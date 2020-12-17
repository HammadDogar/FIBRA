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
            showAlertView(title: "Error", message: error?.localizedDescription ?? "")
            return false
        }
        if let responseDict = response as? [String: Any] {
            if let status = responseDict["status"] as? Int {
                if status == 404 || status == 0 {
                    if let message = responseDict["message"] as? String {
                        if message.lowercased() == "success" {
                            return true
                        }else {
                            showAlertView(title: "Error", message: message)
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
        let passwordRegex = "^((?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])|(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[^a-zA-Z0-9])|(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[^a-zA-Z0-9])|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^a-zA-Z0-9])).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
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

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 80
        return sizeThatFits
    }
}

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

