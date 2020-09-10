//
//  TopFansCell.swift
//  FootballFan
//
//  Created by Mayank Sharma on 14/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

class TopFansCell: UITableViewCell {
    @IBOutlet weak var fanName: UILabel?
    @IBOutlet weak var fanImage: UIImageView?
    @IBOutlet weak var rank: UILabel?
    @IBOutlet weak var fanCoins: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fanImage?.layer.masksToBounds = true;
        fanImage?.layer.borderWidth = 1.0
        fanImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        fanImage?.layer.cornerRadius = 18.0
    }
    
}
