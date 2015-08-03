//
//  Entity.swift
//  swift-http-server
//
//  Created by rlong on 29/07/2015.
//
//

import Foundation


protocol Entity {
    
    var mimeType : String? { get }
    func teardownForCaller( swallowErrors: Bool, file: String, function: String )
    func writeToStream( destination: NSOutputStream, offset: Int, length: Int )
    
}