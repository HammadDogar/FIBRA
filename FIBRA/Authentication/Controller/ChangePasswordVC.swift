//
//  ChangePasswordVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!

    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var reTypePasswordLabel: UILabel!
    @IBOutlet weak var btnNewPassword: UIButton!
    @IBOutlet weak var btnReTypePassword: UIButton!
        
    @IBOutlet weak var btnBackGroundColorView: UIView!
    @IBOutlet weak var btnSaveChanges: UIButton!


    @IBOutlet weak var oldErrorView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var reTypePasswordView: UIView!
    @IBOutlet weak var BothPasswordView: UIView!
    @IBOutlet weak var validPasswordView: UIView!
    @IBOutlet weak var formatPasswordView: UIView!
    @IBOutlet weak var validPasswordViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var oldErrorLineView: UIView!
    @IBOutlet weak var newPasswordLineView: UIView!
    @IBOutlet weak var reTypePasswordLineView: UIView!
    @IBOutlet weak var apiErrorView: UIView!
    @IBOutlet weak var apiErrorLabel: UILabel!


    var viewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiErrorView.isHidden = true
        self.oldPasswordLabel.isHidden = true
        self.newPasswordLabel.isHidden = true
        self.reTypePasswordLabel.isHidden = true
        self.btnBackGroundColorView.isHidden = true
        self.btnSaveChanges.isEnabled = false
        
        self.oldErrorView.isHidden = true
        self.newPasswordView.isHidden = true
        self.reTypePasswordView.isHidden = true
        self.validPasswordView.isHidden = true
        self.formatPasswordView.isHidden = true
        self.BothPasswordView.isHidden = true
        self.validPasswordViewHeightConstraint.constant = 0

        
        viewModel = AuthenticationViewModel(delegate: self, viewController: self)

        self.oldPassTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                 for: .editingChanged)
        self.newPassTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                 for: .editingChanged)
        self.confirmPassTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                  for: .editingChanged)

        self.btnNewPassword.setTitle(" Show", for: .normal)
        self.btnNewPassword.setTitle(" Hide", for: .selected)
        self.btnReTypePassword.setTitle(" Show", for: .normal)
        self.btnReTypePassword.setTitle(" Hide", for: .selected)
        
        self.btnNewPassword.setImage(UIImage(named: "showPassword1"), for: .normal)
        self.btnNewPassword.setImage(UIImage(named: "hidePassword1"), for: .selected)
        self.btnReTypePassword.setImage(UIImage(named: "showPassword1"), for: .normal)
        self.btnReTypePassword.setImage(UIImage(named: "hidePassword1"), for: .selected)

        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.oldPassTF{
            if textField.text != ""{
                self.oldPasswordLabel.isHidden = false
            }else{
                self.oldPasswordLabel.isHidden = true
            }
        }else if textField == self.newPassTF{
            if textField.text != ""{
                self.newPasswordLabel.isHidden = false
            }else{
                self.newPasswordLabel.isHidden = true

            }
        }else{
            if textField.text != ""{
                self.reTypePasswordLabel.isHidden = false
            }else{
                self.reTypePasswordLabel.isHidden = true

            }
        }
        if self.oldPassTF.text != "" && self.newPassTF.text != "" && self.confirmPassTF.text != "" {
            self.btnBackGroundColorView.isHidden = false
            self.btnSaveChanges.backgroundColor = UIColor.clear
            self.btnSaveChanges.isEnabled = true
        }else{
            self.btnBackGroundColorView.isHidden = true
            self.btnSaveChanges.backgroundColor = UIColor.lightGray
            self.btnSaveChanges.isEnabled = false
        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChangePassword(_ sender: UIButton) {
        if isValidInput() {
            let param: [String: Any] = [
                "oldPassword": oldPassTF.text ?? "",
                "password": newPassTF.text ?? "",
                "confirmPassword": confirmPassTF.text ?? ""
            ]
            if BReachability.isConnectedToNetwork(){
                SVProgressHUD.show()
                self.view.isUserInteractionEnabled = false
                viewModel.changePassword(with: param)
            }else{
                self.apiErrorLabel.text = "The internet connection appears to be offline."
                self.apiErrorView.isHidden = false
                
                
                
            }
        }
    }
    
    @IBAction func actionNewPassWordShow(_ sender: UIButton) {
        self.btnNewPassword.isSelected.toggle()
        self.newPassTF.isSecureTextEntry.toggle()
    }
    
    @IBAction func actionReTypePassWordShow(_ sender: UIButton) {
        self.confirmPassTF.isSecureTextEntry.toggle()
        self.btnReTypePassword.isSelected.toggle()
    }    
}

extension ChangePasswordVC: AuthenticationViewModelDelegate {
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        self.apiErrorView.isHidden = false
        if Constants.kSomethingWrong == error{
            self.apiErrorLabel.text = "Old Password is wrong."
        }else{
            self.apiErrorLabel.text = "\(error)"
        }
//        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        self.apiErrorView.isHidden = true
        self.view.isUserInteractionEnabled = true

        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            SVProgressHUD.dismiss()
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
            let navigationController = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
//        self.showAlertView(title: Constants.kSuccessMessage, message: "Password updated successfully.", successTitle: "OK", successCallback: {
//            let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
//            let navigationController = UINavigationController(rootViewController: vc)
//            UIApplication.shared.windows.first?.rootViewController = navigationController
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
//        })
    }
    
}

extension ChangePasswordVC {
    func isValidInput() -> Bool {
        var isError = true
        if !oldPassTF.isValidInput() {
            self.oldErrorView.isHidden = false
            self.oldErrorLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.oldPasswordLabel.textColor = UIColor.init(hexString: "#D0021B")

//            self.showAlertView(title: "Error", message: "Please enter old password")
            isError = false
        }else{
            self.oldErrorView.isHidden = true
            self.oldPasswordLabel.textColor = UIColor.init(named: "YellowColor")
            self.oldErrorLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")

        }
        if !(oldPassTF.text?.isStrongPassword ?? false) {
            self.oldErrorLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.oldPasswordLabel.textColor = UIColor.init(hexString: "#D0021B")

            isError = false
        }else{
            self.oldPasswordLabel.textColor = UIColor.init(named: "YellowColor")
            self.oldErrorLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")
        }
        if !newPassTF.isValidInput() {
            self.newPasswordView.isHidden = false
            self.newPasswordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.newPasswordLabel.textColor = UIColor.init(hexString: "#D0021B")


//            self.showAlertView(title: "Error", message: "Please enter new password")
            isError = false
        }else{
            self.newPasswordView.isHidden = true
            self.newPasswordLabel.textColor = UIColor.init(named: "YellowColor")
            self.newPasswordLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")

        }
        if !(newPassTF.text?.isStrongPassword ?? false) {
            self.newPasswordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.newPasswordLabel.textColor = UIColor.init(hexString: "#D0021B")

            self.formatPasswordView.isHidden = false
            self.validPasswordView.isHidden = false
            self.validPasswordViewHeightConstraint.constant = 30
//            self.showAlertView(title: "Error", message: "Password Must be at least of 8 characters and contains 3 or 4 of the following: Uppercase (A-Z), Lowercase (a-z), Number (0-9), and Special characters (!@#$%^&*)")
            isError = false
        }else{
            self.formatPasswordView.isHidden = true
            self.validPasswordView.isHidden = true
            self.validPasswordViewHeightConstraint.constant = 0
            self.newPasswordLabel.textColor = UIColor.init(named: "YellowColor")
            self.newPasswordLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")

        }
        if confirmPassTF.text != newPassTF.text {
            self.newPasswordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.reTypePasswordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.newPasswordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.reTypePasswordLabel.textColor = UIColor.init(hexString: "#D0021B")

            self.BothPasswordView.isHidden = false
//            self.showAlertView(title: "Error", message: "Passwords do no match.")
            isError = false
        }else{
            self.BothPasswordView.isHidden = true
            self.newPasswordLabel.textColor = UIColor.init(named: "YellowColor")
            self.newPasswordLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")
            self.reTypePasswordLabel.textColor = UIColor.init(named: "YellowColor")
            self.reTypePasswordLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")

        }
        return isError
    }
}


