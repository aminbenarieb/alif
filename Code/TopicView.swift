//
//  TopicView.swift
//  Alif
//
//  Created by Amin Benarieb on 06/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import UIKit

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
