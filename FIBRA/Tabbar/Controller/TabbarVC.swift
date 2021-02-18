//
//  TabbarVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var currentIndex = 1
    lazy var vc1: UINavigationController = {
        let vc = ReciptVC.instantiate(fromAppStoryboard: .Tabbar)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem.title = "My Receipts"
        nvc.tabBarItem.image = UIImage(named: "receiptGray")
        nvc.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -6, right: 0);

        nvc.setUpAttributes()
        return nvc
    }()
    
    lazy var vc2: UINavigationController = {
        let vc = QRCodeVC.instantiate(fromAppStoryboard: .Tabbar)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem.title = "My Code"
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "YellowColor")], for: .selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        
        nvc.setUpAttributes()
        return nvc
    }()
    
    lazy var vc3: UINavigationController = {
        let vc = MyProfileVC.instantiate(fromAppStoryboard: .Tabbar)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem.title = "My Profile"
        nvc.tabBarItem.image = UIImage(named: "profileGray")
        nvc.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -6, right: 0);

        nvc.setUpAttributes()
        return nvc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.red, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)

        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2

        viewControllers = [vc1, vc2, vc3]
        selectedIndex = currentIndex
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        tabBar.tintColor = UIColor.init(named: "Base")
        setupMiddleButton()

    }
}

extension TabbarVC {
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = -32
        menuButtonFrame.origin.x = ((view.bounds.width/2 - menuButtonFrame.size.width/2))
        menuButton.frame = menuButtonFrame
        menuButton.backgroundColor = UIColor(named: "YellowColor")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.layer.shadowColor = UIColor.black.cgColor
        menuButton.layer.shadowRadius = 3
        menuButton.layer.shadowOpacity = 0.6
        menuButton.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        tabBar.addSubview(menuButton)
        menuButton.setImage(UIImage(named: "myCode"), for: .normal)
        menuButton.tintColor = UIColor.white
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
        
    }
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
//    {
//        if tabBarController.selectedIndex == 1
//        {
//            tabBarController.navigationController?.popToRootViewController(animated: false)
//        }
//    }
    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 1
        
        
        
    }
    
}
