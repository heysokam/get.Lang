#!/bin/sh
set -eu
#:___________________________________________________________________________
#  ༄  get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
#:___________________________________________________________________________
# curl -s https://raw.githubusercontent.com/heysokam/get.Lang/master/get.Zig.sh | bash
curl -s https://raw.githubusercontent.com/heysokam/get.Lang/master/get.Nim.sh | bash


#_______________________________________
# @section Configuration
#_____________________________
# General
binDir=./bin
# Zig
zigDir=$binDir/.zig
zig=$zigDir/zig
# Nim
nimDir=$binDir/.nim
nim=$nimDir/bin/nim


#_______________________________________
# @section Build
#_____________________________
# Use the Compilers
$zig version
$nim --version

