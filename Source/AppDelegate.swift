//
//  AppDelegate.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 2/22/21.
//

import UIKit
import LSUniversalSDK

let SightCallAPN = Notification.Name(rawValue: "SightCallAPN")


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var deviceToken: String?
//    var sessions = Set<UISceneSession>()
    var lastAPNPayload: [AnyHashable:Any]?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.register(settings: "Settings")
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
//        sessions.insert(connectingSceneSession)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        sceneSessions.forEach { sessions.remove($0) }
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        self.deviceToken = deviceToken.hexEncodedString()
        
//        for scene in UIApplication.shared.connectedScenes {
//            guard let d = scene.delegate as? SightCallManager else { continue }
//            d.sightCall.ls_sdk.agentHandler?.notificationToken = self.deviceToken
//        }
        if let token = self.deviceToken {
            print(#function, token)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function, error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {        
        lastAPNPayload = userInfo
        
        NotificationCenter.default.post(name: SightCallAPN, object: userInfo)
        
//        for s in sessions {
//            if let del = s.scene?.delegate as? SceneDelegate {
//                del.didReceiveRemoteNotification(userInfo)
//            }
//        }
    }
}
