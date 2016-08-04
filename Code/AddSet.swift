//
//  AddSet.swift
//  Alif
//
//  Created by Amin Benarieb on 06/02/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift
import CHCSVParser
import GSIndeterminateProgressBar
import Material



class AddSet : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let RowHeight : CGFloat = 75.0
    private var sets = [AnyObject]()
    
    var progressView : GSIndeterminateProgressView!
    @IBOutlet var tableView : UITableView!
    
    //MARK: - Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create template button
        let button: UIButton = UIButton(type: .Custom)
        button.setImage(UIImage(named: "Add Icon"), forState: UIControlState.Normal)
        button.addTarget(self, action: "createTemplate", forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 25, 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        //GSIndeterminateProgressBar
        let navigationBar = self.navigationController!.navigationBar
        progressView = GSIndeterminateProgressView(frame: CGRectMake(0, navigationBar.frame.size.height - 2,
            navigationBar.frame.size.width, 2))
        progressView.progressTintColor = UIColor.whiteColor();
        progressView.backgroundColor = navigationBar.barTintColor
        progressView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin];
        navigationBar.addSubview(progressView)
        
        // Info Button
        let img: UIImage? = UIImage(named: "Info")
        let buttonInfo: FabButton = FabButton(frame: CGRectMake(self.view.bounds.width-74, self.view.bounds.height-74, 64, 64))
        buttonInfo.setImage(img, forState: .Normal)
        buttonInfo.setImage(img, forState: .Highlighted)
        buttonInfo.backgroundColor = navigationBar.barTintColor
        self.view.addSubview(buttonInfo)
        
        tableView.separatorColor = .clearColor()
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Add a new set"
        
        if (Reachability.isConnectedToNetwork() == true)
        {
            // fetching files
        }
        else {
            Amin.sharedInstance.showZAlertView("Oops", message: "Internet connection appears to be offline.")
        }
        
        
    }
    
    //MARK: - Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

//        setLoading(true)
//        if let file = sets[indexPath.row] as? <#T##fileType##fileType#> {
//        
//            if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
//            {
//                let path = dir.stringByAppendingPathComponent(file.identifier+".csv");
//                
//                if let url = NSURL(string: Amin.sharedInstance.spreadSheetLinkUrl(file.identifier, gid: ""))
//                {
//                    <#T##someService##someService#>.fetcherService.fetcherWithURL(url).beginFetchWithCompletionHandler({ (data : NSData?, error : NSError?) -> Void in
//                        
//                        self.setLoading(false)
//                        if (error == nil)
//                        {
//                            //writing
//                            if (data?.writeToFile(path, atomically: false) == true)
//                            {
//                                
//                                let topicDict : Dictionary<String, AnyObject> = Dictionary(dictionaryLiteral:
//                                    ("name", file.name),
//                                    ("identifier", file.identifier),
//                                    ("color", NSKeyedArchiver.archivedDataWithRootObject(UIColor.randomColor())),
//                                    ("setUp", false)
//                                )
//                                
//                                NSUserDefaults.standardUserDefaults().setObject(topicDict, forKey: file.identifier)
//                                print("Successfully saved to path: "+path)
//                                Amin.sharedInstance.showInfoMessage("Saved")
//                            }
//                            else
//                            {
//                                Amin.sharedInstance.showInfoMessage("Unable save file")
//                            }
//                        
//                        }
//                        else {
//                            Amin.sharedInstance.showZAlertView("Error", message: (error?.localizedDescription)!)
//                        }
//                    })
//                }
//                else
//                {
//                    print("Invalid url.")
//                }
//            }
//        }
        
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
        return sets.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
        
//        if let file = sets[indexPath.row] as? <#T##fileType##fileType#> {
//            cell!.textLabel?.text = file.name
//        }
        
        return cell!
    }
    
   
    
    //MARK: - Action
    func createTemplate(){

        print("creating template...")

    }
    
    func setLoading(flag : Bool){
        
        if (flag)
        {
            progressView.startAnimating()
        }
        else
        {
            progressView.stopAnimating()
        }
        tableView.userInteractionEnabled = !flag
    }
    
}
