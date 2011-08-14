# Basic matrix class.
module.exports = class Matrix
  # Create a new matrix with given dimensions and contents.
  # Contents are specified as a flat array, row by row.
  constructor: (rows, cols, items = []) ->
    @rows = rows
    @cols = cols
    @items = items

  # Create a new identity matrix of size *n*.
  @identity: (n) ->
    items = []
    for i in [0...n]
      for j in [0...n]
        items.push if i is j then 1 else 0
    new Matrix n, n, items

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
  #     m.project column(1), column(3)
  project: (fns...) ->
    items = []
    for row in [0...@rows]
      for fn in fns
        ind = row * @cols
        items.push fn(@items.slice(ind, ind + @cols))
    new Matrix @rows, fns.length, items

  # Aliases for `project`:
  proj: @::project
  select: @::project

  # Transpose the matrix (switch columns with rows).
  transpose: ->
    items = []
    for i in [0...@rows]
      for j in [0...@cols]
        items.push @items[j * @rows + i]
    new Matrix @cols, @rows, items

  # Aliases for `transpose`:
  transp: @::transpose
  t: @::transpose

  # Create a one-level deep copy of the current matrix.
  clone: ->
    new Matrix @rows, @cols, @items.slice(0)

  # Calculate the inverse matrix.
  #
  # **NB!** Exceptions for noninvertible matrices are currently not thrown.
  inverse: ->
    # Exit with an error, if the matrix is not square.
    if @rows isnt @cols
      throw new Error 'Dimensionality mismatch'

    # Create two matrices to work on them in parallel.
    # These are a direct clone of the current matrix,
    # and an identity matrix of the same size.
    #
    # When the direct clone is reduced to an identity matrix,
    # the other (initially identity) matrix should become the inverse.
    m = @clone()
    inv = Matrix.identity size

    # To avoid swapping rows in the matrix itself during pivoting,
    # a special array is used for indirect indexing.
    #
    # With this array, to get the ij matrix element:
    #
    #     m.get(row[i], j)
    size = @rows
    row = (i for i in [0...size] by 1)

    # Reduce the matrix to upper triangular form using
    # Gaussian elimination with pivoting.
    for i in [0...size] by 1

      # Find pivot.
      pivot = i
      pivotVal = m.get row[pivot], i
      for j in [i + 1...size] by 1
        test = j
        testVal = m.get row[test], i
        if Math.abs(testVal) > Math.abs(pivotVal)
          pivotVal = testVal
          pivot = test

      # Swap current row with pivot row.
      temp = row[i]
      row[i] = row[pivot]
      row[pivot] = temp

      # Divide the pivot row so that pivot element would become 1.
      for j in [0...size] by 1
        ind = m.index row[i], j
        m.items[ind] /= pivotVal
        inv.items[ind] /= pivotVal

      # Subtract pivot row from rows below so that
      # elements under pivot become 0.
      for ii in [i + 1...size] by 1
        k = m.get row[ii], i
        for j in [0...size] by 1
          ind = m.index row[ii], j
          m.items[ind] -= k * m.get(row[i], j)
          inv.items[ind] -= k * inv.get(row[i], j)

    # Reduce the upper triangular matrix to identity matrix.
    for i in [size - 1..0] by -1
      for ii in [i - 1..0] by -1
        k = m.get row[ii], i
        for j in [0...size] by 1
          ind = m.index row[ii], j
          m.items[ind] -= k * m.get(row[i], j)
          inv.items[ind] -= k * inv.get(row[i], j)

    # Compose the resulting matrix according to the state
    # of the indirect indexing array (move rows into place).
    res = new Matrix size, size
    for i in [0...size] by 1
      for j in [0...size] by 1
        res.items[res.index i, j] = inv.items[inv.index row[i], j]
    res

  # Alias for `inverse`:
  inv: @::inverse

  # Negate the matrix (negate each element).
  # Essentially, this is -A where -A + A = 0 (zero matrix).
  negate: ->
    new Matrix @rows, @cols, (-item for item in @items)

  # Alias for `negate`:
  neg: @::negate

  # Add this matrix to the other matrix (pairwise addition).
  # Both dimensions of operands should match.
  # Scalar addition is currently not implemented.
  add: (other) ->
    if @rows isnt other.rows or @cols isnt other.cols
      throw new Error 'Dimensionality mismatch'
    items = []
    for i in [0...@items.length]
      items.push @items[i] + other.items[i]
    new Matrix @rows, @cols, items

  # Subtract the other matrix from this matrix.
  # Essentialy, this is A + (-B).
  subtract: (other) ->
    @add other.negate()

  # Alias for `subtract`:
  sub: @::subtract

  # Multiply this matrix by the other matrix.
  # Column count in this matrix should be the same as row count in the other.
  # Scalar multiplication is currently not implimented.
  multiply: (other) ->
    if @cols isnt other.rows
      throw new Error 'Dimensionality mismatch'
    items = []
    for i in [0...@rows]
      for j in [0...other.cols]
        sum = 0
        for k in [0...@cols]
          sum += @get(i, k) * other.get(k, j)
        items[i * other.cols + j] = sum
    new Matrix @rows, other.cols, items

  # Alias for `multiply`:
  mul: @::multiply

  # Divide this matrix by the other matrix.
  # Essentially, this is A * inverse of B.
  divide: (other) ->
    @mul other.inverse()

  # Alias for `divide`:
  div: @::divide

  # Calculate the Euclidean norm of this matrix, sans the square root.
  norm: ->
    norm = 0
    norm += item * item for item in @items
    norm

  # Pretty-printed string representation of this matrix.
  toString: ->
    s = ''
    for row in [0...@rows] by 1
      ind = row * @cols
      items = (item.toFixed(2) for item in @items.slice(ind, ind + @cols))
      s += items.join(', ') + "\n"
    s
