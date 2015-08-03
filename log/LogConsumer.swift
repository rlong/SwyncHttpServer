//
//  LogConsumer.swift
//  swift-http-server
//
//  Created by rlong on 27/07/2015.
//
//

import Foundation


protocol LogConsumer {
    
    func consume( event: LogEvent );
}