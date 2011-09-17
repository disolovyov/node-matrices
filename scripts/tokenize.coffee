coffee   = require 'coffee-script'
fs       = require 'fs'
path     = require 'path'
traverse = require 'traverse'

# Create a new algebraic expression AST.
algebraic = (op, first, second) ->
  nodes = coffee.nodes("a#{op}b").expressions[0]
  nodes.first = first
  nodes.second = second
  nodes

# Constant values of numeric provider properties.
constantFor =
  unit: 1
  zero: 0

# Built-in equivalents for numeric provider methods.
operatorFor =
  add: '+'
  div: '/'
  eq: '=='
  mul: '*'
  neg: '-'
  sub: '-'

# This function is a Beans hook that optimizes GenericMatrix by replacing
# generic methods and properties with double operators and constants.
# This effectively hard codes the Double numeric provider directly into
# GenericMatrix.
#
# Up to ~1.7 times performance gain over GenericMatrix with Double objects is
# observed, when running the matrix benchmark (development dependencies must
# be installed):
#
#     $ coffee bench/matrix
module.exports = (filename, data) ->
  if matches = filename.match /^(.*)\/generic-matrix/
    # Create an AST based on provided tokens,
    # with its root set to the start of the class declaration.
    nodes = coffee.nodes data
    nodes.expressions[0].value = nodes.expressions[0].value.body.expressions[0]
    ast = traverse nodes

    # Walk the AST.
    ast.forEach (node) ->
      # Change class name to Matrix.
      if node is 'GenericMatrix'
        @update 'Matrix'

      # Replace numeric provider expressions with built-in algebra.
      if node is 'numeric'
        ctx = @parent.parent
        op = ctx.node.properties[0].name.value
        switch op
          # Replace properties with constants.
          when 'unit', 'zero'
            ctx.node.base.value = constantFor[op]
            ctx.node.properties = []

          # Change `abs` base to `Math`.
          when 'abs'
            ctx.node.base.value = 'Math'

          # Replace methods with operators.
          when 'add', 'eq', 'div', 'mul', 'neg', 'sub'
            ctx = ctx.parent
            ctx.node = algebraic operatorFor[op], ctx.node.args...

        # Apply modifications to context.
        ctx.update ctx.node

    # Write optimized AST to file.
    fs.mkdirSync matches[1], 0755 unless path.existsSync matches[1]
    fs.writeFileSync matches[1] + '/matrix.js', nodes.compile bare: true
    return
