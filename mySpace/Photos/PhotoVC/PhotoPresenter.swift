//
//  PhotoPresenter.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import UIKit

class PhotoPresenter: PhotoViewOutputProtocol {
    
    unowned let view: PhotoViewInputProtocol
    var interactor: PhotoInteractorInputProtocol!
    var router: PhotoRouterInputProtocol!
    
    required init(view: PhotoViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchPhoto()
    }
}


// MARK: - PhotoInteractorOutputProtocol
extension PhotoPresenter: PhotoInteractorOutputProtocol {
    
    func photoDidReceive(_ photo: ApiResponse) {
        view.display(photo.results)
    }
}
