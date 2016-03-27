// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CAStringHelper.h"
#import "CADataHelper.h"

#import "JBDelimiterFound.h"
#import "JBEntity.h"
#import "JBMultiPartReader.h"
#import "JBMultiPartReaderUnitTest.h"
#import "JBTestMultiPartHandler.h"
#import "JBTestPartHandler.h"
#import "JBDataEntity.h"


@implementation JBMultiPartReaderUnitTest



-(void)test1 {
    Log_enteredMethod();
}


-(id<JBEntity>)buildEntity:(NSString*)multipartString {
    
    
    
    NSData* data = [CAStringHelper toUtf8Data:multipartString];
    
    JBDataEntity* answer = [[JBDataEntity alloc] initWithData:data];
    [answer autorelease];
    
    return answer;
    
}

-(id<JBEntity>)buildEntityWithMultipartLines:(NSString**)multipartLines {
    
    NSMutableString* multipartString = [[NSMutableString alloc] init];
    [multipartString autorelease];
    
    for( int i = 0; nil != multipartLines[i]; i++ ) {
        [multipartString appendString:multipartLines[i]];
        [multipartString appendString:@"\r\n"];
    }
    
    return [self buildEntity:multipartString];
    
}


-(void)testDelimiterDetection {
    
    
    Log_enteredMethod();
    
    
    NSString* multipartLines[] = {
        @"",
        @"-----------------------------114782935826962",
        @"Content-Disposition: form-data; name=\"datafile\"; filename=\"test.txt\"",
        @"Content-Type: text/plain",
        @"",
        @"0123",
        @"4567",
        @"89ab",
        @"cdef",
        @"-----------------------------114782935826962--",
        nil
    };
    
    
    id<JBEntity> entity = [self buildEntityWithMultipartLines:multipartLines];
    JBMultiPartReader* reader = [[JBMultiPartReader alloc] initWithBoundary:@"---------------------------114782935826962" entity:entity];
    
    id<JBDelimiterIndicator> indicator = [reader skipToNextDelimiterIndicator];
    XCTAssertNotNil(indicator, @"actual = %p", indicator);
    XCTAssertTrue( [indicator isKindOfClass:[JBDelimiterFound class]], @"NSStringFromClass([indicator class]) = '%@'", NSStringFromClass([indicator class]));
    JBDelimiterFound* delimiterFound = (JBDelimiterFound*)indicator;
    XCTAssertTrue( 0 == [delimiterFound startOfDelimiter], @"actual = %d", [delimiterFound startOfDelimiter] );
    XCTAssertFalse( [delimiterFound isCloseDelimiter], @"actual = %d", [delimiterFound isCloseDelimiter]);
    
    
    // Content-Disposition
    NSMutableData* stringBuffer = [[NSMutableData alloc] init];
    NSString* contentDisposition = [reader readLine:stringBuffer];
    XCTAssertTrue( [multipartLines[2] isEqualToString:contentDisposition], @"actual = %@", contentDisposition );
    
    // Content-Type
    NSString* contentType = [reader readLine:stringBuffer];
    XCTAssertTrue( [multipartLines[3] isEqualToString:contentType], @"actual = %@", contentType );
    
    // empty line
    NSString* emptyLine = [reader readLine:stringBuffer];
    XCTAssertTrue( [@"" isEqualToString:emptyLine], @"actual = %@", emptyLine );
    
    // ending indicator
    indicator = [reader skipToNextDelimiterIndicator];
    XCTAssertNotNil(indicator, @"actual = %p", indicator);
    XCTAssertTrue( [indicator isKindOfClass:[JBDelimiterFound class]], @"NSStringFromClass([indicator class]) = '%@'", NSStringFromClass([indicator class]));
    delimiterFound = (JBDelimiterFound*)indicator;
    XCTAssertTrue( [delimiterFound isCloseDelimiter], @"actual = %d", [delimiterFound isCloseDelimiter]);
    
}


-(void)testDoubleMultiPartForm {
    
    
    
    NSString* multipartLines[] = {
        @"",
        @"-----------------------------114782935826962",
        @"Content-Disposition: form-data; name=\"datafile\"; filename=\"test1.txt\"",
        @"Content-Type: text/plain",
        @"",
        @"0123",
        @"4567",
        @"89ab",
        @"cdef",
        @"-----------------------------114782935826962",
        @"Content-Disposition: form-data; name=\"datafile\"; filename=\"test2.txt\"",
        @"Content-Type: text/plain",
        @"",
        @"cdef",
        @"89ab",
        @"4567",
        @"0123",
        @"-----------------------------114782935826962--",
        nil
    };
    
    
    id<JBEntity> entity = [self buildEntityWithMultipartLines:multipartLines];
    JBMultiPartReader* reader = [[JBMultiPartReader alloc] initWithBoundary:@"---------------------------114782935826962" entity:entity];
    JBTestMultiPartHandler* testMultiPartHandler = [[JBTestMultiPartHandler alloc] init];
    [reader process:testMultiPartHandler];
    
    XCTAssertTrue( [testMultiPartHandler haveFoundCloseDelimiter], @"actual = %d", [testMultiPartHandler haveFoundCloseDelimiter]);
    XCTAssertTrue( 2 == [[testMultiPartHandler partHandlers] count], @"actual = %d", [[testMultiPartHandler partHandlers] count] );
    
    {
        JBTestPartHandler* firstTestPartHandler = [[testMultiPartHandler partHandlers] objectAtIndex:0];
        XCTAssertTrue( (16+6) == [[firstTestPartHandler data] length], @"actual = %d", [[firstTestPartHandler data] length] );
        NSString* expectedContent = @"0123\r\n4567\r\n89ab\r\ncdef";
        NSString* actualContent = [CADataHelper toUtf8String:[firstTestPartHandler data]];
        XCTAssertTrue( [expectedContent isEqualToString:actualContent], @"actual = %@", actualContent );
        
    }
    
    {
        
        JBTestPartHandler* secondTestPartHandler = [[testMultiPartHandler partHandlers] objectAtIndex:1];
        XCTAssertTrue( (16+6) == [[secondTestPartHandler data] length], @"actual = %d", [[secondTestPartHandler data] length] );
        NSString* expectedContent = @"cdef\r\n89ab\r\n4567\r\n0123";
        NSString* actualContent = [CADataHelper toUtf8String:[secondTestPartHandler data]];
        XCTAssertTrue( [expectedContent isEqualToString:actualContent], @"actual = %@", actualContent );
    }
    
}

-(NSString*)buildAttachment:(NSString*)contentSource length:(NSUInteger)length {
    NSMutableString* answer = [[NSMutableString alloc] init];
    [answer autorelease];
    
    NSUInteger remaining = length;
    while (remaining >= [contentSource length]) {
        [answer appendString:contentSource];
        remaining -= [contentSource length];
    }
    
    NSUInteger modulus = length % [contentSource length];
    
    for( NSUInteger i = 0; i < modulus; i++ ) {
        [answer appendFormat:@"%c", [contentSource characterAtIndex:i]];
    }
    
    return answer;

}

-(void)testSingleAttachmentWithBoundary:(NSString*)boundary contentSource:(NSString*)contentSource length:(NSUInteger)length {
    
    
    
    if (0 == length)
    {
        Log_debugString( contentSource );
    }
    
    NSString* attachment = [self buildAttachment:contentSource length:length];
    XCTAssertTrue( length == [attachment length], @"actual = %d", [attachment length]);
    
    NSMutableString* stringBuilder = [[NSMutableString alloc] init];
    [stringBuilder autorelease];
    

    [stringBuilder appendString:@"\r\n--"];
    [stringBuilder appendString:boundary];
    [stringBuilder appendString:@"\r\n"];
    
    [stringBuilder appendString:@"Content-Disposition: form-data; name=\"datafile\"; filename=\"test1.txt\"\r\n"];
    [stringBuilder appendString:@"Content-Type: text/plain\r\n"];
    [stringBuilder appendString:@"\r\n"];

    [stringBuilder appendString:attachment];
    
    [stringBuilder appendString:@"\r\n--"];
    [stringBuilder appendString:boundary];
    [stringBuilder appendString:@"--\r\n"];
    
    
    id<JBEntity> entity = [self buildEntity:stringBuilder];
    JBMultiPartReader* reader = [[JBMultiPartReader alloc] initWithBoundary:boundary entity:entity];
    [reader autorelease];
    
    JBTestMultiPartHandler* testMultiPartHandler = [[JBTestMultiPartHandler alloc] init];
    [reader process:testMultiPartHandler];
    
    XCTAssertTrue( [testMultiPartHandler haveFoundCloseDelimiter], @"actual = %d", [testMultiPartHandler haveFoundCloseDelimiter]);
    XCTAssertTrue( 1 == [[testMultiPartHandler partHandlers] count], @"actual = %d", [[testMultiPartHandler partHandlers] count] );
    
    JBTestPartHandler* firstTestPartHandler = [[testMultiPartHandler partHandlers] objectAtIndex:0];
    XCTAssertTrue( [attachment length] == [[firstTestPartHandler data] length], @"actual = %d", [[firstTestPartHandler data] length] );
    
    NSString* actualContent = [CADataHelper toUtf8String:[firstTestPartHandler data]];
    XCTAssertTrue( [attachment isEqualToString:actualContent], @"![attachment isEqualToString:actualContent]"); // `actual` value could be very large ... won't print to console
    

    
}


-(void)testSingleAttachmentWithBoundary:(NSString*)boundary contentSource:(NSString*)contentSource {
    
    for (NSUInteger i = 0; i < 10; i++)
    {
        [self testSingleAttachmentWithBoundary:boundary contentSource:contentSource length:i];
    }
    
    NSUInteger lowerBound = ([JBMultiPartReader BUFFER_SIZE] / 2) - 10;
    NSUInteger upperBound = ([JBMultiPartReader BUFFER_SIZE] / 2) + 10;
    
    for (NSUInteger i = lowerBound; i < upperBound; i++)
    {
        [self testSingleAttachmentWithBoundary:boundary contentSource:contentSource length:i];
    }

    lowerBound = [JBMultiPartReader BUFFER_SIZE] - 200;
    upperBound = [JBMultiPartReader BUFFER_SIZE] + 10;
    
    for (NSUInteger i = lowerBound; i < upperBound; i++)
    {
        [self testSingleAttachmentWithBoundary:boundary contentSource:contentSource length:i];
    }
    
    lowerBound = ([JBMultiPartReader BUFFER_SIZE] * 2) - 200;
    upperBound = ([JBMultiPartReader BUFFER_SIZE] * 2) + 10;
    
    for (NSUInteger i = lowerBound; i < upperBound; i++)
    {
        [self testSingleAttachmentWithBoundary:boundary contentSource:contentSource length:i];
    }
    
    
    
}


-(void)testSingleAttachments {
    
    Log_enteredMethod();
    
    NSString* boundary = @"---------------------------114782935826962";
    
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"------"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"------\r\n"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"-----\r\n-"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"----\r\n--"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"---\r\n---"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"--\r\n----"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"-\r\n-----"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"\r\n------"];
    [self testSingleAttachmentWithBoundary:boundary contentSource:@"\r\n\r\n\r\n"];

    
}


-(void)testDoubleAttachmentsWithBoundary:(NSString*)boundary contentSource:(NSString*)contentSource length:(NSUInteger)length {
    
    
    
    if (0 == length)
    {
        Log_debugString( contentSource );
    }
    
    NSString* attachment = [self buildAttachment:contentSource length:length];
    XCTAssertTrue( length == [attachment length], @"actual = %d", [attachment length]);
    
    NSMutableString* stringBuilder = [[NSMutableString alloc] init];
    [stringBuilder autorelease];
    
    
    [stringBuilder appendString:@"\r\n--"];
    [stringBuilder appendString:boundary];
    [stringBuilder appendString:@"\r\n"];
    
    [stringBuilder appendString:@"Content-Disposition: form-data; name=\"datafile\"; filename=\"test1.txt\"\r\n"];
    [stringBuilder appendString:@"Content-Type: text/plain\r\n"];
    [stringBuilder appendString:@"\r\n"];
    
    [stringBuilder appendString:attachment];

    [stringBuilder appendString:@"\r\n--"];
    [stringBuilder appendString:boundary];
    [stringBuilder appendString:@"\r\n"];
    
    [stringBuilder appendString:@"Content-Disposition: form-data; name=\"datafile\"; filename=\"test1.txt\"\r\n"];
    [stringBuilder appendString:@"Content-Type: text/plain\r\n"];
    [stringBuilder appendString:@"\r\n"];
    
    [stringBuilder appendString:attachment];

    [stringBuilder appendString:@"\r\n--"];
    [stringBuilder appendString:boundary];
    [stringBuilder appendString:@"--\r\n"];
    
    
    id<JBEntity> entity = [self buildEntity:stringBuilder];
    JBMultiPartReader* reader = [[JBMultiPartReader alloc] initWithBoundary:boundary entity:entity];
    [reader autorelease];
    
    JBTestMultiPartHandler* testMultiPartHandler = [[JBTestMultiPartHandler alloc] init];
    [reader process:testMultiPartHandler];
    
    XCTAssertTrue( [testMultiPartHandler haveFoundCloseDelimiter], @"actual = %d", [testMultiPartHandler haveFoundCloseDelimiter]);
    XCTAssertTrue( 2 == [[testMultiPartHandler partHandlers] count], @"actual = %d", [[testMultiPartHandler partHandlers] count] );
    
    {
        JBTestPartHandler* firstTestPartHandler = [[testMultiPartHandler partHandlers] objectAtIndex:0];
        XCTAssertTrue( [attachment length] == [[firstTestPartHandler data] length], @"actual = %d", [[firstTestPartHandler data] length] );
        
        NSString* actualContent = [CADataHelper toUtf8String:[firstTestPartHandler data]];
        XCTAssertTrue( [attachment isEqualToString:actualContent], @"![attachment isEqualToString:actualContent]"); // `actual` value could be very large ... won't print to console
        
    }
    
    {
        JBTestPartHandler* secondTestPartHandler = [[testMultiPartHandler partHandlers] objectAtIndex:1];
        XCTAssertTrue( [attachment length] == [[secondTestPartHandler data] length], @"actual = %d", [[secondTestPartHandler data] length] );
        
        NSString* actualContent = [CADataHelper toUtf8String:[secondTestPartHandler data]];
        XCTAssertTrue( [attachment isEqualToString:actualContent], @"![attachment isEqualToString:actualContent]"); // `actual` value could be very large ... won't print to console
        
    }
    
}

-(void)testDoubleAttachmentsWithBoundary:(NSString*)boundary contentSource:(NSString*)contentSource {
    
    for (NSUInteger i = 0; i < 10; i++)
    {
        [self testDoubleAttachmentsWithBoundary:boundary contentSource:contentSource length:i];
    }
    
    NSUInteger lowerBound = ([JBMultiPartReader BUFFER_SIZE] / 2) - 10;
    NSUInteger upperBound = ([JBMultiPartReader BUFFER_SIZE] / 2) + 10;
    
    for (NSUInteger i = lowerBound; i < upperBound; i++)
    {
        [self testDoubleAttachmentsWithBoundary:boundary contentSource:contentSource length:i];
    }
    
    lowerBound = [JBMultiPartReader BUFFER_SIZE] - 200;
    upperBound = [JBMultiPartReader BUFFER_SIZE] + 10;
    
    for (NSUInteger i = lowerBound; i < upperBound; i++)
    {
        [self testDoubleAttachmentsWithBoundary:boundary contentSource:contentSource length:i];
    }
    
    lowerBound = ([JBMultiPartReader BUFFER_SIZE] * 2) - 200;
    upperBound = ([JBMultiPartReader BUFFER_SIZE] * 2) + 10;
    
    for (NSUInteger i = lowerBound; i < upperBound; i++)
    {
        [self testDoubleAttachmentsWithBoundary:boundary contentSource:contentSource length:i];
    }
    
}

-(void)testDoubleAttachments {
    
    Log_enteredMethod();
    
    NSString* boundary = @"---------------------------114782935826962";
    
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"------"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"------\r\n"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"-----\r\n-"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"----\r\n--"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"---\r\n---"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"--\r\n----"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"-\r\n-----"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"\r\n------"];
    [self testDoubleAttachmentsWithBoundary:boundary contentSource:@"\r\n\r\n\r\n"];
    
    
}



@end
