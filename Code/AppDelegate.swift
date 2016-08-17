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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        NSLog("didFinishLaunchingWithOptions")
        
        
        // **** Preloading database *******
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("databaseIsPreloaded")
        if !isPreloaded {
            removeData()
            preloadData()
//            defaults.setBool(true, forKey: "databaseIsPreloaded")
        }
        
        // **** Integration *******
        
        // Fabric & Crashlytics
        Fabric.with([Crashlytics.self()])
        
        
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
                //processs launch options
            }
        }
        
        // Google Analytics
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        if let configureError = configureError
        {
            print("Error configuring Google services: \(configureError)")
            GAI.sharedInstance().trackerWithTrackingId(Identifier_GoogleAnalytics)
        }
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
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

    //MARK: Push Notification workflow
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        // saving device tokens
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        //handle remote notification
        
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.Alif" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Alif", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Alif.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Pleloading data
    
    func preloadData () {
        
        if let dataInfo = LoadManager.sharedInstance.JSONFromFile("data") {
        
            if let items = dataInfo["data"] as? NSArray {

                // Preload the menu items
                for item in items {

                    if let topicInfo = item as? NSDictionary
                    {
                        let topic = NSEntityDescription.insertNewObjectForEntityForName("Topic", inManagedObjectContext: managedObjectContext) as! Topic

                        if let name = topicInfo["topic"] as? String
                        {
                            topic.name = name
                        }
                        if let slides = topicInfo["slides"] as? NSArray
                        {
                            let slidesData = NSKeyedArchiver.archivedDataWithRootObject(slides)
                            topic.slides = slidesData
                        }
                        if let train_dictionary = topicInfo["train_dictionary"] as? NSDictionary
                        {
                            let trainDictionary = NSKeyedArchiver.archivedDataWithRootObject(train_dictionary)
                            topic.train_dictionary = trainDictionary
                        }
                        
                        do
                        {
                            try managedObjectContext.save()
                        }
                        catch let error as NSError
                        {
                            Amin.sharedInstance.showInfoMessage(error.localizedDescription)
                        }

                    }
                }
            }
        }
        
    }
    
    func removeData () {
        // Remove the existing items
        let fetchRequest = NSFetchRequest(entityName: "Topic")
        
        do {
            let topics = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Topic]
            for topic in topics {
                managedObjectContext.deleteObject(topic)
            }
        } catch  {
            print(error)
        }
        
    }


}

