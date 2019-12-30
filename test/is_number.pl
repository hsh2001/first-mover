#!perl
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);

use FirstMover dirname(dirname abs_path $0);

sub _is_number {
  my $value = shift;
  return FirstMover::_is_number($value);
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
    "check $number is number",
    sub {
      return _is_number($number);
    }
  )
  ->expectValue(1);
}

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
    "check $notNumber is not a number",
    sub {
      return !_is_number($notNumber);
    }
  )
  ->expectValue(1);
}
