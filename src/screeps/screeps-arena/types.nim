import std/jsffi

import "./consts"

# js examples
# https://github.com/nim-lang/Nim/blob/ddce5559981ac5dedd3a5dfb210eb25296e69307/lib/js/dom.nim#L77-L108

# use cstrings over strings for js code
# strings are intended for nim

# https://nim-lang.org/docs/jsffi.html

# TODO some of these types are not complete as I figure things out

type
  GameObject* {.exportc.} = ref object of RootObj
    exists*: bool
    id*: cstring
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
  StructureContainer* {.exportc.} = ref object of OwnedStructure
    capacity*: int
    cost*: int
    store*: Store
  StructureTower* {.exportc.} = ref object of OwnedStructure
    store*: Store
  BodyPart* {.exportc.} = ref object
    `type`*: cstring
    hits*: int
  Creep* {.exportc.} = ref object of GameObject
    body*: seq[BodyPart]
    fatigue*: float64
    hits*: int
    hitsMax*: int
    my*: bool
    store*: Store
  Flag* {.exportc.} = ref object of GameObject
    my*: bool
  Source* {.exportc.} = object
    effects*: seq[Effects]
    energy*: int
    energyCapacity*: int
    id*: cstring
    pos*: RoomPosition
    ticksToRegeneration*: int
  GameUtil* {.exportc.} = object

proc moveTo*(c: Creep, target: GameObject): ReturnCode {.importcpp.}

proc attack*(c: Creep, target: Creep): ReturnCode {.importcpp.}
proc attack*(c: Creep, target: Structure): ReturnCode {.importcpp.}
proc attack*(t: StructureTower, target: Creep): ReturnCode {.importcpp.}
proc attack*(t: StructureTower, target: Structure): ReturnCode {.importcpp.}

proc rangedAttack*(c: Creep, target: Creep): ReturnCode {.importcpp.}
proc rangedAttack*(c: Creep, target: Structure): ReturnCode {.importcpp.}

proc heal*(c: Creep, target: Creep): ReturnCode {.importcpp.}

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
proc getCapacity*(s: Store): int {.importcpp.}
proc getFreeCapacity*(s: Store): int {.importcpp.}
proc getUsedCapacity*(s: Store): int {.importcpp.}

proc findClosestByPath*[T: GameObject](c: Creep, targets: seq[
    T]): T {.importcpp.}
proc findClosestByRange*(c: Creep, targets: seq[
    Position]): GameObject {.importcpp.}
