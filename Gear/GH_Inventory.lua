local function GetSlotsByEquipLoc(equipLoc)
	GearHelper:BenchmarkCountFuncCall("GetSlotsByEquipLoc")
	local equipSlot = {}

	if equipLoc == "INVTYPE_WEAPON" then
		local _, myClass = UnitClass("player")
		local playerSpec = GetSpecializationInfo(GetSpecialization())
		local equipLocByClass = GearHelper.itemSlot[equipLoc][myClass]

		if equipLocByClass[tostring(playerSpec)] == nil then
			equipSlot = equipLocByClass
		else
			equipSlot = equipLocByClass[tostring(playerSpec)]
		end
	else
		equipSlot = GearHelper.itemSlot[equipLoc]
	end

	return equipSlot
end

function GearHelper:GetItemsByEquipLoc(equipLoc)
	self:BenchmarkCountFuncCall("GearHelper:GetItemsByEquipLoc")
	local result = {}
	local equipSlot = GetSlotsByEquipLoc(equipLoc)

	-- TODO: si on remplace ça par Result[v] = true, on peut faire une recherche dans la table avec un if (Result[v]) then, ce qui evite de faire un foreach avec la fonction IsValueInTablr
	for k, v in ipairs(equipSlot) do
		result[v] = GearHelperVars.charInventory[v]
	end

	return result
end