use ExtUtils::MakeMaker;
WriteMakefile( NAME => "Devel::LineLeak",
               VERSION_FROM => "LineLeak.pm",
	       PREREQ_PM => {"Test::More" => 0},
               INC => `glib-config --cflags`,
               LIBS => `glib-config --libs`,
             );
