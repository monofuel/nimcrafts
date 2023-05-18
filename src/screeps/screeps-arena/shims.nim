import ./types

# Collection of shim functions to help translate
# typescript to nim

proc getAllCreeps*(): seq[Creep] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(Creep);
  """.}

proc getAllFlags*(): seq[Flag] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(Flag);
  """.}
