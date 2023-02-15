local meta = FindMetaTable("Entity")

local blank = "photon/common/blank"

function meta:EX_OverrideMetaTable(name)
	if isstring(name) then name = exmeta.FindMetaTable(name) end
	exmeta.SetMetaTable(self:GetTable(), name)
end

function meta:EX_HideSubMaterial(index)
	self:SetSubMaterial(index, blank)
end

function meta:EX_HideSubMaterials(...)
	for _,i in ipairs({...}) do
		if (isstring(i)) then i = self:GetSubMaterialIndex(i) end
		self:SetSubMaterial(i, blank)
	end
end

function meta:EX_RestoreSubMaterial(index)
	self:SetSubMaterial(index)
end

function meta:EX_RestoreSubMaterials(...)
	for _,i in ipairs({...}) do
		self:SetSubMaterial(i)
	end
end

function meta:EX_GetSubMaterialIndex(name)
	for i, v in ipairs(self:GetMaterials()) do
		if v == name then return i - 1 end
	end
	return -1
end