//
//  Topic.swift
//  
//
//  Created by Amin Benarieb on 07/02/16.
//
//

import Foundation
import Material

class Topic : UIViewController
{
    
    @IBOutlet var btnTrain : FlatButton!
    @IBOutlet var btnLearn : FlatButton!
    
    
    override func viewDidLoad() {
        
        for btn in [btnTrain, btnLearn]
        {
            btn.setTitleColor(.whiteColor(), forState: .Normal)
            btn.pulseColor = MaterialColor.white
        }
    }
    
    @IBAction func pushToLearn()
    {
        //
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let unlockScreen = storyBoard.instantiateViewControllerWithIdentifier("Learn")
        //        self.navigationController?.pushViewController(unlockScreen, animated: true)
    }
    @IBAction func pushToTrain()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let unlockScreen = storyBoard.instantiateViewControllerWithIdentifier("Train")
        self.navigationController?.pushViewController(unlockScreen, animated: true)
    }

    
    
}