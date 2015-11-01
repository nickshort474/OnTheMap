//
//  InformationViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController:UIViewController,UITextViewDelegate{
    
    
    @IBOutlet weak var enterLocationText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enterLocationText.delegate = self
    }
    
    @IBAction func dismissInformation(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //MapAppClient.sharedInstance().getStudentLocation()
        
    }
    @IBAction func findOnMapButton(sender: UIButton) {
        var locationText = enterLocationText.text
        
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        enterLocationText.text = ""
        
    }
    
    func textView(enterLocationText: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            enterLocationText.resignFirstResponder()
        }
        return true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
