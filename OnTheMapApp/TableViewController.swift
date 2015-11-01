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
    
   
    @IBOutlet weak var myTableView: UITableView!
    var refreshTableButton:UIBarButtonItem?
    var postTableButton:UIBarButtonItem?
    
    
    var studentLocations:[StudentLocations] = [StudentLocations]()
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        studentLocations = MapAppClient.sharedInstance().studentLocations
        count = studentLocations.count
       
        refreshTableButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshTableData")
        
        postTableButton = UIBarButtonItem(image: UIImage(named:"Pin"), style: .Plain, target: self, action: "postNewData")
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // clear then reload buttons for when tab changes back from map view
        self.parentViewController!.navigationItem.rightBarButtonItems = []
        
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshTableButton!,postTableButton!]
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(myTableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return count
    }
    
    
     func tableView(myTableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        myTableView.backgroundColor = UIColor.whiteColor()
        
        let cell = myTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
       
        let students = studentLocations[indexPath.row]
        cell.textLabel!.text = "\(students.firstName) \(students.lastName)"
        let image = UIImage(named:"Pin")
        cell.imageView!.image = image
        return cell
    }
    
    
    func tableView(myTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let linkToOpen = studentLocations[indexPath.row].mediaURL
        let safari = UIApplication.sharedApplication()
        
        safari.openURL(NSURL(string:linkToOpen)!)
    }
    
    func tableView(myTableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selected = true
    }
    
    
    func refreshTableData(){
        
        if let myTableView = self.myTableView{
            myTableView.reloadData()
            print("reloading table data")
        }
        
        
    }
       
    func postNewData(){
        let informationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationViewController")
        
        self.presentViewController(informationViewController, animated: true, completion: nil)
    }

    
    
    
}
