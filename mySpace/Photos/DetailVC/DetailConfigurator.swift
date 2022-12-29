//
//  DetailConfigurator.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import Foundation

protocol DetailConfiguratorInputProtocol {
    func configure(with viewController: DetailViewController, and detail: Result)
}

class DetailConfigurator: DetailConfiguratorInputProtocol {
    func configure(with viewController: DetailViewController, and detail: Result) {
        let presenter = DetailPresenter(view: viewController)
        let intreactor = DetailInteractor(presenter: presenter, detail: detail)
        
        viewController.presenter = presenter
        presenter.interactor = intreactor
    }
}
