//
//  GradientBackGroundOrange.swift
//  FIBRA
//
//  Created by Irfan Malik on 23/12/2020.
//

import Foundation
import UIKit

@IBDesignable




class GradientBackGroundOrange: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds//CGRect(x: 0, y: 0, width: 375, height: 812)
        gradient.colors = [
            UIColor(red: 0.94, green: 0.77, blue: 0.47, alpha: 1).cgColor,
            UIColor(red: 0.94, green: 0.66, blue: 0.16, alpha: 1).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: -0.39, y: -0.38)
        layer.addSublayer(gradient)
    }

}
