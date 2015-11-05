//
//  MapAppConvenience.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit


extension MapAppClient {
    
    func loginToUdacity(email:String,password:String, completionHandler:(result: AnyObject!, error: NSError?) -> Void){
        
        let method = "POST"
        
        let parameters = [
            "url":"\(Constants.udacityBaseURL)\(Constants.session)",
            "isUdacity":"true"
        ]
        
        let requestHeaderValues = [
            "Accept":"application/json",
            "Content-type":"application/json",
        ]
        
        let requestBodyValues = [
            "key":"{\"udacity\":{\"username\":\"\(email)\", \"password\":\"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        ]
        
        
        
        repeatableTasks(method,parameters: parameters,requestHeaderValues:requestHeaderValues,requestBodyValues:requestBodyValues){
            (result, error) in
            
            if let error = error{
                
                
                completionHandler(result:result,error:error)
                
            }else{
                if let result = result{
                    
                    completionHandler(result:result,error: error)
                }
            }
        }
      
        
    }
    
    
    func logoutSession(completionHandler:(result: AnyObject!, error: NSError?) -> Void){
        
      
        
        let request = NSMutableURLRequest(URL:NSURL(string:"https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie:NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]!{
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie{
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            data, response, error in
            if let error = error{
                print(error)
            }else{
                if let result = response{
                    completionHandler(result:result,error:error)
                }
            }
        }
        task.resume()
        
        
        
    }
    
    
    func getPublicUserData(completionHandler:(result: AnyObject!, error: NSError?) -> Void){
        
        let method = "GET"
        
        let parameters = [
            "url":"\(Constants.udacityBaseURL)\(Constants.users)\(Constants.userID)",
            "isUdacity":"true"
        ]
        
        let requestHeaderValues = [
            "Accept":"application/json",
        
        ]
        
        repeatableTasks(method,parameters: parameters,requestHeaderValues: requestHeaderValues){
        (result, error) in
                
                if let error = error{
                    print("error, code: \(error)")
                    
                }else{
                    if let result = result{
                        
                        completionHandler(result:result,error:error)
                    }
                }
        }
        
        
        
        
    }
    
    
    
    func getStudentLocation(completionHandler:(result: AnyObject!, error: NSError?) -> Void){
        
        let method = "GET"
        
        let parameters = [
            "url":"\(Constants.parseURL)?limit=100&order=-updatedAt",
            "isUdacity":"false"
        ]
        
        let requestHeaderValues = [
            "X-Parse-Application-Id":Constants.ApplicationID,
            "X-Parse-REST-API-Key":Constants.APIKey
        ]
        
        
        repeatableTasks(method,parameters: parameters,requestHeaderValues: requestHeaderValues)
            {
                (result, error) in
                if let error = error{
                    //print("error, code: \(error)")
                    completionHandler(result:result,error:error)
                }else{
                    if let result = result{
                        
                        completionHandler(result:result,error:error)
                    }
                }
        }
        
        
        
    }
    
    
    
    func postStudentLocation(completionHandler:(result: AnyObject!, error: NSError?) -> Void){
        
        let method = "POST"
        
        let parameters = [
            "url":Constants.parseURL,
            "isUdacity":"false"
            
        ]
        
        let requestHeaderValues = [
            "X-Parse-Application-Id":Constants.ApplicationID,
            "X-Parse-REST-API-Key":Constants.APIKey,
            "Content-Type":"application/json",
        ]
        
        let requestBodyValues = [
            "bodyString":"{\"uniqueKey\":\"\(userData.uniqueKey)\",\"firstName\":\"\(userData.firstName)\",\"lastName\":\"\(userData.lastName)\",\"mapString\":\"\(userData.mapString)\",\"mediaURL\": \"\(userData.mediaURL)\",\"latitude\":\(userData.latitude),\"longitude\":\(userData.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)!
           
        ]
        
        repeatableTasks(method,parameters: parameters, requestHeaderValues: requestHeaderValues,requestBodyValues: requestBodyValues){
            (result,error) in
            if let error = error{
                completionHandler(result:result,error:error)
            }else{
                if let result = result{
                    completionHandler(result:result,error:error)
                    
                }
            }
        }
        
       
        
        }
    
   }