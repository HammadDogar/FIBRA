//
//  RegisterViewController.swift
//  FIBRA
//
//  Created by Irfan Malik on 25/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var reTypePasswordLabel: UILabel!

    @IBOutlet weak var btnBackGroundColorView: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var btnNewPassword: UIButton!
    @IBOutlet weak var btnReTypePassword: UIButton!
    
    @IBOutlet weak var mobileNoErrorView: UIView!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var rePasswordErrorView: UIView!
    @IBOutlet weak var emailValidErrorView: UIView!
    @IBOutlet weak var emailValidTopErrorView: UIView!
    @IBOutlet weak var passwordValidTopErrorView: UIView!

    @IBOutlet weak var passwordValidErrorView: UIView!

    @IBOutlet weak var bothPasswordErrorView: UIView!
    @IBOutlet weak var checkBoxErrorView: UIView!

    @IBOutlet weak var mobileNoLineView: UIView!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var rePasswordLineView: UIView!


    
    var viewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureErrorViews()
        
        self.emailAddressLabel.isHidden = true
        self.mobileNoLabel.isHidden = true
        self.passwordLabel.isHidden = true
        self.reTypePasswordLabel.isHidden = true

        self.btnBackGroundColorView.isHidden = true
        self.btnRegister.isEnabled = false
        
        viewModel = AuthenticationViewModel(delegate: self, viewController: self)
        
        self.btnNewPassword.setTitle(" Show", for: .normal)
        self.btnNewPassword.setTitle(" Hide", for: .selected)
        self.btnReTypePassword.setTitle(" Show", for: .normal)
        self.btnReTypePassword.setTitle(" Hide", for: .selected)
        
        self.btnNewPassword.setImage(UIImage(named: "showPassword"), for: .normal)
        self.btnNewPassword.setImage(UIImage(named: "hidePassword"), for: .selected)
        self.btnReTypePassword.setImage(UIImage(named: "showPassword"), for: .normal)
        self.btnReTypePassword.setImage(UIImage(named: "hidePassword"), for: .selected)

        
        mobileText.attributedPlaceholder =
            NSAttributedString(string: "Mobile No", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        emailText.attributedPlaceholder =
            NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        passwordText.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        confirmPasswordText.attributedPlaceholder =
            NSAttributedString(string: "Re-type password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        self.emailText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmPasswordText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        self.mobileText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),for: .editingChanged)
    }
    
    func configureErrorViews(){
        self.mobileNoErrorView.isHidden = true
        self.emailErrorView.isHidden = true
        self.passwordErrorView.isHidden = true
        self.rePasswordErrorView.isHidden = true
        self.emailValidErrorView.isHidden = true
        self.bothPasswordErrorView.isHidden = true
        self.checkBoxErrorView.isHidden = true
        self.passwordValidErrorView.isHidden = true
        self.emailValidTopErrorView.isHidden = true
        self.passwordValidTopErrorView.isHidden = true

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.emailText{
            if textField.text != ""{
                self.emailAddressLabel.isHidden = false
            }else{
                self.emailAddressLabel.isHidden = true
            }
        }else if textField == self.mobileText{
            if textField.text != ""{
                self.mobileNoLabel.isHidden = false
            }else{
                self.mobileNoLabel.isHidden = true

            }
        }else if textField == self.passwordText{
            if textField.text != ""{
                self.passwordLabel.isHidden = false
            }else{
                self.passwordLabel.isHidden = true

            }
        }
        else {
            if textField.text != ""{
                self.reTypePasswordLabel.isHidden = false
            }else{
                self.reTypePasswordLabel.isHidden = true

            }
        }
        if self.emailText.text != "" && self.mobileText.text != "" && self.passwordText.text != "" && self.confirmPasswordText.text != "" && checkBtn.isSelected{
            self.btnBackGroundColorView.isHidden = false
            self.btnRegister.backgroundColor = UIColor.clear
            self.btnRegister.isEnabled = true

        }else{
            self.btnBackGroundColorView.isHidden = true
            self.btnRegister.backgroundColor = UIColor.lightGray
            self.btnRegister.isEnabled = false

        }

    }
    
    
    //MARK:ACTIONS
    
    @IBAction func actionNewPassWordShow(_ sender: UIButton) {
        self.btnNewPassword.isSelected.toggle()
        self.passwordText.isSecureTextEntry.toggle()
    }
    @IBAction func actionReTypePassWordShow(_ sender: UIButton) {
        self.confirmPasswordText.isSecureTextEntry.toggle()
        self.btnReTypePassword.isSelected.toggle()

    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        } else{
            sender.isSelected = true
            self.checkBoxErrorView.isHidden = true
        }
        self.textFieldDidChange(self.emailText)
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
        signUp()
    }
    
}

extension RegisterViewController: AuthenticationViewModelDelegate {
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.showAlertView(title: Constants.kSuccessMessage, message: "User successfully created.", successTitle: "OK", successCallback: {
            self.navigationController?.popViewController(animated: true)
        })
//        SVProgressHUD.dismiss()
//        UserDefaults.standard.set(true, forKey: "loginKey")
//        UserDefaults.standard.synchronize()
//        let tabbarVC = TabbarVC.instantiate(fromAppStoryboard: .Tabbar)
//        tabbarVC.modalPresentationStyle = .fullScreen
//        tabbarVC.modalTransitionStyle = .crossDissolve
//        self.present(tabbarVC, animated: true, completion: nil)

    }
    
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
}

extension RegisterViewController {
    func signUp() {
        if isValidInput() {
            SVProgressHUD.show()
            let param: [String: Any] = [
                "email": emailText.text ?? "",
                "password": passwordText.text ?? "",
                "phone": mobileText.text ?? "",
                "address": "-",
                "fullName": "-"
            ]
            viewModel.register(with: param)
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.9) {
                UIView.animate(withDuration: 0.1) {
                    self.mobileNoErrorView.isHidden = true
                    self.emailErrorView.isHidden = true
                    self.passwordErrorView.isHidden = true
                    self.rePasswordErrorView.isHidden = true
                    self.bothPasswordErrorView.isHidden = true
                    self.emailValidTopErrorView.isHidden = true
                    self.passwordValidTopErrorView.isHidden = true
                    //                self.emailValidErrorView.isHidden = true
                    //                self.checkBoxErrorView.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func isValidInput() -> Bool {
        var isError = true
         if !mobileText.isValidInput() {
//            self.showAlertView(title: Constants.kErrorMessage, message: "Phone number is required.")
            self.mobileNoErrorView.isHidden = false
            self.mobileNoLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.mobileNoLineView.backgroundColor = UIColor.init(hexString: "#D0021B")

            isError = false
        }
        if !emailText.isValidInput() {
//            self.showAlertView(title: "Error", message: "Email is required.")
            self.emailErrorView.isHidden = false
            self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")

            isError = false
        }
        if !(emailText.text?.isValidEmail ?? false) {
//            self.showAlertView(title: "Error", message: "Please enter valid email.")
            self.emailValidErrorView.isHidden = false
            self.emailValidTopErrorView.isHidden = false
            self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            isError = false
        }
        if !passwordText.isValidInput() {
//            self.showAlertView(title: "Error", message: "Please enter password")
            self.passwordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.passwordErrorView.isHidden = false
            isError = false
        }
        if !confirmPasswordText.isValidInput() {
//            self.showAlertView(title: "Error", message: "Please enter password")
            self.reTypePasswordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.rePasswordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            isError = false
        }
        if passwordText.text != ""{
            if !(passwordText.text?.isStrongPassword ?? false) {
                self.passwordLabel.textColor = UIColor.init(hexString: "#D0021B")
                self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
                self.passwordValidErrorView.isHidden = false
                self.passwordValidTopErrorView.isHidden = false
//                self.showAlertView(title: "Error", message: "Password Must be at least of 8 characters and contains 3 or 4 of the following: Uppercase (A-Z), Lowercase (a-z), Number (0-9), and Special characters (!@#$%^&*)")
                isError = false
            }
        }
        if passwordText.text != confirmPasswordText.text {
//            self.showAlertView(title: "Error", message: "Passwords do no match.")
            self.passwordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.reTypePasswordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.rePasswordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")

            self.bothPasswordErrorView.isHidden = false
            isError = false
        }
        if !checkBtn.isSelected {
//            self.showAlertView(title: "Error", message: "Please select terms and condition.")
            self.checkBoxErrorView.isHidden = false
            isError = false
        }
        return isError
    }
}




