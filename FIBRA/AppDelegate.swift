//
//  AppDelegate.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//
import UIKit
import SVProgressHUD
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotifications()
        
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setDefaultAnimationType(.flat)
        return true
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        
        print(notification.request.content.userInfo)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // notification
        
        let info = response.notification.request.content.userInfo
        
        var transactionId = 0
        if let notificationData = info[AnyHashable("transactionId")] as? String{
            print(notificationData)
            transactionId = Int(notificationData)!
        }
        
        if let topNavController = self.window?.rootViewController as? UINavigationController {
             
            
            let sb = UIStoryboard(name: "Authentication", bundle: nil)
            if #available(iOS 13.0, *) {
                let splashVC = sb.instantiateViewController(identifier: "SplashViewController") as! SplashViewController
                
               splashVC.isFromNotification = true
                
                let tsb = UIStoryboard(name: "Tabbar", bundle: nil)

//                let presentedVC = tsb.instantiateViewController(identifier: "TabbarVC") as! TabbarVC
//                       presentedVC.selectedIndex = 0

                if let topVC = UIApplication.getTopViewController()
                {
                    topVC.tabBarController?.selectedIndex = 0

                    let vc1 = topVC.tabBarController?.selectedViewController as! UINavigationController
                    
                    let reciptVC = tsb.instantiateViewController(identifier: "ReciptVC") as! ReciptVC
                                   reciptVC.transactionId = transactionId
                                   reciptVC.getImageIndex(transactionId:transactionId)
                    
                    vc1.popToRootViewController(animated: false)
                    vc1.pushViewController(reciptVC, animated: false)

                    
                   // topVC.navigationController?.pushViewController(vc1!, animated: false)
//                    topVC.navigationController?.popToRootViewController(animated: false)
//
//                    topVC.navigationController?.pushViewController(reciptVC, animated: false    )
                }
            } else {
                // Fallback on earlier versions
            }
           
            
            
        }
        completionHandler()
    }
}

public extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        print("getTopViewController")

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


// Register push notification
extension AppDelegate {
    func registerForPushNotifications() {
        
        print("registerForPushNotifications")
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    
                }
            }
        }
        
    }
}

// Message Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("didReceiveRegistrationToken")

        if fcmToken != "" {
            print("FCM Token: \(fcmToken)")
            UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
            UserDefaults.standard.synchronize()
            #if Debug
            Messaging.messaging().subscribe(toTopic: "TestDevices") { (error) in
                if error == nil {
                    print("subscribed to topic.")
                }
            }
            #endif
        }
    }
}
