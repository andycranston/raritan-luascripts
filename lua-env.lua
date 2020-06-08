--
--  lua-env.lua : show the Lua environment
--

require "LuaService"

local lserv = luaservice.Manager:getDefault()

local environ = lserv:getEnvironment()

print("Lua Environment")
print("---------------")

printTable(environ)

print("---")
print("End")
