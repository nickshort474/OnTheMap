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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
            
            // check to see if getting result
            if let result = result{
                // try to assign results to results
                if let results = result["results"]{
                    // check whether assignment successful
                    if let results = results{
                        StudentLocations.createStudentArray(results as! [[String:AnyObject]])
                        self.addDataToMap(results as! [[String:AnyObject]])
                    }else{
                        let results = result["error"]
                        if let results = results{
                            dispatch_async(dispatch_get_main_queue(), {
                                let alertController = UIAlertController()
                                alertController.title = "Download Failed"
                                alertController.message = "Failed to download student data:  \(results!)"
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                                let alertAction = UIAlertAction(title: "Finished", style: UIAlertActionStyle.Default){
                                    action in
                                    //self.logout()
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.hidden = true
                                }
                                alertController.addAction(alertAction)
                            })
                        }
                    }
                    
                    
                }
            }
            else{
                // handle no connection?  - have already logged in so must have connection?
            }
        }// end of get student location
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        // clear then reload buttons for when tab changes back from table view
        self.parentViewController!.navigationItem.rightBarButtonItems = []
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshMapButton!,postMapButton!]
        
    }
    
    
    func addDataToMap(results:[[String:AnyObject]]){
        
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
    
    
    
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
    
    func logout(){
        MapAppClient.sharedInstance().logoutSession(){
            (result,error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
                
                
            })
        }
    }
    
    
    func refreshData(){
        
        self.parentViewController!.navigationItem.rightBarButtonItems = []
        self.view.alpha = 0.5
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        MapAppClient.sharedInstance().getStudentLocation(){
            (result,error) in
            
            if let result = result{
                
                // parse JSON into results dictionary
                if let results = result["results"] {
                    
                    if let results = results{
                        // save in shared studentLocations Array
                        StudentLocations.createStudentArray(results as! [[String:AnyObject]])
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.view.alpha = 1
                            self.activityIndicator.hidden = true
                            self.activityIndicator.stopAnimating()
                            self.parentViewController!.navigationItem.rightBarButtonItems = [self.refreshMapButton!,self.postMapButton!]
                        })
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            let alertController = UIAlertController()
                            alertController.title = "Download Failed"
                            alertController.message = "Failed to download student data"
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            let alertAction = UIAlertAction(title: "Finished", style: UIAlertActionStyle.Default){
                                action in
                                
                                self.view.alpha = 1
                                self.activityIndicator.hidden = true
                                self.activityIndicator.stopAnimating()
                                self.parentViewController!.navigationItem.rightBarButtonItems = [self.refreshMapButton!,self.postMapButton!]
                            }
                            alertController.addAction(alertAction)
                        })
                    }
                }
            }
        }
    }
    
    
    
    func postNewData(){
        let informationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationViewController")
        
        self.presentViewController(informationViewController, animated: true, completion: nil)
    }
    
    
    
}