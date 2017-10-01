//
//  AppDelegate.swift
//  whattowear
//
//  Created by Brendan Lensink on 2017-09-23.
//  Copyright © 2017 wsiw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let mainViewController = MainViewController()
        window!.rootViewController = mainViewController
        window!.makeKeyAndVisible()

        return true
    }
}

