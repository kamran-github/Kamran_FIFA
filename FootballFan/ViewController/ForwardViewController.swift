//
//  ForwardViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 25/08/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//
import UIKit

class ForwardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var storyTableView: UITableView?
    var FiltereddictAllChats = NSMutableArray()
    var dictAllChats = NSMutableArray()
    let cellReuseIdentifier = "forwardcontacts"
    var searchActive : Bool = false
    var searchStarting : Bool = false
    var selectedChatArr = NSMutableArray()
    var selectedRoomArr = NSMutableArray()
     @IBOutlet weak var storySearchBar: UISearchBar?
     lazy var lazyImage:LazyImage = LazyImage()
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
          storySearchBar?.delegate = self
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
         self.navigationItem.title = "Forward"
        loadBanters()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
   /* func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(searchActive) {
            return "Search Results"
        }
        
        return "Football Fan Contacts"
        
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive){
            return FiltereddictAllChats.count
        }
        return dictAllChats.count
        //return ((appDelegate().allAppContacts as AnyObject).count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ForwardCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ForwardCell
        //print(phoneFilteredContacts)
        if(searchActive){
            //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
            let dict2: NSDictionary? = FiltereddictAllChats[indexPath.row] as? NSDictionary
            let chatType: String = dict2?.value(forKey: "chatType") as! String
            if(chatType == "banter")
            {
                cell.contactImage2?.isHidden = false
                cell.VS?.isHidden = false
                cell.groupName?.isHidden = false
                cell.contactName?.isHidden = true
                cell.groupName?.text = dict2?.value(forKey: "userName") as? String
                
                
                if ((dict2?.value(forKey: "supportedTeam") != nil))
                {
                    
                    //print(dict2?.value(forKey: "supportedTeam") ?? "")
                    let teamId = dict2?.value(forKey: "supportedTeam") as! Int
                    
                    let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                    //print("Team Image Name: " + teamImageName)
                    
                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                    if((teamImage) != nil)
                    {
                        cell.contactImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                        
                        /*if(cell.chatImage?.image == nil)
                         {
                         appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                         }*/
                    }
                    else
                    {
                        cell.contactImage?.image = UIImage(named: "team")
                    }
                    
                }
                
                if ((dict2?.value(forKey: "opponentTeam") != nil))
                {
                    //print(dict2?.value(forKey: "opponentTeam") ?? "")
                    let teamId = dict2?.value(forKey: "opponentTeam") as! Int
                    
                    let teamImageName = "Team" + teamId.description
                    //let teamImageName = "Team" + String(describing: dict2?.value(forKey: "opponentTeam"))
                    //print("Team Image Name: " + teamImageName)
                    
                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                    if((teamImage) != nil)
                    {
                        cell.contactImage2?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                        
                        /*if(cell.chatImage?.image == nil)
                         {
                         appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                         }*/
                    }
                    else
                    {
                        cell.contactImage2?.image = UIImage(named: "team")
                    }
                }
                
                
                //dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
            }
            if(chatType == "teambr")
            {
                cell.contactImage2?.isHidden = true
                cell.VS?.isHidden = true
                cell.groupName?.isHidden = true
                cell.contactName?.isHidden = false
                cell.contactName?.text = dict2?.value(forKey: "userName") as? String
                cell.contactImage?.image = UIImage(named: "Invite_users")
                
                              if ((dict2?.value(forKey: "supportedTeam") != nil))
                              {
                                  
                                  //print(dict2?.value(forKey: "supportedTeam") ?? "")
                                  let teamId = dict2?.value(forKey: "supportedTeam") as! Int
                                  
                                  let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                                  //print("Team Image Name: " + teamImageName)
                                  
                                  let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                                  if((teamImage) != nil)
                                  {
                                      cell.contactImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                      
                                      /*if(cell.chatImage?.image == nil)
                                       {
                                       appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                                       }*/
                                  }
                                  else
                                  {
                                      cell.contactImage?.image = UIImage(named: "team")
                                  }
                                  
                              }
            }
            if(chatType == "group")
            {
                cell.contactImage2?.isHidden = true
                cell.VS?.isHidden = true
                cell.groupName?.isHidden = true
                cell.contactName?.isHidden = false
                cell.contactName?.text = dict2?.value(forKey: "userName") as? String
                cell.contactImage?.image = UIImage(named: "Invite_users")
                
            }
            else if(chatType == "chat"){
                cell.contactImage2?.isHidden = true
                cell.VS?.isHidden = true
                cell.groupName?.isHidden = true
                cell.contactName?.isHidden = false
                let fanname = appDelegate().ExistingContact(username: (dict2?.value(forKey: "JID") as? String)!)
                cell.contactName?.text = fanname//dict2?.value(forKey: "userName") as? String
                let avatar:String = (dict2?.value(forKey: "userAvatar") as? String)!
                if(!avatar.isEmpty)
                {
                    self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "avatar")
                }
                else{
                    cell.contactImage?.image = UIImage(named: "avatar")
                }
                cell.contactImage?.layer.masksToBounds = true;
                // cell.contactImage?.layer.borderWidth = 1.0
                //self.contentView.tintColor.cgColor
                cell.contactImage?.layer.cornerRadius = 17.5
                
            }
            cell.pickContact?.image = UIImage(named: (dict2?.value(forKey: "image") as? String)!)
            
            /*
             
             /*if( dict?.value(forKey: "colour") as? String == "blue")
             {
             //cell.pickContact?.backgroundColor = UIColor.blue
             
             }
             else
             {
             cell.pickContact?.backgroundColor = UIColor.clear
             }*/
             cell.pickContact?.image = UIImage(named: (dict?.value(forKey: "image") as? String)!)
             
             */
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
        }
        else
        {
            //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
            let dict2: NSDictionary? = dictAllChats[indexPath.row] as? NSDictionary
             let chatType: String = dict2?.value(forKey: "chatType") as! String
            if(chatType == "banter")
            {
                cell.contactImage2?.isHidden = false
                cell.VS?.isHidden = false
                cell.groupName?.isHidden = false
                cell.contactName?.isHidden = true
                cell.groupName?.text = dict2?.value(forKey: "userName") as? String
                
                
                if ((dict2?.value(forKey: "supportedTeam") != nil))
                {
                    
                    //print(dict2?.value(forKey: "supportedTeam") ?? "")
                    let teamId = dict2?.value(forKey: "supportedTeam") as! Int
                    
                    let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                    //print("Team Image Name: " + teamImageName)
                    
                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                    if((teamImage) != nil)
                    {
                        cell.contactImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                        
                        /*if(cell.chatImage?.image == nil)
                         {
                         appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                         }*/
                    }
                    else
                    {
                        cell.contactImage?.image = UIImage(named: "team")
                    }
                    
                }
                
                if ((dict2?.value(forKey: "opponentTeam") != nil))
                {
                    //print(dict2?.value(forKey: "opponentTeam") ?? "")
                    let teamId = dict2?.value(forKey: "opponentTeam") as! Int
                    
                    let teamImageName = "Team" + teamId.description
                    //let teamImageName = "Team" + String(describing: dict2?.value(forKey: "opponentTeam"))
                    //print("Team Image Name: " + teamImageName)
                    
                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                    if((teamImage) != nil)
                    {
                        cell.contactImage2?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                        
                        /*if(cell.chatImage?.image == nil)
                         {
                         appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                         }*/
                    }
                    else
                    {
                        cell.contactImage2?.image = UIImage(named: "team")
                    }
                }
                
                
                //dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
            }
            if(chatType == "teambr")
            {
                cell.contactImage2?.isHidden = true
                cell.VS?.isHidden = true
                cell.groupName?.isHidden = true
                cell.contactName?.isHidden = false
                cell.contactName?.text = dict2?.value(forKey: "userName") as? String
                cell.contactImage?.image = UIImage(named: "Invite_users")
                
                              if ((dict2?.value(forKey: "supportedTeam") != nil))
                              {
                                  
                                  //print(dict2?.value(forKey: "supportedTeam") ?? "")
                                  let teamId = dict2?.value(forKey: "supportedTeam") as! Int
                                  
                                  let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                                  //print("Team Image Name: " + teamImageName)
                                  
                                  let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                                  if((teamImage) != nil)
                                  {
                                      cell.contactImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                      
                                      /*if(cell.chatImage?.image == nil)
                                       {
                                       appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                                       }*/
                                  }
                                  else
                                  {
                                      cell.contactImage?.image = UIImage(named: "team")
                                  }
                                  
                              }
            }
            if(chatType == "group")
            {
                cell.contactImage2?.isHidden = true
                cell.VS?.isHidden = true
                cell.groupName?.isHidden = true
                cell.contactName?.isHidden = false
                cell.contactName?.text = dict2?.value(forKey: "userName") as? String
                 cell.contactImage?.image = UIImage(named: "Invite_users")
                
            }
            else if(chatType == "chat"){
                cell.contactImage2?.isHidden = true
                cell.VS?.isHidden = true
                cell.groupName?.isHidden = true
                cell.contactName?.isHidden = false
                 let fanname = appDelegate().ExistingContact(username: (dict2?.value(forKey: "JID") as? String)!)
                cell.contactName?.text = fanname//dict2?.value(forKey: "userName") as? String
                let avatar:String = (dict2?.value(forKey: "userAvatar") as? String)!
                if(!avatar.isEmpty)
                {
                    self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "avatar")
                }
                else{
                    cell.contactImage?.image = UIImage(named: "avatar")
                }
                cell.contactImage?.layer.masksToBounds = true;
               // cell.contactImage?.layer.borderWidth = 1.0
                //self.contentView.tintColor.cgColor
                cell.contactImage?.layer.cornerRadius = 17.5
                
            }
            cell.pickContact?.image = UIImage(named: (dict2?.value(forKey: "image") as? String)!)
            
            /*
            
            /*if( dict?.value(forKey: "colour") as? String == "blue")
             {
             //cell.pickContact?.backgroundColor = UIColor.blue
             
             }
             else
             {
             cell.pickContact?.backgroundColor = UIColor.clear
             }*/
            cell.pickContact?.image = UIImage(named: (dict?.value(forKey: "image") as? String)!)
            
            */
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ForwardCell
        
        //tmpSelected.add(indexPath)
        cell.isForward = true
       // cell.pickContact?.backgroundColor = cell.contentView.tintColor
        //print(tmpSelected)
        //let colour = cell.contentView.tintColor
        
        //let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
        //dict?.setValue("blue", forKey: "colour")
        if(selectedRoomArr.count < 5){
        cell.pickContact?.image = UIImage(named: "check")
        if(searchActive){
            let dict: NSDictionary = FiltereddictAllChats[indexPath.row] as! NSDictionary
            let filterJID = dict.value(forKey: "JID") as! String
             for i in 0...dictAllChats.count-1 {
                
                var dict1: [String : AnyObject] = dictAllChats[i] as! [String : AnyObject]
                let JID = dict1["JID"] as! String
                if(JID == filterJID){
                    dict1["image"] = "check" as AnyObject
                    selectedRoomArr.add(dict1)
                    dictAllChats.replaceObject(at: indexPath.row, with: dict1)
                }
                
            }
        }
        else{
            var dict: [String : AnyObject] = dictAllChats[indexPath.row] as! [String : AnyObject]
            
            dict["image"] = "check" as AnyObject
            
            dictAllChats.replaceObject(at: indexPath.row, with: dict)
            selectedRoomArr.add(dict)
           
        }
       // let allSelected = self.storyTableView?.indexPathsForSelectedRows
        if(selectedRoomArr.count > 0)
        {
            self.navigationItem.rightBarButtonItem = nil
            
            let button1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.forwardChat))
            let rightSearchBarButtonItem1:UIBarButtonItem = button1
            //UIBarButtonItem(barButtonSystemItem: UIImage(named: "imagename"), target: self, action: .plain, action: Selector(Banterdelete))//UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
            // 3
            self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
            
        }
        }
        else{
            alertWithTitle1(title: nil, message: "You can forward to maximum 5 Groups or Banter Rooms or Chats.", ViewController: self)
            /* let superView = self.view
            superView!.becomeFirstResponder()
            let ReportMenuItem = UIMenuItem(title: "You can forward to maximum 5 Groups or Banter Rooms or Chats.", action:  #selector(reportTapped))
            UIMenuController.shared.menuItems = [ReportMenuItem]
            UIMenuController.shared.arrowDirection = UIMenuControllerArrowDirection.down
            UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 200, width: 300, height: 300), in: superView!)
            
            // Animate the menu onto view
            UIMenuController.shared.setMenuVisible(true, animated: true)*/
        }
      /*  var dict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        dict["image"] = "check"
        appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict)*/
       
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    @objc func reportTapped() {
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ForwardCell
        //cell.isForward = false
        //cell.pickContact?.backgroundColor = UIColor.clear
        cell.pickContact?.image = UIImage(named: "uncheck")
        //var tmpDict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        //tmpDict["colour"] = "clear"
        //appDelegate().allAppContacts[indexPath.row] = tmpDict
        if(searchActive){
            let dict: NSDictionary = FiltereddictAllChats[indexPath.row] as! NSDictionary
            let filterJID = dict.value(forKey: "JID") as! String
            for i in 0...dictAllChats.count-1 {
                
                var dict1: [String : AnyObject] = dictAllChats[i] as! [String : AnyObject]
                let JID = dict1["JID"] as! String
                if(JID == filterJID){
                    selectedRoomArr.remove(dict1)
                    dict1["image"] = "uncheck" as AnyObject
                    
                    dictAllChats.replaceObject(at: indexPath.row, with: dict1)
                    
                }
                
            }
        }
        else{
        var dict: [String : AnyObject] = dictAllChats[indexPath.row] as! [String : AnyObject]
            selectedRoomArr.remove(dict)
        dict["image"] = "uncheck" as AnyObject
        dictAllChats.replaceObject(at: indexPath.row, with: dict)
            
        }
       // let allSelected = self.storyTableView?.indexPathsForSelectedRows
        print(selectedRoomArr.count)
        if(selectedRoomArr.count == 0)
        {
            
            self.navigationItem.rightBarButtonItem = nil
           
        }
            
        //appDelegate().allAppContacts[indexPath.row] = dict
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
        
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func loadBanters()
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
         var encountered = Set<String>()
        for tmpAllUserChats in appDelegate().arrAllChats
        {
            let tmpSingleUserChat: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
            let chatType: String = tmpSingleUserChat["chatType"] as! String
             let toUserJID = tmpSingleUserChat["roomJID"] as! String
            if(toUserJID != appDelegate().toUserJID){
               
                  //  let array = Blockeduser.rows(filter:"roomId = '\(toUserJID)'") as! [Blockeduser]
                   // if(array.count == 0){
                        if(chatType == "banter")
                        {
                            let isJoined = tmpSingleUserChat["isJoined"] as! String
                            let banterStatus = tmpSingleUserChat["banterStatus"] as! String
                            if(banterStatus == "active"){
                                if(!isJoined.contains("no") && !isJoined.contains("block")){
                                    //print(tmpSingleUserChat["userName"] as! String)
                                   // print(isJoined)
                                    tmpArrAllChats[tmpAllUserChats.key] = tmpAllUserChats.value
                                }
                            }
                           
                            
                            //dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
                        }
                else if(chatType == "teambr")
                {
                    let isJoined = tmpSingleUserChat["isJoined"] as! String
                    let banterStatus = tmpSingleUserChat["banterStatus"] as! String
                    if(banterStatus == "active"){
                        if(!isJoined.contains("no") && !isJoined.contains("block")){
                            //print(tmpSingleUserChat["userName"] as! String)
                           // print(isJoined)
                            tmpArrAllChats[tmpAllUserChats.key] = tmpAllUserChats.value
                        }
                    }
                   
                    
                    //dictAllChats.setValue(tmpAllUserChats.value, forKey: tmpAllUserChats.key)
                }
                        if(chatType == "group")
                        {
                            let isJoined = tmpSingleUserChat["isJoined"] as! String
                            let banterStatus = tmpSingleUserChat["banterStatus"] as! String
                            if(banterStatus == "active"){
                            if(!isJoined.contains("no") && !isJoined.contains("block")){
                                //print(tmpSingleUserChat["userName"] as! String)
                               // print(isJoined)
                                tmpArrAllChats[tmpAllUserChats.key] = tmpAllUserChats.value
                            }
                            }
                        }
                        else if(chatType == "chat"){
                            let array = Blockeduser.rows(filter:"roomId = '\(toUserJID)'") as! [Blockeduser]
                            if(array.count == 0){
                            tmpArrAllChats[tmpAllUserChats.key] = tmpAllUserChats.value
                            encountered.insert(toUserJID)
                            }
                        }
                    
              //  }
             
               
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
     
        //dictAllChats = tmpArrAllChats as NSDictionary
        
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
                let mili1: Double = Double(truncating: (date1["lastDate"] as AnyObject) as! NSNumber) //(date1["lastTime"] as! NSString).doubleValue //Double((val1 as AnyObject) as! NSNumber)
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
            tmpDict["image"] = "uncheck" as AnyObject
            dictAllChats.add(tmpDict)
        }
        if(appDelegate().allAppContacts.count > 0)
        {
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
            for arr in tmpArr
            {
                var tmpDict = arr as! [String : AnyObject]
                let Jid = tmpDict["jid"] as! String
                if encountered.contains(Jid) {
                    // Do not add a duplicate element.
                }
                else {
                    // Add value to the set.
                    
                    // ... Append the value.
                    // result.append(value)
                    let array = Blockeduser.rows(filter:"roomId = '\(Jid)'") as! [Blockeduser]
                    if(array.count == 0){
                     let avatar = tmpDict["avatar"] as! String
                      let fanname = appDelegate().ExistingContact(username: Jid )
                    tmpDict["JID"] = Jid as AnyObject
                    tmpDict["image"] = "uncheck" as AnyObject
                    tmpDict["chatType"] = "chat" as AnyObject
                    tmpDict["userAvatar"] = avatar as AnyObject
                    tmpDict["userName"] = fanname as AnyObject
                     dictAllChats.add(tmpDict)
                    }
                }
                
                
                
            }
        }
        //dictAllChats = appDelegate().arrAllChats as NSDictionary
        //print(dictAllChats)
        storyTableView?.reloadData()
    }
    
    
    /*func pickContact(_ sender: UIButton!)
     {
     
     //var indexPath: NSIndexPath!
     
     
     if let superview = sender.superview {
     if let cell = superview.superview as? ForwardCell {
     if(cell.isSelected)
     {
     cell.isSelected = false
     cell.pickContact?.setTitle("C", for: UIControlState.normal)
     }
     else
     {
     cell.isSelected = true
     cell.pickContact?.setTitle("S", for: UIControlState.normal)
     }
     
     }
     }
     }*/
    
    @IBAction func cancelForward () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forwardChat () {
        DispatchQueue.main.async {
          //  let allSelected = self.storyTableView?.indexPathsForSelectedRows
            //print(allSelected ?? " Failed")
            //let currentUserJID = self.appDelegate().toUserJID
            if(self.selectedRoomArr.count > 0)
            {
                //Forward chats
                 var time: Int64 = self.appDelegate().getUTCFormateDate()
                for i in 0...self.selectedRoomArr.count-1 {
                    
                    //let indexP: NSIndexPath = sel as NSIndexPath
                    if let tmpDict: NSDictionary = self.selectedRoomArr[i] as? NSDictionary{
                        //print(tmpDict)
                        //var indexPath: NSIndexPath!
                        //print(self.appDelegate().arrUserChat)
                        //print(self.appDelegate().selectedForwardIndex.row)
                        //print(self.appDelegate().arrUserChat.count)
                        var mySupportedTeam: Int64 = 0
                        let recRoomType = tmpDict.value(forKey: "chatType") as! String
                        if(recRoomType == "banter"){
                            mySupportedTeam = tmpDict.value(forKey: "mySupportedTeam") as! Int64
                        }
                        if(recRoomType == "teambr"){
                            mySupportedTeam = tmpDict.value(forKey: "mySupportedTeam") as! Int64
                        }
                        let toUserJID = tmpDict.value(forKey: "JID") as! String
                        let banterNickName = tmpDict.value(forKey: "userName") as! String
                        
                        for message in self.selectedChatArr
                        {
                            let messageType = (message as AnyObject).value(forKey: "messageType") as! String
                            let messageContent = (message as AnyObject).value(forKey: "messageContent") as! String
                            let fileLocalId = (message as AnyObject).value(forKey: "fileLocalId") as! String
                            
                            let filePath = (message as AnyObject).value(forKey: "filePath") as! String
                            let thumb = (message as AnyObject).value(forKey: "thumb") as! String
                            
                            
                            //Change chats of selected users
                           // self.appDelegate().toUserJID = tmpDict["jid"]!
                            //print(self.appDelegate().toUserJID)
                            //print(self.appDelegate().arrAllChats)
                            //var tmpArrChatDetails = [String : AnyObject]()
                            if(self.currentReachabilityStatus != .notReachable && self.appDelegate().isUserOnline == true)
                            {
                                let uuid = UUID().uuidString
                               
                                //print(time)
                                 time = time + 1000
                                print(time)
                               /* let myMilliseconds: UnixTime = UnixTime(Double(time1)/1000.0)
                                let calendar = NSCalendar.autoupdatingCurrent
                               let timeStampTmp = calendar.date(byAdding: .second, value: +1, to: myMilliseconds.dateFull)
                                let time: Int64 = timeStampTmp!.millisecondsSince1970*/
                                
                                if(messageType == "text"){
                                    self.appDelegate().prepareMessageForServerOut(toUserJID, messageContent: messageContent, chatType: recRoomType, messageType: "text", messageTime: time, messageId: uuid,userName:banterNickName, chatStatus: "sent", newBanterNickName: banterNickName, mySupportedTeam: mySupportedTeam, messageSubType: "Forwarded")
                                    // print(appDelegate().toUserJID)
                                    self.appDelegate().sendMessageToServer(toUserJID, messageContent: messageContent, messageType: "text", messageTime: time, messageId: uuid, roomType: recRoomType, messageSubType: "Forwarded", mySupportTeam: mySupportedTeam)
                                    
                                }
                                if(messageType == "image" || messageType == "video"){
                                    //self.appDelegate().prepareMessageForServerOut(toUserJID, messageContent: messageContent, chatType: recRoomType, messageType: "text", messageTime: time, messageId: uuid,userName:banterNickName, chatStatus: "sent", newBanterNickName: banterNickName, mySupportedTeam: mySupportedTeam)
                                    // print(appDelegate().toUserJID)
                                    self.appDelegate().prepareMessageForServerOut(toUserJID, messageContent: messageContent, chatType: recRoomType, messageType: messageType, messageTime: time, messageId: uuid, filePath: filePath, fileLocalId: fileLocalId, caption: "", thumbLink: thumb,userName:banterNickName, chatStatus: "sent", newBanterNickName: banterNickName,mySupportedTeam: mySupportedTeam, messageSubType: "Forwarded")
                                    self.appDelegate().sendMessageToServer(toUserJID, messageContent: messageContent, messageType: messageType, messageTime: time, messageId: uuid, caption: "", thumbLink: thumb, roomType: recRoomType, messageSubType: "Forwarded",mySupportTeam: mySupportedTeam)
                                    
                                  //  self.appDelegate().sendMessageToServer(toUserJID, messageContent: messageContent, messageType: "text", messageTime: time, messageId: uuid, roomType: recRoomType, mySupportTeam: mySupportedTeam)
                                    
                                }
                               
                                
                            }
                            else
                            {
                                let uuid = UUID().uuidString
                                //let time: Int64 = self.appDelegate().getUTCFormateDate()
                               time = time + 1000
                                print(time)
                               if(messageType == "text"){
                                self.appDelegate().prepareMessageForServerOut(toUserJID, messageContent: messageContent, chatType: recRoomType, messageType: "text", messageTime: time, messageId: uuid,userName:banterNickName, chatStatus: "failed", newBanterNickName: banterNickName, mySupportedTeam: mySupportedTeam, messageSubType: "Forwarded")
                                }
                                if(messageType == "image" || messageType == "video"){
                                    //self.appDelegate().prepareMessageForServerOut(toUserJID, messageContent: messageContent, chatType: recRoomType, messageType: "text", messageTime: time, messageId: uuid,userName:banterNickName, chatStatus: "sent", newBanterNickName: banterNickName, mySupportedTeam: mySupportedTeam)
                                    // print(appDelegate().toUserJID)
                                    self.appDelegate().prepareMessageForServerOut(toUserJID, messageContent: messageContent, chatType: recRoomType, messageType: messageType, messageTime: time, messageId: uuid, filePath: filePath, fileLocalId: fileLocalId, caption: "", thumbLink: thumb,userName:banterNickName, chatStatus: "failed", newBanterNickName: banterNickName,mySupportedTeam: mySupportedTeam, messageSubType: "Forwarded")
                                   // self.appDelegate().sendMessageToServer(toUserJID, messageContent: messageContent, messageType: messageType, messageTime: time, messageId: uuid, caption: "", thumbLink: thumb, roomType: recRoomType, messageSubType: "Forwarded",mySupportTeam: mySupportedTeam)
                                    
                                    //  self.appDelegate().sendMessageToServer(toUserJID, messageContent: messageContent, messageType: "text", messageTime: time, messageId: uuid, roomType: recRoomType, mySupportTeam: mySupportedTeam)
                                    
                                }
                            }
                          
                        }
                       /* let message: NSDictionary = self.appDelegate().arrUserChat[self.appDelegate().selectedForwardIndex.row] as! NSDictionary
                        let messageType = message.value(forKey: "messageType") as! String
                        let messageContent = message.value(forKey: "messageContent") as! String
                        let fileLocalId = message.value(forKey: "fileLocalId") as! String
                        
                        let filePath = message.value(forKey: "filePath") as! String
                        let thumb = message.value(forKey: "thumb") as! String
                        
                        
                        //Change chats of selected users
                        self.appDelegate().toUserJID = tmpDict["jid"]!
                        //print(self.appDelegate().toUserJID)
                        //print(self.appDelegate().arrAllChats)
                        //var tmpArrChatDetails = [String : AnyObject]()
                        if var tmpArrChatDetails: [String : AnyObject] = self.appDelegate().arrAllChats[self.appDelegate().toUserJID] as? [String : AnyObject]
                        {
                            //var tmpArrUserChat = tmpArrChatDetails["Chats"] as! [AnyObject]
                            
                            self.appDelegate().arrUserChat = tmpArrChatDetails["Chats"] as! [AnyObject]//tmpArrUserChat
                        }
                        else
                        {
                            self.appDelegate().arrUserChat = [AnyObject]()
                        }
                        //end
                        
                        let uuid = UUID().uuidString
                        let time: Int64 = self.appDelegate().getUTCFormateDate()
                        
                        let login: String? = UserDefaults.standard.string(forKey: "userJID")
                        self.appDelegate().prepareMessageForServerOut(tmpDict["jid"]!, messageContent: messageContent, messageType: messageType, messageTime: time, messageId: uuid, filePath: filePath, fileLocalId: fileLocalId, caption: "", thumbLink: thumb,  fromUser: login!,userName: tmpDict["name"]!, userAvatar: tmpDict["avatar"]!)
                        
                        self.appDelegate().sendMessageToServer(tmpDict["jid"]!, messageContent: messageContent, messageType: messageType, messageTime: time, messageId: uuid, caption: "", thumbLink: thumb, roomType: self.appDelegate().curRoomType)
                        
                        //Change chats of current users
                        self.appDelegate().toUserJID = currentUserJID
                        if var tmpArrChatDetails2: [String : AnyObject] = self.appDelegate().arrAllChats[self.appDelegate().toUserJID] as? [String : AnyObject]
                        {
                            //var tmpArrUserChat = tmpArrChatDetails["Chats"] as! [AnyObject]
                            
                            self.appDelegate().arrUserChat = tmpArrChatDetails2["Chats"] as! [AnyObject]//tmpArrUserChat
                        }
                        else
                        {
                            self.appDelegate().arrUserChat = [AnyObject]()
                        }
                        //end
                        
                        let notificationName = Notification.Name("MessageReceivedFromServer")
                        NotificationCenter.default.post(name: notificationName, object: nil)
                        
                        */
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
        
        //self.dismiss(animated: true, completion: nil)
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ForwardViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ForwardViewController.realDelegate!;
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        storySearchBar?.showsCancelButton = true
        searchStarting = true
        storyTableView?.reloadData()
        //searchActive = true
    }
    
    /*func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
     //searchActive = false;
     }*/
    
    /*func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
     //let but: UIButton = searchBar.value(forKey: "_cancelButton") as! UIButton
     //but.isUserInteractionEnabled = true
     if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
     cancelButton.isEnabled = true
     }
     
     return true;
     }*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        storySearchBar?.text = ""
        FiltereddictAllChats = dictAllChats.mutableCopy() as! NSMutableArray
        storySearchBar?.resignFirstResponder()
        storySearchBar?.showsCancelButton = false
        searchActive = false
        searchStarting = false
       // noContactFound?.isHidden = true
        storyTableView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        //storySearchBar?.text = ""
        //phoneFilteredContacts = appDelegate().allPhoneContacts.mutableCopy() as! NSMutableArray
        storySearchBar?.resignFirstResponder()
        if let cancelButton = storySearchBar?.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        searchActive = true
        searchStarting = true
        storySearchBar?.showsCancelButton = false
        //searchActive = false;
        //storyTableView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        FiltereddictAllChats = NSMutableArray()
        let result = dictAllChats.filter({ (text) -> Bool in
            let tmp: NSDictionary = text as! NSDictionary
            let val = tmp.value(forKey: "userName")
            let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
       /* let result1 = dictAllChats.filter({ (text) -> Bool in
            let tmp: NSDictionary = text as! NSDictionary
            let val = tmp.value(forKey: "userName")
            let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })*/
        
        for record in result {
            FiltereddictAllChats[FiltereddictAllChats.count] = record
        }
      /*  for record1 in result1 {
            FiltereddictAllChats[FiltereddictAllChats.count] = record1
        }*/
        
        /* if(result.count>0)
         {
         phoneFilteredContacts = NSMutableArray(array: result)//result as! NSMutableArray
         }
         else
         {
         phoneFilteredContacts = NSMutableArray()
         }
         if(result1.count>0)
         {
         
         for record in result1 {
         phoneFilteredContacts[phoneFilteredContacts.count] = record
         }
         // phoneFilteredContacts = NSMutableArray(array: result1)//result as! NSMutableArray
         }
         else
         {
         if(result.count == 0)
         {
         phoneFilteredContacts = NSMutableArray()
         }
         }*/
        /*let predicateFormat = NSString(format: "name MATCHES[c] '(%@).*'", searchText)
         let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
         
         let sectionArray = phoneNotSplitContacts.filtered(using: predicate)
         if(sectionArray.count > 0)
         {
         phoneFilteredContacts[phoneFilteredContacts.count] = sectionArray
         }*/
        
        if(FiltereddictAllChats.count == 0){
           // noContactFound?.isHidden = false
            //showNocontactfound()
        } else {
           // noContactFound?.isHidden = true
        }
        searchActive = true
        storyTableView?.reloadData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
/*
import UIKit

class ForwardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var storyTableView: UITableView?
    var phoneFilteredContacts = NSMutableArray()
    let cellReuseIdentifier = "forwardcontacts"
    var searchActive : Bool = false
    var searchStarting : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
        //self.storyTableView?.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
        let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
        if strAllContacts != nil
        {
            //Code to parse json data
            if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    //appDelegate().allContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray as! NSMutableArray
                    let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                    
                    appDelegate().allContacts = NSMutableArray()
                    for record in tmpAllContacts {
                        appDelegate().allContacts[appDelegate().allContacts.count] = record
                    }
                    
                    //appDelegate().allContacts = tmpAllAppContacts as! NSMutableArray
                    //appDelegate().allAppContacts = appDelegate().allContacts[0] as! NSMutableArray
                    
                    let tmpAllAppContacts = appDelegate().allContacts[0] as! NSArray
                    
                    appDelegate().allAppContacts = NSMutableArray()
                    for record in tmpAllAppContacts {
                        appDelegate().allAppContacts[appDelegate().allAppContacts.count] = record
                    }
                    
                    //print(appDelegate().allAppContacts)
                    
                    /*var size = 0
                    repeat {
                        let colour = "clear"
                        tmpSelected.add(colour)
                        // Increment.
                        size += 1
                        
                    } while size < appDelegate().allAppContacts.count*/
                    let tmpArryContact = NSMutableArray()
                    if(appDelegate().allAppContacts.count > 0)
                    {
                        for rec in appDelegate().allAppContacts
                        {
                            var dict: [String : String] = rec as! [String : String]
                            dict["image"] = "uncheck"
                            tmpArryContact[tmpArryContact.count] = dict
                        }
                    }
                    
                    if(tmpArryContact.count > 0)
                    {
                        appDelegate().allAppContacts = tmpArryContact
                    }
                    
                    
                    //print(tmpSelected.count)
                    //print(appDelegate().allAppContacts.count)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(searchActive) {
            return "Search Results"
        }
        
        return "Football Fan Contacts"
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive){
            return phoneFilteredContacts.count
        }
        
        return ((appDelegate().allAppContacts as AnyObject).count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ForwardCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ForwardCell
        //print(phoneFilteredContacts)
        if(searchActive){
            //let arry: NSArray? = phoneFilteredContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            cell.contactImage?.isHidden = true
            //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
            cell.contactName?.frame.origin.x = 15.0
            cell.contactStatus?.frame.origin.x = 15.0
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
            if(cell.isSelected)
            {
                cell.pickContact?.backgroundColor = cell.contentView.tintColor
            }
            else
            {
                cell.pickContact?.backgroundColor = UIColor.clear
            }
            
        }
        else
        {
            //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
            let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            
            if(dict?.value(forKey: "avatar") != nil)
            {
                let avatar:String = (dict?.value(forKey: "avatar") as? String)!
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
            
            /*if( dict?.value(forKey: "colour") as? String == "blue")
            {
                //cell.pickContact?.backgroundColor = UIColor.blue
                
            }
            else
            {
                cell.pickContact?.backgroundColor = UIColor.clear
            }*/
            cell.pickContact?.image = UIImage(named: (dict?.value(forKey: "image") as? String)!)
            
            
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ForwardCell
        
        //tmpSelected.add(indexPath)
        cell.isForward = true
        cell.pickContact?.backgroundColor = cell.contentView.tintColor
        //print(tmpSelected)
        //let colour = cell.contentView.tintColor
        
        //let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
        //dict?.setValue("blue", forKey: "colour")
        cell.pickContact?.image = UIImage(named: "check")
        
        var dict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        dict["image"] = "check"
        appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict)
        
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ForwardCell
        //cell.isForward = false
        //cell.pickContact?.backgroundColor = UIColor.clear
        cell.pickContact?.image = UIImage(named: "uncheck")
        //var tmpDict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        //tmpDict["colour"] = "clear"
        //appDelegate().allAppContacts[indexPath.row] = tmpDict
        
        var dict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        dict["image"] = "uncheck"
        appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict)
        //appDelegate().allAppContacts[indexPath.row] = dict
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
        
    }
    
    
    
    
    /*func pickContact(_ sender: UIButton!)
    {
     
        //var indexPath: NSIndexPath!
     
     
        if let superview = sender.superview {
            if let cell = superview.superview as? ForwardCell {
                if(cell.isSelected)
                {
                    cell.isSelected = false
                    cell.pickContact?.setTitle("C", for: UIControlState.normal)
                }
                else
                {
                    cell.isSelected = true
                    cell.pickContact?.setTitle("S", for: UIControlState.normal)
                }
                
            }
        }
    }*/
    
    @IBAction func cancelForward () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forwardChat () {
        DispatchQueue.main.async {
            let allSelected = self.storyTableView?.indexPathsForSelectedRows
            print(allSelected ?? " Failed")
            let currentUserJID = self.appDelegate().toUserJID
            if((allSelected?.count)! > 0)
            {
                //Forward chats
                for sel in allSelected!
                {
                    let indexP: NSIndexPath = sel as NSIndexPath
                    if let tmpDict: [String : String] = self.appDelegate().allAppContacts[indexP.row] as? [String : String]
                    {
                        //print(tmpDict)
                        //var indexPath: NSIndexPath!
                        print(self.appDelegate().arrUserChat)
                        print(self.appDelegate().selectedForwardIndex.row)
                        print(self.appDelegate().arrUserChat.count)
                        
                        let message: NSDictionary = self.appDelegate().arrUserChat[self.appDelegate().selectedForwardIndex.row] as! NSDictionary
                        let messageType = message.value(forKey: "messageType") as! String
                        let messageContent = message.value(forKey: "messageContent") as! String
                        let fileLocalId = message.value(forKey: "fileLocalId") as! String
                        
                        let filePath = message.value(forKey: "filePath") as! String
                        let thumb = message.value(forKey: "thumb") as! String
                        
                        
                        //Change chats of selected users
                        self.appDelegate().toUserJID = tmpDict["jid"]!
                        //print(self.appDelegate().toUserJID)
                        //print(self.appDelegate().arrAllChats)
                        //var tmpArrChatDetails = [String : AnyObject]()
                        if var tmpArrChatDetails: [String : AnyObject] = self.appDelegate().arrAllChats[self.appDelegate().toUserJID] as? [String : AnyObject]
                        {
                            //var tmpArrUserChat = tmpArrChatDetails["Chats"] as! [AnyObject]
                            
                            self.appDelegate().arrUserChat = tmpArrChatDetails["Chats"] as! [AnyObject]//tmpArrUserChat
                        }
                        else
                        {
                            self.appDelegate().arrUserChat = [AnyObject]()
                        }
                        //end
                        
                        let uuid = UUID().uuidString
                        let time: Int64 = self.appDelegate().getUTCFormateDate()
                        
                        let login: String? = UserDefaults.standard.string(forKey: "userJID")
                        self.appDelegate().prepareMessageForServerOut(tmpDict["jid"]!, messageContent: messageContent, messageType: messageType, messageTime: time, messageId: uuid, filePath: filePath, fileLocalId: fileLocalId, caption: "", thumbLink: thumb,  fromUser: login!,userName: tmpDict["name"]!, userAvatar: tmpDict["avatar"]!)
                        
                        self.appDelegate().sendMessageToServer(tmpDict["jid"]!, messageContent: messageContent, messageType: messageType, messageTime: time, messageId: uuid, caption: "", thumbLink: thumb, roomType: self.appDelegate().curRoomType)
                        
                        //Change chats of current users
                        self.appDelegate().toUserJID = currentUserJID
                        if var tmpArrChatDetails2: [String : AnyObject] = self.appDelegate().arrAllChats[self.appDelegate().toUserJID] as? [String : AnyObject]
                        {
                            //var tmpArrUserChat = tmpArrChatDetails["Chats"] as! [AnyObject]
                            
                            self.appDelegate().arrUserChat = tmpArrChatDetails2["Chats"] as! [AnyObject]//tmpArrUserChat
                        }
                        else
                        {
                            self.appDelegate().arrUserChat = [AnyObject]()
                        }
                        //end
                        
                        let notificationName = Notification.Name("MessageReceivedFromServer")
                        NotificationCenter.default.post(name: notificationName, object: nil)
                        
                        
                    }
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}*/
