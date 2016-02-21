//
//  LogPrinter.swift
//  swift-http-server
//
//  Created by rlong on 27/07/2015.
//
//

import Foundation


class NSLogPrinter : LogConsumer {
    
    
    
    func consume(event: LogEvent) {
        
        
        var level: String
        
        switch event.level {
        case .Debug:
            level = " DBG"
        case .Info:
            level = " INF"
        case .Warn:
            level = "-WRN"
        case .Error:
            level = "*ERR"
        }
        NSLog( "\(level) \(event.thread.name).\(event.category).\(event.function) \(event.content)" )

    }
}