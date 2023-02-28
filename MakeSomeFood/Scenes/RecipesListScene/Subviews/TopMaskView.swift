//
//  TopMaskView.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 16.02.2023.
//

import UIKit

final class TopMaskView: UIView {

    private var fillColor: UIColor = .black

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    convenience init(fillColor: UIColor) {
        self.init(frame: .zero)
        self.fillColor = fillColor
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        let height = rect.height
        let shadowAddition: CGFloat = rect.height / 2

        let startPoint = rect.origin
        let secondPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let thirdPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.minX + height, y: rect.maxY - height)
        // Draw shape of the view
        let drawPath = UIBezierPath()
        drawPath.move(to: startPoint)
        drawPath.addLine(to: secondPoint)
        drawPath.addLine(to: thirdPoint)
        drawPath.addArc(withCenter: CGPoint(x: rect.maxX - height, y: rect.maxY),
                        radius: height,
                        startAngle: 0,
                        endAngle: 3 * .pi / 2,
                        clockwise: false)
        drawPath.addLine(to: endPoint)
        drawPath.addArc(withCenter: CGPoint(x: rect.minX + height, y: rect.maxY),
                        radius: height,
                        startAngle: 3 * .pi / 2,
                        endAngle: .pi, clockwise: false)
        drawPath.addLine(to: startPoint)

        fillColor.set()
        drawPath.fill()

        // Draw shadow shaped as view
        let shadowPath = UIBezierPath()
        shadowPath.move(to: startPoint)
        shadowPath.addLine(to: secondPoint)
        shadowPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY + shadowAddition))
        shadowPath.addArc(withCenter: CGPoint(x: rect.maxX - height, y: rect.maxY + shadowAddition),
                          radius: height,
                          startAngle: 0,
                          endAngle: 3 * .pi / 2,
                          clockwise: false)
        shadowPath.addLine(to: CGPoint(x: rect.minX + height, y: rect.maxY - height + shadowAddition))
        shadowPath.addArc(withCenter: CGPoint(x: rect.minX + height, y: rect.maxY + shadowAddition),
                          radius: height,
                          startAngle: 3 * .pi / 2,
                          endAngle: .pi,
                          clockwise: false)
        shadowPath.addLine(to: startPoint)
        // Make shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = shadowAddition / 2
        layer.shadowOffset = CGSize(width: 0, height: -shadowAddition / 2)
        layer.shadowOpacity = 0.3
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowPath = shadowPath.cgPath
    }
}
