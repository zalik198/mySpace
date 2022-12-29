//
//  NetworkManager.swift
//  mySpace
//
//  Created by Shom on 27.12.2022.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    public var results: [Result] = []
    
    func fetchPhotos() {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=car&client_id=Qna3-TRud7w_UcZ820C52OMaAzSgt2HHrjrywlUl7is"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let jsonResults = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResults.results
                    //print(self?.results)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
