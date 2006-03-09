/* list.c */

#include "common.h"
#include "list.h"

#define list_SORTED		(1 << 0)

int list_append(list *l, const list_ITY p) {
	l->flags &= ~list_SORTED;
	return buffer_append(l, &p, sizeof(p));
}

#if 0
/* Return the location of the first difference between two lists
 * scanning from the end. The value returned is the offset from
 * the end of each list (i.e. -1 .. -(list size)) of the first
 * difference or 0 if the lists are the same.
 */
long list_cmp(const list *a, const list *b) {
	/* Make a be the shorter list */
	if (list_used(a) > list_used(b)) {
		const list *t = a;
		a = b;
		b = t;
	}
	
	long sza = (long) list_used(a);
	long szb = (long) list_used(b);
	list_ITY *pa = list_ar(a);
	list_ITY *pb = list_ar(b);
	
	while (sza > 0) {
		sza--;
		szb--;
		if (pa[sza] != pb[szb]) {
			return sza - list_used(a);
		}
	}
	
	return (szb == 0) ? 0 : (szb - list_used(b));
}

static void list_walk(const list *l, long start, 
	   	              const void *p, list_callback cb) {
	if (start != 0) {
		long pos  = (long) list_used(l) + start;
		list_ITY *ar = list_ar(l);
		while (pos >= 0) {
			cb((list_ITY) ar[pos--], p);
		}
	}
}

void list_diff(const list *a, const list *b, const void *p,
			   list_callback added, list_callback removed) {
	long cmp = list_cmp(a, b);
	if (0 != cmp) {
		if (added) {
			list_walk(b, cmp, p, added);
		}
		if (removed) {
			list_walk(a, cmp, p, removed);
		}
	}
}
#endif

int list_build(list *l, const list_ITY v, size_t sz) {
	int err;

	if (err = list_init(l, sz), ERR_None != err) {
		return err;
	}

	for (; v; v = list_NEXT(v)) {
		if (err = list_append(l, v), ERR_None != err) {
			return err;
		}
	}
	
	return ERR_None;
}

static int list_compare(const void *a, const void *b) {
	return list_CMP(a, b);
}

void list_sort(list *l) {
	if ((l->flags & list_SORTED) == 0) {
		qsort(l->buf, list_used(l), list_ISZ, list_compare);
		l->flags |= list_SORTED;
	}
}

long list_true_diff(list *a, list *b, const void *p,
			        list_callback added, list_callback removed) {
	list_ITY *a_ar;
	list_ITY *b_ar;
	long a_p, b_p, diff;
	size_t a_sz, b_sz;

	list_sort(a);
	list_sort(b);
	
	a_ar = list_ar(a); a_sz = list_used(a); a_p = 0;
	b_ar = list_ar(b); b_sz = list_used(b); b_p = 0;
	diff = 0;
		
	while (a_p < a_sz || b_p < b_sz) {
		while (a_p < a_sz &&
		       (b_p == b_sz ||
		        list_CMP(&b_ar[b_p], &a_ar[a_p]) > 0)) {
			if (removed) {
				removed(a_ar[a_p], p);
			}
			a_p++;
			diff++;
		}
		while (b_p < b_sz &&
		       (a_p == a_sz ||
		        list_CMP(&a_ar[a_p], &b_ar[b_p]) > 0)) {
			if (added) {
				added(b_ar[b_p], p);
			}
			b_p++;
			diff++;
		}
		while (a_p < a_sz && b_p < b_sz &&
		       list_CMP(&a_ar[a_p], &b_ar[b_p]) == 0) {
			a_p++;
			b_p++;
		}
	}
	
	return diff;
}
