//
//  AppDelegate.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow()
        
        let splitViewController = UISplitViewController()
        splitViewController.delegate = self
        
        let masterNav = UINavigationController(rootViewController: OperatorsTableViewController())
        let detailNav = UINavigationController(rootViewController: ViewController())
        
        
        
        splitViewController.viewControllers = [masterNav, detailNav]
        
        window?.rootViewController = splitViewController
        
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UserActivity
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
            return true
    }
    
    // MARK: UISplitViewControllerDelegate
    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
      
        if splitViewController.collapsed {
            if let masterNav = splitViewController.viewControllers.first as? UINavigationController {
                masterNav.pushViewController(vc, animated: true)
                return true
            }
        }
        
        if let detailNav = splitViewController.viewControllers.last as? UINavigationController {
            detailNav.setViewControllers([vc], animated: false)
            return true
        }
        
        return false
    }
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        if let detail = primaryViewController.separateSecondaryViewControllerForSplitViewController(splitViewController) {
            return UINavigationController(rootViewController: detail)
        } else {
            return nil
        }
    }
}

