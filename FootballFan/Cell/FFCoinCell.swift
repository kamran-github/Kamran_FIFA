//
//  FFCoinCell.swift
//  FootballFan
//
//  Created by Apple on 09/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

class FFCoinCell : UICollectionViewCell {
     @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var viewprice: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var coins: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
