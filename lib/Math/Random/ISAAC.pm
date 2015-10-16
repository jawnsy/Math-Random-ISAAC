package Math::Random::ISAAC;
# ABSTRACT: Perl interface to the ISAAC PRNG algorithm

use strict;
use warnings;
use Carp ();

our $DRIVER = 'PP';

# Try to load the XS version first
eval {
  require Math::Random::ISAAC::XS;
  $DRIVER = 'XS';
};

# Fall back on the Perl version
if ($@) {
  require Math::Random::ISAAC::PP;
}

=head1 DESCRIPTION

ISAAC (Indirection, Shift, Accumulate, Add, and Count) is a
L<Cryptographically Secure Pseudorandom Number Generator|
https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator>
(CSPRNG) that quickly produces high-quality random data.  The results are
uniformly distributed, unbiased, and unpredictable unless you know the seed.
Despite this, the algorithm is very fast: on average, it requires only 18.75
processor cycles to generate each 32-bit value.  As a result, ISAAC is
suitable for applications where a significant amount of random data needs to
be produced quickly, such as solving using the Monte Carlo method or for
games.

The algorithm was published by Bob Jenkins in 1996, along with a reference
implementation, and despite the best efforts of many security researchers, no
feasible attacks have been identified to date.  For more information, see the
L<algorithm description|http://burtleburtle.net/bob/rand/isaac.html> and
L<reference implementation|http://burtleburtle.net/bob/rand/isaacafa.html>.

=head2 USAGE WARNING

There was no method supplied to provide the initial seed data by the author.
On his web site, Bob Jenkins writes:

  Seeding a random number generator is essentially the same problem as
  encrypting the seed with a block cipher.

In the same spirit, by default, this module does not seed the algorithm at
all -- it simply fills the state with zeroes -- if no seed is provided.
The idea is to remind users that selecting good seed data for their purpose
is important, and for the module to conveniently set it to something like
C<localtime> behind-the-scenes hurts users in the long run, since they don't
understand the limitations of doing so.

The type of seed you might want to use depends entirely on the purpose of
using this algorithm in your program in the first place. Here are some
possible seeding methods:

=over

=item 1 Math::TrulyRandom

The L<Math::TrulyRandom> module provides a way of obtaining truly random
data by using timing interrupts. This is probably one of the better ways
to seed the algorithm.

=item 2 /dev/random

Using the system random device is, in principle, the best idea, since it
gathers entropy from various sources including interrupt timing, other
device interrupts, etc. However, it's not portable to anything other than
Unix-like platforms, and might not produce good data on some systems.

=item 3 localtime()

This works for basic things like simulations, but results in not-so-random
output, especially if you create new instances quickly (as the seeds would
be the same within per-second resolution).

=item 4 Time::HiRes

In theory, using L<Time::HiRes> is the same as option (2), but you get a
higher resolution time so you're less likely to have the same seed twice.
Note that you need to transform the output into an integer somehow, perhaps
by taking the least significant bits or using a hash function. This would
be less prone to duplicate instances, but it's still not ideal.

=back

=head1 SYNOPSIS

  use Math::Random::ISAAC;

  my $rng = Math::Random::ISAAC->new(@seeds);

  for (0..30) {
    print 'Result: ' . $rng->irand() . "\n";
  }

=head1 PURPOSE

The intent of this module is to provide single simple interface to the two
compatible implementations of this module, namely, L<Math::Random::ISAAC::XS>
and L<Math::Random::ISAAC::PP>.

If, for some reason, you need to determine what version of the module is
actually being included by C<Math::Random::ISAAC>, then:

  print 'Backend type: ', $Math::Random::ISAAC::DRIVER, "\n";

In order to force use of one or the other, simply load the appropriate module:

  use Math::Random::ISAAC::XS;
  my $rng = Math::Random::ISAAC::XS->new();
  # or
  use Math::Random::ISAAC::PP;
  my $rng = Math::Random::ISAAC::PP->new();

=method new

  Math::Random::ISAAC->new( @seeds )

Creates a C<Math::Random::ISAAC> object, based upon either the optimized
C/XS version of the algorithm, L<Math::Random::ISAAC::XS>, or falls back
to the included Pure Perl module, L<Math::Random::ISAAC::PP>.

Example code:

  my $rng = Math::Random::ISAAC->new(time);

This method will return an appropriate B<Math::Random::ISAAC> object or
throw an exception on error.

=cut

# Wrappers around the actual methods
sub new {
  my ($class, @seed) = @_;

  Carp::croak('You must call this as a class method') if ref($class);

  my $self = {
  };

  if ($DRIVER eq 'XS') {
    $self->{backend} = Math::Random::ISAAC::XS->new(@seed);
  }
  else {
    $self->{backend} = Math::Random::ISAAC::PP->new(@seed);
  }

  bless($self, $class);
  return $self;
}

=method rand

  $rng->rand()

Returns a random double-precision floating point number which is normalized
between 0 and 1 (inclusive; it's a closed interval).

Internally, this simply takes the uniformly distributed unsigned integer from
C<$rng-E<gt>irand()> and divides it by C<2**32-1> (maximum unsigned integer
size)

Example code:

  my $next = $rng->rand();

This method will return a double-precision floating point number or throw an
exception on error.

=cut

# This package should have an interface similar to the builtin Perl
# random number routines; these are methods, not functions, so they
# are not problematic
## no critic (ProhibitBuiltinHomonyms)

sub rand {
  my ($self) = @_;

  Carp::croak('You must call this method as an object') unless ref($self);

  return $self->{backend}->rand();
}

=method irand

  $rng->irand()

Returns the next unsigned 32-bit random integer. It will return a value with
a value such that: B<0 E<lt>= x E<lt>= 2**32-1>.

Example code:

  my $next = $rng->irand();

This method will return a 32-bit unsigned integer or throw an exception on
error.

=cut

sub irand {
  my ($self) = @_;

  Carp::croak('You must call this method as an object') unless ref($self);

  return $self->{backend}->irand();
}

=head1 ACKNOWLEDGEMENTS

=over

=item *

Special thanks to Bob Jenkins E<lt>bob_jenkins@burtleburtle.netE<gt> for
devising this very clever algorithm and releasing it into the public domain.

=item *

Thanks to John L. Allen (contact unknown) for providing a Perl port of the
original ISAAC code, upon which C<Math::Random::ISAAC::PP> is heavily based.
His version is available on Bob's web site, in the SEE ALSO section.

=back

=head1 SEE ALSO

=over

=item *

L<Math::Random::ISAAC::XS>, the C/XS optimized version of this module, which
will be used automatically if available.

=item *

L<Bob Jenkins' page about ISAAC|http://burtleburtle.net/bob/rand/isaacafa.html>,
which explains the algorithm as well as potential attacks.

=item *

Jean-Philippe Aumasson, L<On the pseudo-random generator ISAAC|https://eprint.iacr.org/2006/438>.
IACR ePrint Archive, Report 2006/438.  The paper discusses seeds that produce
non-uniform results and introduces a variant called ISAAC+, which uses rotations
(circular shifts) instead of normal shifts to increase diffusion of the internal
state.

=item *

Marina Pudovkina, L<A known plaintext attack on the ISAAC keystream
generator|https://eprint.iacr.org/2001/049>, which proves that the algorithm
is cryptographically secure.  It also provides an estimated time complexity
of B<Tmet = 4.67*10^1240> for recovering the seed given the output.

=back

=head1 CAVEATS

=over

=item *

There is no method that allows re-seeding of algorithms. This is not really
necessary because one can simply call C<new> again with the new seed data
periodically.

But he also provides a simple workaround:

  As ISAAC is intended to be a secure cipher, if you want to reseed it,
  one way is to use some other cipher to seed some initial version of ISAAC,
  then use ISAAC's output as a seed for other instances of ISAAC whenever
  they need to be reseeded.

=item *

There is no way to clone a PRNG instance. I'm not sure why this is might
even be necessary or useful. File a bug report with an explanation why and
I'll consider adding it to the next release.

=back

=cut

1;
