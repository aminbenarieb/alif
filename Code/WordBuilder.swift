//
//  WordBuilder.swift
//  Alif
//
//  Created by Amin Benarieb on 11/03/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import Material

class WordBuilder : UIView
{
    
    @IBOutlet var resultLabel: TextField!
    @IBOutlet var wordCollection: UICollectionView!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        wordCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
    }

    
    func setUp(word : String)
    {
        
        for (var i = 0; i < word.characters.count ; i++)
        {
            
//            wordCollection.ce
            
        }
    }
    
}