//
//  ViewController.swift
//  Yelp
//
//  Created by Ashish Patel on 9/17/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, FilterUIViewControllerProtocol,UITextFieldDelegate  {
    
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var loading: Bool = false;
    var searchedTerm: String = "food"
    @IBOutlet var businessTableView: UITableView!
    var businesses = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK - delegates
        businessTableView.delegate = self
        businessTableView.dataSource = self
        searchTextField.delegate = self
        
        //button UI changes
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.cornerRadius = 5
        filterButton.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        businessTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func filterButtonClicked(sender: AnyObject) {
        println("Filter clicked")
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("Search should return \(textField.text)")
        self.searchedTerm = textField.text
        self.businesses.removeAll(keepCapacity: true)
        searchWithQueryAndUpdateTable(textField.text)
        textField.resignFirstResponder()
        return true
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
            
            if let thumbUrl = self.businesses[indexPath.row].thumbImageUrl {
                cell.thumImageView.setImageWithURL(NSURL(string: thumbUrl))
                //make imageview rounded corners
                cell.thumImageView.layer.cornerRadius = 8.0
                cell.thumImageView.clipsToBounds = true
            }
            
            if let ratingsUrl = self.businesses[indexPath.row].ratingsImageUrl{
                cell.ratingsImageView.setImageWithURL(NSURL(string: ratingsUrl))
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    //TODO - Still need to work on it to pass pages instead same term
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var currentOffset = scrollView.contentOffset.y
        var maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - currentOffset <= 10.0 && !loading) {
            searchWithQueryAndUpdateTable(self.searchedTerm)
            loading = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var navigationController = segue.destinationViewController as UINavigationController
        var destinationVC = navigationController.viewControllers[0] as FilterUIViewController
        destinationVC.delegate = self
    }
    
    func searchWithQueryAndUpdateTable(query: String){
        var yc = YelpClient()
        var parameters = []
        yc.searchWithTerm(query, parameters: nil,success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            if let tmpBusinesses = YelpClient.getBusinessFromJsonObject(response){
                self.businesses += tmpBusinesses
                self.businessTableView.reloadData()
                self.loading = false
            }
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error code = \(error.code)")
        }
    }
    
    //TODO - Still need to work on using data passed from filter model 
    // Search delegate method
    func searchDidFinish(savedKeys: [String]) {
        println("searchDidFinish")
        var defaults = NSUserDefaults.standardUserDefaults()
        for key in savedKeys {
            println("\(key) = \(defaults.valueForKey(key))")
        }
        
        businessTableView.reloadData()
    }
    
    
}

