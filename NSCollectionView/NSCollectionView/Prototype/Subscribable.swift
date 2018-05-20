
import Foundation

/// Subscription is a container returned upon subscription to a subscribable object.
private final class Subscription {
    fileprivate weak var subscriber: AnyObject?
    
    fileprivate init(subscriber: AnyObject) {
        self.subscriber = subscriber
    }
}

/// Subscribable object implements the observer pattern.
public final class Subscribable<T> {
    
    fileprivate var subscriptions: [Subscription] = []
    
    public init() {
    }
    
    /**
     Subscribe to this object.
     
     - parameter subscriber: The subscriber wanting to subscribe to object notifications.
     */
    public func subscribe(_ subscriber: T) {
        assert(subscriber as? AnyObject != nil)
        if let object = subscriber as? AnyObject {
            self.subscriptions.append(Subscription(subscriber: object))
        }
    }
    
    /**
     Unsubscribe from this object.
     
     - parameter subscriber: The subsriber that has previously subscribed.
     */
    public func unsubscribe(_ subscriber: T) {
        assert(subscriber as? AnyObject != nil)
        if let object = subscriber as? AnyObject {
            self.subscriptions = self.subscriptions.filter { $0.subscriber != nil && $0.subscriber !== object }
        }
    }
    
    /// Removes all subscribers from object.
    public func unsubscribeAll() {
        self.subscriptions = []
    }
    

    /**
     Notifies all subscribers.
     Subscribers are allowed to unsubscrible while being called from this method.
     
     - parameter subscriber: The subscriber to notify.
     */
    public func notifyAll(_ handler: @escaping (_ subscriber: T) -> Void) -> Void {
        for subscription in subscriptions {
            guard let subscriber = subscription.subscriber as? T else {
                continue
            }
            handler(subscriber)
        }
    }
    
}
