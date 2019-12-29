#!perl
use strict;

# Repository: https://github.com/hsh2001/first-mover
# Issue: https://github.com/hsh2001/first-mover
# Author: https://github.com/hsh2001
# License: MIT License

use Term::ANSIColor;

package FirstMover;

sub _trim_string {
  my $string = shift;
  $string =~ s/^\s+|\s+$//g;
  return $string;
}

sub _add_color_string {
  my ($color, $string) = @_;
  return Term::ANSIColor::color($color)
        .$string
        .Term::ANSIColor::color("reset");
}

sub _get_warn_message {
  return _add_color_string("red", shift);
}

sub _get_success_message {
  return _add_color_string("green", shift);
}

sub new {
  my ($self, $testName, $testCode) = @_;
  $self = bless {}, $self;

  unless ("code" eq lc ref $testCode) {
    die _get_warn_message "Second argument is not a CODE in test:$testName\n";
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
    warn _get_warn_message "The result is $result even though $value was expected in test:'$testName'.\n";
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
    warn _get_warn_message(
      "The reference of result is "
      .uc($resultRef)
      ." even though "
      .uc($ref)
      ." was expected for reference in test:'$testName'.\n"
    );
  }
  return $self;
}

return 1;
