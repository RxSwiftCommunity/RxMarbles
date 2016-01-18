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
        let operatorTableViewController = OperatorTableViewController()
        let navigationController = UINavigationController()
        navigationController.addChildViewController(operatorTableViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

