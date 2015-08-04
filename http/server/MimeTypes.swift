//
//  MimeTypes.swift
//  SyncHttpServer
//
//  Created by rlong on 4/08/2015.
//
//

import Foundation


public class MimeTypes {
    
    let mimeTypes: [String: String]
    public static var defaultMimeTypes: MimeTypes = MimeTypes()
    
    init() {
        
        var mimeTypes = [String: String]()

        mimeTypes[".css"] = "text/css"
        mimeTypes[".eot"] = "application/vnd.ms-fontobject" // http://symbolset.com/blog/properly-serve-webfonts/
        mimeTypes[".html"] = "text/html"
        mimeTypes[".gif"] = "image/gif"
        mimeTypes[".ico"] = "image/x-icon"
        mimeTypes[".jpeg"] = "image/jpeg"
        mimeTypes[".jpg"] = "image/jpeg"
        mimeTypes[".js"] = "application/javascript"
        mimeTypes[".json"] = MimeType.ApplicationJSON.rawValue
        mimeTypes[".map"] = MimeType.ApplicationJSON.rawValue // http://stackoverflow.com/questions/19911929/what-mime-type-should-i-use-for-source-map-files
        mimeTypes[".png"] = "image/png"
        mimeTypes[".svg"] = "image/svg+xml" // http://www.ietf.org/rfc/rfc3023.txt, section 8.19
        mimeTypes[".ts"] = "text/x.typescript" // http://stackoverflow.com/questions/13213787/whats-the-mime-type-of-typescript
        mimeTypes[".ttf"] = "application/x-font-ttf" // http://symbolset.com/blog/properly-serve-webfonts/
        mimeTypes[".woff"] = "application/x-font-woff" // http://symbolset.com/blog/properly-serve-webfonts/
        mimeTypes[".woff2"] = "application/font-woff2"   // http://stackoverflow.com/questions/25796609/font-face-isnt-working-in-iis-8-0
        
        self.mimeTypes = mimeTypes
        
    }
    
    public func mimeTypeForPath( path: String ) -> String? {
    
        if let lastDot = path.rangeOfString( "." , options: NSStringCompareOptions.BackwardsSearch) {
            let pathExtension = path.substringFromIndex( lastDot.startIndex )
            return mimeTypes[pathExtension]
        } else {
            return nil
        }
    }
    
}