//
//  WriterView.swift
//  Alif
//
//  Created by Amin Benarieb on 15/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import Material

class WriterView : TrainView, UITextFieldDelegate
{
    // Layout
    @IBOutlet var textField: TextField!
    @IBOutlet var checkbutton : FlatButton!
    
    // Support variables
    var activeField : TextField?;

    static func instantiate() -> WriterView{
        return UINib(nibName: "WriterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! WriterView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //button
        checkbutton.setTitleColor(.whiteColor(), forState: .Normal)
        checkbutton.pulseColor = MaterialColor.white
        
        //textField
        textField.delegate = self
        textField.leftView = UIView(frame:CGRectMake(0, 0, 5, 20))
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.placeholder = "Translation"
        textField.textColor = MaterialColor.black
        textField.titleLabel = UILabel()
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = MaterialColor.grey.lighten1
        textField.titleLabelActiveColor = UIColor(netHex: 0x246746)
        textField.clearButtonMode = .WhileEditing

        
    }
   
    //MARK: Actions
    
    @IBAction func check(){
        delegate?.check(textField.text)
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