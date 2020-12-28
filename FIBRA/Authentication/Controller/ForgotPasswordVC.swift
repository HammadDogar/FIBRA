//
//  ForgotPasswordVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var btnBackGroundColorView: UIView!
    @IBOutlet weak var btnForgotPassword: UIButton!

    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var emailValidErrorView: UILabel!
    @IBOutlet weak var emailValidTopErrorView: UIView!


    var viewModel: AuthenticationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailAddressLabel.isHidden = true
        self.btnBackGroundColorView.isHidden = true
        self.btnForgotPassword.isEnabled = false
        self.emailErrorView.isHidden = true
        self.emailValidTopErrorView.isHidden = true
        self.emailValidErrorView.isHidden = true
        
        
        viewModel = AuthenticationViewModel(delegate: self, viewController: self)
        // Do any additional setup after loading the view.
        self.emailTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)),
                                    for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.emailTF{
            if textField.text != ""{
                self.emailAddressLabel.isHidden = false
            }else{
                self.emailAddressLabel.isHidden = true
            }
        }
        if self.emailTF.text != "" {
            self.btnBackGroundColorView.isHidden = false
            self.btnForgotPassword.backgroundColor = UIColor.clear
            self.btnForgotPassword.isEnabled = true
        }else{
            self.btnBackGroundColorView.isHidden = true
            self.btnForgotPassword.backgroundColor = UIColor.lightGray
            self.btnForgotPassword.isEnabled = false
        }
    }
    
    
    @IBAction func onForgotPassword(_ sender: UIButton) {
        forgotPassword()
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ForgotPasswordVC: AuthenticationViewModelDelegate {
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.showAlertView(title: "Success", message: "Instruction for reseting password are send on your email adress please check your email. Thanks", successTitle: "Ok", cancelTitle: "", successCallback:  {
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension ForgotPasswordVC {
    func forgotPassword() {
        if isValidInput() {
            SVProgressHUD.show()
            viewModel.forgotPassword(with: emailTF.text ?? "")
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.9) {
                UIView.animate(withDuration: 0.1) {
                    self.emailErrorView.isHidden = true
                    self.emailValidTopErrorView.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func isValidInput() -> Bool {
        var isError = true
        if !emailTF.isValidInput() {
            self.emailValidTopErrorView.isHidden = false
            self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")

//            self.showAlertView(title: "Error", message: "Please enter email.")
            isError = false
        }
        if !(emailTF.text?.isValidEmail ?? false) {
            self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")

//            self.showAlertView(title: "Error", message: "Please enter valid email.")
            self.emailErrorView.isHidden = false
            self.emailValidErrorView.isHidden = false
            isError = false
        }
        return isError
    }
}
