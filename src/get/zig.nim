#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview get.Zig API and cable connector to all its modules
import ./zig/json ; export json
import ./zig/bin  ; export bin

#_____________________________
# Internal dependencies
from nstd/paths import Path, dirExists, absolutePath
from nstd/shell import md
import ./cli as opts

#_______________________________________
# @section External API
#_____________________________
proc get *(
    dir     : Path;
    index   : Path;
    force   : bool;
    verbose : bool = false;
  ) :Path {.discardable.}=
  if not dirExists(dir): md dir
  zig.json.download(
    dir     = dir.absolutePath,
    index   = index,
    verbose = verbose,
    ) # << zig.json.download( ... )
  result = zig.bin.download(
    dir     = dir.absolutePath,
    index   = index,
    force   = force,
    verbose = verbose,
    ) # << zig.bin.download( ... )
#_____________________________
proc get *(cli :Cfg) :void=
  zig.get(
    dir     = cli.trgDir,
    index   = cli.zigJson,
    force   = cli.force,
    verbose = cli.verbose,
    ) # << zig.get( ... )
