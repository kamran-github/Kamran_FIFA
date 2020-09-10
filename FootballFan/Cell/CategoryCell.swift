//
//  CategoryCell.swift
//  FootballFan
//
//  Created by Mayank Sharma on 12/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel?
    @IBOutlet weak var contactStatus: UILabel?
    @IBOutlet weak var contactImage: UIImageView?
    @IBOutlet weak var btnInvite: UIButton?
    @IBOutlet weak var selectedTeamCount: UILabel?
    @IBOutlet weak var selectedTeamCountConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*contactImage?.layer.masksToBounds = true;
        contactImage?.layer.borderWidth = 1.0
        contactImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        contactImage?.layer.cornerRadius = 20.0 */
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

