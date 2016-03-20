//
//  ViewController.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import UIKit
import Material
import GSIndeterminateProgressBar
import JTAlertView

class TrainScreen: UIViewController, UITextFieldDelegate {

    // Layout
    @IBOutlet var label: UILabel!
    @IBOutlet var textfield: TextField!
    @IBOutlet var checkbutton : FlatButton!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var contentview : UIView!
    @IBOutlet var progressView : AminProgressView!
    
    @IBOutlet var contentheight: NSLayoutConstraint!
    @IBOutlet var contenttopmargin: NSLayoutConstraint!
    
    // Support variables
    var activeField : TextField?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listener of tapping on screen to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        

        //label
        label.font = label.font.fontWithSize(40)
        
        //button
        checkbutton.setTitleColor(.whiteColor(), forState: .Normal)
        checkbutton.pulseColor = MaterialColor.white
        
        //textField
        textfield.delegate = self
        textfield.leftView = UIView(frame:CGRectMake(0, 0, 5, 20))
        textfield.leftViewMode = UITextFieldViewMode.Always
        textfield.placeholder = "Translation"
        textfield.textColor = MaterialColor.black
        textfield.titleLabel = UILabel()
        textfield.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textfield.titleLabelColor = MaterialColor.grey.lighten1
        textfield.titleLabelActiveColor = UIColor(netHex: 0x246746)
        textfield.clearButtonMode = .WhileEditing

        //progressview settings
        progressView.progressValue = Vocabluary.sharedInstance.getProgressValue()
        

    }
    override func viewWillAppear(animated: Bool) {

        registerForKeyboardNotifications()
        updateView()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        unRegisterForKeyboardNotifications()
    }
    
    
//MARK: Actions
    
    @IBAction func check(){
        
        let message = Vocabluary.sharedInstance.checkWord(textfield.text) ? "You cool!" : "Try again :)";
        Amin.sharedInstance.showInfoMessage(message)
        
        progressView.progressValue = Vocabluary.sharedInstance.getProgressValue()
        
        if (Vocabluary.sharedInstance.isFinished() )
        {
            
            if let alertView = JTAlertView(title: "\(Vocabluary.sharedInstance.result.title)\n\n \(Vocabluary.sharedInstance.result.message)", andImage:Vocabluary.sharedInstance.image)
            {
                alertView.size = CGSizeMake(280, 230);
                alertView.addButtonWithTitle("OK", style: .Default, action: { (alertview: JTAlertView!) in
                    
                    alertview.hide()
                    
                })
                
                alertView.show()
            }
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else
        {
            updateView()
        }

    }
    
    func updateView(){
        
        label.text = Vocabluary.sharedInstance.getNextWord().target as String 
    
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
        
        if let navBarHeight = self.navigationController?.navigationBar.frame.height
        {
            let contentInsets = UIEdgeInsetsMake(navBarHeight+contenttopmargin.constant+progressView.bounds.height, 0.0, 0, 0.0)
            scrollview.contentInset = contentInsets
            scrollview.scrollIndicatorInsets = contentInsets
            
        }
        
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        activeField = textField as? TextField
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

