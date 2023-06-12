# LogFilter

## Description

LogFilter is a simple Perl module to filter log files. It reads a keywords file and an exclude file, and then prints lines from the log file that match any of the keywords and do not match any of the exclude phrases.

## Usage

Here is a basic usage example:

```perl
use LogFilter;

my $filter = LogFilter->new('keywords.txt', 'exclude.txt', '/var/log/syslog');
$filter->filter();
```

In this example, keywords.txt is a file with one keyword per line. These are the phrases that we are interested in. exclude.txt is similar, but it contains phrases that we want to exclude from the output. /var/log/syslog is the log file that we want to filter.

## Installation

To install this module, run the following commands:

```bash

perl Makefile.PL
make
make test
make install
```

## Author

Kawamura Shingo (pannakoota@gmail.com)

## License

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.28.1 or, at your option, any later version of Perl 5 you may have available.
