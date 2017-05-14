//
//  AppDelegate.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/24/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container = Container() { container in
        container.register(APIManager.self) {_ in APIManager()}
        container.register(MatchsViewModelFromMatchs.self) { r in
            MatchsViewModelFromMatchs(apiManager: r.resolve(APIManager.self)!)
        }
        container.storyboardInitCompleted(MatchsController.self) { r, c in
            //c.apiManager = r.resolve(APIManager.self)!
            c.viewModel = r.resolve(MatchsViewModelFromMatchs.self)
        }
        container.storyboardInitCompleted(MatchCastController.self) { r, c in
            c.apiManager = r.resolve(APIManager.self)!
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let bundle = Bundle(for: MatchsController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.saveData), object: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

