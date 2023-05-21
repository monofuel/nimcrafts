
import "./types", "./consts"

export types, consts

when defined(screepsArena):
    raise newException(Exception, "don't import screeps world from screeps arena")

# API https://docs.screeps.com/api/

# Reference
# https://github.com/oderwat/nim-screeps

type
    Game* = ref GameType

var game* {.noDecl, importc: "Game".}: Game
