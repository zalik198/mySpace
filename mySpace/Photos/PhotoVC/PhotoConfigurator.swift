//
//  PhotoConfigurator.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import Foundation

protocol PhotoConfiguratorInputProtocol {
    func configure(with viewController: PhotoViewController)
}

class PhotoConfigurator: PhotoConfiguratorInputProtocol {
    
    func configure(with viewController: PhotoViewController) {
        let presenter = PhotoPresenter(view: viewController)
        let interactor = PhotoInteractor(presenter: presenter)
        let router = PhotoRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
    }
}


