//
//  StandingCell.swift
//  FootballFan
//
//  Created by Apple on 27/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class StandingCell: UITableViewCell {
     @IBOutlet weak var Sno: UILabel?
    @IBOutlet weak var teamName: UILabel?
    @IBOutlet weak var pl: UILabel?
    @IBOutlet weak var W: UILabel?
    @IBOutlet weak var D: UILabel?

    @IBOutlet weak var L: UILabel?
    @IBOutlet weak var F: UILabel?
    @IBOutlet weak var A: UILabel?
    @IBOutlet weak var GD: UILabel?
    @IBOutlet weak var Pts: UILabel?
     @IBOutlet weak var imgtagright: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
