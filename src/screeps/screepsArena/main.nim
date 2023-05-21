
import "./types", "./consts", "./shims"
import std/jsffi

export types, consts, shims

when defined(screepsWorld):
    raise newException(Exception, "don't import screeps arena from screeps world")

# interface for Screeps Arena

# adding comments for ts types ot help with debugging
{.emit"""
/// <reference path="./node_modules/@types/screeps-arena/game/constants.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/index.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/path-finder.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/utils.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/visual.d.ts" />
""".}

# Loading modules into variables
# TODO should probably use objects instead of individual imports
# need to figure out which one does what
var gameUtil* {.importJs.}: GameUtil

{.emit"""
import * as gameUtil from 'game/utils';
import * as gameVisual from 'game/visual';
import * as gamePathFinder from 'game/path-finder';
import * as game from 'game';
import * as arena from 'arena';

import { 
  Creep, Source, StructureContainer, StructureTower, StructureSpawn,
  ConstructionSite
 } from 'game/prototypes';
// import { Flag } from 'arena/prototypes';
""".}

when defined(screepsFlag):
    {.emit"""
    import * as arena from 'arena';
    import { Flag } from 'arena/prototypes';
    """.}

# Nodejs global objects
# NB. use `echo` with nim js -d:nodejs
# var console* {.importJs, nodecl.}: JsObject
# var module* {.importJs, nodecl.}: JsObject