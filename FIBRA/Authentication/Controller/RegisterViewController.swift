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

    
    var viewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailAddressLabel.isHidden = true
        self.mobileNoLabel.isHidden = true
        self.passwordLabel.isHidden = true
        self.reTypePasswordLabel.isHidden = true

        self.btnBackGroundColorView.isHidden = true
        self.btnRegister.isEnabled = false
        viewModel = AuthenticationViewModel(delegate: self, viewController: self)
        
        
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
    
    @IBAction func onLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        } else{
            sender.isSelected = true
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
                "address": "",
                "fullName": ""
            ]
            viewModel.register(with: param)
        }
    }
    
    func isValidInput() -> Bool {
         if !mobileText.isValidInput() {
            self.showAlertView(title: Constants.kErrorMessage, message: "Phone number is required.")
            return false
        }else  if !emailText.isValidInput() {
            self.showAlertView(title: "Error", message: "Email is required.")
            return false
        }else if !(emailText.text?.isValidEmail ?? false) {
            self.showAlertView(title: "Error", message: "Please enter valid email.")
            return false
        }else if !passwordText.isValidInput() {
            self.showAlertView(title: "Error", message: "Please enter password")
            return false
        }else if !(passwordText.text?.isStrongPassword ?? false) {
            self.showAlertView(title: "Error", message: "Password Must be at least of 8 characters and contains 3 or 4 of the following: Uppercase (A-Z), Lowercase (a-z), Number (0-9), and Special characters (!@#$%^&*)")
        }else if passwordText.text != confirmPasswordText.text {
            self.showAlertView(title: "Error", message: "Passwords do no match.")
            return false
        }else if !checkBtn.isSelected {
            self.showAlertView(title: "Error", message: "Please select term and condition.")
            return false
        }
        return true
    }
}




