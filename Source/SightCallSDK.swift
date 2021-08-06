//
//  SightCallSDK.swift
//  USDKDemo
//
//  Created by Jason Jobe on 2/28/21.
//

import Foundation
import LSUniversalSDK

public protocol SightCallManager {
    var sightCall: SightCallSDK! { get }
}


open class SightCallSDK: NSObject, LSUniversalDelegate {
    
    var window: UIWindow?
    var ls_sdk = LSUniversal()

    public init (window: UIWindow?) {
        self.window = window
        super.init()
        ls_sdk.delegate = self
    }

    public func start(with url: URL) {
        ls_sdk.start(with: url.absoluteString)
    }

    public func start(with url_str: String) {
        ls_sdk.start(with: url_str)
    }

    public func showDisplayNameAlert(_ alertController: UIAlertController?) {
        present(alertController)
    }
    
    public func displayConsent(with description: LSConsentDescription?) {
        let controller = UIAlertController(title: description?.title, message: description?.message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: description?.cancelLabel, style: .cancel, handler: { _ in
            description?.consent?(false)
        }))
        controller.addAction(UIAlertAction(title: description?.eulaURL, style: .default, handler: { _ in
            guard let urlString = description?.eulaURL
            else { return }
            print (urlString)
            /**
             Show the content of the url page
             **/
        }))
        controller.addAction(UIAlertAction(title: description?.agreeLabel, style: .default, handler: { _ in
            description?.consent?(true)
        }))
        present(controller)
    }
    
    public func connectionEvent(_ status: lsConnectionStatus_t) {
        //            print (#function, #line, "\(status)", status.rawValue)
        switch status {
        case .callActive:
            present(ls_sdk.callViewController)
        case .disconnecting:
            dismissPresentedViewControler()
        default:
            break
        }
    }
    
    public func connectionError(_ error: lsConnectionError_t) {
        print (#function, #line, "\(error)", error.rawValue)
    }
    
    public func callReport(_ callEnd: LSCallReport) {
        print (#function, #line, callEnd)
    }
}

extension SightCallSDK {
    
    open func present (_ viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else { return }
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(viewController, animated: animated, completion: nil)
        }
    }
    
    open func dismissPresentedViewControler() {
        DispatchQueue.main.async {
            self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
}

// MARK: UIViewController Extenstion

public extension UIViewController {
    var sightCall: SightCallSDK? {
        var target: UIResponder? = self
        while target != nil {
//            print (#function, target?.className ?? "<Responder>")
            if let mgr = target as? SightCallManager {
                return mgr.sightCall
            }
            if let scene = target as? UIWindowScene,
               let mgr = scene.delegate as? SightCallManager {
                return mgr.sightCall
            }
            target = target?.next
        }
        return nil
    }
}


public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
