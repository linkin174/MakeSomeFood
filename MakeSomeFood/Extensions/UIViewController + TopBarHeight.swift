//
//  UIViewController + TopBarHeight.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 16.02.2023.
//

import UIKit

extension UIViewController {
    var statusBarHeight: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return (scene?.statusBarManager?.statusBarFrame.height ?? 0) + (navigationController?.navigationBar.frame.height ?? 0)
//        guard
//            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//            let statusBarHeight = scene.statusBarManager?.statusBarFrame.height,
//            let navigationBarHeight = self.navigationController?.navigationBar.frame.height,
//        else {
//            return 0
//        }
//        return statusBarHeight + navigationBarHeight
    }
}
