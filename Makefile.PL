use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Tie::Tools',
    'VERSION_FROM' => 'lib/Tie/Func.pm', # finds $VERSION
    'PREREQ_PM' => {'Tie::Cache' => 0.08},
);
