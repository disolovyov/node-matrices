selectors = require '../src/selectors'

module.exports =
  'column selector': (test) ->
    index1 = selectors.column(1)
    test.equal index1([1, 2, 3]), 2
    test.done()

  'fixed selector': (test) ->
    fixed1 = selectors.fixed(1)
    test.equal fixed1(2), 1
    test.done()
