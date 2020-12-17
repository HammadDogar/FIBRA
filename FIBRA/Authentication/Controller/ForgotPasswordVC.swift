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

    var viewModel: AuthenticationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailAddressLabel.isHidden = true
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
        }
    }
    
    func isValidInput() -> Bool {
        if !emailTF.isValidInput() {
            self.showAlertView(title: "Error", message: "Please enter email.")
            return false
        }else if !(emailTF.text?.isValidEmail ?? false) {
            self.showAlertView(title: "Error", message: "Please enter valid email.")
            return false
        }
        return true
    }
}
