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
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),NSAttributedString.Key.foregroundColor: UIColor.orange]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)

        qrImageView.set(urlString: "http://fibraapi.imedhealth.us\(LoginData.shared.qrCodeUrl)", placeholder: "")
        self.fibraUserID.text = "Fibra-User-000-\(LoginData.shared.userId)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),NSAttributedString.Key.foregroundColor: UIColor.init(named: "YellowColor")]
        tabBarController?.tabBar.tintColor = UIColor.orange
        self.navigationController?.isNavigationBarHidden = true
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
