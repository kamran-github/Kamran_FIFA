//
//  NotificationService.swift
//  FootballFanPush
//
//  Created by Apple on 16/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var subType: String = ""
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        var ChatType: String = ""
        
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            let userInfo = bestAttemptContent.userInfo as! [String:Any]
            // .shared.applicationIconBadgeNumber = 6
            //UserDefaults.standard.persistentDomain(forName: "com.tridecimal.ltd.footballfan")
            if(userInfo["chattype"] != nil)
            {
                ChatType = userInfo["chattype"] as! String
            }
            
            if(ChatType == "chat"){
                if userInfo["subtype"] != nil{
                    //bestAttemptContent.title = userInfo["roomid"] as! String
                    subType = userInfo["subtype"] as! String
                }
                if(subType == "inviten" || subType == "invite")
                {
                    //var myRoomName: String = ""
                    
                    //if userInfo["roomname"] != nil{
                    //bestAttemptContent.title = userInfo["roomid"] as! String
                    //myRoomName = userInfo["roomname"] as! String
                    // }
                    bestAttemptContent.title = ""//myRoomName
                }
                else{
                    
                    
                    let userD2: UserDefaults = UserDefaults(suiteName: "group.com.tridecimal.ltd.footballfan")!
                    //let login: String? = userD2.string(forKey: "arrBanterSound")
                    var allPhoneContacts = NSArray()
                    
                    let localAllcontacts: String? = userD2.string(forKey: "allPhoneContacts")
                    if localAllcontacts != nil
                    {
                        //Code to parse json data
                        if let data = localAllcontacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                            do {
                                allPhoneContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                                
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                    if(allPhoneContacts.count>0){
                        
                        
                        var strName1: String = ""
                        _ = allPhoneContacts.filter({ (text) -> Bool in
                            let tmp: NSDictionary = text as! NSDictionary
                            let val: String = tmp.value(forKey: "jid") as! String
                            let val2: String = userInfo["username"] as! String
                            //let arrReadUserJid = val.components(separatedBy: "@")
                            //let userjidTrim: String = arrReadUserJid[0]
                            
                            
                            if(val.contains(val2))
                            {
                                let ind = tmp.value(forKey: "name") as! String
                                //print(ind)
                                //tempPoneContacts.removeObject(at: Int(ind))
                                if(ind == " " || ind == "")
                                {
                                    strName1 = val2
                                }
                                else{
                                    strName1 = tmp.value(forKey: "name") as! String
                                }
                                
                                //return true
                            }
                            
                            // }
                            
                            
                            return false
                        })
                        
                        
                        if(!strName1.isEmpty)
                        {
                            bestAttemptContent.title = strName1
                        }
                        else{
                            bestAttemptContent.title = userInfo["username"] as! String
                        }
                        
                        
                        
                        
                    }
                    else{
                        bestAttemptContent.title = userInfo["username"] as! String
                    }
                    
                    
                    
                    let messagecontent = bestAttemptContent.body
                    let arrReadUserJid = messagecontent.components(separatedBy: " ")
                    let howSended: String = arrReadUserJid[0] + " "
                    bestAttemptContent.body = messagecontent.replacingOccurrences(of: howSended, with: "")
                    
                    bestAttemptContent.sound = UNNotificationSound.default
                }
            }
            else if(ChatType == "trivia"){
                  bestAttemptContent.sound = UNNotificationSound.default
            }
                else if(ChatType == "fanstory"){
                                     bestAttemptContent.sound = UNNotificationSound.default
                                  }
                           else if(ChatType == "news"){
                                                 bestAttemptContent.sound = UNNotificationSound.default
                                             }
                           else if(ChatType == "products"){
                              bestAttemptContent.sound = UNNotificationSound.default
                           }
                else if(ChatType == "event"){
                bestAttemptContent.sound = UNNotificationSound.default
            }
            else{
                
                let userD2: UserDefaults = UserDefaults(suiteName: "group.com.tridecimal.ltd.footballfan")!
                //let login: String? = userD2.string(forKey: "arrBanterSound")
                var arrAllBantersMute = NSArray()
                var myRoomId: String = ""
                var myRoomName: String = ""
                
                let localAllBantersMute: String? = userD2.string(forKey: "arrBanterSound")
                if localAllBantersMute != nil
                {
                    //Code to parse json data
                    if let data = localAllBantersMute?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do {
                            arrAllBantersMute = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                            
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
                
                
                
                //change the subtitle
                if userInfo["roomid"] != nil{
                    //bestAttemptContent.title = userInfo["roomid"] as! String
                    myRoomId = userInfo["roomid"] as! String
                }
                
                if userInfo["roomname"] != nil{
                    //bestAttemptContent.title = userInfo["roomid"] as! String
                    myRoomName = userInfo["roomname"] as! String
                }
                
                if userInfo["subtype"] != nil{
                    //bestAttemptContent.title = userInfo["roomid"] as! String
                    subType = userInfo["subtype"] as! String
                }
                
                let result = arrAllBantersMute.filter({ (text) -> Bool in
                    let tmp: NSDictionary = text as! NSDictionary
                    let val = tmp.value(forKey: "toUserJID")
                    let range = (val as AnyObject).range(of: myRoomId, options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                })
                
                if(result.count > 0)
                {
                    let dict: NSDictionary? = result[0] as? NSDictionary
                    let sound = dict?.value(forKey: "soundValue") as? Int
                    let roomName = myRoomName //dict?.value(forKey: "toUsername") as? String
                    //bestAttemptContent.title = String(describing: sound)
                    
                    if(sound == 1)
                    {
                        bestAttemptContent.title = roomName
                        bestAttemptContent.sound = UNNotificationSound.default
                    }
                    else
                    {
                        
                        
                        bestAttemptContent.title = roomName
                        
                        //bestAttemptContent.sound = UNNotificationSound.value(forKey: "sound.caf") as? UNNotificationSound
                        
                        
                    }
                    
                    
                    
                    
                }
                
                if(subType == "inviten" || subType == "invite")
                {
                    bestAttemptContent.title = ""
                }
                
                if(subType == "referral")
                {
                    bestAttemptContent.title = "Referral Bonus"
                }
                if(subType == "broadcastall" || subType == "broadcastinactive")
                {
                    bestAttemptContent.title = myRoomName
                }
                
                // bestAttemptContent.title = roomIdNotify
                //let login: String? = userD2.string(forKey: "arrBanterSound")
                var allPhoneContacts = NSArray()
                
                let localAllcontacts: String? = userD2.string(forKey: "allPhoneContacts")
                if localAllcontacts != nil
                {
                    //Code to parse json data
                    if let data = localAllcontacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do {
                            allPhoneContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                            
                        } catch let error as NSError {
                            print(error)
                            bestAttemptContent.body = "No contact get"
                        }
                    }
                }
                if(allPhoneContacts.count>0){
                    let messagecontent = bestAttemptContent.body
                    let arrReadUserJid = messagecontent.components(separatedBy: ":")
                    let howSended: String = arrReadUserJid[0] //+ JIDPostfix
                    
                    var strName1: String = ""
                    _ = allPhoneContacts.filter({ (text) -> Bool in
                        let tmp: NSDictionary = text as! NSDictionary
                        let val: String = tmp.value(forKey: "jid") as! String
                        //let val2: String = userInfo["username"] as! String
                        //let arrReadUserJid = val.components(separatedBy: "@")
                        //let userjidTrim: String = howSended
                        
                        
                        if(val.contains(howSended))
                        {
                            let ind = tmp.value(forKey: "name") as! String
                            //print(ind)
                            //tempPoneContacts.removeObject(at: Int(ind))
                            if(ind == " " || ind == "")
                            {
                                strName1 = howSended
                            }
                            else{
                                strName1 = tmp.value(forKey: "name") as! String
                            }
                            
                            //return true
                        }
                        
                        
                        // }
                        
                        
                        return false
                    })
                    
                    
                    if(!strName1.isEmpty)
                    {
                        bestAttemptContent.body = messagecontent.replacingOccurrences(of: howSended, with: strName1)
                    }
                    
                }
                
            }
            
            let userB: UserDefaults = UserDefaults(suiteName: "group.com.tridecimal.ltd.footballfan")!
            var intUserB: Int = userB.integer(forKey: "badge")
            //print(login ?? "")
            
            intUserB = intUserB + 1//Int(truncating: bestAttemptContent.badge!)
            
            //let badge: Int = Int(truncating: bestAttemptContent.badge!) + 1
            let userD: UserDefaults = UserDefaults.init(suiteName: "group.com.tridecimal.ltd.footballfan")!
            userD.set(intUserB, forKey: "badge")
            userD.synchronize()
            
            
            //let userD: UserDefaults = UserDefaults.init(suiteName: "group.com.tridecimal.ltd.footballfan")!
            //userD.set("Message from background pop", forKey: "pop")
            //userD.synchronize()
            
            
            //bestAttemptContent.title = title//login!//"\(login!) [modified by Ravi]" //+ login!
            //bestAttemptContent.body = "Modified message"
            
            
            bestAttemptContent.badge = intUserB as NSNumber
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
