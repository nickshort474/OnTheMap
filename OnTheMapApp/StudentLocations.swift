//
//  StudentLocations.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation




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
        
        //var studentInfo = [StudentLocations]()
    
        for value in results{
            //studentInfo.append(StudentLocations(value: value))
            MapAppClient.sharedInstance().studentLocations.append(StudentLocations(value:value))
        }
        
        //return studentInfo
    }
    
    
   //  -> [StudentLocations]
    
    
}

