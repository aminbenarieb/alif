//
//  SelectorView.swift
//  Alif
//
//  Created by Amin Benarieb on 15/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import Material

class SelectorView : TrainView
{
    // Layout
    @IBOutlet weak var checkbutton : FlatButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //button
        checkbutton.setTitleColor(.whiteColor(), forState: .Normal)
        checkbutton.pulseColor = MaterialColor.white
        
    }
    
    
    static func instantiate() -> SelectorView{
        return UINib(nibName: "SelectorView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! SelectorView
    }
    
    //MARK: Actions
    
    @IBAction private func check(){
        
        delegate?.check("")
        
    }
    
    //MARK: Protocol
    
    override func updateView(userInfo : [NSObject : AnyObject]? ){
        if let userInfo = userInfo
        {
            if  let btnTitle = userInfo["btnTitle"] as? String,
                btnColor = userInfo["btnColor"] as? UIColor
            {
                self.checkbutton.setTitle(btnTitle, forState: .Normal)
                self.checkbutton.backgroundColor = btnColor
            }
        }
    }
    
}