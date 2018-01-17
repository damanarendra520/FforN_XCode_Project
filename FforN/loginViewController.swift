//
//  loginViewController.swift
//  FforN
//
//  Created by Dama Narendra on 11/18/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit
import CoreData

class loginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var txtusername: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var data: NSArray = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var editedTextField: UITextField?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let logindetails = NSUserDefaults.standardUserDefaults()
        let user_name = logindetails.stringForKey("user_name")
        if user_name != "nil" {
            self.performSegueWithIdentifier("login_access", sender: self);
        }
        
    }

    
    @IBAction func login(sender: AnyObject) {

        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/index.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "user_name=\(txtusername.text!)&password=\(txtpassword.text!)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        
        let task = NSURLSession.sharedSession().dataTaskWithRequest (request){
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            let responseString =  NSString (data: data!, encoding: NSUTF8StringEncoding)
            print ("response String: \(responseString)");
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers
                    ) as? NSDictionary
                
                if  let parseJSON = json {
                    
                    let resultvalue = parseJSON["error"] as? String
                    
                    if(resultvalue == "successful") {
                        
                        let data:Dictionary<String, AnyObject> = (parseJSON["data"] as? Dictionary)!
                        
                        let logindetails = NSUserDefaults.standardUserDefaults()
                        logindetails.setValue(data["username"] , forKey: "user_name")
                        logindetails.setValue(data["id_users"], forKey: "id_user")
                        
                        //self.performSegueWithIdentifier("login_access", sender: self);
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(),{
                            let alertController = UIAlertController(title: "Error", message: "Error in login", preferredStyle: .Alert)
                            
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
                print(error)
            }
            //self.performSegueWithIdentifier("login_access", sender: self);
        }
        task.resume()
        let logindetails = NSUserDefaults.standardUserDefaults()
        let user_name = logindetails.stringForKey("user_name")
        if user_name != "nil" {
            allow_access()
        }
        
    }
    
    func allow_access(){
        self.performSegueWithIdentifier("login_access", sender: self);
    }
    
}
