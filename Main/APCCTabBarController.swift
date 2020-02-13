//
//  APCCTabBarController.swift
//  APCC
//
//  Created by Yusheng Xu on 2/1/20.
//  Copyright © 2020 Kulanui. All rights reserved.
//

import UIKit

class APCCTabBarController: UITabBarController {
    
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
        guestViewNavigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        guestViewNavigationController.tabBarItem.title = "Guests"
        guestViewNavigationController.tabBarItem.image = UIImage(named: "guests")

        viewControllers = [eventViewNavigationController, guestViewNavigationController, createDummyNavControllerWithTitle(title: "Discover", imageName: "discover")]
        
        


        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .themeColor
    }
    
    func fetchEmployee(){
        // load Employer data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let employer_Request = Employer_Request()
            employer_Request.getVenders{ [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let employers):
                    print(employers)
                }
            }
        }
    }
    
    func fetchEvents() {
                // load Schedule data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let schedule_Request = Schedule_Request()
            schedule_Request.getVenders{ [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let schedule):
                    print(schedule)
                }
            }
        }
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController{
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
