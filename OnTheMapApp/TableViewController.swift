//
//  TableViewController.swift
//  OnTheMapApp
//
//  Created by Nick Short on 28/10/2015.
//  Copyright © 2015 Nick Short. All rights reserved.
//


import Foundation
import UIKit


class TableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshTableButton:UIBarButtonItem?
    var postTableButton:UIBarButtonItem?
    
    var location:[StudentLocations]!
    
    var count:Int = 0
    var isButtonRefresh:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        location = (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations
        
        activityIndicator.hidden = true
        
        
        
        refreshTableButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshTableData")
        postTableButton = UIBarButtonItem(image: UIImage(named:"Pin"), style: .Plain, target: self, action: "postNewData")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // clear then reload buttons for when tab changes back from map view
        self.parentViewController!.navigationItem.rightBarButtonItems = []
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshTableButton!,postTableButton!]
        
    }
    
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return location.count
    }
    
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        // get latest version of studentLocations array
        
        location = (UIApplication.sharedApplication().delegate as! AppDelegate).studentLocations
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let students = location[indexPath.row]
        
        cell.textLabel?.text = "\(students.firstName) \(students.lastName)"
        cell.detailTextLabel?.text = "hello"
        let image = UIImage(named:"Pin")
        cell.imageView!.image = image
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let linkToOpen = location[indexPath.row].mediaURL
        let safari = UIApplication.sharedApplication()
        
        safari.openURL(NSURL(string:linkToOpen)!)
    }
    
    
    func refreshTableData(){
        
        self.parentViewController!.navigationItem.rightBarButtonItems = []
        self.view.alpha = 0.5
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        MapAppClient.sharedInstance().getStudentLocation(){
            (result,error) in
            
            if let result = result{
                if let results = result["results"]{
                    if let results = results{
                        
                        // save in shared studentLocations Array
                        StudentLocations.createStudentArray(results as! [[String:AnyObject]])
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.view.alpha = 1
                            self.activityIndicator.hidden = true
                            self.activityIndicator.stopAnimating()
                            self.parentViewController!.navigationItem.rightBarButtonItems = [self.refreshTableButton!,self.postTableButton!]
                        })
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            let alertController = UIAlertController()
                            alertController.title = "Download Failed"
                            alertController.message = "Failed to download student data"
                            self.presentViewController(alertController, animated: true, completion: nil)
                            
                            let alertAction = UIAlertAction(title: "Finished", style: UIAlertActionStyle.Default){
                                action in
                                
                                self.view.alpha = 1
                                self.activityIndicator.hidden = true
                                self.activityIndicator.stopAnimating()
                                self.parentViewController!.navigationItem.rightBarButtonItems = [self.refreshTableButton!,self.postTableButton!]
                            }
                            alertController.addAction(alertAction)
                        })
                    }
                }
            }
        }
        
        
        if let studentTableView = self.tableView{
            studentTableView.reloadData()
        }
        
    }
    
    func postNewData(){
        let informationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationViewController")
        
        self.presentViewController(informationViewController, animated: true, completion: nil)
    }
    
    
    
}
