//
//  SLGoogleItemView.swift
//  SLGoogleMenuDemo
//
//  Created by WangZHW on 16/6/4.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import Foundation
import UIKit

struct SLItemData {
    let title: String
    let buttonColor: UIColor
    let buttonClosure: ()->()
}

class SLItemView: UIView {
    init(itemData: SLItemData) {
        self.itemData = itemData
        super.init(frame: CGRectZero)
        self.backgroundColor = .clearColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let itemData: SLItemData
    
    override func drawRect(rect: CGRect) {
        let _ = UIGraphicsGetCurrentContext()
        // 边框
        let path = UIBezierPath(roundedRect: CGRectInset(rect, 1, 1), cornerRadius: rect.size.height / 2)
        path.lineWidth = 2
        UIColor.whiteColor().setStroke()
        itemData.buttonColor.setFill()
        path.stroke()
        path.fill()
        
        
        // 文字
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .Center
        let attr = [NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: UIFont.systemFontOfSize(17.0),NSForegroundColorAttributeName: UIColor.whiteColor()]
        let size = itemData.title.sizeWithAttributes(attr)
        
        let r = CGRectMake(rect.origin.x,
                           rect.origin.y + (rect.size.height - size.height)/2.0,
                           rect.size.width,
                           size.height)
        itemData.title.drawInRect(r, withAttributes: attr)
    }
}




