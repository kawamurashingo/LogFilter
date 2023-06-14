use Test::More tests => 5;
use LogFilter;

my $filter = LogFilter->new('test_keywords.txt', 'test_exclude.txt', 'test_log.txt');
ok($filter, 'New instance');

# Start a child process to update the test log periodically
my $pid = fork();
if ($pid == 0) {
    # Child process
    while (1) {
        open my $log, '>>', 'test_log.txt';
        print $log "This is an error line\n";
        print $log "This is a warning line\n";
        print $log "This is an ignore_this_error line\n";
        print $log "This is a normal line\n";
        close $log;
        sleep 1;
    }
    exit;
}

# Run filter method with a timeout
my $output;
eval {
    local $SIG{ALRM} = sub { die "timeout\n" };
    alarm 5; # Set timeout
    {
        local *STDOUT;
        open(STDOUT, '>', \$output) or die "Can't open STDOUT: $!";
        $filter->filter();
    }
    alarm 0;
};

kill 'TERM', $pid; # Terminate child process

# Check if the lines containing keywords (and not excluded) are in the output
like($output, qr/This is an error line/, 'Error line is included');
like($output, qr/This is a warning line/, 'Warning line is included');
unlike($output, qr/This is an ignore_this_error line/, 'Excluded line is not included');
unlike($output, qr/This is a normal line/, 'Normal line is not included');

