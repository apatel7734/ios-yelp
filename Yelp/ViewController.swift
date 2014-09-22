//
//  ViewController.swift
//  Yelp
//
//  Created by Ashish Patel on 9/17/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, FilterUIViewControllerProtocol  {
    
    @IBOutlet weak var filterUIBarButton: UIBarButtonItem!
    
    @IBOutlet var businessTableView: UITableView!
    var businesses = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK - delegates
        businessTableView.delegate = self
        businessTableView.dataSource = self
        
        
        var yc = YelpClient()
        yc.searchWithTerm("chipotle", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            if let tmpBusinesses = self.getBusinessFromJsonObject(response){
                self.businesses = tmpBusinesses
                self.businessTableView.reloadData()
            }
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error code = \(error.code)")
        }
        
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
        
        if self.businesses.count > 0{
            cell.locationNameLabel.text = self.businesses[indexPath.row].name
            cell.addressLabel.text = self.businesses[indexPath.row].locationAddress
            var categories = self.businesses[indexPath.row].categories
            var listCategories: String = ""
            
            for category in categories{
                if(!listCategories.isEmpty){
                    listCategories = "\(listCategories), \(category[0])"
                }else{
                    listCategories = category[0]
                }
            }
            
            if(!listCategories.isEmpty){
                cell.categoryLabel.text = listCategories
            }
            
            cell.reviewsLabel.text = "\(self.businesses[indexPath.row].reviewCount) Reviews"
            cell.distanceLabel.text = "0.07mi"
            cell.priceLabel.text = "$$"
            
            if(!self.businesses[indexPath.row].thumbImageUrl.isEmpty){
                cell.thumImageView.setImageWithURL(NSURL(string: self.businesses[indexPath.row].thumbImageUrl))
                //make imageview rounded corners
                cell.thumImageView.layer.cornerRadius = 8.0
                cell.thumImageView.clipsToBounds = true
            }
            
            if(!self.businesses[indexPath.row].ratingsImageUrl.isEmpty){
                cell.ratingsImageView.setImageWithURL(NSURL(string: self.businesses[indexPath.row].ratingsImageUrl))
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.destinationViewController.isKindOfClass(FilterUIViewController)){
            var destinationVC = segue.destinationViewController as FilterUIViewController
            destinationVC.delegate = self
        }
    }
    
    
    func getBusinessFromJsonObject (businessJsonObj: AnyObject!) -> [Business]?{
        
        var isValidJsonObj = NSJSONSerialization.isValidJSONObject(businessJsonObj)
        if(isValidJsonObj){
            let jsonData: NSData! = NSJSONSerialization.dataWithJSONObject(businessJsonObj, options: nil, error: nil)
            let jsonObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as NSDictionary
            var businesses = [Business]()
            
            let jsonBusinesses = jsonObject["businesses"] as [NSDictionary]
            for jsonBusinessObj in jsonBusinesses{
                var businessModel = Business()
                businessModel.id = jsonBusinessObj["id"] as String
                businessModel.name = jsonBusinessObj["name"] as String
                businessModel.ratingsImageUrl = jsonBusinessObj["rating_img_url"] as String
                businessModel.thumbImageUrl = jsonBusinessObj["image_url"] as String
                businessModel.reviewCount = jsonBusinessObj["review_count"] as Int
                businessModel.categories = jsonBusinessObj["categories"] as [[String]]
                var location = jsonBusinessObj["location"] as NSDictionary
                var address = location["address"] as NSArray
                if(address.count > 0){
                    businessModel.locationAddress = address[0] as String
                }
                businesses += [businessModel]
            }
            return businesses
        }
        return nil
    }
    
    func searchDidFinish(test: String) {
        println(test)
    }
    
    
}

