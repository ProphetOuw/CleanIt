# CleanIt
A LUAU memory cleaner, it's a simple package that helps you clean memory.
- Functions
- Instances
- Connections
- Threads
- Tables
- Anything with a Destroy function
> [!CAUTION]
> If you are sending in functions or objects with custom destroy functions, make sure there is error handling in those functions. **All** yields in any destroy functions will effect all of the other elements in the CleanIt cleaning list.
## Installation
### Roblox
### Wally
### Github
To download this from the github, see the releases section and download the latest rbxm file.
## Methods
### Add
Adds the Entity to the cleaning list.
```lua
local Cleaner = CleanIt.New()
Cleaner.Add(object1)
Cleaner:Destroy()
```
If you want custom cleaning logic you can use functions:
```lua
local Object = workspace.Object
Cleaner.Add(function()
    Object.Name = "--";
    Object:Destroy()
end)
```
### Destroy
Cleans everything in the CleanIt cleaning list and itself.
```lua
Cleaner.Add(object1)
Cleaner:Destroy()
```