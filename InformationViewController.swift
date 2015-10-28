//
//  InformationViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController:UIViewController{
    
    
    @IBAction func dismissInformation(sender: UIButton) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        MapAppClient.sharedInstance().getStudentLocation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
