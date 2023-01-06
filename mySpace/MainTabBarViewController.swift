//
//  MainTabBarViewController.swift
//  mySpace
//
//  Created by Shom on 26.12.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        setupApperance()
        
        viewControllers = [
            generatedNavControl(rootViewController: PhotoViewController(), title: "Фотографии", image: UIImage(systemName: "photo.on.rectangle")!, selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill")!),
            generatedNavControl(rootViewController: NotesViewController(), title: "Заметки", image: UIImage(systemName: "list.bullet.clipboard")!, selectedImage: UIImage(systemName: "list.bullet.clipboard.fill")!),
            generatedNavControl(rootViewController: MapViewController(), title: "Карты", image: UIImage(systemName: "map.circle")!, selectedImage: UIImage(systemName: "map.circle.fill")!)
        ]
        
    }
    
    private func generatedNavControl(rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        let navgationVC = UINavigationController(rootViewController: rootViewController)
        navgationVC.tabBarItem.title = title
        navgationVC.tabBarItem.image = image
        navgationVC.tabBarItem.selectedImage = selectedImage
        return navgationVC
    }
    
    private func setupApperance() {
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = constPurpleColor
        UITabBar.appearance().tintColor = constPurpleColor
    }
    
}
