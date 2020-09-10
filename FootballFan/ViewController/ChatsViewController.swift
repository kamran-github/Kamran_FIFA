//
//  ChatsViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 19/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import XMPPFramework

class ChatsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "chats"
    var dictAllChats = NSMutableArray()
    var isFromNewChat: Bool = false
    var strings:[String] = []
     @IBOutlet weak var loginview: UIView?
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var loginimageview: UIImageView?
    @IBOutlet weak var loginmsg: UILabel?
    @IBOutlet weak var loginbut: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(showCreateNewChat))
        //Set message received notification
        let notificationName = Notification.Name("RefreshChatsView")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChatsViewController.refreshChats), name: notificationName, object: nil)
      
        //Code to check if all contacts synced already
        if(appDelegate().allContacts.count == 0)
        {
            let strAllContactsLocal: String? = UserDefaults.standard.string(forKey: "allContacts")
            if strAllContactsLocal != nil
            {
                //Code to parse json data
                if let data = strAllContactsLocal?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    do {
                        let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                        
                        for record in jsonData {
                            appDelegate().allContacts[appDelegate().allContacts.count] = record
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                //Fetch non split contacts for filter from local
                let strNonSplitContactsLocal: String? = UserDefaults.standard.string(forKey: "allNonSplitContacts")
                if strNonSplitContactsLocal != nil
                {
                    //Code to parse json data
                    if let data = strNonSplitContactsLocal?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do {
                            let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                            
                            for record in jsonData {
                                appDelegate().phoneNotSplitContacts[appDelegate().phoneNotSplitContacts.count] = record
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
                
            }
        }
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
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        appDelegate().isOnChatsView = false
        
        
    }

   @IBAction func addchatRoom () {
       showCreateNewChat()
       
   }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Chats"
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.appDelegate().isUpdatesLoaded = false
        if(appDelegate().isFromNewChat == false){
            appDelegate().toUserJID = ""

        }
     
       
        appDelegate().isOnChatsView = true
        refreshChats()
        appDelegate().curRoomType = "chat"
        
        //Temp code
        //showChatWindow()
        //end
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login == nil)
        {
         
            storyTableView?.isHidden = true
            notelable?.isHidden = true
            let but: String? = UserDefaults.standard.string(forKey: "chatloginmbut")
            loginbut?.setTitle(but, for: .normal)
            let message: String? = UserDefaults.standard.string(forKey: "chatloginmsg")
            loginmsg?.text = message
            
            let mediaurl: String? = UserDefaults.standard.string(forKey: "chatloginmurl")
            let mediatype: String? = UserDefaults.standard.string(forKey: "chatloginmtype")
            if(mediatype == "gif"){
                // messageimg.imageURL = mediaurl
                let arrReadselVideoPath = mediaurl!.components(separatedBy: "/")
                let imageId = arrReadselVideoPath.last
                let arrReadimageId = imageId?.components(separatedBy: ".")
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".gif")
                //try fileManager.removeItem(atPath: imageId)
                // Check if file exists
                if fileManager.fileExists(atPath: paths) {
                    //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "contacts", withExtension: "gif")!)
                    // let advTimeGif = UIImage.gifImageWithName("contacts")
                    // messageimg.image = advTimeGif
                    let fileName = arrReadimageId![0] + ".gif"
                    let fileURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(fileName)
                    if let imageData = NSData(contentsOf: fileURL!) {
                        let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                        loginimageview?.image = UIImage.gifImageWithData(imageData as Data)
                    }
                    
                    /* do {
                     if let imageData = NSData(contentsOfURL: paths) {
                     let image = UIImage(data: imageData) // Here you can attach image to UIImageView
                     }
                     let imageData = try Data(contentsOf: URL(string: paths)!)
                     messageimg.image = UIImage.gifImageWithData(imageData)
                     } catch {
                     print("Not able to load image")
                     }*/
                    
                }
                else{
                    loginimageview?.image = UIImage.gifImageWithURL(mediaurl!)
                }
                //
            }
            else{
                loginimageview?.imageURL = mediaurl
            }
             loginview?.isHidden = false
        }
        else{
            loginview?.isHidden = true
        }
      
    }
    
  
    @objc func showSettings() {
        //print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    
    
    @objc func refreshChats()
    {
        
        let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
        if localArrAllChats != nil
        {
            //Code to parse json data
            if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        //New code for Banter rooms, Group Chats and user updates
        var tmpArrAllChats = [String: AnyObject]()
        for tmpAllUserChats in appDelegate().arrAllChats
        {
            let tmpSingleUserChat: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
            let chatType: String = tmpSingleUserChat["chatType"] as! String
            if(chatType != "banter" && chatType != "trivia" && chatType != "teambr")
            {
                tmpArrAllChats[tmpAllUserChats.key] = tmpAllUserChats.value
                //dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
            }
            /*if((!chatType.isEmpty) && (chatType == "banter"))
            {
                dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
            }
            else
            {
                dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
            }*/
            
        }
        
        
        let tmpArr = tmpArrAllChats.sorted { (item1, item2) -> Bool in
            let date1 =  item1.value as! [String : AnyObject]
            let date2 =  item2.value as! [String : AnyObject]
            /*var val1: Int = 0
             var val2: Int = 0
             if date1["chatsOrder"] != nil
             {
             val1 = date1["chatsOrder"] as! Int
             }
             else
             {
             val1 = 0
             }
             if date2["chatsOrder"] != nil
             {
             val2 = date2["chatsOrder"] as! Int
             }
             else
             {
             val2 = 0
             }*/
            
            
            //let val1 = (date1["lastTime"] as NSString).doubleValue as! Int64
            //let val2 = date2["lastTime"] as! Int64
            var dt1: Date = Date()
            var dt2: Date = Date()
            
            if date1["lastDate"] != nil
            {
                //print(date1["lastDate"] as AnyObject)
                let mili1: Double = Double((date1["lastDate"] as AnyObject) as! NSNumber) //(date1["lastTime"] as! NSString).doubleValue //Double((val1 as AnyObject) as! NSNumber)
                let myMilliseconds1: UnixTime = UnixTime(mili1/1000.0)
                dt1 = myMilliseconds1.dateFull
                //print("Date1: " + dt1.description)
            }
            
            if date2["lastDate"] != nil
            {
                let mili2: Double = Double(truncating: (date2["lastDate"] as AnyObject) as! NSNumber) //(date2["lastTime"] as! NSString).doubleValue
                let myMilliseconds2: UnixTime = UnixTime(mili2/1000.0)
                dt2 = myMilliseconds2.dateFull
                //print("Date2: " + dt2.description)
            }
            
            
            
            return dt1.compare(dt2) == ComparisonResult.orderedDescending
        }

        
        dictAllChats = NSMutableArray()
        for arr in tmpArr
        {
            //print(arr.key)
            //arrAllChats[arr.key] = arr.value
            //dictAllChats.setValue(arr.value, forUndefinedKey: arr.key as! String)
            //dictAllChats.setValue(arr.value, forKey: arr.key)
            //dictAllChats.setValue(arr.value, forKey: arr.key as! String)
            var tmpDict = arr.value as! [String : AnyObject]
            tmpDict["JID"] = arr.key as AnyObject
            dictAllChats.add(tmpDict)
        }
        //print(dictAllChats)
       
        //dictAllChats = appDelegate().arrAllChats as NSDictionary
        //print(dictAllChats)
        storyTableView?.reloadData()
        let rowCnt: Int = (self.storyTableView?.numberOfRows(inSection: 0))!
        if(rowCnt == 0 )
        {   notelable?.isHidden = false
            let bullet1 = "You have no conversations yet."
            let bullet2 = "Tap on (+) at the top right corner of this screen to start a new conversation or go to the Contacts section."
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
            //let message = "No Chats found."
            //alertWithTitle(title: "Error", message: message, ViewController: self)
            
        }
        else{
            notelable?.isHidden = true
            
        }
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
     func showChatWindow(roomid: String,BanterClosed : String,roomtype : String, roomname : String, join : String,mySupportedTeam : Int64) {
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
           //present(registerController as! UIViewController, animated: true, completion: nil)
           registerController.opponentTeam = 0
           registerController.supportedTeam = 0
           
                         registerController.BanterClosed = BanterClosed
                         registerController.RoomType = roomtype
                        registerController.Roomname = roomname
                        registerController.isjoin = join
                         registerController.mySupportedTeam = mySupportedTeam
                        registerController.Roomid = roomid
           show(registerController, sender: self)
           
       }
    func showCreateNewGroup()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newGroupController : NewGroupViewController = storyBoard.instantiateViewController(withIdentifier: "NewGroup") as! NewGroupViewController
       
        self.present(newGroupController, animated: true, completion: nil)
    }
    
    @objc func showCreateNewChat()
    {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newChatController : NewChatViewController = storyBoard.instantiateViewController(withIdentifier: "NewChat") as! NewChatViewController
        isFromNewChat = true
         show(newChatController as UIViewController, sender: self)
        //self.present(newChatController, animated: true, completion: nil)
        }
        else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    
    // number of rows in table view
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictAllChats.count
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }
     */
     /* func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 80.0
     }*/
    
    // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AllChatsCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AllChatsCell
        
        
        //let index = dictAllChats.allKeys.startIndex.advanced(by: indexPath.row)
        //let key1 = dictAllChats.allKeys[index]
        //let dict2: NSDictionary? = dictAllChats.value(forKey: key1 as! String) as? NSDictionary
        let dict2: NSDictionary? = dictAllChats[indexPath.row] as? NSDictionary
        if let chatT: String = dict2?.value(forKey: "chatType") as? String
        {
            if(chatT == "chat")
            {
                //cell.chatImage?.image = UIImage(named: "Invite_users")
                if(appDelegate().allAppContacts.count>0){
                    
                    
                    var strName1: String = ""
                    _ = appDelegate().allAppContacts.filter({ (text) -> Bool in
                        let tmp: NSDictionary = text as! NSDictionary
                        let val: String = tmp.value(forKey: "jid") as! String
                        let val2: String = dict2?.value(forKey: "JID") as! String//(res as! NSDictionary).value(forKey: "username") as! String
                        
                        
                        if(val.contains(val2))
                        {
                           // let ind = tmp.value(forKey: "name") as! String
                            //print(ind)
                            //tempPoneContacts.removeObject(at: Int(ind))
                           
                                strName1 = tmp.value(forKey: "name") as! String
                           
                            
                            //return true
                        }
                        
                        // }
                        
                        
                        return false
                    })
                    if(!strName1.isEmpty){
                        cell.chatName?.text = strName1//dict2?.value(forKey: "userName") as? String
                    }
                    else{
                        let recReadUserJid = dict2?.value(forKey: "JID") as! String
                        
                        let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                        let userReadUserJid = arrReadUserJid[0]
                        cell.chatName?.text = userReadUserJid
                    }
                }
                else{
                    let recReadUserJid = dict2?.value(forKey: "JID") as! String
                    
                    let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                    let userReadUserJid = arrReadUserJid[0]
                    cell.chatName?.text = userReadUserJid
                }
            }
            else
            {
                cell.chatName?.text = dict2?.value(forKey: "userName") as? String
            }
            
        }
        else{
            cell.chatName?.text = dict2?.value(forKey: "userName") as? String
        }
        //cell.chatName?.text = dict2?.value(forKey: "userName") as? String
        cell.lastMessage?.text = dict2?.value(forKey: "lastMessage") as? String
        //cell.chatTime?.text = dict2?.value(forKey: "lastTime") as? String
        //print(dict2?.value(forKey: "lastMessage") as? String)
        var msgtime = ""
        if let mili = dict2?.value(forKey: "lastDate")
        {
            let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yy HH:mm"
            //dateFormatter.dateStyle = .short
            
            let now = Date()
            let birthday: Date = myMilliseconds.dateFull as Date
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.hour], from: birthday, to: now)
            let timebefore = Int64(ageComponents.hour!)
            if(timebefore > 24){
                msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
            }
            else{
                dateFormatter.dateFormat = "HH:mm"
                msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
            }
            
            
        }
        cell.chatTime?.text = "Last Activity: " + msgtime
        if ((dict2?.value(forKey: "badgeCounts") != nil))
        {
            let badgeCnt: Int = (dict2?.value(forKey: "badgeCounts") as? Int)!
            cell.badgeCount?.text = String(badgeCnt)

            if(badgeCnt > 0)
            {
                if(badgeCnt>99 && badgeCnt<999){
                    cell.badgeCountsConstraint.constant = CGFloat(40.0)
                }
                else if(badgeCnt>999){
                    cell.badgeCountsConstraint.constant = CGFloat(60.0)
                }
                else{
                    cell.badgeCountsConstraint.constant = CGFloat(20.0)
                }
                cell.badgeCount?.isHidden = false
                cell.badgeCount?.text = String(badgeCnt)
                //cell.badgeCount?.sizeToFit()
                //cell.badgeCount?.frame.size = CGSize(width: (cell.badgeCount?.intrinsicContentSize.width)!, height: (cell.badgeCount?.frame.height)!)
                cell.badgeCount?.backgroundColor = UIColor.init(hex: "FFD401")//self.view.tintColor
                cell.badgeCount?.layer.masksToBounds = true;
                //cell.badgeCount?.layer.borderWidth = 1.0
               // cell.badgeCount?.layer.borderColor = //UIColor.init(hex: "FFD401").cgColor
                cell.badgeCount?.layer.cornerRadius = 10
                 cell.lastMessage?.textColor = UIColor.black
            }
            else
            {
                cell.badgeCount?.text = ""
                cell.badgeCount?.isHidden = true
                 cell.lastMessage?.textColor = UIColor.init(hex: "9A9A9A")
            }
        }
        
        
        if(dict2?.value(forKey: "userAvatar") != nil)
        {
            let avatar:String = (dict2?.value(forKey: "userAvatar") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.chatImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                appDelegate().loadImageFromUrl(url: avatar, view: cell.chatImage!)
            }
            else
            {
                if let chatT = dict2?.value(forKey: "chatType")
                {
                    if((chatT as! String) == "group")
                    {
                        cell.chatImage?.image = UIImage(named: "Invite_users")
                    }
                    else
                    {
                        cell.chatImage?.image = UIImage(named: "avatar")
                    }
                    
                }
                else
                {
                    cell.chatImage?.image = UIImage(named: "avatar")
                }
                
            }
        }
        else
        {
            //cell.chatImage?.image = UIImage(named: "user")
            if let chatT = dict2?.value(forKey: "chatType")
            {
                if((chatT as! String) == "group")
                {
                    cell.chatImage?.image = UIImage(named: "Invite_users")
                }
                else
                {
                    cell.chatImage?.image = UIImage(named: "avatar")
                }
                
            }
            else
            {
                cell.chatImage?.image = UIImage(named: "avatar")
            }
        }
        cell.chatImage?.layer.masksToBounds = true;
        cell.chatImage?.clipsToBounds=true;
        // contactImage?.layer.borderWidth = 1.0
        //  contactImage?.layer.borderColor = UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0).cgColor
        cell.chatImage?.contentMode =  UIView.ContentMode.scaleAspectFit
        cell.chatImage?.layer.cornerRadius = 35.0
        //cell.countryImage?.image = UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
        if let chatT = dict2?.value(forKey: "chatType")
        {
            if((chatT as! String) == "group")
            {
                if let joined = dict2?.value(forKey: "isJoined")
                {
                    if (joined as! String == "yes") {
                        if ((dict2?.value(forKey: "fansCount") != nil))
                        {
                            let fansCount: Int = (dict2?.value(forKey: "fansCount") as? Int)!
                            
                            if(fansCount > 0)
                            {
                                cell.fanCount?.isHidden = false
                                if(fansCount == 1)
                                {
                                    cell.fanCount?.text = "Fan: \(fansCount )"
                                }
                                else{
                                    cell.fanCount?.text = "Fans: \(self.appDelegate().formatNumber(fansCount) )"
                                }
                            }
                            else{
                                cell.fanCount?.isHidden = true
                            }
                        }
                        else{
                            cell.fanCount?.isHidden = true
                        }
                    }
                    else{
                        cell.fanCount?.isHidden = true
                    }
                }
            }
            else{
                cell.fanCount?.isHidden = true
            }
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("You tapped cell number \(indexPath.row).")
        
        var Roomname: String =  ""
         var isjoin: String =  ""
         var isBanterClosed: String =  ""
        var curRoomType: String =  ""
        var toUserJID: String =  ""
        var mySupportedTeam: Int64 =  0
        
       
        let dict2: NSDictionary? = dictAllChats[indexPath.row] as? NSDictionary
        //appDelegate().toUserJID = key1 as! String
       toUserJID = dict2?.value(forKey: "JID") as! String
      //  print(dict2?.value(forKey: "JID") as! String)
        
        // By Mayank for group chat
        if(dict2?.value(forKey: "chatType") as! String == "group") {
            //Calling this room users
            appDelegate().getbanterroomusers(roomid:  toUserJID)
          
        }
        
        // By Mayank for group chat
        if let chatT: String = dict2?.value(forKey: "chatType") as? String
        {
            if(chatT == "chat")
            {
                 Roomname =  self.appDelegate().ExistingContact(username: toUserJID)!//(dict.value(forKey: "username") as? String)!
                        
            
        }
        else{
            Roomname = (dict2?.value(forKey: "userName") as? String)!
        }
      
        
        }
        if(dict2?.value(forKey: "userAvatar") != nil)
        {
            appDelegate().toAvatarURL = (dict2?.value(forKey: "userAvatar") as? String)!
        }
        else
        {
            appDelegate().toAvatarURL = ""
        }
        
        if let chatType = dict2?.value(forKey: "chatType")
        {
         curRoomType = chatType as! String
        }
        else
        {
           curRoomType = "chat"
        }
        if let closed = dict2?.value(forKey: "banterStatus")
        {
            if((closed as! String) == "closed")
            {
                isBanterClosed = closed as! String
            }
            else
            {
                isBanterClosed = "active"
            }
            
        }
        else
        {
            isBanterClosed = "active"
        }

       
             self.showChatWindow(roomid: toUserJID, BanterClosed: isBanterClosed, roomtype: curRoomType, roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static var realDelegate: AppDelegate?
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ChatsViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ChatsViewController.realDelegate!;
    }
    
    func xmppStream() -> XMPPStream {
        return appDelegate().xmppStream!
    }
    @IBAction func modleAction(){
        let action: String? = UserDefaults.standard.string(forKey: "chatloginaction")
        if(action == "login"){
            appDelegate().LoginwithModelPopUp()
            
        }
    }
    
}
