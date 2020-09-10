//
//  Messages.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 22/02/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
class Messages:SQLTable {
    var userName = ""
    var userAvatar = ""
    var badgeCounts = 0
    var lastMessage = ""
    var lastTime: Int64 = 0
    var lastDate: Int64 = 0 //integer,
    var chatType = ""// text,
    var banterNickName = ""//text,i
    var isJoined = ""// text,
    var isAdmin = ""//text,
    var banterStatus = ""//text,
    var supportedTeam = 0//integer,
    var opponentTeam = 0//integer,
    var banterUsers = ""//text,
    var roomJID = ""//text,
    var mySupportedTeam = 0//integer
}
