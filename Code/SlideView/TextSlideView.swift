//
//  WordSlideView.swift
//  Alif
//
//  Created by Amin Benarieb on 12/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import UIKit

class TextSlideView: UIView, SlideView {

    @IBOutlet var label : UILabel!
    
    func prepareViewWithInfo( slideInfo : NSDictionary ){
        
        if let text = slideInfo["content"] as? String
        {
            label.text = text
        }
        
    }
    
    static func instantiate() -> TextSlideView{
        return UINib(nibName: "TextSlideView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! TextSlideView
    }
}
