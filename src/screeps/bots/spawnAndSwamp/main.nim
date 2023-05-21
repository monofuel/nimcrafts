import std/[sequtils, random]

import ../../screepsArena/main
import ../../screepsLib/[debug, screeps, blocks]

# consts
const desiredWorkers = 3
# Creeps do not need to harvest from source, just loot from containers
const workerBody = @[CARRY, CARRY, MOVE]
const healerBody = @[HEAL, MOVE, MOVE]
const combatBody = @[ATTACK, ATTACK, MOVE, MOVE, MOVE]
const healerRatio = 0.2

# state
var
  workers: seq[Creep]
  combats: seq[Creep]
  healers: seq[Creep]
  combatStagingArea: Position
  doAttack = false

# TODO: ideas
# could build ramparts around spawn
# could build roads from spawn to the edges of wall

# building extensions
# building towers
# building walls
# building ramparts

randomize()

proc spawnAndSwampLoop() {.exportc.} =
  mainLoop:
    debugPrintCounts()

    # read in the game state
    let spawns = getAllSpawns()
    let mySpawns = spawns.filterIt(it.my == true)
    if mySpawns.len == 0:
      raise newException(CatchableError, "No spawns found!")
    let mySpawn = mySpawns[0]
    let containers = getAllContainers()
    # let creeps = getAllCreeps()

    # let myCreeps = creeps.filterIt(it.my == true)
    
    # TODO remove dead creeps from lists

    if combatStagingArea.isNil:
      let random = rand(1.0)
      let y = (if random < 0.5: -5 else: 5)
      combatStagingArea = Position(x: mySpawn.x + 2,y: mySpawn.y + y)
      echo "Combat staging area: ", combatStagingArea

    # let workerCost = len(workerBody) * 100
    # let combatCost = len(combatBody) * 100
    # let healerCost = len(healerBody) * 100

    logicBlock("spawning"):
      if not isNil(mySpawn.spawning):
        # spawn busy
        echo "spawn busy"
        return

      # let random = rand(1.0)
      # echo "random: ", random
      # if random < 0.8:
      #   raise newException(CatchableError, "Random exception")

      # spawn workers if we have less than desired
      if len(workers) < desiredWorkers:
        let spawnResult = mySpawn.spawnCreep(workerBody)
        if isNil(spawnResult.object):
          echo "Spawn error: ", spawnResult.error
        else:
          workers.add(spawnResult.object)
      else:
        # decide to build combat or healer
        let currentRatio = len(healers) / len(combats)
        let doHealer = currentRatio < healerRatio
        let body = (if doHealer: healerBody else: combatBody)
        let spawnResult = mySpawn.spawnCreep(body)
        if isNil(spawnResult.object):
          echo "Spawn error: ", spawnResult.error
        else:
          if doHealer:
            healers.add(spawnResult.object)
          else:
            combats.add(spawnResult.object)


    logicBlock("workers"):
      # loop through workers and give them orders
      for c in workers:
        # carry energy back to base
        if not isNil(c.store) and c.store.getUsedCapacity(RESOURCE_ENERGY) > 0:
          let res = c.transfer(mySpawn, RESOURCE_ENERGY)
          if res == ERR_NOT_IN_RANGE:
            discard c.moveTo(mySpawn)
          continue

        # hunt for a container to loot
        # TODO should ignore empty containers
        # or containers that are already being looted
        let closestContainer = findClosestByPath(c, containers)
        if isNil(closestContainer):
          echo "No containers found!"
          continue;
        let res = c.withdraw(closestContainer, RESOURCE_ENERGY)
        if res == ERR_NOT_IN_RANGE:
          discard c.moveTo(closestContainer)

    logicBLock("combat"):
      # if we don't have enough combat units, keep them near spawn
      if not doAttack:
        for c in combats:
          discard c.moveTo(combatStagingArea)
        for c in healers:
          discard c.moveTo(combatStagingArea)
        if len(combats) + len(healers) >= 5:
          doAttack = true
      else:
        if len(combats) == 0:
          echo "No combat units left, stopping attack"
          doAttack = false
        else:
          # otherwise, go attack their spawn 
          echo "attack!!"
          let enemySpawn = spawns.filterIt(it.my == false)[0]
          for c in combats:
            let res = c.attack(enemySpawn)
            if res == ERR_NOT_IN_RANGE:
              discard c.moveTo(enemySpawn)
          for c in healers:
            let mostHurtHealer = getMostHurtCreep(healers)
            if (mostHurtHealer.hits < mostHurtHealer.hitsMax):
              if c.heal(mostHurtHealer) == ERR_NOT_IN_RANGE:
                discard c.moveTo(mostHurtHealer)
            else:
              if len(combats) > 0:
                let mostHurtCombat = getMostHurtCreep(combats)
                if c.heal(mostHurtCombat) == ERR_NOT_IN_RANGE:
                  discard c.moveTo(mostHurtCombat)
              else:
                echo "No combat units left, to heal"

when not defined(screepsTest):
  {.emit"""
  export const loop = spawnAndSwampLoop;
  """.}
