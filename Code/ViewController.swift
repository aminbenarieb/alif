//
//  ViewController.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import UIKit
import TextFieldEffects


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var label: UILabel!
    @IBOutlet var textfield: HoshiTextField!
    @IBOutlet var checkbutton : UIButton!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var contentview : UIView!
    
    @IBOutlet var contentheight: NSLayoutConstraint!
    @IBOutlet var contenttopmargin: NSLayoutConstraint!
    
    var activeField : HoshiTextField?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        label.font = label.font.fontWithSize(40)
        textfield.delegate = self
        
        textfield.leftView = UIView(frame:CGRectMake(0, 0, 5, 20))
        textfield.leftViewMode = UITextFieldViewMode.Always
        
        textfield.borderInactiveColor = .lightGrayColor()
        textfield.borderActiveColor = UIColor(netHex: 0x246746)
        
        textfield.placeholderColor = .lightGrayColor()
        textfield.placeholder = "Translation"

        


    }
    override func viewWillAppear(animated: Bool) {

        registerForKeyboardNotifications()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        unRegisterForKeyboardNotifications()
    }
    
    //MARK Actions
    
    @IBAction func check()
    {
        let message = "word" == textfield.text ? "You cool!" : "Try again :)";
        
        Amin.sharedInstance.showMessage(message, message: "")
    }
    
    //MARK: Handling Keyboard & TextField
    
    func dismissKeyboard(){
        if let _activeField = activeField
        {
            _activeField.resignFirstResponder()
        }
        self.view.endEditing(true)
        
    }
    
    func unRegisterForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWasShown(aNotification : NSNotification){
        if let info = aNotification.userInfo
        {
            if let kbsize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
            {
                if let _activeField = activeField
                {
                    let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbsize.height, 0.0)
                    scrollview.contentInset = contentInsets
                    scrollview.scrollIndicatorInsets = contentInsets
                    scrollview.scrollRectToVisible(_activeField.frame, animated: true)
                }
                
            }
        }
    }
    func keyboardWillBeHidden(aNotification : NSNotification){
        let contentInsets = UIEdgeInsetsMake((self.navigationController?.navigationBar.frame.height)!+contenttopmargin.constant, 0.0, 0, 0.0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        activeField = textField as? HoshiTextField
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool  {
        
        activeField = nil
        return true
    }


    // MARK: - ScrollView & Rotation
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        self.viewWillAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentheight.constant = checkbutton.frame.origin.y+checkbutton.bounds.height+20
        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, contentheight.constant);
    }

}

