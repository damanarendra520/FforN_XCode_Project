//
//  friendsDetailsViewController.swift
//  FforN
//
//  Created by Dama Narendra on 12/8/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit

var user_data:[[String: AnyObject]] = []

class friendsDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var selected_user = [String: AnyObject] ()
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userMobile: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var userDonations: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        _ = getUserData((selected_user["id_users"] as? String)!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.blackColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        userName.text = ((selected_user["first_name"]!) as! String) + " " + ((selected_user["last_name"]!) as! String)
        userMobile.text = selected_user["mobile"]! as? String
        userEmail.text = selected_user["email"]! as? String
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getUserData(user_id: String)-> [[String: AnyObject]] {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/getDonationsByUser.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "id_user=\(user_id)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            let _ =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    let resultvalue = parseJSON["error"] as? String
                    if(resultvalue == "successful") {
                        if let department = parseJSON["data"] as? [[String: AnyObject]] {
                            user_data = department
                        }
                        
                        self.viewDidLoad()
                        
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(),{
                            print("in error")
                        })
                    }
                }
                
            } catch {
            }
            
        }
        task.resume()

        return user_data
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return user_data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("donation_list", forIndexPath: indexPath) as! FriendsDonatinsTableViewCell
        // Configure the cell...
        
        cell.donationDateAddress.text = "" + (user_data[indexPath.row]["date_time"]! as! String) + " " + (user_data[indexPath.row]["address"]! as! String)
        
        cell.donationQuantity.text = "" + (user_data[indexPath.row]["type"]! as! String) + " " + (user_data[indexPath.row]["quantity"]! as! String)
        
        cell.donationAmount.text = (user_data[indexPath.row]["amount"]! as! String)
        
        return cell
    }
    
}
