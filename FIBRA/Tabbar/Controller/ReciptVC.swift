//
//  ReciptVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReciptVC: UIViewController {
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var apiErrorView: UIView!
    @IBOutlet weak var apiErrorLabel: UILabel!
    
    var transactionId:Int = 0
    var viewModel: ReciptViewModel!
    var refreshControl = UIRefreshControl()
    var shouldPerfoamNotificationAction = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //05-03
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFromNoti), name: NSNotification.Name("refreshReceipts"), object: nil)
        
        errorLbl.isHidden = true
        self.tableView.register(UINib(nibName: "ReceiptTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiptTableViewCell")
        viewModel = ReciptViewModel(delegate: self, viewController: self)
        if BReachability.isConnectedToNetwork(){
            self.apiErrorView.isHidden = true
            viewModel.getAllRecipts(isLoader: true)
        }else{
            self.apiErrorLabel.text = "The internet connection appears to be offline."
            self.apiErrorView.isHidden = false
        }
        self.tableView.rowHeight = 85.0
        //05-03
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
     }
    //05-03
    @objc func refreshFromNoti() {
        viewModel.getAllRecipts(isLoader: true)
    }
    //05-03
     @objc func refresh(_ sender: AnyObject) {
        if BReachability.isConnectedToNetwork(){
            self.apiErrorView.isHidden = true
            viewModel.getAllRecipts(isLoader:false)

        }else{
            self.refreshControl.endRefreshing()
            self.apiErrorLabel.text = "Unable to Refresh, Internet connection appears to be offline."
            self.apiErrorView.isHidden = false
            
            
        }
     }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.init(named: "Base")
        self.navigationController?.isNavigationBarHidden = true
        //05-03
        viewModel.getAllRecipts()
    }
    
//    @objc func methodOfReceivedNotification(notification:NSNotification){
//        print("hello")
//    }
}

extension ReciptVC: ReciptViewModelDelegate {
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        tableView.reloadData()
        //05-03
        errorLbl.isHidden = viewModel.totalRecipts > 0 ? true : false
        
        
        if shouldPerfoamNotificationAction {
            getImageIndex(transactionId:transactionId)
            shouldPerfoamNotificationAction = false
        }
    }
    
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        errorLbl.isHidden = viewModel.totalRecipts > 0 ? true : false
//        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
}

extension ReciptVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.totalRecipts
        let key = viewModel.sectionKeys[section]
        
//        totalIndex = (viewModel.sectionReceipt[key]?.count)!
        
        return (viewModel.sectionReceipt[key]?.count)!

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.tableView{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ReceiptHeaderTableViewCell") as! ReceiptHeaderTableViewCell
            
            let key = viewModel.sectionKeys[section]
            headerCell.configure(sectionDate: "\(key)")
            return headerCell.contentView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
//
//        for i in (0...totalIndex-1).reversed(){
//            let recipt = viewModel.recipt(at: i)
//            let key = viewModel.sectionKeys[indexPath.section]
//            let item = (viewModel.sectionReceipt[key]?[i])
//            cell.titleLbl.text = item?.vendorName ?? ""
//            cell.qrNumberLbl.text = "\(item?.netAmount ?? 0)"
//
//            let year = item!.createdDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("yyyy"))
//            let monthAndDay = item!.createdDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("d MMM"))
//
//            let attributedString = NSMutableAttributedString(string: "\(monthAndDay ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), .foregroundColor: UIColor(named: "Base") ?? .green])
//
//            let dateString = NSMutableAttributedString(string: "\n\(year ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), .foregroundColor: UIColor(named: "DarkGray") ?? .darkGray])
//            attributedString.append(dateString)
//
//            cell.dateLbl.attributedText = attributedString
//            print("\(attributedString)")
//            return cell
//        }
//        return cell
        
        let recipt = viewModel.recipt(at: indexPath.row)
        let key = viewModel.sectionKeys[indexPath.section]
        let item = (viewModel.sectionReceipt[key]?[indexPath.row])
        
        cell.titleLbl.text = item?.vendorName ?? ""
        cell.qrNumberLbl.text = "\(item?.netAmount ?? 0)"
        
        //chnaged from == 0 to this
        if item?.isRead ?? false{
            cell.redDotImage.isHidden = true
        }
        else{
            cell.redDotImage.isHidden = false
        }

        let year = item!.createdDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("yyyy"))
        let monthAndDay = item!.createdDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("d MMM"))

        let attributedString = NSMutableAttributedString(string: "\(monthAndDay ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), .foregroundColor: UIColor(named: "Base") ?? .green])

        let dateString = NSMutableAttributedString(string: "\n\(year ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), .foregroundColor: UIColor(named: "DarkGray") ?? .darkGray])
        attributedString.append(dateString)

        cell.dateLbl.attributedText = attributedString
        print("\(attributedString)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // create func get first index image from this
        let recipt = viewModel.recipt(at: indexPath.row)
        let key = viewModel.sectionKeys[indexPath.section]
        let item = (viewModel.sectionReceipt[key]?[indexPath.row])
        let vc = ImagePreviewVC.instantiate(fromAppStoryboard: .Main)
        vc.urlString = "http://\(item?.receiptUrl ?? "")"
        vc.vendorName = item?.vendorName ?? ""
        vc.date = item?.createdDate ?? ""
        //05-03
        viewModel.sectionReceipt[key]?[indexPath.row].isRead = true

        vc.transactionId = item!.transactionId as Int
        print(item!.transactionId as Int)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func getImageIndex(transactionId:Int) {
        var reciptUrl = ""
        if viewModel != nil{
            
            for i in 0...viewModel.recipts.count-1{
                if viewModel.recipts[i].transactionId == transactionId{
                    reciptUrl = viewModel.recipts[i].receiptUrl
                }
            }
            
            //let key = viewModel.sectionKeys[0]
            //let item = (viewModel.sectionReceipt[key]?[0])
            let key = viewModel.sectionKeys[0]
            let item = (viewModel.sectionReceipt[key]?[0])
            let vc = ImagePreviewVC.instantiate(fromAppStoryboard: .Main)
            vc.urlString = "http://\(reciptUrl)"
            vc.vendorName = item?.vendorName ?? ""
            vc.date = item?.createdDate ?? ""
            vc.transactionId = item!.transactionId as Int
            print(item!.transactionId as Int)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            shouldPerfoamNotificationAction = true
        }
    }
}
