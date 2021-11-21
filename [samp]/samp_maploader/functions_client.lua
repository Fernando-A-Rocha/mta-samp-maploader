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
        lod = createObject(1337,x,y,z,rx,ry,rz,true)
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
    local model = getSAMPOrDefaultModel(object)
    
    local tex_name = nil

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
                outputDebugString("(samp) "..dffname.." not in SA_MATLIB", 2)
            end
        end
    else -- normal SA object
        local dffname = string.lower(engineGetModelNameFromID(model))
        if SA_MATLIB[dffname..".dff"] ~= nil then
            for _,val in ipairs(SA_MATLIB[dffname..".dff"]) do
                if val.index == mat_index then --
                    tex_name = val.name
                end
            end
        else
            outputDebugString(dffname..".dff not in SA_MATLIB", 2)
        end
    end
    return tex_name
end
function getTextureFromName(model_id,tex_name)
    
    if not tonumber(model_id) then return end
    model_id = tonumber(model_id)

    if exports.newmodels:isCustomModID(model_id) then -- we need to obtain the id allocated by MTA
        local data_name = exports.newmodels:getDataNameFromType("object")
        local foundModelID
        for k,obj in ipairs(getElementsByType("object")) do
            local id = tonumber(getElementData(obj, data_name))
            if id and id == model_id then
                foundModelID = id
                break
            end
        end
        if not foundModelID then
            outputDebugString("Failed to find allocated ID for Custom ID "..model_id, 1)
            return
        else
            model_id = foundModelID
        end
    elseif not isDefaultObject(model_id) then
        -- prevents MTA error: engineGetModelTextures [Invalid model ID]
        return
    end

    local txds = engineGetModelTextures(model_id,tex_name)
    for name,texture in pairs(txds) do
        return texture, name
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

function setObjectMaterial(object,mat_index,model_id,tex_name,color)  -- [Exported]
    --MTA doesn't need lib_name (.txd file) to find texture by name
    if model_id ~= -1 then -- dealing replaced mat objects
        local target_tex_name = getTextureNameFromIndex(object,mat_index)
        if target_tex_name ~= nil then 

            -- find the txd name we want to replaced
            local matShader = dxCreateShader( "files/shader.fx" )
            local matTexture = getTextureFromName(model_id,tex_name)
            if matTexture ~= nil then
                -- apply shader attributes
                --local a,r,g,b = getColor(color)
                --a = a == 0 and 1 or a
                --alpha disabled due to bug
                dxSetShaderValue ( matShader, "gColor", 1,1,1,1);
                dxSetShaderValue ( matShader, "gTexture", matTexture);
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
            setElementData(object, "material_info", mat_info)

            return { matShader, matTexture }
        else
            local model = getSAMPOrDefaultModel(object)
            outputDebugString(string.format( "Unknown material on model: %s, index: %s", tostring(model),tostring(mat_index)), 2)
            return false
        end
    end
end

