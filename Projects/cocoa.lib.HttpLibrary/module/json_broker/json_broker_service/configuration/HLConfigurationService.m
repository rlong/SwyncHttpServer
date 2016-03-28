//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <sys/stat.h>


#import "CABaseException.h"
#import "CAJsonObject.h"
#import "CALog.h"

#import "HLConfigurationService.h"
#import "HLServiceDescription.h"
#import "HLServiceHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLConfigurationService () 

#pragma mark fields	


//NSMutableDictionary* _bundles;
@property (nonatomic, retain) NSMutableDictionary* bundles;
//@synthesize bundles = _bundles;

//NSString* _root;
@property (nonatomic, retain) NSString* root;
//@synthesize root = _root;

//NSFileManager* _fileManager;
@property (nonatomic, retain) NSFileManager* fileManager;
//@synthesize fileManager = _fileManager;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLConfigurationService


static NSString* _SERVICE_NAME = @"jsonbroker.ConfigurationService"; 

static HLServiceDescription* _SERVICE_DESCRIPTION = nil; 

+(void)initialize {
	
    _SERVICE_DESCRIPTION = [[HLServiceDescription alloc] initWithServiceName:_SERVICE_NAME];
	
}



+(NSString*)SERVICE_NAME { 
    
    return _SERVICE_NAME;
    
}



-(CAJsonObject*)getBundle:(NSString*)bundleName {
	
	
	CAJsonObject* answer = [_bundles objectForKey:bundleName];
	
	if( nil != answer ) {
		return answer;
	}
	   
	NSString* absolutePath = [NSString stringWithFormat:@"%@/%@.json", _root, bundleName];
	
	if( ![_fileManager fileExistsAtPath:absolutePath] || ![_fileManager isReadableFileAtPath:absolutePath] ) {
		
        return nil;
	}
	
	NSData* data = [NSData dataWithContentsOfFile:absolutePath];
    
    if( nil == data ) { 
        Log_warnFormat( @"nil == data; absolutePath = '%@'", absolutePath );
        return nil;
    }
    
    Log_debugInt( [data length] );
    if( 0 == [data length] ) { 
        
        Log_warnFormat( @"0 == [data length]; absolutePath = '%@'", absolutePath );
        return nil;
    }
	
	answer = [CAJsonObject buildWithData:data];
	
	[_bundles setObject:answer forKey:bundleName];

	
	return answer;
	
}

-(CAJsonObject*)getBundle:(NSString*)bundleName defaultValue:(CAJsonObject*)defaultValue {
    
    CAJsonObject* answer = [self getBundle:bundleName];
    
    if( nil == answer ) {
        
        answer = defaultValue;
        [_bundles setObject:defaultValue forKey:bundleName];
        
    }
    
    return answer;
    
}


-(void)saveBundle:(CAJsonObject*)bundle withName:(NSString*)bundleName  {
	
	NSString* bundleText = [bundle toString];
	
	NSString* absolutePath = [NSString stringWithFormat:@"%@/%@.json", _root, bundleName];
	Log_debugString(absolutePath );

	NSError* error = nil;
	[bundleText writeToFile:absolutePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
	
	if( nil != error ) { 
		
		NSString* technicalError = [error localizedDescription];
		
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e setError:error];
		
		@throw e;
	}
	
}


-(void)set_bundle:(NSString*)bundleName bundle:(CAJsonObject*)bundle {
	
	[_bundles setObject:bundle forKey:bundleName];
	
}

-(void)saveAllBundles {
	
	Log_enteredMethod();

	
	for( NSString* bundleName in _bundles ) {
		
		CAJsonObject* bundle = [_bundles objectForKey:bundleName];
		
		[self saveBundle:bundle withName:bundleName];
	}
	
}


+(void)mkdirs:(NSString*)rootFolder {
	
	NSScanner* scanner = [[NSScanner alloc] initWithString:rootFolder];
	
	NSString* fullPath = @"";
	
	[scanner scanString:@"/" intoString:nil]; // discard the leading '/' 
	
	NSString* folderName; 
	while( [scanner scanUpToString:@"/" intoString:&folderName] ) {
		
		fullPath = [NSString stringWithFormat:@"%@/%@",fullPath, folderName];		
		
		const char* utf8FullPath = [fullPath UTF8String];
		mkdir(utf8FullPath, S_IRWXU);
		
		[scanner scanString:@"/" intoString:nil]; // discard any trailing '/' that *might* exist
	}
	
	
}

#pragma mark <Service> implementation




-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
	
	NSString* methodName = [request methodName];

    if( [@"save_bundles" isEqualToString:methodName] ) { 
		
		[self saveAllBundles];
		
		return [HLBrokerMessage buildResponse:request];
		
	}

    if( [@"saveAllBundles" isEqualToString:methodName] ) { 
		
		[self saveAllBundles];
		
		return [HLBrokerMessage buildResponse:request];
		
	}

	if( [@"saveBundles" isEqualToString:methodName] ) { 
		
        Log_warn(@"deprecated method 'saveBundles'; use 'saveAllBundles' instead");
		[self saveAllBundles];
		
		return [HLBrokerMessage buildResponse:request];
		
	}
	
    CAJsonObject* requestAssociativeParamaters = [request associativeParamaters];
	
	
	if( [@"getBundle" isEqualToString:methodName] ) { 
		

        NSString* bundleName = [requestAssociativeParamaters stringForKey:@"bundle_name"];
		CAJsonObject* bundleValue = [self getBundle:bundleName];
		
        HLBrokerMessage* answer = [HLBrokerMessage buildResponse:request];
        
        CAJsonObject* responseAssociativeParamaters = [answer associativeParamaters];
        [responseAssociativeParamaters setObject:bundleName forKey:@"bundle_name"];
        [responseAssociativeParamaters setObject:bundleValue forKey:@"bundle_value"];
        
		return answer;

	}
    
    @throw [HLServiceHelper methodNotFound:self request:request];
	
	
}



-(HLServiceDescription*)serviceDescription {
    return _SERVICE_DESCRIPTION;
}

#pragma instance lifecycle



-(id)initWithRootFolder:(NSString*)rootFolder { 
	
	HLConfigurationService* answer = [super init];
	
	
	answer->_bundles = [[NSMutableDictionary alloc] init];
	[answer setRoot:rootFolder];
	answer->_fileManager = [[NSFileManager alloc] init];
	
	[HLConfigurationService mkdirs:rootFolder];
	
	return answer;
	
}

-(void)dealloc { 
	
	
	[self setBundles:nil];
	[self setRoot:nil];
	[self setFileManager:nil];
	
}


#pragma mark fields


//NSMutableDictionary* _bundles;
//@property (nonatomic, retain) NSMutableDictionary* bundles;
@synthesize bundles = _bundles;

//NSString* _root;
//@property (nonatomic, retain) NSString* root;
@synthesize root = _root;


//NSFileManager* _fileManager;
//@property (nonatomic, retain) NSFileManager* fileManager;
@synthesize fileManager = _fileManager;



@end
