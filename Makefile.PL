use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'LogFilter',
    VERSION_FROM     => 'lib/LogFilter.pm',
    ABSTRACT         => 'A simple log filter',
    AUTHOR           => 'Kawamura Shingo <pannakoota@gmail.com>',
    LICENSE          => 'artistic_2',
    PREREQ_PM           => {
        'perl'          => '5.028',
        'File::Tail'    => 0,
        'IO::File'      => 0,
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
     ? ('LICENSE'=> 'perl')
     : ()
    ),
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/kawamurashingo/LogFilter.git',
                web  => 'https://github.com/kawamurashingo/LogFilter.git',
            },
        },
    },
    'File::ShareDir::Install' => '0.06',
    'ShareDir' => 'share',
);

