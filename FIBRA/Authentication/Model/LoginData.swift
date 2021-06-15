//
//  LoginData.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

class LoginData: NSObject{
    
    let userDefaults = UserDefaults.standard
    var userId = 0
    var role = ""
    var isActive = false
    var isAccountVerified = false
    var createdDate = ""
    var vendorId = 0
    var authToken = ""
    var fullName = ""
    var phone = ""
    var address = ""
    var profileUrl = ""
    var qrCodeUrl = ""
    var about = ""
    var roleId = 0
    
    
    var authDict: (email: String, password: String) {
        set(newAuthDict) {
            userDefaults.set(newAuthDict.password, forKey: CodingKeys.password.rawValue)
            userDefaults.set(newAuthDict.email, forKey: CodingKeys.email.rawValue)
            userDefaults.synchronize()
        }
        get {
            return (email: userDefaults.string(forKey: CodingKeys.email.rawValue) ?? "", password: userDefaults.string(forKey: CodingKeys.password.rawValue) ?? "")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case userId, role, isActive, isAccountVerified, createdDate, vendorId, authToken, fullName, phone, address, profileUrl, qrCodeUrl, about, roleId, email, password }
    
    static var shared = {
        return LoginData()
    }()
    
    private override init() {
        super.init()
    }
    
    func loadData(dict: [String: Any]) {
        userId = dict["userId"] as? Int ?? 0
        role = dict["role"] as? String ?? ""
        isActive = dict["isActive"] as? Bool ?? false
        isAccountVerified = dict["isAccountVerified"] as? Bool ?? false
        createdDate = dict["createdDate"] as? String ?? ""
        vendorId = dict["vendorId"] as? Int ?? 0
        authToken = dict["token"] as? String ?? ""
        fullName = dict["fullName"] as? String ?? ""
        phone = dict["phone"] as? String ?? ""
        address = dict["address"] as? String ?? ""
        profileUrl = dict["profileUrl"] as? String ?? ""
        qrCodeUrl = dict["qrCodeUrl"] as? String ?? ""
        about = dict["about"] as? String ?? ""
        roleId = dict["roleId"] as? Int ?? 0
        saveData()
    }
    
    func removeData() {
        userId = 0
        role = ""
        isActive = false
        isAccountVerified = false
        createdDate = ""
        vendorId = 0
        authToken = ""
        fullName = ""
        phone = ""
        address = ""
        profileUrl = ""
        qrCodeUrl = ""
        about = ""
        roleId = 0
        authDict = (email: "", password: "")
        saveData()
    }
    
    func saveData() {
        userDefaults.set(userId, forKey: CodingKeys.userId.rawValue)
        userDefaults.set(role, forKey: CodingKeys.role.rawValue)
        userDefaults.set(isActive, forKey: CodingKeys.isActive.rawValue)
        userDefaults.set(isAccountVerified, forKey: CodingKeys.isAccountVerified.rawValue)
        userDefaults.set(createdDate, forKey: CodingKeys.createdDate.rawValue)
        userDefaults.set(vendorId, forKey: CodingKeys.vendorId.rawValue)
        userDefaults.set(authToken, forKey: CodingKeys.authToken.rawValue)
        userDefaults.set(fullName, forKey: CodingKeys.fullName.rawValue)
        userDefaults.set(phone, forKey: CodingKeys.phone.rawValue)
        userDefaults.set(address, forKey: CodingKeys.address.rawValue)
        userDefaults.set(profileUrl, forKey: CodingKeys.profileUrl.rawValue)
        userDefaults.set(qrCodeUrl, forKey: CodingKeys.qrCodeUrl.rawValue)
        userDefaults.set(about, forKey: CodingKeys.about.rawValue)
        userDefaults.set(roleId, forKey: CodingKeys.roleId.rawValue)
        userDefaults.synchronize()
    }
    
    func getData() {
        userId = userDefaults.value(forKey: CodingKeys.userId.rawValue) as? Int ?? 0
        role = userDefaults.value(forKey: CodingKeys.role.rawValue) as? String ?? ""
        isActive = userDefaults.value(forKey: CodingKeys.isActive.rawValue) as? Bool ?? false
        isAccountVerified = userDefaults.value(forKey: CodingKeys.isAccountVerified.rawValue) as? Bool ?? false
        createdDate = userDefaults.value(forKey: CodingKeys.createdDate.rawValue) as? String ?? ""
        vendorId = userDefaults.value(forKey: CodingKeys.vendorId.rawValue) as? Int ?? 0
        authToken = userDefaults.value(forKey: CodingKeys.authToken.rawValue) as? String ?? ""
        fullName = userDefaults.value(forKey: CodingKeys.fullName.rawValue) as? String ?? ""
        phone = userDefaults.value(forKey: CodingKeys.phone.rawValue) as? String ?? ""
        address = userDefaults.value(forKey: CodingKeys.address.rawValue) as? String ?? ""
        profileUrl = userDefaults.value(forKey: CodingKeys.profileUrl.rawValue) as? String ?? ""
        qrCodeUrl = userDefaults.value(forKey: CodingKeys.qrCodeUrl.rawValue) as? String ?? ""
        about = userDefaults.value(forKey: CodingKeys.about.rawValue) as? String ?? ""
        roleId = userDefaults.value(forKey: CodingKeys.roleId.rawValue) as? Int ?? 0
    }
}
