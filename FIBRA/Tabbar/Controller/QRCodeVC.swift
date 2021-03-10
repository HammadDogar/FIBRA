//
//  QRCodeVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class QRCodeVC: UIViewController {

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var fibraUserID: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),NSAttributedString.Key.foregroundColor: UIColor.init(named: "YellowColor")]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)

        
        self.fibraUserID.text = "\(LoginData.shared.userId)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#EFB243")]
        tabBarController?.tabBar.tintColor = UIColor.init(named: "YellowColor")
        self.navigationController?.isNavigationBarHidden = true
        print("http://fibraapi.imedhealth.us\(LoginData.shared.qrCodeUrl)")
        qrImageView.set(urlString: "http://fibraapi.imedhealth.us\(LoginData.shared.qrCodeUrl)", placeholder: "")
    }
    
    @IBAction func actionShare(_ sender: Any)
   {

       let objectsToShare:URL = URL(string: "http://fibraapi.imedhealth.us\(LoginData.shared.qrCodeUrl)")!
       let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
       let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
       activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

       self.present(activityViewController, animated: true, completion: nil)

   }

}
