//
//  ImagePreview.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import UIKit
import SVProgressHUD
import WebKit

class ImagePreviewVC: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL(string: urlString) {
            webView.navigationDelegate = self
            SVProgressHUD.show()
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        if let url = URL(string: urlString) {
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ImagePreviewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
}
