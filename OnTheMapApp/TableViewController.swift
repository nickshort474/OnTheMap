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
    
    var studentLocations:[StudentLocations] = [StudentLocations]()
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        studentLocations = MapAppClient.sharedInstance().studentLocations
        count = studentLocations.count
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return count
    }
    
    
     func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
       
        let students = studentLocations[indexPath.row]
        cell.textLabel!.text = "\(students.firstName) \(students.lastName)"
        let image = UIImage(named:"Pin")
        cell.imageView!.image = image
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("row selected")
    }
    
    
}
