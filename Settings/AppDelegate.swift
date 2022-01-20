//
//  AppDelegate.swift
//  Settings
//
//  Created by Sergey Vishnyov on 20.01.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let vc = SettingsViewController.loadFromNib()
        let nav = UINavigationController.init(rootViewController: vc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        return true
    }


}

