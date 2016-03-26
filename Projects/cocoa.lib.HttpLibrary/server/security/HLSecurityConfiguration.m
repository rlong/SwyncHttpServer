//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CAObjectTracker.h"
#import "CASecurityUtilities.h"

#import "HLSecurityConfiguration.h"
#import "HLSimpleSecurityAdapter.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLSecurityConfiguration () 


+(HLSecurityConfiguration*)buildTestConfiguration;


-(id)initWithIdentifier:(NSString *)identifier configurationService:(HLConfigurationService*)configurationService;
-(id)initWithValue:(HLJsonObject *)value configurationService:(HLConfigurationService*)configurationService;


-(CAJsonObject*)toJsonObject;

#pragma mark fields


// identifier
//NSString* _identifier;
@property (nonatomic, retain) NSString* identifier;
//@synthesize identifier = _identifier;

// configurationService
//ConfigurationService* _configurationService;
@property (nonatomic, retain) HLConfigurationService* configurationService;
//@synthesize configurationService = _configurationService;

// clients
//NSMutableDictionary* _clients;
@property (nonatomic, retain) NSMutableDictionary* clients;
//@synthesize clients = _clients;


// servers
//NSMutableDictionary* _servers;
@property (nonatomic, retain) NSMutableDictionary* servers;
//@synthesize servers = _servers;



// registeredSubjects
//SubjectGroup* _registeredSubjects;
@property (nonatomic, retain) HLSubjectGroup* registeredSubjects;
//@synthesize registeredSubjects = _registeredSubjects;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation HLSecurityConfiguration




static HLSecurityConfiguration* _test = nil; 


+(HLSecurityConfiguration*)TEST {
    
    if( nil != _test ) { 
        return _test;
    }
    
    _test = [HLSecurityConfiguration buildTestConfiguration];
    
    return _test;
    
    
}



+(HLSecurityConfiguration*)buildTestConfiguration {
    
    HLSecurityConfiguration* answer = [[HLSecurityConfiguration alloc] initWithIdentifier:[HLSubject TEST_REALM] configurationService:nil];
    
    [answer addClient:[HLSubject TEST]];
    
    return answer;
}


// vvv fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)

+(bool)isValidIdentifierCharacter:(unichar)c {
    
    if( c == '-' ) { // 45
        return true;
    }

    if( c == '.' ) { // 46
        return true;
    }
    
    if( c == '/' ) { // 47
        return true;
    }

    if( c >= '0' && c <= '9') { // 48 - 57
        return true;
    }
    
    if( c == ':' ) { // 58
        return true;
    }

    if( c == '@' ) { // 64
        return true;
    }

    if( c >= 'A' && c <= 'Z') { // 65 - 90
        return true;
    }

    if( c == '_' ) { // 95
        return true;
    }

    if( c >= 'a' && c <= 'z') { // 97 - 122
        return true;
    }


    return false;
    
}

+(bool)isValidIdentifier:(NSString*)identifier {
    
    for( NSUInteger i = 0, count = [identifier length]; i < count; i++ ) {
        
        unichar c = [identifier characterAtIndex:i];
        if( ![self isValidIdentifierCharacter:c] ) {
            Log_warnFormat( @"identifier = '%@'; i = %d; c = %d", identifier, i, c );
            return false;
        }
        
    }
    
    return true;
}


// ^^^ fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)


+(HLSecurityConfiguration*)build:(id<HLSecurityAdapter>)securityAdapter configurationService:(HLConfigurationService*)configurationService {
    
    HLJsonObject* bundleData = [configurationService getBundle:[HLSimpleSecurityAdapter BUNDLE_NAME]];
    
    HLSecurityConfiguration* answer = nil;
    
    
    if( nil != bundleData ) { 
        if( [bundleData contains:@"identifier"] )  {
            
            // vvv pairing in production is setting up the user as 'test' (ref: 477550FB-3656-4014-B4D7-DC49821E0BA6)
            // see SecurityConfiguration, KeychainSecurityAdapter
            
            
            NSString* identifier = [bundleData stringForKey:@"identifier"];
            
            if( [@"test" isEqualToString:identifier] ) {
                Log_warnString( identifier );
                
                NSString* identifier = [securityAdapter getIdentifier];
                Log_debugString( identifier );
                
                answer = [[HLSecurityConfiguration alloc] initWithIdentifier:identifier configurationService:configurationService];
                return answer;
            }
            
            
            // ^^^ pairing in production is setting up the user as 'test' (ref: 477550FB-3656-4014-B4D7-DC49821E0BA6)
            
            
            // vvv fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)
            
            if( ![HLSecurityConfiguration isValidIdentifier:identifier] ) {

                Log_warnString( identifier );
                
                NSString* identifier = [securityAdapter getIdentifier];
                Log_debugString( identifier );
                
                answer = [[HLSecurityConfiguration alloc] initWithIdentifier:identifier configurationService:configurationService];
                return answer;

            }
            
            // ^^^ fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)
            
            answer = [[HLSecurityConfiguration alloc] initWithValue:bundleData configurationService:configurationService];
            return answer;
        }
    }
    NSString* identifier = [securityAdapter getIdentifier];
    Log_debugString( identifier );
    
    answer = [[HLSecurityConfiguration alloc] initWithIdentifier:identifier configurationService:configurationService];
    
    return answer;
    
}


-(void)save { 
    
    if( nil == _configurationService ) { 
        Log_warn(@"nil == _configurationService");
        return;
    }
    
    CAJsonObject* bundleData = [self toJsonObject];
    [_configurationService saveBundle:bundleData withName:[HLSimpleSecurityAdapter BUNDLE_NAME]];
    [_configurationService set_bundle:[HLSimpleSecurityAdapter BUNDLE_NAME] bundle:bundleData];
    [_configurationService saveAllBundles];
    
    
}

-(void)addSubject:(NSString*)subjectIdentifier password:(NSString*)subjectPassword label:(NSString*)subjectLabel { 
    
    HLSubject* client = [[HLSubject alloc] initWithUsername:subjectIdentifier realm:_identifier password:subjectPassword label:subjectLabel];
    {
        [_clients setObject:client forKey:subjectIdentifier];        
    }
    
    
    HLSubject* server = [[HLSubject alloc] initWithUsername:_identifier realm:subjectIdentifier password:subjectPassword label:subjectLabel];
    {
        
        [_servers setObject:server forKey:subjectIdentifier];
    }
    
    [self save];
    
}

-(void)removeSubject:(NSString*)subjectIdentifier {
    
    [_clients removeObjectForKey:subjectIdentifier];
    [_servers removeObjectForKey:subjectIdentifier];
    
    [self save];
}




-(CAJsonObject*)toJsonObject {

    CAJsonObject* answer = [[CAJsonObject alloc] init];
    
    [answer setObject:_identifier forKey:@"identifier"];
    
    CAJsonArray* subjects = [[CAJsonArray alloc] init];
    {
    
        for( NSString* clientIdentifier in _clients ) { 
            HLSubject* client = [_clients objectForKey:clientIdentifier];
            
            CAJsonObject* subjectData = [[CAJsonObject alloc] init];
            {
                [subjectData setObject:[client username] forKey:@"identifier"];
                [subjectData setObject:[client password] forKey:@"password"];
                [subjectData setObject:[client label] forKey:@"label"];
                
                [subjects add:subjectData];
            }
            
        }
        
        [answer setObject:subjects forKey:@"subjects"];
    }
    
    return answer;
    
}

#pragma mark <ClientSecurityConfiguration> implementation

////////////////////////////////////////////////////////////////////////////
// ClientSecurityConfiguration::create


-(void)addServer:(HLSubject*)server { 
    
    NSString* subjectIdentifier = [server realm];
    NSString* subjectPassword = [server password];
    NSString* subjectLabel = [server label];
    
    [self addSubject:subjectIdentifier password:subjectPassword label:subjectLabel];
    
}

////////////////////////////////////////////////////////////////////////////
// ClientSecurityConfiguration::read

-(NSString*)username { 
    
    return _identifier;
}


-(BOOL)hasServer:(NSString *)realm {
    
    if( nil != [_servers objectForKey:realm] ) {
        return true;
    }
    return false;
}

//can return nil
-(HLSubject*)getServer:(NSString *)realm {
    return [_servers objectForKey:realm];
}


-(void)removeServer:(NSString *)realm {
    if( nil == [_servers objectForKey:realm] ) {
        Log_warnFormat(@"nil == [_servers objectForKey:realm]; realm = '%@'", realm );
    }
    [self removeSubject:realm];
}


#pragma mark <ServerSecurityConfiguration> implementation

////////////////////////////////////////////////////////////////////////////
// ServerSecurityConfiguration::create


-(void)addClient:(HLSubject*)client { 
    
    NSString* subjectIdentifier = [client username];
    NSString* subjectPassword = [client password];
    NSString* subjectLabel = [client label];
    
    [self addSubject:subjectIdentifier password:subjectPassword label:subjectLabel];
    
}


////////////////////////////////////////////////////////////////////////////
// ServerSecurityConfiguration::read 


-(NSString*)realm {
    return _identifier;
}


//can return nil
-(HLSubject*)getClient:(NSString *)clientUsername {
    return [_clients objectForKey:clientUsername];
}

-(BOOL)hasClient:(NSString *)clientUsername {
    
    if( nil != [_clients objectForKey:clientUsername] ) {
        return true;
    }
    return false;
}



-(NSArray*)getClients {
    
    return [_clients allValues];
    
}

////////////////////////////////////////////////////////////////////////////
// ServerSecurityConfiguration::delete 

-(void)removeClient:(NSString*)clientUsername { 
    
    [self removeSubject:clientUsername];
    
}



#pragma mark instance lifecycle


-(id)initWithIdentifier:(NSString *)identifier configurationService:(HLConfigurationService*)configurationService {
    
    
    HLSecurityConfiguration* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setIdentifier:identifier];
        [answer setConfigurationService:configurationService];
        
        answer->_clients = [[NSMutableDictionary alloc] init];
        answer->_servers = [[NSMutableDictionary alloc] init];
        
        
    }
    
    return answer;
    
}


-(id)initWithValue:(HLJsonObject *)value configurationService:(HLConfigurationService*)configurationService {
    
    
    HLSecurityConfiguration* answer = [super init];

    if( nil != answer ) { 
        
        NSString* identifier = [value stringForKey:@"identifier"];
        [answer setIdentifier:identifier];
        [answer setConfigurationService:configurationService];
        
        answer->_clients = [[NSMutableDictionary alloc] init];
        answer->_servers = [[NSMutableDictionary alloc] init];
        
        {
            HLJsonArray* subjects = [value jsonArrayForKey:@"subjects"];
            for( int i = 0, count = [subjects count]; i < count; i++ ) { 
                HLJsonObject* subjectData = [subjects jsonObjectAtIndex:i];
                
                NSString* subjectIdentifier = [subjectData stringForKey:@"identifier"];
                NSString* subjectPassword = [subjectData stringForKey:@"password"];
                NSString* subjectLabel = [subjectData stringForKey:@"label"];
                
                [answer addSubject:subjectIdentifier password:subjectPassword label:subjectLabel];
            }
        }
    }
    
    return answer;
    
    
}


-(void)dealloc { 
    
    [HLObjectTracker deallocated:self];
    
    [self setIdentifier:nil];
    [self setConfigurationService:nil];
    [self setClients:nil];
    [self setServers:nil];
    
    [self setRegisteredSubjects:nil];
    
}

#pragma mark fields


// identifier
//NSString* _identifier;
//@property (nonatomic, retain) NSString* identifier;
@synthesize identifier = _identifier;


// configurationService
//ConfigurationService* _configurationService;
//@property (nonatomic, retain) ConfigurationService* configurationService;
@synthesize configurationService = _configurationService;


// clients
//NSMutableDictionary* _clients;
//@property (nonatomic, retain) NSMutableDictionary* clients;
@synthesize clients = _clients;


// servers
//NSMutableDictionary* _servers;
//@property (nonatomic, retain) NSMutableDictionary* servers;
@synthesize servers = _servers;



// registeredSubjects
//SubjectGroup* _registeredSubjects;
//@property (nonatomic, retain) SubjectGroup* registeredSubjects;
@synthesize registeredSubjects = _registeredSubjects;



@end
