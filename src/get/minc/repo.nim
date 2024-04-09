#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps ndk
import nstd/paths
import nstd/strings
import nstd/shell
# @deps get
import ../cfg

proc clone *(
    dir   : Path;
    force : bool = false;
  ) :void=
  if not dirExists(dir):
    let URL = MinC_DefaultURL
    git &"clone --depth=1 {URL} {dir}"
  withDir dir:
    git "pull"
    if force: sh "git reset --hard ; git clean -fdx"

