# Abstract number class.
module.exports = class Number
  # Algebraic zero.
  @zero: null

  # Algebraic unit.
  @unit: null

  # Algebraic addition.
  @add: (a, b) ->
    throw new Error 'Not implemented'

  # Algebraic additive inverse.
  @neg: (n) ->
    throw new Error 'Not implemented'

  # Algebraic subtraction.
  @sub: (a, b) ->
    @add(a, @neg(b))

  # Algebraic multiplication.
  @mul: (a, b) ->
    throw new Error 'Not implemented'

  # Algebraic multiplicative inverse.
  @inv: (n) ->
    throw new Error 'Not implemented'

  # Algebraic division.
  @div: (a, b) ->
    @mul(a, @inv(b))

  # Algebraic conjugate.
  @conj: (n) ->
    throw new Error 'Not implemented'

  # Algebraic absolute value.
  @abs: (n) ->
    Math.sqrt @norm2(n)

  # Algebraic squared norm.
  @norm2: (n) ->
    throw new Error 'Not implemented'

  # Instance methods that wrap around static methods.
  # These are more convenient for one-line calculations.
  #
  # For example, compare:
  #
  #     Number.mul(Number.div(a, b), c) # static methods
  #     a.div(b).mul(c)                 # chaining
  #
  # However, static methods can be used with a provider pattern.
  #
  #     calcWith = (provider) ->
  #       one = provider.identity()
  #       two = provider.add(one, one)
  #     calcWith Complex
  #     calcWith Rational
  #
  # Both these approaches should be orthogonal.
  # Choose one that best fits the problem and stick with it.
  add: (other) -> @constructor.add @, other
  neg: -> @constructor.neg @
  sub: (other) -> @constructor.sub @, other
  mul: (other) -> @constructor.mul @, other
  inv: -> @constructor.inv @
  div: (other) -> @constructor.div @, other
  conj: -> @constructor.conj @
  abs: -> @constructor.abs @
  norm2: -> @constructor.norm2 @
