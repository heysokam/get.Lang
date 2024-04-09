#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview get.Nim API and cable connector to all its modules
import ./nim/repo ; export repo
import ./nim/bin  ; export bin
import ./nim/nimz ; export nimz

#_____________________________
# Internal dependencies
from nstd/paths import Path, absolutePath
import ./cli as opts


#_______________________________________
# @section External API
#_____________________________
proc get *(
    M       : SomeInteger;
    m       : SomeInteger;
    dir     : Path;
    force   : bool = false;
    verbose : bool = false;
  ) :Path {.discardable.}=
  nim.repo.clone(
    M       = M,
    m       = m,
    dir     = dir.absolutePath,
    force   = force,
    verbose = verbose,
    ) # << nim.repo.clone( ... )
  result = nim.bin.build(
    dir     = dir.absolutePath,
    force   = force,
    verbose = verbose,
    ) # << nim.bin.build( ... )
#_____________________________
proc get *(cli :Cfg) :void=
  nim.get(
    M       = cli.nimVers.M,
    m       = cli.nimVers.m,
    dir     = cli.trgDir,
    force   = cli.force,
    verbose = cli.verbose,
    ) # << nim.get( ... )

