//
//  ApiMethods.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

enum ApiMethods: String {
    case login = "Auth/Login"
    case register = "Users/Register"
    case forgotPassword = "Users/ForgotPassword"
    case changePassword = "Users/ResetPassword"
    case recipt = "Transaction/GetAllTransactions"
    case updateProfile = "Users/UpdateUserProfile"
    case updateImage = "Users/UploadFile"

}

