//
//  Amin.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit
import JTAlertView
import JTFadingInfoView
import ZAlertView
import Parse


import Foundation
import SystemConfiguration
import Parse

private let _AminSharedInstance = Amin()

class Amin {
    
    class var sharedInstance: Amin {
        return _AminSharedInstance
    }
    
    /** Registed Push Notification 
    */
    func registerPushNotification() -> Void
    {
        let application = UIApplication.sharedApplication()
        let userNotificationTypes : UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    
    /** Showing ZAlertView
     - parameter String: title
     - parameter String: message
     */
    func showZAlertView(title: String, message: String) -> Void
    {
//        ZAlertView(title: <#T##String?#>, message: <#T##String?#>, closeButtonText: <#T##String?#>, closeButtonHandler: <#T##TouchHandler?##TouchHandler?##(ZAlertView) -> ()#>)
//        ZAlertView(title: <#T##String?#>, message: <#T##String?#>, isOkButtonLeft: <#T##Bool?#>, okButtonText: <#T##String?#>, cancelButtonText: <#T##String?#>, okButtonHandler: <#T##TouchHandler?##TouchHandler?##(ZAlertView) -> ()#>, cancelButtonHandler: <#T##TouchHandler?##TouchHandler?##(ZAlertView) -> ()#>)
//        ZAlertView(title: <#T##String?#>, message: <#T##String?#>, okButtonText: <#T##String?#>, cancelButtonText: <#T##String?#>)
        
        let dialog = ZAlertView(title: title, message: message, closeButtonText: "Close") { (alert : ZAlertView) -> () in
            alert.dismiss()
        }
        dialog.show()
        
    }
    
    /** Showing info message view
     - parameter String: message
     */
    func showInfoMessage(message: String) -> Void
    {
        if let view = UIApplication.sharedApplication().keyWindow
        {
            let infoViewSize = CGSizeMake(150,50)
            let infoViewRect = CGRectMake((view.frame.width-infoViewSize.width)/2, view.frame.height-(infoViewSize.height+50), infoViewSize.width, infoViewSize.height)
            
            let infoView = JTFadingInfoView(frame: infoViewRect, label: message)
            infoView.appearingDuration = 0.2
            infoView.displayDuration = 1.5
            infoView.fadeInDirection = JTFadeInDirectionFromBelow
            infoView.fadeOutDirection = JTFadeOutDirectionToBelow
            
            view.addSubview(infoView)
        }
        
    }
    
    /** Return formatted date
    - parameter String: string with date
    - parameter String: string with format
    - returns: date with format
    */
    func converntDate(date:String, format:String) -> NSDate{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format;
        
        return dateFormatter.dateFromString(date)!
    }
    
    /** Download and return data form url
    - parameter URL: source url
    - returns: NSData data with info
    */
    func getDataFromURL(URL: NSURL) -> NSData?{
        return NSData(contentsOfURL:URL)
    }
    
    /** Return dictonary of json form data
    - parameter NSData: data to parse
    - returns: NSDictionary object with json
    */
//    func parseJSONFromData(inputData: NSData) -> NSDictionary{
//
//        let boardsDictionary : NSDictionary
     
//        do {
//            boardsDictionary = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//        }
//        catch let error as NSError
//        {
//            boardsDictionary = [:]
//            print("Unexpected error: \(error.localizedDescription). ");
//        }
        
//        return boardsDictionary
//    }
    /** Creates Download image form url
    - warning: This function is not testes
    - parameter NSURL: source url
    - parameter completion: block to perform
    */
    func downloadImageWithURL(url : NSURL, completion: (succeeded : Bool, image : UIImage?) -> Void)
    {
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue.mainQueue(), completionHandler: {(response : NSURLResponse?, data : NSData?, error : NSError?) in
            
            completion(succeeded: (error) != nil, image: UIImage(data: data!))
        })
    }
    
    /**
    Return current app version
    - returns: AnyObject version info.
    */
    func appVersion() -> AnyObject
    {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!
    }
    
    /**
    Return current build information
    - returns: AnyObject build info.
    */
    func build()  -> AnyObject
    {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String)!
    }
    
    /**
    Return language key from NSUserDefaults
    - returns: String language key.
    */
    func currentLanguage()  -> String
    {
        return "en"
    }
    
    /**
    Print all avialible fonts
    */
    func allFonts(){
        for family in UIFont.familyNames(){
            print(family)
            for name in UIFont.fontNamesForFamilyName(family)
            {
                print("  \(name)")
            }
        }
    }
    
    /**
     Return JF Flat font with given size
     - parameter Int: size of font
     - returns: UIFont font
     */
    func appFont(size : Int) -> UIFont
    {
        
        return UIFont(name: "JF Flat", size: 17) ?? UIFont.systemFontOfSize(17);
    }
    /**
     Return download link for speadsheet
     - parameter String: identifier of speadsheet
     - parameter String: gid of worksheet in speadsheet
     - returns: String link
     */
    func spreadSheetLinkUrl(identifier : String, gid : String) -> String!
    {
        
        var link = "https://docs.google.com/spreadsheets/d/\(identifier)/export?format=csv"
        
        if (gid != "")
        {
            link.appendContentsOf("&gid=\(gid)")
        }
        
        return link
        
    }
    
    
    
    
}