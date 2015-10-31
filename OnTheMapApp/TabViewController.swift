//
//  TabViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 31/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class TabViewController:UITabBarController{
    
    
    @IBAction func refreshList(sender: UIBarButtonItem) {
        
        MapAppClient.sharedInstance().getStudentLocation(){
        (result,error) in
            if let result = result{
                
                // parse JSON into results dictionary
                let results = result["results"] as! [[String:AnyObject]]
                
                
                // save new data in shared studentLocations Array
                StudentLocations.createStudentArray(results)
                
                // refresh map View / list view
                print(self.viewControllers![0])
            }
        
        }
    }
    
}