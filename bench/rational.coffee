Double = require '../src/numeric/double'
Rational = require '../src/numeric/rational'

module.exports.compare =

  # Native doubles, serial.
  'native serial': ->
    res = 0.75 * -0.75
    res = res + 0.75
    res = res / -0.75
    res = res - -0.75

  # Native doubles, chained.
  'native chained': ->
    n1 = 0.75
    n2 = -0.75
    (n1 * n2 + n1) / n2 - n2

  # Double numeric class, serial.
  'Double serial': ->
    res = Double.mul 0.75, -0.75
    res = Double.add res, 0.75
    res = Double.div res, -0.75
    res = Double.sub res, -0.75

  # Double numeric class, chained.
  'Double chained': ->
    n1 = new Double 0.75
    n2 = new Double -0.75
    n1.mul(n2).add(n1).div(n2).sub(n2)

  # Rational numeric class, serial.
  'Rational serial': ->
    n1 = new Rational 3, 4
    n2 = new Rational -3, 4
    res = Rational.mul n1, n2
    res = Rational.add res, n1
    res = Rational.div res, n2
    res = Rational.sub res, n2

  # Rational numeric class, chained.
  'Rational chained': ->
    n1 = new Rational 3, 4
    n2 = new Rational -3, 4
    n1.mul(n2).add(n1).div(n2).sub(n2)

require('bench').runMain()
