//
//  TabBarShape.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import UIKit

@IBDesignable
class CurvedTabBar: UITabBar {

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 0.4
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowPath = shapeLayer.path
        

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    func createPath() -> CGPath {
        
        let height: CGFloat = 44.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
    func createPathCircle() -> CGPath {
            let radius: CGFloat = 35.0
            let path = UIBezierPath()
            let centerWidth = self.frame.width / 2

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
            path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
            path.addLine(to: CGPoint(x: self.frame.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            path.addLine(to: CGPoint(x: 0, y: self.frame.height))
            path.close()
            return path.cgPath
        }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
