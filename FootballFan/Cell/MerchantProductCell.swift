//
//  MerchantProductCell.swift
//  FootballFan
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class MerchantProductCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
   
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rrprice: UILabel!
     @IBOutlet weak var priceWidth: NSLayoutConstraint!
    
    @IBInspectable var cornerRadius: CGFloat = 6
    
    @IBInspectable var shadowOffsetWidth: Int = 1
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*mainView.backgroundColor = UIColor.white
         mainView.layer.cornerRadius = 5.0
         mainView.clipsToBounds = true
         mainView?.layer.masksToBounds = true;
         mainView?.layer.borderWidth = 1.0
         mainView?.layer.borderColor = UIColor.darkGray.cgColor */
        
        mainView?.layer.borderWidth = 0.2
        mainView?.layer.borderColor = UIColor.darkGray.cgColor
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        mainView.layer.masksToBounds = true
        mainView.layer.shadowColor = shadowColor?.cgColor
        mainView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        mainView.layer.shadowOpacity = shadowOpacity
        mainView.layer.shadowPath = shadowPath.cgPath
        
        
        
    }
    
}
