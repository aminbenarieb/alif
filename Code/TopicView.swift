//
//  TopicView.swift
//  Alif
//
//  Created by Amin Benarieb on 06/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import UIKit
import JTAlertView

//WARNING: Retain cycle?

class TopicView: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet var progressView: AminProgressView!

    var slidesInfo : [String] = []
    var slideIndex : Int = 0
        
    override func viewWillAppear(animated: Bool) {
        
        self.slideIndex = 0
        self.prepareView()
    
    }
    
    @IBAction func buttonTapped(){
        if (slideIndex == slidesInfo.count)
        {
            
            if let alertView = JTAlertView(title: "Well done!\n Do you want to train?", andImage: UIImage(named: "Topic Completed"))
            {
                alertView.size = CGSizeMake(280, 230);
                alertView.addButtonWithTitle("Train", action: { (alertview : JTAlertView!) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationPushToTrainView, object: nil)
                    alertview.hide()
                })
                alertView.addButtonWithTitle("Later", style: .Destructive, action: { (alertview: JTAlertView!) in
                    alertview.hide()
                })
                alertView.show()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Request Push Notificatios")
            }
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else
        {
            self.prepareView()
        }
    }
    
    func prepareView(){
        
        progressView.progressValue = CGFloat(slideIndex+1)/CGFloat(slidesInfo.count) * 100;
        self.webView.loadHTMLString(self.slidesInfo[self.slideIndex++], baseURL: nil)
    }
    
    
    static func instantiate() -> TopicView
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TopicView") as! TopicView
    }

    
}
