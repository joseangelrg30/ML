//
//  AppDelegate.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Returns a coordinator instance to be used for the app's entry point.
    private lazy var appCoordinator: AppCoordinator = {
        let navController = UINavigationController()
        navController.isNavigationBarHidden = false
        navController.navigationBar.prefersLargeTitles = true
        return AppCoordinator(navigationController: navController)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launchApp(with: launchOptions)
        return true
    }

}

// MARK: - App Launch
private extension AppDelegate {
    func launchApp(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        appCoordinator.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
}
