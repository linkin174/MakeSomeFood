//
//  UIView + MakeSeparator.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 25.02.2023.
//

import UIKit

extension UIView {
    static func makeSeparator(color: UIColor = .black) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}
