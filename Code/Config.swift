//
//  Config.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants

let BlueColor = 0xA3CDFF
let DarkBlueColor =  0x516D8F
let OrangeColor = 0xFBE500
let GrayColor = 0xEFEFF4
let Identifier_GoogleAnalytics = ""
let Identifier_VK = ""
let Identifier_GoogleDrive = "706417818308-bofant9bu8lfsoo7a23qi1h5hqmgqqvq.apps.googleusercontent.com"
let DeveloperMode = false


// MARK: - Functions

// Localization of String
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: Amin.sharedInstance.currentLanguage(), bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}

// Check iOS version
func iOS(version: Float) -> Bool {
    
    return (UIDevice.currentDevice().systemVersion as NSString).floatValue >= version
    
}

// Color with hex
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

