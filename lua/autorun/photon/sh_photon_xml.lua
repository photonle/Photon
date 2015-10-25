AddCSLuaFile()

Photon.XML = {}

local function parseargs(s)
  local arg = {}
  string.gsub(s, "([%-%w]+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end
    
local function collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end

local xmltest = [[
<photonemv name="Test GMC Savana">
	<siren>1</siren>
	<skin>5</skin>
	<color r="255" g="128" b="255" />
	<bodygroups>
		<bodygroup key="0" desc="">0</bodygroup>
		<bodygroup key="2" desc="">0</bodygroup>
		<bodygroup key="3" desc="">0</bodygroup>
	</bodygroups>
	<components>
		<component index="1">
			<name>Dome Light Amber</name>
			<Scale>1</Scale>
			<position x="-26.6" y="12.5" z="98.7" />
			<angle p="0" y="90" r="0"/>
			<Phase>A</Phase>
		</component>
	</components>
	<modes>
		<primary>
			<stage name="CODE 1" ref="M1" />
			<stage name="CODE 2" ref="M2" />
			<stage name="CODE 3" ref="M3" />
		</primary>
		<auxiliary>
			<stage name="LEFT" ref="L" />
			<stage name="RIGHT" ref="D" />
			<stage name="DIVERGE" ref="R" />
		</auxiliary>
	</modes>
	<vehicledef>
		<category>SenCo</category>
		<author>Schmal</author>
		<model>models/lonewolfie/gmc_savana.mdl</model>
		<script>scripts/vehicles/LWCars/gmc_savana.txt</script>
	</vehicledef>
</photonemv>
]]

Photon.XML.ParseVehicleFromXML = function( inputXml )
	local xt = collect( tostring( inputXml ) )
	local emv = {}
	for _,element in pairs( xt[1] ) do
		if not istable( element ) then continue end
		if ( element.label == "siren" ) then emv.Siren = tonumber( tostring( element[1] ) ); continue end
		if ( element.label == "skin" ) then emv.Skin = tonumber( tostring( element[1] ) ) or tostring( element[1] ); continue end
		if ( element.label == "color" and isnumber( tonumber( element.xarg["b"]) ) and isnumber( tonumber ( element.xarg["g"] ) ) and isnumber( tonumber( element.xarg["r"] )  ) ) then emv.Color = Color( tonumber( element.xarg["r"] ), tonumber( element.xarg["g"] ), tonumber( element.xarg["b"] ) ); continue end
		if ( element.label == "bodygroups" and istable( element[1] ) ) then
			emv.BodyGroups = {}
			for key,bodygroup in pairs( element ) do
				if not istable( bodygroup ) or not bodygroup.xarg then continue end
				emv.BodyGroups[ #emv.BodyGroups + 1 ] = {
					bodygroup.xarg.key, bodygroup[ 1 ]
				}
			end
			continue
		end
		if ( element.label == "components" and istable( element[1] ) ) then
			emv.Auto = {}
			for key,component in pairs ( element ) do
				if not istable( component ) or not ( istable( component.xarg ) ) or not isnumber( tonumber( tostring(component.xarg.index) ) ) then continue end
				local this = {}
				for __,componentProperty in pairs( component ) do
					if not istable( componentProperty ) or not componentProperty.label then continue end
					if ( componentProperty.label ==  "name" ) then this.ID = tostring( componentProperty[1] )
					elseif ( componentProperty.label == "position" and isnumber( tonumber( componentProperty.xarg["x"] ) ) and isnumber( tonumber( componentProperty.xarg["y"] ) ) and isnumber( tonumber( componentProperty.xarg["z"] ) ) ) then this.Pos = Vector( tonumber( componentProperty.xarg["x"] ), tonumber( componentProperty.xarg["y"] ), tonumber( componentProperty.xarg["z"] ) )
					elseif ( componentProperty.label == "angle" and isnumber( tonumber( componentProperty.xarg["p"] ) ) and isnumber( tonumber( componentProperty.xarg["y"] ) ) and isnumber( tonumber( componentProperty.xarg["r"] ) ) ) then this.Ang = Angle( tonumber( componentProperty.xarg["p"] ), tonumber( componentProperty.xarg["y"] ), tonumber( componentProperty.xarg["r"] ) )
					else this[ tostring( componentProperty.label ) ] = tostring( componentProperty[ 1 ] ) end
				end
				emv.Auto[ tonumber( component.xarg.index ) ] = this
			end
			continue
		end
		if ( element.label == "modes" ) then
			emv.Sequences = {}
			for __,sys in pairs( element ) do
				if not istable( sys ) then continue end
				local systemParent = {}
				for index,stageInfo in pairs( sys ) do
					if not istable( stageInfo) or not istable( stageInfo.xarg ) then continue end
					if not stageInfo.label == "stage" then continue end
					local stage = stageInfo.xarg
					local this = {}
					this.Name = stage.name or ""
					this.Stage = stage.ref or ""
					this.Components = {}
					this.Disconnect = {}
					systemParent[ index ] = this
				end
				if ( sys.label == "primary" ) then emv.Sequences.Sequences = systemParent continue end
				if ( sys.label == "auxiliary" ) then emv.Sequences.Traffic = systemParent continue end
			end
		end
		if ( element.label == "vehicledef" ) then
			emv.VehicleDefinition = {}
			for __,property in pairs( element ) do
				if not istable( property ) then continue end
				if ( property.label == "category" ) then emv.VehicleDefinition.Category = tostring( property[1] ); continue end
				if ( property.label == "author" ) then emv.VehicleDefinition.Author = tostring( property[1] ); continue end
				if ( property.label == "model" ) then emv.VehicleDefinition.Model = tostring( property[1] ); continue end
				if ( property.label == "script" ) then emv.VehicleDefinition.KeyValues = { vehiclescript = tostring( property[1] ) } continue end
			end
			emv.VehicleDefinition.Name = xt[1].xarg.name or ""
			emv.VehicleDefinition.Class = "prop_vehicle_jeep"
			emv.VehicleDefinition.IsEMV = true
			emv.VehicleDefinition.EMV = self
			emv.VehicleDefinition.HasPhoton = true
			emv.VehicleDefinition.Photon = "PHOTON_INHERIT"
		end
	end
	return emv
end


-- this code is sloppy as fuck i am sorry
Photon.XML.ConvertToXML = function( emv )

	local result = string.format([[
<photonemv name="%s">
	<siren>%s</siren>
	<skin>%s</skin>
	<color r="%s" g="%s" b="%s" />
]], 
	emv.VehicleDefinition.Name or "",
	emv.Siren or 0,
	emv.Skin or 0,
	emv.Color.r or 255, emv.Color.g or 255, emv.Color.b or 255 )

	if ( istable( emv.BodyGroups ) ) then
		result = result .. 
[[	<bodygroups>
]]
		for _,bodygroup in pairs( emv.BodyGroups ) do
			result = result .. string.format([[
		<bodygroup key="%s">%s</bodygroup>
]], bodygroup[1], bodygroup[2] )
		end
		result = result .. 
[[	</bodygroups>
]]
	end

	if ( istable( emv.Auto ) ) then
		result = result ..
[[	<components>
]]
		for i=1,#emv.Auto do
			local component = emv.Auto[i]
			result = result .. string.format(
[[		<component index="%s">
]], i )
			for k,v in pairs( component ) do
				local inputString = ""
				if k == "ID" then inputString = string.format( [[			<name>%s</name>]], tostring( v ) )
				elseif k == "Pos" then inputString = string.format( [[			<position x="%s" y="%s" z="%s" />]], v.x, v.y, v.z )
				elseif k == "Ang" then inputString = string.format( [[			<angle p="%s" y="%s" r="%s" />]], v.p, v.y, v.r )
				else inputString = string.format( [[			<%s>%s</%s>]], k, tostring( v ), k ) end
				result = result .. inputString .. "\n"
			end
			result = result .. 
[[		</component>
]]
		end
		result = result .. 
[[	</components>
]]
	end

	if ( istable( emv.Sequences ) ) then
		result = result .. [[
	<modes>
]]
		
		for key, sys in pairs( emv.Sequences ) do
			local displayName = ""
			if key == "Sequences" then displayName = "primary"
			elseif key == "Traffic" then displayName = "auxiliary" end
			result = result .. string.format("\t\t<%s>\n", displayName)
			for __,stage in pairs( sys ) do
				result = result .. string.format("\t\t\t<stage name=\"%s\" ref=\"%s\" />\n", stage.Name, stage.Stage)
			end
			result = result .. string.format("\t\t</%s>\n", displayName)
		end

		result = result .. [[
	</modes>
]]
	end

	if ( istable( emv.VehicleDefinition ) ) then
		result = result .. "\t<vehicledef>\n"
		result = result ..  string.format( [[
		<category>%s</category>
		<author>%s</author>
		<model>%s</model>
		<script>%s</script>
]], tostring( emv.VehicleDefinition.Category ), tostring( emv.VehicleDefinition.Author ), tostring( emv.VehicleDefinition.Model ), tostring( emv.VehicleDefinition.KeyValues.vehiclescript ) )
		result = result .. "\t</vehicledef>\n"
	end

	result = result .. [[</photonemv>]]
	return result
end

local testemv = Photon.XML.ParseVehicleFromXML( xmltest )
local back = Photon.XML.ConvertToXML( testemv )
print(tostring(back))
-- print( tostring( testemv ) )
-- PrintTable( testemv )


-- hook.Add( "PopulateVehicles", "AddEntityContentPhotonListen", function( pnlContent, tree, node )

-- end )