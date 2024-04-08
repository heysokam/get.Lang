#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
from nstd/paths import Path


#_______________________________________
# @section Package Information
#_____________________________
const Version *{.strdefine.}= "dev." & gorge "git --no-pager log -n 1 --pretty=format:%H"

#_______________________________________
# @section Format
#_____________________________
const Tab    *{.strdefine.}= "  "
const Prefix *{.strdefine.}= "Ж getLang"


#_______________________________________
# @section All Langs Configuration
#_____________________________
const All_DefaultBaseDir *{.strdefine.}= "bin"

#_______________________________________
# @section Zig Configuration
#_____________________________
const Zig_DefaultJson_Filename *{.strdefine.}= "versions.json"
const Zig_DefaultJson_URL      *{.strdefine.}= "https://ziglang.org/download/index.json"
const Zig_MasterVersion_Name    {.strdefine.}= "master"
const Zig_DefaultVersion       *{.strdefine.}= Zig_MasterVersion_Name
const Zig_DefaultBin           *{.strdefine.}= "zig"

#_______________________________________
# @section Nim Configuration
#_____________________________
const Nim_DefaultURL     *{.strdefine.}= "https://github.com/nim-lang/Nim"
const Nim_DefaultBin     *{.strdefine.}= "nim"
const Nim_DefaultVersion *{.strdefine.}= "2.0"

