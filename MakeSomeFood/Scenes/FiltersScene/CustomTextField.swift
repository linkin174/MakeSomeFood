//
//  CustomTextField.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 08.03.2023.
//

import UIKit

final class CustomTextField: UITextField {

    var insets: UIEdgeInsets?

    override init(frame: CGRect) {
        self.insets = nil
        super.init(frame: frame)
        setupUI()
    }

    convenience init(insets: UIEdgeInsets) {
        self.init(frame: .zero)
        self.insets = insets
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtonTint()
    }

    private func setupUI() {
        borderStyle = .roundedRect
        layer.borderWidth = 1.5
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.borderColor = UIColor.mainTextColor.cgColor
        layer.masksToBounds = true
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: UIColor.mainTextColor.withAlphaComponent(0.5)])
        font = .systemFont(ofSize: 18)
        backgroundColor = .clear
        textColor = .mainTextColor
        clearButtonMode = .always
    }

    private func setupButtonTint() {
        subviews.forEach { subview in
            if let button = subview as? UIButton {
                let tintedImage = button.imageView?.image?.withTintColor(.mainTextColor)
                button.imageView?.image = tintedImage
            }
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let insets {
            return bounds.inset(by: insets)
        } else {
            return bounds
        }
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if let insets {
            return bounds.inset(by: insets)
        } else {
            return bounds
        }
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let insets {
            return bounds.inset(by: insets)
        } else {
            return bounds
        }
    }
}
