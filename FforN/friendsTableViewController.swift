//
//  friendsTableViewController.swift
//  FforN
//
//  Created by Dama Narendra on 12/7/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit

class friendsTableViewController: UITableViewController {

    var selectedRow:Int = 0
    var user_data:[[String: AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/getUsers.php")!)
        request.HTTPMethod = "POST"
        
        let postString = ""
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            if error != nil
            {
                return
            }
            
            let _ = NSString (data: data!, encoding: NSUTF8StringEncoding)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    
                    let resultvalue = parseJSON["error"] as? String
                    
                    if(resultvalue == "successful") {
                        
                        if let department = parseJSON["data"] as? [[String: AnyObject]] {
                            self.user_data = department
                            //print(self.user_data)
                        }
                        self.tableView.reloadData()
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(),{
                            let alertController = UIAlertController(title: "Error", message: "No Friends", preferredStyle: .Alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                // ...
                            }
                            alertController.addAction(OKAction)
                            
                            self.presentViewController(alertController, animated: true) {
                                // ...
                            }
                        })
                        
                    }
                }
                
            } catch {
            }
            
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.user_data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friend", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "" + (self.user_data[indexPath.row]["first_name"]! as! String) + " " + (self.user_data[indexPath.row]["last_name"]! as! String)
      
        cell.detailTextLabel?.text = "" + (self.user_data[indexPath.row]["address"]! as! String) + " " + (self.user_data[indexPath.row]["city"]! as! String)
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "freinds_segue") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let seleted_friend = self.user_data[indexPath.row]
                let dvc = segue.destinationViewController as! friendsDetailsViewController
                dvc.selected_user = seleted_friend
            }
        }
        
    }
    
}
