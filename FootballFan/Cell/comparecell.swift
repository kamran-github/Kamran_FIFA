//
//  comparecell.swift
//  FootballFan
//
//  Created by Apple on 06/07/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class comparecell: UITableViewCell {
    @IBOutlet weak var optionName: UILabel?
    @IBOutlet weak var optionImage: UIImageView?
    
    @IBOutlet weak var count: UILabel?
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
