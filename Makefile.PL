use ExtUtils::MakeMaker;
WriteMakefile( NAME => "Devel::LeakTrace",
               VERSION_FROM => "LeakTrace.pm",
	       PREREQ_PM => {"Test::More" => 0},
               INC => `glib-config --cflags`,
               LIBS => `glib-config --libs`,
             );
