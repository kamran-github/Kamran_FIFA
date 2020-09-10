//
//  MyTeamsCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 01/07/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class MyTeamsCell: UITableViewCell {
    @IBOutlet weak var teamName: UILabel?
    @IBOutlet weak var teamImage: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
