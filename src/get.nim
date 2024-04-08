#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview Cable connector to all get.Lang modules
import ./get/zig  ; export zig
import ./get/nim  ; export nim
import ./get/minc ; export minc


#_______________________________________
# @section Binary App Entry Point
#_____________________________
when isMainModule:
  import nstd/logger
  import ./get/cfg
  import ./get/cli as opts
  logger.init(cfg.Prefix)
  let cli = opts.init()
  case cli.lang
  of Zig  : zig.get(cli)
  of Nim  : nim.get(cli)
  of MinC : minc.get(cli)
  else:discard

