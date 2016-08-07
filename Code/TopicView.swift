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

    var webView = UIWebView()
    var fileName : String?
    
    override func viewDidLoad() {
        
        webView.frame = self.view.frame
        self.view.addSubview(webView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let queue = dispatch_get_main_queue()
        dispatch_async(queue) { () -> Void in
        
            do
            {
                if let fileSourceUrl = NSBundle.mainBundle().URLForResource(self.fileName, withExtension: "html")
                {
                    let data = try String(contentsOfURL: fileSourceUrl, encoding: NSUTF8StringEncoding)
                    self.webView.loadHTMLString(data, baseURL: nil)
                }
            }
            catch let error as NSError
            {
                
                Amin.sharedInstance.showZAlertView("Error".localized, message: error.localizedDescription)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                
            }
        
        }
    
    }

    
}
