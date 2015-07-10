//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Parse

class MenuController: UITableViewController {
    
    @IBOutlet weak var userPhoto: AvatarImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewWillAppear(animated: Bool) {
        var currentUser = PFUser.currentUser()
        usernameLabel.text = currentUser?.username
        // set this image at time of signup / signin 
        var queryUser = PFUser.query() as PFQuery?
        queryUser!.findObjectsInBackgroundWithBlock {
            (users: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let users = users as? [PFObject] {
                    for user in users {
                        var user2:PFUser = user as! PFUser
                        if user2.username == self.usernameLabel.text
                        {
                            var userPhotoFile = user2["ProfilePicture"] as! PFFile
                            userPhotoFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                
                                if let downloadedImage = UIImage(data: data!) {
                                    self.userPhoto.image  = downloadedImage
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.MKColor.Red
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var recipients2 = [String]()
        if (segue.identifier == "profileView2") { //pass data to VC
            var svc = segue.destinationViewController.topViewController as! profileVC
            let selectedUser = PFUser.currentUser()
            svc.name = selectedUser?.username! as String!
            svc.score = "0" //selectedUser["score"] as! String
            svc.show = true
            svc.canChange = true
            //svc.profileObject =
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
