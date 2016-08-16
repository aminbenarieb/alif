//
//  TrainView.swift
//  Alif
//
//  Created by Amin Benarieb on 16/08/16.
//  Copyright © 2016 Amin Benarieb. All rights reserved.
//

import Foundation
import UIKit

protocol TrainerProtocol : class
{
    func check( answer : String?);
}

protocol TrainModeView : class
{
    func updateView(userInfo : [NSObject : AnyObject]? );
}

class TrainView : UIView, TrainModeView
{
    func updateView(userInfo : [NSObject : AnyObject]? ){}
    
    weak var delegate : TrainerProtocol?
    
}