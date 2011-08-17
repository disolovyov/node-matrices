Double = require '../src/numeric/double'

module.exports =
  'bare arithmetic': (test) ->
    test.equal Double.add(2, 2), 4
    test.done()

  'chaining': (test) ->
    two = new Double 2
    test.deepEqual two.mul(two), new Double 4, 'four'
    test.deepEqual two.mul(two).add(two), new Double 6, 'six'
    test.done()
