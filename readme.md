# get.Lang | Automated download of Programming Languages
`get.Lang` is a set of tools to automate the download of Programming Languages.  
It can be used either as an application, or as a collection of functions in your own code.  

```md
# Currently Supported
- Zig
- Nim
- MinC
```

## How-to
`get.Lang` can work either as a **library** or as a binary **application**.  
Both are equally supported.

```md
# Installation
nimble install https://github.com/heysokam/get.Lang
```

```md
# As an Application
get zig                     # Install zig using the default options
get nim --trgDir:./mydir    # Install nim to `./mydir`

get -h                      # List all the available options and their defaults
```

```nim
# As a Library
import get

get.zig.json.download( ... )
get.zig.bin.download( ... )

get.nim.repo.clone( ... )
get.nim.bin.build( ... )

# Every function is commented with a short explanation of what it does.
# Refer to the comments of each module to understand how to use them in your own code.
```

> **Warning**:  
> `get.Lang` is not a toolchain versioning tool _(like `rustup`, `choosenim`, etc)_.  
> The default configuration works by installing languages to `CURRENTDIR/bin/.lang`  
> It can behave as a system-wide installation if you always set the `--trgDir` to the same folder for all your projects.  
> _eg: In your `$HOME/.lang` folder, or any other folder of your choosing_.  

### Alternative Installation
`get.Lang` has a strong emphasis on not depending on existing toolchains being already installed on the system in order to bootstrap their tools.  
As such, this library provides a way to bootstrap itself.  
```md
# Requirements
git, gcc, (sh or powershell)

# Installation
git clone https://github.com/heysokam/get.Lang getlang
cd getlang
## Unix
sh ./init.ps1
## Windows
./init.ps1
```


## Won't support
`get.Lang` will never support languages that do not provide an easy way to create a `per-project` installation of its toolset, without depending on the language already being installed before-hand.  
_eg: Python_
