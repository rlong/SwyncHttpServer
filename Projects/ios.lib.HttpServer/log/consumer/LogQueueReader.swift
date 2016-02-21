//
//  LogQueueReader.swift
//  swift-http-server
//
//  Created by rlong on 28/07/2015.
//
//

import Foundation



class LogQueueReader  {

    var logQueue: LogQueue
    var consumer: LogConsumer
    
    init( logQueue: LogQueue, consumer: LogConsumer ) {
        
        self.logQueue = logQueue
        self.consumer = consumer
        
    }
    
    func start() {
        
        let thread = NSThread(target:self, selector:"forwardLogEvents", object:nil)
        thread.start()
    }
    
    func forwardLogEvents() {
        
        while true {
            let event = logQueue.dequeue()
            consumer.consume(event)
        }
    }
    
}


