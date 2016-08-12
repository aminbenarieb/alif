//
//  WordSlideView.swift
//  Alif
//
//  Created by Amin Benarieb on 12/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import UIKit

class WordSlideView: UIView, SlideView {

    @IBOutlet var arabicWord : UILabel!
    @IBOutlet var arabicNumber : UILabel!
    
    @IBOutlet var transcription : UILabel!
    
    @IBOutlet var translationWord : UILabel!
    @IBOutlet var modernNumber : UILabel!

    func prepareViewWithInfo( slideInfo : NSDictionary ){
        
        if let dictionary = slideInfo["content"] as? NSDictionary,
            arabicWordText = dictionary["arabic"] as? String,
            translationText = dictionary["translation"] as? String,
            transcriptionText = dictionary["transcription"] as? String,
            number = dictionary["number"] as? NSDictionary,
            arabicNumberText = number["arabic"] as? String,
            modernNumberText = number["modern"] as? String
        {
            
            arabicWord.text = arabicWordText
            translationWord.text = translationText
            transcription.text = transcriptionText
            arabicNumber.text = arabicNumberText
            modernNumber.text = modernNumberText

        }
    }
    
    static func instantiate() -> WordSlideView{
        return UINib(nibName: "WordSlideView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! WordSlideView
    }
    
}
