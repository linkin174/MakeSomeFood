//
//  DropDown static factory.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 16.02.2023.
//

import DropDown

extension DropDown {
    static func createMenu(dataSource: [String], anchorView: UIView, selectionAction: @escaping (Int, String) -> Void) -> DropDown {
        let menu = DropDown()
        menu.dataSource = dataSource
        menu.selectionAction = selectionAction
        menu.anchorView = anchorView
        menu.cornerRadius = 12
        menu.textColor = .white
        menu.selectedTextColor = .white
        menu.backgroundColor = .mainAccentColor
        menu.selectionBackgroundColor = .selectedMenuItemColor
        return menu
    }
}
