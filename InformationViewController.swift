//
//  InformationViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationViewController:UIViewController,UITextViewDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var enterLocationText: UITextView!
    @IBOutlet weak var informationMapView: MKMapView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var checkLink: UIButton!
    
    
    
    var locationText:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        enterLocationText.delegate = self
        URLTextField.delegate = self
        
        informationMapView.hidden = true
        URLTextField.hidden = true
        activityIndicator.hidden = true
        submitButton.hidden = true
        checkLink.hidden = true
     }
    
    
    
    @IBAction func dismissInformation(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    @IBAction func findOnMapButton(sender: UIButton) {
        
        locationText = enterLocationText.text
        
        if(locationText == "" || locationText == "Enter Your Location Here" ){
            
            let alertController = UIAlertController()
            alertController.title = "Please enter a location"
            alertController.message = "Location field was empty"
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default){
                action in
                
                
            }
            alertController.addAction(alertAction)
            
            }else{
            
            MapAppClient.userData.mapString = locationText!
        
            informationMapView.hidden = false
            URLTextField.hidden = false
            stackView.hidden = true
        
            
            findOnMapButton.hidden = true
            submitButton.hidden = false
            checkLink.hidden = false
            
            self.view.alpha = 0.5
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            getGeoFromLocation(locationText!)
            
           }
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        enterLocationText.text = ""
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        URLTextField.text = "https://www."
    }
    
    func textView(enterLocationText: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            enterLocationText.resignFirstResponder()
        }
        return true
    }
    
    
    func textFieldShouldReturn(URLTextField: UITextField) -> Bool {
        URLTextField.resignFirstResponder()
        return true
    }
    
    
    func getGeoFromLocation(location:String) {
        
        let geo = CLGeocoder()
        
        geo.geocodeAddressString(location){
            (placeMarks,error) in
            if let location = placeMarks?[0] {
                MapAppClient.userData.longitude = location.location!.coordinate.longitude
                MapAppClient.userData.latitude = location.location!.coordinate.latitude
                self.informationMapView.addAnnotation(MKPlacemark(placemark: location))
                
                let centerCoordinate = CLLocationCoordinate2DMake(location.location!.coordinate.latitude, location.location!.coordinate.longitude)
                let mapSpan = MKCoordinateSpanMake(0.01,0.01)
                let mapRegion = MKCoordinateRegionMake(centerCoordinate,mapSpan)
                
                self.informationMapView.setRegion(mapRegion,animated:true)
                
                
            }else{
                //create alert controller for error
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController()
                    alertController.title = "Location not recognized"
                    alertController.message = "Please try again"
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                    let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default){
                        action in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    
                    }
                    alertController.addAction(alertAction)
                })
            }
            
            self.view.alpha = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        }
        
        
    }
    
    
    @IBAction func submitLocation(sender: UIButton) {
        // post user information
        
        let URLText = URLTextField.text
        
        MapAppClient.userData.mediaURL = URLText!
        self.view.alpha = 0.5
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        MapAppClient.sharedInstance().postStudentLocation(){
            (result,error) in
            
            
            
            if let _ = error{
                
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController()
                    alertController.title = "Could not submit location"
                    alertController.message = "Please try again"
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default){
                        action in
                        self.view.alpha = 1
                        self.activityIndicator.hidden = true
                        self.activityIndicator.stopAnimating()
                    }
                    alertController.addAction(alertAction)
                })
             }
            
        }
        
        
        
    }
    
    
    @IBAction func checkForValidLink(sender: UIButton) {
        
        if(URLTextField.text == "Enter a Link to Share Here" || URLTextField.text == "https://www."){
            let alertController = UIAlertController()
            alertController.title = "No Link entered "
            alertController.message = "Please enter a URL to check"
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default){
                action in
                
                
            }
            alertController.addAction(alertAction)
        }else{
            MapAppClient.temp.URL = URLTextField.text!
        
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CheckURLViewController") as! CheckURLViewController
        
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
   
    
}
