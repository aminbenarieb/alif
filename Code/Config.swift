//
//  Config.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import Foundation
import UIKit
import Material

// MARK: - Constants

let BlueColor = 0xA3CDFF
let DarkBlueColor =  0x516D8F
let OrangeColor = 0xFBE500
let GrayColor = 0xEFEFF4
let Identifier_GoogleAnalytics = ""
let Identifier_VK = ""
let Identifier_GoogleDrive = "706417818308-bofant9bu8lfsoo7a23qi1h5hqmgqqvq.apps.googleusercontent.com"
let DeveloperMode = false

let Identifier_My_Speadsheet = "1QFLz3amkLcvUfP7abk56pmJFpioea5nTxo_foL-682Y"
let Identifier_Arabic = ""
let Identifier_English = "814005167"


// MARK: - Functions

// Localization of String
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: Amin.sharedInstance.currentLanguage(), bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}

// Random range
extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
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
    
    static func randomColor() -> UIColor {
      
        let colors = [MaterialColor.yellow.lighten3, MaterialColor.orange.lighten3, MaterialColor.green.lighten3, MaterialColor.blue.lighten3, MaterialColor.cyan.lighten3, MaterialColor.purple.lighten3, MaterialColor.pink.lighten3, MaterialColor.red.lighten3, MaterialColor.yellow.lighten3, MaterialColor.grey.lighten3]
        
        return colors[Int.random(0...(colors.count-1))]
        
    }
    
    
}

