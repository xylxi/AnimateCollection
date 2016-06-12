//
//  SLMenuButton.swift
//  SLStransform3DDemo
//
//  Created by WangZHW on 16/6/12.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class MenuButton: UIView {
    
    var imageView: UIImageView!
    var tapHandler: (()->())?
    
    override func didMoveToSuperview() {
        frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        
        imageView = UIImageView(image:UIImage(named:"menu.png"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuButton.didTap)))
        addSubview(imageView)
    }
    
    var tap: Bool = false
    
    func didTap() {
        tapHandler?()
        UIView.animateWithDuration(0.5, animations: {
            let angle:CGFloat = self.tap ? 0 : 1
            self.rotate(angle)
        }) { (finish) in
            self.tap = !self.tap
        }
    }
    
    func rotate(fraction: CGFloat) {
        let angle = Double(fraction) * M_PI_2
        imageView.transform = CGAffineTransformMakeRotation(CGFloat(angle))
        print(fraction)
    }
}