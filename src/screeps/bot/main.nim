import std/jsffi

import "../screeps/main"

var console {.importc, nodecl.}: JsObject
var module {.importc, nodecl.}: JsObject

proc spawnHarvester1() =
    let spawnName = "Spawn1".cstring
    let creepName = "Harvester1".cstring
    let gameSpawn = game.spawns[spawnName]

    let ret = gameSpawn.spawnCreep([cstring($WORK), cstring($CARRY), cstring(
            $MOVE)], creepName);
    console.log("game spawn return code: ".cstring, $ret)


proc harvesterCreep1() =
    # module.exports.loop = function () {
    #     var creep = Game.creeps['Harvester1'];
    #     var sources = creep.room.find(FIND_SOURCES);
    #     if(creep.harvest(sources[0]) == ERR_NOT_IN_RANGE) {
    #         creep.moveTo(sources[0]);
    #     }
    # }
    let creepName = "Harvester1".cstring
    let creep: Creep = game.creeps[creepName]

    # TODO making a copy of room breaks things
    # this compiles to nimCopy() which is not what I want
    # let room = creep.room

    let sources: seq[Source] = creep.room.find(FIND_SOURCES)
    # check length of sources
    if (len(sources) == 0):
        console.log("no sources found".cstring)
        return
    if (creep.harvest(sources[0]) == ERR_NOT_IN_RANGE):
        let res = creep.moveTo(sources[0].pos)
        if (res != OK):
            console.log("moveTo returned: ".cstring, $res,
                    " for creep: ".cstring, creepName)

    # TODO next steps
    #     module.exports.loop = function () {
    #     var creep = Game.creeps['Harvester1'];

    #     if(creep.store.getFreeCapacity() > 0) {
    #         var sources = creep.room.find(FIND_SOURCES);
    #         if(creep.harvest(sources[0]) == ERR_NOT_IN_RANGE) {
    #             creep.moveTo(sources[0]);
    #         }
    #     }
    #     else {
    #         if( creep.transfer(Game.spawns['Spawn1'], RESOURCE_ENERGY) == ERR_NOT_IN_RANGE ) {
    #             creep.moveTo(Game.spawns['Spawn1']);
    #         }
    #     }
    # }

proc mainLoop() =
    # spawnHarvester1()
    harvesterCreep1()

# main()
module.exports.loop = mainLoop
