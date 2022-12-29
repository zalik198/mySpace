//
//  DetailPresenter.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import UIKit

class DetailPresenter: DetailViewOutputProtocol {
    unowned let view: DetailViewInputProtocol
    var interactor: DetailInteractorInputProtocol!
    
    required init(view: DetailViewInputProtocol) {
        self.view = view
    }
    
    func showDetails() {
        interactor.provideDetail()
    }
}

// MARK: - DetailInteractorOutputProtocol
extension DetailPresenter: DetailInteractorOutputProtocol {
    func receiveDetail(with data: DetailsData) {
            
            let author = "Location: \(data.authorName)"
            let likes = "Likes: \(data.likes)"
            
            self.view.displayLocation(with: data.locationName)
            self.view.displayAuthor(with: author)
            self.view.displayLikes(with: likes)
            self.view.displayImage(with: data.imageData!)
    }
}
