#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps ndk
import confy

# Configure
confy.cfg.nim.systemBin = off

# Build
build Program.new(
  src  = cfg.srcDir/"get.nim",
  deps = Dependencies.new(
    submodule( "nstd",  "https://github.com/heysokam/nstd"  ),
    submodule( "jsony", "https://github.com/treeform/jsony" ),
    ), # << Dependencies.new( ... )
  ) # << Program.new( ... )
