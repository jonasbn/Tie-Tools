use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
#
# $Id: Makefile.PL 1046 2003-12-08 20:51:09Z jonasbn $

WriteMakefile(
    'NAME'	 => 'Tie::Tools',
    'VERSION_FROM'  => 'lib/Tie/Tools.pm', # finds $VERSION
    'PREREQ_PM' => {
                'Tie::Cache'               => 0.08,
    }
);
