#!/bin/sh
set -eu
#:__________________________________________________________________________
#  ༄  get.Nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
#:__________________________________________________________________________
## @fileoverview  Automatic download of Nim.
##
##  - Does not change your global environment in any way.
##  - Does nothing if the target binary already exists.
##  - You can call it repeatedly without worry.
##
#__________________________________________________________________________|
##
##  !! IMPORTANT !!
##  This script will bootstrap a fully ZigCC-built version of Nim (and its toolset)
##
##  Standard Nim is built with GCC/Clang (depending on the platform)
##  ZigCC is a Clang interface with safer defaults.
##  This means that everything that works with Clang-Nim should work with this build.
##
#__________________________________________________________________________|
##
## @howto
##  Set these variables in CLI before calling the script to change the behavior of the script.
##
##  Examples:
##  0. Using the default options remotely
##     curl https://raw.githubusercontent.com/heysokam/get.Lang/master/get.Nim.sh | bash
##
##  1. Using the default options
##     get.Nim.sh
##
##  2. Installing into  ./some/other/dir
##     TargetDir=./some/other/dir get.Nim.sh
##
##  3. Installing version 0.12.0
##     TargetVersion=0.12.0 get.Nim.sh
##
##  4. Installing version   0.11.0   into   ./this/other/folder
##     TargetDir=./this/other/folder TargetVersion=0.11.0 get.Nim.sh
##
#_____________________________
rootDir=$(pwd)
## @descr Sets the target folder where the binaries will be output
binDir=${TargetDir:-"$rootDir/bin"}
## @descr Sets the target version that will be installed
version=${TargetVersion:-"2-0"}
#_____________________________


#_______________________________________
# @section Internal Options
#_____________________________
# Remote Files
getZigURL="https://raw.githubusercontent.com/heysokam/get.Lang/master/get.Zig.sh"
nimPatchURL="https://raw.githubusercontent.com/heysokam/get.Lang/master/src/zigcc.patch"
zigccURL="https://raw.githubusercontent.com/heysokam/get.Lang/master/src/zigcc.nim"
# Zig
zigDir=$binDir/.zig
zig=$zigDir/zig
zccSrc="$zigDir/zigcc.nim"
zccTrg="zigcc"
# Nim
nimURL="https://github.com/nim-lang/Nim"
nimDir=$binDir/.nim
nim=$nimDir/bin/nim
nimBuilder="./build_all.sh"
nimPatch="zigcc.patch"
patch=$nimPatch


#___________________
# get.Nim
Prefix="༄ get.Nim |"
info() { echo "$Prefix $@"; }

#______________________________________________
# Install zig locally if it doesn't already exist
if [ ! -e $nim ]
then
  # Download Zig
  info "Running the get.Zig installer remotely ..."
  curl -s $getZigURL | bash
  zig=$(readlink -f -n $zig)
  #______________________________________________
  info "Downloading the ZigCC patch for Nim ..."
  curl -s $nimPatchURL > $patch
  patch=$(readlink -f -n $patch)
  #______________________________________________
  info "Done installing with get.Zig."
  prevDir=$(pwd)

  #______________________________________________
  # Download Nim
  if [ ! -d $nimDir ]
  then
    info "Downloading into:  $nimDir"
    git clone -b version-$version --depth=1 $nimURL $nimDir
  else
    info "Already downloaded. Cleaning and updating folder:  $nimDir"
    cd $nimDir
    git pull
    git clean -fdx
    git reset --hard
    cd $prevDir
  fi

  #______________________________________________
  info "Entering folder:  $nimDir"
  cd $nimDir

  #______________________________________________
  info "Compiling nim.stage1 for zigcc..."
  source $nimDir/ci/funs.sh
  CC="$zig cc" nimBuildCsourcesIfNeeded "$@"


  #______________________________________________
  info "Downloading the ZigCC alias source code ..."
  curl -s $zigccURL > $zccSrc
  #______________________________________________
  info "Compiling zigcc alias from:  $zccSrc"
  sed -i -e "s,ZIGCC,${zig},g" $zccSrc
  $nim c -d:release --hint:LineTooLong:off --hint:Conf:off --skipProjCfg --skipParentCfg --out:$zccTrg --outDir:$zigDir $zccSrc
  zigcc="$zigDir/$zccTrg"


  #______________________________________________
  info "Patching for ZigCC compilation"
  cp $patch $nimPatch
  sed -i -e "s,ZIGCC,${zigcc},g" $nimPatch
  git apply $nimPatch


  #______________________________________________
  info "Building with:  $nimDir/$nimBuilder"
  chmod +x $nimBuilder
  CC=$zigcc $nimBuilder


  #______________________________________________
  info "Returning to folder:  $prevDir"
  cd $prevDir
  #______________________________________________
  info "Installed Nim Version:"
  $nim --version
fi

