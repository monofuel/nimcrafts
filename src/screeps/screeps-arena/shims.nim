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
