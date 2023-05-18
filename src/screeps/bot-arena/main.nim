import std/jsffi

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





{.emit"""
export const loop = simpleMoveLoop;
""".}
