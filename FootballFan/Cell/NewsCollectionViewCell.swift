//
//  NewsCollectionViewCell.swift
//  FootballFan
//
//  Created by Mayank Sharma on 11/09/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

class NewsCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    
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
        
        image.isHidden = true
        
    }
    
}

