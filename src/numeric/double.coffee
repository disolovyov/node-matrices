Number = require './number'

# Double numeric class.
module.exports = class Double extends Number
  # Wrap a double in this class.
  constructor: (n) ->
    @n = n

  # Double zero.
  @zero: 0

  # Double unit.
  @unit: 1

  # Double addition.
  @add: (a, b) ->
    a + b

  # Double additive inverse.
  @neg: (n) ->
    -n

  # Double subtraction.
  @sub: (a, b) ->
    a - b

  # Double multiplication.
  @mul: (a, b) ->
    a * b

  # Double multiplicative inverse.
  @inv: (n) ->
    1 / n

  # Double division.
  @div: (a, b) ->
    a / b

  # Double conjugate.
  @conj: (n) ->
    n

  # Double absolute value.
  @abs: (n) ->
    Math.abs n

  # Double squared norm.
  @norm2: (n) ->
    n * n

  # Equality measure.
  @eq: (a, b) ->
    a is b

  # Instance methods for doubles are overriden to have return values
  # wrapped in new instance of `Double`. This is needed, since doubles
  # present a special case of `Number`, where static method results
  # are returned as scalars.
  #
  # For a discussion on the differences between using static methods
  # and method chaining, see the `Number` class.
  add: (other) -> new @constructor @constructor.add(@n, other.n)
  neg: -> new @constructor @constructor.neg(@n)
  sub: (other) -> new @constructor @constructor.sub(@n, other.n)
  mul: (other) -> new @constructor @constructor.mul(@n, other.n)
  inv: -> new @constructor @constructor.inv(@n)
  div: (other) -> new @constructor @constructor.div(@n, other.n)
  conj: -> new @constructor @constructor.conj(@n)
  abs: -> new @constructor @constructor.abs(@n)
  norm2: -> new @constructor @constructor.norm2(@n)
  eq: (other) -> new @constructor @constructor.eq(@n, other.n)
