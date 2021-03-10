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
    @IBOutlet weak var apiErrorView: UIView!
    @IBOutlet weak var apiErrorLabel: UILabel!


    var viewModel: AuthenticationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiErrorView.isHidden = true
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
        self.view.isUserInteractionEnabled = true
            self.apiErrorLabel.text = "User does not exist"
            self.apiErrorView.isHidden = false
//        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        self.apiErrorView.isHidden = true
        Global.shared.updatedStatus = true
//        self.showAlertView(title: "Success", message: "Instruction for reseting password are send on your email adress please check your email. Thanks", successTitle: "Ok", cancelTitle: "", successCallback:  {
            self.navigationController?.popViewController(animated: true)
//        })
    }
}

extension ForgotPasswordVC {
    func forgotPassword() {
        if isValidInput() {
            if BReachability.isConnectedToNetwork(){
                SVProgressHUD.show()
                self.view.isUserInteractionEnabled = false
                viewModel.forgotPassword(with: emailTF.text ?? "")
            }else{
                self.apiErrorLabel.text = "The internet connection appears to be offline."
                self.apiErrorView.isHidden = false
            }
        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                UIView.animate(withDuration: 0.1) {
//                    self.emailErrorView.isHidden = true
//                    self.emailValidTopErrorView.isHidden = true
//                    self.view.layoutIfNeeded()
//                }
//            }
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
        }else{
            self.emailValidTopErrorView.isHidden = true
        }
        if !(emailTF.text?.isValidEmail ?? false) {
            self.emailAddressLabel.textColor = UIColor.init(hexString: "#D0021B")
            self.emailLineView.backgroundColor = UIColor.init(hexString: "#D0021B")

//            self.showAlertView(title: "Error", message: "Please enter valid email.")
            self.emailErrorView.isHidden = false
            self.emailValidErrorView.isHidden = false
            isError = false
        }else{
            self.emailErrorView.isHidden = true
            self.emailValidErrorView.isHidden = true
        }
        return isError
    }
}
