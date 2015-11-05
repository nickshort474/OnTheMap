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
    @IBOutlet weak var imageViewAnimate: UIImageView!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        imageViewAnimate.hidden = true
        notifyLabel.hidden = true
        activityIndicator.hidden = true
        self.view.alpha = 1
        loginButton.hidden = false
    }
    
    @IBAction func loginToUdacity(sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        self.view.alpha = 0.5
        loginButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        if  (email != "" || password != ""){
            
        MapAppClient.sharedInstance().loginToUdacity(email!, password: password!){
            (result, error) in
            
            let error = error
            
            if let _ = error{
                
                // replace with shake animation
                self.runAnimation("No Connection")
              
            }
            
            if let result = result{
                 if let errorResult = result["status"]{
                    if let _ = errorResult{
                        
                        self.runAnimation("Login Information Incorrect")
                       
                    }else{
                       
                        let resultDic = result["account"]
                        
                        if let resultDic = resultDic {
                            
                            MapAppClient.Constants.userID = resultDic!["key"] as! String
                            MapAppClient.userData.uniqueKey = resultDic!["key"] as! String
                            
                            let registered = resultDic!["registered"] as! Int
                            
                            if (registered == 1 ){
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavViewController") as! UINavigationController
                                    
                                    self.presentViewController(controller, animated: true, completion: nil)
                                })
                                
                                MapAppClient.sharedInstance().getPublicUserData(){
                                    (result,error) in
                                    
                                    if let result = result{
                                        if let user = result["user"]!{
                                            MapAppClient.userData.firstName = user["first_name"] as! String
                                            MapAppClient.userData.lastName = user["last_name"] as! String
                                            
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                }
            }
            }
        }else{
            runAnimation("Please input your information")
        }
    }
    
    
    func signUpToUdacity(sender: UIButton) {
        
        let linkToOpen = "https://www.udacity.com/account/auth#!/signup"
        let safari = UIApplication.sharedApplication()
        safari.openURL(NSURL(string:linkToOpen)!)
    
    }
    
    
    func runAnimation(value:String){
        dispatch_async(dispatch_get_main_queue(), {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.imageViewAnimate.hidden = true
                self.view.alpha = 1
                self.loginButton.hidden = false
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
            })
            
            self.imageViewAnimate.hidden = false
            
            
            // add alert controller
            
            
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController()
                alertController.title = "Problem Logging in"
                alertController.message = value
                
                let alertAction = UIAlertAction(title: "Go back", style: UIAlertActionStyle.Default){
                (action) in
                    
                }
                alertController.addAction(alertAction)
            })
            
            
            self.notifyLabel.hidden = false
            self.notifyLabel.text = value
            
            
            
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.1
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint:CGPointMake(self.imageViewAnimate.center.x - 20,self.imageViewAnimate.center.y))
            animation.toValue = NSValue(CGPoint:CGPointMake(self.imageViewAnimate.center.x + 20,self.imageViewAnimate.center.y))
            self.imageViewAnimate.layer.addAnimation(animation, forKey: "position")
            
            CATransaction.commit()
            
            
        })
       
       
    }
    
    
}