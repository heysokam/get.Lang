# @deps std
from std/os import `/`

# Package Information
version       = "0.0.0"
author        = "sOkam"
description   = "get.Lang | Automated download of Programming Languages"
license       = "LGPL-3.0-or-later"

# Installation Options
srcDir        = "src"
binDir        = "bin"
installExt    = @["nim"]
skipFiles     = @[srcDir/"build.nim", "build.nim", "build"]
bin           = @["get"]

# Build Requirements
requires "nim >= 1.9.1"
requires "jsony"
requires "https://github.com/heysokam/nstd#head"

