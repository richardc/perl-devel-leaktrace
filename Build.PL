use strict;
use Module::Build;

my $build = Module::Build->new(
    module_name  => "Devel::LeakTrace",
    dynamic_config => 1,
    license      => 'perl',
    requires     => {
        'Test::More' => 0,
    },
    extra_compiler_flags => `glib-config --cflags`,
    extra_linker_flags   => `glib-config --libs`,
   );

$build->create_build_script;
