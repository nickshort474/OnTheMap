//
//  MapViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController:UIViewController,MKMapViewDelegate{
    
    @IBOutlet weak var MapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    var logoutButton:UIBarButtonItem?
    var refreshMapButton:UIBarButtonItem?
    var postMapButton:UIBarButtonItem?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MapView.delegate = self
        
        logoutButton = UIBarButtonItem(title:"Logout", style: .Plain, target: self, action: "logout")
        refreshMapButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshData")
        postMapButton = UIBarButtonItem(image: UIImage(named:"Pin"), style: .Plain, target: self, action: "postNewData")
        
        self.parentViewController!.navigationItem.leftBarButtonItem = logoutButton
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshMapButton!,postMapButton!]
        
        
        MapAppClient.sharedInstance().getStudentLocation(){
            (result,error) in
            
            if let result = result{
               
                // parse JSON into results dictionary
                let results = result["results"] as! [[String:AnyObject]]
                
                
                // save in shared studentLocations Array
                StudentLocations.createStudentArray(results)
                
                self.addDataToMap(results)
                
               /* for value in results{
                    
                    // assign needed data to locations dictionary to be used on map
                    let lat = CLLocationDegrees(value["latitude"] as! Double)
                    let long = CLLocationDegrees(value["longitude"] as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = value["firstName"] as! String
                    let last = value["lastName"] as! String
                    let mediaURL = value["mediaURL"] as! String
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    self.annotations.append(annotation)
                }*/
            }
            //self.MapView.addAnnotations(self.annotations)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        // clear then reload buttons for when tab changes back from table view
        self.parentViewController!.navigationItem.rightBarButtonItems = []
        
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshMapButton!,postMapButton!]
    }
    
    
    
    
    
    
    func addDataToMap(results:[[String:AnyObject]]){
        print("adding data to map")
        for value in results{
            
            // assign needed data to locations dictionary to be used on map
            let lat = CLLocationDegrees(value["latitude"] as! Double)
            let long = CLLocationDegrees(value["longitude"] as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = value["firstName"] as! String
            let last = value["lastName"] as! String
            let mediaURL = value["mediaURL"] as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
        }
        self.MapView.addAnnotations(self.annotations)
    }
    
   
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }else{
            pinView!.annotation = annotation
        }
            
        return pinView
    }
        
        
        // This delegate method is implemented to respond to taps. It opens the system browser
        // to the URL specified in the annotationViews subtitle property.
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
    
    func logout(){
        MapAppClient.sharedInstance().logoutSession()
    }

    
    func refreshData(){
        print("refreshing map")
        MapAppClient.sharedInstance().getStudentLocation(){
            (result,error) in
            if let result = result{
                print("new results")
                // parse JSON into results dictionary
                let results = result["results"] as! [[String:AnyObject]]
                
                
                // save new data in shared studentLocations Array
                StudentLocations.createStudentArray(results)
                
                // recall addDataToMap function to reload data
                self.addDataToMap(results)
            }
            
        }
    }
    
       
    
    func postNewData(){
        let informationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationViewController")
        
        self.presentViewController(informationViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}