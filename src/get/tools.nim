#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps std
{.define:ssl.}
import std/httpclient as http
# @deps ndk
import nstd/strings
import nstd/paths
import nstd/logger
# @deps get
from ./cfg import nil


#_______________________________________
# @section Download Tools
#_____________________________
proc dl *(url :string; trgFile :Path; report :bool= true) :void=
  let client = newHttpClient()
  if report: info &"Downloading {url}  as  {trgFile} ..."
  client.downloadFile(url, trgFile.string)
  client.close()


#_______________________________________
# @section Buildsystem Tools
#_____________________________
proc submodule *(libDir :Path; name,url :string; sub :string= "src") :Path=
  ## @descr Simple replacement for `@heysokam/confy`'s submodule function
  let dir = libDir/name
  if not dirExists(dir): git &"clone {url} {dir}"
  result = libDir/name/sub

