//
//  profileViewController.swift
//  FforN
//
//  Created by Dama Narendra on 12/9/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit
import CoreData

class profileViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        let logindetails = NSUserDefaults.standardUserDefaults()
        logindetails.setValue("nil", forKey: "user_name")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
