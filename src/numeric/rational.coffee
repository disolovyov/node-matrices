Number = require './number'

# Rational numeric class.
module.exports = class Rational extends Number
  # Create a new rational number with *num* and *denom* parts.
  constructor: (num, denom = 1) ->
    d = gcd num, denom
    @num = num / d
    @denom = denom / d

  # Find greatest common divisor.
  gcd = (a, b) ->
    while b != 0
      temp = a
      a = b
      b = temp % b
    a

  # Rational zero cached in the class body.
  #
  # **NB!** See the `Complex` class for a discussion on mutability.
  zeroCached =
    new @ 0

  # Rational zero.
  @zero: ->
    zeroCached

  # Rational unit cached in the class body.
  #
  # **NB!** See the `Complex` class for a discussion on mutability.
  unitCached =
    new @ 1

  # Rational unit.
  @unit: ->
    unitCached

  # Rational addition.
  @add: (a, b) ->
    new @ a.num * b.denom + b.num * a.denom, a.denom * b.denom

  # Rational additive inverse.
  @neg: (n) ->
    new @ -n.num, n.denom

  # Rational subtraction.
  @sub: (a, b) ->
    new @ a.num * b.denom - b.num * a.denom, a.denom * b.denom

  # Rational multiplication.
  @mul: (a, b) ->
    new @ a.num * b.num, a.denom * b.denom

  # Rational multiplicative inverse.
  @inv: (n) ->
    new @ n.denom, n.num

  # Rational division.
  @div: (a, b) ->
    new @ a.num * b.denom, a.denom * b.num

  # Rational conjugate.
  @conj: (n) ->
    n

  # Rational squared norm.
  @norm2: (n) ->
    (n.num * n.num) / (n.denom * n.denom)
