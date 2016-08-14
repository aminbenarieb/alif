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

private let _TrainerSharedInstance = Trainer()

class Trainer
{
    
    class var sharedInstance: Trainer {
        return _TrainerSharedInstance
    }
    
    internal var targetMode = true
    internal var trainMode = true
    
    private let vTourWordCount = 10
    var wordList = [Word]()
    var wordListIndex = 0
    var step : Int = 1
    var rightAnswerCount = 0
    var result : Result = Result(title: "Undefined", message: "Undefined", procent: 0)
    
    /*   NON-DOCUMENTED FUNCTIONS   */
    
    func setUpTour(topic : Topic){
        
        if let train_dictionary = topic.train_dictionary,
                trainDict = NSKeyedUnarchiver.unarchiveObjectWithData(train_dictionary),
                    from = trainDict["from"] as? Int,
                    to  = trainDict["to"] as? Int
        {
            
            var words = [Word]()
            
            for _ in 0...9
            {
                let number = Int.random(from...to)
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.SpellOutStyle
                numberFormatter.locale = NSLocale(localeIdentifier: "ar")
                if let wordString = numberFormatter.stringFromNumber((number))
                {
                    let word = Word(target: "\(number)", meaning: wordString, memorize: .Zero)
                    words.append(word)
                }
            }
            
            let minCount = min(10, words.count)
            while (wordList.count < minCount)
            {
                let word = words[Int.random(0...minCount-1)]
                if word.memorize != .Full && !wordList.contains(word)
                {
                    wordList.append(word)
                }
            }
            
            
        }
        
    }
    
    func currentWord(shuffle : Bool) -> NSString {
        let currentword = (targetMode ? wordList[wordListIndex-1].target : wordList[wordListIndex-1].meaning);
        return shuffle ? currentword.shuffle() : currentword
    }
    
    func resetTour(){
        wordListIndex = 0
        wordList.removeAll()
        step = 1
        rightAnswerCount = 0
    }
    
    /********************************/
     
    /** Get next word from tour word list
    */
    func nextWord() -> NSString{
        targetMode = arc4random_uniform(2) == 0
        wordListIndex++
        return targetMode ? wordList[wordListIndex-1].meaning : wordList[wordListIndex-1].target
    }
    
    /** Get progress bar value
     - return: CGFloat procent value for progress bar
     */
    func progressValue() -> Float{
        return Float(step)/Float(vTourWordCount)*100
    }
    
    
    func checkWord(givenWord : String?) -> Bool{
        step += 1
        
        var flag = false
        if let word = givenWord
        {
            flag = word == (targetMode ? wordList[wordListIndex-1].target : wordList[wordListIndex-1].meaning)
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
    func isFinished() -> Bool{
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
            
            resetTour()
        }
        
        return finished
    }
    
}
