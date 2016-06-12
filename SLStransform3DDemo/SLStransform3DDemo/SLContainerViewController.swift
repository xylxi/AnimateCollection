//
//  SLContainerViewController.swift
//  SLStransform3DDemo
//
//  Created by WangZHW on 16/6/12.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit
import QuartzCore

class SLContainerViewController: UIViewController {
    
    let menuWidth: CGFloat = 80.0
    let animationTime: NSTimeInterval = 0.5
    
    let menuViewController: UIViewController!
    let centerViewController: UIViewController!
    
    var isOpening = false
    
    init(sideMenu: UIViewController, center: UIViewController) {
        menuViewController = sideMenu
        centerViewController = center
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        setNeedsStatusBarAppearanceUpdate()
        
        addChildViewController(centerViewController)
        view.addSubview(centerViewController.view)
        centerViewController.didMoveToParentViewController(self)
        
        addChildViewController(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMoveToParentViewController(self)
        menuViewController.view.layer.anchorPoint.x = 1.0
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
        setToPercent(0.0)
        
        let panGesture = UIPanGestureRecognizer(target:self, action:#selector(SLContainerViewController.handleGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func handleGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(recognizer.view!.superview!)
        var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
        progress = min(max(progress, 0.0), 1.0)
        
        switch recognizer.state {
        case .Began:
            // 缓存image，防止抗锯齿效果
            menuViewController.view.layer.shouldRasterize = true
            menuViewController.view.layer.rasterizationScale =
                UIScreen.mainScreen().scale
            let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
            isOpening = isOpen == 1.0 ? false: true
            
        case .Changed:
            self.setToPercent(isOpening ? progress: (1.0 - progress))
            
        case .Ended: fallthrough
        case .Cancelled: fallthrough
        case .Failed:
            
            var targetProgress: CGFloat
            if (isOpening) {
                targetProgress = progress < 0.5 ? 0.0 : 1.0
            } else {
                targetProgress = progress < 0.5 ? 1.0 : 0.0
            }
            
            UIView.animateWithDuration(animationTime, animations: {
                self.setToPercent(targetProgress)
                }, completion: {_ in
                    // 取消缓存
                    self.menuViewController.view.layer.shouldRasterize = false
            })
            
        default: break
        }
    }
    
    func toggleSideMenu() {
        menuViewController.view.layer.shouldRasterize = true
        menuViewController.view.layer.rasterizationScale =
            UIScreen.mainScreen().scale
        let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
        let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0
        
        UIView.animateWithDuration(animationTime, animations: {
            self.setToPercent(targetProgress)
            }, completion: { _ in
                self.menuViewController.view.layer.shouldRasterize = false
                self.menuViewController.view.layer.shouldRasterize = false
        })
    }
    
    var vc: SLCenterViewController!
    
    func setToPercent(percent: CGFloat) {
        centerViewController.view.frame.origin.x = menuWidth * CGFloat(percent)
        menuViewController.view.layer.transform = menuTransformForPercent(percent)
        vc.menuButton?.rotate(percent)
    }
    
    
    
    func menuTransformForPercent(percent: CGFloat) -> CATransform3D {
        var identify = CATransform3DIdentity
        // 透视效果
        identify.m34 = -1.0 / 1000
        let remainingPercent = 1.0 - percent
        let angle = remainingPercent * CGFloat(-M_PI_2)
        let rotationTransfrom = CATransform3DRotate(identify, angle, 0.0, 1.0, 0.0)
        let translationTransfrom = CATransform3DMakeTranslation(menuWidth * percent, 0, 0)
        return CATransform3DConcat(rotationTransfrom, translationTransfrom)
    }
}