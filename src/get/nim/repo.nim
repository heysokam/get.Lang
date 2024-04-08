#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps ndk
import nstd/strings
import nstd/shell
import nstd/paths
# @deps get
import ../cfg


proc clone *(
    M     : SomeInteger;
    m     : SomeInteger;
    dir   : Path;
    force : bool = false;
  ) :void=
  let branch = &"version-{M}-{m}"
  if not dirExists(dir):
    let URL = cfg.Nim_DefaultURL
    git &"clone --depth=1 -b {branch} {URL} {dir}"
  withDir dir:
    git "pull"
    if force: sh "git reset --hard ; git clean -fdx"

