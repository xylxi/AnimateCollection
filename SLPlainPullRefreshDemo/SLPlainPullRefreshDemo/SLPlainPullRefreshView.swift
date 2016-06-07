//
//  SLPlainPullRefreshView.swift
//  SLPlainPullRefreshDemo
//
//  Created by WangZHW on 16/6/7.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit
import QuartzCore


protocol SLRefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: SLRefreshView)
}


class SLRefreshView: UIView, UIScrollViewDelegate {
    
    var delegate: SLRefreshViewDelegate?
    var scrollView: UIScrollView?
    var refreshing: Bool = false
    var progress: CGFloat = 0.0
    
    var isRefreshing = false
    // 圆形路径layer
    let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
    let airplaneLayer: CALayer = CALayer()
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        
        self.scrollView = scrollView
        
        //add the background image
        let imgView = UIImageView(image: UIImage(named: "refresh-view-bg.png"))
        imgView.frame = bounds
        imgView.contentMode = .ScaleAspectFill
        imgView.clipsToBounds = true
        addSubview(imgView)
        
        ovalShapeLayer.strokeColor = UIColor.whiteColor().CGColor
        ovalShapeLayer.fillColor   = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth   = 4.0
        // 虚线样式
        ovalShapeLayer.lineDashPattern = [2,3]
        let refreshRadius          = frame.size.height / 2 * 0.8
        ovalShapeLayer.path        = UIBezierPath(ovalInRect: CGRect(x: frame.size.width / 2 - refreshRadius, y: frame.size.height / 2 - refreshRadius, width: 2 * refreshRadius, height: 2 * refreshRadius)).CGPath
        layer.addSublayer(ovalShapeLayer)
        
        let airplaneImage = UIImage(named: "airplane.png")
        airplaneLayer.contents = airplaneImage?.CGImage
        airplaneLayer.bounds   = CGRect(x: 0.0, y: 0.0, width: airplaneImage!.size.width, height: airplaneImage!.size.height)
        airplaneLayer.position = CGPoint(x: frame.size.width/2 + frame.size.height/2 * 0.8, y: frame.size.height/2)
        airplaneLayer.opacity  = 0.0
        layer.addSublayer(airplaneLayer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Scroll View Delegate methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = CGFloat( max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0))
        self.progress = min(max(offsetY / frame.size.height, 0.0), 1.0)
        
        if !isRefreshing {
            redrawFromProgress(self.progress)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && self.progress >= 1.0 {
            delegate?.refreshViewDidRefresh(self)
            beginRefreshing()
        }
    }
    
    // MARK: animate the Refresh View
    
    func beginRefreshing() {
        isRefreshing = true
        UIView.animateWithDuration(0.3, animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top += self.frame.size.height
            self.scrollView!.contentInset = newInsets
        })
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue   = 1.0
        let strokeEndAnimation   =  CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue   = 0.0
        strokeEndAnimation.toValue     = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration  = 1.5
        strokeAnimationGroup.repeatCount = 5.0
        strokeAnimationGroup.animations = [strokeStartAnimation,strokeEndAnimation]
        ovalShapeLayer.addAnimation(strokeAnimationGroup, forKey: nil)
        
        let flightAnimation = CAKeyframeAnimation(keyPath: "position")
        flightAnimation.path = ovalShapeLayer.path
        /*
         在关键帧动画中还有一个非常重要的参数,那便是calculationMode,计算模式.其主要针对的是每一帧的内容为一个座标点的情况,也就是对anchorPoint 和 position 进行的动画.当在平面座标系中有多个离散的点的时候,可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算. calculationMode目前提供如下几种模式：
         kCAAnimationLinear calculationMode的默认值,表示当关键帧为座标点的时候,关键帧之间直接直线相连进行插值计算;
         kCAAnimationDiscrete 离散的,就是不进行插值计算,所有关键帧直接逐个进行显示;
         kCAAnimationPaced 使得动画均匀进行,而不是按keyTimes设置的或者按关键帧平分时间,此时keyTimes和timingFunctions无效;
         kCAAnimationCubic 对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算，这里的主要目的是使得运行的轨迹变得圆滑；
         kCAAnimationCubicPaced 看这个名字就知道和kCAAnimationCubic有一定联系,其实就是在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,此时keyTimes以及timingFunctions也是无效的
         */
        flightAnimation.calculationMode = kCAAnimationPaced
        
        let airplaneOrientationAnimation = CABasicAnimation( keyPath: "transform.rotation")
        airplaneOrientationAnimation.fromValue = 0
        airplaneOrientationAnimation.toValue   = 2 * M_PI
        
        let flightAnimationGroup = CAAnimationGroup()
        flightAnimationGroup.duration = 1.5
        flightAnimationGroup.repeatCount = 5.0
        flightAnimationGroup.animations  = [flightAnimation,airplaneOrientationAnimation]
        airplaneLayer.addAnimation(flightAnimationGroup, forKey: nil)
        
        
    }
    
    func endRefreshing() {
        self.isRefreshing = false
        UIView.animateWithDuration(0.3, delay:0.0, options: .CurveEaseOut ,animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top -= self.frame.size.height
            self.scrollView!.contentInset = newInsets
            }, completion: {_ in
                self.airplaneLayer.removeAllAnimations()
                self.ovalShapeLayer.removeAllAnimations()
        })
    }
    
    func redrawFromProgress(progress: CGFloat) {
        ovalShapeLayer.strokeEnd = progress;
        airplaneLayer.opacity    = Float(progress)
    }
    
}