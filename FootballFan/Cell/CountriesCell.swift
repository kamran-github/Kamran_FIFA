//
//  CountriesCell.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 29/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class CountriesCell: UITableViewCell {
    @IBOutlet weak var countryName: UILabel?
    @IBOutlet weak var countryImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
