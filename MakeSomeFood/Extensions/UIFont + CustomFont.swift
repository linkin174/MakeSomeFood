//
//  UIFont + CustomFont.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 04.03.2023.
//

import UIKit

extension UIFont {
    class func handlee(of size: CGFloat = 16) -> UIFont {
        UIFont(name: "Handlee", size: size) ?? .systemFont(ofSize: 16)
    }
}

