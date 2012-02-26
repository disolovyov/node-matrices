matrices = require '../lib/matrices'

module.exports =
  'attached version': (test) ->
    test.notEqual matrices.version, null, 'version absent'
    test.done()
