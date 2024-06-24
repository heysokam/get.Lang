#!/usr/bin/env sh
# @fileoverview
#  Combined Shell and PowerShell initialization script.
#  It's only goal is to build a local copy of Nim

#_______________________________________
# @section Shell Initialization
#____________________________
# Don't use  #＞ directly  (e.g.  #"">   or similar).
# Otherwise the Bash section would be exited and Bash would try to execute Powershell code.
echo --% >/dev/null;: ' | out-null
<#'
#____________________________
# Bash tools
set -u # error on undefined variables
set -e # exit on first error
# General Config
nimMaj=2              # Major nim version that MinC tracks
nimMin=0              # Minor nim version that MinC tracks
Prefix="༄ get.Lang:"  # Prefix to append to all console info messages
# Project setup
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
rootDir="$thisDir"        # Find the root folder of the repository
binDir="$rootDir/bin"     # Binaries output folder
srcDir="$rootDir/src"     # Source code folder
nimDir="$binDir/.nim"     # nim submodule folder (absolute)
nimBranch="version-$nimMaj-$nimMin"  # Name of the Nim branch that MinC tracks
nim="$nimDir/bin/nim"     # Nim binary result after it has been bootstrapped
echo "$Prefix Initializing MinC binaries from Bash ..."

#____________________________
# Init nimDir
[ ! -d $binDir ] && mkdir $binDir;
[ ! -d $nimDir ] && git clone --depth=1 -b $nimBranch https://github.com/nim-lang/Nim $nimDir
# Build Nim and come back
prev=$PWD
cd $nimDir
sh ./build_all.sh
cd $prev
# Run the main initializer process
# $nimDir/bin/nim c -r --outDir:$binDir $srcDir/build/init.nim

echo "$Prefix Finished initializing MinC binaries."
#____________________________
# end bash section
exit #>
#____________________________



#_______________________________________
# @section PowerShell Initialization
#   No need to escape anything. Shell cannot reach this section.
#___________________
# Helpers
function dirExists  ($dir) { Test-Path -PathType Container $dir }
function fileExists ($dir) { Test-Path -PathType Leaf      $dir }
# General Config
$nimMaj=2              # Major nim version that MinC tracks
$nimMin=0              # Minor nim version that MinC tracks
$Prefix="༄ get.Lang:"  # Prefix to append to all console info messages
# Project Setup
$binDir="./bin"
$nimDir="$binDir/.nim"
#____________________________
echo "$Prefix Running PowerShell init section..."

# Init Nim
if ( !(dirExists $binDir) ) { md $binDir }
if ( !(dirExists $nimDir) ) { git clone -b version-$nimMaj-$nimMin --depth=1 https://github.com/nim-lang/Nim $nimDir }

# Build Nim and come back
$prev=pwd
cd $nimDir
./build_all.bat
cd $prev

# Run the main initializer process
# $nimDir/bin/nim c -r --outDir:$binDir $srcDir/build/init.nim

echo "$Prefix Finished PowerShell init."
#____________________________


