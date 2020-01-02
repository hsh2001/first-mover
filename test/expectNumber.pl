#!perl
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use LWP::UserAgent;
use JSON;

use FirstMover;

my $i = 0;
my @positiveNumbers = (1..30);
my @negativeNumbers = map { -$_ } @positiveNumbers;

for my $number (
  @positiveNumbers,
  @negativeNumbers,
) {
  $i++;
  FirstMover->new(
    "Test 'expectNumber' value $i: \"$number\"",
    sub { return $number; }
  )
  ->expectNumber
  ->done;
}

print "\n";

$i = 0;
for my $positiveNumber (
  @positiveNumbers
) {
  $i++;
  FirstMover->new(
    "Test `expectPositiveNumber` value $i: \"$positiveNumber\"",
    sub { return $positiveNumber; }
  )
  ->expectPositiveNumber
  ->done;
}

print "\n";

$i = 0;
for my $negativeNumber (
  @positiveNumbers
) {
  $i++;
  FirstMover->new(
    "Test `expectNegativeNumber` value $i: \"$negativeNumber\"",
    sub { return $negativeNumber; }
  )
  ->expectNegativeNumber
  ->done;
}
