//
//  AppDelegate.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainTabBarViewController()
        self.window?.makeKeyAndVisible()
        self.window?.overrideUserInterfaceStyle = .light
        return true
    }
}

