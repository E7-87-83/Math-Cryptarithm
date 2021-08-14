use 5.034000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Math::Cryptarithm',
    VERSION_FROM      => 'lib/Math/Cryptarithm.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Math/Cryptarithm.pm', # retrieve abstract from module
    AUTHOR            => 'e78783 <e78783@tqgtyn10aqxuxoi0mkfbldi5vh.jx.internal.cloudapp.net>',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #https://metacpan.org/pod/Module::Build::API
);
