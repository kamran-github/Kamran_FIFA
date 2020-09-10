//
//  BlockedViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 13/04/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class BlockedViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
   // let sections = [" Mobile"," Email Address"," Messaging"]
     var settingOptions: [AnyObject] = []
    // let items = ["Available"]
  var resultArry = NSMutableArray()
     var sectionNames: Array<Any> = []
    var strings:[String] = []
     // @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var storyTableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register to receive notification
        let infoimage   = UIImage(named: "add_block")!
        let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
        self.navigationItem.rightBarButtonItem = infoButton
        let notificationName2 = Notification.Name("unblockFromBlocklist")
        NotificationCenter.default.addObserver(self, selector: #selector(BlockedViewController.UpdateBlockUnblockStatus), name: notificationName2, object: nil)
      
        
     
    }
    func loaddata() {
        let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
        if strAllContacts != nil
        {
            //Code to parse json data
            if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                    
                    self.appDelegate().allContacts = NSMutableArray()
                    for record in tmpAllContacts {
                        self.appDelegate().allContacts[self.appDelegate().allContacts.count] = record
                    }
                    
                    let tmpAllAppContacts = self.appDelegate().allContacts[0] as! NSArray
                    
                    self.appDelegate().allAppContacts = NSMutableArray()
                    for record in tmpAllAppContacts {
                        self.appDelegate().allAppContacts[self.appDelegate().allAppContacts.count] = record
                    }
                    
                }
                catch let error as NSError {
                    print(error)
                }
            }
            
        }
        
        let data =  appDelegate().db.query(sql: "SELECT * FROM Blockeduser  where status = 'Blocked' GROUP BY Blockeduser.chatType")
        sectionNames = []
        resultArry = NSMutableArray()
        
        for res in data {
            
            let dict1: NSDictionary = res as NSDictionary
            
            let toUser = dict1.value(forKey: "chatType") as! String
            if(toUser != "chatR"){
            sectionNames.append(toUser)
            let data1 =  appDelegate().db.query(sql: "SELECT * FROM Blockeduser where chatType = '\(toUser)' And status = 'Blocked'")
            var  childArry = NSMutableArray()
            
            for res1 in data1 {
                let dict2: NSDictionary = res1 as NSDictionary
                var msgDict = [String: AnyObject]()
                
                if(toUser == "chat"){
                    var strName1: String = ""
                    _ = appDelegate().allAppContacts.filter({ (text) -> Bool in
                        let tmp: NSDictionary = text as! NSDictionary
                        let val: String = tmp.value(forKey: "jid") as! String
                        let val2: String = dict2.value(forKey: "touser") as! String
                        
                        
                        if(val.contains(val2))
                        {
                            let ind = tmp.value(forKey: "name") as! String
                            //print(ind)
                            //tempPoneContacts.removeObject(at: Int(ind))
                            msgDict["username"] = tmp.value(forKey: "name") as AnyObject
                            msgDict["touserjid"] = dict2.value(forKey: "touser")  as AnyObject
                            msgDict["avatar"] = tmp.value(forKey: "avatar") as AnyObject
                            strName1 = ind
                            
                            
                            return true
                        }
                        
                        // }
                        
                        
                        return false
                    })
                    
                    
                    if(strName1.isEmpty)
                    {
                        let myjid: String? = dict2.value(forKey: "touser") as? String
                        let arrdUserJid = myjid?.components(separatedBy: "@")
                        let userUserJid = arrdUserJid?[0]
                        
                        let myjidtrim: String? = userUserJid
                        msgDict["username"] = myjidtrim as AnyObject
                        msgDict["touserjid"] = dict2.value(forKey: "touser")  as AnyObject
                        msgDict["avatar"] = "" as AnyObject
                    }
                    
                    msgDict["chatType"] = "chat" as AnyObject
                    msgDict["roomId"] = dict2.value(forKey: "roomId") as AnyObject
                    
                }

                   else if(toUser == "fanstory"){
                        var strName1: String = ""
                        _ = appDelegate().allAppContacts.filter({ (text) -> Bool in
                            let tmp: NSDictionary = text as! NSDictionary
                            let val: String = tmp.value(forKey: "jid") as! String
                            let val2: String = dict2.value(forKey: "touser") as! String
                            
                            
                            if(val.contains(val2))
                            {
                                let ind = tmp.value(forKey: "name") as! String
                                //print(ind)
                                //tempPoneContacts.removeObject(at: Int(ind))
                                msgDict["username"] = tmp.value(forKey: "name") as AnyObject
                                msgDict["touserjid"] = dict2.value(forKey: "touser")  as AnyObject
                                msgDict["avatar"] = tmp.value(forKey: "avatar") as AnyObject
                                strName1 = ind
                                
                                
                                return true
                            }
                            
                            // }
                            
                            
                            return false
                        })
                        
                        
                        if(strName1.isEmpty)
                        {
                            let myjid: String? = dict2.value(forKey: "touser") as? String
                            let arrdUserJid = myjid?.components(separatedBy: "@")
                            let userUserJid = arrdUserJid?[0]
                            
                            let myjidtrim: String? = userUserJid
                            msgDict["username"] = myjidtrim as AnyObject
                            msgDict["touserjid"] = dict2.value(forKey: "touser")  as AnyObject
                            msgDict["avatar"] = "" as AnyObject
                        }
                        
                        msgDict["chatType"] = "fanstory" as AnyObject
                        msgDict["roomId"] = dict2.value(forKey: "roomId") as AnyObject
                        
                    }
                else if(toUser == "banter" || toUser == "group" || toUser == "teambr"){
                    var strName1: String = ""
                    _ = appDelegate().allAppContacts.filter({ (text) -> Bool in
                        let tmp: NSDictionary = text as! NSDictionary
                        let val: String = tmp.value(forKey: "jid") as! String
                        let val2: String = dict2.value(forKey: "touser") as! String
                        
                        
                        if(val.contains(val2))
                        {
                            
                            //tempPoneContacts.removeObject(at: Int(ind))
                            msgDict["username"] = tmp.value(forKey: "name") as AnyObject
                            msgDict["touserjid"] = dict2.value(forKey: "touser")  as AnyObject
                            msgDict["avatar"] = tmp.value(forKey: "avatar") as AnyObject
                            strName1 = tmp.value(forKey: "name") as! String
                            
                            
                            //return true
                        }
                        
                        // }
                        
                        
                        return false
                    })
                    
                    
                    if(strName1.isEmpty)
                    {
                        let myjid: String? = dict2.value(forKey: "touser") as? String
                        let arrdUserJid = myjid?.components(separatedBy: "@")
                        let userUserJid = arrdUserJid?[0]
                        
                        let myjidtrim: String? = userUserJid
                        msgDict["username"] = myjidtrim as AnyObject
                        msgDict["touserjid"] = dict2.value(forKey: "touser")  as AnyObject
                        msgDict["avatar"] = "" as AnyObject//chatType
                        
                    }
                    msgDict["chatType"] = toUser as AnyObject
                    msgDict["roomId"] = dict2.value(forKey: "roomId") as AnyObject
                    if let dt = self.appDelegate().arrAllChats[(dict2.value(forKey: "roomId") as? String)!]
                    {
                        msgDict["supportedTeam"] = dt.value(forKey: "supportedTeam") as AnyObject
                        msgDict["opponentTeam"] = dt.value(forKey: "opponentTeam") as AnyObject
                        msgDict["bantername"] = dt.value(forKey: "userName") as AnyObject
                        
                    }
                }
                
                childArry.add(msgDict)
            }
            let tmpArr = childArry.sorted { (item1, item2) -> Bool in
                let date1 =  item1 as! [String : AnyObject]
                let date2 =  item2 as! [String : AnyObject]
                
                var dt1: String = ""
                var dt2: String = ""
                
                if date1["username"] != nil
                {
                    
                    dt1 = date1["username"] as! String
                    
                }
                
                if date2["username"] != nil
                {
                    
                    dt2 = date2["username"] as! String
                    
                }
                
                
                
                return dt1.compare(dt2) == ComparisonResult.orderedAscending
            }
            childArry = NSMutableArray()
            for arr in tmpArr
            {
                let tmpDict = arr as! [String : AnyObject]
                
                
                
                childArry.add(tmpDict)
            }
            
            resultArry.add(childArry)
            }
        }
        if (sectionNames.count == 0) {
            notelable?.isHidden = false
            let bullet1 = "Tap (+) at the top of your screen to select a contact to block."
            let bullet2 = "You can block fans from Banter Rooms and Chats."
            let bullet3 = "Blocked contacts from a Banter Room will no longer participate in that particular Banter Room."
            let bullet4 = "Blocked contacts from Chats will no longer be able to contact you or send you messages."
          //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
           // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1, bullet2, bullet3, bullet4]
            // let boldText  = "Quick Information \n"
            let attributesDictionary = [kCTForegroundColorAttributeName : notelable?.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedString.Key : Any])
            //  let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
            //let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
            //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: boldString)
            
            //fullAttributedString.append(boldString)
            for string: String in strings
            {
                //let _: String = ""
                let formattedString: String = "\(string)\n\n"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
                
                let paragraphStyle = createParagraphAttribute()
                attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                
                let range1 = (formattedString as NSString).range(of: "Invite")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
                
                let range2 = (formattedString as NSString).range(of: "Settings")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
                
                fullAttributedString.append(attributedString)
            }
            
            
            notelable?.attributedText = fullAttributedString
        }
        else{
            notelable?.isHidden = true
        }
        storyTableView?.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.parent?.title = "Settings"
         self.navigationItem.title = "Blocked Fans"
         self.appDelegate().isOnBlockeduserView = true
        loaddata()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //appDelegate().toUserJID = ""
      self.appDelegate().isOnBlockeduserView = false
        /*if(self.appDelegate().isShowChatWindow)
         {
         appDelegate().toUserJID = ""
         appDelegate().toName = ""
         appDelegate().toAvatarURL = ""
         }*/
        //self.appDelegate().isShowChatWindow = false
    }
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        //paragraphStyle.tabStops = [NSTextTab (textAlignment: .justified, location: 0.0, options: [NSTextTab.OptionKey: an])] //[NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [String : AnyObject])]
        paragraphStyle.defaultTabInterval = 0
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 0
        
        return paragraphStyle
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arrrow = resultArry[indexPath.section] as! NSArray
        let dic = arrrow[indexPath.row] as! NSDictionary
        // print(dic.value(forKey: "chatType"))
        var Hieghtofrow: CGFloat = 90.0
        let chattype = dic.value(forKey: "chatType") as! String
        if(chattype == "chat"){
            Hieghtofrow = 70.0
        }
        return Hieghtofrow
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionNames[section] as? String
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.sectionNames.count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if(section == 0)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
            // headerView.tintColor=UIColor(hex:"FFFFFF")
        }
        else if(section == 1)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
        }
        else if(section == 2)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let chatType = self.sectionNames[section] as! String
        if(chatType == "banter")
        {
           label.text = " Blocked Banter Room Fans"// #FD7A5C
            // headerView.tintColor=UIColor(hex:"FFFFFF")
        }
        else if(chatType == "chat")
        {
            label.text = " Blocked Fans"// #7FD9FB
        }
        else if(chatType == "group")
        {
           label.text = " Blocked Group Fans"// #FD7A5C
        }
        else if(chatType == "fanstory")
        {
           label.text = " Blocked Stories Fans"// #FD7A5C
        }
        label.textColor=UIColor(hex: "FFFFFF")
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrrow = resultArry[section] as! NSArray
        
        return arrrow.count
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BlockedCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! BlockedCell
        
        let arrrow = resultArry[indexPath.section] as! NSArray
        let dic = arrrow[indexPath.row] as! NSDictionary
       // print(dic.value(forKey: "chatType"))
        cell.optionImage2?.isHidden = false
        cell.lblvs?.isHidden = false
        cell.optionName?.isHidden = false
        cell.banterFan?.isHidden = false
        cell.singleFan?.isHidden = false
        cell.bottomConstraint2.constant = CGFloat(21.0)
        let chattype = dic.value(forKey: "chatType") as! String
        if(chattype == "banter"){
            cell.optionName?.text = dic.value(forKey: "bantername") as? String
            if ((dic.value(forKey: "supportedTeam") != nil))
            {
                
                //print(dict2?.value(forKey: "supportedTeam") ?? "")
                let teamId = dic.value(forKey: "supportedTeam") as! Int
                
                let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                //print("Team Image Name: " + teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    cell.optionImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    /*if(cell.chatImage?.image == nil)
                     {
                     appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                     }*/
                }
                else
                {
                    cell.optionImage?.image = UIImage(named: "team")
                }
                
            }
            
            if ((dic.value(forKey: "opponentTeam") != nil))
            {
                //print(dict2?.value(forKey: "opponentTeam") ?? "")
                let teamId = dic.value(forKey: "opponentTeam") as! Int
                
                let teamImageName = "Team" + teamId.description
                //let teamImageName = "Team" + String(describing: dict2?.value(forKey: "opponentTeam"))
                //print("Team Image Name: " + teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                   cell.optionImage2?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    /*if(cell.chatImage?.image == nil)
                     {
                     appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                     }*/
                }
                else
                {
                    cell.optionImage2?.image = UIImage(named: "team")
                }
            }
            cell.banterFan?.text = dic.value(forKey: "username") as? String
            cell.singleFan?.isHidden = true
        }
        else if( chattype == "chat"){
            cell.singleFan?.text = dic.value(forKey: "username") as? String
             cell.bottomConstraint2.constant = CGFloat(5.0)
            if(dic.value(forKey: "avatar") != nil)
            {
                let avatar:String = (dic.value(forKey: "avatar") as? String)!
                if(!avatar.isEmpty)
                {
                    //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                    appDelegate().loadImageFromUrl(url: avatar, view: cell.optionImage!)
                    
                }
                else
                {
                    cell.optionImage?.image = UIImage(named: "user")
                }
            }
            else
            {
                cell.optionImage?.image = UIImage(named: "user")
            }
            cell.optionImage2?.isHidden = true
            cell.lblvs?.isHidden = true
            cell.optionName?.isHidden = true
            cell.banterFan?.isHidden = true
            cell.optionImage?.layer.masksToBounds = true;
            //optionImage?.layer.borderWidth = 1.0
            // optionImage?.layer.borderColor = self.contentView.tintColor.cgColor
            //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
            cell.optionImage?.layer.cornerRadius = 21.0
            
        }
            else if( chattype == "fanstory"){
                cell.singleFan?.text = dic.value(forKey: "username") as? String
                 cell.bottomConstraint2.constant = CGFloat(5.0)
                if(dic.value(forKey: "avatar") != nil)
                {
                    let avatar:String = (dic.value(forKey: "avatar") as? String)!
                    if(!avatar.isEmpty)
                    {
                        //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                        appDelegate().loadImageFromUrl(url: avatar, view: cell.optionImage!)
                        
                    }
                    else
                    {
                        cell.optionImage?.image = UIImage(named: "user")
                    }
                }
                else
                {
                    cell.optionImage?.image = UIImage(named: "user")
                }
                cell.optionImage2?.isHidden = true
                cell.lblvs?.isHidden = true
                cell.optionName?.isHidden = true
                cell.banterFan?.isHidden = true
                cell.optionImage?.layer.masksToBounds = true;
                //optionImage?.layer.borderWidth = 1.0
                // optionImage?.layer.borderColor = self.contentView.tintColor.cgColor
                //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
                cell.optionImage?.layer.cornerRadius = 21.0
                
            }
        else if( chattype == "group"){
            cell.optionName?.text = dic.value(forKey: "bantername") as? String
            cell.singleFan?.text = dic.value(forKey: "username") as? String
           /* if(dic.value(forKey: "avatar") != nil)
            {
                let avatar:String = (dic.value(forKey: "avatar") as? String)!
                if(!avatar.isEmpty)
                {
                    //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                    appDelegate().loadImageFromUrl(url: avatar, view: cell.optionImage!)
                    
                }
            }
            else
            {
                cell.optionImage?.image = UIImage(named: "user")
            }*/
            cell.optionImage?.image = UIImage(named: "Invite_users")
            cell.optionImage2?.isHidden = true
            cell.lblvs?.isHidden = true
            cell.optionName?.isHidden = false
            cell.banterFan?.isHidden = true
            cell.optionImage?.layer.masksToBounds = true;
            //optionImage?.layer.borderWidth = 1.0
            // optionImage?.layer.borderColor = self.contentView.tintColor.cgColor
            //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
            cell.optionImage?.layer.cornerRadius = 21.0
             cell.optionImage?.image = UIImage(named: "Invite_users")
            
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
        if((allSelected?.count)! == 1)
        {
             self.navigationItem.rightBarButtonItem = nil
            let infoimage   = UIImage(named: "listunblock")!
           
            let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.unblockedUser))
            
            let rightSearchBarButtonItem:UIBarButtonItem = infoButton
           
            let button1 = UIBarButtonItem(image: UIImage(named: "add_block"), style: .plain, target: self, action: #selector(self.showBlockedUser))
            let rightSearchBarButtonItem1:UIBarButtonItem = button1
         //UIBarButtonItem(barButtonSystemItem: UIImage(named: "imagename"), target: self, action: .plain, action: Selector(Banterdelete))//UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
            // 3
         self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem,rightSearchBarButtonItem1], animated: true)
            
        }
        
        //print("You tapped cell number \(indexPath.row).")
       /* var priority = ""
        let indexvalue = indexPath.row
        if(indexPath.section == 2){
            
        }
        else{
            //self.items[indexPath.section][indexPath.row
            let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
            let EveryoneAction = UIAlertAction(title: "Everyone", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                //print("Take Photo")
                //Code to show camera
                priority = "Everyone"
                if(indexPath.section == 0 && indexPath.row == 0){
                    UserDefaults.standard.setValue(priority, forKey: "Mobilesetting")
                    UserDefaults.standard.synchronize()
                    var tempDict1 = [String: String]()
                    tempDict1["mode"] = priority
                    tempDict1["name"] = "Mobile"
                    self.settingOptions[0]=tempDict1 as AnyObject
                }
                else if(indexPath.section == 1 && indexPath.row == 0){
                    UserDefaults.standard.setValue(priority, forKey: "Emailsetting")
                    UserDefaults.standard.synchronize()
                    var tempDict1 = [String: String]()
                    tempDict1["mode"] = priority
                    tempDict1["name"] = "Email"
                    self.settingOptions[1]=tempDict1 as AnyObject
                }
                self.storyTableView?.reloadData()
                
                                
            })
            let ContactsAction = UIAlertAction(title: "My Contacts", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                priority = "My contacts"
                if(indexPath.section == 0 && indexPath.row == 0){
                    
                    UserDefaults.standard.setValue(priority, forKey: "Mobilesetting")
                    UserDefaults.standard.synchronize()
                    var tempDict1 = [String: String]()
                    tempDict1["mode"] = priority
                    tempDict1["name"] = "Mobile"
                    self.settingOptions[0]=tempDict1 as AnyObject
                }
                else if(indexPath.section == 1 && indexPath.row == 0){
                    UserDefaults.standard.setValue(priority, forKey: "Emailsetting")
                    UserDefaults.standard.synchronize()
                    var tempDict1 = [String: String]()
                    tempDict1["mode"] = priority
                    tempDict1["name"] = "Email"
                    self.settingOptions[1]=tempDict1 as AnyObject
                }
                self.storyTableView?.reloadData()
                
                
            })
            let NobodyAction = UIAlertAction(title: "None", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                //print("Choose Photo")
                //Code to show gallery
                priority = "None"
                if(indexPath.section == 0 && indexPath.row == 0){
                    
                    UserDefaults.standard.setValue(priority, forKey: "Mobilesetting")
                    UserDefaults.standard.synchronize()
                    var tempDict1 = [String: String]()
                    tempDict1["mode"] = priority
                    tempDict1["name"] = "Mobile"
                    self.settingOptions[0]=tempDict1 as AnyObject
                }
                else if(indexPath.section == 1 && indexPath.row == 0){
                    UserDefaults.standard.setValue(priority, forKey: "Emailsetting")
                    UserDefaults.standard.synchronize()
                    var tempDict1 = [String: String]()
                    tempDict1["mode"] = priority
                    tempDict1["name"] = "Email"
                    self.settingOptions[1]=tempDict1 as AnyObject
                }
                self.storyTableView?.reloadData()
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                //print("Cancelled")
                self.storyTableView?.reloadData()
            })
            optionMenu.addAction(EveryoneAction)
            optionMenu.addAction(ContactsAction)
            optionMenu.addAction(NobodyAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        }*/
       
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
        if(allSelected == nil)
        {
            
            self.navigationItem.rightBarButtonItem = nil
            let infoimage   = UIImage(named: "add_block")!
            let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
            self.navigationItem.rightBarButtonItem = infoButton
        }
    }
        @IBAction func unblockedUser(sender:UIButton) {
        //print("search pressed")
        if ClassReachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: title, message: "Do you really want to unblock these fans?", preferredStyle: .alert)
            let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                
            });
            let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                LoadingIndicatorView.show((self.appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while unblock these fans")
                let allSelected = self.storyTableView?.indexPathsForSelectedRows
                if((allSelected?.count)! > 0)
                {
                    //Forward chats
                    for sel in allSelected!
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let indexP: NSIndexPath = sel as NSIndexPath
                            let arrrow = self.resultArry[indexP.section] as! NSArray
                            let dict2 = arrrow[indexP.row] as! NSDictionary
                           
                            //let tmpSingleUserChat: [String: AnyObject] = dict2.value as! [String: AnyObject]
                            let chatType: String = dict2["chatType"] as! String
                            if(chatType == "banter" || chatType == "group"){
                                self.appDelegate().RoomuserUnBlock(roomid: dict2.value(forKey: "roomId") as! String, roomtype: chatType, blockuser: dict2.value(forKey: "touserjid") as! String)
                               /* var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "unblockuserinroom" as AnyObject
                                
                                //Creating Request Datap
                                var dictRequestData = [String: AnyObject]()
                                //let messagecontent = bestAttemptContent.body
                                let login: String? = dict2.value(forKey: "touserjid") as? String
                                let arrReadUserJid = login?.components(separatedBy: "@")
                                let userReadUserJid = arrReadUserJid?[0]
                                dictRequestData["roomid"] = dict2.value(forKey: "roomId") as AnyObject
                                dictRequestData["username"] = userReadUserJid as AnyObject //appDelegate().toUserJID as AnyObject
                                dictRequestData["roomtype"] = chatType as AnyObject
                                dictRequest["requestData"] = dictRequestData as AnyObject
                                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                //print(dictRequest)
                                do {
                                    let dataMyTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                    let strMyTeams = NSString(data: dataMyTeams, encoding: String.Encoding.utf8.rawValue)! as String
                                    //print(strMyTeams)
                                    self.appDelegate().sendRequestToAPI(strRequestDict: strMyTeams)
                                } catch {
                                    print(error.localizedDescription)
                                }*/

                            }
                            else if( chatType == "chat"){
                                self.appDelegate().calluserunblock(blockeduser: dict2.value(forKey: "touserjid") as! String)
                             /*   var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "userunblock" as AnyObject
                                
                                
                                
                                do {
                                    //Creating Request Data
                                    var dictRequestData = [String: AnyObject]()
                                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                    let arrdUserJid = myjid?.components(separatedBy: "@")
                                    let userUserJid = arrdUserJid?[0]
                                    
                                    let myjidtrim: String? = userUserJid
                                    let login: String = dict2.value(forKey: "touserjid") as! String 
                                    let arrReadUserJid = login.components(separatedBy: "@")
                                    let userReadUserJid = arrReadUserJid[0]
                                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    let myMobile: String? = userReadUserJid//UserDefaults.standard.string(forKey: "myMobileNo")
                                    dictRequestData["username"] = myjidtrim as AnyObject
                                    dictRequestData["blockedusername"] = myMobile as AnyObject
                                    let array = Blockeduser.rows(filter:"roomId = '\(login)'") as! [Blockeduser]
                                    if(array.count != 0){
                                        let disnarysound = array[0]
                                        
                                        let status = disnarysound.value(forKey: "blocked_time") as AnyObject
                                        dictRequestData["blockedtime"] = status as AnyObject
                                        
                                    }
                                    else{
                                        dictRequestData["blockedtime"] = 0 as AnyObject
                                    }
                                    dictRequestData["unblockedtime"] = time as AnyObject
                                    dictRequest["requestData"] = dictRequestData as AnyObject
                                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                    //print(dictRequest)
                                    
                                    let dataGetBanterDetails = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                    let strGetBanterDetails = NSString(data: dataGetBanterDetails, encoding: String.Encoding.utf8.rawValue)! as String
                                    print(strGetBanterDetails)
                                    self.appDelegate().sendRequestToAPI(strRequestDict: strGetBanterDetails)
                                } catch {
                                    print(error.localizedDescription)
                                }*/
                                
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    let counter = (allSelected?.count)! + 2
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter)) {
                        LoadingIndicatorView.hide()
                    }
                    self.storyTableView?.reloadData()
                    
                }
                else{
                    self.alertWithTitle(title: "Error", message: "No fan select for Unblock.", ViewController: self)
                }
               
              
                
                //   self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showNewBanterNotify))
            });
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion:nil)
            
            
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    @IBAction func showBlockedUser(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : FanContactListViewController = storyBoard.instantiateViewController(withIdentifier: "FanContactList") as! FanContactListViewController
        //  appDelegate().isFromSettings = true
         myTeamsController.AddType = "AddBlock"
        show(myTeamsController, sender: self)
       
       // self.present(myTeamsController, animated: true, completion: nil)
    }
    @IBAction func cancelTeam () {
        //  UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func UpdateBlockUnblockStatus(notification: NSNotification)
    {
        let  Status = (notification.userInfo?["userdetail"] )as! String
        self.navigationItem.rightBarButtonItem = nil
        let infoimage   = UIImage(named: "add_block")!
        let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
        self.navigationItem.rightBarButtonItem = infoButton
        if(Status == "banter"){
            
          loaddata()
            
        }
        else{
            let blockeduser = Status + JIDPostfix
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            
            _ = appDelegate().db.query(sql: "UPDATE blockeduser SET status = 'unblocked', unblocked_time = \(time) WHERE roomId = '\(blockeduser)' And chatType = 'chat'")
          //  print(result)
            loaddata()

        }
        
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            BlockedViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return BlockedViewController.realDelegate!;
    }
}
