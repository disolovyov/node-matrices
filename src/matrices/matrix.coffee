module.exports = class Matrix
  constructor: (rows, cols, items = []) ->
    @rows = rows
    @cols = cols
    @items = items

  @identity: (n) ->
    items = []
    for i in [0...n]
      for j in [0...n]
        items.push if i is j then 1 else 0
    new Matrix n, n, items

  index: (i, j) ->
    i * @cols + j

  get: (i, j) ->
    @items[@index i, j]

  project: (fns...) ->
    items = []
    for row in [0...@rows]
      for fn in fns
        ind = row * @cols
        items.push fn(@items.slice(ind, ind + @cols))
    new Matrix @rows, fns.length, items

  @column: (n) ->
    (arr) -> arr[n]

  proj: @::project

  transpose: ->
    items = []
    for i in [0...@rows]
      for j in [0...@cols]
        items.push @items[j * @rows + i]
    new Matrix @cols, @rows, items

  transp: @::transpose
  t: @::transpose

  clone: ->
    new Matrix @rows, @cols, @items.slice(0)

  inverse: ->
    if @rows isnt @cols
      throw new Error 'Dimensionality mismatch'
    m = @clone()
    size = @rows
    row = (i for i in [0...size] by 1)
    inv = Matrix.identity size
    for i in [0...size] by 1
      lead = i
      leadVal = m.get row[lead], i
      for j in [i + 1...size] by 1
        test = j
        testVal = m.get row[test], i
        if Math.abs(testVal) > Math.abs(leadVal)
          leadVal = testVal
          lead = j
      temp = row[i]
      row[i] = row[lead]
      row[lead] = temp
      for j in [0...size] by 1
        ind = m.index row[i], j
        m.items[ind] /= leadVal
        inv.items[ind] /= leadVal
      for ii in [i + 1...size] by 1
        k = m.get row[ii], i
        for j in [0...size] by 1
          ind = m.index row[ii], j
          m.items[ind] -= k * m.get(row[i], j)
          inv.items[ind] -= k * inv.get(row[i], j)
    for i in [size - 1..0] by -1
      for ii in [i - 1..0] by -1
        k = m.get row[ii], i
        for j in [0...size] by 1
          ind = m.index row[ii], j
          m.items[ind] -= k * m.get(row[i], j)
          inv.items[ind] -= k * inv.get(row[i], j)
    res = new Matrix size, size
    for i in [0...size] by 1
      for j in [0...size] by 1
        res.items[res.index i, j] = inv.items[inv.index row[i], j]
    res

  inv: @::inverse

  negate: ->
    new Matrix @rows, @cols, (-item for item in @items)

  neg: @::negate

  add: (other) ->
    if @rows isnt other.rows or @cols isnt other.cols
      throw new Error 'Dimensionality mismatch'
    items = []
    for i in [0...@items.length]
      items.push @items[i] + other.items[i]
    new Matrix @rows, @cols, items

  subtract: (other) ->
    @add other.neg()

  sub: @::subtract

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

  mul: @::multiply

  divide: (other) ->
    @mul other.inverse()

  div: @::divide

  norm: ->
    norm = 0
    norm += item * item for item in @items
    norm

  toString: ->
    s = ''
    for row in [0...@rows] by 1
      ind = row * @cols
      items = (item.toFixed(2) for item in @items.slice(ind, ind + @cols))
      s += items.join(', ') + "\n"
    s
