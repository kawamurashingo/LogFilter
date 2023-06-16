# LogFilter

## Description

LogFilter is a simple Perl module to filter log files. It reads a keywords file and an exclude file, and then prints lines from the log file that match any of the keywords and do not match any of the exclude phrases.

## Usage

Here is a basic usage example:

```perl
use LogFilter;

my $filter = LogFilter->new($keywords_file, $exclude_file, $log_file, $interval);
$filter->filter();
```

The new function takes four arguments:

1. A file containing keywords, one per line.
2. A file containing exclusion patterns, one per line.
3. The log file to be filtered.
4. The interval (in seconds) at which the log file should be read.

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
