//
//  VocabluaryInstance.swift
//  Alif
//
//  Created by Amin Benarieb on 11/03/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation


private let vTourWordCount = 10

private let _VocabluarySharedInstance = Vocabluary()


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

    func levelUp()
    {
        
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

struct Result
{
    var title : String
    var message : String
    var procent : Int
}

struct Topic
{
    var name : String
    var identifier : String
    var words : [Word]
}


class Vocabluary
{
    
    class var sharedInstance: Vocabluary {
        return _VocabluarySharedInstance
    }
    
    internal var targetMode = true
    internal var trainMode = true
    
    
    var topic : Topic = Topic(name: "Undefined", identifier:"Undefined", words: [Word]())
    var wordList = [Word]()
    var wordListIndex = 0
    var step : Int = 1
    var rightAnswerCount = 0
    var result : Result = Result(title: "Undefined", message: "Undefined", procent: 0)
    var image : UIImage = UIImage()
    
    /*   NON-DOCUMENTED FUNCTIONS   */
    
    
    func setUpTour(topicDict : Dictionary<String, AnyObject>)
    {
        
        if let topicName = topicDict["name"] as? String
        {
            topic.name = topicName
        }
        if let topicName = topicDict["identifier"] as? String
        {
            topic.identifier = topicName
        }
        if let topicWordsArchive = topicDict["words"] as? NSData
        {
            if let topicWords = NSKeyedUnarchiver.unarchiveObjectWithData(topicWordsArchive) as? [Word]
            {
                topic.words = topicWords
            }
        }
        
         for (var i = 0; i < min(10, topic.words.count); i++)
         {
            let word = topic.words[i]
            if word.memorize != .Full
            {
                wordList.append(word)
            }
         }
        
    }
    
    func getCurrentWord() -> Word
    {
        return wordList[wordListIndex-1]
    }
    
    /********************************/
    
    //WARNING : METHOD STUB
    /** Get list of four words
    - warning: This function is not testes
    */
    func getProposalList() -> [String]
    {
        return ["Ring", "Window", "Word", "Key"]
    }
    
    //WARNING : METHOD STUB
    /** Get next word from tour word list
    - warning: This function is not testes
    */
    func getNextWord() -> Word
    {
        return wordList[wordListIndex++]
    }
    
    /** Get progress bar value
     - return: CGFloat procent value for progress bar
     */
    func getProgressValue() -> CGFloat
    {
        return CGFloat(step)/CGFloat(vTourWordCount)*100
    }
    
    
    func checkWord(givenWord : String?) -> Bool
    {
        step += 1
        
        var flag = false
        if let word = givenWord
        {
            flag = word == wordList[wordListIndex-1].meaning
            if (flag)
            {
                rightAnswerCount++
                wordList[wordListIndex-1].levelUp()
            }
        }
        
        return flag
    }
    
    /** Return flag if tour is finished
     - return: Bool flag
     */
    func isFinished() -> Bool
    {
        let finished = step == vTourWordCount
        if (finished)
        {
            
            let procent = (rightAnswerCount*100)/vTourWordCount
            var title : String
            if (procent >= 90)
            {
                title = "Well done"
            }
            else if (procent >= 70)
            {
                title = "Good"
                
            }
            else if (procent >= 40)
            {
                title = "Not bad"
            }
            else
            {
                title = "Next time :)"
            }
            let message = "You have answered \(procent)% of words correcty."
            
            result = Result(title: title, message: message, procent: procent)
            
            if var topicDict = NSUserDefaults.standardUserDefaults().objectForKey(topic.identifier) as? Dictionary<String, AnyObject>
            {
                topicDict["words"] = NSKeyedArchiver.archivedDataWithRootObject(topic.words)
                NSUserDefaults.standardUserDefaults().setObject(topicDict, forKey: topic.identifier)
                
                print("Result \(topic.words.description)")
                
            }
            else
            {
                print("Error saving tour results with topic identifier \(topic.identifier).")
            }
            
            wordListIndex = 0
            wordList.removeAll()
            step = 1
            rightAnswerCount = 0
        }
        
        return finished
    }

    /** Return result of the tour
     - return: Result info about user's tour
     */
    func getResult() -> Result
    {
        return result
    }
    
}
