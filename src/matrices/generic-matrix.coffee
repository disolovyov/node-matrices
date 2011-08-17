Matrix = require './matrix'

# Generic matrix is based on basic matrix, but is more flexible.
# Every matrix of such kind works in almost the same way as the basic matrix,
# except that it is initialized with an arithmetic numeric.
# This numeric.does all the calculations within matrix operations.
#
# `Rational` and `Complex` numeric classes are both examples of numeric..
module.exports = (numeric) ->
  class GenericMatrix extends Matrix
    # Create a new identity matrix of size *n*.
    @identity: (n) ->
      items = []
      for i in [0...n] by 1
        for j in [0...n] by 1
          items.push if i is j then numeric.unit else numeric.zero
      new @ n, n, items

    # Create a new permutation matrix based on row *perms* list.
    @permutation: (perms, inverted = false) ->
      items = []
      n = perms.length
      for i in [0...n] by 1
        for j in [0...n] by 1
          if inverted
            items.push if perms[i] is j then numeric.unit else numeric.zero
          else
            items.push if perms[j] is i then numeric.unit else numeric.zero
      new @ n, n, items

    # U(L^-1)P decomposition of the current matrix.
    # Implementation details can be found in the `@constructor` class.
    decompose = ->
      if @rows isnt @cols
        throw new Error 'Dimensionality mismatch'
      size = @rows
      upper = @clone()
      lower = @constructor.identity size
      row = (i for i in [0...size] by 1)
      det = numeric.unit
      for i in [0...size] by 1
        pivot = i
        pivotVal = upper.get row[pivot], i
        for j in [i + 1...size] by 1
          test = j
          testVal = upper.get row[test], i
          if numeric.abs(testVal) > numeric.abs(pivotVal)
            pivotVal = testVal
            pivot = test
        det = numeric.mul det, pivotVal
        console.log det
        if numeric.eq pivotVal, numeric.zero
          return det: numeric.zero
        if i isnt pivot
          temp = row[i]
          row[i] = row[pivot]
          row[pivot] = temp
          det = numeric.neg det
        for j in [0...size] by 1
          ind = upper.index row[i], j
          upper.items[ind] = numeric.div upper.items[ind], pivotVal
          lower.items[ind] = numeric.div lower.items[ind], pivotVal
        for ii in [i + 1...size] by 1
          k = upper.get row[ii], i
          for j in [0...size] by 1
            ind = upper.index row[ii], j
            prod = numeric.mul k, upper.get(row[i], j)
            upper.items[ind] = numeric.sub upper.items[ind], prod
            prod = numeric.mul k, lower.get(row[i], j)
            lower.items[ind] = numeric.sub lower.items[ind], prod
      upper: upper
      lower: lower
      perm: row
      det: det

    # Calculate the determinant of this matrix.
    det: ->
      decompose.call(@).det

    # Calculate the inverse matrix.
    inv: ->
      # Try decomposing the matrix and check if determinant is not 0.
      {upper, lower, perm, det} = decompose.call @
      if numeric.abs(det) < 1e-8
        throw new Error '@constructor is not invertible or is ill-conditioned'

      # Reduce the upper triangular matrix to identity matrix.
      size = @rows
      for i in [size - 1..0] by -1
        for ii in [i - 1..0] by -1
          k = upper.get perm[ii], i
          for j in [0...size] by 1
            ind = upper.index perm[ii], j
            prod = numeric.mul k, upper.get(perm[i], j)
            upper.items[ind] = numeric.sub upper.items[ind], prod
            prod = numeric.mul k, lower.get(perm[i], j)
            lower.items[ind] = numeric.sub lower.items[ind], prod

      # Compose the resulting matrix according to the state
      # of the indirect indexing array (move rows into place).
      res = new @constructor size, size
      for i in [0...size] by 1
        for j in [0...size] by 1
          res.items[res.index i, j] = lower.items[lower.index perm[i], j]
      res

    # Negate the matrix (negate each element).
    # Essentially, this is -A where -A + A = 0 (zero matrix).
    neg: ->
      new @constructor @rows, @cols, (numeric.neg item for item in @items)

    # Add this matrix to the other matrix (pairwise addition).
    # Both dimensions of operands should match.
    # Scalar addition is currently not implemented.
    add: (other) ->
      if @rows isnt other.rows or @cols isnt other.cols
        throw new Error 'Dimensionality mismatch'
      items = []
      for i in [0...@items.length] by 1
        items.push numeric.add(@items[i], other.items[i])
      new @constructor @rows, @cols, items

    # Multiply this matrix by the other matrix.
    # Column count in this matrix should be the same as row count in the other.
    # Scalar multiplication is currently not implemented.
    mul: (other) ->
      if @cols isnt other.rows
        throw new Error 'Dimensionality mismatch'
      items = []
      for i in [0...@rows] by 1
        for j in [0...other.cols] by 1
          sum = numeric.zero
          for k in [0...@cols] by 1
            sum = numeric.add sum, numeric.mul(@get(i, k), other.get(k, j))
          items[i * other.cols + j] = sum
      new @constructor @rows, other.cols, items

    # Calculate the Euclidean norm of this matrix.
    # Divide by matrix element count instead of square root.
    norm: ->
      norm = 0
      norm += numeric.mul item, item for item in @items
      numeric.abs(norm) / @items.length

    # Pretty-printed string representation of this matrix.
    toString: ->
      s = ''
      for row in [0...@rows] by 1
        ind = row * @cols
        slice = @items.slice ind, ind + @cols
        items = (numeric.abs(item).toFixed(2) for item in slice)
        s += items.join(', ') + "\n"
      s
