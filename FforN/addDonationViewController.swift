//
//  addDonationViewController.swift
//  FforN
//
//  Created by Dama Narendra on 11/30/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit
import AssetsLibrary
import CoreLocation

class addDonationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var donation_type: UITextField!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperChanged(sender: UIStepper) {
        quantityLabel.text = Int(sender.value).description
        
    }
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var state: UITextField!
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        
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
    
    @IBAction func uploadData(sender: AnyObject) {
        
        let logindetails = NSUserDefaults.standardUserDefaults()
        let user_id = logindetails.stringForKey("id_user")
        

        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/addDonations.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "quntity_type=\(donation_type.text!)&quantity=\(quantityLabel.text!)&amount=\(amount.text!)&address=\(address.text!)&city=\(city.text!)&state=\(state.text!)&latString=\(latitude)&lngString=\(longitude)&user_id=\(user_id!)"
        
        
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

                        self.dismissViewControllerAnimated(true, completion: nil)
                        
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
            
        }
        task.resume()
        
    }
    
//
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .ScaleAspectFit
//            imageView.image = pickedImage
//        }
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
//    @IBAction func uploadData(sender: AnyObject) {
//        
//        let myUrl = "http://localhost:8888/FforN/addDonations.php"
//        
//        guard let endpoint = NSURL(string: myUrl) else { print("Error creating endpoint");return }
//        
//        let request = NSMutableURLRequest(URL: endpoint)
//        request.HTTPMethod = "POST"
//        
//        print(currentUserLocation?.coordinate.latitude)
//        
//        
//        let latString = String((currentUserLocation?.coordinate.latitude)!)
//        let lngString = String((currentUserLocation?.coordinate.longitude)!)
//        
////
//        let param = [
//            "donation_type" :   donation_type,
//            "quantity"      :   quantityLabel,
//            "amount"        :   amount,
//            "address"       :   address,
//            "city"          :   city,
//            "state"         :   state,
//            "gps_lat"       :   latString,
//            "gps_lng"       :   lngString
//        ]
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
//        
//        if(imageData==nil)  { return; }
//        
//        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file1", imageDataKey: imageData!, boundary: boundary)
//        
//        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
//            do {
//                // print(data)
//                guard let dat = data else { throw JSONError.NoData }
//                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
//                print(json)
//                // print ("photo uploaded")
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                    self.imageView.image = nil;
//                    print ("photo uploaded")
//                    let alert = UIAlertController(title: "Photo Upload", message:"Success!!", preferredStyle: .Alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
//                    self.presentViewController(alert, animated: true){}
//                })
//                
//            } catch let error as JSONError {
//                print("Error **** Error")
//                print(error.rawValue)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                    self.imageView.image = nil
//                    let alert = UIAlertController(title: "Photo Update Error", message:"Success!!", preferredStyle: .Alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
//                    self.presentViewController(alert, animated: true){}
//                    print ("photo not uploaded")
//                })
//                
//            } catch {
//                print("**** Error")
//                print(error)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.imageView.image = nil;
//                    let alert = UIAlertController(title: "Photo Upload Error 2", message:"Success!!", preferredStyle: .Alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
//                    self.presentViewController(alert, animated: true){}
//                    print ("photo not uploaded?")
//                })
//                
//            }
//            }
//            .resume()
//        }
//    }
//
//    func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().UUIDString)"
//    }
//
//    func createBodyWithParameters(parameters: [String: NSObject]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//        let body = NSMutableData();
//    
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//    
//        let randomNumber = (arc4random() % 99999) + 10001;
//    
//    
//        let myString:String = String(randomNumber)
//    
//        let filename = "IMG-" + myString + ".jpg"
//        print (filename)
//        let mimetype = "image/jpg"
//    
//        body.appendString("--\(boundary)\r\n")
//        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
//    
//        body.appendData(imageDataKey)
//        body.appendString("\r\n")
//    
//        body.appendString("--\(boundary)--\r\n")
//    
//        return body
//    }
//
//    extension NSMutableData {
//    
//    func appendString(string: String) {
//        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        appendData(data!)
//    }
}

