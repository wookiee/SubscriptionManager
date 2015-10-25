//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()


let subMgr = SubscriptionManager<Int>()

subMgr.addSubscriptionForObject(NSNull(), queue: dispatch_get_main_queue()) { i in
    print("Got info! \(i)")
}

subMgr.fulfillSubscriptionsWithInfo(42)
