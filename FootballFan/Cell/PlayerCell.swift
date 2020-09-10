//
//  PlayerCell.swift
//  FootballFan
//
//  Created by Apple on 07/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class PlayerCell: UITableViewCell {
    @IBOutlet weak var playstate: UILabel?
    @IBOutlet weak var headername: UILabel?
    @IBOutlet weak var playerimg: UIImageView?
    @IBOutlet weak var number: UILabel?
    //@IBOutlet weak var headerlabelHightConstraint2: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerimg?.layer.masksToBounds = true;
        playerimg?.layer.borderWidth = 1.0
        playerimg?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        playerimg?.layer.cornerRadius = 20.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
