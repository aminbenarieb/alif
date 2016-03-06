//
//  AppDelegate.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        NSLog("didFinishLaunchingWithOptions")
        
        // **** Integration *******
        
        // Fabric & Crashlytics
        Fabric.with([Crashlytics.self()])
        
        // Parse Integration
        Parse.setApplicationId("a1WVWqCPCETQsAjDIyoT7G84pTv7YhxfcFKNKlBi", clientKey: "yRzlTCdWULTft7krLyNmZ2qGVkSH3wGUM5QTiw2z")
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        // ************************
        
        
        // **** Appereance ****
        
        UILabel.appearance().font = Amin.sharedInstance.appFont(17)

        UITextField.appearance().font = Amin.sharedInstance.appFont(15)
        UITextField.appearance().backgroundColor = UIColor.clearColor()
        UITextField.appearance().layer.borderColor = UIColor.greenColor().CGColor

        UITextField.appearance().layer.borderWidth = 2.0
        UITextField.appearance().layer.cornerRadius = 3.0
        
        UINavigationBar.appearance().titleTextAttributes  = [NSFontAttributeName: Amin.sharedInstance.appFont(17), NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // *********************
        
        return true
    }

    //MARK: Parse Push Notification
    
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
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }



}

