//
//  UIFont + CustomFont.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 04.03.2023.
//

import UIKit

extension UIFont {
    class func handlee(ofSize: CGFloat = 16) -> UIFont {
        UIFont(name: "Handlee", size: ofSize) ?? .systemFont(ofSize: 16)
    }
}

