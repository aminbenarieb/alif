//
//  TopicView.swift
//  Alif
//
//  Created by Amin Benarieb on 06/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import UIKit
import JTAlertView

class TopicView: UIViewController {

    @IBOutlet var slideView: UIView!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet var buttonPrev: UIButton!
    @IBOutlet var progressView: AminProgressView!

    var slidesInfo : [NSDictionary] = []
    var slideIndex : Int = 0
    
    //MARK: Class methods
    
    override func viewWillAppear(animated: Bool) {
        
        self.slideIndex = 0
        self.prepareView()
    
    }
    
    @IBAction func buttonNextTapped(){
        if (slideIndex == slidesInfo.count-1)
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
            self.slideIndex++
            self.prepareView()
        }
    }
    
    @IBAction func buttonPrevTapped(){
        if (slideIndex > 0){
            slideIndex--
            self.prepareView()
        }

    }
    
    static func instantiate() -> TopicView{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TopicView") as! TopicView
    }
    
    //MARK: Loading HTML
    
    func prepareView(){
        
        progressView.progressValue = CGFloat(slideIndex+1)/CGFloat(slidesInfo.count) * 100;
        
        let slideInfo = self.slidesInfo[self.slideIndex]
        var slideSubView : SlideView?
        
        if let type = slideInfo["type"] as? String where type == "text"
        {
            slideSubView =   TextSlideView.instantiate()
        }
        if let type = slideInfo["type"] as? String where type == "word"
        {
            slideSubView = WordSlideView.instantiate()
        }
        
        if let slideSubView = slideSubView as? UIView
        {
            let lastSubView = slideView.subviews.last
            lastSubView?.removeFromSuperview()
            
            slideSubView.frame = slideView.bounds
            slideView.addSubview(slideSubView)
        }
        
        slideSubView?.prepareViewWithInfo(slideInfo)
        
    }
    
    
}
