//
//  LogoutVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import UIKit

class LogoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onYes(_ sender: UIButton) {
        LoginData.shared.removeData()
        UserDefaults.standard.set(false, forKey: "loginKey")
        UserDefaults.standard.synchronize()
        let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
        let navigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func onNo(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
