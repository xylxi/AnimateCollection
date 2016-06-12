//
//  SLSideMenuViewController.swift
//  SLStransform3DDemo
//
//  Created by WangZHW on 16/6/12.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

class SLSideMenuViewController: UITableViewController {
    
    var centerViewController: SLCenterViewController!
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return SLMenuItem.sharedItems.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath:indexPath) as UITableViewCell
        
        let menuItem = SLMenuItem.sharedItems[indexPath.row]
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 36.0)
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.text = menuItem.symbol
        
        cell.contentView.backgroundColor = menuItem.color
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView  {
        return tableView.dequeueReusableCellWithIdentifier("HeaderCell")!
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        centerViewController.menuItem = SLMenuItem.sharedItems[indexPath.row]
        
        let containerVC = parentViewController as! SLContainerViewController
        containerVC.toggleSideMenu()
    }
    
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        return 84.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
}
