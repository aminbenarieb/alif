//
//  Word.swift
//  Alif
//
//  Created by Amin Benarieb on 14/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation

enum MemorizeType : Int {
    case Zero = 1
    case Querter = 2
    case Half = 3
    case ThreeQuarter = 4
    case Full = 5
}



class Word : NSObject
{
    internal var target : NSString = ""
    internal var meaning : NSString = ""
    internal var memorize : MemorizeType = .Zero
    
    init(target : NSString, meaning : NSString, memorize : MemorizeType) {
        
        self.target = target
        self.meaning = meaning
        self.memorize = memorize
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.target = aDecoder.decodeObjectForKey("target") as! String
        self.meaning = aDecoder.decodeObjectForKey("meaning") as! String
        self.memorize =  MemorizeType(rawValue: aDecoder.decodeObjectForKey("memorize") as! Int )!
        
    }
    
    func encodeWithCoder(aCoder : NSCoder)
    {
        aCoder.encodeObject(self.target, forKey: "target")
        aCoder.encodeObject(self.meaning, forKey: "meaning")
        aCoder.encodeObject(self.memorize.rawValue, forKey: "memorize")
    }
    
    override var description: String {
        get {
            return ("\(self.target), \(self.meaning), \(self.memorize.rawValue)")
        }
    }
    
    func levelUp(){
        
        switch (self.memorize)
        {
        case .Zero:
            self.memorize = .Querter
            break;
        case .Querter:
            self.memorize = .Half
            break;
        case .Half:
            self.memorize = .ThreeQuarter
            break;
        case .ThreeQuarter:
            self.memorize = .Full
            break;
            
        default:
            break;
        }
    }
    
    
}