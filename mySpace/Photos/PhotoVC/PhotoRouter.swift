//
//  PhotoRouter.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import UIKit

protocol PhotoRouterInputProtocol {

    init(viewController: PhotoViewController)
    func openDetailViewController(with vc: UIViewController)
}

class PhotoRouter: PhotoRouterInputProtocol {
    unowned let viewController: PhotoViewController
    
    required init(viewController: PhotoViewController) {
        self.viewController = viewController
    }
    
    func openDetailViewController(with vc: UIViewController) {
        vc.modalPresentationStyle = .automatic
        viewController.present(vc, animated: true)
    }
}
