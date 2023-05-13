#!/bin/bash

yarn add screeps

echo $STEAM_KEY | npx screeps init

npx screeps start --cli_host 0.0.0.0