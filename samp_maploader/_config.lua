--[[
	Author: Fernando

	_config.lua

	All global config variables are in this file:
]]

WARN_GET_TEX_NAME_FROM_INDEX = true

WARN_GET_TEX_FROM_NAME = true

ENABLE_DEBUG_MSGS = true

ods = outputDebugString
function outputDebugString(...)
    if not (ENABLE_DEBUG_MSGS) then return true end
    return ods(...)
end