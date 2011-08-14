# A collection of selector functions for use with matrix projections.
module.exports =
  # Column *n* projection selector.
  column: (n) ->
    (arr) -> arr[n]

  # Constant *n* projection selector.
  fixed: (n) ->
    -> n
