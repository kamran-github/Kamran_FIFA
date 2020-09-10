//
//  AllChatsCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 27/07/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class AllChatsCell: UITableViewCell {
    @IBOutlet weak var chatImage: UIImageView?
    @IBOutlet weak var chatImage2: UIImageView?
    @IBOutlet weak var chatName: UILabel?
    @IBOutlet weak var chatTime: UILabel?
    @IBOutlet weak var senderName: UILabel?
    @IBOutlet weak var lastMessage: UILabel?
    @IBOutlet weak var badgeCount: UILabel?
    @IBOutlet weak var badgeCountsConstraint: NSLayoutConstraint!
    @IBOutlet weak var vs: UILabel?
@IBOutlet weak var fanCount: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTime?.textColor = UIColor.init(hex: "9A9A9A")//self.contentView.tintColor
        //chatImage?.layer.masksToBounds = true;
       // chatImage?.layer.borderWidth = 1.0
       // chatImage?.layer.borderColor = UIColor.init(hex: "9A9A9A").cgColor//self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
       // chatImage?.layer.cornerRadius = 21.0
        
        
        //chatImage2?.layer.masksToBounds = true;
        //chatImage2?.layer.borderWidth = 1.0
       // chatImage2?.layer.borderColor = UIColor.init(hex: "9A9A9A").cgColor//self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
       // chatImage2?.layer.cornerRadius = 21.0
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
