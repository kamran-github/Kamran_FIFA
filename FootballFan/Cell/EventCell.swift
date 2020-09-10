//
//  EventCell.swift
//  FootballFan
//
//  Created by Apple on 28/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
class EventCell: UITableViewCell {
  //  @IBOutlet weak var hometeam: UILabel?
  //  @IBOutlet weak var visitteam: UILabel?
   // @IBOutlet weak var imghometeam: UIImageView?
    //   @IBOutlet weak var imgvisitteam: UIImageView?
   // @IBOutlet weak var lbltime: UILabel?
    // @IBOutlet weak var lbltimeTop: NSLayoutConstraint!
    // @IBOutlet weak var lblstatus: UILabel?
    @IBOutlet weak var homeview: UIView?
    @IBOutlet weak var headlineleft: UILabel?
    @IBOutlet weak var Discriptionleft: UILabel?
    @IBOutlet weak var imgtagleft: UIImageView?
    @IBOutlet weak var visitorview: UIView?
       @IBOutlet weak var headlineright: UILabel?
       @IBOutlet weak var Discriptionright: UILabel?
       @IBOutlet weak var imgtagright: UIImageView?
    @IBOutlet weak var minuteleft: UILabel?
    @IBOutlet weak var minuteright: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
