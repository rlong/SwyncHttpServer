//
//  RootLogConsumer.swift
//  swift-http-server
//
//  Created by rlong on 27/07/2015.
//
//

import Foundation


class RootLogConsumer : LogConsumer {
    
    static let instance = RootLogConsumer()
    
    var delegate: LogConsumer
    
    init() {
        delegate = LogPrinter()
    }
    
    
    func consume( event: LogEvent ) {
        
        delegate.consume( event )
        
    }

    


}