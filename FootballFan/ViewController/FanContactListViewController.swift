//
//  FanContactListViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 18/04/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework
class FanContactListViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    // let sections = [" Mobile"," Email Address"," Messaging"]
    var settingOptions: [AnyObject] = []
    // let items = ["Available"]
    var resultArry = NSMutableArray()
   // var sectionNames: Array<Any> = []
    var strings:[String] = []
    var AddType: String = ""
   var  localallappContacts = NSMutableArray()
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var butcontacts: UIButton?
    @IBOutlet weak var storyTableView: UITableView?
     @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationName2 = Notification.Name("Blockuser")
        NotificationCenter.default.addObserver(self, selector: #selector(FanContactListViewController.UpdateBlockUnblockStatus), name: notificationName2, object: nil)
        
        notelable?.isHidden = true
       
    }
     func loaddata() {
        resultArry = NSMutableArray()
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
        if(appDelegate().allAppContacts.count > 0)
        {
            
            //code to save non split contacts
            //For Temp hide
            let tmpArr = appDelegate().allAppContacts.sorted { (item1, item2) -> Bool in
                let date1 =  item1 as! [String : AnyObject]
                let date2 =  item2 as! [String : AnyObject]
                
                var dt1: String = ""
                var dt2: String = ""
                
                if date1["name"] != nil
                {
                    
                    dt1 = date1["name"] as! String
                    
                }
                
                if date2["name"] != nil
                {
                    
                    dt2 = date2["name"] as! String
                    
                }
                
                
                
                return dt1.compare(dt2) == ComparisonResult.orderedAscending
            }
            appDelegate().allPhoneContacts = NSMutableArray()
            var encountered = Set<String>()
            if(self.AddType == "AddBlock")
            {
                let data1 = appDelegate().db.query(sql: "SELECT roomId FROM Blockeduser where chatType = 'chat' And status = 'Blocked'")
                for res in data1
                {
                    let tmpDict = res as [String : AnyObject]
                    let Jid = tmpDict["roomId"] as! String
                    encountered.insert(Jid)
                }
            }
            else if(self.AddType == "AddNew"){
                for res in appDelegate().arrBanterUsers
                {
                    let dict: NSDictionary = res as! NSDictionary
                    let Jid: String = (dict.value(forKey: "jid") as? String)!
                    
                    encountered.insert(Jid)
                }
            }
           
            for arr in tmpArr
            {
                let tmpDict = arr as! [String : AnyObject]
                let Jid = tmpDict["jid"] as! String
                if encountered.contains(Jid) {
                    // Do not add a duplicate element.
                }
                else {
                    // Add value to the set.
                    
                    // ... Append the value.
                    // result.append(value)
                    
                    resultArry.add(tmpDict)
                }
                
                
                
            }
            notelable?.isHidden = true
             butcontacts?.isHidden = true
            storyTableView?.isHidden = false
            if(resultArry.count == 0 && appDelegate().allAppContacts.count > 0){
                notelable?.isHidden = false
                butcontacts?.isHidden = true
                storyTableView?.isHidden = true
                //notelable?.text = "No Fans Found."
                var bullet1: String = ""
                if(self.AddType == "AddBlock")
                {
                    bullet1 = "No more Football Fan contacts available to block."
                }
                else if(self.AddType == "AddNew"){
                    bullet1 = "No more Football Fan contacts available to add to your " + appDelegate().toName+" group."
                }
                //let bullet2 = "Please sync your Contacts first by tapping on Sync Contacts."
                //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
                // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
                
                strings = [bullet1]
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
        }
        else{
            notelable?.isHidden = false
             butcontacts?.isHidden = false
            storyTableView?.isHidden = true
            // notelable?.text = "Sorry! Your Contacts are not synced yet.\nPlease sync your Contacts first by tapping on Sync Contacts."
            /*let infoButton = UIBarButtonItem(title: "sys", style: .plain, target: self, action: #selector(self.showChatWindow(sender:)))//UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
            //UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
            // 3
            self.navItem.rightBarButtonItem = infoButton*/
            let bullet1 = "Sorry! Your Contacts are not synced yet."
            let bullet2 = "Please sync your Contacts first by tapping on Sync Contacts."
           // let bullet3 = ""
           // let bullet4 = ""
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1, bullet2]
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
                let formattedString: String = "\(string)\n"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
                
                let paragraphStyle = createParagraphAttribute()
                attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                
                let range1 = (formattedString as NSString).range(of: "Sync Contacts")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
                
                let range2 = (formattedString as NSString).range(of: "Settings")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
                
                fullAttributedString.append(attributedString)
            }
            
            
            notelable?.attributedText = fullAttributedString
 
        }
       
        storyTableView?.reloadData()
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
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            FanContactListViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return FanContactListViewController.realDelegate!;
    }
    @IBAction func cancelTeam () {
        //  UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.parent?.title = "Settings"
        self.navigationItem.title = "Football Fan Contacts"
        
        self.appDelegate().isOnFanContactlistView = true
        loaddata()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //appDelegate().toUserJID = ""
        self.appDelegate().isOnFanContactlistView = false
        /*if(self.appDelegate().isShowChatWindow)
         {
         appDelegate().toUserJID = ""
         appDelegate().toName = ""
         appDelegate().toAvatarURL = ""
         }*/
        //self.appDelegate().isShowChatWindow = false
    }
   /* func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionNames[section] as? String
        
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    }*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // let arrrow = resultArry[section] as! NSArray
        
        return resultArry.count
        
    }
  /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ContactsCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! ContactsCell
        let dic = resultArry[indexPath.row] as! NSDictionary
        cell.contactName?.text = dic.value(forKey: "name") as? String
        if(dic.value(forKey: "avatar") != nil)
        {
            let avatar:String = (dic.value(forKey: "avatar") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                
            }
            else
            {
                cell.contactImage?.image = UIImage(named: "user")
            }
        }
        else
        {
            cell.contactImage?.image = UIImage(named: "user")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
        if(allSelected == nil)
        {
            
            self.navItem.rightBarButtonItem = nil
            
           
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
        if((allSelected?.count)! == 1)
        {
            let infoButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.butDone(sender:)))//UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
            //UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
            // 3
           self.navigationItem.rightBarButtonItem = infoButton
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
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let text = (notelable!.text)!
        let termsRange = (text as NSString).range(of: "Sync Contacts")
        
        if gesture.didTapAttributedTextInLabel(label: notelable!, inRange: termsRange) {
            // print("Tapped terms")
           // showWEBVIEWScreen()
            showChatWindow()
        
        }else {
            
        }
    }
    @IBAction func butDone(sender:UIButton){
        if ClassReachability.isConnectedToNetwork()
        {
            self.navigationItem.rightBarButtonItem = nil
           // let alert = UIAlertController(title: title, message: "Do you really want to unblock these fans?", preferredStyle: .alert)
           // let action = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel,handler: {_ in
                
            //});
            //let action1 = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: {_ in
            if(self.AddType == "AddBlock")
            {
                LoadingIndicatorView.show(self.view, loadingText: "Blocking contact for you")
            }
            else if(self.AddType == "AddNew"){
                 LoadingIndicatorView.show(self.view, loadingText: "Adding contact for you")
            }
            
                let allSelected = self.storyTableView?.indexPathsForSelectedRows
                if((allSelected?.count)! > 0)
                {
                     let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                    let arrdUserJid = userJid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    //Forward chats
                    for sel in allSelected!
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let indexP: NSIndexPath = sel as NSIndexPath
                           // let arrrow = self.resultArry[indexP.section] as! NSArray
                            let dict2 = self.resultArry[indexP.row] as! NSDictionary
                            if(self.AddType == "AddBlock")
                            {
                                let login: String? = dict2.value(forKey: "jid") as? String
                                let arrReadUserJid = login?.components(separatedBy: "@")
                                let userReadUserJid = arrReadUserJid?[0]
                                
                                let myMobile: String? = userReadUserJid
                                self.appDelegate().getuserblock(blockuser: myMobile!)
                               /* var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "userblock" as AnyObject
                                
                                
                                
                                do {
                                    //Creating Request Data
                                    var dictRequestData = [String: AnyObject]()
                                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                    let arrdUserJid = myjid?.components(separatedBy: "@")
                                    let userUserJid = arrdUserJid?[0]
                                    
                                    let myjidtrim: String? = userUserJid
                                    //UserDefaults.standard.string(forKey: "myMobileNo")
                                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    dictRequestData["username"] = myjidtrim as AnyObject
                                    dictRequestData["blockedusername"] = myMobile as AnyObject
                                    dictRequestData["blockedtime"] = time as AnyObject
                                    dictRequestData["unblockedtime"] = 0 as AnyObject
                                    dictRequest["requestData"] = dictRequestData as AnyObject
                                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                    //print(dictRequest)
                                    
                                    let dataGetBanterDetails = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                    let strGetBanterDetails = NSString(data: dataGetBanterDetails, encoding: String.Encoding.utf8.rawValue)! as String
                                    //print(strGetBanterDetails)
                                    self.appDelegate().sendRequestToAPI(strRequestDict: strGetBanterDetails)
                                } catch {
                                    print(error.localizedDescription)
                                }*/
                                
                            }
                            else if(self.AddType == "AddNew"){
                                var dictRequest1 = [String: AnyObject]()
                                var strGetBanterDetails = ""
                                do {
                                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    
                                    dictRequest1["time"] = time as AnyObject
                                    
                                    dictRequest1["roomname"] = self.appDelegate().toName as AnyObject
                                    dictRequest1["roomtype"] = "group" as AnyObject
                                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                    //print(dictRequest)
                                    
                                    let dataGetBanterDetails = try JSONSerialization.data(withJSONObject: dictRequest1, options: .prettyPrinted)
                                    strGetBanterDetails = NSString(data: dataGetBanterDetails, encoding: String.Encoding.utf8.rawValue)! as String
                                } catch {
                                    print(error.localizedDescription)
                                }
                                let roomJID = XMPPJID(string: self.appDelegate().toUserJID)
                                let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                
                                let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                
                             
                                let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                history.addAttribute(withName: "maxchars", stringValue: "0")
                                if(!room.isJoined){
                                room.join(usingNickname: myJID!, history: history)
                                }

                                let inviteArrUser: String = dict2.value(forKey: "jid") as! String
                                   // let inviteUser = inviteArrUser[0]
                                 
                                    let userJid: XMPPJID = XMPPJID(string: inviteArrUser)!
                                   // if(myJID != inviteArrUser)
                                   // {
                                       
                                        room.inviteUser(userJid, withMessage: strGetBanterDetails)
                                let uuid = UUID().uuidString
                                let time: Int64 = self.appDelegate().getUTCFormateDate()
                                self.appDelegate().sendMessageToServer(inviteArrUser as AnyObject as! String, messageContent: userUserJid! + " has added you in Group: "  + self.appDelegate().toName, messageType: "header", messageTime: time, messageId: uuid, roomType: "group", messageSubType: "invite", roomid: self.appDelegate().toUserJID , roomName: self.appDelegate().toName)
                                
                                
                                        
                                        let arrReadUserJid = inviteArrUser.components(separatedBy: "@")
                                        let userReadUserJid = arrReadUserJid[0]
                                        
                                        let username: String? = userReadUserJid
                                self.appDelegate().savebanterroom(supportteam: 0, roomtype: "group", roomid: self.appDelegate().toUserJID,username:username!)
                                       /* var dictRequest = [String: AnyObject]()
                                        dictRequest["cmd"] = "savebanterroom" as AnyObject
                                        
                                        do {
                                            //Creating Request Data
                                            var dictRequestData = [String: AnyObject]()
                                            
                                            // let myMobile: String? = UserDefaults.standard.string(forKey: "myMobileNo")
                                            
                                            dictRequestData["roomid"] = self.appDelegate().toUserJID as AnyObject
                                            dictRequestData["supportteam"] = 0 as AnyObject
                                            
                                            dictRequestData["username"] = username as AnyObject
                                            dictRequestData["status"] = "active" as AnyObject
                                            
                                            dictRequest["requestData"] = dictRequestData as AnyObject
                                            //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                            //print(dictRequest)
                                            
                                            let dataSaveBanter = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                            let strSaveBanter = NSString(data: dataSaveBanter, encoding: String.Encoding.utf8.rawValue)! as String
                                            //print(strSaveBanter)
                                            self.appDelegate().sendRequestToAPI(strRequestDict: strSaveBanter)
                                        } catch {
                                            print(error.localizedDescription)
                                        }*/
                                   // }
                               // }
                                self.navigationController?.popViewController(animated: true)
                               
                                // self.dismiss(animated: true, completion: nil)
                            }
                            //let tmpSingleUserChat: [String: AnyObject] = dict2.value as! [String: AnyObject]
                          
                         
                            
                            
                            
                        }
                        
                        
                    }
                    let counter = (allSelected?.count)! + 2
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter)) {
                        LoadingIndicatorView.hide()
                    }
                    self.storyTableView?.reloadData()
                    
                }
                else{
                    self.alertWithTitle(title: "Error", message: "No fan selected.", ViewController: self)
                }
                
                
                
                //   self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showNewBanterNotify))
          //  });
           // alert.addAction(action)
           // alert.addAction(action1)
           // self.present(alert, animated: true, completion:nil)
            
            
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
   @IBAction  func showChatWindow() {
       /* appDelegate().showMainTab()
//showMainTab
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
        let notificationName = Notification.Name("tabindexchange")
        NotificationCenter.default.post(name: notificationName, object: nil)
        }*/
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    let registerController : ContactsTableViewController! = storyBoard.instantiateViewController(withIdentifier: "Contacts") as? ContactsTableViewController
    show(registerController, sender: self)
    }
func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
        
    });
    alert.addAction(action)
    self.present(alert, animated: true, completion:nil)
}
    @objc func UpdateBlockUnblockStatus(notification: NSNotification)
    {
        let  Status = (notification.userInfo?["userdetail"] )as! String + JIDPostfix
       
        //let  Status = (notification.userInfo?["userdetail"] )as! String
print(Status)
        if(!Status.isEmpty){
            
           // let login: String? = self.appDelegate().toUserJID
            
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            let array =  appDelegate().db.query(sql: "SELECT * FROM Blockeduser where roomId = '\(Status)' And chatType = 'chat'")
            if(array.count == 0){
                let BlockeduserTable = Blockeduser()
                BlockeduserTable.chatType = "chat"
                BlockeduserTable.roomId = Status
                BlockeduserTable.touser = Status
                BlockeduserTable.unblocked_time = 0
                BlockeduserTable.status = "Blocked"
                BlockeduserTable.blocked_time = time
                if BlockeduserTable.save() != 0 {
                   
                    
                }
            }
            else{
               
                let time: Int64 = self.appDelegate().getUTCFormateDate()
                //let login = self.appDelegate().toUserJID as String
                
                _ = appDelegate().db.query(sql: " UPDATE blockeduser SET status = 'Blocked', unblocked_time = 0,blocked_time = \(time) WHERE roomId = '\(Status)' And chatType = 'chat'")
              //  print(result)
            }
           
        }
        loaddata()
         LoadingIndicatorView.hide()
        //self.dismiss(animated: true, completion: nil)
    }
}
