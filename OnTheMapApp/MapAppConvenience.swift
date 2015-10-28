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
        
        //var loginError:NSError?
        //var loginResult:AnyObject?
        
        
        let parameters = [
            "url":Constants.udacityURL,
            "method":"POST"
        ]
        
        let requestHeaderValues = [
            "Accept":"application/json",
            "Content-type":"application/json",
        ]
        
        let requestBodyValues = [
            "key":"{\"udacity\":{\"username\":\"\(email)\", \"password\":\"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        ]
        
        
        
        // TODO:  USE: let newData = data?.subdataWithRange(NSMakeRange(5,data!.length - 5))
        // AND: NSString(data: newData!, encoding:NSUTF8StringEncoding)
        // to process data
        // OR???  JSON FUNCTION taken from movieManager App
        
        repeatableTasks(parameters,requestHeaderValues: requestHeaderValues,requestBodyValues:requestBodyValues){
            (result, error) in
            
            if let error = error{
                
                print("error, code: \(error)")
                //loginError = error
                
            }else{
                if let result = result{
                    
                    completionHandler(result: result,error: error)
                }
            }
        }
        
        
        
        //request.HTTPMethod = "POST"
        //request.addValue("application/json",forHTTPHeaderField:"Accept")
        //request.addValue("application/json", forHTTPHeaderField:"Content-type")
        //request.HTTPBody = "{\"udacity\":{\"username\":\"nickshorty2010@yahoo.co.uk\", \"password\":\"colorado\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        //let session = NSURLSession.sharedSession()
        //let task = session.dataTaskWithRequest(request){
        //data, response,error in
        //if let error = error{
        //print(error)
        //}else{
        // let newData = data?.subdataWithRange(NSMakeRange(5,data!.length - 5))
        //print(NSString(data: newData!, encoding:NSUTF8StringEncoding))
        // }
        //}
        //task.resume()
        
    }
    
    func logoutSession(){
        
        let request = NSMutableURLRequest(URL:NSURL(string:"https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie:NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie]!{
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
                let newData = data?.subdataWithRange(NSMakeRange(5,data!.length - 5))
                print(NSString(data: newData!, encoding:NSUTF8StringEncoding))
            }
        }
        task.resume()
        
        
        
    }
    
    func getPublicUserData(){
        
        let url = "https://www.udacity.com/api/users"
        let nsURL = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: nsURL)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            data,response, error in
            if let error = error{
                print(error)
            }else{
                let newData = data?.subdataWithRange(NSMakeRange(5,data!.length - 5))
                print(NSString(data: newData!, encoding:NSUTF8StringEncoding))
            }
        }
        task.resume()
        
    }
    
    
    
    func getStudentLocation(){
        
        
        let parameters = [
            "url":Constants.udacityURL
        ]
        
        let requestHeaderValues = [
            "X-Parse-Application-Id":Constants.ApplicationID,
            "X-Parse-REST-API-Key":Constants.APIKey
        ]
        
        
        repeatableTasks(parameters,requestHeaderValues: requestHeaderValues)
            {
                (result, error) in
                if let error = error{
                    print("error, code: \(error)")
                    
                }else{
                    print(result)
                }
        }
        
        // use returned info
        
    }
    
    func postStudentLocation(){
        
        let url = "https://api.parse.com/1/classes/StudentLocation"
        let nsURL = NSURL(string: url)!
        let request = NSMutableURLRequest(URL:nsURL)
        request.HTTPMethod = "POST"
        request.addValue("\(Constants.ApplicationID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(Constants.APIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        
        
        // TODO: add studnt location data
        
        request.HTTPBody = "studentLocation".dataUsingEncoding(NSUTF8StringEncoding)
        
        // continue
        
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            data, response, error in
            if let error = error{
                print(error)
            }else{
                print(NSString(data:data!, encoding:NSUTF8StringEncoding))
            }
            
        }
        task.resume()
        
    }
    
    
    func sortMapStuff(){
        
        // do stuff
        
        // repeatableTasks(method, parameters)
        
        // use returned info
        
        // do some stuff
        
    }
    
    
    
    func populateTable(){
        // do stufff
        
        // do stuff
        
        // repeatableTasks(method, parameters)
        
        // use returned info
    }
    
    
    
    
    
}