use Test::More tests => 7;
use LogFilter;
use File::Spec;

my ($vol, $dir, $file) = File::Spec->splitpath(__FILE__);
my $test_data_dir = File::Spec->catdir($dir);

my $keywords_file = File::Spec->catfile($test_data_dir, 'test_keywords.txt');
my $exclude_file = File::Spec->catfile($test_data_dir, 'test_exclude.txt');
my $log_file = File::Spec->catfile($test_data_dir, 'test_log.txt');

my $filter = LogFilter->new($keywords_file, $exclude_file, $log_file);
ok($filter, 'New instance');
is($filter->{keywords_file}, $keywords_file, 'Check keywords_file path');
is($filter->{exclude_file}, $exclude_file, 'Check exclude_file path');
is($filter->{log_file}, $log_file, 'Check log_file path');

my @lines = ();
open(my $fh, '<', $log_file) or die "Could not open file '$log_file' $!";
while (my $row = <$fh>) {
  chomp $row;
  push @lines, $row;
}
close $fh;

like($lines[0], qr/This is an error line/, 'Error line is included in log file');
like($lines[1], qr/This is a warning line/, 'Warning line is included in log file');
unlike($lines[2], qr/This is an ignore_this_error line/, 'Excluded line is not included in log file');
unlike($lines[3], qr/This is a normal line/, 'Normal line is not included in log file');

