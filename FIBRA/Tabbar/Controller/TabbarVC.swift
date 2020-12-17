//
//  TabbarVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    lazy var vc1: UINavigationController = {
        let vc = ReciptVC.instantiate(fromAppStoryboard: .Tabbar)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem.title = "My Receipts"
        nvc.tabBarItem.image = UIImage(named: "receiptGray")
        nvc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);

        nvc.setUpAttributes()
        return nvc
    }()
    
    lazy var vc2: UINavigationController = {
        let vc = QRCodeVC.instantiate(fromAppStoryboard: .Tabbar)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem.title = "My Code"
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        

        nvc.setUpAttributes()
        return nvc
    }()
    
    lazy var vc3: UINavigationController = {
        let vc = MyProfileVC.instantiate(fromAppStoryboard: .Tabbar)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.tabBarItem.title = "My Profile"
        nvc.tabBarItem.image = UIImage(named: "profileGray")
        nvc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0);

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
        selectedIndex = 1
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
        menuButtonFrame.origin.y = -31
        menuButtonFrame.origin.x = ((view.bounds.width/2 - menuButtonFrame.size.width/2)+0.5)
        menuButton.frame = menuButtonFrame
        menuButton.backgroundColor = UIColor(named: "YellowColor")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        tabBar.addSubview(menuButton)
        menuButton.setImage(UIImage(named: "myCode"), for: .normal)
        menuButton.tintColor = UIColor.white
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
    }

    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 1
    }
    
}
