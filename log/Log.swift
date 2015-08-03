//
//  Log.swift
//  swift-http-server
//
//  Created by rlong on 26/07/2015.
//
//

import Foundation




class Log {
    
    internal var debug : LogCategory?
    internal var warn : LogCategory
    internal var error : LogCategory
    
    init( category: Any?, logConsumer: LogConsumer = RootLogConsumer.instance, file: String = __FILE__, line: Int = __LINE__ ) {
    
    
        var name : String
        if nil == category {
            name = file + "." + String( line )
        } else {

            name = toString( category! )
        }
        
        debug = LogCategory( category: name,  level: LogLevel.Debug, logConsumer: logConsumer )
        warn = LogCategory( category: name,  level: LogLevel.Warn, logConsumer: logConsumer )
        error = LogCategory( category: name,  level: LogLevel.Error, logConsumer: logConsumer )
        
    }
    
    func enteredMethod( function: String = __FUNCTION__ ) {
        debug?.enteredMethod(function);
    }
    
    func error( value: String?, _ name: String, function: String = __FUNCTION__ ) {
        error.logValue( value, name: name, function: function)
    }
    
    func error<T>( value: T?, _ name: String, function: String = __FUNCTION__ ) {
        error.logValue( value, name: name, function: function)
    }


    func debug( value: String?, _ name: String, function: String = __FUNCTION__ ) {
        debug?.logValue( value, name: name, function: function)
    }

    func debug<T>( value: T?, _ name: String, function: String = __FUNCTION__ ) {
        debug?.logValue( value, name: name, function: function)
    }

    func warn( value: String?, _ name: String, function: String = __FUNCTION__ ) {
        warn.logValue( value, name: name, function: function)
    }
    
    func warn<T>( value: T?, _ name: String, function: String = __FUNCTION__ ) {
        warn.logValue( value, name: name, function: function)
    }



}