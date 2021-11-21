--[[
    Credits: Fernando, gta191977649
    
    Shared Functions
]]

function isDefaultObject(model)
    return exports.newmodels:isDefaultID("object", model)
end

function isSAMPObject(model) -- samp ids
	model = tonumber(model)
	return (model >= 18631 and model <= 19999) or (model >= 11682 and model <= 12799)
	-- 				min 				max 	  include 11682 to 12799 SAMP ID Range
end

function getSAMPOrDefaultModel(object)
	local data_name = exports.newmodels:getDataNameFromType("object")
	return getElementData(object, data_name) or getElementModel(object)
end



-- Parse SA-MP map code (Pawn)


-- Adding new objects for SA-MP Maps
--  PS. You can generate a model's .col with kdff
function addMapModel(baseid, newid, fileDff, fileTxd, fileCol)

    if exports.newmodels:isCustomModID(newid) then
        outputDebugString("addMapModel: custom ID "..newid.." already added", 2)
        return true
    end

    -- SAMP model as base id not supported
    if not isDefaultObject(baseid) then
        -- outputDebugString(string.format("ignoring new object model with base id %d (upon adding): %d - %s, %s, %s ...",baseid, newid, fileDff,fileTxd,fileCol), 2)
        baseid = 1337
    end

    local folderName = "models/"
    local worked, reason = exports.newmodels:addExternalMod_CustomFilenames("object", newid, baseid,
            string.gsub(fileDff, ".dff", ""), folderName..fileDff, folderName..fileTxd, folderName..fileCol)

    if not worked then
        outputDebugString(string.format("Failed to add object model: %d, %d, %s, %s, %s, reason: %s",baseid,newid,fileDff,fileTxd,fileCol, reason), 1)
        return false
    end
    return true
end


function string.trim(str)
    str = string.gsub(str, "%s+", "")
    return str
end
function string.contains(str,key) 
    return string.match(str, key) ~= nil
end
local block_comment = nil
function isCommented(line)
    -- detects comment start /* and comment end */
    if not block_comment then
        local blockstart = string.find(line, "/%*")
        if blockstart then
            -- print("Block comment start: "..line)
            block_comment = true

            local blockend = string.find(line, "%*/")
            if blockend and blockend > blockstart then
                -- print("Block comment end same line")
                block_comment = nil
            end
        end
        
    elseif block_comment then
        local blockend = string.find(line, "%*/")
        if blockend then
            -- print("Block comment end: "..line)
            block_comment = nil

            local blockstart = string.find(line, "/%*")
            if blockstart and blockstart > blockend then
                -- print("Block comment start same line")
                block_comment = true
            end
        end
    end
    return block_comment
end
function removeLineComment(line)
    -- example: function(...) // this is a comment
    -- ' // this is a comment' will be removed
    local removed = false
    local pos = string.find(line, "//")
    if pos then
        line = line:sub(1, pos-1)
        removed = true
    end
    return line, removed
end
function isCreateObject(line)
    return string.contains(line,"CreateObject") or string.contains(line,"CreateDynamicObject")
end
function isMaterialText(line) 
    return string.contains(line,"SetDynamicObjectMaterialText") or string.contains(line,"SetObjectMaterialText")
end
function isSetMaterial(line)
    if isMaterialText(line) then return false end
    return string.contains(line,"SetObjectMaterial") or string.contains(line,"SetDynamicObjectMaterial")
end
function isWorldObjectRemovel(line)
    return string.contains(line,"RemoveBuildingForPlayer")
end
function isAddSimpleModel(line)
    return string.contains(line, "AddSimpleModel")
end

function parseCreateObject(code)
    -- get rid of unused syntax
    code = string.gsub(code, "%(", "")
    code = string.gsub(code, "%)", "")
    code = string.gsub(code, ";", "")
    code = string.gsub(code, "CreateObject", "")
    code = string.gsub(code, "CreateDynamicObjectEx", "")
    code = string.gsub(code, "CreateDynamicObject", "")
    code = string.trim(code)

    -- get object code
    local b = split(code,',')
    local model = tonumber(b[1])
    local x = tonumber(b[2])
    local y = tonumber(b[3])
    local z = tonumber(b[4])
    local rx = tonumber(b[5])
    local ry = tonumber(b[6])
    local rz = tonumber(b[7])
    local streamDis = b[11] ~= nil and tonumber(b[11]) or nil
    return model,x,y,z,rx,ry,rz,streamDis
end
function parseSetObjectMaterial(code)
    --code = string.gsub(code, "%(", "")
    --code = string.gsub(code, "%)", "")
    code = string.gsub(code, ";", "")
    code = string.gsub(code, "SetObjectMaterial", "")
    code = string.gsub(code, "SetDynamicObjectMaterial", "")
    code = string.trim(code)
    -- get info
    local b = split(code,',')
    local matIndex = tonumber(b[2])
    local model = tonumber(b[3])
    local lib = string.gsub(b[4], "\"", "")
    local txd = string.gsub(b[5], "\"", "")
    if lib == "none" or txd == "none" then
        return nil -- ignore none, it's just to set color
    end

    -- local color = string.gsub(b[6], "%)", "") -- color ignored for now
    -- color = string.gsub(color, "0x", "")
    return matIndex,model,lib,txd--,color 
end
function parseRemoveBuildingForPlayer(code)
    code = string.gsub(code, "%(", "")
    code = string.gsub(code, "%)", "")
    code = string.gsub(code, ";", "")
    code = string.gsub(code, "RemoveBuildingForPlayer", "")
    code = string.trim(code)
    local b = split(code,',')

    local model = tonumber(b[2])
    local x = tonumber(b[3])
    local y = tonumber(b[4])
    local z = tonumber(b[5])
    local rad = tonumber(b[6])
    return model, x, y, z, rad
end
function parseAddSimpleModel(code)
    code = string.gsub(code, "%(", "")
    code = string.gsub(code, "%)", "")
    code = string.gsub(code, ";", "")
    code = string.gsub(code, "AddSimpleModel", "")
    code = string.trim(code)
    local b = split(code,',')

    local virtualworld = tonumber(b[1])--useless
    local baseid = tonumber(b[2])
    local newid = tonumber(b[3])
    local dffname = string.gsub(b[4], "\"", "")
    local txdname = string.gsub(b[5], "\"", "")
    return baseid, newid, dffname, txdname
end

function parseTextureStudioMap(filename) -- [Exported]  type: shared
    if fileExists(filename) then 

        local result = {}
        local new_objs_used = {}

        local f = fileOpen(filename)
        local str = fileRead(f,fileGetSize(f))
        fileClose(f)

        Lines = split(str,'\n' )
        for i = 1, #Lines do
            local line, removed = removeLineComment(Lines[i])
            if line ~= "" and not isCommented(line) then

                if isAddSimpleModel(line) then
                    local baseid, newid, dffname, txdname = parseAddSimpleModel(line)
                    if baseid then
                        local colname = (dffname:gsub(".dff", ""))..".col"
                        local worked, reason = addMapModel(baseid, newid, dffname, txdname, colname)
                        if worked then
                            table.insert(result, {
                                f = "model",
                                line = i,
                                variables = {
                                    baseid, newid, dffname, txdname
                                }
                            })
                        end
                    end
                end
                if isCreateObject(line) then
                    local objdetails = ""
                    if string.find(line, "=") then -- variable = createObject
                        objdetails = split(line,"=")
                        objdetails = objdetails[2] or ""
                    else
                        objdetails = line
                    end
                    local model,x,y,z,rx,ry,rz,dist = parseCreateObject(objdetails)
                    if model then
                        table.insert(result, {
                            f = "object",
                            line = i,
                            variables = {
                                model,x,y,z,rx,ry,rz,dist
                            }
                        })

                        if not isDefaultObject(model) then
                            new_objs_used[model] = true
                        end
                    end
                end
                if isSetMaterial(line) then 
                    local index,model,lib,txd,color = parseSetObjectMaterial(line)
                    if index then
                        table.insert(result, {
                            f = "material",
                            line = i,
                            variables = {
                                --lib not needed
                                index,model,txd,color
                            }
                        })

                        if not isDefaultObject(model) then
                            new_objs_used[model] = true
                        end
                    end
                end
                if isWorldObjectRemovel(line) then 
                    local model,x,y,z,radius = parseRemoveBuildingForPlayer(line)
                    if model then
                        table.insert(result, {
                            f = "remove",
                            line = i,
                            variables = {
                                model,x,y,z,radius
                            }
                        })
                    end
                end
            end
        end

        return result, "", new_objs_used
    else
        return false, filename.." doesn't exist"
    end
end