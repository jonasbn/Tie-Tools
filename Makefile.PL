use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
#
# $Id: Makefile.PL,v 1.2 2003/12/08 20:51:09 jonasbn Exp $

WriteMakefile(
    'NAME'	 => 'Tie::Tools',
    'VERSION_FROM'  => 'lib/Tie/Tools.pm', # finds $VERSION
    'PREREQ_PM' => {
                'Tie::Cache'               => 0.08,
    }
);
