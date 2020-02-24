//
//  APCCTabBarController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class APCCTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let eventViewController = EventViewController()
        let eventViewNavigationController = UINavigationController(rootViewController: eventViewController)
        eventViewNavigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        eventViewNavigationController.tabBarItem.title = "Calendar"
        eventViewNavigationController.tabBarItem.image = UIImage(named: "calendar")
        
        
        let guestViewController = GuestViewController()
        let guestViewNavigationController = UINavigationController(rootViewController: guestViewController)
        guestViewNavigationController.navigationBar.prefersLargeTitles = true
        guestViewNavigationController.tabBarItem.title = "Guests"
        guestViewNavigationController.tabBarItem.image = UIImage(named: "guests")
        
        let discoverViewController = DiscoverViewController()
        //let discoverViewNavigationController = UINavigationController(rootViewController: discoverViewController)
//        discoverViewNavigationController.tabBarItem.title = "Discover"
//        discoverViewNavigationController.tabBarItem.image = UIImage(named: "discover")
        //discoverViewNavigationController.navigationBar.prefersLargeTitles = true
        discoverViewController.tabBarItem.title = "Discover"
        discoverViewController.tabBarItem.image = UIImage(named: "discover")
        viewControllers = [eventViewNavigationController, guestViewNavigationController,discoverViewController]
        
        
        delegate = self

        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .themeColor
    }
    //MARK: Properties
    
    func tabBarController(_ tabBarController: UITabBarController,shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController === viewController{
            //let handler = viewController as? TabBarReselectHandling {
            // NOTE: viewController in line above might be a UINavigationController,
            // in which case you need to access its contents
            guard let navigationController = viewController as? UINavigationController else { return true }
            guard navigationController.viewControllers.count <= 1, let handler = navigationController.viewControllers.first as? TabBarReselectHandling else { return true }
            
            handler.handleReselect()
        }

        return true
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController{
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}

protocol TabBarReselectHandling {
    func handleReselect()
}
