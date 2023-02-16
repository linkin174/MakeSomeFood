//
//  UIView + DropShadow.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 16.02.2023.
//

import UIKit

extension UIView {
    func dropShadow(color: UIColor = .black, offset: CGSize = .zero, radius: CGFloat = 5, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
