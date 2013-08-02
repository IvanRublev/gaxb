<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_"
FULL_NAME_CAMEL = capitalizedString(this.namespace)
%>
//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

#import <objc/message.h>
#import <objc/runtime.h>
#import "<%= FULL_NAME_CAMEL %>_XMLLoader.h"

#ifndef TARGET_OS_IPHONE
#define objc_msgSend(object,selector,argument)	{ IMP imp = objc_msg_lookup(object, selector); imp(object, selector, argument); }
#endif

typedef struct _TBXMLAttribute {
	char * name;
	char * value;
	struct _TBXMLAttribute * next;
} TBXMLAttribute;

typedef struct _TBXMLElement {
	char * name;
	char * text;
	TBXMLAttribute * firstAttribute;
	struct _TBXMLElement * parentElement;
	struct _TBXMLElement * firstChild;
	struct _TBXMLElement * currentChild;
	struct _TBXMLElement * nextSibling;
	struct _TBXMLElement * previousSibling;
} TBXMLElement;

typedef struct _TBXMLElementBuffer {
	TBXMLElement * elements;
	struct _TBXMLElementBuffer * next;
	struct _TBXMLElementBuffer * previous;
} TBXMLElementBuffer;

typedef struct _TBXMLAttributeBuffer {
	TBXMLAttribute * attributes;
	struct _TBXMLAttributeBuffer * next;
	struct _TBXMLAttributeBuffer * previous;
} TBXMLAttributeBuffer;

@interface TBXML : NSObject {
	
@private
	TBXMLElement * rootXMLElement;
	TBXMLElementBuffer * currentElementBuffer;
	TBXMLAttributeBuffer * currentAttributeBuffer;
	long currentElement;
	long currentAttribute;
	char * bytes;
	long bytesLength;
}

@property (nonatomic, readonly) TBXMLElement *rootXMLElement;

+ (id) tbxmlWithURL:(NSURL *)aURL;
+ (id) tbxmlWithXMLString:(NSString *)aXMLString;
+ (id) tbxmlWithXMLData:(NSData *)aData;
+ (id) tbxmlWithXMLFile:(NSString *)aXMLFile;
+ (id) tbxmlWithXMLFile:(NSString *)aXMLFile fileExtension:(NSString *)aFileExtension;
- (id) initWithURL:(NSURL *)aURL;
- (id) initWithXMLString:(NSString *)aXMLString;
- (id) initWithXMLData:(NSData *)aData;
- (id) initWithXMLFile:(NSString *)aXMLFile;
- (id) initWithXMLFile:(NSString *)aXMLFile fileExtension:(NSString *)aFileExtension;
@end

static BOOL UseTBXML = YES;

@implementation NSData (NSDataAdditions<%= FULL_NAME_CAMEL %>_XMLLoader)

static NSObject * CreateElementWithNamespace(TBXMLElement *element,
									  const char *currentNamespace,
									  NSMutableDictionary *namespaceMap,
									  NSObject *parent);
#define kMaxSelectorName 256

static int _XmlElementUid;
static Class _NSStringClass = NULL;
static Class _NSMutableStringClass = NULL;
static Class _NSObjectClass = NULL;
static char scratch[kMaxSelectorName];
static char selectorName[kMaxSelectorName];
static char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static char decodingTable[128];

+ (void) initialize 
{
	if (self == [NSData class]) 
	{
	    NSInteger i;		
		memset(decodingTable, 0, sizeof(decodingTable));
		for (i = 0; i < sizeof(encodingTable); i++) 
		{
			decodingTable[encodingTable[i]] = i;
		}
	}
}

+ (NSString *) encode:(const uint8_t *) input length:(NSInteger) length 
{
	NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
	uint8_t *output = (uint8_t *)data.mutableBytes;
	NSInteger i, j;
	for (i = 0; i < length; i += 3) {
		NSInteger value = 0;
		for (j = i; j < (i + 3); j++) {
			value <<= 8;
			if (j < length) { value |= (0xFF & input[j]); }
		}
		
		NSInteger index = (i / 3) * 4;
		output[index + 0] =                    encodingTable[(value >> 18) & 0x3F];
		output[index + 1] =                    encodingTable[(value >> 12) & 0x3F];
		output[index + 2] = (i + 1) < length ? encodingTable[(value >> 6)  & 0x3F] : '=';
		output[index + 3] = (i + 2) < length ? encodingTable[(value >> 0)  & 0x3F] : '=';
	}
	return [[NSString alloc] initWithData:data
								  encoding:NSASCIIStringEncoding];
}

+ (NSString *) encode:(NSData *) rawBytes 
{
	if ([rawBytes respondsToSelector:@selector(gzipDeflate)])
		rawBytes = [rawBytes performSelector:@selector(gzipDeflate)];
	return [self encode:(const uint8_t *) rawBytes.bytes length:rawBytes.length];
}

+ (NSData *) decode:(const char *) string length:(NSInteger) inputLength 
{
	if ((string == NULL) || (inputLength % 4 != 0)) { return nil; }
	
	while (inputLength > 0 && string[inputLength - 1] == '=') { inputLength--; }
	
	NSInteger outputLength = inputLength * 3 / 4;
	NSMutableData *data = [NSMutableData dataWithLength:outputLength];
	uint8_t *output = (uint8_t *)data.mutableBytes;
	
	NSInteger inputPoint = 0;
	NSInteger outputPoint = 0;
	while (inputPoint < inputLength) 
	{
		char i0 = string[inputPoint++];
		char i1 = string[inputPoint++];
		char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to ? */
		char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
				
		output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
		if (outputPoint < outputLength) {
			output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
		}
		if (outputPoint < outputLength) {
			output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
		}
	}
	if ([data respondsToSelector:@selector(gzipInflate)]) 
	{
		NSMutableData *infData = [data performSelector:@selector(gzipInflate)];
		data = ([infData length] ? infData : data);
	}
	return data;
}

+ (NSData *) decode:(NSString *) string 
{
	return [self decode:[string UTF8String] length:string.length];
}

@end


@implementation <%= FULL_NAME_CAMEL %>_XMLLoader

@synthesize element_stack;

#if 0
+ (void) initialize
{<%
for k,v in pairs(schema.elements) do
	if (schema.namespace == v.namespace) then			
		gaxb_print("\t[[["..className(v).." alloc] init] release];\n")
	end
end
%>}
#endif

+ (NSString *)convertName:(NSString *)name 
{
	if ([name isEqualToString:@"id"]) { return @"_id"; }
	if ([name isEqualToString:@"class"]) { return @"_class"; }
	if ([name isEqualToString:@"restrict"]) { return @"_restrict"; }
	return [name stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

static NSString * cappedString(NSString *name) 
{
	char first = toupper([name characterAtIndex: 0]);
	return [NSString stringWithFormat: @"%c%@", first, [name substringFromIndex: 1]];
}

+ (NSString *)setterName:(NSString *)name {
	return [NSString stringWithFormat:@"set%@:", cappedString([self convertName:name])];
}

+ (NSString *)setterNameWithString:(NSString *)name {
	return [NSString stringWithFormat:@"set%@WithString:", cappedString([self convertName:name])];
}

+ (NSString *)getterName:(NSString *)name 
{
	name = [self convertName:name];
	name = [NSString stringWithFormat:@"%@", name];	
	return name;
}

+ (NSString *)getterNamePlural:(NSString *)name 
{
	name = [self convertName:name];
	name = [NSString stringWithFormat:@"%@s", name];	
	return name;
}

+ (id) readFromData:(NSData *)data withParent:(id)p AndMemoryLite:(BOOL)memLite
{
	if(!data) return NULL;
	Class TBXLCLASS = NSClassFromString(@"TBXML");
	if(TBXLCLASS != NULL) 
	{
		TBXML * tbxml = [TBXLCLASS tbxmlWithXMLData:data];
		if(UseTBXML && tbxml) 
		{
			_XmlElementUid = time(0);
			_NSStringClass = [NSString class];
			_NSMutableStringClass = [NSMutableString class];
			_NSObjectClass = [NSObject class];
			if(tbxml.rootXMLElement) 
			{
				return CreateElementWithNamespace(tbxml.rootXMLElement, NULL, [NSMutableDictionary dictionary], p);
			}
		}
	}
	
	return NULL;
}

+ (id) readFromData:(NSData *)data withParent:(id)p
{
  return [self readFromData:data withParent:p AndMemoryLite:YES];
}

+ (id) readFromData:(NSData *)data 
{
	return [<%= FULL_NAME_CAMEL %>_XMLLoader readFromData:data withParent:NULL];
}

+ (id) readFromFile:(NSString *)path 
{
	return [<%= FULL_NAME_CAMEL %>_XMLLoader readFromData:[NSData dataWithContentsOfFile:path options:0 error:NULL]];
}

+ (id) readFromString:(NSString *)xml_string 
{
	return [<%= FULL_NAME_CAMEL %>_XMLLoader readFromData:[xml_string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (id) readFromDataFast:(NSData *)data 
{
	return [self readFromData:data withParent:NULL AndMemoryLite:NO];
}

+ (id) readFromFileFast:(NSString *)path 
{
	return [self readFromDataFast:[NSData dataWithContentsOfFile:path options:0 error:NULL]];
}

+ (id) readFromStringFast:(NSString *)xml_string 
{
	return [self readFromDataFast:[xml_string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void) useTBXML:(BOOL)b 
{
	UseTBXML = b;
}

+ (NSString *) writeToString:(id)object
{
	NSMutableString * scratch = [NSMutableString string];
	[scratch appendString:@"<?xml version=\\"1.0\\" encoding=\\"UTF-8\\"?>"];
	
	if([object respondsToSelector:@selector(appendXML:)])
	{
		[object performSelector:@selector(appendXML:) withObject:scratch];
	}
	
	return scratch;
}

+ (NSString *) writeOriginalXMLToString:(id)object
{
	NSMutableString * scratch = [NSMutableString string];
	[scratch appendString:@"<?xml version=\\"1.0\\" encoding=\\"UTF-8\\"?>"];
	
	if([object respondsToSelector:@selector(appendXML:useOriginalValues:)])
	{
		[object performSelector:@selector(appendXML:useOriginalValues:) withObject:scratch withObject:[NSNumber numberWithBool:true]];
	}
	
	return scratch;
}

+ (void) write:(id)object toFile:(NSString *)path
{
	[[self writeToString:object] writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:NULL];
}

+ (NSData *) writeToData:(id)object
{
	return [[self writeToString:object] dataUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark -

- (id) initWithParent:(id)p AndMemoryLite:(BOOL)m
{
	self = [super init];
	if (self)
	{
		memLite = m; attribute_map = [NSMutableDictionary dictionary]; plural_element_map = [NSMutableDictionary dictionary];
		parent = p;  element_stack = [NSMutableArray array];
	}
	return self;
}

static void ConvertName(const char * ptr, char * scratch)
{
	if (*ptr == 'c' || *ptr == 'i' || *ptr == 'r')
	{
		if (strcmp(ptr, "id") == 0 || strcmp(ptr, "class") == 0 || strcmp(ptr, "restrict") == 0 )
		{
			*scratch = '_';
			scratch++;
		}
	}
	while (*ptr)
	{
		if (*ptr == '-')
		{
			*scratch = '_';
		}
		else
		{
			*scratch = *ptr;
		}
		scratch++;
		ptr++;
	}
	scratch[0] = 0;
}

static char * DecodeAllAmpersands(char * src)
{
	char * aptr = src;
	char * bptr = src;
	BOOL shouldCopy = NO;
	
	if (!src)
	{
		return NULL;
	}
	
	while (*aptr)
	{
		if (*aptr == '&')
		{
			if (strncmp(aptr, "&amp;", 5) == 0)
			{
				*bptr = '&';
				aptr += 4;
				shouldCopy = YES;
			}
			if (strncmp(aptr, "&lt;", 4) == 0)
			{
				*bptr = '<';
				aptr += 3;
				shouldCopy = YES;
			}
			if (strncmp(aptr, "&gt;", 4) == 0)
			{
				*bptr = '>';
				aptr += 3;
				shouldCopy = YES;
			}
			if (strncmp(aptr, "&quot;", 6) == 0)
			{
				*bptr = '\"';
				aptr += 5;
				shouldCopy = YES;
			}
			if (strncmp(aptr, "&apos;", 6) == 0)
			{
				*bptr = '\\'';
				aptr += 5;
				shouldCopy = YES;
			}
		}
		else
		{
			if (shouldCopy)
			{
				*bptr = *aptr;
			}
		}
		
		aptr++;
		bptr++;
	}
	
	*bptr = 0;
	
	return src;
}

static void SetValue(NSObject * object, NSObject * childObject, const char * elementName, const char * className)
{
	Class c = object_getClass(object);
	Class cc = object_getClass(childObject);
	
	ConvertName(elementName, scratch);
	
	strncpy(selectorName, "set", sizeof(selectorName));
	selectorName[3] = toupper(scratch[0]);
	strncat(selectorName, scratch+1, sizeof(selectorName));
	
	if (cc == _NSStringClass || cc == _NSMutableStringClass)
	{
		strncat(selectorName, "WithString:", sizeof(selectorName));
	}
	else
	{
		strncat(selectorName, ":", sizeof(selectorName));
	}
	
	SEL selector = sel_getUid(selectorName);
	if (selector && class_respondsToSelector(c, selector))
	{
		// Must be a single element... go ahead and set it
		objc_msgSend(object, selector, childObject);
	}
	else
	{
		// Ok, now let's check for an array...
		strncpy(selectorName, scratch, sizeof(selectorName));
		strncat(selectorName, "s", sizeof(selectorName));
		SEL selector = sel_getUid(selectorName);
		if (selector && class_respondsToSelector(c, selector))
		{
			if (selector && class_respondsToSelector(c, selector))
			{
				NSMutableArray * parentArray;
				
#ifdef TARGET_OS_IPHONE
				parentArray = objc_msgSend(object, selector, NULL);
#else
				IMP imp = objc_msg_lookup(object, selector); 
				parentArray = imp(object, selector, NULL);
#endif
				
				if ([parentArray isKindOfClass:[NSMutableArray class]])
				{
					strncpy(selectorName, "append", sizeof(selectorName));
					selectorName[6] = toupper(scratch[0]);
					strncat(selectorName, scratch+1, sizeof(selectorName));
					strncat(selectorName, "WithString:", sizeof(selectorName));
					
					SEL selector = sel_getUid(selectorName);
					if (selector && class_respondsToSelector(c, selector))
					{
						objc_msgSend(object, selector, childObject);
					}
					else
					{
						[parentArray addObject:childObject];
					}
				}
			}
		}
		else
		{
			// No?  How about anys...
			SEL selector = sel_getUid("anys");
			if (selector && class_respondsToSelector(c, selector))
			{
				NSMutableArray * parentArray;
#ifdef TARGET_OS_IPHONE
				parentArray = objc_msgSend(object, selector, NULL);
#else
				IMP imp = objc_msg_lookup(object, selector); 
				parentArray = imp(object, selector, NULL);
#endif				
				[parentArray addObject:childObject];
			}
			else
			{
				// No?  How about any (special note on the singular there)...
				SEL selector = sel_getUid("setAny:");
				if (selector && class_respondsToSelector(c, selector))
				{
					objc_msgSend(object, selector, childObject);
				}
				else
				{
					Class p = class_getSuperclass(objc_lookUpClass(className));
					
					// No?  Ok, lets try the superclass of this thing...
					if (p != _NSObjectClass && p != _NSStringClass && p != _NSMutableStringClass)
					{
						const char * className = object_getClassName(p);
						char * elementName = strchr(className, '_');
						if (elementName && className)
						{
							SetValue(object, childObject, elementName+1, className);
						}
					}
				}
			}
		}
	}
}

static NSObject * CreateElementWithNamespace(TBXMLElement * element,
											 const char * currentNamespace,
											NSMutableDictionary * namespaceMap,
											 NSObject * parent)
{
	char className[kMaxSelectorName];
	TBXMLAttribute * repObjBindings[kMaxSelectorName];
	int nRepObjBindings = 0;
	TBXMLAttribute * attribute;
	
	// If there is no known namespace, use ocxb supplied global
	if (currentNamespace == NULL)
	{
		currentNamespace = "<%= FULL_NAME_CAMEL %>";
	}
	
	// make our namespace mappings
	attribute = element->firstAttribute;
	while (attribute)
	{
		if (attribute->name[0] == 'x' && strncmp(attribute->name, "xmlns:", 6) == 0)
		{
			char * abbrevPtr = strchr(attribute->name, ':')+1;
			[namespaceMap setObject:[[NSString stringWithUTF8String:attribute->value] lastPathComponent] forKey:[NSString stringWithUTF8String:abbrevPtr]];
		}
		attribute = attribute->next;
	}
	// Look very quickly to see if there is an xmlns attribute
	attribute = element->firstAttribute;
	while (attribute)
	{
		if (attribute->name[0] == 'x' && strcmp(attribute->name, "xmlns") == 0)
		{
			// if there is, use that namespace
			currentNamespace = strrchr(attribute->value, '/')+1;
			break;
		}
		attribute = attribute->next;
	}
	const char * mappedNamespace = currentNamespace;
	if (strchr(element->name, ':'))
	{
		char * abbrevPtr = strchr(element->name, ':');
		abbrevPtr[0] = 0;
		mappedNamespace = [[namespaceMap objectForKey:[NSString stringWithUTF8String:element->name]] UTF8String];
		abbrevPtr[0] = ':';
	}
	const char * adjustedElementName = element->name;
	if (strchr(adjustedElementName, ':'))
	{
		adjustedElementName = strchr(adjustedElementName, ':')+1;
	}
	strncpy(className, mappedNamespace, sizeof(className));
	strncat(className, "_", sizeof(className));
	strncat(className, adjustedElementName, sizeof(className));
	
	Class c = objc_lookUpClass(className);
	if (c)
	{
		id object = [[c alloc] init];
		
		[object performSelector:@selector(setUid:) withObject:[NSNumber numberWithInt:_XmlElementUid++]];
		[object performSelector:@selector(setParent:) withObject:parent];

		SEL origValueSelector = sel_getUid("setOriginalValues:");
		NSMutableDictionary * origValues;
		if (origValueSelector &&  class_respondsToSelector(c, origValueSelector))
		{
			origValues = [[NSMutableDictionary alloc] init];
		}
		
		// Handle attributes...
		attribute = element->firstAttribute;
		while (attribute)
		{
			if (attribute->value && attribute->value[0])
			{
				ConvertName(attribute->name, scratch);
				strncpy(selectorName, "set", sizeof(selectorName));
				selectorName[3] = toupper(scratch[0]);
				strncat(selectorName, scratch+1, sizeof(selectorName));
				strncat(selectorName, "WithString:", sizeof(selectorName));
				
				SEL selector = sel_getUid(selectorName);
				if (selector && class_respondsToSelector(c, selector))
				{
					if ((attribute->value[0] == '$' && attribute->value[1] != '$' && attribute->value[1]) || (attribute->value[0] == '@' && attribute->value[1] != '@' && attribute->value[1]))
					{
						if (selector && class_respondsToSelector(c, selector))
						{
							repObjBindings[nRepObjBindings] = attribute;
							nRepObjBindings++;
						}
					} 
					else
					{
						objc_msgSend(object, selector, (NSString *)CFBridgingRelease(CFStringCreateWithCString(NULL, DecodeAllAmpersands(attribute->value), kCFStringEncodingUTF8)));
					}
					char attribName[kMaxSelectorName];
					ConvertName(attribute->name, attribName);
					[origValues setValue:(NSString *)CFBridgingRelease(CFStringCreateWithCString(NULL, DecodeAllAmpersands(attribute->value), kCFStringEncodingUTF8))
							  		forKey:(NSString *)CFBridgingRelease(CFStringCreateWithCString(NULL, DecodeAllAmpersands(attribName), kCFStringEncodingUTF8))];
				}
			}
			attribute = attribute->next;
		}

		objc_msgSend(object, origValueSelector, origValues);
		
		// Handle mixed content ( if it exists )
		if (element->text && element->text[0])
		{
			SEL selector = sel_getUid("setMixedContentWithString:");
			if (selector && class_respondsToSelector(c, selector))
			{
				// Must be a single element... go ahead and set it
				objc_msgSend(object, selector, (NSString *)CFBridgingRelease(CFStringCreateWithCString(NULL, DecodeAllAmpersands(element->text), kCFStringEncodingUTF8)));
			}
		}
		
		element = element->firstChild;
		while (element)
		{
			// This can be either a single element, or a series.  Check the object's selectors to figure out which...
			id childObject = CreateElementWithNamespace(element, currentNamespace, namespaceMap, object);
			const char * adjustedChildElementName = element->name;
			if (strchr(adjustedChildElementName, ':'))
			{
				adjustedChildElementName = strchr(adjustedChildElementName, ':')+1;
			}
			
			if (childObject)
			{
				SetValue(object, childObject, adjustedChildElementName, object_getClassName(childObject));
			}
			else if (element->text && element->text[0])
			{
				// Element did not resolve to a child, so it might be a NSString single
				ConvertName(adjustedChildElementName, scratch);
				strncpy(selectorName, "set", sizeof(selectorName));
				selectorName[3] = toupper(scratch[0]);
				strncat(selectorName, scratch+1, sizeof(selectorName));
				strncat(selectorName, "WithString:", sizeof(selectorName));
				
				SEL selector = sel_getUid(selectorName);
				if (selector && class_respondsToSelector(c, selector))
				{
					// Must be a single element... go ahead and set it
					objc_msgSend(object, selector, (NSString *)CFBridgingRelease(CFStringCreateWithCString(NULL, DecodeAllAmpersands(element->text), kCFStringEncodingUTF8)));
				}
			}
			if ([childObject respondsToSelector:@selector(gaxb_loadDidComplete)])	{ [childObject performSelector:@selector(gaxb_loadDidComplete)]; }
			
			element = element->nextSibling;
		}
		return object;
	}
	
	if (element->text && element->text[0])
	{
		return (NSString *)CFBridgingRelease(CFStringCreateWithCString(NULL, DecodeAllAmpersands(element->text), kCFStringEncodingUTF8));
	}
	return NULL;
}

#pragma mark -
#pragma mark Enum Handling

<%
	-- simpleType definitions, such as enums
	for k,v in pairs(schema.simpleTypes) do
		-- only include defintions from this schema's namespace
		if (schema.namespace == v.namespace) then
			
			gaxb_print("+ (NSArray *) arrayForEnum"..v.name.."\n");
			gaxb_print("{\n");
			gaxb_print("\tstatic NSArray *"..v.name.."s;\n");
			gaxb_print("\t\t"..v.name.."s = [[NSArray alloc] initWithObjects: ");
			
			local appinfo = gaxb_xpath(v.xml, "./XMLSchema:annotation/XMLSchema:appinfo");
			local enums = gaxb_xpath(v.xml, "./XMLSchema:restriction/XMLSchema:enumeration");
		
			if(appinfo ~= nil) then
				appinfo = appinfo[1].content;
			end
		
			if(appinfo == "ENUM" or appinfo == "NAMED_ENUM") then
				for k,v in pairs(enums) do
					gaxb_print("@\""..v.attributes.value.."\", ")
				end
			end
	--		if(appinfo == "ENUM_MASK") then
	--			local i = 1
	--			gaxb_print("enum\n{\n")
	--			for k,v in pairs(enums) do
	--				gaxb_print("\t"..v.attributes.value.." = "..i..",\n")
	--				i = i * 2;
	--			end
	--			gaxb_print("};\n")
	--		end
	
			gaxb_print("nil];\n");
			gaxb_print("\t\n");
			gaxb_print("\treturn "..v.name.."s;\n");
			gaxb_print("}");
		end			
	end
%>

@end
