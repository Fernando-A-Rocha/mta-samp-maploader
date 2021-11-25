--[[
	Author: Fernando
	Script: server.lua
	
	Description:

		Parses SA-MP maps in TextureStudio format (Pawn code) and sends them to client for loading

	Commands (serverside):
		- /loadmap: loads a map by ID for every online player
		- /unloadmap: unloads a map by ID for every online player
		- /bb: teleports to Blueberry (center of map)
]]

local startTickCount = getTickCount()
local SERVER_READY = false

local parsed_maps = {}

addCommandHandler("bb", function(player) setElementPosition(player, 5,5,3.5) setElementDimension(player, 0) setElementInterior(player, 0) end, false, false)

function unloadMapCmd(thePlayer, cmd, map_id)
	if not SERVER_READY then
		return outputChatBox("Server not ready: still parsing maps.", thePlayer,255,0,0)
	end
	if not tonumber(map_id) then
		return outputChatBox("SYNTAX: /"..cmd.." [Map ID from /listmaps]", thePlayer, 255,194,14)
	end
	map_id = tonumber(map_id)

    for k, map in pairs(mapList) do
        if map.id == map_id then

			unloadMapForPlayers(map_id)
            return
        end
    end

    outputChatBox("Map ID "..map_id.." not found, check /listmaps", thePlayer, 255,0,0)
end
addCommandHandler("unloadmap", unloadMapCmd, false, false)

function loadMapCmd(thePlayer, cmd, map_id)
	if not SERVER_READY then
		return outputChatBox("Server not ready: still parsing maps.", thePlayer,255,0,0)
	end
	if not tonumber(map_id) then
		return outputChatBox("SYNTAX: /"..cmd.." [Map ID from /listmaps]", thePlayer, 255,194,14)
	end
	map_id = tonumber(map_id)

    for k, map in pairs(mapList) do
        if map.id == map_id then

            loadMapForPlayers(map_id)
            return
        end
    end

    outputChatBox("Map ID "..map_id.." not found, check /listmaps", thePlayer, 255,0,0)
end
addCommandHandler("loadmap", loadMapCmd, false, false)


function mapCheckError(text)
	outputDebugString("mapList incorrect: "..text, 0, 255,120,0)
end

function mapChecks() -- check if the dev configured all variables correctly
	
	local used_ids = {}
	for _, map in pairs(mapList) do

		-- 1.  verify IDs
		if not tonumber(map.id) then
			return false, mapCheckError("Invalid map ID '"..tostring(map.id).."'")
		else
			if map.id == 0 then
				return false, mapCheckError("Invalid map ID '"..tostring(map.id).."', must be >0")
			end

			for k,id in pairs(used_ids) do
				if id == map.id then
					return false, mapCheckError("Duplicated map ID '"..id.."'")
				end
			end

			table.insert(used_ids, map.id)
		end

		-- 2.  verify name
		if not map.name or type(map.name)~="string" then

			return false, mapCheckError("Missing/Invalid map name '"..tostring(map.name).."' for map ID "..map.id)
		end

		-- 3.  verify path
		if not map.path or type(map.path)~="string" then

			return false, mapCheckError("Missing/Invalid map path '"..tostring(map.path).."' for map ID "..map.id)
		end

		-- 4.  verify file exists
		if not fileExists(map.path) then

			return false, mapCheckError("File does not exist: '"..tostring(map.path).."' for map ID "..map.id)
		end

		-- 5.  verify interior
		if not tonumber(map.int) then

			return false, mapCheckError("Missing/Invalid interior world (int): '"..tostring(map.int).."' for map ID "..map.id)
		end

		-- 6.  verify dimension
		if not tonumber(map.dim) then

			return false, mapCheckError("Missing/Invalid dimension world (dim): '"..tostring(map.dim).."' for map ID "..map.id)
		end

		-- 7.  verify teleport pos
		if not map.pos or type(map.pos)~="table" or not (map.pos[1] and map.pos[2] and map.pos[3]) then

			return false, mapCheckError("Missing/Invalid teleport position X,Y,Z (pos): '"..tostring(map.pos).."' for map ID "..map.id)
		end

		-- 8.  verify autoload
		if (map.autoload)==nil or type(map.autoload)~="boolean" then
			
			return false, mapCheckError("Missing/Invalid autoload value (must be true or false) for map ID "..map.id)
		end

	end

	return true
end

function parseTextureStudioMaps()

	for _, map in pairs(mapList) do

		local path = ":"..getResourceName(getThisResource()).."/"..map.path
		local parsed, reason, objects_used = parseTextureStudioMap(path)
		if not (type(parsed)=="table") then
			outputDebugString("Failed to parse map ID "..map.id.." ('"..map.path.."'), reason: "..reason, 1)
		else

			-- parsed map content
			parsed_maps[map.id] = parsed
		end
	end
	
	return true
end


addEventHandler( "onResourceStart", resourceRoot, 
function (startedResource)

	if not mapChecks() then return end

	if parseTextureStudioMaps() then
		SERVER_READY = true
	end
end)

function unloadMapForPlayers(map_id)
    for k, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "samp_maps:unloadMap", resourceRoot, map_id)
	end
end

function loadMapForPlayers(map_id)
	for _, map in pairs(mapList) do
		if map.id == map_id then
			for k, player in ipairs(getElementsByType("player")) do
				triggerClientEvent(player, "samp_maps:loadMap", resourceRoot, map_id, parsed_maps[map_id], map.int,map.dim)
			end
			return
		end
	end
end

function sendResultWhenReady(player)
	if SERVER_READY then

		-- only send maps which are auto-load on startup request

		local autoload_maps = {}

		for mapid,content in pairs(parsed_maps) do
			local autoload
            for k, map in pairs(mapList) do
                if map.id == mapid then
                    autoload = map.autoload
                    break
                end
            end

            if autoload == true then
            	autoload_maps[mapid] = content
            end
		end

		startTickCount = nil
		triggerLatentClientEvent(player, "samp_maps:loadAll", resourceRoot, autoload_maps)
	else
		if (getTickCount() - startTickCount) > 10000 then

			outputDebugString("Aborting: stopping resource after waiting too long", 1)
			stopResource(getThisResource())
			return
		end

		setTimer(sendResultWhenReady, 1000, 1, player)
	end
end

addEvent("samp_maps:request", true)
function clientStartupRequest()

	if (table.size(parsed_maps)) == 0 then
		outputDebugString(getPlayerName(client).." requested maps but none had been parsed", 2)
		return
	end

	sendResultWhenReady(client)	
end
addEventHandler("samp_maps:request", resourceRoot, clientStartupRequest)


function table.size ( tab )
    local length = 0
    for _ in pairs ( tab ) do
        length = length + 1
    end
    return length
end