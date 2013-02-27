<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_XMLLOADER_"
FULL_NAME_CAMEL = capitalizedString(this.namespace)
%>//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

#ifndef <%= FULL_NAME_CAPS %>

#import <Foundation/Foundation.h>

<%
	-- includes for other header files
	for k,v in pairs(schema.elements) do
		-- only include defintions from this schema's namespace
		if (schema.namespace == v.namespace) then
			gaxb_print("#import \""..className(v)..".h\"\n")
		end
	end
	
	for k,v in pairs(schema.simpleTypes) do
		-- only include defintions from this schema's namespace
		if (schema.namespace == v.namespace) then
			gaxb_print("\n#import \""..this.namespace.."_XMLConstants.h\"\n");
			break;
		end
	end

%>
@interface <%= FULL_NAME_CAMEL %>_XMLLoader : NSObject 
{
	NSMutableArray *element_stack;
	NSString *last_element_name;
	NSMutableString *scratch_string;
	NSMutableDictionary *attribute_map;
	NSMutableDictionary *plural_element_map;
	id parent;
	int uid;
	BOOL memLite;
}

@property (nonatomic, strong) NSMutableArray * element_stack;

+ (id) readFromFile:(NSString *)path;
+ (id) readFromData:(NSData *)data;
+ (id) readFromData:(NSData *)data withParent:(id)parent;
+ (id) readFromString:(NSString *)xml_string;
+ (id) readFromFileFast:(NSString *)path;
+ (id) readFromDataFast:(NSData *)data;
+ (id) readFromStringFast:(NSString *)xml_string;
+ (void) useTBXML:(BOOL)b;
+ (void) write:(id)object toFile:(NSString *)path;
+ (NSData *) writeToData:(id)object;
+ (NSString *) writeToString:(id)object;
+ (NSString *) writeOriginalXMLToString:(id)object;
- (id) initWithParent:(id)p AndMemoryLite:(BOOL)m;
<%
for k,v in pairs(schema.simpleTypes) do
	-- only include defintions from this schema's namespace
	if (schema.namespace == v.namespace) then
		gaxb_print("+ (NSArray *) arrayForEnum"..v.name..";\n");
	end			
end
%>
@end

#endif