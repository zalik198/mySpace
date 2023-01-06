//
//  PhotoInteractor.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import Foundation

protocol PhotoInteractorInputProtocol: AnyObject {
    init(presenter: PhotoInteractorOutputProtocol)
    func fetchPhoto()
}

protocol PhotoInteractorOutputProtocol: AnyObject {
}

class PhotoInteractor: PhotoInteractorInputProtocol {
    unowned let presenter: PhotoInteractorOutputProtocol
    required init(presenter: PhotoInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchPhoto() {
        NetworkManager.shared.fetchPhotos(collection: "")
    }
}
