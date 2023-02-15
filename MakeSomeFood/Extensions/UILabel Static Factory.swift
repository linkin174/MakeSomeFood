//
//  UILabel Static Factory.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import UIKit

extension UILabel {

    static func makeUILabel(text: String? = nil,
                            font: UIFont? = nil,
                            textColor: UIColor = .white,
                            onTapGesture: Selector? = nil,
                            target: Any? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        if let onTapGesture {
            let tapGesture = UITapGestureRecognizer(target: target, action: onTapGesture)
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true

        }
        return label
    }
}
