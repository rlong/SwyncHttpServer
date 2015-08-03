//
//  DataEntity.swift
//  SyncHttpServer
//
//  Created by rlong on 3/08/2015.
//
//

import Foundation
import FoundationAnnex

class DataEntity: Entity {
    
    
    var streamContent: NSInputStream?
    let data: NSData
    
    init( data: NSData) {

        self.data = data
        
    }
    
    func getContent() -> NSInputStream {
        
        StreamHelper.closeStream( streamContent, swallowErrors: false);
        
        streamContent = NSInputStream(data: data )
        if( nil == streamContent ) {
            ErrorHelper.fail( "nil == streamContent" )
        }
        streamContent?.open()
        return streamContent!
        
    }

    var mimeType : String? {
        return nil
    }
    
    
    func teardownForCaller( swallowErrors: Bool, file: String, function: String ) {
        
        StreamHelper.closeStream( streamContent, swallowErrors: swallowErrors, file: file, function: function )
        streamContent = nil
        
    }
    
    func writeToStream( destination: NSOutputStream, offset: Int, length: Int ) {
        
        let content = self.getContent()
        InputStreamHelper.seek( content, to: offset )
        InputStreamHelper.writeFrom( content, count: length, to: destination)
    }
    
}