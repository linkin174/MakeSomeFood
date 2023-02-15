//
//  UIView + Preview.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//
import SwiftUI

extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {

        let viewController: UIViewController

        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }

    func makePreview() -> some View {
        Preview(viewController: self).ignoresSafeArea()
    }
}
