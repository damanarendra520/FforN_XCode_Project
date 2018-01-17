//
//  donationsTableViewController.swift
//  FforN
//
//  Created by Dama Narendra on 11/30/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit

class donationsTableViewController: UITableViewController {
    
    var donatins_list:[[String: AnyObject]] = []
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        
        print("in viewDidload")
        super.viewDidLoad()
        self.tableView.reloadData()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/getAllDonations.php")!)
        request.HTTPMethod = "POST"
        
        let postString = ""
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            if error != nil
            {
                return
            }
            
            NSString (data: data!, encoding: NSUTF8StringEncoding)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    
                    let resultvalue = parseJSON["error"] as? String
                    
                    if(resultvalue == "successful") {
                        
                        if let department = parseJSON["data"] as? [[String: AnyObject]] {
                            self.donatins_list = department
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
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.donatins_list.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("user_donation", forIndexPath: indexPath) as! donationdListTableViewCell
        
        // Configure the cell...
        cell.donationTitle.text = "" + (self.donatins_list[indexPath.row]["date_time"]! as! String) + " " + (self.donatins_list[indexPath.row]["address"]! as! String) + " " + (self.donatins_list[indexPath.row]["city"]! as! String)
        
        cell.donationSubtitle?.text = "" + (self.donatins_list[indexPath.row]["first_name"]! as! String) + " " + (self.donatins_list[indexPath.row]["last_name"]! as! String)
        
        return cell
    }
    
}
