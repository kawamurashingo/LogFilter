package LogFilter;

use strict;
use warnings;

our $VERSION = '0.10'; # Incremented version number

use File::Tail;
use IO::File;

sub new {
    my ($class, $keywords_file, $exclude_file, $log_file, $interval) = @_;

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
        interval => $interval || 1, # default interval is 1 second
    };

    return bless $self, $class;
}

sub filter {
    my ($self) = @_;

    my $file = File::Tail->new(name=>$self->{log_file}, interval=>$self->{interval});
    while (defined(my $line = $file->read)) {
        if ($line =~ /$self->{keywords_regex}/ && $line !~ /$self->{exclude_regex}/) {
            print $line;
        }
    }
}

1;

=head1 NAME

LogFilter - Filter logs based on keywords and exclusion patterns

=head1 VERSION

Version 0.10

=head1 SYNOPSIS

    use LogFilter;

    my $filter = LogFilter->new($keywords_file, $exclude_file, $log_file, $interval);

    $filter->filter;

=head1 DESCRIPTION

LogFilter is a module for filtering log files based on keywords and exclusion patterns. It reads the log file line by line and if a line matches any keyword but does not match any exclusion pattern, it is printed to the console.

=head1 METHODS

=head2 new

    my $filter = LogFilter->new($keywords_file, $exclude_file, $log_file, $interval);

Creates a new LogFilter object. Takes four arguments:

=over 4

=item * A file containing keywords, one per line

=item * A file containing exclusion patterns, one per line

=item * The log file to be filtered

=item * The interval (in seconds) at which the log file should be read. Default is 1 if not specified.

=back

=head2 filter

    $filter->filter;

Starts the filtering process. Reads the log file at the specified interval and prints lines that match any keyword and do not match any exclusion pattern.

=head1 AUTHOR

Kawamura Shingo, C<< pannakoota@gmail.com >>

=head1 LICENSE AND COPYRIGHT

Copyright 2023 Kawamura Shingo.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

