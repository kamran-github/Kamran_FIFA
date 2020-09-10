//
//  LivescoreCell.swift
//  FootballFan
//
//  Created by Apple on 13/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
class LivescoreCell: UITableViewCell {
    @IBOutlet weak var hometeam: UILabel?
    @IBOutlet weak var visitteam: UILabel?
    @IBOutlet weak var imghometeam: UIImageView?
       @IBOutlet weak var imgvisitteam: UIImageView?
    @IBOutlet weak var lblstatus: UILabel?
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
