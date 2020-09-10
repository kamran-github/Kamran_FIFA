//
//  NearbyCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 15/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class NearbyCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel?
    @IBOutlet weak var contactDistance: UILabel?
    @IBOutlet weak var contactImage: UIImageView?
    @IBOutlet weak var contactFollow: UIButton!
    var isForward: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage?.layer.masksToBounds = true;
        contactImage?.layer.borderWidth = 1.0
        contactImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        contactImage?.layer.cornerRadius = 25.0
        
        
        contactFollow?.layer.masksToBounds = true;
        contactFollow?.layer.cornerRadius = 5.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
