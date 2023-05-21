
# Ensure this package is only included on screeps arena
when defined(screepsWorld):
    raise newException(Exception, "don't import screeps arena from screeps world")

# When testing, don't define JS functions so we can mock them instead
when not defined(screepsTest):
    import std/jsffi
    import "./types", "./consts", "./shims"

    export types, consts, shims

    # adding comments for ts types to help with debugging
    {.emit"""
    /// <reference path="./node_modules/@types/screeps-arena/game/index.d.ts" />
    /// <reference path="./node_modules/@types/screeps-arena/arena/index.d.ts" />
    """.}

    # Loading modules into variables

    var game* {.importJs.}: Game
    var arena* {.importJs.}: Arena

    {.emit"""
    import * as game from 'game';
    import * as arena from 'arena';
    """.}

    # Nodejs global objects
    # NB. use `echo` with nim js -d:nodejs
    # var console* {.importJs, nodecl.}: JsObject
    # var module* {.importJs, nodecl.}: JsObject