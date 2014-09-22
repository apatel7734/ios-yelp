//
//  FilterUIViewController.swift
//  Yelp
//
//  Created by Ashish Patel on 9/19/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import UIKit

protocol FilterUIViewControllerProtocol{
    
    func searchDidFinish(test: [String])
}

class FilterUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: FilterUIViewControllerProtocol? = nil
    
    var sectionsArr = ["Category","Sort by","Distance","Deals"]
    
    var categoriesSectoin0 = ["Take-out","Good for Groups","Takes Reservations","Outdoor Seating","Full Bar"]
    var sortSection1 = ["Best Match", "Distance", "Rating"]
    var radiusSection2 = ["5","0.3","1","20"]
    var savedKeys: [String] = [String]()
    var switchStatus: [String:Bool] = [String:Bool]()
    
    //section : isExpanded or Not
    var isExpanded:[Int:Bool] = [Int:Bool]()
    //section : indexPath.row
    var selectedRow:[Int:Int] = [Int:Int]()
    
    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        filterTableView.dataSource = self
        filterTableView.delegate = self
        //setup defaults
        isExpanded[0] = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonClicked(sender: UIBarButtonItem) {
        if(delegate != nil ){
            saveFilterValues()
            delegate?.searchDidFinish(savedKeys)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        if(delegate != nil ){
            delegate?.searchDidFinish(savedKeys)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func switchValueChanged(sender: UISwitch!){
        if let customSwitch  =  sender as? customUISwitch {
            println("section \(customSwitch.indexPath.section) , Row \(customSwitch.indexPath.row) - \(customSwitch.on)")
            if(customSwitch.indexPath.section == 0){
                var key = categoriesSectoin0[customSwitch.indexPath.row]
                switchStatus[key] = customSwitch.on
            }else if (customSwitch.indexPath.section == 3){
                var key = "deals"
                switchStatus[key] = customSwitch.on
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var section = self.sectionsArr[indexPath.section]
        
        //deals category = custom 1
        //sort, radius = custom 2
        
        //cells for categories
        if(indexPath.section == 0 || indexPath.section == 3){
            
            var cell = tableView.dequeueReusableCellWithIdentifier("customcell2") as secondCustomTableViewCell
            //category
            if(section == self.sectionsArr[0]){
                cell.customLabel.text = categoriesSectoin0[indexPath.row]
                //Deals *******
            }else if(section == self.sectionsArr[3]){
                cell.customLabel.text = "Deals"
            }
            
            cell.switchVal.addTarget(self, action: Selector("switchValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            cell.switchVal.indexPath = indexPath
            return cell
            
        }else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("customcell1") as firstCustomTableViewCell
            //Sort By *******
            if(section == self.sectionsArr[1]){
                if(isExpanded[indexPath.section] == true){
                    cell.customLabel.text = self.sortSection1[indexPath.row]
                }else{
                    if let selectedRow = self.selectedRow[indexPath.section] {
                        cell.customLabel.text = self.sortSection1[selectedRow]
                    }
                }
                //Distance**********
            }else if(section == self.sectionsArr[2]){
                if(isExpanded[indexPath.section] == true){
                    cell.customLabel.text = self.radiusSection2[indexPath.row]
                }else{
                    if let selectedRow = self.selectedRow[indexPath.section] {
                        cell.customLabel.text = self.radiusSection2[selectedRow]
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let expanded = isExpanded[section]
        
        if(expanded == true && section == 0){
            return categoriesSectoin0.count
        }else if (expanded == true && section == 1){
            return sortSection1.count
        }else if (expanded == true && section == 2){
            return radiusSection2.count
        }else{
            //deals
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsArr.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableCellWithIdentifier("headercell") as headerViewTableViewCell
        cell.headerLabel.text = self.sectionsArr[section]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let expanded = isExpanded[indexPath.section]
        if(indexPath.section == 0){
            isExpanded[indexPath.section] = true
        }else if(expanded == true){
            isExpanded[indexPath.section] = false
        }else{
            isExpanded[indexPath.section] = true
        }
        selectedRow[indexPath.section] = indexPath.row
        
        //filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
        filterTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    func saveFilterValues(){
        var defaults = NSUserDefaults.standardUserDefaults()
        //save all switch values
        for (key,value) in switchStatus{
            savedKeys += [key]
            defaults.setBool(value, forKey: key)
        }
        
        for (section, selectedRow) in self.selectedRow{
            if(section == 0){
            }else if(section == 1){
                var strKey: String = self.sectionsArr[section]
                defaults.setValue(sortSection1[section], forKey: strKey)
                savedKeys += [strKey]
                
            }else if (section == 2){
                var strKey: String = self.sectionsArr[section]
                savedKeys += [strKey]
                defaults.setValue(radiusSection2[section], forKey: strKey)
            }
        }
        
        // synchronize
        defaults.synchronize()
    }
    
}
