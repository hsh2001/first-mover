#!perl
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);

use FirstMover dirname(dirname abs_path $0);

sub isNumber {
  my $value = shift;
  return FirstMover::_isNumber($value);
}

for my $number (
  "2001",
  201,
  3.14,
  15,
  2.7,
  -1,
  -1.2,
  -333333,
) {
  FirstMover
  ->new(
    "check \"$number\" is number",
    sub {
      return isNumber($number);
    }
  )
  ->expectValue(1)
  ->done;
}

print "\n";

for my $notNumber (
  "Hello world",
  "!23",
  " 23",
  "\n23",
  "A23",
  "99a",
  "99 ",
  "99\n",
  "99n",
  "",
  "\n",
) {
  FirstMover
  ->new(
    "check \"$notNumber\" is not a number",
    sub {
      return !isNumber($notNumber);
    }
  )
  ->expectValue(1)
  ->done;
}
