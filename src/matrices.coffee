# Create the matrices export object.
# Include version information and matrix classes.
matrices =
  Matrix: require './matrices/matrix'
  genericMatrix: require './matrices/generic-matrix'
  numeric:
    Complex: require './numeric/complex'
    Double: require './numeric/double'
    Rational: require './numeric/rational'
  selectors: require './selectors'

# Attach version info to the export object.
# This will fail in the browser.
try
  package = require('fs').readFileSync(__dirname + '/../package.json')
  matrices.version = JSON.parse(package).version

# Export everything:
module.exports = matrices
