Complex = require '../src/numeric/complex.coffee'

a = new Complex 3, 4
b = new Complex -7, 24
c = new Complex 312, 25

module.exports =
  'multiplication': (test) ->
    test.deepEqual a.mul(a), b, 'mul'
    test.deepEqual b.div(a), a, 'div'
    test.deepEqual Complex.unit().div(c).mul(c), Complex.unit(), 'unit'
    test.done()

  'absolute values': (test) ->
    test.equal a.abs(), 5, 'a'
    test.equal b.abs(), 25, 'b'
    test.equal c.abs(), 313, 'c'
    test.done()
