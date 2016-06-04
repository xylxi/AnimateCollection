//
//  ViewController.swift
//  SLAnimationCircleDemo
//
//  Created by WangZHW on 16/6/4.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var circle: SLCircleLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        circle = SLCircleLayer()
        circle.frame = CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, 90)
        circle.backgroundColor = UIColor.yellowColor().CGColor
        circle.setNeedsDisplay()
        self.view.layer.addSublayer(circle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func progress(sender: AnyObject) {
        circle.progress = CGFloat(( sender as! UISlider ).value)
    }

}

