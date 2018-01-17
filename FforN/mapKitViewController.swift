//
//  mapKitViewController.swift
//  FforN
//
//  Created by Dama Narendra on 11/28/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//


import UIKit
import MapKit
import ImageIO
import CoreImage
import CoreLocation

class mapKitViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let annotation = MKPointAnnotation()
    var images_data:[[String: String]] = []
    var user_data:[[String: String]] = []
    var address_array:[String] = []
    var locationManager = CLLocationManager()
    var currentUserLocation: CLLocation?
    let geocoder = CLGeocoder()
    
    var annotations = [MKAnnotation]()
    
    typealias waypointInfo = Dictionary<String,AnyObject>
    var waypoint:waypointInfo = waypointInfo()
    var waypoints = [waypointInfo]()
    
    @IBOutlet weak var mapsegment: UISegmentedControl!
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        if mapsegment.selectedSegmentIndex == 0 {
            print("image")
        }
        else{
            print("people")
        }
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization();
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        

        mapView.mapType = .Standard
        mapView.delegate = self
        
        print(self.images_data)
        if self.images_data.count != 0
        {
            var i = 0
            while i < self.images_data.count {
                _ = "" + (self.images_data[i]["address"]! ) + ", " + (self.images_data[i]["city"]!) + ", " + (self.images_data[i]["state"]!) + ", " + (self.images_data[i]["country"]! )
                
                let latituteString : String = self.images_data[i]["gps_lat"]!
                let longitudeString : String = self.images_data[i]["gps_lng"]!
                
                let latitudeDegrees:CLLocationDegrees = Double(latituteString)!
                let longitudeDegrees:CLLocationDegrees = Double(longitudeString)!
                
                //let initialLocation : CLLocation = CLLocation.init(latitude: latitudeDegrees, longitude: longitudeDegrees)
                
                let initialLocation = CLLocationCoordinate2D(latitude: latitudeDegrees, longitude: longitudeDegrees)
                
                let location = initialLocation
                let region = MKCoordinateRegionMake(location, self.span)
                self.mapView.setRegion(region, animated: true)
                
                self.annotation.coordinate = initialLocation
                self.annotation.title = "" + (self.images_data[i]["address"]! ) + ", " + (self.images_data[i]["city"]!)
                self.annotation.subtitle = (self.images_data[i]["state"]!)
                
                self.annotations.append(self.annotation)
                
                mapView.addAnnotation(annotation)
                //mapView.showAnnotations(annotations, animated: true)
                i = i + 1
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8888/FforN/getDataForMapView.php")!)
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
                        
                        let image_data = parseJSON["donations"] as? [[String: String]]
                        self.images_data = image_data!
                        
                        let users_data = parseJSON["users"] as? [[String: String]]
                        self.user_data = users_data!
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
    
    @IBAction func reloadMapView(sender: AnyObject) {
       
         //super.viewDidLoad()
       // super.viewWillAppear(true)
        self.viewDidLoad();
        
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _:CLLocationCoordinate2D = manager.location!.coordinate
        
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = Constants.AnnotationViewReuseIdentifier
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = UIColor.blueColor()
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        pinView!.leftCalloutAccessoryView = nil
        pinView!.rightCalloutAccessoryView = nil
        pinView!.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
        
        pinView!.draggable = annotation is EditableMapPin
        
        if annotation is EditableMapPin
        {
            pinView!.rightCalloutAccessoryView =  UIButton(type: UIButtonType.DetailDisclosure)
        }
        else {
            pinView!.rightCalloutAccessoryView = UIButton (type: UIButtonType.InfoLight)
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let waypoint = view.annotation as? MapPin {
            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIButton {
                if (waypoint is EditableMapPin) {
                    print(waypoint.coordinate)
                    
                }
                else {
                    let imageName = waypoint.title
                    let urlpath = NSBundle.mainBundle().pathForResource(imageName, ofType: "JPG")
                    let url:NSURL = NSURL.fileURLWithPath(urlpath!)
                    if let imageData = NSData(contentsOfURL: url) { // blocks main thread!
                        if let image = UIImage(data: imageData) {
                            thumbnailImageView.setImage(image, forState: .Normal)
                        }
                    }
                }
                
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(view.annotation!.coordinate)
        if (control == view.leftCalloutAccessoryView) {
            performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
        }
        else {
            print ("need to show directions")
            
            performSegueWithIdentifier(Constants.ShowDirectionsSegue, sender: view)
        }
    }
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "ShowImageSegue"
        static let ShowDirectionsSegue = "DirectionsSegue"
    }
    
}
