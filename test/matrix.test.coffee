Matrix = require '../src/matrices/matrix'

# Matrix set for tests.
basic = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 8]
transp = new Matrix 3, 3, [1, 4, 7, 2, 5, 8, 3, 6, 8]
rect = new Matrix 3, 2, [1, 2, 3, 4, 5, 6]
empty =  new Matrix 3, 0
zeroDet = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 9]
negDet = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 10]
edge = new Matrix 3, 3, [117, 28, -53, -527, 77, 13, 434, 35, 11]
ident = Matrix.identity 3
permNone = Matrix.permutation [0, 1, 2]
perm = Matrix.permutation [1, 2, 0]
permInv = Matrix.permutation [1, 2, 0], true
permRows = new Matrix 3, 3, [4, 5, 6, 7, 8, 8, 1, 2, 3]
permCols = new Matrix 3, 3, [2, 3, 1, 5, 6, 4, 8, 8, 7]

# For slightly permissive equality checks.
eps = 1e-8
closeEnough = (a, b) ->
  -eps < a - b < eps

module.exports =
  'indexing': (test) ->
    test.equal basic.index(2, 1), 7, 'index'
    test.equal basic.get(2, 1), 8, 'get'
    test.done()

  'transposition': (test) ->
    test.deepEqual basic.t(), transp, 'single'
    test.deepEqual basic.t().t(), basic, 'double'
    test.done()

  'identity matrix': (test) ->
    test.ok basic.inv().mul(basic).equal(ident, eps), 'basic'
    test.ok edge.inv().mul(edge).equal(ident, eps), 'edge'
    test.done()

  'permutation matrix': (test) ->
    test.ok permNone.equal(ident), 'neutral'
    test.ok permRows.equal(permInv.multiply(basic)), 'rows'
    test.ok permCols.equal(basic.multiply(perm)), 'cols'
    test.done()

  'determinant calculation': (test) ->
    test.ok closeEnough(basic.determinant(), 3), 'positive'
    test.ok closeEnough(zeroDet.determinant(), 0), 'zero'
    test.ok closeEnough(negDet.determinant(), -3), 'negative'
    test.done()
