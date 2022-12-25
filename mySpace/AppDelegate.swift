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
        
        let tabBarController = UITabBarController()
        self.window?.rootViewController = tabBarController
        
        let notesViewController = NotesViewController()
        let notesNavigationController = UINavigationController(rootViewController: notesViewController)
        notesNavigationController.tabBarItem = UITabBarItem(title: "Заметки", image: UIImage(systemName: "list.bullet.clipboard"), selectedImage: UIImage(systemName: "list.bullet.clipboard.fill"))
        notesViewController.view.backgroundColor = .white
        
        
        tabBarController.viewControllers = [notesNavigationController]
        tabBarController.tabBar.isHidden = false
        tabBarController.tabBar.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = constPurpleColor
        UITabBar.appearance().tintColor = constPurpleColor
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        self.window?.overrideUserInterfaceStyle = .light

        
        return true
    }
    
    
    
    
}

