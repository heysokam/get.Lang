#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps std
from std/os import lastPathPart
# @deps ndk
import nstd/paths
import nstd/shell
# @deps get
import ../cfg {.all.}
import ../tools
# @deps get.zig
import ./json

#_____________________________
proc download *(
    dir     : Path;
    index   : Path = Zig_DefaultJson_Filename.Path;
    force   : bool = false;
    verbose : bool = false;
  ) :Path {.discardable.}=
  ## @descr Downloads the correct zig binaries for the current hostCPU/hostOS.
  const binName = Zig_DefaultBin.Path
  if not dir.dirExists: md dir
  let link = json.latest(dir,index).url(dir,index)
  let file = dir/link.lastPathPart
  if force or not fileExists( dir/binName ):
    tools.dl(link, file)
    withDir dir: shell.unz(file)
    let resDir = dir/file.lastPathPart.splitFile.name.splitFile.name  # Basename of the file, without extensions
    resDir.copyDirWithPermissions(dir)
    # Cleanup after done
    resDir.removeDir
  result = dir/binName

