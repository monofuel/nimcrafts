import std/jsffi

import "./consts"

# use cstrings over strings for js code
# strings are intended for nim

# https://nim-lang.org/docs/jsffi.html

# TODO some of these types are not complete as I figure things out

type
    StructureSpawnType* {.exportc.} = object # https://docs.screeps.com/api/#StructureSpawn
        hits*: int
        hitsMax*: int
        id*: cstring
        structureType*: cstring
    GameType* {.exportc.} = object # https://docs.screeps.com/api/#Game
        time*: int
        spawns*: JsAssoc[cstring, StructureSpawnType]


type
    SpawnCreepOpts* {.exportc.} = object
        dryRun*: bool

# TODO opts
proc spawnCreep*(
        g: StructureSpawnType,
        #body: openArray[BodyPart],
        body: openArray[cstring],
        name: cstring
    ): ReturnCodeType {.importcpp.}
