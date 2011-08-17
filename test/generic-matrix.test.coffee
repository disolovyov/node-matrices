Rational = require '../src/numeric/rational'
RationalMatrix = require('../src/matrices/generic-matrix')(Rational)

# Converts each array value from integer to Rational.
r = (array) ->
  array.map (item) ->
    new Rational item

# RationalMatrix set for tests.
basic = new RationalMatrix 3, 3, r [1, 2, 3, 4, 5, 6, 7, 8, 8]
zeroDet = new RationalMatrix 3, 3, r [1, 2, 3, 4, 5, 6, 7, 8, 9]
negDet = new RationalMatrix 3, 3, r [1, 2, 3, 4, 5, 6, 7, 8, 10]
edge = new RationalMatrix 3, 3, r [117, 28, -53, -527, 77, 13, 434, 35, 11]
ident = RationalMatrix.identity 3

module.exports =
  'identity matrix': (test) ->
    test.deepEqual basic.inv().mul(basic), ident, 'basic'
    test.deepEqual edge.inv().mul(edge), ident, 'edge'
    test.done()

  'determinant calculation': (test) ->
    test.deepEqual basic.det(), new Rational(3, 1), 'positive'
    test.deepEqual zeroDet.det(), Rational.zero, 'zero'
    test.deepEqual negDet.det(), new Rational(-3, 1), 'negative'
    test.done()
