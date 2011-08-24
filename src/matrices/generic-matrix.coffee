# Generic matix is a flexible kind of matrix.
# Every matrix of such kind is initialized with an arithmetic numeric.
# This numeric does all the calculations within matrix operations.
#
# `Rational` and `Complex` numeric classes are both examples of numeric..
module.exports = (numeric) ->
  class GenericMatrix
    # Create a new matrix with given dimensions and contents.
    # Contents are specified as a flat array, row by row.
    constructor: (rows, cols, items = []) ->
      @rows = rows
      @cols = cols
      @items = items

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

    # Get the index of the *ij* matrix element in the items array.
    index: (i, j) ->
      i * @cols + j

    # Get the *ij* matrix element.
    get: (i, j) ->
      @items[@index i, j]

    # Project the matrix to a new matrix using a set of selector functions.
    # These functions are defined as: f(row) -> selected value.
    #
    # For example, if we define:
    #
    #     column = (n) ->
    #       (arr) -> arr[n]
    #
    # We can then create a new 2-column matrix from columns 1 and 3
    # of a 4-column matrix like so:
    #
    #     m.proj column(1), column(3)
    proj: (fns...) ->
      items = []
      for row in [0...@rows] by 1
        for fn in fns
          ind = row * @cols
          items.push fn(@items.slice(ind, ind + @cols))
      new @constructor @rows, fns.length, items

    # Transpose the matrix (switch columns with rows).
    t: ->
      items = []
      for i in [0...@rows] by 1
        for j in [0...@cols] by 1
          items[j * @rows + i] = @get i, j
      new @constructor @cols, @rows, items

    # Create a one-level deep copy of the current matrix.
    clone: ->
      new @constructor @rows, @cols, @items.slice(0)

    # Create a new matrix by appending the columns of this
    # and the other matrix.
    # Both matrices should have the same row count.
    #
    # This isn't the most effective solution in terms of memory for
    # large enough matrices, but cases of such matrices should be rare.
    # Besides, they are probably sparse and should be treated
    # in a different way.
    augment: (other) ->
      if @rows isnt other.rows
        throw new Error 'Dimensionality mismatch'
      selfT = @t()
      otherT = other.t()
      selfT.rows += otherT.rows
      selfT.items.push otherT.items...
      selfT.t()

    # Get a matrix slice based on a range of rows.
    # Extract up to but not including *end*.
    sliceRows: (begin, end) ->
      # Support negative and out of bounds indexes, just like array slices.
      begin += @rows if begin < 0
      begin = 0 if begin < 0
      end ?= @rows
      if end > @rows
        end = @rows
      else if end < 0
        end += @rows
      end = begin if end < begin

      # Do the actual slice.
      new @constructor end - begin, @cols, @items.slice(begin * @cols, end * @cols)

    # Get a matrix slice based on a range of cols.
    # Extract up to but not including *end*.
    sliceCols: (begin, end) ->
      end ?= @cols
      @t().sliceRows(begin, end).t()

    # Get a matrix slice based on ranges of cols and rows.
    # This uses *sliceRows* and *sliceCols* logic.
    slice: (beginCols, beginRows, endCols, endRows) ->
      beginRows ?= 0
      endCols ?= @cols
      endRows ?= @rows
      @sliceRows(beginRows, endRows).sliceCols(beginCols, endCols)

    # U(L^-1)P decomposition of the current matrix.
    # Result is in the form of {upper, lower, perm, det}, where:
    #
    # * *upper* is the upper triangular matrix
    # * *lower* is the inverse of lower triangular matrix
    # * *perm* is the permutations list
    # * *det* is the determinant
    #
    # This method is used internally for determinant calculation and
    # for finding inverse matrices.
    decompose = ->
      # Exit with an error, if the matrix is not square.
      if @rows isnt @cols
        throw new Error 'Dimensionality mismatch'

      # Create two matrices to work on them in parallel.
      # These are a direct clone of the current matrix,
      # and an identity matrix of the same size.
      #
      # When the direct clone is reduced to the upper triangular matrix,
      # the other (initially identity) matrix should become the inverse
      # of lower triangular matrix.
      size = @rows
      upper = @clone()
      lower = @constructor.identity size

      # To avoid swapping rows in the matrix itself during pivoting,
      # a special array is used for indirect indexing.
      #
      # With this array, to get the *ij* matrix element:
      #
      #     upper.get(row[i], j)
      row = (i for i in [0...size] by 1)

      # Perform the decomposition
      # using Gaussian elimination with pivoting.
      # Calculate the determinant along the way.
      det = numeric.unit
      for i in [0...size] by 1

        # Find pivot.
        pivot = i
        pivotVal = upper.get row[pivot], i
        for j in [i + 1...size] by 1
          test = j
          testVal = upper.get row[test], i
          if numeric.abs(testVal) > numeric.abs(pivotVal)
            pivotVal = testVal
            pivot = test

        # If pivot value is 0, things are bad.
        det = numeric.mul det, pivotVal
        if numeric.eq pivotVal, numeric.zero
          return det: numeric.zero

        # Try to swap current row with pivot row.
        # Negate the determinant, if rows are swapped.
        if i isnt pivot
          temp = row[i]
          row[i] = row[pivot]
          row[pivot] = temp
          det = numeric.neg det

        # Divide the pivot row so that pivot element would become 1.
        for j in [0...size] by 1
          ind = upper.index row[i], j
          upper.items[ind] = numeric.div upper.items[ind], pivotVal
          lower.items[ind] = numeric.div lower.items[ind], pivotVal

        # Subtract pivot row from rows below so that
        # elements under pivot become 0.
        for ii in [i + 1...size] by 1
          k = upper.get row[ii], i
          for j in [0...size] by 1
            ind = upper.index row[ii], j
            prod = numeric.mul k, upper.get(row[i], j)
            upper.items[ind] = numeric.sub upper.items[ind], prod
            prod = numeric.mul k, lower.get(row[i], j)
            lower.items[ind] = numeric.sub lower.items[ind], prod

      # Compose the final result.
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
        throw new Error 'Matrix is not invertible or is ill-conditioned'

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

    # Subtract the other matrix from this matrix.
    # Essentialy, this is A + (-B).
    sub: (other) ->
      @add other.neg()

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

    # Divide this matrix by the other matrix.
    # Essentially, this is A * inverse of B.
    div: (other) ->
      @mul other.inv()

    # Calculate the Euclidean norm of this matrix.
    # Divide by matrix element count instead of square root.
    norm: ->
      norm = 0
      norm += numeric.mul item, item for item in @items
      numeric.abs(norm) / @items.length

    # Test the equality of matrices with *eps* precision.
    eq: (other, eps = 0) ->
      @sub(other).norm() <= eps

    # Pretty-printed string representation of this matrix.
    toString: ->
      s = ''
      for row in [0...@rows] by 1
        ind = row * @cols
        slice = @items.slice ind, ind + @cols
        items = (numeric.abs(item).toFixed(2) for item in slice)
        s += items.join(', ') + "\n"
      s
