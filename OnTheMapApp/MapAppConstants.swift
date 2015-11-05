//
//  MapAppConstants.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation


extension MapAppClient{
    
    struct Constants{
        static let APIKey:String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID:String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        static let parseURL:String = "https://api.parse.com/1/classes/StudentLocation"
        static let udacityBaseURL:String = "https://www.udacity.com/api/"
       
        static let session:String = "session"
        static let users:String = "users/"
        static var userID:String = ""
    }
    
    
    struct userData{
        static var uniqueKey = ""
        static var firstName = ""
        static var lastName = ""
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }
    
    struct temp{
        static var URL = ""
    }
    
      
    
}


