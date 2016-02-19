//
//  AppDelegate.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import CoreSpotlight
import Fabric
import Crashlytics
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var introWindow: UIWindow?
    private var _disposeBag = DisposeBag()
    
    private let _operatorsTableViewController = OperatorsTableViewController()
    private let _splitViewController = UISplitViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow()
        
        _splitViewController.delegate = self
        
        let masterNav = UINavigationController(rootViewController: _operatorsTableViewController)
        let detailNav = UINavigationController(rootViewController: OperatorViewController(rxOperator: _operatorsTableViewController.selectedOperator))
        
        _splitViewController.viewControllers = [masterNav, detailNav]
        
        window?.rootViewController = _splitViewController
       
        let showIntroKey = "show_intro"
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey(showIntroKey) == nil {
            defaults.setObject(true, forKey: showIntroKey)
        }
        
        self.window?.makeKeyAndVisible()
        
        _showHelpWindow()
        
//        if defaults.objectForKey(showIntroKey)?.boolValue == true {
//            _showHelpWindow()
//        } else {
//            showMainWindow()
//        }
        
        defaults.setObject(false, forKey: showIntroKey)
        defaults.synchronize()
        
        NSOperationQueue.mainQueue().addOperationWithBlock(Operator.index)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.rx_notification(Names.hideHelpWindow).subscribeNext { notification in
            self.showMainWindow()
        }.addDisposableTo(_disposeBag)
        
        return true
    }
    
    private func _showHelpWindow() {
        introWindow = UIWindow()
        let helpViewController = HelpViewController()
        helpViewController.helpMode = false
        introWindow?.rootViewController = helpViewController
        introWindow?.makeKeyAndVisible()
    }
    
    func showMainWindow() {
        UIView.animateWithDuration(0.5) {
            self.introWindow?.alpha = 0
        }
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
            let op = _operatorsTableViewController.selectedOperator
            return UINavigationController(rootViewController: OperatorViewController(rxOperator: op))
        }
    }
   
    // MARK: Shortcuts
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if let nav = _splitViewController.viewControllers.first as? UINavigationController {
            nav.popToRootViewControllerAnimated(false)
            
            _operatorsTableViewController.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
            
            _operatorsTableViewController.focusSearch()
        }
    }
    
    // MARK: UserActivity
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
     
        var operatorRawValue = Operator.CombineLatest.rawValue
        
        // NSUserActivity
        if let _ = UserActivityType(rawValue: userActivity.activityType),
            let opRawValue = userActivity.userInfo?["operator"] as? String {
            operatorRawValue = opRawValue
        // Spotlite index
        } else if userActivity.activityType == CSSearchableItemActionType,
            let opRawValue = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            operatorRawValue = opRawValue
        }
        if  let op = Operator(rawValue: operatorRawValue),
            let nav = _splitViewController.viewControllers.first as? UINavigationController {
            nav.popToRootViewControllerAnimated(false)
            _operatorsTableViewController.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
            _operatorsTableViewController.openOperator(op)
        }
        
        return false
    }
    
}

