//
//  SplashViewController.swift
//  FIBRA
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit

class SplashViewController: UIViewController {
    
    var isFromNotification = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for moving to recipt
//        isFromNotification = true
        
        
        if UserDefaults.standard.value(forKey: "loginKey") as? Bool ?? false{
            LoginData.shared.getData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                let tabbarVC = TabbarVC.instantiate(fromAppStoryboard: .Tabbar)
                tabbarVC.modalPresentationStyle = .fullScreen
                tabbarVC.modalTransitionStyle = .crossDissolve
                
                // notification 11-34
                
                if self.isFromNotification {
                    tabbarVC.currentIndex = 0
                }else {
                    tabbarVC.currentIndex = 1
                }
                
                //
                
                self.present(tabbarVC, animated: true, completion: nil)
            }
        }else{
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
