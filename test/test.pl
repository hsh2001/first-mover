#!perl
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use FirstMover dirname(dirname abs_path $0);

sub add {
  return @_[0] + @_[1];
}

FirstMover
->new("Test add", sub {
  return add(1, 3);
})
->expectValue(4) # correct
->expectValue(5) # warnings!
->expectValue(6) # warnings!
;
