import std/jsffi

import "../screeps-arena/main"


var console {.importc, nodecl.}: JsObject
var module {.importc, nodecl.}: JsObject

proc mainLoop() {.exportc.} =
    let currentTick = gameUtil.getTicks()
    console.log("Current tick: ".cstring, currentTick)

# module.exports.loop = mainLoop

{.emit"""
export const loop = mainLoop;
""".}
