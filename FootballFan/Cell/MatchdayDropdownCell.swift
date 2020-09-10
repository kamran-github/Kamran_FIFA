//
//  MatchdayDropdownCell.swift
//  FootballFan
//
//  Created by Apple on 23/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
class MatchdayDropdownCell: UITableViewCell {
    @IBOutlet weak var matchday: UILabel?
    
    @IBOutlet weak var lbltime: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
