import std/[jsffi, sequtils, sugar]

import "../screeps-arena/main"


var console {.importc, nodecl.}: JsObject
var module {.importc, nodecl.}: JsObject

proc simpleMoveLoop() {.exportc.} =
  let currentTick = gameUtil.getTicks()
  console.log("Current tick: ".cstring, currentTick)

  let creeps = getAllCreeps()
  console.log("found creeps: ".cstring, len(creeps))

  let flags = getAllFlags()
  console.log("found flags: ".cstring, len(flags))

  if len(creeps) < 1:
    raise newException(Exception, "No creeps found")
  if len(flags) < 1:
    raise newException(Exception, "No flags found")


  # head to the flag
  let flag = flags[0]
  let creep = creeps[0]

  let res = creep.moveTo(flag)
  console.log("moveTo result: ".cstring, res)


proc firstAttack() {.exportc.} =
  let currentTick = gameUtil.getTicks()
  console.log("Current tick: ".cstring, currentTick)

  let creeps = getAllCreeps()
  console.log("found creeps: ".cstring, len(creeps))

  # filter my creeps and not my creeps
  let myCreeps = creeps.filter((c: Creep) => c.my)
  let enemyCreeps = creeps.filter((c: Creep) => not c.my)

  if len(myCreeps) < 1:
    raise newException(Exception, "No my creeps found")
  if len(enemyCreeps) < 1:
    raise newException(Exception, "No enemy creeps found")

  let myCreep = myCreeps[0]
  let enemyCreep = enemyCreeps[0]

  let attackRes = myCreep.attack(enemyCreep)
  console.log("attack result: ".cstring, attackRes)
  if (attackRes == ERR_NOT_IN_RANGE):
    let moveRes = myCreep.moveTo(enemyCreep)
    console.log("moveTo result: ".cstring, moveRes)

proc creepsBodies() {.exportc.} =
  let creeps = getAllCreeps()
  console.log("found creeps: ".cstring, len(creeps))

  let enemyCreeps = creeps.filter((c: Creep) => not c.my)

  if len(enemyCreeps) < 1:
    raise newException(Exception, "No enemy creeps found")
  let myCreeps = creeps.filter((c: Creep) => c.my)
  let attackCreeps = myCreeps.filter((c: Creep) => c.body.anyIt(it.type == ATTACK))
  let rangedCreeps = myCreeps.filter((c: Creep) => c.body.anyIt(it.type ==
      RANGED_ATTACK))

  for c in creeps.filter((c: Creep) => c.my):
    console.log("creep: ".cstring, c.id)
    console.log("body: ".cstring, c.body)

    for b in c.body:
      console.log("part: ".cstring, b.type)
      console.log("ATTACK".cstring, ATTACK)

    if c.body.anyIt(it.type == ATTACK):
      console.log("creep has attack part: ".cstring, c.id)
      if len(enemyCreeps) > 0:
        if c.attack(enemyCreeps[0]) == ERR_NOT_IN_RANGE:
          discard c.moveTo(enemyCreeps[0])
      else:
        console.log("no other creeps to attack".cstring)
    elif c.body.anyIt(it.type == RANGED_ATTACK):
      console.log("creep has ranged attack part: ".cstring, c.id)
      if len(enemyCreeps) > 0:
        if c.rangedAttack(enemyCreeps[0]) == ERR_NOT_IN_RANGE:
          discard c.moveTo(enemyCreeps[0])
      else:
        console.log("no other creeps to attack".cstring)
    elif c.body.anyIt(it.type == HEAL):
      console.log("creep has heal part: ".cstring, c.id)
      if len(attackCreeps) > 0:
        if c.heal(attackCreeps[0]) == ERR_NOT_IN_RANGE:
          discard c.moveTo(attackCreeps[0])
      elif len(rangedCreeps) > 0:
        if c.heal(rangedCreeps[0]) == ERR_NOT_IN_RANGE:
          discard c.moveTo(rangedCreeps[0])
      else:
        console.log("no other creeps to heal".cstring)

    else:
      console.log("creep missing attack or heal part".cstring)

proc storeAndTransfer() {.exportc.} =
  let currentTick = gameUtil.getTicks()
  console.log("Current tick: ".cstring, currentTick)
  let creeps = getAllCreeps()
  console.log("found creeps: ".cstring, len(creeps))


  for c in creeps.filter((c: Creep) => c.my):
    console.log("creep: ".cstring, c.id)
    console.log("body: ".cstring, c.body)

    if c.store.getUsedCapacity() == 0:
      let containers = getAllContainers()
      console.log("found containers: ".cstring, len(containers))
      if len(containers) > 0:
        let container = containers[0]
        if c.withdraw(container, RESOURCE_ENERGY) == ERR_NOT_IN_RANGE:
          discard c.moveTo(container)
      else:
        console.log("no containers found".cstring)

    else:
      let towers = getAllTowers()
      console.log("found towers: ".cstring, len(towers))
      if len(towers) > 0:
        let tower = towers[0]
        if c.transfer(tower, RESOURCE_ENERGY) == ERR_NOT_IN_RANGE:
          discard c.moveTo(tower)
      else:
        console.log("no towers found".cstring)


  # tower shoot creeps
  let towers = getAllTowers()
  console.log("found towers: ".cstring, len(towers))
  if len(towers) > 0:
    let tower = towers[0]
    let enemyCreeps = creeps.filter((c: Creep) => not c.my)
    if len(enemyCreeps) > 0:
      let enemyCreep = enemyCreeps[0]
      let res = tower.attack(enemyCreep)
      console.log("tower attack result: ".cstring, res)
    else:
      console.log("no enemy creeps found".cstring)
  else:
    console.log("no towers found".cstring)



{.emit"""
export const loop = storeAndTransfer;
""".}
