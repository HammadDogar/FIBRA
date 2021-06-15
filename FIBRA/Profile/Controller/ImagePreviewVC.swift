//
//  ImagePreview.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import UIKit
import SVProgressHUD
import WebKit

class ImagePreviewVC: UIViewController{

    
    @IBOutlet var webView: WKWebView!
    
    var transactionId = 0
    var viewModel: ReciptViewModel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var urlString: String!
    var vendorName: String!
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activityIndicatorView.color = .gray
        activityIndicatorView.isHidden = true
        // Do any additional setup after loading the view.
        if let url = URL(string: urlString) {
            webView.navigationDelegate = self
            SVProgressHUD.show()
//            activityIndicatorView.startAnimating()
            webView.load(URLRequest(url: url))
            

        }
        self.ReadTransaction()
        
        
    }
    
    func ReadTransaction(){
        var task:URLSessionDataTask?
        let url = "http://fibraapi.imedhealth.us/api/\(ApiMethods.ReadRecipt.rawValue)?transactionId=\(transactionId)"
        let urlString = URL(string: url)
        
        let parameter:[String:Any] = [:]
        
//        let parameter = ["transactionId":transactionId] as! [String:Any]
    
        var request = URLRequest(url: urlString!)
        
        request.httpMethod = "POST"
        
        print(transactionId)
        print(parameter)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: [])
        }
        catch{
            print("error")
        }
//        print(request.httpBody)
        request.addValue("Bearer \(LoginData.shared.authToken)", forHTTPHeaderField: "Authorization")
        
//        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.dataTask(with: request){(data,response,error) in
            if let error = error{
                print(error)
                
            }
             guard let data = data else{
                return
            }
            print(data)
            
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
                    print(json)
                    
                    if let jsonData = json["status"]{
                        if jsonData as! Int == 1{
                            print("Successfull")
                        }
                        print("Status code \(jsonData)")
                    }
                }
            }
            catch{
                print("Error")
            }
            
        }
        task?.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
//        activityIndicatorView.stopAnimating()
//        activityIndicatorView.isHidden = true


    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        
        
//        let year = item!.createdDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("d MMM, yyyy"))
        var dateString = ""
        if date != "" {
            if let dateObj = date.date(with: DateFormateStyle.DATE_TIME_FORMAT_ISO8601) {
                dateString = dateObj.string(with: DateFormateStyle.custom("d MMM, yyyy"))
            }
        }
        
        
        let sendStr = vendorName + " reciept - " + dateString

//        let text2 = "reciept -"
//        let text = vendorName
            if let url = URL(string: urlString)
            {let activityController = UIActivityViewController(activityItems: [sendStr , url], applicationActivities: nil)
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
//        activityIndicatorView.stopAnimating()
//        activityIndicatorView.isHidden = true


    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
//        activityIndicatorView.stopAnimating()
//        activityIndicatorView.isHidden = true


    }
}
