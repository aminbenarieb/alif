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

var imageCache = [String : UIImage]()

import Foundation
import SystemConfiguration

private let _AminSharedInstance = Amin()


class Amin {
    class var sharedInstance: Amin {
        return _AminSharedInstance
    }
    
    /** Showing alert message
    - parameter String: title
    - parameter String: message
    */
    func showMessage(title: String, message: String) -> Void
    {
        if let alertView = JTAlertView(title: title, andImage: UIImage(named: "bg.jpg"))
        {
            alertView.size = CGSizeMake(280, 230);

            alertView.addButtonWithTitle("OK", style: .Default, action: { (alertview: JTAlertView!) in
                
                alertview.hide()
                
            })
            
            alertView.show()
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
    func parseJSONFromData(inputData: NSData) -> NSDictionary{

        let boardsDictionary : NSDictionary
        
        do {
            boardsDictionary = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        }
        catch let error as NSError
        {
            boardsDictionary = [:]
            print("Unexpected error: \(error.localizedDescription). ");
        }
        
        return boardsDictionary
    }
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
    Return all avialible fonts
    - returns: String language key.
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
    
    func appFont(size : Int) -> UIFont
    {
        
        return UIFont(name: "JF Flat", size: 17) ?? UIFont.systemFontOfSize(17);
    }
    
}