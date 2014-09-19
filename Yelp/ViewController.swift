//
//  ViewController.swift
//  Yelp
//
//  Created by Ashish Patel on 9/17/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet var businessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK - delegates
        businessTableView.delegate = self
        businessTableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func filterButtonClicked(sender: AnyObject) {
        println("Filter clicked")
    }
    
    
    //MARK - tableview methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("businesscell") as BusinessTableViewCell
        cell.locationNameLabel.text = "1. Basil Thai Restaurant and Bar"
        cell.addressLabel.text = "1175 Folsom st, Soma"
        cell.categoryLabel.text = "Thai, Seafood, Salad"
        cell.reviewsLabel.text = "469 Reviews"
        cell.distanceLabel.text = "0.07mi"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
}

