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
        UserDefaults.standard.set(false, forKey: "loginKey")
        UserDefaults.standard.synchronize()
        logout()
        let vc = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
        let navigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    func logout(){
        var task:URLSessionDataTask?
        let url = "http://fibraapi.imedhealth.us/api/\(ApiMethods.removeFcmToken.rawValue)"
        let urlString = URL(string: url)
        
    
        var request = URLRequest(url: urlString!)
        
        request.httpMethod = "POST"
        

        request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        
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
                            LoginData.shared.removeData()
                        }
                        print("Status code \(jsonData)")
                        print("Token Deleted Successfully")
                    }
                }
            }
            catch{
                print("Error")
            }
            
        }
        task?.resume()
    }
    
    @IBAction func onNo(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
     
        print("hhhhhh")
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
