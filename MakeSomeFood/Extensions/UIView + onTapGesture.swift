//
//  UIView + onTapGesture.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import UIKit

extension UIView {
    func onTapGesture(target: Any?, action: Selector, tag: Int? = nil) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        if let tag {
            tapGesture.view?.tag = tag
        }
    }
}
