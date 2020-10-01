//
//  AppDelegate.swift
//  KaMPKit-SwiftUI
//
//  Created by David Chavez on 01.10.20.
//  Copyright © 2020 Double Symmetry UG. All rights reserved.
//

import UIKit
import shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // lazy initialize since AppDelegate is instantiated before we run init on KoinIOS
    lazy var log = KoinIOS().get(objCClass: Kermit.self, parameter: "AppDelegate") as! Kermit
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Koin depedency injection
        let userDefaults = UserDefaults(suiteName: "KAMPKIT_SETTINGS")!
        KoinIOS().initialize(userDefaults: userDefaults)
        
        // Override point for customization after application launch.
        log.v(withMessage: {"App Started"})
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

