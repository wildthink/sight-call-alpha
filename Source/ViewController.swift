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
//    @IBOutlet var apnToken: UITextField!
    var cancellables = Set<AnyCancellable>()
    var connectionURL: URL? {
        didSet {
            urlField.text = connectionURL?.absoluteString ?? ""
//            pinField.text = urlPin
        }
    }
    
    func register() {
        NotificationCenter.default.publisher(for: SightCallAPN)
            .sink(receiveValue: { note in
//                if let nob = note.object as? [AnyHashable:Any] {
//                print(nob)
                if let packet = APNPayload(note.object) {
                    self.autoconnect(packet)
                }
            })
            .store(in: &cancellables)
    }

    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func autoconnect(_ payload: APNPayload) {
        
        guard let url_s: String =
                payload["sightCallURL"]
                ?? payload["sightCallUrl"]
                ?? payload["url"]
        else {
            print(#function, "NO URL in Payload \(payload)")
            return
        }
        if let url = URL(string: url_s) {
            connectionURL = url
            self.sightCall?.start(with: url)
        }
    }

    
//    func autoconnect(_ payload: [AnyHashable:Any]) {
//        let url_s: String?
//        if let apn = payload["aps"] as? [AnyHashable:Any] {
//            url_s = apn["sightcallUrl"] as? String
//        }
//        else {
//            url_s = payload["sightcallUrl"] as? String
//        }
//        if let url_s = url_s, let url = URL(string: url_s) {
//            connectionURL = url
////            self.urlField.text = url
//            self.sightCall?.start(with: url)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        paste()
//        apnToken?.text = appDelegate?.deviceToken
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        apnToken?.text = appDelegate?.deviceToken
    }
    
//    func url(_ key: String) -> URL? {
//        if let str = UserDefaults.standard.string(forKey: key),
//           let u = URL(string: str)
//        {
//            return u
//        }
//        return UIPasteboard.general.url
//    }
    
//    var urlPin: String? {
//        guard let url = UIPasteboard.general.url ?? url("agent_url")
//        else { return nil }
//        return url.queryValueForKey("pin")
//    }
//    
//    var pin: String? {
//        pinField.text ?? urlPin
//    }
//    
//    struct ShareSheetView: View {
//        var body: some View {
//            Button(action: actionSheet) {
//                Image(systemName: "square.and.arrow.up")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 36, height: 36)
//            }
//        }
        
    @IBAction
    func share() {
//        guard let data = URL(string: "https://www.example.com") else { return }
        let json = """
        SightCall Connection Info
        {
            "apn": \(appDelegate?.deviceToken ?? ""),
            "sightCallURL": \(self.connectionURL?.absoluteString ?? "https://www.example.com")
        }
        """
        let av = UIActivityViewController(activityItems: [json], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }

    @IBAction
    func paste() {
        connectionURL = UIPasteboard.general.url
//            connectionURL = url.absoluteString
//            urlField.text = url.absoluteString
//        }
//        pinField.text = urlPin
    }
    
    @IBAction
    func connect() {
//        if let url = UIPasteboard.general.url ?? url("agent_url") {
//            print (#function, url.absoluteString)
//            sightCall?.start(with: url)
//        }
    }
    
    @IBAction
    func call() {
//        if let url = url("acd_url") {
//            print (#function, url.absoluteString)
//            sightCall?.start(with: url)
//        }
    }

    @IBAction
    func cancel() {
        sightCall?.cancel()
    }
}

struct APNPayload {
    var rawValue: [AnyHashable:Any]
    var packetKey: String = "aps"
    
    init?(_ any: Any) {
        guard let packet = any as? [AnyHashable:Any]
        else { return nil }
        rawValue = packet
    }
    
    subscript<Value>(_ key: String, as vtype: Value.Type = Value.self) -> Value? {
        (rawValue[key] as? Value)
        ?? (rawValue[packetKey] as? [AnyHashable:Any])?[key] as? Value
    }
}

extension APNPayload: CustomStringConvertible {
    var description: String {
        String(describing: rawValue)
    }
}
