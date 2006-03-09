package Devel::LeakTrace;
use strict;
require 5.006;
use base 'DynaLoader';

BEGIN {
    our $VERSION = 0.05;
    bootstrap Devel::LeakTrace $VERSION;
    hook_runops();
}

my $i_care;
INIT {
    reset_counters();
    $i_care = 1;
}

END {
    show_used() if $i_care;
}

1;

__END__

=head1 NAME

Devel::LeakTrace - indicate where leaked variables are coming from.

=head1 SYNOPSIS

  perl -MDevel::LeakTrace -e '{ my $foo; $foo = \$foo }'
  leaked SV(0x528d0) from -e line 1
  leaked SV(0x116a10) from -e line 1

=head1 DESCRIPTION

Based heavily on Devel::Leak, Devel::LeakTrace uses the pluggable
runops feature found in perl 5.6 and later in order to trace SV
allocations of a running program.

At END time Devel::LeakTrace identifies any remaining variables, and
reports on the lines in which the came into existence.

Note that by default state is first recorded during the INIT phase.
As such the module will not pay attention to any scalars created
during BEGIN time.  This is intentional as symbol table aliasing is
never released before the END times and this is most common in the
implicit BEGIN blocks of C<use> statements.

=head1 TODO

Improve the documentation.

Clustering of reports if they're from the same line.

Stack backtraces to suspect lines.

=head1 AUTHOR

Richard Clamp <richardc@unixbeard.net> with portions of LeakTrace.xs
taken from Nick Ing-Simmons' Devel::Leak module.

=head1 COPYRIGHT

Copyright (C) 2002 Richard Clamp. All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<Devel::Leak>, L<Devel::Cover>

=cut
