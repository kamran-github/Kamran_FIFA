//
//  FixtureCell.swift
//  FootballFan
//
//  Created by Apple on 28/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class FixtureCell: UITableViewCell {
    @IBOutlet weak var time: UILabel?
    @IBOutlet weak var teamhome: UILabel?
    @IBOutlet weak var teamaway: UILabel?
    //@IBOutlet weak var W: UILabel?
   // @IBOutlet weak var D: UILabel?
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
