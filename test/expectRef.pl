#!perl
use strict;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use LWP::UserAgent;
use JSON;

use FirstMover dirname(dirname abs_path $0);

my $json = JSON->new;
my $userAgent = LWP::UserAgent->new;
my $baseURL = "https://hsh2001.github.io/first-mover";

sub getJSON {
  my $requestURL = shift;
  my $response = $userAgent->get($requestURL);
  die "Response fail!" unless $response->is_success;
  return $json->decode($response->content);
}

FirstMover->new(
  # will suceess
  "Test HTTP request 1",
  sub {
    return getJSON "$baseURL/json/hash.json";
  }
)
->expectRef("HASH")
->done;

FirstMover->new(
  # will fail
  "Test HTTP request 2",
  sub {
    #Invalid URL
    return getJSON "$baseURL/jsonn/hash.json";
  }
)
->expectRef("HASH")
->done;

FirstMover->new(
  # will suceess
  "Test HTTP request 3",
  sub {
    return getJSON "$baseURL/json/empty_array.json";
  }
)
->expectRef("ARRAY")
->done;

FirstMover->new(
  # will fail
  "Test HTTP request 4",
  sub {
    #Invalid URL
    return getJSON "$baseURL/jsonn/empty_array.json";
  }
)
->expectRef("ARRAY")
->done;
