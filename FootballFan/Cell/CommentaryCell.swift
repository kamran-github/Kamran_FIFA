//
//  CommentaryCell.swift
//  FootballFan
//
//  Created by Apple on 01/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class CommentaryCell: UITableViewCell {
    //@IBOutlet weak var Sno: UILabel?
    @IBOutlet weak var lblheadline: UILabel?
     @IBOutlet weak var lblminuts: UILabel?
     @IBOutlet weak var vline1: UILabel?
     @IBOutlet weak var vline2: UILabel?
    //@IBOutlet weak var headerlabelHightConstraint2: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
