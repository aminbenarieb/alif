//
//  Unlock.swift
//  
//
//  Created by Amin Benarieb on 06/02/16.
//
//

import Foundation

class Unlock : UIViewController
{
    
    @IBAction func dissmiss()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}