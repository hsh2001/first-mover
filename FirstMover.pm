#!perl
use strict;

package FirstMover;

sub _trim_string {
  my $string = shift;
  $string =~ s/^\s+|\s+$//g;
  return $string;
}

sub new {
  my ($self, $testName, $testCode) = @_;
  $self = bless {}, $self;

  unless ("code" eq lc ref $testCode) {
    die "Second argument is not a CODE in test:$testName\n";
  }

  $self->{name} = $testName;
  $self->{code} = $testCode;
  $self->{error} = 0;
  $self->{isSuccess} = eval {
    $self->{result} = $testCode->();
  };

  if ($@) {
    $self->{errorMessage} = $@;
    $self->{error} = 1;
  }

  return $self;
}

sub expectValue {
  my ($self, $value) = @_;
  my $testName = $self->{name};
  my $result = $self->{result};
  unless ($result eq $value) {
    warn "The result is $result even though $value was expected in test:'$testName'.\n";
  }
  return $self;
}

sub expectRef {
  my ($self, $ref) = @_;
  my $testName = $self->{name};
  my $result = $self->{result};
  my $resultRef = lc(ref $result);
  $ref = lc($ref);
  unless ($resultRef eq $ref) {
    warn "The reference of result is B even though A was expected for reference in test:'$testName'.\n";
  }
  return $self;
}

return 1;
