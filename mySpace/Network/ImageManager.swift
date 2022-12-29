//
//  ImageManager.swift
//  mySpace
//
//  Created by Shom on 27.12.2022.
//

import UIKit

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchData(from url: URL?) -> Data? {
            guard let url = url else { return nil}
            guard let imageData = try? Data(contentsOf: url) else { return nil}
            return imageData
    }
}
