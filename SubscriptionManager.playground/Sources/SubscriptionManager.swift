import Foundation


private struct Subscription<InfoType> : Equatable, Hashable {
    let identifier: NSUUID = NSUUID()
    let subscriber: ObjectIdentifier
    let closure: (InfoType?) -> Void
    let queue: dispatch_queue_t
    var hashValue: Int { return identifier.hashValue }
    
    init(subscriber: ObjectIdentifier, queue: dispatch_queue_t, closure: (InfoType?) -> Void) {
        self.subscriber = subscriber
        self.queue = queue
        self.closure = closure
    }
    
    func fulfill(info: InfoType?) {
        dispatch_async(queue) {
            self.closure(info)
        }
    }
}

private func ==<T>(one: Subscription<T>, two: Subscription<T>) -> Bool {
    return one.identifier == two.identifier
}

public class SubscriptionManager<InfoType> {
    public var cancelSubscriptionsAfterFulfilling: Bool = false
    private var subscriptions: Set<Subscription<InfoType>> = []
    
    public init() {
        
    }
    
    public func addSubscriptionForObject(subscriber: AnyObject, queue: dispatch_queue_t, closure: (InfoType?) -> Void) -> NSUUID {
        let subscriberID = ObjectIdentifier(subscriber)
        let subscription = Subscription(subscriber: subscriberID, queue: queue, closure: closure)
        subscriptions.insert(subscription)
        return subscription.identifier
    }
    
    public func cancelSubscriptionID(id: NSUUID) {
        for subscription in subscriptions {
            if subscription.identifier == id {
                subscriptions.remove(subscription)
                return
            }
        }
    }
    
    public func cancelSubscriptionsForObject(subscriber: AnyObject) {
        let subscriberToRemove = ObjectIdentifier(subscriber)
        for subscription in subscriptions {
            if subscription.subscriber == subscriberToRemove {
                subscriptions.remove(subscription)
            }
        }
    }
    
    public func cancelAllSubscriptions() {
        subscriptions.removeAll()
    }
    
    public func fulfillSubscriptionsWithInfo(info: InfoType?) {
        for subscription in subscriptions {
            subscription.fulfill(info)
        }
    }
}