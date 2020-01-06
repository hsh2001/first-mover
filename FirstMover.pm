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
    1;
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

sub _expect {
  my ($self, $errorMessage, $code) = @_;
  my ($result, $testName) = map {$self->{$_}} (
    'result', 'name',
  );

  return $self unless $self->{isSuccess};

  unless ("code" eq lc ref $code) {
    die _getWarnMessage "Second argument is not a CODE in test:$testName";
  }

  unless ($code->($result)) {
    $self->{isTestFail} = 1;
    warn _getWarnMessage $errorMessage;
  }

  return $self;
}

sub expectValue {
  my ($self, $value) = @_;
  my ($result, $testName) = map {$self->{$_}} (
    'result', 'name',
  );
  my $errorMessage = "The result is $result even though $value was expected in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    return $value eq shift;
  });
}

sub expectRef {
  my ($self, $ref) = @_;
  my ($result, $testName) = map {$self->{$_}} (
    'result', 'name',
  );
  my $errorMessage =
    "The reference of result is "
    .uc(ref $result)
    ." even though "
    .uc($ref)
    ." was expected for reference in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    return lc(ref shift) eq lc($ref);
  });
}

sub expectArrayRef {
  my $self = shift;
  return $self->expectRef("array");
}

sub expectHashRef {
  my $self = shift;
  return $self->expectRef("hash");
}

sub expectNumber {
  my $self = shift;
  my ($testName) = map {$self->{$_}} (
    'name',
  );
  my $errorMessage = "The result is not a number even though number was expected in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    return _isNumber shift;
  });
}

sub expectPositiveNumber {
  my $self = shift;
  my ($testName) = map {$self->{$_}} (
    'name',
  );
  my $errorMessage = "The result is not a positive number even though positive number was expected in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    my $data = shift;
    return _isNumber($data) && $data > 0;
  });
}

sub expectNegativeNumber {
  my $self = shift;
  my ($testName) = map {$self->{$_}} (
    'name',
  );
  my $errorMessage = "The result is not a nagative number even though nagative number was expected in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    my $data = shift;
    return _isNumber($data) && $data > 0;
  });
}

sub expectFalsy {
  my $self = shift;
  my ($testName) = map {$self->{$_}} (
    'name',
  );
  my $errorMessage = "The result is truthy value even though falsy value was expected in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    return !shift;
  });
}

sub expectTruthy {
  my $self = shift;
  my ($testName) = map {$self->{$_}} (
    'name',
  );
  my $errorMessage = "The result is falsy value even though truthy value was expected in test:'$testName'.";
  return $self->_expect($errorMessage, sub {
    return shift;
  });
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
