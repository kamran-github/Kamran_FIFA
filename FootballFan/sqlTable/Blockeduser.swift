//
//  Blockeduser.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 06/04/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
class Blockeduser:SQLTable {
    
    var blocked_time: Int64 = 0
    var unblocked_time: Int64 = 0
    var roomId = ""
    var chatType = ""
    var status = ""
    var touser = ""
}
