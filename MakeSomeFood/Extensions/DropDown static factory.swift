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
        menu.textColor = .black
        menu.selectedTextColor = .black
        menu.backgroundColor = #colorLiteral(red: 0.4139624238, green: 0.7990826964, blue: 0.003590217093, alpha: 1)
        menu.selectionBackgroundColor = #colorLiteral(red: 0.3732654589, green: 0.7286896552, blue: 0, alpha: 1)
        return menu
    }
}
