#!perl -w
use strict;
use Test::More tests => 11;

sub output ($) {
    my $code = shift;
    `$^X -MDevel::LeakTrace -e'$code' 2>&1`
}

is( output '1;', '', 'no statements = no leak' );

is( output 'my $foo;', '', 'single scalar = no leak' );

local $_ = output q{
my $foo;
$foo = \$foo;
};

ok( $_, 'leak a reference loop $foo = \$foo' );
ok( s/^leaked SV\(.*?\) from -e line 3$//m, 'one SV');
ok( s/^leaked SV\(.*?\) from -e line 3$//m, 'another SV');
ok( m/^\n*$/,                               "and that's all" );

$_ = output q{
my @foo;
$foo[0] = \@foo;
};

#print $_;
ok( $_, 'leak a reference loop $foo[1] = \@foo' );
if ($] < 5.008001) { # HACK
    ok( s/^leaked SV\(.*?\) from -e line 2$//m, 'one SV');
}
else {
    ok( s/^leaked SV\(.*?\) from -e line 3$//m, 'one SV');
}
ok( s/^leaked AV\(.*?\) from -e line 3$//m, 'one AV');
ok( s/^leaked RV\(.*?\) from -e line 3$//m, 'one RV');
ok( m/^\n*$/,                               "and that's all" );

# programatic interface
use Data::Dumper;
use Devel::Peek;
use Devel::LeakTrace;
$Devel::LeakTrace::quiet = 1;

Devel::LeakTrace::reset_counters();
my $x = [ 'fish' ];
my @used = Devel::LeakTrace::used();
print Dumper \@used;

# hmm, 2 arrays?
for my $used (@used) {
    print "$used->{leaked}\n";
    Dump $used->{leaked};
}

