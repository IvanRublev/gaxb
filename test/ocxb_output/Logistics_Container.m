//
// Autogenerate by ocxb on 2012-01-06 10:17:48 -0500
//


#import <UIKit/UIKit.h>

#import "Logistics_Container.h"



@interface NSData (NSDataAdditions)
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;
+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
+ (NSData*) decode:(NSString*) string;

@end

@implementation Logistics_Container

@synthesize parent, uid;
- (void) ocxb_valueWillChange:(NSString *)_name {
}

- (void) ocxb_valueDidChange:(NSString *)_name {
}

- (void) ocxb_loadDidComplete { }

- (id) ocxb_init {
return self;
}

- (void) ocxb_dealloc {
}

- (void) setValue:(id)_value forKey:(NSString *)_key { 
  if([_value isKindOfClass:[NSString class]]) { 
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@WithString:", [[[_key capitalizedString] substringToIndex:1] stringByAppendingString:[_key substringFromIndex:1]]]);
    if([self respondsToSelector:selector]) { [self performSelector:selector withObject:_value]; }
  }else{
    [super setValue:_value forKey:_key];
  }
}
@synthesize Packages;


- (id) init {
	self = [super init];
	if(self != NULL) {
if(!ocxb_init_called){ocxb_init_called=YES;[self ocxb_init];}
		Packages = [[NSMutableArray array] retain];
	}
return self;
}

- (void) dealloc {
[uid release];uid=NULL;
if(!ocxb_dealloc_called){ocxb_dealloc_called=YES;[self ocxb_dealloc];}
	[Packages release];    Packages = NULL;
	[super dealloc];
}
- (NSString *) translateToXMLSafeString:(NSString *)__value
{
NSMutableString * string = [NSMutableString stringWithString:[__value description]];
[string replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
[string replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
[string replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
[string replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
[string replaceOccurrencesOfString:@"'" withString:@"&apos;" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
return string;
}

- (NSArray *) validAttributes
{
	return [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObject:@"Logistics_Package[]" forKey:@"Packages"],
		NULL];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key { }
- (NSDate *) schemaDateTimeFromString:(NSString *)date_string
{ NSDateFormatter * date_format = [[[NSDateFormatter alloc] init] autorelease]; [date_format setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; [date_format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; return [date_format dateFromString:date_string]; }

- (NSDate *) schemaDateFromString:(NSString *)date_string
{ NSDateFormatter * date_format = [[[NSDateFormatter alloc] init] autorelease]; [date_format setDateFormat:@"yyyy-MM-dd"]; [date_format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; return [date_format dateFromString:date_string]; }

- (NSString *) dateTimeStringFromSchema:(NSDate *)_date
{ NSDateFormatter * date_format = [[[NSDateFormatter alloc] init] autorelease]; [date_format setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; [date_format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; return [date_format stringFromDate:_date]; }

- (NSString *) dateStringFromSchema:(NSDate *)_date
{ NSDateFormatter * date_format = [[[NSDateFormatter alloc] init] autorelease]; [date_format setDateFormat:@"yyyy-MM-dd"]; [date_format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; return [date_format stringFromDate:_date]; }


- (void) appendXMLAttributesForSubclass:(NSMutableString *)xml
{
}
- (void) appendXMLElementsForSubclass:(NSMutableString *)xml
{
for(id x in Packages) { [x appendXML:xml]; } 
}
- (void) appendXML:(NSMutableString *)xml
{
[xml appendFormat:@"<Container"];
if([parent performSelector:@selector(xmlns)] != @"http://schema.smallplanet.com/Logistics") { [xml appendFormat:@" xmlns='http://schema.smallplanet.com/Logistics'"]; } 
[self appendXMLAttributesForSubclass:xml];
NSMutableString * elems = [NSMutableString string];
[self appendXMLElementsForSubclass:elems];
if([elems length]){
[xml appendFormat:@">"];
   [xml appendFormat:@"%@</Container>", elems];
}else{
   [xml appendFormat:@"/>"];
}
}
- (NSString *) xmlns
{
  return @"http://schema.smallplanet.com/Logistics";
}


- (NSString *) description { NSMutableString * s = [NSMutableString string]; [self appendXMLAttributesForSubclass:s]; return [NSString stringWithFormat:@"<Container%@ />", s]; }




@end