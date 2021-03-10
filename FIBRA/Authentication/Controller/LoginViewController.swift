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
    @IBOutlet weak var emailSentView: UIView!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var btnBackGroundColorView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNewPassword: UIButton!

    @IBOutlet weak var emailValidErrorView: UIView!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    
    @IBOutlet weak var passwordValidTopErrorView: UIView!
    @IBOutlet weak var emailValidTopErrorView: UIView!
    @IBOutlet weak var passwordValidErrorView: UIView!
    @IBOutlet weak var apiErrorView: UIView!
    @IBOutlet weak var apiErrorLabel: UILabel!



    var viewModel: AuthenticationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureErrorViews()
        self.btnLogin.backgroundColor = UIColor.clear
//        self.emailAddressLabel.isHidden = true
//        self.passwordLabel.isHidden = true
//        self.btnBackGroundColorView.isHidden = true
//        self.btnLogin.isEnabled = false
        
//        userText.text = "hassan@getnada.com"
//        passwordText.text = "Abc@123456"
        
        self.btnNewPassword.setTitle(" Show", for: .normal)
        self.btnNewPassword.setTitle(" Hide", for: .selected)
        
        
        self.btnNewPassword.setImage(UIImage(named: "showPassword"), for: .normal)
        self.btnNewPassword.setImage(UIImage(named: "hidePassword"), for: .selected)

        viewModel = AuthenticationViewModel(delegate: self, viewController: self)
        setupView()
        
        self.userText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                for: .editingChanged)
        self.passwordText.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                    for: .editingChanged)
    }
    
    
    
    func configureErrorViews(){
        self.emailErrorView.isHidden = true
        self.passwordErrorView.isHidden = true
        self.emailValidErrorView.isHidden = true
        self.emailValidTopErrorView.isHidden = true
        self.passwordValidErrorView.isHidden = true
        self.passwordValidTopErrorView.isHidden = true
        self.apiErrorView.isHidden = true
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
        if self.userText.text != "" && self.passwordText.text != ""{
            self.btnBackGroundColorView.isHidden = false
            self.btnLogin.backgroundColor = UIColor.clear
            self.btnLogin.isEnabled = true
        }else{
            self.btnBackGroundColorView.isHidden = true
            self.btnLogin.backgroundColor = UIColor.lightGray
            self.btnLogin.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if Global.shared.updatedStatus{
            Global.shared.updatedStatus = false
            self.emailSentView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now()+6) {
                self.emailSentView.isHidden = true
            }
        }else{
            self.emailSentView.isHidden = true
        }
    }
    @IBAction func actionNewPassWordShow(_ sender: UIButton) {
        self.btnNewPassword.isSelected.toggle()
        self.passwordText.isSecureTextEntry.toggle()
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
        self.view.isUserInteractionEnabled = true
        self.apiErrorView.isHidden = false

        if error == Constants.kSomethingWrong{
            self.apiErrorLabel.text = "Email or Password is Invalid"
            self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.passwordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
        }else{
            self.apiErrorLabel.text = "\(error)"
        }
//        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.apiErrorView.isHidden = true
        self.view.isUserInteractionEnabled = true
        UserDefaults.standard.set(true, forKey: "loginKey")
        UserDefaults.standard.synchronize()
        let tabbarVC = TabbarVC.instantiate(fromAppStoryboard: .Tabbar)
        tabbarVC.modalPresentationStyle = .fullScreen
        tabbarVC.modalTransitionStyle = .crossDissolve
        self.present(tabbarVC, animated: true, completion: nil)
    }
    
    
    
}

extension LoginViewController {
    func signIn() {
        if isValidInput() {
            if BReachability.isConnectedToNetwork(){
                SVProgressHUD.show()
                self.view.isUserInteractionEnabled = false
                viewModel.login(with: userText.text ?? "", password: passwordText.text ?? "")
                
                
            }else{
                self.apiErrorLabel.text = "The internet connection appears to be offline."
                self.apiErrorView.isHidden = false
            }
        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                UIView.animate(withDuration: 0.1) {
//                    self.emailErrorView.isHidden = true
//                    self.passwordErrorView.isHidden = true
//                    self.emailValidTopErrorView.isHidden = true
//                    self.passwordValidTopErrorView.isHidden = true
//                    self.view.layoutIfNeeded()
//                }
//            }
        }
    }
    
    func isValidInput() -> Bool {
        var isError = true
        if !userText.isValidInput() {
            self.emailErrorView.isHidden = false

//            self.showAlertView(title: "Error", message: "Please enter email.")
            isError = false
        }else{
            self.emailErrorView.isHidden = true

        }
        if userText.isValidInput(){
            if !(userText.text?.isValidEmail ?? false) {
                self.emailValidErrorView.isHidden = false
                self.emailValidTopErrorView.isHidden = false
                self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
                self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
                
                //            self.showAlertView(title: "Error", message: "Please enter valid email.")
                isError = false
            }else{
                self.emailValidErrorView.isHidden = true
                self.emailValidTopErrorView.isHidden = true
                self.emailAddressLabel.textColor = UIColor.init(named: "YellowColor")
                self.emailLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")

            }            
        }
        if !passwordText.isValidInput() {
            self.passwordLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.passwordErrorView.isHidden = false
            self.passwordValidErrorView.isHidden = false
//            self.showAlertView(title: Constants.kErrorMessage, message: "Password is required.")
            isError = false
        }else{
            self.passwordErrorView.isHidden = true
            self.passwordValidErrorView.isHidden = true
            self.passwordLabel.textColor = UIColor.init(named: "YellowColor")
            self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")

        }
        if passwordText.isValidInput(){
            if !(passwordText.text?.isStrongPassword ?? false) {
                self.passwordLabel.textColor = UIColor.init(hexString: "#D0021B")
                self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
                self.passwordValidErrorView.isHidden = false
                self.passwordValidTopErrorView.isHidden = false
//                self.showAlertView(title: "Error", message: "Password Must be at least of 8 characters and contains 3 or 4 of the following: Uppercase (A-Z), Lowercase (a-z), Number (0-9), and Special characters (!@#$%^&*)")
                isError = false
            }else{
                self.passwordValidErrorView.isHidden = true
                self.passwordValidTopErrorView.isHidden = true
                self.passwordLabel.textColor = UIColor.init(named: "YellowColor")
                self.passwordLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")
            }
        }
        return isError
    }
}
