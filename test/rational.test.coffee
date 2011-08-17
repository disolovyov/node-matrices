Rational = require '../src/numeric/rational.coffee'

a = new Rational 9, 16
b = new Rational -3, 4

module.exports =
  'unit and zero': (test) ->
    test.deepEqual Rational.zero(), new Rational(0, 1), 'zero'
    test.deepEqual Rational.unit(), new Rational(1, 1), 'unit'
    test.done()

  'norm': (test) ->
    test.equal a.norm2(), (81 / 256), 'positive num'
    test.equal b.norm2(), (9 / 16), 'negative num'
    test.done()

  'inverse': (test) ->
    test.deepEqual b.neg(), new Rational(3, 4), 'neg'
    test.deepEqual b.inv(), new Rational(4, -3), 'inv'
    test.done()

  'addition': (test) ->
    test.deepEqual a.add(b), new Rational(-12, 64), 'add'
    test.deepEqual a.sub(b), new Rational(84, 64), 'sub'
    test.done()

  'multiplication': (test) ->
    test.deepEqual b.mul(b), a, 'mul'
    # These should work when reducing is in place.
    # test.deepEqual a.div(b), b, 'div'
    # test.deepEqual Rational.unit().div(b).mul(b), Rational.unit(), 'unit'
    test.done()

  'absolute values': (test) ->
    test.equal a.abs(), 0.5625, 'a'
    test.equal b.abs(), 0.75, 'b'
    test.done()

  'conjugate values': (test) ->
    test.deepEqual a.conj(), a, 'positive num'
    test.deepEqual b.conj(), b, 'negative num'
    test.done()
