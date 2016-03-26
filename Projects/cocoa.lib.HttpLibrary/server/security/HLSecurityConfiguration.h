//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "HLAuthorization.h"
#import "HLClientSecurityConfiguration.h"
#import "HLConfigurationService.h"
#import "HLSecurityAdapter.h"
#import "HLSecurityConfiguration_Generated.h"
#import "HLServerSecurityConfiguration.h"
#import "HLSubjectGroup.h"

@interface HLSecurityConfiguration : HLSecurityConfiguration_Generated <HLClientSecurityConfiguration,HLServerSecurityConfiguration> {
    
    // identifier
	NSString* _identifier;
	//@property (nonatomic, retain) NSString* identifier;
	//@synthesize identifier = _identifier;

    
    // configurationService
	HLConfigurationService* _configurationService;
	//@property (nonatomic, retain) ConfigurationService* configurationService;
	//@synthesize configurationService = _configurationService;
    

	// clients
	NSMutableDictionary* _clients;
	//@property (nonatomic, retain) NSMutableDictionary* clients;
	//@synthesize clients = _clients;
    
    
    // servers
	NSMutableDictionary* _servers;
	//@property (nonatomic, retain) NSMutableDictionary* servers;
	//@synthesize servers = _servers;
    
    // registeredSubjects
	HLSubjectGroup* _registeredSubjects;
	//@property (nonatomic, retain) SubjectGroup* registeredSubjects;
	//@synthesize registeredSubjects = _registeredSubjects;

}


+(HLSecurityConfiguration*)TEST;

+(HLSecurityConfiguration*)build:(id<HLSecurityAdapter>)securityAdapter configurationService:(HLConfigurationService*)configurationService;




@end
