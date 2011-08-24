genericMatrix = require '../src/matrices/generic-matrix'

# Numeric providers.
Double = require '../src/numeric/double'
Rational = require '../src/numeric/rational'
Complex = require '../src/numeric/complex'

# Generic matrices.
DoubleMatrix = genericMatrix Double
RationalMatrix = genericMatrix Rational
ComplexMatrix = genericMatrix Complex

# Matrices for benching.
items = [1, 2, 3, 4, 5, 6, 7, 8, 8]
doubleMatrix = new DoubleMatrix 3, 3, items
rationalMatrix = new RationalMatrix 3, 3, items.map (item) ->
  new Rational item
complexMatrix = new ComplexMatrix 3, 3, items.map (item) ->
  new Complex item, item / 2

module.exports.compare =

  # GenericMatrix with Double objects.
  'inverse of Double matrix': ->
    doubleMatrix.inv()

  # GenericMatrix with Rational objects.
  'inverse of Rational matrix': ->
    rationalMatrix.inv()

  # GenericMatrix with Complex objects.
  'inverse of Complex matrix': ->
    complexMatrix.inv()

require('bench').runMain()
