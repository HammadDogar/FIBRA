//
//  SetGradient.swift
//  FIBRA
//
//  Created by Irfan Malik on 25/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

@IBDesignable

class Gradientbackground: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds//CGRect(x: 0, y: 0, width: 375, height: 812)
        gradient.colors = [
          UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1).cgColor,
          UIColor(red: 0.1, green: 0.48, blue: 0.59, alpha: 1).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: -0.39, y: -0.38)
        layer.addSublayer(gradient)
    }

}
