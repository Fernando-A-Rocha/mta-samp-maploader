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