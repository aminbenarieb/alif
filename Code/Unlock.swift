//
//  Unlock.swift
//  
//
//  Created by Amin Benarieb on 06/02/16.
//
//

import Foundation
import Material

class Unlock : UIViewController
{
    
    @IBOutlet var buttonUnlock : FlatButton!
    
    override func viewDidLoad() {
        buttonUnlock.setTitleColor(.whiteColor(), forState: .Normal)
        buttonUnlock.pulseColor = MaterialColor.white
    }
    
    
    @IBAction func dissmiss()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}