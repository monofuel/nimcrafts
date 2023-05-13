
import "./types", "./consts"

export types, consts

# API https://docs.screeps.com/api/

# Reference
# https://github.com/oderwat/nim-screeps

type
    Game* = ref GameType

var game* {.noDecl, importc: "Game".}: Game
