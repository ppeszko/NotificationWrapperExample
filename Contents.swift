import UIKit

struct Payment { }

enum PaymentResponse {
    case Accepted(Payment)
    case Rejected(Payment)
}

// It's just an example for notifications. The rest can be safely ignored :)
class SadPaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NSNotificationCenter.defaultCenter()

        // MARK: ლ( `Д’ ლ)
        // This tells Notfication Center that we are interested in updates.
        notificationCenter.addObserver(self,
                                       selector: #selector(SadPaymentViewController.paymentNotificationReceived(_:)),
                                       name: "PaymentViewControllerNotificationRejected",
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(SadPaymentViewController.paymentNotificationReceived(_:)),
                                       name: "PaymentViewControllerNotificationAccepted",
                                       object: nil)
    }

    func paymentServiceDidReturn(paymentResponse: PaymentResponse) {
        let notificationCenter = NSNotificationCenter.defaultCenter()

        switch paymentResponse {
        case .Accepted(_):
            // MARK: •́︵•̀
            // And this is how we post notifications
            notificationCenter.postNotificationName("PaymentViewControllerNotificationRejected",
                                                    object: nil,
                                                    userInfo: nil)
        case .Rejected(_):
            notificationCenter.postNotificationName("PaymentViewControllerNotificationAccepted",
                                                    object: nil,
                                                    userInfo: nil)
        }
    }

    func paymentNotificationReceived(notification: NSNotification) {
        //FIXIT: Write this code before release, okay? Bye, I'm off for vacation. ᕕ( ᐛ )ᕗ
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

// In the past I was calling it Notification but iOS10 
// NSNotification was renamed to Notification, so ¯\_(ツ)_/¯
protocol Notifiable: RawRepresentable {

    func post(userInfo aUserInfo: [NSObject : AnyObject]?, object anObject: AnyObject?)
    func observe(observer: AnyObject, selector aSelector: Selector, object anObject: AnyObject?)

    func name() -> String

    func notificationCenter() -> NSNotificationCenter

}

extension Notifiable {

    func post(userInfo aUserInfo: [NSObject : AnyObject]? = nil, object anObject: AnyObject? = nil) {
        notificationCenter().postNotificationName(self.name(),
            object: anObject,
            userInfo: aUserInfo)
    }

    func observe(observer: AnyObject, selector aSelector: Selector, object anObject: AnyObject? = nil) {
        notificationCenter().addObserver(observer,
            selector: aSelector,
            name: name(),
            object: anObject)
    }

    func name() -> String {
        return "\(self.dynamicType).\(self.rawValue)"
    }

    func notificationCenter() -> NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }

    var description: String {
        return name()
    }

}

enum PaymentNotifications: String, Notifiable {
    case accepted
    case rejected
}

// It's just an example for notifications. The rest can be safely ignored :)
class HappyPaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        PaymentNotifications.accepted.observe(self,
                                              selector: #selector(HappyPaymentViewController.paymentNotificationReceived(_:)))
        PaymentNotifications.rejected.observe(self,
                                              selector: #selector(HappyPaymentViewController.paymentNotificationReceived(_:)))
    }

    func paymentServiceDidReturn(paymentResponse: PaymentResponse) {
        switch paymentResponse {
        case .Accepted(_):
            PaymentNotifications.accepted.post()
        case .Rejected(_):
            PaymentNotifications.rejected.post()
        }
    }

    func paymentNotificationReceived(notification: NSNotification) {
        //FIXIT: Write this code before release, okay? Bye, I'm off for vacation. ᕕ( ᐛ )ᕗ
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
