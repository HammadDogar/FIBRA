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
    
    var viewModel: ReciptViewModel!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ReceiptTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiptTableViewCell")
        viewModel = ReciptViewModel(delegate: self, viewController: self)
        viewModel.getAllRecipts()
        self.tableView.rowHeight = 85.0

        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
     }

     @objc func refresh(_ sender: AnyObject) {
        viewModel.getAllRecipts()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.init(named: "Base")
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension ReciptVC: ReciptViewModelDelegate {
    func onSuccess() {
        self.refreshControl.endRefreshing()
        tableView.reloadData()
        errorLbl.isHidden = viewModel.totalRecipts > 0 ? true : false
    }
    
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.refreshControl.endRefreshing()
        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
}

extension ReciptVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.totalRecipts
        let key = viewModel.sectionKeys[section]
        return (viewModel.sectionReceipt[key]?.count)!

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.tableView{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ReceiptHeaderTableViewCell") as! ReceiptHeaderTableViewCell
            
            let key = viewModel.sectionKeys[section]
//            let year = (key.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("yyyy")))!
//            let monthAndDay = (key.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("d MMM")))!

            headerCell.configure(sectionDate: "\(key)")
            return headerCell.contentView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
        let recipt = viewModel.recipt(at: indexPath.row)
        let key = viewModel.sectionKeys[indexPath.section]
        let item = (viewModel.sectionReceipt[key]?[indexPath.row])
        cell.titleLbl.text = item?.vendorName ?? ""
        cell.qrNumberLbl.text = "\(item?.netAmount ?? 0)"
        
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
        let recipt = viewModel.recipt(at: indexPath.row)
        let key = viewModel.sectionKeys[indexPath.section]
        let item = (viewModel.sectionReceipt[key]?[indexPath.row])

        let vc = ImagePreviewVC.instantiate(fromAppStoryboard: .Main)
        vc.urlString = "http://\(item?.receiptUrl ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

}
