//
//  FilterUIViewController.swift
//  Yelp
//
//  Created by Ashish Patel on 9/19/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import UIKit

class FilterUIViewController: UIViewController {

    @IBOutlet weak var price1Button: UIButton!
    @IBOutlet weak var price2Button: UIButton!
    @IBOutlet weak var price3Button: UIButton!
    @IBOutlet weak var price4Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        price1Button.layer.borderColor = UIColor.blueColor().CGColor
        price1Button.layer.borderWidth = 1.0
        price1Button.layer.cornerRadius = 3
        
        price2Button.layer.borderColor = UIColor.blueColor().CGColor
        price2Button.layer.borderWidth = 1.0
        price2Button.layer.cornerRadius = 3
        
        price3Button.layer.borderColor = UIColor.blueColor().CGColor
        price3Button.layer.borderWidth = 1.0
        price3Button.layer.cornerRadius = 3
        
        price4Button.layer.borderColor = UIColor.blueColor().CGColor
        price4Button.layer.borderWidth = 1.0
        price4Button.layer.cornerRadius = 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
