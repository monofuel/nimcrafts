import std/[sequtils, sugar]

import ../screepsArena/main


proc debugPrintCounts*() =
  let currentTick = gameUtil.getTicks()
  echo "Current tick: ".cstring, currentTick
  let creeps = getAllCreeps()
  echo "found creeps: ".cstring, len(creeps)
  let spawns = getAllSpawns()
  echo "found spawns: ".cstring, len(spawns)

  let myCreeps = creeps.filter(c => c.my)
  echo "my creeps: ".cstring, len(myCreeps)

  let mySpawns = spawns.filterIt(it.my == true)
  for s in mySpawns:
    echo "spawn ID: ", s.id
    echo "spawn capacity: ", s.store.getCapacity(RESOURCE_ENERGY)
    echo "spawn free capacity: ", s.store.getFreeCapacity(RESOURCE_ENERGY)
    echo "spawn used capacity: ", s.store.getUsedCapacity(RESOURCE_ENERGY)