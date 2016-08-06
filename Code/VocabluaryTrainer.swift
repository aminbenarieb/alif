//
//  VocabluaryTrainer.swift
//  Alif
//
//  Created by Amin Benarieb on 04/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import Material
import SWTableViewCell
import JTAlertView

class VocabluaryTrainer : UIViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {
    
    private let RowHeight : CGFloat = 75.0
    private var topics = [String]()
    
    @IBOutlet var tableView : UITableView!
    
    //MARK: - Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //unlock button
        let button: UIButton = UIButton(type: .Custom)
        button.setImage(UIImage(named: "Unlock Icon"), forState: UIControlState.Normal)
        button.addTarget(self, action: "unlockAction", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 25, 25)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        //addbutton
        let buttonAdd: UIButton = UIButton(type: .Custom)
        buttonAdd.setImage(UIImage(named: "Add Icon"), forState: UIControlState.Normal)
        buttonAdd.addTarget(self, action: "addAction", forControlEvents: UIControlEvents.TouchUpInside)
        buttonAdd.frame = CGRectMake(0, 0, 25, 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonAdd)
        
        
        tableView.separatorColor = .clearColor()
        tableView.registerNib(UINib(nibName: "SetCell", bundle: nil), forCellReuseIdentifier: "SetCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        
        //request push notification
        
        if (!NSUserDefaults.standardUserDefaults().boolForKey("Request Push Notificatios"))
        {
            if let alertView = JTAlertView(title: "Notify about new features and updates", andImage: UIImage(named: "Push Notifications Background"))
            {
                alertView.size = CGSizeMake(280, 230);
                alertView.addButtonWithTitle("Later", style: .Destructive, action: { (alertview: JTAlertView!) in
                    alertview.hide()
                })
                alertView.addButtonWithTitle("OK", action: { (alertview : JTAlertView!) -> Void in
                    Amin.sharedInstance.registerPushNotification()
                    alertview.hide()
                })
                alertView.show()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Request Push Notificatios")
            }
        }
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Alif"
        self.loadFiles()
    }
    
    //MARK: - Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.navigationController?.pushViewController(modeChoice, animated: true)
    }
    
    //MARK: - Section
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Rows
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RowHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SetCell") as! SetCell
        
        cell.rightUtilityButtons = rightButtons() as [AnyObject]
        cell.delegate = self
        
        
        if let topicDict = NSUserDefaults.standardUserDefaults().objectForKey(topics[indexPath.row]) as? Dictionary<String, AnyObject>
        {
            if let topicName = topicDict["name"] as? String
            {
                cell.titleLabel.text = topicName
            }
            if let topicColorData = topicDict["color"] as? NSData
            {
                if let topicColor = NSKeyedUnarchiver.unarchiveObjectWithData(topicColorData) as? UIColor
                {
                    cell.pictureView.backgroundColor = topicColor
                }
            }
            
            
        }
        
        
        return cell
    }
    
    //MARK: - Action
    
    func unlockAction(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let unlockScreen = storyBoard.instantiateViewControllerWithIdentifier("Unlock")
        self.navigationController?.presentViewController(unlockScreen, animated: true, completion: nil)
    }
    func addAction(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let unlockScreen = storyBoard.instantiateViewControllerWithIdentifier("AddSet")
        self.navigationController?.pushViewController(unlockScreen, animated: true)
    }
    func loadFiles(){
        
        topics.removeAll()
        // loading topics
        tableView.reloadData()
        
    }
    
    //MARK: - Button
    
    func rightButtons() -> NSArray{
        //cell buttons
        let rightButtons = NSMutableArray()
        rightButtons.sw_addUtilityButtonWithColor(MaterialColor.red.darken1, title: "Delete")
        
        return rightButtons
    }
    
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        switch(index)
        {
        case (0):
            if let cellIndexPath = tableView.indexPathForCell(cell)
            {
                if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
                {
                    let path = dir.stringByAppendingPathComponent(topics[cellIndexPath.row]);
                    let fileManager = NSFileManager.defaultManager()
                    
                    do {
                        try fileManager.removeItemAtPath(path)
                        topics.removeAtIndex(cellIndexPath.row)
                        tableView.deleteRowsAtIndexPaths([cellIndexPath], withRowAnimation: .Automatic)
                        Amin.sharedInstance.showInfoMessage("Saved")
                    }
                    catch let error as NSError {
                        
                        Amin.sharedInstance.showZAlertView("Ooops! Something went wrong", message: error.localizedDescription)
                    }
                }
            }
            break;
        default:
            break;
        }
        
    }
    
}