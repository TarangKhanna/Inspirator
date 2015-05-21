//
//  ViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/13/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
var shown : Bool = false
let kSuccessTitle = "Congratulations"
let kErrorTitle = "Connection error"
let kNoticeTitle = "Notice"
let kWarningTitle = "Warning"
let kInfoTitle = "Randomized"
let kSubtitle = "Get Going!"

let kDefaultAnimationDuration = 2.0


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    let manager = DataSource()
    var motivate = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motivate = manager.getMotivated()
        //let navBar = self.navigationController!.navigationBar
        //navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        //navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG.png")!)
        //self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        var footer =  UIView(frame: CGRectZero)
        tableView.tableFooterView = footer
        tableView.tableFooterView!.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
                let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(shown, forKey: "shown")
        userDefaults.synchronize()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.motivate.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let motivate1 = self.motivate[indexPath.row] as? Motivate
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? MotivationCell!
        cell!.MainText?.text = motivate1?.title
        cell!.backgroundColor = motivate1?.color
        cell!.MainIndex.text = "\(indexPath.row+1)"
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        //var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.greenColor()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 1) {
            //WeightsVC.view.backgroundColor = UIColor.greenColor()
            performSegueWithIdentifier("Weights", sender: self)
            if(!shown) {
              SCLAlertView().showInfo(kInfoTitle, subTitle: kSubtitle)
              shown = true
            }
        } else if(indexPath.row == 2) {
            performSegueWithIdentifier("Programming", sender: self)
        } else if(indexPath.row == 4) {
            performSegueWithIdentifier("Pure", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tableView.contentInset = UIEdgeInsetsMake(0,0,70,0)
    }
    

}

