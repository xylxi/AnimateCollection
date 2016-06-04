//
//  SLCircleLayer.swift
//  SLAnimationCircleDemo
//
//  Created by WangZHW on 16/6/4.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

enum MovingPoint {
    case POINT_B
    case POINT_D
}

let outSideRectSize: CGFloat = 90

class SLCircleLayer: CALayer {

    var progress: CGFloat = 0.5 {
        didSet {
            if progress < 0.5 {
                movePoint = .POINT_B
            }else {
                movePoint = .POINT_D
            }
            // 计算出偏移量 frame.size.with - outSideRectSize 结果为可以移动的长度
            // buff可以计算出，左右移动的距离  0.5为中心点
            let buff = (progress - 0.5) * (frame.size.width - outSideRectSize)
            // position为锚点的位置(默认为0.5,0.5)-->所以origin.x为position.x在-layer的宽度的一般
            // +buff为移动后的位置
            let origin_X = self.frame.width / 2 - outSideRectSize / 2 + buff
            let origin_Y = self.frame.height / 2 - outSideRectSize / 2
            // 外接矩形
            outsideRect  = CGRect(x: origin_X, y: origin_Y, width: outSideRectSize, height: outSideRectSize)
            self.setNeedsDisplay()
        }
    }
    
    private lazy var outsideRect: CGRect! = CGRectMake(self.frame.width / 2 - outSideRectSize / 2, self.frame.height / 2 - outSideRectSize / 2, outSideRectSize, outSideRectSize)
    private var movePoint: MovingPoint = .POINT_B
    
    override func drawInContext(ctx: CGContext) {
        let offset = outsideRect.width / 3.6 // 研究结果，画一个圆 1 / 3.6
        let movedDistance = (outsideRect.width / 6) * 2 * fabs(progress - 0.5)
        let rectCenter = CGPointMake(CGRectGetMidX(outsideRect) , CGRectGetMidY(outsideRect))
        
        let pointA = CGPointMake(rectCenter.x ,outsideRect.origin.y + movedDistance)
        let pointB = CGPointMake(movePoint == .POINT_D ? rectCenter.x + outsideRect.size.width/2 : rectCenter.x + outsideRect.size.width/2 + movedDistance*2 ,rectCenter.y)
        let pointC = CGPointMake(rectCenter.x ,CGRectGetMaxY(outsideRect) - movedDistance)
        let pointD = CGPointMake(movePoint == .POINT_D ? outsideRect.origin.x - movedDistance*2 : outsideRect.origin.x, rectCenter.y)
        
        let c1 = CGPointMake(pointA.x + offset, pointA.y)
        let c2 = CGPointMake(pointB.x, self.movePoint == .POINT_D ? pointB.y - offset : pointB.y - offset + movedDistance)
        
        let c3 = CGPointMake(pointB.x, self.movePoint == .POINT_D ? pointB.y + offset : pointB.y + offset - movedDistance)
        let c4 = CGPointMake(pointC.x + offset, pointC.y)
        
        let c5 = CGPointMake(pointC.x - offset, pointC.y)
        let c6 = CGPointMake(pointD.x, self.movePoint == .POINT_D ? pointD.y + offset - movedDistance : pointD.y + offset)
        
        let c7 = CGPointMake(pointD.x, self.movePoint == .POINT_D ? pointD.y - offset + movedDistance : pointD.y - offset)
        let c8 = CGPointMake(pointA.x - offset, pointA.y)
        
        
        let path = UIBezierPath(rect: outsideRect)
        CGContextAddPath(ctx, path.CGPath)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(ctx, 1.0)
        // 关于虚线，绘制20后，过5，在绘制20
        let dash = [CGFloat(20.0), CGFloat(5.0)]
        CGContextSetLineDash(ctx, 0.0, dash, 2)
        CGContextStrokePath(ctx)
        
        // 当path绘制完后，改path就在画布上清除了
        // 所以下面的path绘制，不会收到上面的影响
        
        let ovalPath = UIBezierPath()
        ovalPath.moveToPoint(pointA)
        ovalPath.addCurveToPoint(pointB, controlPoint1: c1, controlPoint2: c2)
        ovalPath.addCurveToPoint(pointC, controlPoint1: c3, controlPoint2: c4)
        ovalPath.addCurveToPoint(pointD, controlPoint1: c5, controlPoint2: c6)
        ovalPath.addCurveToPoint(pointA, controlPoint1: c7, controlPoint2: c8)
        ovalPath.closePath()
        
        CGContextAddPath(ctx, ovalPath.CGPath)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
        CGContextSetLineDash(ctx, 0, nil, 0) // 清楚虚线效果
        CGContextDrawPath(ctx, .FillStroke)//同时给线条和线条包围的内部区域填充颜色
        
    }
    
}
