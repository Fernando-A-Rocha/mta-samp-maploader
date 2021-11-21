--[[
	Author: Fernando
	Script: client.lua
	
	Description:

		Loads SA-MP maps in TextureStudio format (Pawn code)

    Commands (clientside):
        - /listmaps: lists all maps defined in list.lua inside mapList
]]

local loaded_maps = {}
local last_object

function listMaps(cmd)
    for k, map in pairs(mapList) do
        local status = loaded_maps[map.id] and ("#89ff6b[LOADED] #d1d1d1("..(#(loaded_maps[map.id].objects).." objects)")) or "#ff9c9c[NOT LOADED]"
        outputChatBox(status.." #ffc67a(ID "..map.id..") #ffa126'"..map.name.."' #ffffffint: "..map.int.." dim: "..map.dim, 255,126,0, true)
    end
end
addCommandHandler("listmaps", listMaps, false)


function loadTextureStudioMap(mapid,parsed,int,dim)

    if loaded_maps[mapid] then
        return false, "Already loaded"
    end

    loaded_maps[mapid] = { -- store elements so the map can be unloaded
        models = {},
        objects = {},
        materials = {},
        removals = {},
    }

    int = int or 0
    dim = dim or 0

    local filename = ""
    local mapname = ""
    for k,map in pairs(mapList) do
        if map.id == mapid then
            filename = map.path
            mapname = map.name
            break
        end
    end
    -- Async:foreach(parsed, function(v)
    for _, v in pairs(parsed) do

        if v.f == "model" then
            local baseid, newid, dffname, txdname = unpack(v.variables)
            table.insert(loaded_maps[mapid].models, newid)
        elseif v.f == "object" then
            local obj,lod = createMapObject(unpack(v.variables))
            last_object = obj

            if isElement(obj) then

                setElementInterior(obj,int)
                setElementDimension(obj,dim)

                if isElement(lod) then
                    setElementInterior(lod,int)
                    setElementDimension(lod,dim)
                    
                    table.insert(loaded_maps[mapid].objects, {last_object, lod})
                else
                    table.insert(loaded_maps[mapid].objects, {last_object})
                end


            end
        elseif v.f == "material" then
            if isElement(last_object) then
                local mat_index,model_id,tex_name,color = unpack(v.variables)
                local elements = setObjectMaterial(last_object, mat_index,model_id,tex_name,color)
                if type(elements) == "table" then
                    table.insert(loaded_maps[mapid].materials, {
                        model = model_id,
                        elements = elements,
                    })
                end
            end
        elseif v.f == "remove" then
            local model,radius,x,y,z = unpack(v.variables)
            if removeWorldModel(model,radius,x,y,z,int) then
                table.insert(loaded_maps[mapid].removals, {
                    model,radius,x,y,z,int
                })
            end
        end
    end
    -- end)

    last_object = nil

    outputDebugString("Map '"..mapname.."' (ID "..mapid..") loaded")
    return true
end

function unloadTextureStudioMap(mapid)
    if not loaded_maps[mapid] then
        return false, "Map not loaded"
    end

    local mapname = ""
    for k,map in pairs(mapList) do
        if map.id == mapid then
            mapname = map.name
            break
        end
    end

    local icounts = {
        materials = #(loaded_maps[mapid].materials),
        models = #(loaded_maps[mapid].models),
        objects = #(loaded_maps[mapid].objects),
        removals = #(loaded_maps[mapid].removals),
    }

    local counts = {
        materials = 0,
        models = 0,
        objects = 0,
        removals = 0,
    }
    
    
    for k,v in pairs(loaded_maps[mapid].materials) do -- important cleanup
    -- Async:foreach(loaded_maps[mapid].materials, function(v)

        local elements = v.elements
        for j,w in pairs(elements) do
            if isElement(w) then
                destroyElement(w)
            end
        end

        counts.materials = counts.materials + 1
    end
    -- end)

    for k,v in pairs(loaded_maps[mapid].models) do
    -- Async:foreach(loaded_maps[mapid].models, function(v)
        counts.models = counts.models + 1
    end
    -- end)

    for k,v in pairs(loaded_maps[mapid].objects) do
    -- Async:foreach(loaded_maps[mapid].objects, function(v)
        for j,w in pairs(v) do
            if isElement(w) then
                destroyElement(w)
                counts.objects = counts.objects + 1
            end
        end
    end
    -- end)

    for k,v in pairs(loaded_maps[mapid].removals) do
    -- Async:foreach(loaded_maps[mapid].removals, function(v)
        local model,radius,x,y,z,int = unpack(v)
        restoreWorldModel(model,radius,x,y,z,int)
        counts.removals = counts.removals + 1
    end
    -- end)

    outputDebugString("Map '"..mapname.."' (ID "..mapid..") unloaded, stats:")
    outputDebugString("=> "..counts.materials.."/"..icounts.materials.." materials cleaned", 0,255,255,255)
    outputDebugString("=> "..counts.models.."/"..icounts.models.." models cleaned", 0,255,255,255)
    outputDebugString("=> "..counts.objects.."/"..icounts.objects.." objects cleaned", 0,255,255,255)
    outputDebugString("=> "..counts.removals.."/"..icounts.removals.." removals cleaned", 0,255,255,255)

    loaded_maps[mapid] = nil
    return true
end

function doUnloadTextureStudioMap(mapid)

    local unloaded, reason = unloadTextureStudioMap(mapid)
    if not unloaded then
        outputDebugString("Failed to unload map ID "..mapid..", reason: "..reason)
    end
end
addEvent("samp_maps:unloadMap", true)
addEventHandler("samp_maps:unloadMap", resourceRoot, doUnloadTextureStudioMap)

function doLoadTextureStudioMap(mapid,parsed,int,dim)

    local loaded, reason = loadTextureStudioMap(mapid, parsed, int, dim)
    if not loaded then
        outputDebugString("Failed to load map ID "..mapid..", reason: "..reason)
    end
end
addEvent("samp_maps:loadMap", true)
addEventHandler("samp_maps:loadMap", resourceRoot, doLoadTextureStudioMap)

function clientStartupLoad(parsed_maps)

    for id, parsed in pairs(parsed_maps) do

        local int,dim
        for k, map in pairs(mapList) do
            if map.id == id then
                int = map.int
                dim = map.dim
                break
            end
        end

        local loaded, reason = loadTextureStudioMap(id, parsed, int, dim)
        if not loaded then
            outputDebugString("(startup) Failed to load map ID "..id..", reason: "..reason)
        end
    end
end
addEvent("samp_maps:loadAll", true)
addEventHandler("samp_maps:loadAll", resourceRoot, clientStartupLoad)

local attempts = 0
function requestMapsWhenReady()
    if exports.newmodels:isClientReady() then
        triggerLatentServerEvent("samp_maps:request", resourceRoot)
    else
        if attempts == 10 then
            outputChatBox("Not loading SA-MP maps: 'newmodels' didn't send mod list to client", 255,0,0)
            return
        end
        attempts = attempts + 1
        setTimer(requestMapsWhenReady, 1000, 1)
    end
end

addEventHandler( "onClientResourceStart", resourceRoot, 
function (startedResource)
    requestMapsWhenReady()
end)

addEventHandler( "onClientResourceStop", resourceRoot, 
function (startedResource)
    for mapid,v in pairs(loaded_maps) do
        unloadTextureStudioMap(mapid)
    end
end)