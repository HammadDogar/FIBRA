//
//  LoginViewController.swift
//  FIBRA
//
//  Created by Irfan Malik on 25/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!

    var viewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailAddressLabel.isHidden = true
        self.passwordLabel.isHidden = true
        
        userText.text = "hassan@getnada.com"
        passwordText.text = "Abc@123456"
        
        viewModel = AuthenticationViewModel(delegate: self, viewController: self)
        setupView()
        
        self.userText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                for: .editingChanged)
        self.passwordText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                    for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.userText{
            if textField.text != ""{
                self.emailAddressLabel.isHidden = false
            }else{
                self.emailAddressLabel.isHidden = true
            }
        }else {
            if textField.text != ""{
                self.passwordLabel.isHidden = false
            }else{
                self.passwordLabel.isHidden = true

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func onLogin(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func onForgotPassword(_ sender: UIButton) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Authentication)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
        let vc = RegisterViewController.instantiate(fromAppStoryboard: .Authentication)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginViewController {
    func setupView() {
        userText.attributedPlaceholder =
            NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        passwordText.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
}

extension LoginViewController: AuthenticationViewModelDelegate {
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        SVProgressHUD.dismiss()
        UserDefaults.standard.set(true, forKey: "loginKey")
        UserDefaults.standard.synchronize()
        let tabbarVC = TabbarVC.instantiate(fromAppStoryboard: .Tabbar)
        tabbarVC.modalPresentationStyle = .fullScreen
        self.present(tabbarVC, animated: true, completion: nil)
    }
    
}

extension LoginViewController {
    func signIn() {
        if isValidInput() {
            SVProgressHUD.show()
            viewModel.login(with: userText.text ?? "", password: passwordText.text ?? "")
        }
    }
    
    func isValidInput() -> Bool {
        if !userText.isValidInput() {
            self.showAlertView(title: "Error", message: "Please enter email.")
            return false
        }else if !(userText.text?.isValidEmail ?? false) {
            self.showAlertView(title: "Error", message: "Please enter valid email.")
            return false
        }else if !passwordText.isValidInput() {
            self.showAlertView(title: Constants.kErrorMessage, message: "Password is required.")
            return false
        }
        return true
    }
}
