//
//  LogCategory.swift
//  swift-http-server
//
//  Created by rlong on 27/07/2015.
//
//

import Foundation


class LogCategory {
    
    internal let category: String
    internal let level: LogLevel
    internal let logConsumer: LogConsumer
    
    init( category: String, level: LogLevel, logConsumer: LogConsumer ) {
        
        self.category = category
        self.level = level
        self.logConsumer = logConsumer
        
    }
    
    func enteredMethod( function: String ) {
        
        let event = LogEvent( category: category, content: "entered", function: function, level: level, thread: NSThread.currentThread() )
        logConsumer.consume( event );
        
    }
    
    
    func logValue<T>( value: T?, name: String, function: String ) {

        let content: String
        
        if( nil == value ) {
            content = "\(name) = nil"
            
        } else {
            content = "\(name) = \(value!)"
        }
        
        let event = LogEvent( category: category, content: content, function: function, level: level, thread: NSThread.currentThread() )
        logConsumer.consume( event );
        
    }
    
    
    func logValue( value: String?, name: String, function: String ) {
        
        let content: String
        
        if( nil == value ) {
            content = "\(name) = nil"
            
        } else {
            content = "\(name) = '\(value!)'"
        }
        
        let event = LogEvent( category: category, content: content, function: function, level: level, thread: NSThread.currentThread() )
        logConsumer.consume( event );
        
    }

    
//    func logValue( value: Int?, name: String, function: String ) {
//        
//        let content: String
//        
//        if( nil == value ) {
//            content = "\(name) = nil"
//            
//        } else {
//            content = "\(name) = \(value)"
//        }
//        
//        let event = LogEvent( category: category, content: content, function: function, level: level, thread: NSThread.currentThread() )
//        logConsumer.consume( event );
//    }



    
}
