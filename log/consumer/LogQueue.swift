//
//  QueueConsumer.swift
//  swift-http-server
//
//  Created by rlong on 28/07/2015.
//
//

import Foundation


class LogQueue : LogConsumer {
 
    
    enum LockState: Int {
        
        case NoEventsPending = 1
        case EventsPending = 2
    }

    let queueLock: NSConditionLock
    var queue: [LogEvent]
   
    init() {
    
        queueLock = NSConditionLock(condition: LockState.NoEventsPending.rawValue)
        queue = []
        
    }
    
    func consume( event: LogEvent ) {
        
        queueLock.lock()
        
        queue.append( event )

        queueLock.unlockWithCondition(LockState.EventsPending.rawValue)
        
    }
    
    func dequeue() -> LogEvent {
        queueLock.lockWhenCondition(LockState.EventsPending.rawValue)
        
        let answer = queue.removeAtIndex(0)
        
        if 0 == queue.count {
            queueLock.unlockWithCondition(LockState.NoEventsPending.rawValue)
        } else {
            queueLock.unlockWithCondition(LockState.EventsPending.rawValue)
        }
        
        return answer
    }
    
    static func setupAsyncRootLogConsumer( asyncDelegate: LogConsumer = LogPrinter() ) {
        
        let logQueue = LogQueue()
        RootLogConsumer.instance.delegate = logQueue
        
        var queueReader = LogQueueReader(logQueue: logQueue, consumer: asyncDelegate )
        queueReader.start()
        
    }
    
}