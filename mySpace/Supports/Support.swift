//
//  Support.swift
//  mySpace
//
//  Created by Shom on 23.12.2022.
//

import UIKit

public var currentDate = Date()
let constPurpleColor = UIColor(red: 0.63, green: 0.09, blue: 0.80, alpha: 1.00)

public extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
