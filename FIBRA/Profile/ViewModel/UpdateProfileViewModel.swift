//
//  UpdateProfileViewModel.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 29/11/2020.
//

protocol UpdateProfileViewModelDelegate {
    func onSuccess()
    func onFaild(with error: String)
}

import UIKit

class UpdateProfileViewModel: NSObject {
    
    var delegate: UpdateProfileViewModelDelegate?
    var viewController: UIViewController!
    
    init(delegate: UpdateProfileViewModelDelegate, viewController: UIViewController) {
        self.viewController = viewController
        self.delegate = delegate
    }
    
    func updateProfile(with param: [String: Any],selectedImage:UIImage) {
        WebManager.shared.updateProfile(params: param, selectedImage: selectedImage) { (response, error) in
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

