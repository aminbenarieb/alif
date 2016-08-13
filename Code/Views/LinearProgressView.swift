//
//  LinearProgressView.swift
//  LinearProgressBar
//
//  Created by Eliel Gordon on 11/13/15.
//  Copyright © 2015 Eliel Gordon. All rights reserved.
//

import UIKit

protocol LinearProgressDelegate: class {
    func didChangeProgress(fromValue from: Double, toValue to: Double)
}

@IBDesignable
class AminProgressView: UIView {
    
    @IBInspectable var barColor: UIColor = UIColor.greenColor()
    @IBInspectable var trackColor: UIColor = UIColor.clearColor()
    @IBInspectable var isRounded: Bool = false
    @IBInspectable var barThickness: CGFloat = 10
    @IBInspectable var barPadding: CGFloat = 0
    @IBInspectable var trackPadding: CGFloat = 6 {
        didSet {
            if trackPadding < 0 {
                trackPadding = 0
            }else if trackPadding > barThickness {
                trackPadding = 0
            }
        }
    }
    @IBInspectable var progressValue: CGFloat = 0 {
        didSet {
            if (progressValue >= 100) {
                progressValue = 100
            } else if (progressValue <= 0) {
                progressValue = 0
            }


            setNeedsDisplay()
        }
    }
    
    weak var delegate: LinearProgressDelegate?
    
    override func drawRect(rect: CGRect) {
        drawProgressView()
    }
    
    // Draws the progress bar and track
    func drawProgressView() {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        // Progres Bar Track
        CGContextSetStrokeColorWithColor(context, trackColor.CGColor)
        CGContextBeginPath(context)
        CGContextSetLineWidth(context, barThickness + trackPadding)
        CGContextMoveToPoint(context, barPadding, frame.size.height / 2)
        CGContextAddLineToPoint(context, frame.size.width - barPadding, frame.size.height / 2)
        CGContextSetLineCap(context, isRounded ? .Round : .Square)
        CGContextStrokePath(context)
        CGContextRestoreGState(context)
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: barPadding, y: 0))
        linePath.addLineToPoint(CGPoint(x: barPadding, y: 0))
        
        let endLinePath = linePath.copy()
        endLinePath.addLineToPoint(CGPoint(x: barPadding + calcualtePercentage(), y: 0))
        
        
        let lineLayer = CAShapeLayer()
        lineLayer.frame = bounds
        lineLayer.path = linePath.CGPath
        lineLayer.strokeColor = barColor.CGColor
        lineLayer.lineWidth = barThickness
        layer.addSublayer(lineLayer)
        
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endLinePath.CGPath
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        lineLayer.addAnimation(animation, forKey: animation.keyPath)
        
    }
    
    /**
     Calculates the percent value of the progress bar
     
     - returns: The percentage of progress
     */
    func calcualtePercentage() -> CGFloat {
        let screenWidth = frame.size.width - (barPadding * 2)
        let progress = ((progressValue / 100) * screenWidth)
        return progress < 0 ? barPadding : progress
    }
}
