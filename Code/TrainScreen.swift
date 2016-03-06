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
    
    //Exercise variables
    var checkWord = ""
    var step : CGFloat = 1
    var wordCount : CGFloat = 5
    
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
        progressView.progressValue = (step/wordCount)*100
        

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
        
        let message = checkWord == textfield.text ? "You cool!" : "Try again :)";
        Amin.sharedInstance.showInfoMessage(message)
        
        step += 1
        progressView.progressValue = (step/wordCount)*100
        
        if (step == 5)
        {
            Amin.sharedInstance.showInfoMessage("Result")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else
        {
            updateView()
        }

    }
    
    func updateView(){
        
        let randNum = Int.random(0...(Amin.sharedInstance.targetWords).count-1)
        label.text = Amin.sharedInstance.targetWords[randNum]
        checkWord = Amin.sharedInstance.meaningWords[randNum]
    
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

