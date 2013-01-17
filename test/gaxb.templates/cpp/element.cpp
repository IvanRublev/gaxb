<%
-- Copyright (c) 2012 Small Planet Digital, LLC
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
-- (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
-- subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 %>
<% -- C++ template
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_"..string.upper(this.name).."_";
CLASS_NAME = classNameWithNamespace(this.namespace, this.name);

--SAFE_RELEASE(p)            if(p) { (p)->release(); }
--SAFE_RELEASE_NULL(p)       if(p) { (p)->release(); (p) = 0; }
--CC_SAFE_RETAIN(p)          if(p) { (p)->retain(); } 


IMPORTS = {};
FORWARDS = {};
CLASS_INSTANCES = {};
for k,v in pairs(this.attributes) do
	local t = typeForItem(v);
	if(t == "tVector2*" or t == "tVector3*" or t == "tVector4*" or t == "tRect*" or t == "tColor*") then
		IMPORTS['#include "PlanetTypes.h"'] = true;
	else
		if (isObject(v)) then
			IMPORTS['#include "'..classNameStripped(t)..'.h"'] = true;
		end
	end
	if (isObject(v)) then
		CLASS_INSTANCES[v.name] = true;
	end
end
for k,v in pairs(this.sequences) do
	local t = typeForItem(v);
	if(t == "tVector2*" or t == "tVector3*" or t == "tVector4*" or t == "tRect*" or t == "tColor*") then
		IMPORTS['#import "PlanetTypes.h"'] = true;
	else
		if (isObject(v)) then
			IMPORTS['#include "'..classNameStripped(t)..'.h"'] = true;
		end
	end
end
for k,v in pairs(this.appinfos) do
	local vcopy = v
	local pipepos = string.find(v, "|")
	if (pipepos ~= nil) then
		vcopy = string.sub(v, 1, pipepos-1);
		FORWARDS[vcopy] = true;
	end
end

%>//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

<%
for k,v in pairs(IMPORTS) do
	gaxb_print(k.."\n")
end
%>#include "cocos2d.h"
#include <string>

namespace smallplanet {

class <%= CLASS_NAME %> : <%= superclassForItem(this) %> 
{
	std::string <%= CLASS_NAME %>::xmlns(void) { return "<%= this.namespace %>"; }
	
	<%= CLASS_NAME %>::<%= CLASS_NAME %>(void) { }
	<%= CLASS_NAME %>::~<%= CLASS_NAME %>(void) { }
	
<% if ( not hasSuperclass(this) ) then 
%>	void <%= CLASS_NAME %>::setParent(cocos2d::CCObject* u_parent)
	{
		if (u_parent) { u_parent->retain(); }
		if (parent) { parent->release(); }
		parent=u_parent;
	}

	cocos2d::CCObject* getParent(void)
	{
		return parent;
	}
<% end 
	if (# this.attributes > 0) then
		gaxb_print("\n\t// attributes\n")
		for k,v in pairs(this.attributes) do
%>	<%= typeForItem(v) %> <%= CLASS_NAME %>::get<%= capitalizedString(v.name).."" %> { return <%= v.name %>; }
	void <%= CLASS_NAME %>::set<%= capitalizedString(v.name).."" %>(<%= typeForItem(v) %> u_<%= v.name %>) {
<%			if (isObject(v)) then
%>		if (u_<%= v.name %>) { u_<%= v.name %>->retain(); }
		if (<%= v.name %>) { <%= v.name %>->release(); }
		<%= v.name %>=u_<%= v.name %>;
		<%= v.name %>Exists = true;
	}
<%			else
				gaxb_print('\t\t'..v.name..' = u_'..v.name..';\n\t}\n');
			end
			gaxb_print("\tbool get"..capitalizedString(v.name).."Exists { return "..v.name.."Exists; }\n\n")
		end
	end
%><%
	if (# this.sequences > 0) then
		gaxb_print("\n\t\t// subelements\n")
		for k,v in pairs(this.sequences) do
			if (v.name == "any") then
				gaxb_print("\t\tcocos2d::CCArray *anys;\n")
				print("class_instances adding: "..v)
				CLASS_INSTANCES["anys"] = true;
			elseif(isPlural(v)) then
				gaxb_print("\t\tcocos2d::CCArray *"..pluralName(v.name)..";\n")
				CLASS_INSTANCES[pluralName(v.name)] = true;
			else
				gaxb_print("\t\t"..typeForItem(v).." "..v.name..";\n\n")
				gaxb_print("\t\tbool "..v.name.."Exists;\n")
				if (isObject(v)) then
					CLASS_INSTANCES[v.name] = true;
				end
			end
		end
	end
%><%
	if (# this.appinfos > 0) then
		gaxb_print("\n\t\t// appinfo declarations\n")
		for k,v in pairs(this.appinfos) do
			local vcopy = v
			local pipepos = string.find(v, "|")
			if (pipepos ~= nil) then
				vcopy = string.sub(v, pipepos+1)
			end
			gaxb_print("\t\t"..vcopy.."\n")
		end
	end
%><% if ( not hasSuperclass(this) ) then %>
		cocos2d::CCObject* valueForKey(std::string s);
		
		void <%= CLASS_NAME %>::dealloc(void)
		{
<% if ( not hasSuperclass(this) ) then 
%>			if (m_parent) { m_parent->release(); m_parent=0; }
	<% end 
	print (table.tostring(CLASS_INSTANCES));
		for k,v in pairs(CLASS_INSTANCES) do
			gaxb_print("\n\t\t\tif ("..k..") { "..k.."->release(); "..k.."=0; }");
		end
	%>
	
		}
		
<% end 
if ( not hasSuperclass(this) ) then %>
		
		// Overriden by subclasses
		void gaxb_init(void);
		void gaxb_close(void);
		void gaxb_valueWillChange(std::string _name);
		void gaxb_valueDidChange(std::string _name);	
<% end %>}

} // end namespace

#endif
