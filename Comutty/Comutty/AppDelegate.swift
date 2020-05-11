//
//  AppDelegate.swift
//  Comutty
//
//  Created by Maksim Dimitrov on 8.05.20.
//  Copyright © 2020 Maksim Dimitrov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationController = UINavigationController()

        coordinator = AppCoordinator(navigationController)
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        UIView.appearance().tintColor = .purple

        return true
    }
}
