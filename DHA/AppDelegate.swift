////
////  AppDelegate.swift
////  DHA
////
////  Created by Yaser Abdulrahman on 1/22/19.
////  Copyright Â© 2019 YaserAbdulrahman. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
//import UserNotifications
//
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        FirebaseApp.configure()
//        //var rootViewController = self.window!.rootViewController
//
//        let isUserLoggedIn:Int = UserDefaults.standard.integer(forKey: "isUserLoggedIn")
//        switch isUserLoggedIn {
//        case 3:
//            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
//            let protectedPage = mainStoryboard.instantiateViewController(withIdentifier: "PatientHomeTabBarViewController")
//            window!.rootViewController = protectedPage
//            window!.makeKeyAndVisible()
//        case 2:
//            print("Yaser")
//        case 1:
//            print("Yaser")
//        default:
//            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
//            let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginpage")
//            window!.rootViewController = loginViewController
//            window!.makeKeyAndVisible()
//        }
//
//        if #available(iOS 10, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in })
//            application.registerForRemoteNotifications()
//        }
//        else
//        {
//            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//        window?.tintColor = UIColor(red: 8/255, green: 179/255, blue: 230/255, alpha: 1)
//
//        return true
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//
//
//}

//
//  AppDelegate.swift
//  DHA
//
//  Created by Yaser Abdulrahman on 1/22/19.
//  Copyright © 2019 YaserAbdulrahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // var rootViewController = self.window!.rootViewController

        let isUserLoggedIn:Int = UserDefaults.standard.integer(forKey: "isUserLoggedIn")
        print("Access:")
        print(isUserLoggedIn)
        switch isUserLoggedIn {
        case 3:
            print(">> Access: Patient")
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let protectedPage = mainStoryboard.instantiateViewController(withIdentifier: "PatientHomeTabBarViewController")
            window!.rootViewController = protectedPage
            window!.makeKeyAndVisible()
        case 2:
            print(">> Access: Nurse")
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let protectedPage2 = mainStoryboard.instantiateViewController(withIdentifier: "successfullyLoggedinNurse")
            window!.rootViewController = protectedPage2
            window!.makeKeyAndVisible()
        case 1:
            print(">> Access: Admin")
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let protectedPage3 = mainStoryboard.instantiateViewController(withIdentifier: "successfullyLoggedinAdmin")
            window!.rootViewController = protectedPage3
            window!.makeKeyAndVisible()
        default:
            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
            let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginpage")
            window!.rootViewController = loginViewController
            window!.makeKeyAndVisible()
        }

        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in })
            application.registerForRemoteNotifications()
        }
        else
        {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        window?.tintColor = UIColor(red: 8/255, green: 179/255, blue: 230/255, alpha: 1)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
