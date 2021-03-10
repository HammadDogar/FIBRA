//
//  WebManager.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestCompletion = (_ response: Any?, _ error: Error?) -> Void

class WebManager: NSObject {
    
    static let shared: WebManager = {
        return WebManager()
    }()
    
    #if Debug
        let baseUrl = "http://fibraapi.imedhealth.us/"
        private let apiBaseUrl = "http://fibraapi.imedhealth.us/api/"
    #else
        let baseUrl = "http://fibraapi.imedhealth.us/"
        private let apiBaseUrl = "http://fibraapi.imedhealth.us/api/"
    #endif
    
    let ITUNES_URL = ""
    
    private override init() {
        super.init()
    }
}

//MARK: - Authentication

extension WebManager {
    
    func login(params: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: ApiMethods.login.rawValue, parameters: params, completion: completion)
    }
    
    func register(params: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: ApiMethods.register.rawValue, parameters: params, completion: completion)
    }
    
    func forgotPassword(email: String, completion: @escaping RequestCompletion) {
        //POSTRequest(url: ApiMethods.forgotPassword.rawValue, parameters: params, completion: completion)
        POSTRequestForgotPassword(email: email, completion: completion)
    }
    
    func changePAssword(params: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: ApiMethods.changePassword.rawValue, parameters: params, completion: completion)
    }
    
    func updateProfile(params: Parameters, completion: @escaping RequestCompletion) {
        self.POSTRequest(url: ApiMethods.updateProfile.rawValue, parameters: params, completion: completion)
        
        
        
    }
    
            
//        PostRequestWithMultipartImage(url: ApiMethods.updateImage.rawValue, selectedImages: selectedImage) { (imgUrl, isSuccess) in
//            if isSuccess{
//                let parameters:[String:Any] = [
//                    "fullName": params["fullName"] as! String,
//                    "phone": params["phone"] as! String,
//                    "address": params["address"] as! String,
//                    "profileUrl": imgUrl
//                ]
//                Global.shared.profileUrl = imgUrl
//                self.POSTRequest(url: ApiMethods.updateProfile.rawValue, parameters: parameters, completion: completion)
//            }else{
//
//            }
//        }
    
}

//MARK: Recipt

extension WebManager {
    func getAllRecipt(params: Parameters, completion: @escaping RequestCompletion) {
        GETRequest(url: ApiMethods.recipt.rawValue, parameters: params, completion: completion)
    }
}

extension WebManager {
    func PostRequestWithMultipartImage(url:String, selectedImages:UIImage, completion: @escaping (String,Bool) -> Void){
        if let imgData = selectedImages.jpegData(compressionQuality: 0.7) {


           Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "abc.jpg", mimeType: "image/jpg")
                    //Optional for extra parameters
               },
           to:URL.init(string: apiBaseUrl+url)!)
           { (result) in
               switch result {
               case .success(let upload, _, _):
                   upload.uploadProgress(closure: { (progress) in
                       print("Upload Progress: \(progress.fractionCompleted)")
                   })

                upload.responseJSON { response in
                    let dic = response.result.value as? [String: Any]
                    print(dic?["message"] as? String ?? "")
                    print(response.result.value)
                    completion(dic?["message"] as? String ?? "",true)
                   }

               case .failure(let encodingError):
                   print(encodingError)
                completion("Failed to upload your profile image",false)

               }
           }
        }
    }
    fileprivate func POSTRequest(url: String, parameters: Parameters, completion: @escaping RequestCompletion) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        var request = URLRequest(url: URL(string: apiBaseUrl + url)!)
        print(url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        print(parameters)
        
        request.httpBody = toJSonString(data: parameters).data(using: .utf8)
        request.httpMethod = "POST"
        manager.request(request).responseJSON { (response) in
            print(response)
        if response.result.isSuccess {
            completion(response.result.value, nil)
        } else {
            completion(nil,response.error)
            }
        }
    }
    fileprivate func POSTRequestForgotPassword(email:String, completion: @escaping RequestCompletion) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        var request = URLRequest(url: URL(string: "http://fibraapi.imedhealth.us/api/Users/ForgotPassword?email=\(email)")!)

        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        manager.request(request).responseJSON { (response) in
            print(response)
        if response.result.isSuccess {
            completion(response.result.value, nil)
        } else {
            completion(nil,response.error)
            }
        }
    }

    
    fileprivate func GETRequest(url: String, parameters: Parameters, completion: @escaping RequestCompletion) {
        
        let urlType = URL(string: url)!
        
        let queryItems = parameters.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        
        var urlComponents = URLComponents(url: urlType, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        print(urlComponents?.url ?? "")
              
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        var request = URLRequest(url: URL(string: apiBaseUrl + (urlComponents?.url?.absoluteString)!)!)
        
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        
        manager.request(request).responseJSON { (response) in
            if response.result.isSuccess {
                completion(response.result.value, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    fileprivate func DeleteRequest(url: String, parameters: Parameters, completion: @escaping RequestCompletion) {
        
        let urlType = URL(string: url)!
        
        let queryItems = parameters.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        
        var urlComponents = URLComponents(url: urlType, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        print(urlComponents?.url ?? "")
              
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        var request = URLRequest(url: URL(string: apiBaseUrl + (urlComponents?.url?.absoluteString)!)!)
        
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        
        manager.request(request).responseJSON { (response) in
            if response.result.isSuccess {
                completion(response.result.value, nil)
                
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    fileprivate func PUTRequest(url: String, parameters: Parameters, completion: @escaping RequestCompletion) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        var request = URLRequest(url: URL(string: apiBaseUrl + url)!)
        print(url)
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = toJSonString(data: parameters).data(using: .utf8)
        request.httpMethod = "PUT"
        
        manager.request(request).responseJSON { (response) in
            if response.result.isSuccess {
                completion(response.result.value, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    fileprivate func toJSonString(data : Any) -> String {
        
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
    }
    
}

