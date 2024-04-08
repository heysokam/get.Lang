#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @fileoverview get.MinC API and cable connector to all its modules
# import ./minc/repo ; export repo
# import ./minc/bin  ; export bin


import ./cli as opts
proc get *(cli :Cfg) :void=
  echo cli
