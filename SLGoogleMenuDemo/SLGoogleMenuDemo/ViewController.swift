//
//  ViewController.swift
//  SLGoogleMenuDemo
//
//  Created by WangZHW on 16/6/4.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var menu: SLGoogleMenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        title = "首页"
        let menuOptions = SLMenuOptions(
            titles:["首页","消息","发布","发现","个人","设置"],
            buttonHeight: 40.0, menuColor: UIColor(red: 0.0, green: 0.722, blue: 1.0, alpha: 1.0),
            blurStyle: .Dark,
            buttonSpace: 30.0,
            menuBlankWidth: 50.0,
            menuClickBlock: { (index,title,titleCounts) in
                print("index:\(index) title:\(title), titleCounts:\(titleCounts)")
        })
        menu = SLGoogleMenuView(options: menuOptions)
    }

    @IBAction func clickBtn(sender: AnyObject) {
        menu?.trigger()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

