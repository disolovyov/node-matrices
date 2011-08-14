Matrix = require '../src/matrices/matrix'

# Matrix set for tests.
basic = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 8]
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

module.exports =
  'indexing': (test) ->
    test.equal basic.index(2, 1), 7
    test.equal basic.get(2, 1), 8
    test.done()

  'permutation matrix': (test) ->
    test.ok permNone.equal(ident)
    test.ok permRows.equal(permInv.multiply(basic))
    test.ok permCols.equal(basic.multiply(perm))
    test.done()
