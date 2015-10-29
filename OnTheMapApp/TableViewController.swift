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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.tableView!.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")
        
        
        studentLocations = MapAppClient.sharedInstance().studentLocations
        print(studentLocations)
        
        //MapAppClient.sharedInstance().getStudentLocation(){
            //(result,error) in
            
        //}
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
     func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //let cellID = tableCell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = "hello"
        
        print("cell presenting?")
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("row selected")
    }
    
    
}
