import std/jsffi

import "../screeps/main"

var console {.importc, nodecl.}: JsObject

proc main() =
    let spawnName = "Spawn1".cstring
    let creepName = "Harvester1".cstring
    let gameSpawn = game.spawns[spawnName]

    let ret = gameSpawn.spawnCreep([cstring($WORK), cstring($CARRY), cstring(
            $MOVE)], creepName);
    console.log("game spawn return code: ".cstring, $ret)


main()
