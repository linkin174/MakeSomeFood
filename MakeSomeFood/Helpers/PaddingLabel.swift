//
//  PaddingLabel.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 18.02.2023.
//

import UIKit

final class PaddingLabel: UILabel {
    // MARK - Private Properties

    private var edgeInsets: UIEdgeInsets

    // MARK: - Initializers

    init(withEdgeInsets: UIEdgeInsets) {
        self.edgeInsets = withEdgeInsets
        super.init(frame: .zero)
    }

    convenience init(withEdgeInsets: UIEdgeInsets, text: String?) {
        self.init(withEdgeInsets: withEdgeInsets)
        self.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides
    
    override var intrinsicContentSize: CGSize {
        numberOfLines = 0
        var size = super.intrinsicContentSize
        size.height = size.height + edgeInsets.top + edgeInsets.bottom
        size.width = size.width + edgeInsets.left + edgeInsets.right
        return size
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let boundsRect = bounds.inset(by: edgeInsets)
        let textFrame = super.textRect(forBounds: boundsRect, limitedToNumberOfLines: 0)
        return textFrame
    }
}
