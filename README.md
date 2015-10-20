Math::Random::ISAAC
===================

[![Travis CI Build Status](https://travis-ci.org/jawnsy/Math-Random-ISAAC.svg?branch=master)](https://travis-ci.org/jawnsy/Math-Random-ISAAC)
[![AppVeyor CI Build Status](https://ci.appveyor.com/api/projects/status/github/jawnsy/Math-Random-ISAAC?branch=master&svg=true)](https://ci.appveyor.com/project/jawnsy/Math-Random-ISAAC)
[![Code Coverage](https://codecov.io/github/jawnsy/Math-Random-ISAAC/coverage.svg?branch=master)](https://codecov.io/github/jawnsy/Math-Random-ISAAC?branch=master)

Introduction
------------

ISAAC (Indirection, Shift, Accumulate, Add, and Count) is a [Cryptographically
Secure Pseudorandom Number Generator](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator)
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
[algorithm description](http://burtleburtle.net/bob/rand/isaac.html) and
[reference implementation](http://burtleburtle.net/bob/rand/isaacafa.html).

Usage
-----

    use Math::Random::ISAAC;

    my $rng = Math::Random::ISAAC->new(@seeds);

    for (0..30) {
      print 'Result: ' . $rng->irand() . "\n";
    }

Copyright and License
---------------------

Anyone is free to copy, modify, publish, use, compile, sell, or distribute
this software, either in source code form or as a compiled binary, for any
purpose, commercial or non-commercial, and by any means.

The author or authors of this software dedicate any and all copyright
interest in the software to the public domain. We make this dedication for
the benefit of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of relinquishment
in perpetuity of all present and future rights to this software under
copyright law.

The software is provided "AS IS", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall
the authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising
from, out of or in connection with the software or the use or other
dealings in the software.

For more details, see `perldoc Math::Random::ISAAC` or [view it online on
MetaCPAN](https://metacpan.org/pod/Math::Random::ISAAC).
