import std/jsffi

import "./consts"

# js examples
# https://github.com/nim-lang/Nim/blob/ddce5559981ac5dedd3a5dfb210eb25296e69307/lib/js/dom.nim#L77-L108

# use cstrings over strings for js code
# strings are intended for nim

# https://nim-lang.org/docs/jsffi.html

# TODO some of these types are not complete as I figure things out

type
  GameObject* {.exportc.} = object of RootObj
    exists*: bool
    id*: cstring
    ticksToDecay*: int
    x*: int
    y*: int

type
  Effects* {.exportc.} = object
    effect*: int
    level*: int
    ticksRemaining*: int
  RoomPosition* {.exportc.} = object
    x*: int
    y*: int
    roomName*: cstring
  Structure* {.exportc.} = ref object of GameObject
    hits*: int
    hitsMax*: int
  StructureSpawn* {.exportc.} = object # https://docs.screeps.com/api/#StructureSpawn
    hits*: int
    hitsMax*: int
    id*: cstring
    structureType*: cstring
  StructureController* {.exportc.} = object
  Room* {.exportc.} = object
    energyAvailable*: int
    energyCapacityAvailable*: int
    name*: cstring
  BodyPart* {.exportc.} = ref object
    `type`*: cstring
    hits*: int
  Creep* {.exportc.} = ref object of GameObject
    body*: seq[BodyPart]
    fatigue*: float64
    hits*: int
    hitsMax*: int
    my*: bool
    # store
  Flag* {.exportc.} = ref object of GameObject
    my*: bool
  Source* {.exportc.} = object
    effects*: seq[Effects]
    energy*: int
    energyCapacity*: int
    id*: cstring
    pos*: RoomPosition
    room*: Room
    ticksToRegeneration*: int
  GameType* {.exportc.} = object # https://docs.screeps.com/api/#Game
    time*: int
    spawns*: JsAssoc[cstring, StructureSpawn]
    creeps*: JsAssoc[cstring, Creep]
  GameUtil* {.exportc.} = object


type
  SpawnCreepOpts* {.exportc.} = object
    dryRun*: bool

# TODO opts
proc spawnCreep*(
        g: StructureSpawn,
        #body: openArray[BodyPart],
        body: openArray[cstring],
        name: cstring
    ): ReturnCode {.importcpp.}

# TODO return type depends on specified type
proc find*(r: Room, t: FindTargetsType): seq[Source] {.importcpp.}

# TODO Mineral or Deposit
proc harvest*(c: Creep, s: Source): ReturnCode {.importcpp.}

proc moveTo*(c: Creep, target: ref GameObject): ReturnCode {.importcpp.}

proc attack*(c: Creep, target: Creep): ReturnCode {.importcpp.}
proc attack*(c: Creep, target: Structure): ReturnCode {.importcpp.}

proc rangedAttack*(c: Creep, target: Creep): ReturnCode {.importcpp.}
proc rangedAttack*(c: Creep, target: Structure): ReturnCode {.importcpp.}

proc heal*(c: Creep, target: Creep): ReturnCode {.importcpp.}

proc getTicks*(g: GameUtil): int {.importcpp.}
