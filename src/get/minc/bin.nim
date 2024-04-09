#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps ndk
import nstd/shell
import nstd/strings
import nstd/paths
import nstd/logger
# @deps get
import ../tools
# @deps get.nim
import ../nim/nimz

#_______________________________________
# @section MinC compile command template
#_____________________________
const BuildTempl = nimz.CCTempl & " --nimcache:{cacheDir} --path:{nstd} --path:{slate} --outDir:{binDir} {src}"


#_______________________________________
# @section External API
#_____________________________
proc build *(
    dir     : Path;
    nim     : Path;
    zigDir  : Path;
    zigBin  : Path;
    force   : bool = false;
    verbose : bool = false;
  ) :void=
  let (zigcc, zigcpp) = nimz.build(
    trgDir  = zigDir,
    nim     = nim,
    zigBin  = zigBin,
    force   = force,
    verbose = verbose,
    ) # << bin.buildNimZ( ... )
  # MinC Buildsystem: Minimalist Confy Replacement
  #  └─ Folders
  let rootDir  = dir.absolutePath
  let srcDir   = rootDir/"src"
  let binDir   = rootDir/"bin"
  let libDir   = srcDir/"lib"
  let cacheDir = binDir/".cache"
  #  └─ Dependencies
  let nstd     = tools.submodule( libDir, "nstd",  "https://github.com/heysokam/nstd"  )
  let slate    = tools.submodule( libDir, "slate", "https://github.com/heysokam/slate" )
  #  └─ Source Code
  let src      = srcDir/"minc.nim"
  #  └─ Compile
  sh fmt BuildTempl

