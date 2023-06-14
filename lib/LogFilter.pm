package LogFilter;

use strict;
use warnings;

our $VERSION = '0.06'; # Incremented version number

use File::Tail;
use IO::File;

sub new {
    my ($class, $keywords_file, $exclude_file, $log_file) = @_;

    my @keywords;
    my @exclude;

    # Open and read keywords file
    my $fh = IO::File->new($keywords_file, 'r');
    if (defined $fh) {
        while (my $keyword = $fh->getline) {
            chomp $keyword;
            push @keywords, $keyword;
        }
        $fh->close;
    } else {
        die "Could not open file '$keywords_file': $!";
    }

    # Open and read exclude file
    $fh = IO::File->new($exclude_file, 'r');
    if (defined $fh) {
        while (my $exclude = $fh->getline) {
            chomp $exclude;
            push @exclude, $exclude;
        }
        $fh->close;
    } else {
        die "Could not open file '$exclude_file': $!";
    }

    my $self = {
        keywords_regex => join('|', map { "(?:$_)" } @keywords),
        exclude_regex => join('|', map { "(?:$_)" } @exclude),
        log_file => $log_file,
    };

    return bless $self, $class;
}

sub filter {
    my ($self) = @_;

    my $file = File::Tail->new($self->{log_file});
    while (defined(my $line = $file->read)) {
        if ($line =~ /$self->{keywords_regex}/ && $line !~ /$self->{exclude_regex}/) {
            print $line;
        }
    }
}

=head1 NAME

LogFilter - A simple log filter

=head1 SYNOPSIS

    use LogFilter;

    my $filter = LogFilter->new('keywords.txt', 'exclude.txt', '/var/log/syslog');
    $filter->filter();

=head1 DESCRIPTION

This module provides a simple way to filter log files. It takes as input a keywords file, an exclude file and the log file to be filtered.

=head1 METHODS

=over

=item new($keywords_file, $exclude_file, $log_file)

The constructor. It takes three arguments: the keywords file, the exclude file, and the log file. It returns a new instance of LogFilter.

=item filter()

This method filters the log file, printing lines that match any of the keywords and do not match any of the exclude phrases.

=back

=head1 AUTHOR

Kawamura Shingo <pannakoota@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Kawamura Shingo 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.28.1 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;

