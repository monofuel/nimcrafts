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


type SpawnCreepResult = object
  error*: ErrorRes
  creep*: Creep

# NB. this function is a bit of a hack because spawnCreep can return
# 2 different possible types- a creep or an error.
# NB. the creeps returned by this function appear to be just structures without methods
proc spawnCreep*(sArg: StructureSpawn, bodyArg: seq[
    cstring]): SpawnCreepResult =
  let s {.exportc.} = sArg
  # TODO: under the hood, nim is doing a nimCopy of bodyArgs, should avoid that
  let body {.exportc.} = bodyArg
  {.emit"""
  const result = s.spawnCreep(body);
  if (result.error) {
    return {error: result.error};
  } else {
    return {creep: result};
  }
  """.}

type CreateStructureTowerResult = object
  error*: ErrorRes
  constructionSite*: ConstructionSite

# NB. createConstructionSite takes a prototype
proc createStructureTower*(posArg: Position): CreateStructureTowerResult =
  let pos {.exportc.} = posArg
  {.emit"""
  const result = gameUtil.createConstructionSite(pos, StructureTower);
  if (result.error) {
    return {error: result.error};
  } else {
    return {constructionSite: result};
  }
  """.}
