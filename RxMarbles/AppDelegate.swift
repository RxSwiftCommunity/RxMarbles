
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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var introWindow: UIWindow?
    private var _disposeBag = DisposeBag()
    
    private let _operatorsTableViewController = OperatorsTableViewController()
    private let _splitViewController = UISplitViewController()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow()
        
        _splitViewController.delegate = self
        
        let masterNav = UINavigationController(rootViewController: _operatorsTableViewController)
        let detailNav = UINavigationController(rootViewController: OperatorViewController(rxOperator: _operatorsTableViewController.selectedOperator))
  
        if #available(iOS 11, *) {
            masterNav.navigationBar.prefersLargeTitles = true
            
        }
        
        _splitViewController.viewControllers = [masterNav, detailNav]
        
        window?.rootViewController = _splitViewController
        
        let showIntroKey = "show_intro"
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: showIntroKey) == nil {
            defaults.set(true, forKey: showIntroKey)
        }
        
        self.window?.makeKeyAndVisible()
        
        if (defaults.object(forKey: showIntroKey)! as AnyObject).boolValue == true {
            _showHelpWindow()
        } else {
            showMainWindow()
        }
        
        defaults.set(false, forKey: showIntroKey)
        defaults.synchronize()
        
        OperationQueue.main.addOperation(Operator.index)
        
        Notifications.hideHelpWindow.rx()
            .subscribe { _ in self.showMainWindow() }
            .disposed(by: _disposeBag)
        
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
        UIView.animate(withDuration: 0.5, animations: {
            self.introWindow?.alpha = 0
        }) { _ in self.window?.makeKeyAndVisible() }
    }
    
    // MARK: Shortcuts
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        focusSearch()
    }
    
    @objc func focusSearch() {
        if let nav = _splitViewController.viewControllers.first as? UINavigationController {
            nav.popToRootViewController(animated: false)
            
            
            _operatorsTableViewController.focusSearch()
        }
    }
    
    // MARK: UserActivity
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        var operatorRawValue = Operator.combineLatest.rawValue
        
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
            nav.popToRootViewController(animated: false)
            _operatorsTableViewController.presentingViewController?.dismiss(animated: false, completion: nil)
            _operatorsTableViewController.openOperator(op)
        }
        
        return false
    }
    
    // MARK: Commands
    override var keyCommands: [UIKeyCommand]? {
        let cmdF = UIKeyCommand(input: "f", modifierFlags: [.command], action: #selector(AppDelegate.focusSearch), discoverabilityTitle: "Search")
        return [cmdF]
    }
    
    
}

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        if let masterNav = splitViewController.viewControllers.first as? UINavigationController, splitViewController.isCollapsed {
            masterNav.pushViewController(vc, animated: true)
			return true
        }
        if let detailNav = splitViewController.viewControllers.last as? UINavigationController {
            detailNav.setViewControllers([vc], animated: false)
            return true
        }
        return false
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
		guard let detailNav = secondaryViewController as? UINavigationController, let masterNav = primaryViewController as? UINavigationController else { return false }
		let detailControllers = detailNav.children
		masterNav.viewControllers = masterNav.children + detailControllers
		return true
    }

    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        let navController: UINavigationController
        if let detail = primaryViewController.separateSecondaryViewController(for: splitViewController) {
            navController = UINavigationController(rootViewController: detail)
        } else {
            let op = _operatorsTableViewController.selectedOperator
            navController = UINavigationController(rootViewController: OperatorViewController(rxOperator: op))
        }
        if #available(iOS 11.0, *) {
            navController.navigationBar.prefersLargeTitles = true
        }
        return navController
    }
}
