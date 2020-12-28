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


    var viewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldPasswordLabel.isHidden = true
        self.newPasswordLabel.isHidden = true
        self.reTypePasswordLabel.isHidden = true
        self.btnBackGroundColorView.isHidden = true
        self.btnSaveChanges.isEnabled = false
        
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
            viewModel.changePassword(with: param)
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
        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.showAlertView(title: Constants.kSuccessMessage, message: "Password updated successfully.", successTitle: "OK", successCallback: {
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
            let navigationController = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })
    }
    
}

extension ChangePasswordVC {
    func isValidInput() -> Bool {
        if !oldPassTF.isValidInput() {
            self.showAlertView(title: "Error", message: "Please enter old password")
            return false
        }else if !newPassTF.isValidInput() {
            self.showAlertView(title: "Error", message: "Please enter new password")
            return false
        }else if !(newPassTF.text?.isStrongPassword ?? false) {
            self.showAlertView(title: "Error", message: "Password Must be at least of 8 characters and contains 3 or 4 of the following: Uppercase (A-Z), Lowercase (a-z), Number (0-9), and Special characters (!@#$%^&*)")
        }else if confirmPassTF.text != newPassTF.text {
            self.showAlertView(title: "Error", message: "Passwords do no match.")
            return false
        }
        return true
    }
}


