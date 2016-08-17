//
//  Trainer.swift
//  Alif
//
//  Created by Amin Benarieb on 11/03/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation

struct Result
{
    var title : String
    var message : String
    var procent : Int
}

enum TrainMode : Int {
    case Writer = 1 // Default
    case Constructor = 2
    case Selector = 3
}


private let _TrainerSharedInstance = Trainer()

class Trainer
{
    // MARK: Class functions
    
    class var sharedInstance: Trainer {
        return _TrainerSharedInstance
    }
    // MARK: Variables & Constants
    
    private let lTrainingWordCount = 10
    
    var wordList = [Word]()
    var wordIndex : Int = 0
    var mode  = TrainMode.Writer
    var rightAnswerCount = 0
    var result : Result?
    
    // MARK: Public functions
    
    /** Setting up training with topic info
     - parameter Topic : topic info
    */
    func setUpTraining(trainDict : NSDictionary){
        
        initializeTraining(trainDict)
        
    }

    /** Calclulate and return next word with randrom train mode
     */
    func nextWord() -> (targetWord : NSString, support : [String] , mode : TrainMode){
        mode  = TrainMode(rawValue: Int.random(1...3))!
        let nextWord = wordList[wordIndex++]
        var result = (targetWord : nextWord.target, support : [String]() , mode : mode)
        
        switch(mode)
        {
        case .Constructor:
            result.targetWord = nextWord.meaning
            result.support = nextWord.target.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as [String]
            return result
        case .Selector:
            result.support = wordList.filter(){$0 != nextWord}.shuffle.choose(3).map({($0.meaning as String)})
            result.support.append(nextWord.target as String)
            result.support = result.support.shuffle
            return result
        default:
            return result
        }
        
        
    }
    
    /** Checking given word depending on train mode and return bool
     */
    func checkWord(word : NSString) -> Bool{
        
        let prevWord = wordList[wordIndex-1]
        var isRight : Bool = false
        
        switch(mode)
        {
        case .Constructor:
            isRight = word == prevWord.target
            break
        default:
            isRight = word == prevWord.meaning
            break
        }
        rightAnswerCount += Int(isRight)
        
        return isRight
    }

    /** Get progress bar value
     - return: CGFloat procent value for progress bar
     */
    func progressValue() -> Float{
        return Float(wordIndex + 1)/Float(lTrainingWordCount)*100
    }
    
    /** Return flag if Training is finished
     - return: Bool flag
     */
    func isFinished() -> Bool{
        
        let finished = wordIndex == lTrainingWordCount - 1
        if (finished)
        {
            
            let procent = (rightAnswerCount*100)/lTrainingWordCount
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
        }
        
        return finished
    }
    
    // MARK: Private
    
    /** Reseting all variables
    */
    private func initializeTraining(trainDict : NSDictionary){
        
        wordList.removeAll()
        wordIndex = 0
        rightAnswerCount = 0
        
        if let from = trainDict["from"] as? Int,
                to  = trainDict["to"] as? Int
        {
            // Generating training words
            for _ in 1...lTrainingWordCount
            {
                let number = Int.random(from...to)
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.SpellOutStyle
                numberFormatter.locale = NSLocale(localeIdentifier: "ar")
                if let wordString = numberFormatter.stringFromNumber((number))
                {
                    let word = Word(target: wordString, meaning: "\(number)", memorize: .Zero)
                    wordList.append(word)
                }
            }
            
        }
        
    }
    
}
