//
//  ViewController.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 2/22/21.
//

import UIKit
import Combine
import LSUniversalSDK

class ViewController: UIViewController {

    @IBOutlet var urlField: UITextField!
    @IBOutlet var pinField: UITextField!
    @IBOutlet var apnToken: UITextField!
    var cancellables = Set<AnyCancellable>()

    func register() {
        NotificationCenter.default.publisher(for: SightCallAPN)
            .sink(receiveValue: { note in
                if let nob = note.object as? [AnyHashable:Any] {
                print(nob)
                self.autoconnect(nob)
                }
            })
            .store(in: &cancellables)
    }

    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func autoconnect(_ payload: [AnyHashable:Any]) {
//        guard let payload = (payload.object) as? [AnyHashable:Any]
//        else { return }
        let url: String?
        if let apn = payload["aps"] as? [AnyHashable:Any] {
            url = apn["sightcallUrl"] as? String
        }
        else {
            url = payload["sightcallUrl"] as? String
        }
        if let url = url{
            self.urlField.text = url
            self.sightCall?.start(with: url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paste()
        apnToken?.text = appDelegate?.deviceToken
    }

    override func viewDidAppear(_ animated: Bool) {
        apnToken?.text = appDelegate?.deviceToken
    }
    
    func url(_ key: String) -> URL? {
        if let str = UserDefaults.standard.string(forKey: key),
           let u = URL(string: str)
        {
            return u
        }
        return nil
    }
    
    var urlPin: String? {
        guard let url = UIPasteboard.general.url ?? url("agent_url")
        else { return nil }
        return url.queryValueForKey("pin")
    }
    
    var pin: String? {
        pinField.text ?? urlPin
    }
    
    @IBAction
    func paste() {
        if let url = UIPasteboard.general.url {
            urlField.text = url.absoluteString
        }
        pinField.text = urlPin
    }
    
    @IBAction
    func connect() {
        if let url = UIPasteboard.general.url ?? url("agent_url") {
            print (#function, url.absoluteString)
            sightCall?.start(with: url)
        }
    }
    
    @IBAction
    func call() {
        if let url = url("acd_url") {
            print (#function, url.absoluteString)
            sightCall?.start(with: url)
        }
    }

    @IBAction
    func cancel() {
        sightCall?.cancel()
    }
}

