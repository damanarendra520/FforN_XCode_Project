//
//  signupViewController.swift
//  FforN
//
//  Created by Dama Narendra on 11/22/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit
import CoreLocation

class signupViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var signup_button: UIButton!
    
    var locationManger = CLLocationManager()
    var currentUserLocation: CLLocation?
    var latitude  = 0.0
    var longitude = 0.0
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        latitude = (userLocation.coordinate.latitude)
        longitude = (userLocation.coordinate.longitude)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManger.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidLoad()
        determineMyCurrentLocation()
    }
    
    
    func determineMyCurrentLocation() {
        locationManger = CLLocationManager()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManger.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signup(sender: AnyObject) {
        if first_name.text == "" || last_name.text == "" || email.text == "" || mobile.text == "" || user_name.text == "" || password.text == "" || address.text == "" || city.text == "" || state.text == "" || zip.text == "" {
            
            let alertController = UIAlertController(title: "Empty Field", message: "Please fill all the datafields.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
            
        }
        else{
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/insertUserData.php")!)
            request.HTTPMethod = "POST"
            
            let postString = "first_name=\(first_name.text!)&last_name=\(last_name.text!)&email=\(email.text!)&mobile=\(mobile.text!)&username=\(user_name.text!)&password=\(password.text!)&address=\(address.text!)&state=\(state.text!)&city=\(city.text!)&zip=\(zip.text!)&latString=\(latitude)&lngString=\(longitude)"
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                if responseString! == ""
                {
                    print("in if")
                }else{
                    print("in else")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            task.resume()
            
        }
    }
}
