#!/bin/sh
set -eu
#:__________________________________________________________________________
#  ༄  get.Zig  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
#:__________________________________________________________________________
## @fileoverview
##  Automatic download of Zig using zvm into a local folder.
##
##  - Does not change your global environment in any way.
##  - Does nothing if the target binary already exists.
##  - You can call it repeatedly without worry.
##
#__________________________________________________________________________|
##
## @howto
##  Set these variables in CLI before calling the script to change the behavior of the script.
##
##  Examples:
##  0. Using the default options remotely
##     curl https://raw.githubusercontent.com/heysokam/get.Lang/master/get.Zig.sh | bash
##
##  1. Using the default options
##     get.Zig.sh
##
##  2. Installing into  ./some/other/dir
##     TargetDir=./some/other/dir get.Zig.sh
##
##  3. Installing version 0.12.0
##     TargetVersion=0.12.0 get.Zig.sh
##
##  4. Installing version   0.11.0   into   ./this/other/folder
##     TargetDir=./this/other/folder TargetVersion=0.11.0 get.Zig.sh
##
#_____________________________
## @descr Sets the target folder where the binaries will be output
binDir=${TargetDir:-"./bin"}
## @descr Sets the target version that will be installed
version=${TargetVersion:-"0.14.0"}
#_____________________________


#_______________________________________
# @section Internal Options
#_____________________________
# zvm
zvmSub=.zvm
zvmDir=$binDir/$zvmSub
zvmInstall="$zvmDir/install.sh"
zvm=$zvmDir/self/zvm
#___________________
# Zig
zigDir=$binDir/.zig
zig=$zigDir/zig

#___________________
# get.Zig
Prefix="༄ get.Zig |"
info() { echo "$Prefix $@"; }

#______________________________________________
# Install zig locally if it doesn't already exist
if [ ! -e $zig ]
then
  # Download zvm
  info "Creating zvm folder at:  $zvmDir"
  mkdir -p $zvmDir
  info "Downloading and Running the zvm installer at:  $zvmInstall"
  curl https://raw.githubusercontent.com/tristanisham/zvm/master/install.sh > $zvmInstall
  chmod +x $zvmInstall
  HOME=$binDir $zvmInstall
  # Download Zig
  info "Downloading Zig into:  $zigDir"
  HOME=$binDir $zvm install $version
  ln -s $(realpath $zvmDir/$version) $zigDir
  info "Installed Zig Version:"
  $zig version
fi

