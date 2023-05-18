
import "./types", "./consts"

export types, consts

# interface for Screeps Arena
# the Screeps Arena API relies on importing modules
# we can't really do that from nim, so I have an init.ts shim that
# imports all the modules as objects we can use from nim

# TODO could I just call require() from nim?


# adding comments for ts types ot help with debugging
{.emit"""
/// <reference path="./typings/game/constants.d.ts" />
/// <reference path="./typings/game/index.d.ts" />
/// <reference path="./typings/game/path-finder.d.ts" />
/// <reference path="./typings/game/utils.d.ts" />
/// <reference path="./typings/game/visual.d.ts" />
""".}

# Loading modules into variables

var gameUtil* {.importJs.}: GameUtil

{.emit"""
import * as gameUtil from 'game/utils';
import * as gameVisual from 'game/visual';
import * as gamePathFinder from 'game/path-finder';
// NB. not using gameConstants, can just copy them to nim
// not sure what this arena type is but it's not in typings
// import { } from 'arena';
""".}
