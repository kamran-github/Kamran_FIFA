//
//  triviaCell.swift
//  FootballFan
//
//  Created by Apple on 27/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

class triviaCell: UITableViewCell {
   
    @IBOutlet weak var username: UILabel?
   @IBOutlet weak var message: UILabel?
    @IBOutlet weak var header: UILabel?
     @IBOutlet weak var time: UILabel?
     @IBOutlet weak var messagesview: UIView?
     @IBOutlet weak var headerview: UIView?
     @IBOutlet weak var messagesviewHightConstraint: NSLayoutConstraint!
     @IBOutlet weak var messagesHightConstraint: NSLayoutConstraint!
}
