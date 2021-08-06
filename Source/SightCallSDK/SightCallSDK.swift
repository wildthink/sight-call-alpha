//
//  SightCallSDK.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 2/28/21.
//

import Foundation
import LSUniversalSDK

public protocol SightCallManager {
    var sightCall: SightCallSDK! { get }
}


open class SightCallSDK: NSObject, LSUniversalDelegate {
    
    /*
     idle: no valid endpoint available
     ready: has valid enpoint, including pin for CODE
     calling: connection requested
     connected: active call in progress
     */
    enum State { case idle, ready, calling, connected }
    
//    var window: UIWindow?
    var presentingController: UIViewController?
    
    var ls_sdk = LSUniversal()
        
//    var agentRegistration: String { "https://mobile.sightcall.com/register/41cc8f34f12" }
//    var apnKey: String { "Sightcall IOS" }
//    var apnToken: String {
//            "e12e3fba6c54a72b0aad681d4d15ace7a529e7035d0cfb55e2b034ef9d3788c7"
//    }
    
    var agentRegistration: String?
    var agentCode: LSMARegistrationStatus_t = .notSpecified
#if DEBUG
    var apnKey: String = "com.sightcall.agent.s"
#else
    var apnKey: String = "com.sightcall.agent.p"
#endif

var apnToken: String?

    var isCallControllerActive: Bool = false
    
    var timeout: TimeInterval = 30
    var timer: AutoTimer?
    var state: State = .idle
    {
        didSet {
            if state == .calling {
                timer = AutoTimer(timeout: timeout, every: 0.1) {
                    self.tick($0)
                }.start()
                
            } else {
                timer?.stop()
                timer = nil
            }
        }
    }
    
    func tick (_ t: AutoTimer) {
        if t.isFinished {
            cancel()
        }
    }
    
    public init (presentingController: UIViewController?) {
        self.presentingController = presentingController
        super.init()
        ls_sdk.delegate = self
    }

    public func start(with url: URL) {
        print (#function, #line, url.description)
        ls_sdk.start(with: url.absoluteString)
    }

    public func start(with url_str: String) {
        print (#function, #line, url_str.description)
        ls_sdk.start(with: url_str)
    }

    // Cancel is called by the client
    public func cancel() {
        print (#function)
        close()
    }

    public func close() {
        ls_sdk.abort()
        state = .ready
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
        print (#function, #line, "\(status)")
        
        switch status {
        case .idle:
            state = .idle
        case .agentConnected:
            break
        case .agentRegistering:
            break
        case .agentUnregistering:
            break
        case .connecting:
            state = .calling
            break
        case .active:
            break
        case .calling:
            break
        case .callActive:
            state = .connected
            presentCallController()
        case .disconnecting:
            dismissCallViewController()
//            state = .ready
        case .networkLoss:
            break
        @unknown default:
            break
        }
    }
    
    public func connectionError(_ error: lsConnectionError_t) {
        print (#function, #line, error.description)
    }
    
    public func callReport(_ callEnd: LSCallReport) {
        print (#function, #line, callEnd.description)
    }
}

// MARK: Mobile Agent Methods
extension SightCallSDK {
    public func registerAsAgent(_ url_s: String) {
        agentRegistration = url_s
        ls_sdk.agentHandler?.register(withCode: url_s, andReference: apnKey) { (code, error) in
            self.agentCode = code
            print (#function, code, error ?? "")
        }
    }
}

// MARK: UIViewController interaction

extension SightCallSDK {
    
    open func present (_ viewController: UIViewController?, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        DispatchQueue.main.async {
            if let navc = self.presentingController?.navigationController {
                navc.pushViewController(viewController, animated: animated)
                completion?()
            } else {
                self.presentingController?
                    .present(viewController, animated: animated,
                             completion: completion)
            }
        }
    }
    
    open func dismissPresentedViewController(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let navc = self.presentingController?.navigationController {
                navc.popViewController(animated: true)
                completion?()
            } else {
            self.presentingController?
                .dismiss(animated: false, completion: completion)
            }
        }
    }
    
    open func presentCallController (animated: Bool = false) {
        guard !isCallControllerActive, let viewController = ls_sdk.callViewController
        else { return }
        
        DispatchQueue.main.async {
            self.presentingController?.present(viewController, animated: animated) {
                self.isCallControllerActive = true
            }
        }
    }
    
    open func dismissCallViewController() {
        guard isCallControllerActive else { return }
        DispatchQueue.main.async {
            self.presentingController?.dismiss(animated: true) {
                self.isCallControllerActive = false
            }
        }
    }

}

// ACD Related Delegate Methods

extension SightCallSDK {
    
    public func acdStatusUpdate(_ update: LSACDQueue) {
        print (#function, update.status.description)
    }
    
    public func acdAcceptedEvent(_ agentUID: String?) {
        print (#function, agentUID ?? "<ACD ID>")
    }
}
