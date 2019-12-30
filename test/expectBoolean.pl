#!perl
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use LWP::UserAgent;
use JSON;

use FirstMover dirname(dirname abs_path $0);

my $i = 0;

for my $truthyValue (
  "Hello world",
  "00",
  "\n0",
  "true",
  "false",
) {
  $i++;
  FirstMover->new(
    "Test truthy value $i: \"$truthyValue\"",
    sub { return $truthyValue; }
  )
  ->expectTruthy
  ->done;
}

print "\n";

$i = 0;
for my $falsyValue (
  "",
  0,
  "0",
) {
  $i++;
  FirstMover->new(
    "Test falsy value $i: \"$falsyValue\"",
    sub { return $falsyValue; }
  )
  ->expectFalsy
  ->done;
}
