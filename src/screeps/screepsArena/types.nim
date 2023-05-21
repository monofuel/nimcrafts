import ./consts

# js examples
# https://github.com/nim-lang/Nim/blob/ddce5559981ac5dedd3a5dfb210eb25296e69307/lib/js/dom.nim#L77-L108

# use cstrings over strings for js code
# strings are intended for nim

# https://nim-lang.org/docs/jsffi.html

# TODO some of these types are not complete as I figure things out

type
  GameObject* {.exportc.} = ref object of RootObj
    exists*: bool
    id*: int # docs say it is a string but it looks like an int in reality
    ticksToDecay*: int
    x*: int
    y*: int
  Position* {.exportc.} = ref object
    x*: int
    y*: int
  ErrorRes* {.exportc.} = object
    error*: int

type
  Effects* {.exportc.} = object
    effect*: int
    level*: int
    ticksRemaining*: int
  RoomPosition* {.exportc.} = object
    x*: int
    y*: int
    roomName*: cstring
  Store* {.exportc.} = ref object
  Structure* {.exportc.} = ref object of GameObject
    hits*: int
    hitsMax*: int
  OwnedStructure* {.exportc.} = ref object of Structure
    my*: bool
  Spawning* {.exportc.} = ref object
    creep*: Creep
    needTime*: int
    remainingTime*: int
  StructureSpawn* {.exportc.} = ref object of OwnedStructure
    store*: Store
    spawning*: Spawning
  Source* {.exportc.} = ref object of GameObject
    energy*: int
    energyCapacity*: int
  StructureContainer* {.exportc.} = ref object of OwnedStructure
    store*: Store
  StructureTower* {.exportc.} = ref object of OwnedStructure
    store*: Store
  BodyPart* {.exportc.} = ref object
    `type`*: cstring
    hits*: int
  ConstructionSite* {.exportc.} = ref object of GameObject
    my*: bool
    progress*: int
    progressTotal*: int
    structure*: Structure
  Creep* {.exportc.} = ref object of GameObject
    body*: seq[BodyPart]
    fatigue*: int
    hits*: int
    hitsMax*: int
    my*: bool
    store*: Store
  Flag* {.exportc.} = ref object of GameObject
    my*: bool
  GameUtil* {.exportc.} = object

proc moveTo*(c: Creep, target: GameObject): ReturnCode {.importcpp.}
proc moveTo*(c: Creep, target: Position): ReturnCode {.importcpp.}

proc attack*(c: Creep, target: Creep): ReturnCode {.importcpp.}
proc attack*(c: Creep, target: Structure): ReturnCode {.importcpp.}
proc attack*(t: StructureTower, target: Creep): ReturnCode {.importcpp.}
proc attack*(t: StructureTower, target: Structure): ReturnCode {.importcpp.}

proc rangedAttack*(c: Creep, target: Creep): ReturnCode {.importcpp.}
proc rangedAttack*(c: Creep, target: Structure): ReturnCode {.importcpp.}

proc heal*(c: Creep, target: Creep): ReturnCode {.importcpp.}

proc harvest*(c: Creep, target: Source): ReturnCode {.importcpp.}
proc build*(c: Creep, target: ConstructionSite): ReturnCode {.importcpp.}

proc getTicks*(g: GameUtil): int {.importcpp.}

proc transfer*(c: Creep, target: Creep, resource: cstring): ReturnCode {.importcpp.}
proc transfer*(c: Creep, target: Structure,
    resource: cstring): ReturnCode {.importcpp.}
proc withdraw*(c: Creep, target: Structure,
    resource: cstring): ReturnCode {.importcpp.}

proc transfer*(c: Creep, target: Creep, resource: cstring,
    amount: int): ReturnCode {.importcpp.}
proc transfer*(c: Creep, target: Structure, resource: cstring,
    amount: int): ReturnCode {.importcpp.}
proc withdraw*(c: Creep, target: Structure, resource: cstring,
    amount: int): ReturnCode {.importcpp.}


# NB. resource argument is optional, but RESOURCE_ENERGY is the default
proc getCapacity*(s: Store, resource: cstring): int {.importcpp.}
proc getFreeCapacity*(s: Store, resource: cstring): int {.importcpp.}
proc getUsedCapacity*(s: Store, resource: cstring): int {.importcpp.}

proc findClosestByPath*[T: GameObject](c: Creep, targets: seq[
    T]): T {.importcpp.}
proc findClosestByRange*(c: Creep, targets: seq[
    Position]): GameObject {.importcpp.}

type SpawnCreepResult = object
  error*: ErrorRes
  `object`*: Creep

proc spawnCreep*(s: StructureSpawn, body: seq[cstring]): SpawnCreepResult {.importcpp.}

type CreateStructureTowerResult = object
  error*: ErrorRes
  `object`*: ConstructionSite
proc createStructureTower*(posArg: Position): CreateStructureTowerResult {.importcpp.}