#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview Nim ZigCC compiler aliases : Manager to Write/Compile the required files
# @deps ndk
import nstd/strings
import nstd/shell
import nstd/paths
import nstd/logger


#_______________________________________
# @section ZigCC aliases: File Template
#_____________________________
let NimcZopts = "c -d:release --hint:Conf:off --hint:Link:off --skipProjCfg --skipParentCfg" # Base nimc command to build zigcc and zigcpp binaries with
const ZigccTemplate = """
# From: https://github.com/enthus1ast/zigcc
import std/os
import std/osproc
# Set the zig compiler to call, append args, and Start the process
let process = startProcess(
  command = r"{zigBin}", # Path of the real Zig binary
  args    = @["{CC}"] & commandLineParams(),  # Add the suffix and all commandLineParams to the command
  options = {{poStdErrToStdOut, poUsePath, poParentStreams}},
  ) # << startProcess( ... )
# Get the code so we can carry across the exit code
let exitCode = process.waitForExit()
# Clean up
close process
quit exitCode
"""


#_______________________________________
# @section ZigCC aliases: Source File Writing
#_____________________________
proc writeFile (
    CC      : string;
    trg     : Path;
    zigBin  : Path;
    rewrite : bool;
    verbose : bool = false;
  ) :void=
  if rewrite or not trg.fileExists:
    if verbose and not rewrite: info &"{trg} does not exist. Writing it ..."
    trg.writeFile( fmt ZigccTemplate )
#___________________
proc writeCC (
    trgDir  : Path;
    zigBin  : Path;
    rewrite : bool;
    verbose : bool = false;
  ) :void=
  ## @descr Writes the zigcc source code file to {@trgDir} if it doesn't exist
  let zigBin = trgDir/zigBin
  nimz.writeFile(
    CC      = "cc",
    trg     = trgDir/"zigcc.nim",
    zigBin  = zigBin,
    rewrite = rewrite,
    verbose = verbose,
    ) # << nimz.writeFile( ... )
#___________________
proc writeCpp (
    trgDir  : Path;
    zigBin  : Path;
    rewrite : bool;
    verbose : bool = false;
  ) :void=
  ## @descr Writes the zigcpp source code file to {@trgDir} if it doesn't exist
  let zigBin = trgDir/zigBin
  nimz.writeFile(
    CC      = "c++",
    trg     = trgDir/"zigcpp.nim",
    zigBin  = zigBin,
    rewrite = rewrite,
    verbose = verbose,
    ) # << nimz.writeFile( ... )


#_______________________________________
# @section ZigCC aliases: Building
#_____________________________
proc buildBase (
    src     : Path;
    trg     : Path;
    trgDir  : Path;
    nim     : Path;
    force   : bool;
    verbose : bool = false;
  ) :void=
  ## @descr Builds {@arg trg} into {@arg trg} with {@arg nim} if it doesn't exist
  let src = trgDir/src
  let trg = trgDir/trg
  if force or not trg.fileExists:
    let cmd = nim.string & &" {NimcZopts} --out:{trg.lastPathPart} --outDir:{trgDir} {src}"
    if verbose and not trg.fileExists: info &"{trg} does not exist. Creating it with:\n  {cmd}"
    sh cmd
  elif verbose: info &"{trg.lastPathPart} is up to date."
#___________________
proc buildCC (
    trgDir  : Path;
    nim     : Path;
    force   : bool;
    verbose : bool = false;
  ) :void=
  ## @descr Builds the zigcc binary if it doesn't exist
  nimz.buildBase(
    src     = "zigcc.nim".Path,
    trg     = "zigcc".Path,
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
    ) # << nimz.buildBase( ... )
#___________________
proc buildCpp (
    trgDir  : Path;
    nim     : Path;
    force   : bool;
    verbose : bool = false;
  ) :void=
  ## @descr Builds the zigcpp binary if it doesn't exist
  nimz.buildBase(
    src     = "zigcpp.nim".Path,
    trg     = "zigcpp".Path,
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
    ) # << nimz.buildBase( ... )


#_______________________________________
# @section ZigCC aliases: External API
#_____________________________
proc build *(
    trgDir  : Path;
    nim     : Path;
    zigBin  : Path;
    force   : bool = false;
    verbose : bool = false;
  ) :void=
  ## @descr Writes and builds the source code of both NimZ aliases when they do not exist.
  let rewrite = force or not fileExists(trgDir/zigBin)
  #___________________
  nimz.writeCC(
    trgDir  = trgDir,
    zigBin  = zigBin,
    rewrite = rewrite,
    verbose = verbose,
    ) # << nimz.writeCC( ... )
  #___________________
  nimz.writeCpp(
    trgDir  = trgDir,
    zigBin  = zigBin,
    rewrite = rewrite,
    verbose = verbose,
    ) # << nimz.writeCpp( ... )
  #___________________
  nimz.buildCC(
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
  ) # << nimz.buildCC( ... )
  #___________________
  nimz.buildCpp(
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
    ) # << nimz.buildCpp( ... )

