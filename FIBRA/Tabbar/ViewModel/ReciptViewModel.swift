//
//  ReciptViewModel.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

protocol ReciptViewModelDelegate {
    func onSuccess()
    func onFaild(with error: String)
}

import UIKit
import SVProgressHUD

class ReciptViewModel: NSObject {
    
    var delegate: ReciptViewModelDelegate?
    var viewController: UIViewController!
    
    var unread = 0
    
    var recipts: [Recipt] = []
    var sectionReceipt: [String:[Recipt]] = [String:[Recipt]]()
    var sectionKeys: [String] = [String]()

    var totalRecipts: Int {
        return recipts.count
    }
    
//    var unreadRecipts: Int {
//        _ = recipts.filter { (r) -> Bool in
//            if !r.isRead  {
//                unread += 1
//            }
//            return true
//        }
//        return unread
//    }
    
    func recipt(at index: Int) -> Recipt {
        return recipts[index]
    }
    
    init(delegate: ReciptViewModelDelegate, viewController: UIViewController) {
        self.viewController = viewController
        self.delegate = delegate
    }
    
    func getAllRecipts(isLoader:Bool = false) {
        if isLoader {
            SVProgressHUD.show()
        }
        
        WebManager.shared.getAllRecipt(params: [:]) { (response, error) in
            var isSuccess = false
            var datesCheck:[String] = [String]()
            print(response as Any)
            self.unread = 0
            if self.viewController.isValidResponse(response: response, error: error) {
                let responseDict = response as! [String: Any]
                print(responseDict)
                if let responseData = responseDict["data"] as? [[String: Any]] {
                    isSuccess = true
                    self.recipts = responseData.map({Recipt(dict: $0)})
                    // 20-2 4-26 for badge number
                    
                    _ = self.recipts.filter { (recipt) -> Bool in
                        if !recipt.isRead {
                            self.unread += 1
                        }
                        return true
                    }
                   let sorted = self.recipts.sorted { (date1, date2) -> Bool in
                        date1.createdDate > date2.createdDate
                    }
                    for eachReceipt in sorted {
                       let date = eachReceipt.createdDate.date(with: .DATE_TIME_FORMAT_ISO8601)
                        let receiptDate = eachReceipt.createdDate.components(separatedBy: "T").first!
                        let key = date?.getPastTime()
                        if datesCheck.contains(key!){
                            self.sectionReceipt[receiptDate]?.append(eachReceipt)
                        }else{
                            datesCheck.append(key!)
                            self.sectionReceipt[receiptDate] = [eachReceipt]
                        }
                    }
                    
                    self.sectionKeys = self.sectionReceipt.keys.sorted(by: { (str1, str2) -> Bool in
                        str1 > str2
                    })
                    for (key, value) in self.sectionReceipt{
                        //self.sectionReceipt[key] = value.reversed()
                    }
                    self.delegate?.onSuccess()
                    print("Count of unread recipts : ---------------- \(self.unread)")
                    
                   // UIApplication.shared.applicationIconBadgeNumber = self.unread
                }
            }else if !isSuccess {
                self.delegate?.onFaild(with: error?.localizedDescription ?? Constants.kSomethingWrong)
            }
        }
    }
}
