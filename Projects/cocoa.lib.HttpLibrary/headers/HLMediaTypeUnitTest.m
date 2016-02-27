// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLMediaType.h"
#import "HLMediaTypeUnitTest.h"


@implementation HLMediaTypeUnitTest


-(void)test1 {
    Log_enteredMethod();
}

-(void)testMultiPartFormData {
    
    
    JBMediaType* mediaType = [JBMediaType buildFromString:@"multipart/form-data; boundary=---------------------------114782935826962"];
    STAssertTrue( [@"multipart" isEqualToString:[mediaType type]], @"actual = '%@'", [mediaType type]);
    STAssertTrue( [@"form-data" isEqualToString:[mediaType subtype]], @"actual = '%@'", [mediaType subtype]);

    NSString* actualBoundary = [mediaType getParameterValue:@"boundary" defaultValue:nil];
    STAssertTrue( [@"---------------------------114782935826962" isEqualToString:actualBoundary], @"actual = '%@'", actualBoundary );
    
    
    
    
}


-(void)testTextPlain  {

    JBMediaType* mediaType = [JBMediaType buildFromString:@"text/plain"];
    STAssertTrue( [@"text" isEqualToString:[mediaType type]], @"actual = '%@'", [mediaType type]);
    STAssertTrue( [@"plain" isEqualToString:[mediaType subtype]], @"actual = '%@'", [mediaType subtype]);

    
}


-(void)testApplicationXZipCompresssed {
    

    JBMediaType* mediaType = [JBMediaType buildFromString:@"application/x-zip-compressed"];
    STAssertTrue( [@"application" isEqualToString:[mediaType type]], @"actual = '%@'", [mediaType type]);
    STAssertTrue( [@"x-zip-compressed" isEqualToString:[mediaType subtype]], @"actual = '%@'", [mediaType subtype]);

    
}
@end
