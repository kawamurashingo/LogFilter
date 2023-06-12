use Test::More tests => 3;
use LogFilter;

my $filter = LogFilter->new('test_keywords.txt', 'test_exclude.txt', 'test_log.txt');
ok($filter, 'New instance');

# Redirect stdout to a scalar
my $output;
{
    local *STDOUT;
    open(STDOUT, '>', \$output) or die "Can't open STDOUT: $!";
    $filter->filter();
}

# Check if the lines containing keywords (and not excluded) are in the output
like($output, qr/This is an error line/, 'Error line is included');
like($output, qr/This is a warning line/, 'Warning line is included');
unlike($output, qr/This is an ignore_this_error line/, 'Excluded line is not included');
unlike($output, qr/This is a normal line/, 'Normal line is not included');
