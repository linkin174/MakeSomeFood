//
//  UILabel Static Factory.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import UIKit

extension UILabel {
    static func makeUILabel(text: String? = nil, font: UIFont? = nil,
                            textColor: UIColor = .black, alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = 0
        label.textAlignment = alignment
        return label
    }
}
