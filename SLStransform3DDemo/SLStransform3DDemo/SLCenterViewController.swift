//
//  SLCenterViewController.swift
//  SLStransform3DDemo
//
//  Created by WangZHW on 16/6/12.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class SLCenterViewController: UIViewController {
    
    var menuItem: SLMenuItem! {
        didSet {
            title = menuItem.title
            view.backgroundColor = menuItem.color
            symbol.text = menuItem.symbol
        }
    }
    
    @IBOutlet var symbol: UILabel!
    
    // MARK: ViewController
    
    var menuButton: MenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = MenuButton()
        menuButton.tapHandler = {
            if let containerVC = self.navigationController?.parentViewController as? SLContainerViewController {
                containerVC.toggleSideMenu()
            }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        menuItem = SLMenuItem.sharedItems.first!
    }
    
}
