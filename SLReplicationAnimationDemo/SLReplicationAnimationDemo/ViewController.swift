//
//  ViewController.swift
//  SLReplicationAnimationDemo
//
//  Created by WangZHW on 16/6/8.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var replicationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.greenColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.firstReplicatiorAnimation()
        self.secondReplicatiorAnimation()
    }


    func firstReplicatiorAnimation() ->Void {
        let replicatiorLayer = CAReplicatorLayer()
        replicatiorLayer.bounds = CGRect(x: self.replicationView.frame.origin.x, y: self.replicationView.frame.origin.y, width: self.replicationView.frame.size.width, height: self.replicationView.frame.size.height);
        replicatiorLayer.anchorPoint = CGPoint(x: 0, y: 0)
        replicatiorLayer.backgroundColor = UIColor.greenColor().CGColor
        self.replicationView.layer.addSublayer(replicatiorLayer)
        print(replicatiorLayer.frame)
        
        // 为什么rectangle的坐标系，不是对照replicationLer的来
        let rectangle = CALayer()
        rectangle.bounds = CGRect(x: 0, y: 0, width: 30, height: 90)
        rectangle.anchorPoint = CGPoint(x: 0, y: 0)
        rectangle.position = CGPoint(x: replicationView.frame.origin.x + 10, y: replicationView.frame.origin.y + 120)
        rectangle.cornerRadius = 2
        rectangle.backgroundColor = UIColor.whiteColor().CGColor
        replicatiorLayer.addSublayer(rectangle)
        
        let moveRectangle = CABasicAnimation(keyPath: "position.y")
        moveRectangle.toValue = rectangle.position.y - 55
        moveRectangle.duration = 0.7
        moveRectangle.autoreverses = true
        moveRectangle.repeatCount = HUGE
        rectangle.addAnimation(moveRectangle, forKey: nil)
        
        // 赋值3次
        replicatiorLayer.instanceCount = 3;
        // 每个位置偏移
        replicatiorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0)
        // 每个动画起始时间递增
        replicatiorLayer.instanceDelay = 0.3
        // 切割超出late的部分
        replicatiorLayer.masksToBounds = true
    }
    
    func secondReplicatiorAnimation() ->Void {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: self.secondView.frame.size.width, height: self.secondView.frame.size.height)
        replicatorLayer.position = CGPoint(x: self.secondView.frame.size.width/2, y: self.secondView.frame.size.height/2)
        replicatorLayer.backgroundColor = UIColor.greenColor().CGColor
        self.secondView.layer.addSublayer(replicatorLayer)
        
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        circle.position = CGPoint(x: self.secondView.frame.size.width/2, y: self.secondView.frame.size.height/2 - 55)
        circle.cornerRadius = 7.5
        circle.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(circle)
        
        // 注意，赋值的layer，选择是围绕的CAReplicatorLayer的锚点旋转的
        replicatorLayer.instanceCount = 15
        let angle = CGFloat(2 * M_PI) / CGFloat(15)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 0.1
        scale.duration = 1
        scale.repeatCount = HUGE
        circle.addAnimation(scale, forKey: nil)
        replicatorLayer.instanceDelay = 1/15
        circle.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
    }
}

