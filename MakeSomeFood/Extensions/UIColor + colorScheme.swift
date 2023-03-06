//
//  UIColor + colorScheme.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 16.02.2023.
//

import UIKit

extension UIColor {

    class var mainAccentColor: UIColor {
        UIColor(named: "mainAccentColor") ?? .white
    }

    class var selectedMenuItemColor: UIColor {
        UIColor(named: "selectedMenuItem") ?? .white
    }

    class var mainTextColor: UIColor {
        UIColor(named: "mainTextColor") ?? .black
    }

    class var disabledColor: UIColor {
        UIColor(named: "disabledColor") ?? .gray
    }

    class var mainBackgroundColor: UIColor {
        UIColor(named: "mainBackgroundColor") ?? .white
    }

    class var mainTintColor: UIColor {
        UIColor(named: "mainTintColor") ?? .white
    }
}
