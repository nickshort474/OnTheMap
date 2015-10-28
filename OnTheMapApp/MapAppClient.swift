//
//  MapAppClient.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation


class MapAppClient:NSObject {
    
    let session = NSURLSession.sharedSession()
    
    func repeatableTasks(parameters: [String : AnyObject],requestHeaderValues: [String : AnyObject],requestBodyValues: [String : NSData]?=nil,completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask  {
        
        // TODO: send url parametres to escaped parameters
        
        // let escapedParameters = MapAppClient.escapedParameters()
        
        // get other parameters to use
        var mutableParameters = [String:AnyObject]()
        mutableParameters["url"] = parameters["url"]
        
        
        // mutableParameters["other"] = parameters["other"]
        
        let urlString = parameters["url"] as! String
        
        
        let URL = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: URL!)
        
        request.HTTPMethod = parameters["method"] as! String
        
        
        
        for (key,value) in requestHeaderValues{
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        
        if let requestBodyValues = requestBodyValues{
            for (_,value) in requestBodyValues{
                request.HTTPBody = value
            }
        }
        
        
        
        let task = session.dataTaskWithRequest(request){
            data, response, downloadError in
            
            if let error = downloadError{
                // handle error
                print("error: \(error)")
            }else{
                // process JSON
                
                // TODO: deal with first 5 characters of udacity response but not parse
                
                if(parameters["url"] as! String == "https://www.udacity.com/api/session"){
                    
                    let newData = data?.subdataWithRange(NSMakeRange(5, data!.length - 5))
                    MapAppClient.parseJSON(newData!){
                        (result,error) in
                        
                        completionHandler(result:result,error:error)
                    }
                }else{
                    MapAppClient.parseJSON(data!){
                        (result,error) in
                        
                        completionHandler(result:result,error:error)
                    }
                }
                //print()
                
                
            }
        }
        
        task.resume()
        return task
    }
    
    
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    
    class func parseJSON(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSON", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    
    
    
    class func sharedInstance() -> MapAppClient {
        
        struct Singleton {
            static var sharedInstance = MapAppClient()
        }
        
        return Singleton.sharedInstance
    }
    
}

