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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageView.set(urlString: "http://fibraapi.imedhealth.us\(LoginData.shared.qrCodeUrl)", placeholder: "stockQR")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

}
