# From: https://github.com/enthus1ast/zigcc
import std/os
import std/osproc
# Set the zig compiler to call, append args, and Start the process
let process = startProcess(
  command = r"ZIGCC", # Path of the real Zig binary
  args    = @["cc"] & commandLineParams(),  # Add the suffix and all commandLineParams to the command
  options = {poStdErrToStdOut, poUsePath, poParentStreams},
  ) # << startProcess( ... )
# Get the code so we can carry across the exit code
let exitCode = process.waitForExit()
# Clean up
close process
quit exitCode
