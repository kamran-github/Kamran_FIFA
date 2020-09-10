//
//  NewChatCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 13/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class NewChatCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel?
    @IBOutlet weak var contactStatus: UILabel?
    @IBOutlet weak var contactImage: UIImageView?
    @IBOutlet weak var pickContact: UIImageView?
      @IBOutlet weak var bottomConstraint3: NSLayoutConstraint!
    var isForward: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage?.layer.masksToBounds = true;
        contactImage?.layer.borderWidth = 1.0
        contactImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        contactImage?.layer.cornerRadius = 17.0
        
        pickContact?.layer.masksToBounds = true;
        pickContact?.layer.borderWidth = 1.0
        pickContact?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        pickContact?.layer.cornerRadius = 10.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
