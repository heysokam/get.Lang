#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps ndk
import nstd/shell
import nstd/strings
import nstd/paths


proc build *(
    dir   : Path;
    force : bool = false;
  ) :void=
  let trg = dir/"bin"/"nim"
  if fileExists(trg) and not force: return
  withDir dir:
    when defined(unix)    : sh "./build_all.sh"
    elif defined(windows) : sh "./build_all.bat"
    else                  : quit(&"Tried to install Nim for an unknown platform:  ({hostOS}, {hostCPU})")

