//
//  SplashViewController.swift
//  FIBRA
//
//  Created by Irfan Malik on 17/12/2020.
//

import UIKit

class SplashViewController: UIViewController {
    
    var isFromNotification = false
    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserDefaults.standard.value(forKey: "loginKey") as? Bool ?? false{
            LoginData.shared.getData()
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                let tabbarVC = TabbarVC.instantiate(fromAppStoryboard: .Tabbar)
                tabbarVC.modalPresentationStyle = .fullScreen
                tabbarVC.modalTransitionStyle = .crossDissolve
                
                // notification 11-34
                
                if self.isFromNotification {
                    tabbarVC.currentIndex = 0
                    
                    
                    // 04-03
                    Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) {_ in
                        let tsb = UIStoryboard(name: "Tabbar", bundle: nil)
                        if let topVC = UIApplication.getTopViewController(){
                            if let vc1 = topVC.tabBarController?.selectedViewController as? UINavigationController {
                                
                                if #available(iOS 13.0, *) {
                                    let reciptVC = tsb.instantiateViewController(identifier: "ReciptVC") as! ReciptVC
                                    reciptVC.transactionId = self.id
                                    reciptVC.getImageIndex(transactionId:self.id)
                                    
                                    vc1.popToRootViewController(animated: false)
                                    vc1.pushViewController(reciptVC, animated: false)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                        }
                    }
                    
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
