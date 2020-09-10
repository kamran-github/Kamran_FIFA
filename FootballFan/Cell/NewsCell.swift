//
//  NewsCell.swift
//  FootballFan
//
//  Created by Mayank Sharma on 07/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//


import UIKit

class NewsCell: UITableViewCell {
    
   
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDesc: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

