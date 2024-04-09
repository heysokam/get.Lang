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
    zigDir  : Path;
    nimDir  : Path;
    zigBin  : Path = cfg.Zig_DefaultBin.Path;
    nimBin  : Path = cfg.Nim_DefaultBin.Path;
    force   : bool = false;
    verbose : bool = false;
  ) :void=
  minc.repo.clone(
    dir   = dir.absolutePath,
    force = force,
    ) # << minc.repo.clone( ... )
  minc.bin.build(
    dir     = absolutePath dir,
    nim     = absolutePath nimDir/"bin"/nimBin,
    zigDir  = zigDir,
    zigBin  = zigBin,
    force   = force,
    verbose = verbose,
    ) # << minc.bin.build( ... )
#_____________________________
proc get *(cli :Cfg) :void=
  # Install Zig (build requirement for MinC)
  zig.get(
    dir     = cli.trgDir/cli.zigSub,
    index   = cli.zigJson,
    binName = cli.zigBin,
    force   = cli.force,
    verbose = cli.verbose,
    ) # << zig.get( ... )
  # Install Nim (build requirement for MinC)
  nim.get(
    M       = cli.nimVers.M,
    m       = cli.nimVers.m,
    dir     = cli.trgDir/cli.nimSub,
    force   = cli.force,
    verbose = cli.verbose,
    ) # << nim.get( ... )
  # Install MinC
  minc.get(
    dir     = cli.trgDir/cli.mincSub,
    zigDir  = cli.trgDir/cli.zigSub,
    nimDir  = cli.trgDir/cli.nimSub,
    zigBin  = cli.zigBin,
    nimBin  = cli.nimBin,
    force   = cli.force,
    verbose = cli.verbose,
    ) # << minc.get( ... )

