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

    // Layout
    @IBOutlet var label: UILabel!
    @IBOutlet var textfield: HoshiTextField!
    @IBOutlet var checkbutton : UIButton!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var contentview : UIView!
    
    @IBOutlet var contentheight: NSLayoutConstraint!
    @IBOutlet var contenttopmargin: NSLayoutConstraint!
    
    // Google Drive
    private let kKeychainItemName = "Drive API"
    //kGTLAuthScopeDriveReadonly
    private let scopes = [kGTLAuthScopeDriveReadonly]
    private let service = GTLServiceDrive()
    
    // Support variables
    var activeField : HoshiTextField?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listener of tapping on screen to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Google Drive
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: Identifier_GoogleDrive,
            clientSecret: nil) {
                service.authorizer = auth
        }
        
        
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
    
    
//MARK: GOOGLE DRIVE
    
    // When the view appears, ensure that the Drive API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
                fetchFiles()
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    // Construct a query to get names and IDs of 10 files using the Google Drive API
    func fetchFiles() {
        print("Getting files...")
        let query = GTLQueryDrive.queryForFilesList()
        query.pageSize = 10
        query.fields = "nextPageToken, files(id, name)"
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: "displayResultWithTicket:finishedWithObject:error:"
        )
    }
    
    // Parse results and display
    func displayResultWithTicket(ticket : GTLServiceTicket,
        finishedWithObject response : GTLDriveFileList,
        error : NSError?) {
            
            if let error = error {
                Amin.sharedInstance.showZAlertView("Error", message: error.localizedDescription)
                return
            }
            
            var filesString = ""
            
            if let files = response.files where !files.isEmpty {
                filesString += "Files:\n"
                for file in files as! [GTLDriveFile] {
                    if (file.identifier == "1QFLz3amkLcvUfP7abk56pmJFpioea5nTxo_foL-682Y")
                    {
                        if let stuff = file.userProperties
                        {
                            print(stuff)
                        }

                        if let stuff = file.userProperties
                        {
                            print(stuff)
                        }

                        if let stuff = file.properties
                        {
                            print(stuff)
                        }
                        if let stuff = file.properties
                        {
                            print(stuff)
                        }
                        if let stuff = file.appProperties
                        {
                            print(stuff)
                        }
                        if let stuff = file.kind
                        {
                            print(stuff)
                        }
                        if let stuff = file.mimeType
                        {
                            print(stuff)
                        }
                        if let stuff = file.fileExtension
                        {
                            print(stuff)
                        }
                        
                        
                        
                        
                        if let urlString = file.propertyForKey("exportUrls") as? String
                        {
                            let fetcher = service.fetcherService.fetcherWithURL(NSURL(string: urlString)!)
                            fetcher.beginFetchWithCompletionHandler({ (data : NSData?, error : NSError?) -> Void in
                                
                                if (error == nil)
                                {
                                    print("Retrieved file content")

                                    
                                    
                                } else {
                                    print("An error occurred: \(error!)")
                                }
                                
                            })
                            
                        }
                        else
                        {
                            print("Invalid url.")
                        }
                        filesString += "\(file.name) (\(file.identifier))\n"
                    }
                }
            } else {
                filesString = "No files found."
            }
            
            print(filesString)
    }
    
    
    // Creates the auth controller for authorizing access to Drive API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: Identifier_GoogleDrive,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    func viewController(vc : UIViewController,
        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
            
            if let error = error {
                service.authorizer = nil
                Amin.sharedInstance.showZAlertView("Authentication Error", message: error.localizedDescription)
                return
            }
            
            service.authorizer = authResult
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    
//MARK: Actions
    
    @IBAction func check(){
        let message = "word" == textfield.text ? "You cool!" : "Try again :)";
        
        Amin.sharedInstance.showInfoMessage(message)

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

