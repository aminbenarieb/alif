//
//  LoadManager.swift
//  Alif
//
//  Created by Amin Benarieb on 12/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation

private let _LoadManagerSharedInstance = LoadManager()

class LoadManager
{
    
    class var sharedInstance: LoadManager {
        return _LoadManagerSharedInstance
    }
    
    /** Download and return data form url
     - parameter URL: source url
     - returns: NSData data with info
     */
    func dataFromURL(URL: NSURL) -> NSData?{
        return NSData(contentsOfURL:URL)
    }
    
    /** Return dictonary of json form data
     - parameter NSData: data to parse
     - returns: NSDictionary object with json
     */
     func JSONFromData(inputData: NSData) -> NSDictionary{
 
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
}