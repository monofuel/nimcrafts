import std/[sequtils, sugar]

import ./blocks

import ../screepsArena/main


proc debugPrintCounts*() =
  logicBlock("debugPrintCounts"):
    # TODO print out arena info
    let currentTick = game.utils.getTicks()
    echo "- Current tick: ".cstring, currentTick

    let creeps = getAllCreeps()
    echo "- found creeps: ".cstring, len(creeps)
    let myCreeps = creeps.filter(c => c.my)
    echo "- my creeps: ".cstring, len(myCreeps)
    
    let spawns = getAllSpawns()
    echo "- found spawns: ".cstring, len(spawns)

    for s in spawns:
      echo "  - spawn ID: ", s.id
      echo "    spawn my: ", s.my
      echo "    spawn capacity: ", s.store.getCapacity(RESOURCE_ENERGY)
      echo "    spawn free capacity: ", s.store.getFreeCapacity(RESOURCE_ENERGY)
      echo "    spawn used capacity: ", s.store.getUsedCapacity(RESOURCE_ENERGY)