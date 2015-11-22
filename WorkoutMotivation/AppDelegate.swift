//
//  AppDelegate.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/13/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId("8HWVCwLAEWaLHmXBQ9hKl77YhmfHKPAoiZFJM4Ds", clientKey:"LbugyjO6Pr2GPM5m4JexSCahNMG5e4qjFBq85Yec")
//        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound)
//        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
         PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
         return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }

    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        if let userID = PFUser.currentUser()?.objectId  {
            installation["user"] = userID
        }
        
        installation.saveInBackground()
    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        if error.code == 3010 {
//            println("Push notifications are not supported in the iOS Simulator.")
//        } else {
//            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
//             println(error.localizedDescription)
//        }
//    }
//    
//    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        PFPush.handlePush(userInfo)
//    }
//    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
 
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

