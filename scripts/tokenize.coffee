coffee   = require 'coffee-script'
fs       = require 'fs'
traverse = require 'traverse'

# Create a new algebraic expression AST.
algebraic = (op, first, second) ->
  nodes = coffee.nodes("a#{op}b").expressions[0]
  nodes.first = first
  nodes.second = second
  nodes

# Built-in equivalents for numeric provider methods.
syntaxFor =
  add: '+'
  div: '/'
  eq: '=='
  mul: '*'
  neg: '-'
  sub: '-'

# This hook optimizes GenericMatrix by replacing generic methods and properties
# with double operators and constants. This effectively hard codes the Double
# numeric provider directly into GenericMatrix.
module.exports = (filename, data) ->
  if matches = filename.match /^(.*)generic-matrix/
    # Create an AST based on provided tokens,
    # with its root set to the start of the class declaration.
    nodes = coffee.nodes data
    nodes.expressions[0].value = nodes.expressions[0].value.body.expressions[0]
    ast = traverse nodes

    # Replace numeric provider expressions with built-in algebra.
    ast.forEach (node) ->
      if node is 'numeric'
        ctx = @parent.parent
        op = ctx.node.properties[0].name.value
        switch op
          # Replace properties with constants.
          when 'unit', 'zero'
            ctx.node.base.value = if op is 'unit' then 1 else 0
            ctx.node.properties = []

          # Change `abs` base to `Math`.
          when 'abs'
            ctx.node.base.value = 'Math'

          # Replace methods with operators.
          when 'add', 'eq', 'div', 'mul', 'neg', 'sub'
            ctx = ctx.parent
            ctx.node = algebraic syntaxFor[op], ctx.node.args...

        # Apply modifications to context.
        ctx.update ctx.node

    # Write optimized AST to file.
    fs.writeFileSync matches[1] + 'fast-matrix.js', nodes.compile bare: true
    return
