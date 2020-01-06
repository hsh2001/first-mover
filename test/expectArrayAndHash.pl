#!perl
use strict;
use FirstMover;

FirstMover
->new(
  "Check array",
  sub {
    return [];
  }
)
->expectArrayRef
->done;

FirstMover
->new(
  "Check hash",
  sub {
    return {};
  }
)
->expectHashRef
->done;
