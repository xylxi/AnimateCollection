//
//  SLMenuItem.swift
//  SLStransform3DDemo
//
//  Created by WangZHW on 16/6/12.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

let slmenuColors = [
    UIColor(red: 249/255, green: 84/255,  blue: 7/255,   alpha: 1.0),
    UIColor(red: 69/255,  green: 59/255,  blue: 55/255,  alpha: 1.0),
    UIColor(red: 249/255, green: 194/255, blue: 7/255,   alpha: 1.0),
    UIColor(red: 32/255,  green: 188/255, blue: 32/255,  alpha: 1.0),
    UIColor(red: 207/255, green: 34/255,  blue: 156/255, alpha: 1.0),
    UIColor(red: 14/255,  green: 88/255,  blue: 149/255, alpha: 1.0),
    UIColor(red: 15/255,  green: 193/255, blue: 231/255, alpha: 1.0)
]

class SLMenuItem {
    
    let title: String
    let symbol: String
    let color: UIColor
    
    init(symbol: String, color: UIColor, title: String) {
        self.symbol = symbol
        self.color  = color
        self.title  = title
    }
    
    class var sharedItems: [SLMenuItem] {
        struct Static {
            static let items = SLMenuItem.sharedMenuItems()
        }
        return Static.items
    }
    
    class func sharedMenuItems() -> [SLMenuItem] {
        var items = [SLMenuItem]()
        
        items.append(SLMenuItem(symbol: "☎︎", color: slmenuColors[0], title: "Phone book"))
        items.append(SLMenuItem(symbol: "✉︎", color: slmenuColors[1], title: "Email directory"))
        items.append(SLMenuItem(symbol: "♻︎", color: slmenuColors[2], title: "Company recycle policy"))
        items.append(SLMenuItem(symbol: "♞", color: slmenuColors[3], title: "Games and fun"))
        items.append(SLMenuItem(symbol: "✾", color: slmenuColors[4], title: "Training programs"))
        items.append(SLMenuItem(symbol: "✈︎", color: slmenuColors[5], title: "Travel"))
        items.append(SLMenuItem(symbol: "🃖", color: slmenuColors[6], title: "Etc."))
        
        return items
    }
    
}

