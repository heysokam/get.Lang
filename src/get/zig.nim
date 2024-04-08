#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview get.Zig API and cable connector to all its modules
import ./zig/json ; export json
import ./zig/bin  ; export bin


import ./cli as opts
proc get *(cli :Cfg) :void=
  echo cli
  zig.json.download(
    dir     = cli.trgDir,
    index   = cli.zigJson,
    ) # << zig.json.download( ... )
  zig.bin.download(
    dir     = cli.trgDir,
    index   = cli.zigJson,
    force   = cli.force,
    binName = cli.zigBin,
    ) # << zig.bin.download( ... )

