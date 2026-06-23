# Wavefront Object Loader
A simple module for parsing and loading [Wavefront `.obj`](https://en.wikipedia.org/wiki/Wavefront_.obj_file) files in Lua.

## Example Usage
```lua
local obj = require("obj")
local cube = obj.load("cube.obj")

assert(cube ~= nil)
```