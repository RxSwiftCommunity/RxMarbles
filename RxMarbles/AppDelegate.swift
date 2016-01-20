//
//  AppDelegate.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let splitViewController = UISplitViewController()
            
            let rootViewController = OperatorTableViewController()
            
            let detailViewController = ViewController()
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            
            let navDetailController = UINavigationController(rootViewController: detailViewController)
            splitViewController.viewControllers = [rootViewController, navDetailController]
            splitViewController.delegate = detailViewController
            
            window?.rootViewController = splitViewController
        } else {
            let operatorTableViewController = OperatorTableViewController()
            
            let navigationContoller = UINavigationController(rootViewController: operatorTableViewController)
            window?.rootViewController = navigationContoller
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

