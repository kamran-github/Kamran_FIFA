//
//  UserCell.swift
//  FFMediaPicker
//
//  Created by Nitesh Gupta on 29/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
class UserCell: UITableViewCell {
    @IBOutlet weak var optionName: UILabel?
    @IBOutlet weak var optionImage: UIImageView?
    @IBOutlet weak var optionStatus: UILabel?
     @IBOutlet weak var optionIsAdmin: UILabel?
    var isForward: Bool = false
      @IBOutlet weak var btnFollowed: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionImage?.layer.masksToBounds = true;
        //optionImage?.layer.borderWidth = 1.0
        optionImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
       // //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
       // optionImage?.layer.cornerRadius = 30.0
        
        optionName?.font = UIFont.boldSystemFont(ofSize: 16.0)
        optionStatus?.font = UIFont.boldSystemFont(ofSize: 14.0)
        optionIsAdmin?.font = UIFont.boldSystemFont(ofSize: 14.0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
