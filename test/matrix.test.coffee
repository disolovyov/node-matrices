Matrix = require '../src/matrices/matrix'

# Matrix set for tests.
basic = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 8]
rect = new Matrix 3, 2, [1, 2, 3, 4, 5, 6]
empty =  new Matrix 3, 0
zeroDet = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 9]
negDet = new Matrix 3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 10]
edge = new Matrix 3, 3, [117, 28, -53, -527, 77, 13, 434, 35, 11]
ident = Matrix.identity 3

module.exports =
  'indexing': (test) ->
    test.equal basic.index(2, 1), 7
    test.equal basic.get(2, 1), 8
    test.done()
