//
//  Recipt.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import Foundation

class Recipt: NSObject {
    
    var transactionId = 0
    var venderId = 0
    var userId = 0
    var createdDate = ""
    var netAmount = 0
    var grossAmount = 0
    var receiptUrl = ""
    var userName = ""
    var vendorName = ""
    //chnaged from int to bool
    var isRead = false
    var creationDate = Date()
    
    
    
    init(dict: [String: Any]) {
        transactionId = dict["transactionId"] as? Int ?? 0
        venderId = dict["venderId"] as? Int ?? 0
        userId = dict["userId"] as? Int ?? 0
        createdDate = dict["createdDate"] as? String ?? ""
        netAmount = dict["netAmount"] as? Int ?? 0
        grossAmount = dict["grossAmount"] as? Int ?? 0
        receiptUrl = dict["receiptUrl"] as? String ?? ""
        userName = dict["userName"] as? String ?? ""
        vendorName = dict["vendorName"] as? String ?? ""
        isRead = dict["isRead"] as? Bool ?? false
        
        if createdDate != "" {
            let formattor = DateFormatter()
            formattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formattor.date(from: createdDate) {
                self.creationDate = date
            }else{
                self.creationDate = Date()
            }
        }
    }
    
}
