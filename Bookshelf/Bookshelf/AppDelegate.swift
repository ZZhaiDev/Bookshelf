//
//  AppDelegate.swift
//  Bookshelf
//
//  Created by zijia on 10/11/19.
//  Copyright © 2019 zijia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        defaultUINavigationBar()
        return true
    }
    
    func defaultUINavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
        UINavigationBar.appearance().shadowImage = nil
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .lightRed
//        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    


}

