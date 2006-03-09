#include "common.h"
#include "tools.h"

/* TODO: Currently we scan all the variables every time runops changes
 * state and build a complete new hash. We need to a) only
 * stash the location of object's creation and subtract out the dead
 * objects only at the last stage and b) find a way of detecting
 * variable creation that doesn't involve scanning them all every time
 * we change state. Is pool size/existence a reliable indicator? Also
 * need to fix the numerous memory leaks within this code - nothing is
 * /ever/ freed.
 */

MODULE = Devel::LeakTrace PACKAGE = Devel::LeakTrace

PROTOTYPES: ENABLE

void
hook_runops()
PPCODE:
{
    tools_hook_runops();
}

void
reset_counters()
PPCODE:
{
    tools_reset_counters();
}

void
show_used()
CODE:
{
    tools_show_used();
}
