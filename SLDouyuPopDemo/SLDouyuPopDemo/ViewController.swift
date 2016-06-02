//
//  ViewController.swift
//  SLDouyuPopDemo
//
//  Created by WangZHW on 16/6/2.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit


class SLDouyu:NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let vc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let tovc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let container = transitionContext.containerView()!
        
        let bgView = UIView(frame: container.bounds)
        bgView.backgroundColor = .whiteColor()
        
        container.addSubview(bgView)
        container.addSubview(tovc.view)
        container.addSubview(vc.view)

        tovc.view.transform = CGAffineTransformMakeScale(0.95, 0.95)
        vc.view.frame = CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height)
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            vc.view.frame = CGRectMake(container.bounds.size.width, 0, container.bounds.size.width, container.bounds.size.height)
            tovc.view.transform = CGAffineTransformIdentity
            }) { (finish) in
                bgView.removeFromSuperview()
                tovc.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                print(tovc.navigationController?.view.subviews.count)
        }
        
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let popRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(ViewController.handlePopRecognizer(_:)))
        popRecognizer.edges = .Left
        self.view.addGestureRecognizer(popRecognizer)
    }
    
    func handlePopRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) -> Void {
        var progress = recognizer.translationInView(self.view).x / self.view.bounds.size.width
        progress = min(1.0, max(0, progress))
        
        switch recognizer.state {
        case .Began:
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            self.interactivePopTransition.updateInteractiveTransition(progress)
        case .Ended ,.Cancelled:
            if progress > 0.5 {
                self.interactivePopTransition.finishInteractiveTransition()
            }else {
                self.interactivePopTransition.cancelInteractiveTransition()
            }
            self.interactivePopTransition = nil
        default:
            self.interactivePopTransition.cancelInteractiveTransition()
            self.interactivePopTransition = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        self.navigationController?.delegate = self;
    }

    @IBAction func buttonBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Pop:
            return SLDouyu()
        case .Push:
            return nil
        default:
            return nil;
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is SLDouyu {
            return self.interactivePopTransition
        }else {
            return nil
        }
    }
}