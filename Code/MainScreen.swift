//
//  MainScreen.swift
//  Alif
//
//  Created by Amin Benarieb on 06/02/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import CHCSVParser

class MainScreen : UITableViewController {
    
    private let RowHeight : CGFloat = 75.0
    private var topics = [String]()
        
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
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Alif"
        self.loadFiles()
    }
    
    //MARK: - Selection
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        {
            let path = dir.stringByAppendingPathComponent(topics[indexPath.row]);
            
            //reading
            let fileUrl = NSURL(fileURLWithPath: path)
            if let latestFileComponentsArray = NSArray(contentsOfCSVURL:fileUrl)
            {
//                let parser = CHCSVParser(contentsOfCSVURL: fileUrl)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let unlockScreen = storyBoard.instantiateViewControllerWithIdentifier("Topic")
                
                Amin.sharedInstance.targetWords.removeAll()
                Amin.sharedInstance.meaningWords.removeAll()
                
                for (var i = 2; i < latestFileComponentsArray.count; i++)
                {
                    let foo = latestFileComponentsArray[i] as! NSArray
                    for (var j = 0; j < 2; j++)
                    {
                        let bar = foo[j] as! String
                        if (bar == "")
                        {
                            self.navigationController?.pushViewController(unlockScreen, animated: true)
                            return
                        }
                        
                        switch(j)
                        {
                        case 0:
                            Amin.sharedInstance.targetWords.append(bar)
                        case 1:
                            Amin.sharedInstance.meaningWords.append(bar)
                        default:
                            break
                        }
                    }
                }
                
                self.navigationController?.pushViewController(unlockScreen, animated: true)
            }
        }
    }
    
    //MARK: - Section
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Rows
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RowHeight
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SetCell") as! SetCell
        
        let str = topics[indexPath.row]
        let identifier = str.substringWithRange(Range<String.Index>(start: str.startIndex.advancedBy(0), end: str.endIndex.advancedBy(-4)))
            
        if let name = NSUserDefaults.standardUserDefaults().stringForKey(identifier)
        {
            cell.titleLabel.text = name
            cell.pictureView.backgroundColor = UIColor.randomColor()
            
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
    func loadFiles()
    {
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

        do {
            let directoryUrls = try  NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            
            let csvFiles = directoryUrls.filter{ $0.pathExtension == "csv" }.map{ $0.lastPathComponent }
            
            topics.removeAll()
            for csvFile in csvFiles as [String?]
            {
                if let nameCsvFile = csvFile
                {
                    topics.append(nameCsvFile)
                }
            }
            self.tableView.reloadData()
            
        } catch let error as NSError {
            
            Amin.sharedInstance.showZAlertView("Error", message: error.localizedDescription)
        }
    }
    
}