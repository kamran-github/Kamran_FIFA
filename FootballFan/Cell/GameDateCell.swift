//
//  GameDateCell.swift
//  FootballFan
//
//  Created by Apple on 13/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
class GameDateCell: UICollectionViewCell {
    
    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var weekTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        dayTitle?.layer.cornerRadius = 25.0
               
               
               dayTitle?.layer.masksToBounds = true;
               dayTitle?.layer.cornerRadius = 5.0
        
}
}
