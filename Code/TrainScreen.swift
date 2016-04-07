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
import ZAlertView
import Material

private let reuseIdentifier = "Cell"

struct Letter {
    var position : Int
    var sign  : String
}

class TrainScreen: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    // Layout
    @IBOutlet var label: UILabel!
    @IBOutlet var labelstatus: UILabel!
    @IBOutlet var textfield: TextField!
    @IBOutlet var wordBuilder : UICollectionView!
    @IBOutlet var checkbutton : FlatButton!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var contentview : UIView!
    @IBOutlet var progressView : AminProgressView!
    
    @IBOutlet var contentheight: NSLayoutConstraint!
    @IBOutlet var contenttopmargin: NSLayoutConstraint!
    @IBOutlet var wordBuilderHeight: NSLayoutConstraint!
    
    // Support variables
    var activeField : TextField?;
    var selectedIndexPaths : [NSIndexPath]! = []
    var letterPositions : [Letter]! = []
    var mixedWord : NSString = ""
    var next : Bool = false
    
    
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
        
        //wordbuilder
        wordBuilder.backgroundColor = UIColor.clearColor()
        wordBuilder.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        wordBuilder.delegate = self
        wordBuilder.dataSource = self
        
        // back button actoin
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    func back(sender: UIBarButtonItem) {

        
        let dialog = ZAlertView(title: "Hold on", message: "Are you sure you want to leave the tour?",
            isOkButtonLeft: true,
            okButtonText: "Cancel",
            cancelButtonText: "Leave",
            okButtonHandler: {
                
                (alert : ZAlertView) -> () in
                alert.dismiss()
            
            },
            cancelButtonHandler:
            {
                
                (alert : ZAlertView) -> () in
                alert.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
            })
        dialog.alertType = .Confirmation
        dialog.show()
        
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
        
        if (next)
        {
            // Changing progress value
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
                labelstatus.text = "Translate it"
                labelstatus.textColor = MaterialColor.grey.darken4
                checkbutton.setTitle("Check", forState: .Normal)
                checkbutton.backgroundColor = MaterialColor.blue.darken2

                updateView();
            }
        }
        else
        {
            
            var statustext : String
            var statuscolor : UIColor
            let currentword = Vocabluary.sharedInstance.getCurrentWord(false)
            
            if (!Vocabluary.sharedInstance.checkWord(textfield.text) )
            {
                statustext = "Wrong, it's \"\(currentword).\""
                statuscolor = MaterialColor.red.darken2
                
            }
            else
            {
                statustext = "Right!"
                statuscolor = MaterialColor.green.darken2
            }
            
            labelstatus.text = statustext
            labelstatus.textColor = statuscolor
            checkbutton.setTitle("Next", forState: .Normal)
            checkbutton.backgroundColor = statuscolor
        }
        
        next = !next


    }
    
    func updateView(){
        
        label.text = Vocabluary.sharedInstance.getNextWord() as String
        
        //mixing word for word builder
        mixedWord = Vocabluary.sharedInstance.getCurrentWord(true)
    
        textfield.text = ""
        selectedIndexPaths.removeAll()
        wordBuilder.reloadData()
        
    
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

    
//MARK: UICollectionView Workflow
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mixedWord.length
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = selectedIndexPaths.contains(indexPath) ? UIColor.grayColor() : UIColor.randomColor()
        
        if let titleLabel = cell.contentView.viewWithTag(1) as? UILabel
        {
            titleLabel.text = mixedWord.substringWithRange(NSMakeRange(indexPath.row, 1))
        }
        else
        {
            let titleLabel = UILabel(frame: CGRectMake(0,0, cell.contentView.bounds.width, cell.contentView.bounds.height))
            titleLabel.tag = 1
            titleLabel.textAlignment = .Center
            titleLabel.font = titleLabel.font.fontWithSize(23)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.text = mixedWord.substringWithRange(NSMakeRange(indexPath.row, 1))
            
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            tap.delegate = self
            titleLabel.addGestureRecognizer(tap)
            titleLabel.userInteractionEnabled = true
            
            
            cell.contentView.addSubview(titleLabel)
        }
        
        return cell
        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {

        var indexPath: NSIndexPath!
        
        if let label = sender?.view as? UILabel
        {
            if let superview = label.superview {
                if let cell = superview.superview as? UICollectionViewCell {
                    indexPath = wordBuilder.indexPathForCell(cell)
                }
            }
        
            if let letter = label.text
            {
                if let index = selectedIndexPaths.indexOf(indexPath)
                {
                    let letter = letterPositions[index]
                    
                    // Removing selected letter
                    textfield.text = (textfield.text! as NSString).stringByReplacingCharactersInRange(NSMakeRange(letter.position,1), withString: "")
                    selectedIndexPaths.removeAtIndex(index)
                    letterPositions.removeAtIndex(index)
                    
                    // Reseting letters position
                    for (var i = 0; i < letterPositions.count; i++)
                    {
                        letterPositions[i].position = i
                    }

                }
                else
                {
                    // Adding selected letter and saving it's data
                    textfield.text = "\(textfield.text!)\(letter)"
                    selectedIndexPaths.append(indexPath)
                    letterPositions.append(Letter(position: letterPositions.count, sign: letter))
                }
            }
            
        }

        
        wordBuilder.reloadItemsAtIndexPaths([indexPath])
        
    }
    


// MARK: - ScrollView & Rotation
    
//    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        
//        self.viewWillAppear(true)
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.wordBuilderHeight.constant = self.wordBuilder.contentSize.height
        self.wordBuilder.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentheight.constant = wordBuilder.frame.origin.y + wordBuilder.contentSize.height+checkbutton.bounds.height+30
        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, contentheight.constant);
    }

}

