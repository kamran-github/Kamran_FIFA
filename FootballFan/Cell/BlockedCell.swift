//
//  BlockedCell.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 13/04/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class BlockedCell: UITableViewCell {
    @IBOutlet weak var optionName: UILabel?
    @IBOutlet weak var optionImage: UIImageView?
     @IBOutlet weak var banterFan: UILabel?
    @IBOutlet weak var singleFan: UILabel?
     @IBOutlet weak var lblvs: UILabel?
     @IBOutlet weak var optionImage2: UIImageView?
    var isForward: Bool = false
     @IBOutlet weak var bottomConstraint2: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
      
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
