//
//  AppDelegate.swift
//  SyncHttpServer
//
//  Created by rlong on 3/08/2015.
//
//

import Cocoa
import FoundationAnnex

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let log = Log( category: AppDelegate.self )



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        LogQueue.setupAsyncRootLogConsumer()
        
        log.enteredMethod();
        
        let i = 4;
        log.debug( i, "i");
        log.warn( i, "i");
        log.error( i, "i");
        let str = "str"
        log.debug( str, "str" )
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
        log.enteredMethod()
        
    }


}

