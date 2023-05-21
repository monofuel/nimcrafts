import std/jsffi, ./consts

# js examples
# https://github.com/nim-lang/Nim/blob/ddce5559981ac5dedd3a5dfb210eb25296e69307/lib/js/dom.nim#L77-L108

# use cstrings over strings for js code
# strings are intended for nim

# https://nim-lang.org/docs/jsffi.html

# TODO some of these types are not complete as I figure things out

# Base Types
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
  Effects* {.exportc.} = object
    effect*: int
    level*: int
    ticksRemaining*: int
  Store* {.exportc.} = ref object
  BodyPart* {.exportc.} = ref object
    `type`*: cstring
    hits*: int

# Game Objects
type
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
    # NB. store is not set when a creep is being spawned
    store*: Store


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


## GameUtil

type GameUtil* {.exportc.} = object

proc getTicks*(g: GameUtil): int {.importcpp.}

## GameVisual

type GameVisual* {.exportc.} = object

# TODO gamevisual objects

## GamePathFinder
 

type
  GamePathFinder* {.exportc.} = object
  CostMatrix* {.exportc.} = object
  Goal* {.exportc.} = object
    pos*: Position
    range*: int
  GoalType = Goal | Position
  SearchPathOptions* {.exportc.} = object
    # Custom navigation cost data
    costMatrix*: CostMatrix
    # Cost for walking on plain positions. The default is 2
    plainCost*: int
    # Cost for walking on swamp positions. The default is 10
    swampCost*: int
    # Instead of searching for a path to the goals this will search for a path away from the goals.
    # The cheapest path that is out of range of every goal will be returned.
    # The default is false
    flee*: bool
    # The maximum allowed pathfinding operations. The default value is 50000
    maxOps*: int
    # The maximum allowed cost of the path returned. The default is Infinity
    maxCost*: int
    # Weight from 1 to 9 to apply to the heuristic in the A* formula F = G + weight * H. The default value is 1.2
    heuristicWeight*: float
  SearchPathResult* {.exportc.} = object
    path*: seq[Position]
    # Total number of operations performed before this path was calculated
    ops*: int
    # The total cost of the path as derived from plainCost, swampCost, and given CostMatrix instance
    cost*: int
    # If the pathfinder fails to find a path, this will be set to true
    incomplete*: bool

# TODO haven't tested how newCostMatrix compiles to js
proc newCostMatrix*(): CostMatrix {.importcpp.}
proc get*(m: CostMatrix, x: int, y: int): int {.importcpp.}
proc set*(m: CostMatrix, x: int, y: int, cost: int): void {.importcpp.}
proc clone*(m: CostMatrix): CostMatrix {.importcpp.}

proc searchPath*(g: GamePathFinder, origin: Position, goal: GoalType | seq[GoalType],
    opts: SearchPathOptions): SearchPathResult {.importcpp.}

## Arena

type 
  Arena* {.exportc.} = object
  Flag* {.exportc.} = ref object of GameObject
    my*: bool

## GamePrototypes

type GamePrototypes * {.exportc.} = JsObject

## Game

type
  ArenaInfo* {.exportc.} = object
    # "Capture the Flag", "Spawn and Swamp", "Collect and Control" 
    name*: cstring
    # 1 for basic, 2 for advanced
    level*: int
    season*: cstring
    ticksLimit*: int
    cpuTimeLimit*: int
    cpuTimeLimitFirstTick*: int

  Game* {.exportc.} = object
    utils*: GameUtil
    pathFinder*: GamePathFinder
    prototypes*: GamePrototypes
    visual*: GameVisual
    arenaInfo*: ArenaInfo