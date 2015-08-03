//
//  HttpStatus.swift
//  swift-http-server
//
//  Created by rlong on 29/07/2015.
//

import Foundation


enum HttpStatus: Int {
    
    case SWITCHING_PROTOCOLS_101 = 101;

    case OK_200 = 200;
    case NO_CONTENT_204 = 204;
    case PARTIAL_CONTENT_206 = 206;
    
    case NOT_MODIFIED_304 = 304;
    
    case BAD_REQUEST_400 = 400;
    case UNAUTHORIZED_401 = 401;
    case FORBIDDEN_403 = 403;
    case NOT_FOUND_404 = 404;
    case REQUEST_ENTITY_TOO_LARGE_413 = 413;
    
    case INTERNAL_SERVER_ERROR_500 = 500;
    case NOT_IMPLEMENTED_501 = 501;
    
    enum ErrorDomain: String {
        
        case BAD_REQUEST_400 = "HttpStatus.BAD_REQUEST_400";
        case UNAUTHORIZED_401 = "HttpStatus.UNAUTHORIZED_401";
        case NOT_FOUND_404 = "HttpStatus.NOT_FOUND_404";

    }
    
    var reason: String {


        
        
        get {
            switch self {
            case .SWITCHING_PROTOCOLS_101:
                return "Switching Protocols"
                
            case .OK_200:
                return "OK"
            case .NO_CONTENT_204:
                return "No Content"
            case .PARTIAL_CONTENT_206:
                return "Partial Content"
                
            case .NOT_MODIFIED_304:
                return "Not Modified"
                
            case .BAD_REQUEST_400:
                return "Bad Request"
            case .UNAUTHORIZED_401:
                return "Unauthorized"
            case .FORBIDDEN_403:
                return "Forbidden"
            case .NOT_FOUND_404:
                return "Not Found"
            case .REQUEST_ENTITY_TOO_LARGE_413:
                return "Request Entity Too Large"
                
            case .INTERNAL_SERVER_ERROR_500:
                return "Internal Server Error"
            case .NOT_IMPLEMENTED_501:
                return "Not Implemented"
            }
        }
    }

}


