//
//  SettingsCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 23/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet weak var optionName: UILabel?
    @IBOutlet weak var optionImage: UIImageView?
    
    @IBOutlet weak var count: UILabel?
    var isForward: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionImage?.layer.masksToBounds = true;
        //optionImage?.layer.borderWidth = 1.0
       // optionImage?.layer.borderColor = self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        optionImage?.layer.cornerRadius = 17.0
        
        optionName?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
