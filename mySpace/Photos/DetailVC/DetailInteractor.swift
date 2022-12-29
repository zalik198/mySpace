//
//  DetailInteractor.swift
//  mySpace
//
//  Created by Shom on 29.12.2022.
//

import UIKit

protocol DetailInteractorInputProtocol: AnyObject {
    init(presenter: DetailInteractorOutputProtocol, detail: Result)
    func provideDetail()
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func receiveDetail(with data: DetailsData)
}

class DetailInteractor: DetailInteractorInputProtocol {
    
    unowned let presenter: DetailInteractorOutputProtocol
    private let detail: Result
    
    required init(presenter: DetailInteractorOutputProtocol, detail: Result) {
        self.presenter = presenter
        self.detail = detail
    }
    
    func provideDetail() {
            guard let newImage = ImageManager.shared.fetchData(from: URL(string: self.detail.urls.regular)) else { return }
            let detailData = DetailsData(
                locationName: self.detail.user.location ?? "Местоположение не указано",
                authorName: self.detail.user.name,
                likes: self.detail.likes,
                imageData: newImage
            )
            self.presenter.receiveDetail(with: detailData)
    }
}


