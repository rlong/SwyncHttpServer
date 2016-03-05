//
//  va_screen_local_storage_BrowseConductorHelper.m
//  vlc_amigo
//
//  Created by rlong on 14/02/13.
//
//

#import <MobileCoreServices/MobileCoreServices.h>


#import "JBLog.h"

#import "HLCommonObjects.h"

#import "VPStorageSelectConductorHelper.h"
#import "XPStorageMetaData.h"

@implementation VPStorageSelectConductorHelper

//+(void)alertNoFilesSelected {
//    
//	NSString* title = @"No Files Selected";
//	NSString* message = @"Select some files and try again";
//	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//	[alert show];
//	[alert release];
//}
//
//
//+(void)removeSelectAllFromPlayToolbar:(XP_common_StorageSelectView*)view {
//    
//    
//    UIToolbar* playToolbar = [view playToolbar];
//    NSArray* toolbarItems = [playToolbar items];
//    NSMutableArray* updatedToolbarItems = [[NSMutableArray alloc] initWithArray:toolbarItems];
//    [updatedToolbarItems autorelease];
//
//    UIBarButtonItem* target = [view selectAll];
//    bool foundTarget = false;
//    
//    for( int i = 0, count = [updatedToolbarItems count]; i < count; i++ ) {
//        NSObject* candidate = [updatedToolbarItems objectAtIndex:i];
//        if( target == candidate) {
//            [updatedToolbarItems removeObjectAtIndex:i];
//            foundTarget = true;
//            break; // our work is done
//        }
//            
//    }
//    
//    if( !foundTarget ) {
//        Log_warn(@"!foundTarget");
//    } else {
//        [playToolbar setItems:updatedToolbarItems];
//    }
//    
//}

// vvv http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database

+(NSString*) fileMIMEType:(NSString*) file {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[file pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return (__bridge NSString *)MIMEType;
}

// ^^^ http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database

+(NSString*)getContentTypeForLocalStorageFilename:(NSString*)filename {
    

    NSString* answer = [XPStorageMetaData getContentTypeForFilename:filename];
    
    if( nil == answer ) {
        
        answer = [self fileMIMEType:filename];
        
        if( nil == answer ) {
            Log_warnFormat(@"nil == answer; will return'text/plain'; filename = '%@'", filename);
            answer = @"text/plain"; // same as given by nginx
        }
    }
    Log_debugString( answer );
    return answer;

}

@end
