//
//  NotificationlistCell.swift
//  FootballFan
//
//  Created by Apple on 30/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
class NotificationlistCell: UITableViewCell {
    @IBOutlet weak var notifytitel: UILabel?
    @IBOutlet weak var notifyTime: UILabel?
     @IBOutlet weak var notifydescription: UILabel?
    @IBOutlet weak var contactImage: UIImageView?
    @IBOutlet weak var contactFollow: UIButton!
    var isForward: Bool = false
    @IBOutlet weak var mainview: UIView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage?.layer.masksToBounds = true;
        contactImage?.layer.borderWidth = 1.0
        contactImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        contactImage?.layer.cornerRadius = 20.0
        
        
        contactFollow?.layer.masksToBounds = true;
        contactFollow?.layer.cornerRadius = 5.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
