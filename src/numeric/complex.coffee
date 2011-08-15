Number = require './number'

# Complex numeric class.
module.exports = class Complex extends Number
  # Create a new complex number with *re* and *im* parts.
  constructor: (re, im) ->
    @re = re
    @im = im

  # Complex zero cached in the class body.
  #
  # **NB!** Speeds things up, but all hell breaks loose if someone
  # modifies this object. A good practice is to pretend that
  # complex number objects are immutable.
  #
  # Note that Object.freeze is not a solution right now, since this code
  # is used in the browser as well.
  zeroCached =
    new @ 0, 0

  # Complex zero.
  @zero: ->
    zeroCached

  # Complex unit cached in the class body.
  #
  # **NB!** Same problem as with cached zeroes.
  unitCached =
    new @ 1, 0

  # Complex unit.
  @unit: ->
    unitCached

  # Complex addition.
  @add: (a, b) ->
    new @ a.re + b.re, a.im + b.im

  # Complex additive inverse.
  @neg: (n) ->
    new @ -n.re, -n.im

  # Complex subtraction.
  @sub: (a, b) ->
    new @ a.re - b.re, a.im - b.im

  # Complex multiplication.
  @mul: (a, b) ->
    new @ a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re

  # Complex multiplicative inverse.
  @inv: (n) ->
    norm2 = @norm2 n
    new @ n.re / norm2, -n.im / norm2

  # Complex conjugate.
  @conj: (n) ->
    new @ n.re, -n.im

  # Complex squared norm.
  @norm2: (n) ->
    n.re * n.re + n.im * n.im
