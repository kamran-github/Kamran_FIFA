//
//  Messages_details.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 22/02/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
class Messages_details:SQLTable {
    var toUserJID = ""
    var fromUserJID = ""
    var messageId = ""
    var messageContent = ""
    var messageType = ""
    var supportteam = 0 //integer,
    var userName = ""// text,
    var status = ""//text,i
    var time: Int64 = 0
    var isIncoming = ""//text,
    var filePath = ""//text,
    var thumb = ""
    var fileLocalId = ""
    var isFile = ""//text,
    var fileType = ""//text,
    var fileName = ""//text,
    var caption = ""//text,
    var deleverUsers = ""//text,
    var receivedUsers = ""//text,
    var deleverUsersCount = 0
    var chatType = ""//text,
    var banterNickName = ""//text,
  
  //  toUserJID text,fromUserJID text,messageId text,messageContent text,messageType text,supportteam integer,userName text,status text,time integer,isIncoming text,filePath text,thumb text,fileLocalId text,isFile text,fileType text,fileName text,caption text,deleverUsers text,receivedUsers text,deleverUsersCount integer,chatType text,banterNickName text"
}
