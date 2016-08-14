//
//  Topic.swift
//
//
//  Created by Amin Benarieb on 07/02/16.
//
//

import Foundation
import Material

class ModeChoice: UIViewController
{
    
    @IBOutlet var btnTrain : FlatButton!
    @IBOutlet var btnLearn : FlatButton!
    var topic : Topic?
    
    private let topicViewController = TopicView.instantiate()
    private let trainViewController = TrainScreen.instantiate()
    
    override func viewDidLoad() {
        
        for btn in [btnTrain, btnLearn]
        {
            btn.setTitleColor(.whiteColor(), forState: .Normal)
            btn.pulseColor = MaterialColor.white
        }
    }
    
    static func instantiate() -> ModeChoice{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModeChoice") as! ModeChoice
    }
    
    
    @IBAction func pushToLearn(){
        if let topic = topic,
            slides = topic.slides,
            slidesInfo = NSKeyedUnarchiver.unarchiveObjectWithData(slides) as? [NSDictionary]
        {
            topicViewController.slidesInfo = slidesInfo
            self.navigationController?.pushViewController(topicViewController, animated: true)
        }
        
    }
    @IBAction func pushToTrain(){
        
        if let topic = topic,
            train_dictionary = topic.train_dictionary,
            trainDict = NSKeyedUnarchiver.unarchiveObjectWithData(train_dictionary) as? NSDictionary
        {
            Trainer.sharedInstance.setUpTraining(trainDict)
            self.navigationController?.pushViewController(trainViewController, animated: true)
            
        }
    }
}