//
//  CustomTextField.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 08.03.2023.
//

import UIKit

final class CustomTextField: UITextField {

    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupButtonTint()
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
        backgroundColor = .mainAccentColor
        textColor = .mainTextColor
        clearButtonMode = .always
        tintColor = .disabledColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: UIColor.mainTextColor.withAlphaComponent(0.5)])
    }

    private func setupButtonTint() {
        subviews.forEach { subview in
            if let button = subview as? UIButton {
                let image = button.imageView?.image?.withTintColor(.mainTextColor)
                button.setImage(image, for: .normal)
                button.setImage(image, for: .highlighted)
            }
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
}
