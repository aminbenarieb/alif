//
//  ConstructorView.swift
//  Alif
//
//  Created by Amin Benarieb on 15/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import Material

struct Letter {
    var position : Int
    var sign  : String
}

class ConstructorView : TrainView, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate
{
    // Layout
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var wordBuilder : UICollectionView!
    @IBOutlet weak var checkbutton : FlatButton!
    
    // Constants & variables
    private let reuseIdentifier = "Cell"
    var selectedIndexPaths : [NSIndexPath]! = []
    var letterPositions : [Letter]! = []
    var userVariants = [String]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //button
        checkbutton.setTitleColor(.whiteColor(), forState: .Normal)
        checkbutton.pulseColor = MaterialColor.white
        
        //textField
        textField.leftView = UIView(frame:CGRectMake(0, 0, 5, 20))
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.placeholder = "Translation"
        textField.textColor = MaterialColor.black
        textField.titleLabel = UILabel()
        textField.titleLabel!.font = RobotoFont.mediumWithSize(12)
        textField.titleLabelColor = MaterialColor.grey.lighten1
        textField.titleLabelActiveColor = UIColor(netHex: 0x246746)
        textField.clearButtonMode = .WhileEditing
        
        //wordbuilder
        wordBuilder.backgroundColor = UIColor.clearColor()
        wordBuilder.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        wordBuilder.delegate = self
        wordBuilder.dataSource = self
        
    }
    
    static func instantiate() -> ConstructorView{
        return UINib(nibName: "ConstructorView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ConstructorView
    }

    //MARK: Protocol
    
    override func updateView(userInfo : [NSObject : AnyObject]? ){
        
        if let userInfo = userInfo
        {
            if let userVariants = userInfo["userVariants"] as? [String]
            {
                self.textField.text = ""
                self.userVariants = userVariants
                self.selectedIndexPaths.removeAll()
                self.wordBuilder.reloadData()
            }
            
            
            if  let btnTitle = userInfo["btnTitle"] as? String,
                    btnColor = userInfo["btnColor"] as? UIColor
            {
                self.checkbutton.setTitle(btnTitle, forState: .Normal)
                self.checkbutton.backgroundColor = btnColor
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction private func check(){
        
        delegate?.check(textField.text)
        
    }
    
    //MARK: UICollectionView Workflow
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVariants.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = selectedIndexPaths.contains(indexPath) ? UIColor.grayColor() : UIColor.randomColor()
        
        if let titleLabel = cell.contentView.viewWithTag(1) as? UILabel
        {
            titleLabel.text = userVariants[indexPath.row]
        }
        else
        {
            let titleLabel = UILabel(frame: CGRectMake(0,0, cell.contentView.bounds.width, cell.contentView.bounds.height))
            titleLabel.tag = 1
            titleLabel.textAlignment = .Center
            titleLabel.font = titleLabel.font.fontWithSize(23)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.text = userVariants[indexPath.row]
            
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            tap.delegate = self
            titleLabel.addGestureRecognizer(tap)
            titleLabel.userInteractionEnabled = true
            
            
            cell.contentView.addSubview(titleLabel)
        }
        
        return cell
        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        var indexPath: NSIndexPath!
        
        if let label = sender?.view as? UILabel
        {
            if let superview = label.superview {
                if let cell = superview.superview as? UICollectionViewCell {
                    indexPath = wordBuilder.indexPathForCell(cell)
                }
            }
            
            if let letter = label.text
            {
                if let index = selectedIndexPaths.indexOf(indexPath)
                {
                    let letter = letterPositions[index]
                    
                    // Removing selected letter
                    textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(NSMakeRange(letter.position,1), withString: "")
                    selectedIndexPaths.removeAtIndex(index)
                    letterPositions.removeAtIndex(index)
                    
                    // Reseting letters position
                    for (var i = 0; i < letterPositions.count; i++)
                    {
                        letterPositions[i].position = i
                    }
                    
                }
                else
                {
                    // Adding selected letter and saving it's data
                    textField.text = "\(textField.text!)\(letter)"
                    selectedIndexPaths.append(indexPath)
                    letterPositions.append(Letter(position: letterPositions.count, sign: letter))
                }
            }
            
        }
        
        
        wordBuilder.reloadItemsAtIndexPaths([indexPath])
        
    }
    

    
}

