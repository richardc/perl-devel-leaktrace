#!perl -w
use strict;
use Test::More tests => 4;

sub output ($) {
    my $code = shift;
    `$^X -MDevel::LeakTrace -e'$code' 2>&1`
}

is( output '1;', '', 'no statements = no leak' );

is( output 'my $foo;', '', 'single scalar = no leak' );

like( output q{
my $foo;
$foo = \$foo;
},
      qr{^leaked SV\(.*?\) from -e line 3
leaked SV\(.*?\) from -e line 3$},
      'leak a reference loop $foo = \$foo' );

like( output q{
my @foo;
$foo[0] = \@foo;
},

      qr{^leaked SV\(.*?\) from -e line 2
leaked RV\(.*?\) from -e line 3
leaked AV\(.*?\) from -e line 3$},
      'leak a reference loop $foo[1] = \@foo' );

