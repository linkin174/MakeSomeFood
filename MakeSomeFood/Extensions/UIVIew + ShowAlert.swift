//
//  UIVIew + ShowAlert.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        alert.addAction(closeAction)
        if let actions {
            actions.forEach { alert.addAction($0) }
        }
        present(alert, animated: true)
    }
}
