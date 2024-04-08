#:___________________________________________________________
## get.Lang  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:___________________________________________________________
# @deps std
{.define:ssl.}
import std/httpclient as http
# @deps ndk
import nstd/strings
import nstd/logger
import nstd/paths


#_______________________________________
proc dl *(url :string; trgFile :Path; report :bool= true) :void=
  let client = newHttpClient()
  if report: info &"Downloading {url}  as  {trgFile} ..."
  client.downloadFile(url, trgFile.string)
  client.close()
