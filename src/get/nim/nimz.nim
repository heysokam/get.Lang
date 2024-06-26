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
# @section ZigCC aliases: Compiler Command Template
#_____________________________
const CCTempl * = "{nim} {nimBackend} -d:zig --cc:clang --clang.exe=\"{zigcc}\" --clang.linkerexe=\"{zigcc}\" --clang.cppCompiler=\"{zigcpp}\" --clang.cppXsupport=\"-std=c++20\""
  ## @descr
  ##  Provides a template command for compiling Nim with ZigCC
  ##  Provide the required variables in your code, prefix the string with `fmt` or `&` from `std/strformat`, and execute the command
  ## @note You have to add your target source file, output folder, or any other Nim compiler options that you require
  ##
  ## @param cacheDir Folder where the Nim's cache files will be written.
  ## @param nim Path to the Nim binary. Can be relative, absolute or on $PATH
  ## @param zigcc Path to the zigcc alias binary. Can be relative, absolute or on $PATH
  ## @param zigcpp Path to the zigcpp alias binary. Can be relative, absolute or on $PATH
  ##
  ## @reference
  ##  clang.cppCompiler = "zigcpp"
  ##  clang.cppXsupport = "-std=C++20"
  ##  nim c --cc:clang --clang.exe="zigcc" --clang.linkerexe="zigcc" --opt:speed hello.nim
  #_______________________________________


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
  ) :Path=
  ## @descr Builds the zigcc binary if it doesn't exist
  let trg = "zigcc".Path
  nimz.buildBase(
    src     = "zigcc.nim".Path,
    trg     = trg,
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
    ) # << nimz.buildBase( ... )
  result = trgDir/trg
#___________________
proc buildCpp (
    trgDir  : Path;
    nim     : Path;
    force   : bool;
    verbose : bool = false;
  ) :Path=
  ## @descr Builds the zigcpp binary if it doesn't exist
  let trg = "zigcpp".Path
  nimz.buildBase(
    src     = "zigcpp.nim".Path,
    trg     = trg,
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
    ) # << nimz.buildBase( ... )
  result = trgDir/trg


#_______________________________________
# @section ZigCC aliases: External API
#_____________________________
proc build *(
    trgDir  : Path;
    nim     : Path;
    zigBin  : Path;
    force   : bool = false;
    verbose : bool = false;
  ) :tuple[cc:Path, cpp:Path] {.discardable.}=
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
  result.cc = nimz.buildCC(
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
  ) # << nimz.buildCC( ... )
  #___________________
  result.cpp = nimz.buildCpp(
    trgDir  = trgDir,
    nim     = nim,
    force   = force,
    verbose = verbose,
    ) # << nimz.buildCpp( ... )

