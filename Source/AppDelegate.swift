//
//  AppDelegate.swift
//  SightCallAlpha
//
//  Created by Jason Jobe on 2/22/21.
//

import UIKit
import LSUniversalSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var deviceToken: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.register(settings: "Settings")
        application.registerForRemoteNotifications() // LSUniversalSDK calls this as needed
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken.hexEncodedString()
        
        for scene in UIApplication.shared.connectedScenes {
            guard let d = scene.delegate as? SightCallManager else { continue }
            d.sightCall.ls_sdk.agentHandler?.notificationToken = self.deviceToken
        }
        print(#function, self.deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function, error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(#function, userInfo)
    }
}
