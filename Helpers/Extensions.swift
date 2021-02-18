//
//  Extensions.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import Kingfisher

extension UIViewController {
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertView(title: String, message: String,
                                     successTitle: String = "OK",
                                     cancelTitle: String = "",
                                     successCallback : (()->())! = nil,
                                     cancelCallback : (()->())! = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if successTitle.count > 0 {
            alert.addAction(UIAlertAction(title: successTitle, style: UIAlertAction.Style.default, handler: {
                action in
                
                if successCallback != nil {
                    successCallback()
                }
            }))
        }
        
        if cancelTitle.count > 0 {
            alert.addAction(UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.default, handler: {
                action in
                if cancelCallback != nil {
                    cancelCallback()
                }
            }))
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidResponse(response: Any?, error: Error?) -> Bool{
        guard let response = response else {
//            showAlertView(title: "Error", message: error?.localizedDescription ?? "")
            return false
        }
        if let responseDict = response as? [String: Any] {
            if let status = responseDict["status"] as? Int {
                if status == 404 || status == 0 {
                    if let message = responseDict["message"] as? String {
                        if message.lowercased() == "success" {
                            return true
                        }else {
                            return false
//                            showAlertView(title: "Error", message: message)
                        }
                    }
                    return false
                }
                return true
            }
        }
        return false
    }
}

extension UIView {
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius1: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.gray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 0.5),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 2.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UITextField {
    func isValidInput() -> Bool {
        if text == "" || text == nil {
            return false
        }
        let text1 = text?.replacingOccurrences(of: " ", with: "")
        if text1 == "" || text1 == nil {
            return false
        }
        return true
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
            get {
                return self.placeHolderColor
            }
            set {
                self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
            }
        }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isStrongPassword: Bool {
        let passRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"

        let passwordRegex = "^((?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])|(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[^a-zA-Z0-9])|(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[^a-zA-Z0-9])|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^a-zA-Z0-9])).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegex)
        return passwordTest.evaluate(with: self)
    }
}

extension UIImageView {
    
    func roundCorner() {
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
    
    func set(url: URL, placeholder: String = "placeholder") {
        self.kf.setImage(with: url,placeholder: UIImage(named: placeholder))
    }
    
    func set(urlString: String, placeholder: String = "placeholder") {
        if let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20")) {
            set(url: url, placeholder: placeholder)
        }else {
            self.image = UIImage(named: placeholder)
        }
    }
    
    func getImage(urlString: String, completionHandler: @escaping (_ imageSize: CGSize?) -> Void) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil) { (result) in
                switch result {
                case .success(let value):
                    let imageSize = value.image.size
                    completionHandler(imageSize)
                    break
                case .failure(_):
                    completionHandler(nil)
                    break
                }
            }
        }
    }
    
    func set(url: URL, completion: @escaping () -> Void) {
        self.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil) { (result) in
            switch result {
            case .success(_):
                completion()
                break
            case .failure(_):
                completion()
                break
            }
        }
    }
}

//extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 80
//        return sizeThatFits
//    }
//}

extension UINavigationController {
    func setUpAttributes(){
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barStyle = UIBarStyle.default
        self.navigationBar.barTintColor = UIColor(named: "Base")
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        self.navigationBar.isTranslucent = false
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIButton {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: -0.39, y: -0.38)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 8

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleLabel?.textColor = UIColor.white
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
