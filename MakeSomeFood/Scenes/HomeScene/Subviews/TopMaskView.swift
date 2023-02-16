//
//  TopMaskView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 16.02.2023.
//

import UIKit

final class TopMaskView: UIView {
    #warning("fix shadow path and make init for it")

    private var fillColor: UIColor = .red
    private var radius: CGFloat = 16

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    convenience init(color: UIColor, cornerRadius: CGFloat) {
        self.init(frame: .zero)
        fillColor = color
        radius = cornerRadius
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let startPoint = bounds.origin
        let secondPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
        let thirdPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
        let endPoint = CGPoint(x: bounds.minX + radius, y: bounds.maxY - radius)

        let drawPath = UIBezierPath()
        drawPath.move(to: startPoint)
        drawPath.addLine(to: secondPoint)
        drawPath.addLine(to: thirdPoint)
        drawPath.addArc(withCenter: CGPoint(x: bounds.maxX - radius, y: bounds.maxY), radius: radius, startAngle: 0, endAngle: 3 * .pi / 2, clockwise: false)
        drawPath.addLine(to: endPoint)
        drawPath.addArc(withCenter: CGPoint(x: bounds.minX + radius, y: bounds.maxY), radius: radius, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: false)
        drawPath.addLine(to: startPoint)
        fillColor.set()
        drawPath.fill()

        let shadowPath = UIBezierPath()
        shadowPath.move(to: startPoint)
        shadowPath.addLine(to: secondPoint)
        shadowPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY + 6))
        shadowPath.addArc(withCenter: CGPoint(x: bounds.maxX - radius, y: bounds.maxY + 6), radius: radius, startAngle: 0, endAngle: 3 * .pi / 2, clockwise: false)
        shadowPath.addLine(to: CGPoint(x: bounds.minX + radius, y: bounds.maxY - radius + 6))
        shadowPath.addArc(withCenter: CGPoint(x: bounds.minX + radius, y: bounds.maxY + 6), radius: radius, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: false)
        shadowPath.addLine(to: startPoint)
        // Make shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: -3.5)
        layer.shadowOpacity = 0.4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowPath = shadowPath.cgPath
    }
}
