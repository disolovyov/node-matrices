Complex = require '../src/numeric/complex'

a = new Complex 3, 4
b = new Complex -7, 24
c = new Complex 312, 25

module.exports =
  'unit and zero': (test) ->
    test.deepEqual Complex.zero, new Complex(0, 0), 'zero'
    test.deepEqual Complex.unit, new Complex(1, 0), 'unit'
    test.done()

  'norm': (test) ->
    test.equal a.norm2(), 25, 'positive re'
    test.equal b.norm2(), 625, 'negative re'
    test.done()

  'inverse': (test) ->
    test.deepEqual a.neg(), new Complex(-3, -4), 'neg'
    test.deepEqual a.inv(), new Complex(0.12, -0.16), 'inv'
    test.done()

  'addition': (test) ->
    test.deepEqual a.add(b), new Complex(-4 , 28), 'add'
    test.deepEqual a.sub(b), new Complex(10, -20), 'sub'
    test.done()

  'multiplication': (test) ->
    test.deepEqual a.mul(a), b, 'mul'
    test.deepEqual b.div(a), a, 'div'
    test.deepEqual Complex.unit.div(c).mul(c), Complex.unit, 'unit'
    test.done()

  'absolute values': (test) ->
    test.equal a.abs(), 5, 'a'
    test.equal b.abs(), 25, 'b'
    test.equal c.abs(), 313, 'c'
    test.done()

  'conjugate values': (test) ->
    test.deepEqual a.conj(), new Complex(3, -4), 'positive re'
    test.deepEqual b.conj(), new Complex(-7, -24), 'negative re'
    test.done()
