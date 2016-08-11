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

    var slidesInfo : [NSDictionary] = []
    var slideIndex : Int = 0
    
    //MARK: Class methods
    
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
    
    static func instantiate() -> TopicView{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TopicView") as! TopicView
    }
    
    //MARK: Loading HTML
    
    func prepareView(){
        
        progressView.progressValue = CGFloat(slideIndex+1)/CGFloat(slidesInfo.count) * 100;
        
        let path = NSBundle.mainBundle().bundlePath
        let pathURL = NSURL(fileURLWithPath: path)
        self.webView.loadHTMLString(slideHTMLString(self.slidesInfo[self.slideIndex++]), baseURL: pathURL)
    }
    
    func slideHTMLString(slideInfo: NSDictionary) -> String    {
        
        //FIXME: Added strategy
        var HTMLString = ""
        
        if let type = slideInfo["type"] as? String where type == "text"
        {
            if let text = slideInfo["content"] as? String
            {
                HTMLString = text
            }
        }
        
        if let type = slideInfo["type"] as? String where type == "word"
        {
            if let dictionary = slideInfo["content"] as? NSDictionary,
                    arabicWord = dictionary["arabic"] as? String,
                    translation = dictionary["translation"] as? String,
                    transcription = dictionary["transcription"] as? String,
                    number = dictionary["number"] as? NSDictionary,
                        arabicNumber = number["arabic"],
                        modernNumber = number["modern"]
            {
                HTMLString = "<table class=\"table\">" +
                    "<thead>" +
                        "<tr>" +
                            "<th>Word</th>" +
                            "<th>Number</th>" +
                        "</tr>" +
                    "</thead>" +
                    "<tbody>" +
                        "<tr>" +
                            "<td>" +
                                "<div class=\"row\"> \(arabicWord) </div>" +
                                "<div class=\"row transcription\"> \(transcription) </div>" +
                            "</td>" +
                            "<td class=\"arabicNumber\"> \(arabicNumber)</td>" +
                        "</tr>" +
                        "<tr class=\"translation\">" +
                            "<td> \(translation)</td>" +
                            "<td> \(modernNumber)</td>" +
                        "</tr>" +
                    "</tbody>" +
                "</table>"
            }
        }
        
        HTMLString = "<!DOCTYPE html>" +
        "<html lang=\"en\">" +
        "<head>" +
        "<meta charset=\"utf-8\"> " +
        "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" +
        "<link rel=\"stylesheet\" href=\"bootstrap.min.css\">" +
        "<link rel=\"stylesheet\" href=\"custom.css\">" +
        "</head>" +
        "<body>" +
        "<div class=\"container\">" +
        "\(HTMLString)" +
        "</div>" +
        "</body>" +
        "</html>"
        
        return HTMLString
        
    }

    
}
