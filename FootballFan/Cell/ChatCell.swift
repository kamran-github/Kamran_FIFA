//
//  ChatCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 20/07/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var chatMessage: UILabel?
    @IBOutlet weak var chatBubble: UIView?
 @IBOutlet weak var checkedImage: UIImageView?
    @IBOutlet weak var ledingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //sizeToFit()
        //layoutIfNeeded()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
