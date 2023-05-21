import ./types

# Collection of shim functions to help translate
# typescript to nim

proc getAllCreeps*(): seq[Creep] =
  # TODO nim type descriptions?
  {.emit"""
  return gameUtil.getObjectsByPrototype(Creep);
  """.}

proc getAllFlags*(): seq[Flag] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(Flag);
  """.}

proc getAllContainers*(): seq[StructureContainer] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(StructureContainer);
  """.}

proc getAllTowers*(): seq[StructureTower] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(StructureTower);
  """.}

proc getAllSpawns*(): seq[StructureSpawn] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(StructureSpawn);
  """.}

proc getAllSources*(): seq[Source] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(Source);
  """.}

proc getAllConstructionSites*(): seq[ConstructionSite] =
  {.emit"""
  return gameUtil.getObjectsByPrototype(ConstructionSite);
  """.}


proc `$`*(p: Position): string =
  return $p.x & "," & $p.y
