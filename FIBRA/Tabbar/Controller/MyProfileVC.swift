//
//  MyProfileVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import Kingfisher


class MyProfileVC: UIViewController {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var custumerNoLbl: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.init(named: "Base")

        setData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onInfo(_ sender: UIButton) {
        let vc = InfoVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onChangePassword(_ sender: UIButton) {
        let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Authentication)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        let vc = LogoutVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
}

extension MyProfileVC {
    func setData() {
        userNameLbl.text = LoginData.shared.fullName
        custumerNoLbl.text = "Customer No.: \(LoginData.shared.userId)"//"Fibra-User-000-\(LoginData.shared.userId)"
        mobileNumber.text = "Mobile No: \(LoginData.shared.phone)"
        email.text = "Email: \(LoginData.shared.authDict.email)"
//        if LoginData.shared.profileUrl != ""{
//            let url = URL.init(string: WebManager.shared.baseUrl+LoginData.shared.profileUrl)
//            self.userImageView.kf.indicatorType = .activity
//            self.userImageView.kf.setImage(with: url)
//        }else{
//            self.userImageView.image = UIImage.init(named: "profileGreen")
//        }
    }
}
