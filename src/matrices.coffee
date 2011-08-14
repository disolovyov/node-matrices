fs = require 'fs'

# Create the matrices export object.
# Include version information and matrix classes.
matrices =
  VERSION: JSON.parse(fs.readFileSync(__dirname + '/../package.json')).version
  Matrix: require './matrices/matrix'

# Require matrix projection selector functions
# and attach them to the export object directly.
for own name, fn of require './selectors'
  matrices[name] = fn

# Export everything:
module.exports = matrices
