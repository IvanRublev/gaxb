<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_XMLLOADER_"
FULL_NAME_CAMEL = capitalizedString(this.namespace)
%>//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

<%

-- simpleType definitions, such as enums
for k,v in pairs(schema.simpleTypes) do
	-- only include defintions from this schema's namespace
	if (schema.namespace == v.namespace) then			
		local appinfo = gaxb_xpath(v.xml, "./XMLSchema:annotation/XMLSchema:appinfo");
		local enums = gaxb_xpath(v.xml, "./XMLSchema:restriction/XMLSchema:enumeration");
	
		if(appinfo ~= nil) then
			appinfo = appinfo[1].content;
		end
	
		if(appinfo == "ENUM") then
			gaxb_print("typedef enum\n{\n")
			for k,v in pairs(enums) do
				gaxb_print("\t"..v.attributes.value..",\n")
			end
			gaxb_print("} "..v.name..";\n\n")
		end
		if(appinfo == "NAMED_ENUM") then
			gaxb_print("typedef enum\n{\n")
			for k1,v1 in pairs(enums) do
				gaxb_print("\t"..v.name.."_"..v1.attributes.value..",\n")
				-- print(k1,table.tostring(v1))
			end
			gaxb_print("} "..v.name..";\n\n")
		end
		if(appinfo == "ENUM_MASK") then
			local i = 1
			gaxb_print("typedef enum\n{\n")
			for k,v in pairs(enums) do
				gaxb_print("\t"..v.attributes.value.." = "..i..",\n")
				i = i * 2;
			end
			gaxb_print("} "..v.name..";\n\n")
		end
		if(appinfo == "TYPEDEF") then
			for k,v in pairs(enums) do
				gaxb_print("#define "..string.upper(v.attributes.value).." @\""..v.attributes.value.."\"\n")
			end
			gaxb_print("\n");
		end
	end			
end

%>