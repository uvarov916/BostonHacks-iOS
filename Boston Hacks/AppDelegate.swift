//
//  AppDelegate.swift
//  Boston Hacks
//
//  Created by Иван Уваров on 10/10/15.
//  Copyright © 2015 Ivan Uvarov. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: VARIABLES
    
    var window: UIWindow?
    
    // MARK: INITIALIZATION

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize Parse
        Parse.setApplicationId("TpddRNEVg1gw0BJmle7yrRgiLYqAbLLJQN1mJTDC",
            clientKey: "GKgjTZIeq6BsNKUFLAlqGUbpSwHs0RNPeWPoC6w5")
        
        // Register for push notifications
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        // Set up the nav and tab bar colors
        self.customizeUserInterface()
        
        // Handle push notification
        if application.applicationState != .Background {
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = (options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil)
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
                
                goToAnnouncementsScreen()
            }
        }
        
        return true
    }
    
    // MARK: PUSH NOTIFICATIONS
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if (application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Inactive) {
            if self.window!.rootViewController as? UITabBarController != nil {
                let tababarController = self.window!.rootViewController as! UITabBarController
                tababarController.selectedIndex = 0
            }
        } else {
            PFPush.handlePush(userInfo)
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func goToAnnouncementsScreen() {
        if self.window!.rootViewController as? UITabBarController != nil {
            let tababarController = self.window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 0
        }
    }
    
    // MARK: CUSTOMIZATION
    
    func customizeUserInterface() {
        // Styles for Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 233/255.0, green: 31/255.0, blue: 99/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // Styles for Tab Bar
        UITabBar.appearance().barTintColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 42/255.0, alpha: 1.0)
        UITabBar.appearance().translucent = false
        UITabBar.appearance().tintColor = UIColor(red: 233/255.0, green: 31/255.0, blue: 99/255.0, alpha: 1.0)
    }
}