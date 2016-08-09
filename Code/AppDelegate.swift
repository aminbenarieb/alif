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
        
        
        // **** Preloading database *******
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("databaseIsPreloaded")
        if !isPreloaded {
            preloadData()
//            defaults.setBool(true, forKey: "databaseIsPreloaded")
        }
        
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
    
    // MARK: - CSV Parser Methods
    
    func parseCSV (contentsOfURL: NSURL, encoding: NSStringEncoding, error: NSErrorPointer) -> [(name:String, content:NSData, difficulty: String, passed: String)]? {

        let delimiter = "\t"
        var items:[(name:String, content:NSData, difficulty: String, passed: String)]? = []
        
        do
        {
            let content =  try String(contentsOfURL: contentsOfURL, encoding: encoding)
            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.rangeOfString("\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:NSScanner = NSScanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpToString("\"", intoString: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpToString(delimiter, intoString: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.characters.count {
                                textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = NSScanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.componentsSeparatedByString(delimiter)
                    }
                    
                    // Parsing array for slides
                    let contentArray = values[1].componentsSeparatedByString(",")
                    let contentData = NSKeyedArchiver.archivedDataWithRootObject(contentArray)
                    
                    // Put the values into the tuple and add it to the items array
                    let item = (name: values[0], content: contentData, difficulty: values[2], passed: "0")
                    items?.append(item)
                }
            }
        }
        catch let error as NSError
        {
            Amin.sharedInstance.showInfoMessage(error.localizedDescription)
        }
        
        return items
    }
    
    func preloadData () {
        
        // Get a filr url
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("Alif", withExtension: "csv") {
            
            // Remove all the menu items before preloading
            removeData()
            
            var error:NSError?
            
            
            if let items = parseCSV(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error) {
                // Preload the menu items

                for item in items {
                    let topic = NSEntityDescription.insertNewObjectForEntityForName("Topic", inManagedObjectContext: managedObjectContext) as! Topic
                    topic.name = item.name
                    topic.content = item.content
                    topic.difficulty = (item.difficulty as NSString).floatValue
                    topic.passed = (item.passed as NSString).floatValue
                    
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
            else 
            {
                Amin.sharedInstance.showInfoMessage(error!.localizedDescription)
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

