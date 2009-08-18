#!/usr/bin/perl -T

# t/05fallback.t
#  Tests use of the Pure Perl interface
#
# $Id$

use strict;
use warnings;

use Test::More;

# Cannot 'use' because we might skip tests
require Test::NoWarnings;

eval {
  require Test::Without::Module;
};
if ($@) {
  plan skip_all => 'Test::Without::Module required to test fallback ability';
}

plan tests => 7;

# Delay loading of test hooks
Test::NoWarnings->import();

# Hide the XS version
Test::Without::Module->import('Math::Random::ISAAC::XS');

# Try to load Math::Random::ISAAC
eval {
  require Math::Random::ISAAC;
  Math::Random::ISAAC->import();
};
ok(!$@, 'Math::Random::ISAAC interface compiled and loaded');

my $rng = Math::Random::ISAAC->new();
isa_ok($rng, 'Math::Random::ISAAC');

ok(defined $Math::Random::ISAAC::DRIVER, 'The DRIVER is defined');
ok($Math::Random::ISAAC::DRIVER eq 'PP', 'The Pure Perl port is loaded');
ok($rng->irand() > 0, 'Generate first integer in sequence');
ok($rng->rand()  > 0, 'Generate second number in sequence');
