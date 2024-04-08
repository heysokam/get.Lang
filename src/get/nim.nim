#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview get.Nim API and cable connector to all its modules
import ./nim/repo ; export repo
import ./nim/bin  ; export bin


import ./cli as opts
proc get *(cli :Cfg) :void=
  nim.repo.clone(
    M   = cli.nimVers.M,
    m   = cli.nimVers.m,
    dir = cli.trgDir,
    ) # << nim.repo.clone( ... )
  nim.bin.build(
    dir = cli.trgDir,
    ) # << nim.bin.build( ... )

