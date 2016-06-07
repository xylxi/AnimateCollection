//
//  ViewController.swift
//  SLGradientAnimations
//
//  Created by WangZHW on 16/6/7.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var slideView: SLAnimatedMaskLabel!
    @IBOutlet var time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func didSlide() {
        
        // reveal the meme upon successful slide
        let image = UIImageView(image: UIImage(named: "meme"))
        image.center = view.center
        image.center.x += view.bounds.size.width
        view.addSubview(image)
        
        UIView.animateWithDuration(0.33, delay: 0.0, options: [], animations: {
            self.time.center.y -= 200.0
            self.slideView.center.y += 200.0
            image.center.x -= self.view.bounds.size.width
            }, completion: nil)
        
        UIView.animateWithDuration(0.33, delay: 1.0, options: [], animations: {
            self.time.center.y += 200.0
            self.slideView.center.y -= 200.0
            image.center.x += self.view.bounds.size.width
            }, completion: {_ in
                image.removeFromSuperview()
        })
    }
    
}