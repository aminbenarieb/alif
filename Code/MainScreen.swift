//
//  MainScreen.swift
//  Alif
//
//  Created by Amin Benarieb on 06/02/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import Material
import JTAlertView
import CoreData

class MainScreen : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let RowHeight : CGFloat = 75.0
    private var topics = [NSManagedObject]()
    private let topicViewController = TopicView.instantiate()
    
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
        
        if let topic = topics[indexPath.row] as? Topic, slides = topic.slides as NSData!
        {
            if let slidesInfo = NSKeyedUnarchiver.unarchiveObjectWithData(slides) as? [String]
            {
                topicViewController.slidesInfo = slidesInfo
                self.navigationController?.pushViewController(topicViewController, animated: true)
            }
        }
        
        
        
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
        
        let topic = topics[indexPath.row]
        
        cell.titleLabel!.text = topic.valueForKey("name") as? String
        cell.pictureView.backgroundColor = UIColor.lightGrayColor()
        
        return cell
    }
    
    //MARK: - Action
    
    func unlockAction(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let unlockScreen = storyBoard.instantiateViewControllerWithIdentifier("Unlock")
        self.navigationController?.presentViewController(unlockScreen, animated: true, completion: nil)
    }
    func loadFiles(){
        
        topics.removeAll()
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Topic")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            topics = results as! [NSManagedObject]
        } catch let error as NSError {
            Amin.sharedInstance.showInfoMessage("Could not fetch \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
        
    }
    
}