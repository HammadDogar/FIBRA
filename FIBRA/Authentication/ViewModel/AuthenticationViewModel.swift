//
//  AuthenticationViewModel.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

protocol AuthenticationViewModelDelegate {
    func onSuccess()
    func onFaild(with error: String)
}

class AuthenticationViewModel: NSObject {
    
    var delegate: AuthenticationViewModelDelegate?
    var viewController: UIViewController!
    
    init(delegate: AuthenticationViewModelDelegate, viewController: UIViewController) {
        self.viewController = viewController
        self.delegate = delegate
    }
    
    func login(with username: String, password: String) {
        let param: [String: Any] = ["email": username,
                                    "password": password,
                                    "roleId": 3]
        WebManager.shared.login(params: param) { (response, error) in
            var isSuccess = false
            if self.viewController.isValidResponse(response: response, error: error) {
                let responseDict = response as! [String: Any]
                if let responseData = responseDict["data"] as? [String: Any] {
                    isSuccess = true
                    LoginData.shared.authDict = (email: username, password: password)
                    LoginData.shared.loadData(dict: responseData)
                    self.delegate?.onSuccess()
                }
            }else if !isSuccess {
                self.delegate?.onFaild(with: error?.localizedDescription ?? Constants.kSomethingWrong)
            }
        }
    }
    
    func register(with param: [String: Any]) {
        WebManager.shared.register(params: param) { (response, error) in
            var isSuccess = false
            if self.viewController.isValidResponse(response: response, error: error) {
                isSuccess = true
                self.delegate?.onSuccess()
            }else if !isSuccess {
                self.delegate?.onFaild(with: error?.localizedDescription ?? Constants.kSomethingWrong)
            }
        }
    }
    
    func forgotPassword(with email: String) {
        let param: [String: Any] = ["email": email]
        WebManager.shared.forgotPassword(params: param) { (response, error) in
            var isSuccess = false
            if self.viewController.isValidResponse(response: response, error: error) {
                isSuccess = true
                self.delegate?.onSuccess()
            }else if !isSuccess {
                self.delegate?.onFaild(with: error?.localizedDescription ?? Constants.kSomethingWrong)
            }
        }
    }
    
    func changePassword(with param: [String: Any]) {
        WebManager.shared.changePAssword(params: param) { (response, error) in
            var isSuccess = false
            if self.viewController.isValidResponse(response: response, error: error) {
                isSuccess = true
                self.delegate?.onSuccess()
            }else if !isSuccess {
                self.delegate?.onFaild(with: error?.localizedDescription ?? Constants.kSomethingWrong)
            }
        }
    }
    
}
