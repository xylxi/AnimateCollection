//
//  SLGoogleMenuView.swift
//  SLGoogleMenuDemo
//
//  Created by WangZHW on 16/6/4.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import Foundation
import UIKit

typealias MenuButtonClickedBlock = (index: Int, title: String, titleCounts: Int)->()

struct SLMenuOptions {
    var titles: [String]
    var buttonHeight: CGFloat
    var menuColor: UIColor
    var blurStyle: UIBlurEffectStyle
    var buttonSpace: CGFloat
    //  扩展区域，为了显示弹性的View
    var menuBlankWidth: CGFloat
    var menuClickBlock: MenuButtonClickedBlock
}

class SLGoogleMenuView: UIView {
    
    private let options: SLMenuOptions
    private var triggered: Bool = false
    private var diff: CGFloat   = 0
    private var displayLink: CADisplayLink?
    // 记录动画的个数
    private var animationCount  = 0
    
    private var keyWindow: UIWindow?
    private var blurView: UIVisualEffectView!
    private var helperSideView: UIView!
    private var helperCenterView: UIView!
    
    
    init(options: SLMenuOptions) {
        self.options = options
        if let kWindow = UIApplication.sharedApplication().keyWindow{
            keyWindow = kWindow
            let frame = CGRect(
                x: -kWindow.frame.size.width/2 - options.menuBlankWidth,
                y: 0,
                width: kWindow.frame.size.width/2 + options.menuBlankWidth,
                height: kWindow.frame.size.height)
            super.init(frame:frame)
        } else {
            super.init(frame:CGRectZero)
        }
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: frame.width - options.menuBlankWidth, y: 0))
        path.addQuadCurveToPoint(CGPoint(x: frame.width - options.menuBlankWidth, y: frame.height), controlPoint: CGPoint(x: frame.width - options.menuBlankWidth+diff, y: frame.height/2))
        path.addLineToPoint(CGPoint(x: 0, y: frame.height))
        path.closePath()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path.CGPath)
        options.menuColor.set()
        CGContextFillPath(context)
    }
    
}
extension SLGoogleMenuView {
    private func setUpViews() {
        if let keyWindow = keyWindow {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: self.options.blurStyle))
            blurView.frame = keyWindow.frame
            blurView.alpha = 0.0
            
            // 开始快速
            helperSideView = UIView(frame: CGRect(x: -40, y: 0, width: 40, height: 40))
            helperSideView.backgroundColor = UIColor.redColor()
            helperSideView.hidden = true
            keyWindow.addSubview(helperSideView)
            
            // 开始慢速
            helperCenterView = UIView(frame: CGRect(x: -40, y: CGRectGetHeight(keyWindow.frame)/2 - 20, width: 40, height: 40))
            helperCenterView.backgroundColor = UIColor.yellowColor()
            helperCenterView.hidden = true
            keyWindow.addSubview(helperCenterView)
            
            backgroundColor = UIColor.clearColor()
            keyWindow.insertSubview(self, belowSubview: helperSideView)
            addButton()
        }
    }
    
    func addButton() {
        let titles = self.options.titles
        if titles.count % 2 == 0 {
            var index_down = titles.count / 2
            var index_up = -1
            for i in 0..<titles.count {
                let title = titles[i]
                let buttonOption = SLItemData(title:title, buttonColor:self.options.menuColor, buttonClosure:{ [weak self] () -> () in
                    self?.tapToUntrigger()
                    self!.options.menuClickBlock(index: i,title: title,titleCounts: titles.count)
                    })
                let home_button = SLItemView(itemData: buttonOption)
                home_button.bounds = CGRectMake(0, 0, frame.width - self.options.menuBlankWidth - 20*2, self.options.buttonHeight);
                addSubview(home_button)
                if (i >= titles.count / 2) {
                    index_up += 1
                    let y = frame.height/2 + self.options.buttonHeight*CGFloat(index_up) + self.options.buttonSpace*CGFloat(index_up)
                    home_button.center = CGPoint(x: (frame.width - self.options.menuBlankWidth)/2, y: y+self.options.buttonSpace/2 + self.options.buttonHeight/2)
                } else {
                    index_down -= 1
                    let y = frame.height/2 - self.options.buttonHeight*CGFloat(index_down) - self.options.buttonSpace*CGFloat(index_down)
                    home_button.center = CGPoint(x: (frame.width - self.options.menuBlankWidth)/2, y: y - self.options.buttonSpace/2 - self.options.buttonHeight/2)
                }
            }
        } else {
            var index = (titles.count-1) / 2 + 1
            for i in 0..<titles.count {
                index -= 1
                let title = titles[i]
                let buttonOption = SLItemData(title: title, buttonColor: self.options.menuColor, buttonClosure: { [weak self] () -> () in
                    self?.tapToUntrigger()
                    self!.options.menuClickBlock(index: i, title: title, titleCounts: titles.count)
                    })
                let home_button = SLItemView(itemData: buttonOption)
                home_button.bounds = CGRect(x: 0, y: 0, width: frame.width - self.options.menuBlankWidth - 20*2, height: self.options.buttonHeight)
                home_button.center = CGPoint(x: (frame.width - self.options.menuBlankWidth)/2, y: frame.height/2 - self.options.buttonHeight*CGFloat(index) - 20*CGFloat(index))
                addSubview(home_button)
            }
        }
    }
    
    func trigger() {
        if !self.triggered {
            if let keyWindow = keyWindow {
                keyWindow.insertSubview(blurView, belowSubview: self)
                UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
                    self?.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: keyWindow.frame.size.width/2 + self!.options.menuBlankWidth,
                        height: keyWindow.frame.size.height)
                    })
                
                beforeAnimation()
                UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { [weak self] () -> Void in
                    self?.helperSideView.center = CGPointMake(keyWindow.center.x, self!.helperSideView.frame.size.height/2);
                    }, completion: { [weak self] (finish) -> Void in
                        self?.finishAnimation()
                    })
                
                UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
                    self?.blurView.alpha = 1.0
                    })
                
                beforeAnimation()
                UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { [weak self] () -> Void in
                    self?.helperCenterView.center = keyWindow.center
                    }, completion: { [weak self] (finished) -> Void in
                        if finished {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SLGoogleMenuView.tapToUntrigger))
                            self?.blurView.addGestureRecognizer(tapGesture)
                            self?.finishAnimation()
                        }
                    })
                animateButtons()
            }
        }else {
            
        }
    }
    
    // 设置CADisplayLink
    func beforeAnimation() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(SLGoogleMenuView.handleDisplayLinkAction(_:)))
            displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
        animationCount += 1
    }
    func finishAnimation() {
        animationCount -= 1
        if animationCount == 0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    // 获取实时的diff
    @objc func handleDisplayLinkAction(link: CADisplayLink) {
        let sideHelperPresentationLayer = helperSideView.layer.presentationLayer() as! CALayer
        let centerHelperPresentationLayer = helperCenterView.layer.presentationLayer() as! CALayer
        
        let centerRect = centerHelperPresentationLayer.valueForKeyPath("frame")?.CGRectValue
        let sideRect   = sideHelperPresentationLayer.valueForKeyPath("frame")?.CGRectValue
        
        if let centerRect = centerRect, sideRect = sideRect {
            diff = sideRect.origin.x - centerRect.origin.x
        }
        setNeedsDisplay()
    }
    
    @objc func tapToUntrigger() {
        UIView.animateWithDuration(0.3) { [weak self] () -> Void in
            self?.frame = CGRect(
                x: -self!.keyWindow!.frame.size.width/2 - self!.options.menuBlankWidth,
                y: 0,
                width: self!.keyWindow!.frame.size.width/2 + self!.options.menuBlankWidth,
                height: self!.keyWindow!.frame.size.height)
        }
        
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { () -> Void in
            self.helperSideView.center = CGPoint(x: -self.helperSideView.frame.height/2, y: self.helperSideView.frame.height/2)
        }) { [weak self] (finish) -> Void in
            self?.finishAnimation()
        }
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.blurView.alpha = 0.0
        }
        
        beforeAnimation()
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { () -> Void in
            self.helperCenterView.center = CGPointMake(-self.helperSideView.frame.size.height/2, CGRectGetHeight(self.frame)/2)
        }) { (finish) -> Void in
            self.finishAnimation()
        }
        triggered = false
    }
    
    func animateButtons() {
        for i in 0..<subviews.count {
            let menuButton = subviews[i]
            menuButton.transform = CGAffineTransformMakeTranslation(-90, 0)
            UIView.animateWithDuration(0.7, delay: Double(i)*(0.3/Double(subviews.count)), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.BeginFromCurrentState,.AllowUserInteraction], animations: { () -> Void in
                menuButton.transform =  CGAffineTransformIdentity
                }, completion: nil)
        }
    }
}


