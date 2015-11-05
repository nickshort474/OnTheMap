//
//  CheckURLViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 02/11/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class CheckURLViewController:UIViewController{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tempURL = MapAppClient.temp.URL
        let url = NSURL(string:tempURL)
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
    }
    
    
    @IBAction func clickBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}