#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps std
import std/sets
from std/sequtils import toSeq
# @deps ndk
import nstd/opts
import nstd/strings
import nstd/paths
# @deps get.Lang
from ./cfg import nil
# @section Extra support for std types
func `$` *(list :HashSet[Path]) :string=  list.toSeq.join(" ")


#_______________________________________
# @section CLI types
#_____________________________
type BuildMode * = enum Debug, Release
type Lang * = enum Unknown, Zig, Nim, MinC
type NimVersion * = tuple[M:int, m:int]
type Cfg * = object
  lang     *:Lang
  verbose  *:bool
  force    *:bool
  mode     *:BuildMode
  trgDir   *:Path
  # Zig
  zigJson  *:Path
  zigBin   *:Path
  # Nim
  nimVers  *:NimVersion
  nimBin   *:Path
  # MinC
  zigSub   *:Path
  nimSub   *:Path
  mincSub  *:Path


#_______________________________________
# @section Known Commands and Options
#_____________________________
const KnownCmds  :HashSet[string]=  ["zig","nim","minc"].toHashSet
const KnownShort :HashSet[string]=  ["v","h","f"].toHashSet
const KnownLong  :HashSet[string]=  [
  "help","version","verbose","release",
  "trgDir",
  "zigJson","zigBin",
  "nimVers","nimBin",
  "mincSub", "nimSub", "zigSub",
  ].toHashSet


#_______________________________________
# @section Help and Error Management
#_____________________________
const Help = """
{cfg.Prefix}  Usage
  get [lang] -(opt)

 Usage  Options (single letter)
  -h   : Print this notice and quit
  -v   : Activate verbose mode
  -f   : Force downloading as if the target didn't exist yet

 Usage  Options (word)
  --help          : Print this notice and quit
  --version       : Print the version and quit
  --verbose       : Activate verbose mode
  --force         : Same as -f
  --trgDir:path   : Define the path where the language will be output (default: getCurrentDir/bin/.lang)
  # Zig Options  : ______________________________________________________
  --zigJson:path  : Define the path where Zig's index.json will be output (default: trgDir/{cfg.Zig_DefaultJson_Filename})
  --zigBin:name   : Define the name of the Zig's binary (default: {cfg.Zig_DefaultBin})
  # Nim Options  : ______________________________________________________
  --nimVers:vers  : Define the nim version to download. (default: {cfg.Nim_DefaultVersion})
  --nimBin:name   : Define the name of the Nim's binary (default: {cfg.Nim_DefaultBin})
  # MinC Options : ______________________________________________________
  --mincSub:path  : (minc only) Subfolder of --trgDir where MinC will be installed  (default: {cfg.MinC_DefaultSub})
  --nimSub:path   : (minc only) Subfolder of --trgDir where Nim will be installed   (default: {cfg.Nim_DefaultSub})
  --zigSub:path   : (minc only) Subfolder of --trgDir where Zig will be installed   (default: {cfg.Zig_DefaultSub})

  # TBD
  --release       : ...

 Usage  Downloading Languages
          --=|=--
  [cmd]      | Description
  ___________|__________________________________________
  zig        | Download Zig by parsing the official zig index.json file
  nim        | Download Nim by cloning the official repository and bootstrapping the binaries with their `build_all` scripts
  minc       | Download MinC. Depends on zig and nim. Both will be downloaded, and MinC will be cloned and compiled with ZigCC.
  ___________|__________________________________________
"""
proc stopAndHelp= quit fmt Help
proc stopAndVersion= quit fmt """
{cfg.Prefix}  Version  {cfg.Version}"""
proc err (msg :string) :void=
  echo &"{cfg.Prefix}  Error  {msg}"
  stopAndHelp()
proc check (cli :opts.CLI) :void=
  if "version" in cli.opts.long  : stopAndVersion()
  if "h" in cli.opts.short       : stopAndHelp()
  for opt in cli.opts.long       :
    if opt notin KnownLong       : err "Found an unknown long option: "&opt
  for opt in cli.opts.short      :
    if opt notin KnownShort      : err "Found an unknown short option: "&opt
  if cli.args.len < 1            : err "Called without arguments."
  if cli.args.len != 1           : err "Called with an incorrect number of arguments: " & $cli.args.len
  if cli.args[0] notin KnownCmds : err "Found an unknown command: "&cli.args[0]


#_______________________________________
# @section Special Options
#_____________________________
func getLang (cli :opts.CLI) :Lang=
  case cli.args[0]
  of "zig"  : Lang.Zig
  of "nim"  : Lang.Nim
  of "minc" : Lang.MinC
  else      : Lang.Unknown
#___________________
func getNimVers (cli :opts.CLI) :NimVersion=
  let vers = ( if "nimVers" in cli.opts.long: cli.getLong("nimVers") else: cfg.Nim_DefaultVersion ).split(".")
  assert vers.len == 2, "Something went wrong when parsing the nimVers field. Expected format  --nimVers:M.m   (eg: 2.0)"
  result.M = vers[0].parseInt
  result.m = vers[1].parseInt
#___________________
func getDefaultDir (lang :Lang) :Path=
  let langName = strings.toLowerAscii $lang
  result = cfg.All_DefaultBaseDir.Path / &".{langName}"


#_______________________________________
# @section External API
#_____________________________
proc init *() :Cfg=
  let cli = opts.getCli()
  cli.check()
  # Lang Selection
  result.lang     = cli.getLang()
  # General Options
  result.verbose  = "v" in cli.opts.short or "verbose" in cli.opts.long
  result.force    = "f" in cli.opts.short or "force" in cli.opts.long
  result.mode     = if "release" in cli.opts.long: Release else: Debug
  result.trgDir   = if "trgDir" in cli.opts.long: cli.getLong("trgDir").Path else: getDefaultDir(result.lang)
  # Lang-Specific options
  # └─ Zig
  result.zigJson  = if "zigJson" in cli.opts.long: cli.getLong("zigJson").Path else: cfg.Zig_DefaultJson_Filename.Path
  result.zigBin   = if "zigBin"  in cli.opts.long: cli.getLong("zigBin").Path  else: cfg.Zig_DefaultBin.Path
  # └─ Nim
  result.nimVers  = cli.getNimVers()
  result.nimBin   = if "nimBin" in cli.opts.long: cli.getLong("nimBin").Path else: cfg.Nim_DefaultBin.Path
  # └─ MinC
  result.zigSub   = if "zigSub"  in cli.opts.long: cli.getLong("zigSub").Path  else: cfg.Zig_DefaultSub.Path
  result.nimSub   = if "nimSub"  in cli.opts.long: cli.getLong("nimSub").Path  else: cfg.Nim_DefaultSub.Path
  result.mincSub  = if "mincSub" in cli.opts.long: cli.getLong("mincSub").Path else: cfg.MinC_DefaultSub.Path

