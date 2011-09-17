# Create a freeze function based on the runtime ability.
# This function either freezes an object (if possible), or does nothing.
freeze = ->
  if Object?.freeze?
    (obj) -> Object.freeze obj
  else
    (obj) -> obj

# Export a collection of helpers used throughout the package.
module.exports =
  # Freeze and object: that is, make is effectively immutable.
  freeze: freeze()
