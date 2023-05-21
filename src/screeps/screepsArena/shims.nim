import ./types

# Collection of shim functions to help translate
# typescript to nim

proc getAllCreeps*(): seq[Creep] =
  # TODO nim type descriptions?
  {.emit"""
  return game.utils.getObjectsByPrototype(game.prototypes.Creep);
  """.}

proc getAllFlags*(): seq[Flag] =
  {.emit"""
  return game.utils.getObjectsByPrototype(Flag);
  """.}

proc getAllContainers*(): seq[StructureContainer] =
  {.emit"""
  return game.utils.getObjectsByPrototype(game.prototypes.StructureContainer);
  """.}

proc getAllTowers*(): seq[StructureTower] =
  {.emit"""
  return game.utils.getObjectsByPrototype(game.prototypes.StructureTower);
  """.}

proc getAllSpawns*(): seq[StructureSpawn] =
  {.emit"""
  return game.utils.getObjectsByPrototype(game.prototypes.StructureSpawn);
  """.}

proc getAllSources*(): seq[Source] =
  {.emit"""
  return game.utils.getObjectsByPrototype(game.prototypes.Source);
  """.}

proc getAllConstructionSites*(): seq[ConstructionSite] =
  {.emit"""
  return game.utils.getObjectsByPrototype(game.prototypes.ConstructionSite);
  """.}


proc `$`*(p: Position): string =
  return $p.x & "," & $p.y
