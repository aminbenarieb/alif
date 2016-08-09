//
//  SetCell.swift
//  Alif
//
//  Created by Amin Benarieb on 07/02/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import SWTableViewCell

class SetCell : SWTableViewCell
{
    @IBOutlet var pictureView : UIImageView!
    @IBOutlet var titleLabel : UILabel!
    
    private let inset : CGFloat = 15
    
    override var frame: CGRect {
        
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
//            frame.origin.x += inset
            frame.origin.y += inset/2
//            frame.size.width -= 2*inset+10
            frame.size.height -= inset/2
            
            super.frame = frame
        }
    }
    
}