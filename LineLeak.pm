package Devel::LineLeak;
use strict;
require 5.006;
use base 'DynaLoader';

INIT {
    our $VERSION = 0.01;
    bootstrap Devel::LineLeak $VERSION;
    start_up();
}

END {
    show_used();
}

1;

__END__

=head1 NAME

Devel::LineLeak - indicate where leaked variables are coming from.

=head1 SYNOPSIS

  perl -MDevel::LineLeak -e '{ my $foo; $foo = \$foo }'
  leaked SV(0x528d0) from -e line 1
  leaked SV(0x116a10) from -e line 1

=head1 DESCRIPTION

Based heavily on Devel::Leak, Devel::LineLeak uses the pluggable
runops feature found in perl 5.6 and later in order to trace SV
allocations of a running program.

At END time Devel::LineLeak identifies any remaining variables, and
reports on the lines in which the came into existence.

Note that by default state is first recorded during the INIT phase.
As such the module will not pay attention to any scalars created
during BEGIN time.  This is intentional as symbol table aliasing is
never released before the END times and this is most common in the
implicit BEGIN blocks of C<use> statements.

=head1 TODO

Better docs

Probably stack backtracing, and clustering of reports if they're from
a similar stack frame.

=head1 AUTHOR

Richard Clamp <richardc@unixbeard.net>

=head1 SEE ALSO

L<Devel::Leak>, L<Devel::Cover>

=cut
