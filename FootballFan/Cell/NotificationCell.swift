//
//  NotificationCell.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 18/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var optionName: UILabel?
    @IBOutlet weak var optionmode: UILabel?
    
     @IBOutlet weak var bottomConstraint1: NSLayoutConstraint!
    var isForward: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        optionName?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

