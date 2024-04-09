#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps std
import std/json as Json
# @deps External
import pkg/jsony
# @deps ndk
import nstd/strings
import nstd/paths
# @deps get
import ../tools
import ../cfg {.all.}
# @deps get.zig
import ./types


#_______________________________________
# @section Error Management
#_____________________________
type ZigJsonError = object of CatchableError
template err (msg :string) :void= raise newException(ZigJsonError, msg)


#_______________________________________
# @section Downloading
#_____________________________
proc yesterday (
    dir   : Path = getCurrentDir();
    index : Path = Zig_DefaultJson_Filename.Path;
  ) :bool=
  ## @descr Returns true if the file at {@arg dir}/{@arg index} hasn't been updated in the last 24h.
  (dir/index).noModSince(hours = 24)
#___________________
proc download (
    url   : string = Zig_DefaultJson_URL;
    dir   : Path   = getCurrentDir();
    index : Path   = Zig_DefaultJson_Filename.Path;
  ) :string {.discardable.}=
  ## @descr Downloads the latest zig.index.json versions file from {@arg URL} and saves it into {@arg dir}/{@arg index}
  ## @note Returns the raw json data as a discardable string
  tools.dl url, dir/index
  result = readFile(dir/index)
#___________________
proc download *(
    dir     : Path;
    index   : Path = Zig_DefaultJson_Filename.Path;
    verbose : bool = false;
  ) :string {.discardable.}=
  ## @descr Downloads the latest zig.index.json versions file and saves it into {@arg dir}/{@arg index}
  ## @note Returns the raw json data as a discardable string
  if not dirExists(dir): err &"Tried to download Zig's version list into a folder that does not exist:  {dir}"
  if not json.yesterday(dir,index): return readFile(dir/index)
  result = json.download(Zig_DefaultJson_URL, dir,index)


#_______________________________________
# @section Parsing
#_____________________________
proc parse (
    dir   : Path;
    file  : Path = Zig_DefaultJson_Filename.Path;
  ) :ZigIndex=
  ## @descr
  ##  Parses the downloaded zig download index json at {@arg dir}/{@arg file}, and returns a {@link ZigIndex} object.
  ##  Downloads the file if it does not already exist, unless {@arg downl} is omitted or false.
  let trg = dir/file
  for name,val in trg.readFile.fromJson().pairs:
    result.add ZigVersion(name: name, data: val.toJson.fromJson(ZigData))


#_______________________________________
# @section Version Management: Host
#_____________________________
proc zigCPU (cpu :string= hostCPU) :string=
  ## @descr Returns the zig version of the {@arg CPU} string. Defaults to current host.
  case cpu
  of "amd64": result = "x86_64"
  else:       result = cpu
#___________________
proc zigOS (os :string= hostOS) :string=
  ## @descr Returns the zig version of the {@arg OS} string. Defaults to current host.
  case os
  of "macosx": result = "macos"
  else:        result = os
#_____________________________
proc file (data :ZigData) :ZigFile=
  ## @descr Returns the file information to download the correct version for the current hostOS+hostCPU.
  let syst = &"{zigCPU()}-{zigOS()}"
  for name,val in data.fieldPairs:
    when val is ZigFile:
      if syst == name: return val


#_______________________________________
# @section Version Management: Latest non-master
#_____________________________
proc latestData (index :ZigIndex) :ZigData=
  ## @descr Returns the data for the latest non-master version available stored at {@arg index}
  for ver in index:
    if ver.name == Zig_MasterVersion_Name: continue
    result = ver.data
    if result.version == "":
      result.version = ver.name  # Add entry name as version. Entries don't have subversion
    return                       # exit on first hit
#___________________
proc latest (index :ZigIndex) :string=
  ## @descr Returns the name of the latest non-master version available in the parsed {@arg index}.
  result = index.latestData.version
#___________________
proc latest *(
    dir   : Path;
    file  : Path = Zig_DefaultJson_Filename.Path;
  ) :string=
  ## @descr Returns the name of the latest non-master version available, as described in the {@arg dir}/{@arg file} json.
  json.parse(dir,file).latest()


#_______________________________________
# @section URL Management
#_____________________________
proc url (file :ZigFile) :string=  file.tarball
  ## @descr Returns the url to download the {@arg file} url contained in its {@link ZigFile} data.
#___________________
proc url (data :ZigData) :string=  data.file.url
  ## @descr Returns the url to download the correct version for the current hostOS+hostCPU, as described in the {@arg data} {@link ZigData} object.
#_____________________________
proc url (vers :string; index :ZigIndex) :string=
  ## @descr Returns a string with the `trg` version url from the given parsed {@arg index}.
  for ver in index:
    if ver.name == vers: return ver.data.url
#___________________
proc url *(
    vers  : string;
    dir   : Path;
    file  : Path = Zig_DefaultJson_Filename.Path;
  ) :string=
  ## @descr Returns a string with the `trg` version url.
  json.url(vers, json.parse(dir,file) )

