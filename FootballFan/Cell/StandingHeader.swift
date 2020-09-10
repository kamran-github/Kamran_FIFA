//
//  StandingHeader.swift
//  FootballFan
//
//  Created by Apple on 31/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class StandingHeader: UITableViewCell {
    //@IBOutlet weak var Sno: UILabel?
    @IBOutlet weak var headername: UILabel?
    @IBOutlet weak var headerlabelHightConstraint2: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
