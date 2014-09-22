//
//  firstCustomCellTableViewCell.swift
//  Yelp
//
//  Created by Ashish Patel on 9/21/14.
//  Copyright (c) 2014 Average Techie. All rights reserved.
//

import UIKit

class firstCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
