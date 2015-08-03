//
//  LogLevel.swift
//  swift-http-server
//
//  Created by rlong on 27/07/2015.
//
//

import Foundation

enum LogLevel {
    
    case Debug
    case Info
    case Warn
    case Error
    
    
    func toString() -> String {
        switch self {
        case .Debug:
            return "DBG"
        case .Info:
            return "INF"
        case .Warn:
            return "WRN"
        case .Error:
            return "ERR"
        }
    }
    
}
