//
//  Range.swift
//  SyncHttpServer
//
//  Created by rlong on 6/08/2015.
//
//

import Foundation
import FoundationAnnex



class Range {
    
    let firstBytePosition: Int;
    let lastBytePosition: Int;
    let toString: String;
    
    
//    init( value: String ) {
//        self.toString = value
//        
//        
//        
//        
//        
//    }
    
    init() {
        
    }
    
    
    static func buildFromString( value: String ) -> Range? {
        
        SyncHttpServer.ToDo.refactor( "use swift 2.0 guard ...")
        let rangeOfBytes = value.rangeOfString( "bytes=" )
        if rangeOfBytes == nil {
            ErrorHelper.fail( "rangeOfBytes == nil; value = '\(value)'" )
            return nil;
        }

        let range = value.substringFromIndex( rangeOfBytes!.endIndex )
        

        SyncHttpServer.ToDo.refactor( "use swift 2.0 guard ...")
        let firstHyphen = range.rangeOfString( "-" )
        if firstHyphen == nil {
            ErrorHelper.fail( "firstHyphen == nil; value = '\(value)'" )
            return nil;
        }
        
        let lastHyphen = range.rangeOfString( "-", options: NSStringCompareOptions.BackwardsSearch )
        
        SyncHttpServer.ToDo.refactor( "use swift 2.0 guard ...")
        if( firstHyphen!.startIndex == lastHyphen!.startIndex ) {
            ErrorHelper.fail( "firstHyphen!.startIndex == lastHyphen!.startIndex; value = '\(value)'" )
            return nil;
            
        }

        return nil;
        
    }
    
    
    
    
}