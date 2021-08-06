//
//  ViewController.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 2/22/21.
//

import UIKit
import LSUniversalSDK

class ViewController: UIViewController {

    @IBOutlet var urlField: UITextField!
    @IBOutlet var pinField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paste()
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

