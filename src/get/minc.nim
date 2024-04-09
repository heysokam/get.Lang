#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview get.MinC API and cable connector to all its modules
import ./minc/repo ; export repo
import ./minc/bin  ; export bin

#_____________________________
# Internal dependencies
import nstd/paths
import ./nim
import ./zig
import ./cli as opts
import ./cfg

#_______________________________________
# @section External API
#_____________________________
proc get *(
    dir     : Path;
    zigSub  : Path;
    zigJson : Path;
    nimSub  : Path;
    nimVers : NimVersion;
    mincSub : Path;
    force   : bool = false;
    verbose : bool = false;
  ) :tuple[nim:Path, zig:Path, minc:Path] {.discardable.}=
  # Install Zig (build requirement for MinC)
  let trgDir  = dir.absolutePath
  let zigDir  = trgDir/zigSub
  let nimDir  = trgDir/nimSub
  let mincDir = trgDir/mincSub
  result.zig = zig.get(
    dir     = zigDir,
    index   = zigJson,
    force   = force,
    verbose = verbose,
    ) # << zig.get( ... )
  # Install Nim (build requirement for MinC)
  result.nim = nim.get(
    dir     = nimDir,
    M       = nimVers.M,
    m       = nimVers.m,
    force   = force,
    verbose = verbose,
    ) # << nim.get( ... )
  # Install MinC
  minc.repo.clone(
    dir   = mincDir,
    force = force,
    ) # << minc.repo.clone( ... )
  result.minc = minc.bin.build(
    dir     = mincDir,
    nim     = result.nim,
    zigDir  = zigDir,
    zigBin  = result.zig.lastPathPart,
    force   = force,
    verbose = verbose,
    ) # << minc.bin.build( ... )
#_____________________________
proc get *(cli :Cfg) :void=
  # Install MinC (installs its Zig and Nim dependencies)
  minc.get(
    dir     = cli.trgDir,
    zigJson = cli.zigJson,
    zigSub  = cli.zigSub,
    nimSub  = cli.nimSub,
    nimVers = cli.nimVers,
    mincSub = cli.mincSub,
    force   = cli.force,
    verbose = cli.verbose,
    ) # << minc.get( ... )

