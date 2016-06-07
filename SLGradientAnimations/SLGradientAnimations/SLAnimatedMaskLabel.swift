//
//  SLAnimatedMaskLabel.swift
//  SLGradientAnimations
//
//  Created by WangZHW on 16/6/7.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class SLAnimatedMaskLabel: UIView {
    
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.5)
        let colors = [
            UIColor.blackColor().CGColor,
            UIColor.whiteColor().CGColor,
            UIColor.blackColor().CGColor
        ]
        // 分割点
        let locations = [
            0.25,
            0.5,
            0.75
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        return gradientLayer
    }()
    
    @IBInspectable var text: String! {
        didSet {
            // 生成图片
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            text.drawInRect(bounds, withAttributes: textAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let maskLayer = CALayer()
            maskLayer.frame = CGRectOffset(bounds, bounds.size.width, 0)
            maskLayer.backgroundColor = UIColor.clearColor().CGColor
            maskLayer.contents = image.CGImage
            gradientLayer.mask = maskLayer
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3*bounds.size.width, height: bounds.size.height)
        layer.addSublayer(gradientLayer)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        let gradientAnimaiton = CABasicAnimation(keyPath: "locations")
        gradientAnimaiton.fromValue = [0.0,0.0,0.25]
        gradientAnimaiton.toValue   = [0.75,1.0,1.0]
        gradientAnimaiton.duration  = 3
        gradientAnimaiton.repeatCount = Float.infinity
        gradientLayer.addAnimation(gradientAnimaiton, forKey: nil)
    }
    
    // 
    let textAttributes: [String: AnyObject] = {
       let style = NSMutableParagraphStyle()
        style.alignment = .Center
        return [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 28.0)!,
            NSParagraphStyleAttributeName: style
        ]
    }()

}