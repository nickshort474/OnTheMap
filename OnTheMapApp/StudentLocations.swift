//
//  StudentLocations.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit

struct StudentLocations{
    
    var firstName = ""
    var lastName = ""
    var mediaURL = ""
    var latitude = 0.0
    var longitude = 0.0
    
    
    init(value:[String:AnyObject]){
        
        firstName = value["firstName"] as! String
        lastName = value["lastName"] as! String
        mediaURL = value["mediaURL"] as! String
        latitude = value["latitude"] as! Double
        longitude = value["longitude"] as! Double
        
    }
    
    static func createStudentArray(results:[[String:AnyObject]]){
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        // empty studentLocation array ready to put fresh results in
        
        appDelegate.studentLocations.removeAll()
        
        for value in results{
            
            // add new results to array
            appDelegate.studentLocations.append(StudentLocations(value:value))
            
        }
        
        
    }
    
    
}
