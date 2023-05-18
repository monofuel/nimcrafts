
import "./types", "./consts", "./shims"

export types, consts, shims

# interface for Screeps Arena
# the Screeps Arena API relies on importing modules
# we can't really do that from nim, so I have an init.ts shim that
# imports all the modules as objects we can use from nim

# TODO could I just call require() from nim?


# adding comments for ts types ot help with debugging
{.emit"""
/// <reference path="./node_modules/@types/screeps-arena/game/constants.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/index.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/path-finder.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/utils.d.ts" />
/// <reference path="./node_modules/@types/screeps-arena/game/visual.d.ts" />
""".}

# Loading modules into variables

var gameUtil* {.importJs.}: GameUtil

{.emit"""
import * as gameUtil from 'game/utils';
import * as gameVisual from 'game/visual';
import * as gamePathFinder from 'game/path-finder';
import * as game from 'game';
import * as arena from 'arena';

import { Creep } from 'game/prototypes';
import { Flag } from 'arena/prototypes';
""".}
