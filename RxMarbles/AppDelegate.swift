//
//  AppDelegate.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import CoreSpotlight

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
        NSOperationQueue.mainQueue().addOperationWithBlock {
            Operator.index()
        }
        return true
    }

    // MARK: UserActivity
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
     
        var operatorRawValue = Operator.Delay.rawValue
        // NSUserActivity
        if let _ = UserActivityType(rawValue: userActivity.activityType),
            let opRawValue = userActivity.userInfo?["operator"] as? String {
            operatorRawValue = opRawValue
        // Spotlite index
        } else if userActivity.activityType == CSSearchableItemActionType,
            let opRawValue = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            operatorRawValue = opRawValue
        }
        if let op = Operator(rawValue: operatorRawValue),
            let splitViewController = window?.rootViewController as? UISplitViewController,
            let masterNav = splitViewController.viewControllers.first as? UINavigationController,
            let operatorsController = masterNav.viewControllers.first as? OperatorsTableViewController {
                operatorsController.selectedOperator = op
                return true
        }
        return false
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
    
   
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        if let detailNav = secondaryViewController as? UINavigationController,
           let masterNav = primaryViewController as? UINavigationController {
            let detailControllers = detailNav.childViewControllers
            masterNav.viewControllers = masterNav.childViewControllers + detailControllers
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

