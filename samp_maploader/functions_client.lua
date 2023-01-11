--[[
    Credits: Fernando, gta191977649

	Client Functions
--]]


-- Spawn an object of a default SA ID or a New Added ID
-- (SAMP or custom after calling AddSimpleModel)
function createMapObject(model_id,x,y,z,rx,ry,rz,distance)
    model_id = tonumber(model_id)
    if not model_id then return end

    local isCustom, mod, elementType = exports.newmodels:isCustomModID(model_id)
    if isCustom then
        if elementType ~= "object" then
            outputDebugString("Custom ID "..model_id.." doesn't correspond to an object mod", 1)
            return
        end
    elseif not isDefaultObject(model_id) then
        outputDebugString("Custom ID "..model_id.." doesn't correspond to any mod", 2)
        return
    end


    local lod
    local obj = createObject(1337,x,y,z,rx,ry,rz)
    if not obj then
        outputDebugString("Failed to create object", 1)
        return
    end

    if tonumber(distance) and distance ~= 300 then
        -- lod = createObject(1337,x,y,z,rx,ry,rz,true)
        -- setLowLODElement ( obj, lod )
        -- engineSetModelLODDistance ( model_id, distance )
    end

    if isCustom then
        local data_name = exports.newmodels:getDataNameFromType("object")
        setElementData(obj, data_name, model_id)

        if isElement(lod) then
            setElementData(lod, data_name, model_id)
        end
    else
        setElementModel(obj, model_id)
        if isElement(lod) then
            setElementModel(lod, model_id)
        end
    end

    return obj,lod
end


function getTextureNameFromIndex(object,mat_index)
    local tex_name = nil

    local model = getSAMPOrDefaultModel(object)
    if not model then
        if (WARN_GET_TEX_NAME_FROM_INDEX) then outputDebugString("Failed to get object model ("..inspect(model)..")", 1) end
    else
        if exports.newmodels:isCustomModID(model) then
            local samp_filenames = SAMP_FILES[model]
            if samp_filenames ~= nil then
                local dffname = string.lower(samp_filenames[1])
                local materials = SA_MATLIB[dffname]
                if materials ~= nil then
                    for _,val in ipairs(materials) do
                        if val.index == mat_index then --
                            tex_name = val.name
                        end
                    end
                else
                    if (WARN_GET_TEX_NAME_FROM_INDEX) then outputDebugString("(samp) "..dffname.." not in SA_MATLIB", 2) end
                end
            end
        else -- normal SA object
            local dffname = engineGetModelNameFromID(model)
            if dffname then
                dffname = string.lower(dffname)
                if SA_MATLIB[dffname..".dff"] ~= nil then
                    for _,val in ipairs(SA_MATLIB[dffname..".dff"]) do
                        if val.index == mat_index then --
                            tex_name = val.name
                        end
                    end
                else
                    if (WARN_GET_TEX_NAME_FROM_INDEX) then outputDebugString(dffname..".dff not in SA_MATLIB", 2) end
                end
            else
                if (WARN_GET_TEX_NAME_FROM_INDEX) then outputDebugString("Failed to get model name from ID "..inspect(model), 1) end
            end
        end
    end
    return tex_name
end
function getTextureFromName(model_id,tex_name,isCustom)
    
    if not tonumber(model_id) then return end
    model_id = tonumber(model_id)

    if isCustom then
        -- we need to obtain the id allocated by MTA
        local allocated_id, reason = exports.newmodels:forceAllocate(model_id)
        if not allocated_id then
            if (WARN_GET_TEX_FROM_NAME) then outputDebugString("getTextureFromName => Failed to allocate mod ID "..model_id..": "..reason, 1) end
            return
        end

        for name,texture in pairs(engineGetModelTextures(allocated_id,tex_name)) do
            return texture, name
        end
    else
        for name,texture in pairs(engineGetModelTextures(model_id,tex_name)) do
            return texture, name
        end
    end
end

function getColor(color)
    if color == "0" or color == 0 then
        return 1,1,1,1
    elseif #color == 8 then 
        local a = tonumber(string.sub(color,1,2), 16) /255
        local r = tonumber(string.sub(color,3,4), 16) /255
        local g = tonumber(string.sub(color,5,6), 16) /255
        local b = tonumber(string.sub(color,7,8), 16) /255
        return a,r,g,b
    else -- not hex, not number, return default material color
        return 1,1,1,1
    end 
end

function setObjectMaterial(object,mat_index,model_id,tex_name,color,isCustom)
    -- if true then return end -- testing

    --MTA doesn't need lib_name (.txd file) to find texture by name
    if model_id ~= -1 then -- dealing replaced mat objects
        local target_tex_name = getTextureNameFromIndex(object,mat_index)
        if target_tex_name ~= nil then 

            -- find the txd name we want to replaced
            local matShader = dxCreateShader( "files/shader.fx" )
            local matTexture = getTextureFromName(model_id,tex_name,isCustom)
            if matTexture ~= nil then
                
                -- apply shader attributes
                --local a,r,g,b = getColor(color)
                --a = a == 0 and 1 or a
                --alpha disabled due to bug
                -- dxSetShaderValue ( matShader, "gColor", 1,1,1,1);
                -- dxSetShaderValue ( matShader, "gTexture", matTexture);
                
                dxSetShaderValue ( matShader, "theTex", matTexture);
            else
                destroyElement(matShader)
                outputDebugString(string.format( "Invalid texture/model on model_id: %s and tex_name: %s", tostring(model_id),tostring(tex_name)), 2)
                return false
            end
            engineApplyShaderToWorldTexture (matShader,target_tex_name,object)

            local mat_info = getElementData(object, "material_info") or {}
            table.insert(mat_info, {
                mat_index = mat_index,
                target_tex_name = target_tex_name,
                tex_name = tex_name
            })
            setElementData(object, "material_info", mat_info, false)

            return { matShader, matTexture }
        else
            local model = getSAMPOrDefaultModel(object)
            if (WARN_GET_TEX_NAME_FROM_INDEX) then outputDebugString(string.format( "Unknown material on model: %s, index: %s", tostring(model),tostring(mat_index)), 2) end
            return false
        end
    end
end

