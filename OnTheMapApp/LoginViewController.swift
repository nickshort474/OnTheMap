//
//  LoginViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:UIViewController{
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    @IBAction func loginToUdacity(sender: UIButton) {
        MapAppClient.sharedInstance().loginToUdacity(emailTextField.text!, password: passwordTextField.text!){
            (result, error) in
            
            if let result = result{
                
                print(result)
                
                
                
                let resultDic = result["account"]
                
                if let resultDic = resultDic {
                    let registered = resultDic!["registered"] as! Int
                    if (registered == 1 ){
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavViewController") as! UINavigationController
                            
                            self.presentViewController(controller, animated: true, completion: nil)
                        })
                    }else{
                        let alertController = UIAlertController()
                        alertController.title = "Login Failed"
                        alertController.message = "\(error)"
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        let alertAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Default){
                            action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                        alertController.addAction(alertAction)
                        
                    }
                }
            }
            
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}

