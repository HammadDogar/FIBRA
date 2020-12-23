//
//  SplashViewController.swift
//  FIBRA
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: "loginKey") as? Bool ?? false{
            LoginData.shared.getData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                let tabbarVC = TabbarVC.instantiate(fromAppStoryboard: .Tabbar)
                tabbarVC.modalPresentationStyle = .fullScreen
                tabbarVC.modalTransitionStyle = .crossDissolve

                self.present(tabbarVC, animated: true, completion: nil)
            }
        }else{
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
