#!perl
use strict;

# Repository: https://github.com/hsh2001/first-mover
# Issue: https://github.com/hsh2001/first-mover
# Author: https://github.com/hsh2001
# License: MIT License

use Term::ANSIColor;

package FirstMover;

sub _trimString {
  my $string = shift;
  $string =~ s/^\s+|\s+$//g;
  return $string;
}

sub _addColorString {
  my ($color, $string) = @_;
  return Term::ANSIColor::color($color)
        .$string
        .Term::ANSIColor::color("reset");
}

sub _getWarnMessage {
  return _addColorString("red", shift)."\n";
}

sub _getSuccessMessage {
  return _addColorString("green", shift)."\n";
}

sub _isNumber {
  my $value = shift;
  $value = "$value";
  return 0 if $value =~ /\s/g;
  return $value =~ /^(-?\d+\.\d+)$|^(-?\d+)$/gm;
}

sub new {
  my ($self, $testName, $testCode) = @_;
  $self = bless {}, $self;

  unless ("code" eq lc ref $testCode) {
    die _getWarnMessage "Second argument is not a CODE in test:$testName";
  }

  $testName =~ s/\n/\\n/g;
  $self->{name} = $testName;
  $self->{code} = $testCode;
  $self->{error} = 0;
  $self->{isSuccess} = eval {
    $self->{result} = $testCode->();
  };

  if ($@) {
    $self->{errorMessage} = $@;
    $self->{error} = 1;
    warn _getWarnMessage(
      "Warning while execute: \""
      ._trimString($@)
      ."\" at test: $testName"
    );
  }

  return $self;
}

sub expectValue {
  my ($self, $value) = @_;
  my $testName = $self->{name};
  my $result = $self->{result};
  return $self unless $self->{isSuccess};
  unless ($result eq $value) {
    $self->{isTestFail} = 1;
    warn _getWarnMessage "The result is $result even though $value was expected in test:'$testName'.";
  }
  return $self;
}

sub expectRef {
  my ($self, $ref) = @_;
  my $testName = $self->{name};
  my $result = $self->{result};
  my $resultRef = lc(ref $result);
  $ref = lc($ref);
  return $self unless $self->{isSuccess};
  unless ($resultRef eq $ref) {
    $self->{isTestFail} = 1;
    warn _getWarnMessage(
      "The reference of result is "
      .uc($resultRef)
      ." even though "
      .uc($ref)
      ." was expected for reference in test:'$testName'."
    );
  }
  return $self;
}

sub expectNumber {
  my $self = shift;
  my $testName = $self->{name};
  my $result = $self->{result};
  return $self unless $self->{isSuccess};
  unless (_isNumber $result) {
    $self->{isTestFail} = 1;
    warn _getWarnMessage(
      "The result is not a number even though number was expected in test:'$testName'."
    );
  }
  return $self;
}

sub done {
  my $self = shift;
  my $testName = $self->{name};
  my $isTestFail = $self->{isTestFail};
  return $self unless $self->{isSuccess};
  unless ($isTestFail) {
    print _getSuccessMessage(
      "Suceess test: '$testName'"
    );
  }
  return $self;
}


return 1;
