//
//  LogEvent.swift
//  swift-http-server
//
//  Created by rlong on 27/07/2015.
//
//

import Foundation


class  LogEvent {
    
    let category: String
    let content: String
    let function: String
    let level: LogLevel
    let thread: NSThread
    var when: NSDate?

    init( category: String, content: String, function: String, level: LogLevel, thread: NSThread ) {

        self.category = category
        self.content = content
        self.function = function
        self.level = level
        self.thread = thread
        
    }
    
}