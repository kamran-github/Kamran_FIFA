//
//  BantersViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 07/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import XMPPFramework
import AVFoundation
import Alamofire
class BantersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "chats"
    var dictAllChats = NSMutableArray()
    //var banterTeams: NSMutableArray = []
    var Selectedcount: Int = 0
    var supportedTeam: Int64 = 0
    var opponentTeam: Int64 = 0
    var isMultiSelection = false
    @IBOutlet weak var badgeCountsConstraint: NSLayoutConstraint!
    var strings:[String] = []
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint?
    @IBOutlet weak var Connectinglabel: UILabel?
    @IBOutlet weak var loginview: UIView?
    @IBOutlet weak var loginimageview: UIImageView?
    @IBOutlet weak var loginmsg: UILabel?
    @IBOutlet weak var loginbut: UIButton?
     var refreshTable: UIRefreshControl!
     @IBOutlet weak var removelist: UIButton?
     @IBOutlet weak var banterdelete: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate().fillMyTeams()
     
        //Set message received notification
        let notificationName = Notification.Name("RefreshBantersView")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(BantersViewController.refreshChatsNotification), name: notificationName, object: nil)
      
        
        let notificationName2 = Notification.Name("_isUserOnline")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(BantersViewController.isUserOnline), name: notificationName2, object: nil)
        
        
        let notificationName3 = Notification.Name("RefreshBantersViewFromOthers")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(BantersViewController.RefreshBantersViewFromOthers), name: notificationName3, object: nil)
        
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
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(BantersViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.storyTableView?.addGestureRecognizer(longPressGesture)
        storyTableView?.isUserInteractionEnabled = true
        refreshTable = UIRefreshControl()
               refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(getUserGroupsData(_:)), for: UIControl.Event.valueChanged)
        storyTableView?.addSubview(refreshTable)
       
              
               
    }
    @objc func getUserGroupsData(_ sender: AnyObject)
       {
           Clslogging.logdebug(State: "getuserrooms start")
           //Code to call all rooms API
        isMultiSelection = false
               storyTableView?.allowsMultipleSelection = false
               //self.parent?.navigationItem.rightBarButtonItems = nil
               //self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "banters_add"), style: .plain, target: self, action: #selector(showNewBanterNotify))
        banterdelete?.isHidden = true
                           removelist?.isHidden = true
               for i in 0...dictAllChats.count-1 {
                   //print(i)
                   var dict: [String : AnyObject] = dictAllChats[i] as! [String : AnyObject]
                   dict["checkimage"] = "uncheck" as AnyObject
                   
                   dictAllChats[i] = dict as AnyObject
                   let roomid: String = dict["JID"] as! String
                   
                   deleteChatAtIndex(roomid: roomid, indexPath: i)
               }
               if(self.appDelegate().isOnBantersView == true)
               {
                   //Post notification if user is on chats window and received any message
                   let notificationName = Notification.Name("RefreshBantersView")
                   NotificationCenter.default.post(name: notificationName, object: nil)
               }
           var dictRequest = [String: AnyObject]()
           dictRequest["cmd"] = "getuserrooms" as AnyObject
           dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
           dictRequest["device"] = "ios" as AnyObject
          
           do {
               //Creating Request Data
               var dictRequestData = [String: AnyObject]()
               
               let login: String? = UserDefaults.standard.string(forKey: "userJID")
               let arrReadUserJid = login?.components(separatedBy: "@")
               let userReadUserJid = arrReadUserJid?[0]
               
               let myMobile: String? = userReadUserJid//UserDefaults.standard.string(forKey: "myMobileNo")
               dictRequestData["username"] = myMobile as AnyObject
               
               dictRequest["requestData"] = dictRequestData as AnyObject
            
                                                                               AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                                                                                                               headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                                                                                                                 // 2
                                                                                                                 .responseJSON { response in
                                                                                                                     switch response.result {
                                                                                                                                                             case .success(let value):
                                                                                                                                                                 if let json = value as? [String: Any] {
                                                                                                                                                                                                                                                                                                  let status1: Bool = json["success"] as! Bool
                                                                                                                                                                                                                     if(status1){
                                                                                                                                                                                                                         let response: NSArray = json["responseData"] as! NSArray //jsonData?.value(forKey: "responseData") as! NSArray
                                                                                                                                                                                                                                               //print("getuserrooms:")
                                                                                                                                                                                                                                               //print(response)
                                                                                                                                                                                                                                               //let roomDetails: NSDictionary = response[0] as! NSDictionary
                                                                                                                                                                                                                         for res in response
                                                                                                                                                                                                                         {
                                                                                                                                                                                                                             let roomDetailsDict: NSDictionary = res as! NSDictionary
                                                                                                                                                                                                                             
                                                                                                                                                                                                                             let roomId = roomDetailsDict.value(forKey: "roomid") as! String
                                                                                                                                                                                                                             let banterName = roomDetailsDict.value(forKey: "roomname") as! String
                                                                                                                                                                                                                             let isAdmin = roomDetailsDict.value(forKey: "isAdmin") as! Bool
                                                                                                                                                                                                                             let roomStatus = roomDetailsDict.value(forKey: "roomstatus") as! String
                                                                                                                                                                                                                             let roomType = roomDetailsDict.value(forKey: "roomtype") as! String
                                                                                                                                                                                                                             if self.appDelegate().arrAllChats[roomId] != nil
                                                                                                                                                                                                                                                                              {
                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                              else{
                                                                                                                                                                                                                                 //let mili: Int64 = self.appDelegate().getUTCFormateDate()
                                                                                                                                                                                                                                                                                  let lastactivitytime: Int64? = Int64(roomDetailsDict.value(forKey: "lastactivitytime") as! String)
                                                                                                                                                                                                                                                                                  let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                                                                                                                                                                                                  //curRoomType = "banter"
                                                                                                                                                                                                                                 if(roomType == "banter"){
                                                                                                                                                                                                                                     let supportTeam = roomDetailsDict.value(forKey: "supportteam") as! Int64
                                                                                                                                                                                                                                                                                     let opponentTeam = roomDetailsDict.value(forKey: "opponentteam") as! Int64
                                                                                                                                                                                                                                     self.appDelegate().prepareMessageForServerIn(roomId , messageContent: "You are invited to this Banter Room.\nYou can join this Banter Room by tapping on Join button.", messageType: "header", messageTime: lastactivitytime!, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: myJID!, isIncoming: "YES", chatType: "banter" , banterRoomName: banterName, isJoined: "no", isAdmin: "no", supportedTeam: Int64(supportTeam), opponentTeam: Int64(opponentTeam))
                                                                                                                                                                                                                                     let notificationName = Notification.Name("RefreshBantersView")
                                                                                                                                                                                                                                     NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                 }
                                                                                                                                                                      else if(roomType == "teambr"){
                                                                                                                                                                          let supportTeam = roomDetailsDict.value(forKey: "supportteam") as! Int64
                                                                                                                                                                                                                          let opponentTeam = roomDetailsDict.value(forKey: "opponentteam") as! Int64
                                                                                                                                                                                                                                     self.appDelegate().prepareMessageForServerIn(roomId , messageContent: "You are invited to this Banter Room.\nYou can join this Banter Room by tapping on Join button.", messageType: "header", messageTime: lastactivitytime!, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: myJID!, isIncoming: "YES", chatType: "teambr" , banterRoomName: banterName, isJoined: "no", isAdmin: "no", supportedTeam: Int64(supportTeam), opponentTeam: Int64(opponentTeam))
                                                                                                                                                                          let notificationName = Notification.Name("RefreshBantersView")
                                                                                                                                                                          NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                          
                                                                                                                                                                      }                                                           else if(roomType == "group" ){
                                                                                                                                                                              //messageContent = "You are now ready to post messages, pictures, videos in this group."
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                             }
                                                                                                                                                                                          
                                                                                                                                                                                                                         }
                                                                                                                                                                                                                         if(self.refreshTable.isRefreshing)
                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                 self.refreshTable.endRefreshing()
                                                                                                                                                                                                                                }
                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                     else{
                                                                                                                                                                                                                         if(self.refreshTable.isRefreshing)
                                                                                                                                                                                                                                {
                                                                                                                                                                                                                                 self.refreshTable.endRefreshing()
                                                                                                                                                                                                                                }
                                                                                                                                                                                                                     }
                                                                                                                                                                     
                                                                                                                                                                 }
                                                                                                                                                             case .failure(let error):
                                                                               if(self.refreshTable.isRefreshing)
                                                                                                                                {
                                                                                                                                    self.refreshTable.endRefreshing()
                                                                                                                                }
                                                                                                                        debugPrint(error)
                                                                                                                        break
                                                                                                                                                                 // error handling
                                                                                                                                                  
                                                                                                                                                             }
                                               }
               
                                                 /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                                  let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                                                  //print(strFanUpdates)
                                                  self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)*/
                                             
           } catch {
               print(error.localizedDescription)
            if(refreshTable.isRefreshing)
                   {
                       refreshTable.endRefreshing()
                   }
           }
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        self.parent?.navigationItem.leftBarButtonItem = nil
       self.parent?.navigationItem.rightBarButtonItems = nil
        //self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "banters_add"), style: .plain, target: self, action: #selector(showNewBanterNotify))
        banterdelete?.isHidden = true
                           removelist?.isHidden = true
        self.appDelegate().isUpdatesLoaded = false
             isMultiSelection = false
        /* let settingsImage   = UIImage(named: "settings")!
         let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.showSettings))
         self.parent?.navigationItem.leftBarButtonItem = settingsButton
         */
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
                       refreshChats()
                   }
        appDelegate().toUserJID = ""
        appDelegate().isOnBantersView = true
        
        appDelegate().curRoomType = ""
        
        
        Selectedcount = 0
        
        
        let userD: UserDefaults = UserDefaults.init(suiteName: "group.com.tridecimal.ltd.footballfan")!
        userD.set("Message from background", forKey: "push")
        userD.synchronize()
        
        
        /*let userD2: UserDefaults = UserDefaults(suiteName: "group.com.tridecimal.ltd.footballfan")!
         let login: String? = userD2.string(forKey: "pop")
         //print(login ?? "")
         var title: String = "Test title pop"
         if(login != nil)
         {
         title = login!
         }
         print(title)*/
        self.parent?.title = "Banter"
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            if ClassReachability.isConnectedToNetwork() {
                self.parent?.title = "Banter"
                loginview?.isHidden = true
                
                if(appDelegate().isUserOnline)
                {
                    //self.parent?.title = "Banter Rooms"
                    ConectingHightConstraint?.constant = CGFloat(0.0)
                }
                else
                {
                    Connectinglabel?.text = "Connecting..."
                    ConectingHightConstraint?.constant = CGFloat(0.0)
                    //self.parent?.title = "Connecting.."
                }
                
               
                
            } else {
                // self.parent?.title = "Waiting for network.."
                loginview?.isHidden = true
                
                Connectinglabel?.text = "Waiting for network..."
                ConectingHightConstraint?.constant = CGFloat(20.0)
            }
        }
        else{
            if ClassReachability.isConnectedToNetwork() {
                Connectinglabel?.text = "Connecting..."
                ConectingHightConstraint?.constant = CGFloat(0.0)
            }else{
                Connectinglabel?.text = "Waiting for network..."
                ConectingHightConstraint?.constant = CGFloat(20.0)
            }
            appDelegate().pageafterlogin = "banter"
            appDelegate().idafterlogin = 0
            let but: String? = UserDefaults.standard.string(forKey: "banterloginmbut")
            loginbut?.setTitle(but, for: .normal)
            let message: String? = UserDefaults.standard.string(forKey: "banterloginmsg")
            loginmsg?.text = message
            
            let mediaurl: String? = UserDefaults.standard.string(forKey: "banterloginmurl")
            let mediatype: String? = UserDefaults.standard.string(forKey: "banterloginmtype")
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
                        //let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                        loginimageview?.image = UIImage.gifImageWithData(imageData as Data)
                    }
                 
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
            storyTableView?.isHidden = true
            //ConectingHightConstraint.constant = CGFloat(0.0)
        }
        let usermobileno = UserDefaults.standard.string(forKey: "isprofileNotSelected")
        if( usermobileno != nil)
        {
            
            UserDefaults.standard.setValue("yes", forKey: "isprofileNotSelected")
            UserDefaults.standard.synchronize()
            let notificationName1 = Notification.Name("Showprofile")
            NotificationCenter.default.post(name: notificationName1, object: nil)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate().isOnBantersView = false
        if(isMultiSelection){
            /*  for i in 0...dictAllChats.count-1 {
             //print(i)
             var dict: [String : AnyObject] = dictAllChats[i] as! [String : AnyObject]
             dict["checkimage"] = "uncheck" as AnyObject
             
             dictAllChats[i] = dict as AnyObject
             let roomid: String = dict["JID"] as! String
             
             deleteChatAtIndex(roomid: roomid, indexPath: i)
             }
             */
            Selectedcount = 0
            isMultiSelection = false
            banterdelete?.isHidden = true
            removelist?.isHidden = true
            storyTableView?.allowsMultipleSelection = false
        }
        
        
    }
    
    
    @objc func showSettings() {
        //  print("Show stettings")
        /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
         
         self.present(settingsController, animated: true, completion: nil)*/
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : SettingsViewController! = storyBoard.instantiateViewController(withIdentifier: "Settings") as? SettingsViewController
        // present(registerController, animated: true, completion: nil)
        
        
        show(registerController, sender: self)
        
    }
    
    @objc func isUserOnline()
    {
        DispatchQueue.main.async {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
                self.loginview?.isHidden = true
                if(self.appDelegate().isOnBantersView)
                {
                    if ClassReachability.isConnectedToNetwork() {
                        
                        if(self.appDelegate().isUserOnline)
                        {
                            // LoadingIndicatorView.hide()
                            // self.parent?.title = "Banter Rooms"
                            self.parent?.title = "Banter"
                            self.ConectingHightConstraint?.constant = CGFloat(0.0)
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.Connectinglabel?.text = "Connecting..."
                                self.ConectingHightConstraint?.constant = CGFloat(0.0)
                            }
                            //LoadingIndicatorView.hide()
                            // self.parent?.title = "Banter Rooms"
                            //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading banters.")
                            // self.parent?.title = "Connecting.."
                        }
                        
                        
                    } else {
                        
                        LoadingIndicatorView.hide()
                        self.Connectinglabel?.text = "Waiting for network..."
                        self.ConectingHightConstraint?.constant = CGFloat(20.0)
                        //self.ConectingHightConstraint.constant = CGFloat(20.0)
                        //  }
                        //self.parent?.title = "Waiting for network.."
                        
                    }
                }
            }
            else{
                if ClassReachability.isConnectedToNetwork() {
                    self.Connectinglabel?.text = "Connecting..."
                    self.ConectingHightConstraint?.constant = CGFloat(0.0)
                }else{
                    self.Connectinglabel?.text = "Waiting for network..."
                    self.ConectingHightConstraint?.constant = CGFloat(20.0)
                }
                // ConectingHightConstraint.constant = CGFloat(0.0)
            }
        }
    }
    
    func refreshChats()
    {// DispatchQueue.background(background: {
        // do something in background
        let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
        if localArrAllChats != nil
        {
            //Code to parse json data
            if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        //New code for Banter rooms, Group Chats and user updates
        var tmpArrAllChats = [String: AnyObject]()
        for tmpAllUserChats in self.appDelegate().arrAllChats
        {
            let tmpSingleUserChat: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
            let chatType: String = tmpSingleUserChat["chatType"] as! String
            if(chatType == "banter" || chatType == "teambr")
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
        let banterSequence: Bool? = UserDefaults.standard.bool(forKey: "banterSequence")
        if(banterSequence == true){
            
            
            let tmpArr = tmpArrAllChats
            for arr in tmpArr
            {
                //print(arr.key)
                //arrAllChats[arr.key] = arr.value
                //dictAllChats.setValue(arr.value, forUndefinedKey: arr.key as! String)
                //dictAllChats.setValue(arr.value, forKey: arr.key)
                //dictAllChats.setValue(arr.value, forKey: arr.key as! String)
                var tmpDict = arr.value as! [String : AnyObject]
                tmpDict["JID"] = arr.key as AnyObject
                self.dictAllChats.add(tmpDict)
            }
            //.setValue(tmpArrAllChats.value, forKey: tmpAllUserChats.key)
        }
        else{
            //dictAllChats = tmpArrAllChats as NSDictionary
            
            let tmpArr = tmpArrAllChats.sorted { (item1, item2) -> Bool in
                let date1 =  item1.value as! [String : AnyObject]
                let date2 =  item2.value as! [String : AnyObject]
             
                var dt1: Date = Date()
                var dt2: Date = Date()
                
                if date1["lastDate"] != nil
                {
                    // print(date1["lastDate"] as AnyObject)
                    let mili1: Double = Double(truncating: (date1["lastDate"] as AnyObject) as! NSNumber) //(date1["lastTime"] as! NSString).doubleValue //Double((val1 as AnyObject) as! NSNumber)
                    let myMilliseconds1: UnixTime = UnixTime(mili1/1000.0)
                    dt1 = myMilliseconds1.dateFull
                   // print("Date1: " + dt1.description)
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
            
            self.dictAllChats = NSMutableArray()
            for arr in tmpArr
            {
                //print(arr.key)
                //arrAllChats[arr.key] = arr.value
                //dictAllChats.setValue(arr.value, forUndefinedKey: arr.key as! String)
                //dictAllChats.setValue(arr.value, forKey: arr.key)
                //dictAllChats.setValue(arr.value, forKey: arr.key as! String)
                var tmpDict = arr.value as! [String : AnyObject]
                tmpDict["JID"] = arr.key as AnyObject
                self.dictAllChats.add(tmpDict)
            }
        }
       
        self.isMultiSelection = false
        self.storyTableView?.allowsMultipleSelection = false
        self.storyTableView?.reloadData()
        if (self.dictAllChats.count > 0) {
           // let indexPath = IndexPath(row: 0, section: 0)
            //self.storyTableView?.selectRow(at: indexPath , animated: false, scrollPosition: .bottom)
            //self.storyTableView?.scrollToRow(at: indexPath, at: .none, animated: false)
            LoadingIndicatorView.hide()
            self.notelable?.isHidden = true
        }
        else{
            LoadingIndicatorView.hide()
            
            self.notelable?.isHidden = false
            let bullet1 = "You have no conversations yet."
            let bullet2 = "Tap on (+) at the top right corner of this screen to start a new conversation. "
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            self.strings = [bullet1, bullet2]
            // let boldText  = "Quick Information \n"
            let attributesDictionary = [kCTForegroundColorAttributeName : self.notelable?.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedString.Key : Any])
            //  let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
            //let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
            //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: boldString)
            
            //fullAttributedString.append(boldString)
            for string: String in self.strings
            {
                //let _: String = ""
                let formattedString: String = "\(string)\n\n"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
                
                let paragraphStyle = self.createParagraphAttribute()
                attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                
                let range1 = (formattedString as NSString).range(of: "Invite")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
                
                let range2 = (formattedString as NSString).range(of: "Settings")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
                
                fullAttributedString.append(attributedString)
            }
            
            
            self.notelable?.attributedText = fullAttributedString
            
            // let message = "No Banter Rooms found."
            //alertWithTitle(title: "Error", message: message, ViewController: self)
        }
        
       /* let rowCnt: Int = (self.storyTableView?.numberOfRows(inSection: 0))!
        if(rowCnt > 0)
        {
            LoadingIndicatorView.hide()
            self.notelable?.isHidden = true
        }
        else{
            LoadingIndicatorView.hide()
            
            self.notelable?.isHidden = false
            let bullet1 = "You have no conversations yet."
            let bullet2 = "Tap on (+) at the top right corner of this screen to start a new conversation. "
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            self.strings = [bullet1, bullet2]
            // let boldText  = "Quick Information \n"
            let attributesDictionary = [kCTForegroundColorAttributeName : self.notelable?.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedString.Key : Any])
            //  let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
            //let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
            //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: boldString)
            
            //fullAttributedString.append(boldString)
            for string: String in self.strings
            {
                //let _: String = ""
                let formattedString: String = "\(string)\n\n"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
                
                let paragraphStyle = self.createParagraphAttribute()
                attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                
                let range1 = (formattedString as NSString).range(of: "Invite")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
                
                let range2 = (formattedString as NSString).range(of: "Settings")
                attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
                
                fullAttributedString.append(attributedString)
            }
            
            
            self.notelable?.attributedText = fullAttributedString
            
            // let message = "No Banter Rooms found."
            //alertWithTitle(title: "Error", message: message, ViewController: self)
        }
        */
        // when background job finished, do something in main thread
        //  })
        
        //LoadingIndicatorView.hide()
        
        //UserDefaults.standard.setValue(nil, forKey: "isRegisterProcess")
        //UserDefaults.standard.synchronize()
    }
    
    @objc func refreshChatsNotification()
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
            if(chatType == "banter" || chatType == "teambr")
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
        
        
        
        //dictAllChats = tmpArrAllChats as NSDictionary
        
        let banterSequence: Bool? = UserDefaults.standard.bool(forKey: "banterSequence")
        if(banterSequence == true){
            let tmpArr = tmpArrAllChats
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
            //.setValue(tmpArrAllChats.value, forKey: tmpAllUserChats.key)
        }
        else{
            let tmpArr = tmpArrAllChats.sorted { (item1, item2) -> Bool in
                let date1 =  item1.value as! [String : AnyObject]
                let date2 =  item2.value as! [String : AnyObject]
             
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
                dictAllChats.add(tmpDict)
            }
            
        }
        
        
        
        //dictAllChats = appDelegate().arrAllChats as NSDictionary
        //print(dictAllChats)
        storyTableView?.reloadData()
        
        let rowCnt: Int = (self.storyTableView?.numberOfRows(inSection: 0))!
        if(rowCnt > 0)
        {
            if(appDelegate().isBanterLoaderOn == true){
                LoadingIndicatorView.hide()
            }
            notelable?.isHidden = true
        }
        else{
            LoadingIndicatorView.hide()
            
            notelable?.isHidden = false
            let bullet1 = "You have no conversations yet."
            let bullet2 = "Tap on (+) at the top right corner of this screen to start a new conversation. "
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
            
            // let message = "No Banter Rooms found."
            //alertWithTitle(title: "Error", message: message, ViewController: self)
        }
        appDelegate().isBanterLoaderOn = false
        /*  if(dictAllChats.count == 0)
         {
         let message = "No Banter Rooms found."
         alertWithTitle(title: "Error", message: message, ViewController: self)
         }*/
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
    @objc func RefreshBantersViewFromOthers()
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
            if(chatType == "banter" || chatType == "teambr")
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
        
        
        
        //dictAllChats = tmpArrAllChats as NSDictionary
        
        let tmpArr = tmpArrAllChats.sorted { (item1, item2) -> Bool in
            let date1 =  item1.value as! [String : AnyObject]
            let date2 =  item2.value as! [String : AnyObject]
           
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
            dictAllChats.add(tmpDict)
        }
        
        
        
        //dictAllChats = appDelegate().arrAllChats as NSDictionary
        //print(dictAllChats)
        storyTableView?.reloadData()
        
        let rowCnt: Int = (self.storyTableView?.numberOfRows(inSection: 0))!
        if(rowCnt > 0)
        {
            if(appDelegate().isBanterLoaderOn == true){
                LoadingIndicatorView.hide()
            }
        }
        appDelegate().isBanterLoaderOn = false
        
    }
    
    
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    func showChatWindow(roomid: String,BanterClosed : String,roomtype : String, roomname : String, join : String,mySupportedTeam : Int64) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
        //present(registerController as! UIViewController, animated: true, completion: nil)
        registerController.opponentTeam = opponentTeam
        registerController.supportedTeam = supportedTeam
        
                      registerController.BanterClosed = BanterClosed
                      registerController.RoomType = roomtype
                     registerController.Roomname = roomname
                     registerController.isjoin = join
                      registerController.mySupportedTeam = mySupportedTeam
                     registerController.Roomid = roomid
        show(registerController, sender: self)
        
    }

    
    @objc func showNewBanterNotify() {
        
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            appDelegate().aponentTeamName = ""
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "NewBanter")
            //present(registerController as! UIViewController, animated: true, completion: nil)
            self.present(registerController as! UIViewController, animated: true)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
        /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let previewController : onlyforscreenshort! = storyBoard.instantiateViewController(withIdentifier: "screenshort") as! onlyforscreenshort
         
         
         /*show(previewController!, sender: self)*/
         self.present(previewController, animated: true, completion: nil)*/
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictAllChats.count
    }
    
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }
     */
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 105.0
     }*/
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AllChatsCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AllChatsCell
        
        
        //let index = dictAllChats.allKeys.startIndex.advanced(by: indexPath.row)
        //let key1 = dictAllChats.allKeys[index]
        //let dict2: NSDictionary? = dictAllChats.value(forKey: key1 as! String) as? NSDictionary
        let dict2: NSDictionary? = dictAllChats[indexPath.row] as? NSDictionary
        
        cell.chatName?.text = dict2?.value(forKey: "userName") as? String
        cell.lastMessage?.text = dict2?.value(forKey: "lastMessage") as? String
        
        //print(dict2?.value(forKey: "lastDate") as? String)
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
        if ((dict2?.value(forKey: "supportedTeam") != nil))
        {
            
            //print(dict2?.value(forKey: "supportedTeam") ?? "")
            let teamId = dict2?.value(forKey: "supportedTeam") as! Int
            
            let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
            //print("Team Image Name: " + teamImageName)
            
            let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
            if((teamImage) != nil)
            {
                cell.chatImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                
                /*if(cell.chatImage?.image == nil)
                 {
                   appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "team_logo") as? String)!,view: (cell.colImage)!, fileName: teamImageName as String)
                 }*/
            }
            else
            {
                let array1 = Teams_details.rows(filter:"team_Id = \(teamId)") as! [Teams_details]
                          if(array1.count != 0){
                              let disnarysound = array1[0]
                            appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: cell.chatImage!, fileName: teamImageName as String)
                          }else{
                           cell.chatImage?.image = UIImage(named: "team")
                }
                
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
                cell.chatImage2?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                
                /*if(cell.chatImage?.image == nil)
                 {
                 appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                 }*/
            }
            else
            {
                let array1 = Teams_details.rows(filter:"team_Id = \(teamId)") as! [Teams_details]
                                         if(array1.count != 0){
                                             let disnarysound = array1[0]
                                           appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: cell.chatImage2!, fileName: teamImageName as String)
                                         }else{
                                        cell.chatImage2?.image = UIImage(named: "team")
                               }
                
            }
        }
        
        if ((dict2?.value(forKey: "badgeCounts") != nil))
        {
            let badgeCnt: Int = (dict2?.value(forKey: "badgeCounts") as? Int)!
            
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
                // cell.badgeCount?.layer.borderColor = UIColor.clear
                cell.badgeCount?.layer.cornerRadius = 10.0
                cell.lastMessage?.textColor = UIColor.black
            }
            else
            {
                cell.badgeCount?.text = ""
                cell.badgeCount?.isHidden = true
                cell.lastMessage?.textColor = UIColor.init(hex: "9A9A9A")
            }
        }
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
        let chatT: String = (dict2?.value(forKey: "chatType") as? String)!
        
            if(chatT == "teambr")
            {
                cell.chatImage2?.isHidden = true
                cell.vs?.isHidden = true
                cell.chatName?.textColor = UIColor.init(hex: "FFD401")
        }
            else{
                cell.chatImage2?.isHidden = false
                               cell.vs?.isHidden = false
                 cell.chatName?.textColor = UIColor.black
        }
       
        
        //cell.countryImage?.image = UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
        if (isMultiSelection) {
            if let selecteImage = dict2?.value(forKey: "checkimage") as? String{
                
                if(selecteImage == "check"){
                    cell.contentView.backgroundColor = UIColor.init(hex: "eeeeee")
                }
                else{
                    cell.contentView.backgroundColor = UIColor.white
                }
            }
            else{
                
                cell.contentView.backgroundColor = UIColor.white
            }
            
        }
        else{
            cell.contentView.backgroundColor = UIColor.white
            // cell.selectionView?.borderColor = UIColor.clear
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if(!isMultiSelection)
        {
            var Roomname: String =  ""
             var isjoin: String =  ""
             var isBanterClosed: String =  ""
            var curRoomType: String =  ""
            var toUserJID: String =  ""
            var mySupportedTeam: Int64 =  0
            
                       
            let dict2: NSDictionary? = dictAllChats[indexPath.row] as? NSDictionary
           toUserJID = dict2?.value(forKey: "JID") as! String
            
            //Calling this room users
            appDelegate().getbanterroomusers(roomid: toUserJID)
           
            //End calling this room users
            curRoomType = dict2?.value(forKey: "chatType") as! String
            //print(dict2)
            if let userName = dict2?.value(forKey: "userName")
            {
                
               Roomname = userName as! String
            }
            else
            {
               Roomname = ""
            }
            
            if(dict2?.value(forKey: "userAvatar") != nil)
            {
                appDelegate().toAvatarURL = (dict2?.value(forKey: "userAvatar") as? String)!
            }
            else
            {
                appDelegate().toAvatarURL = ""
            }
            //let chatType = dict2?.value(forKey: "chatType") as? String
            //self.appDelegate().joinRoomOnly(with: appDelegate().toUserJID, delegate: self.appDelegate())
            if let joined = dict2?.value(forKey: "isJoined")
            {
                isjoin = joined as! String
            }
            else
            {
               isjoin = "no"
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
            
            
            
            /*if (dict2?.value(forKey: "banterUsers")) != nil
             {
             banterUsers = dict2?.value(forKey: "banterUsers") as! NSMutableArray
             print(banterUsers)
             }*/
            
            if (dict2?.value(forKey: "supportedTeam")) != nil
            {
                supportedTeam = dict2?.value(forKey: "supportedTeam") as! Int64
                // print(supportedTeam)
            }
            
            if (dict2?.value(forKey: "opponentTeam")) != nil
            {
                opponentTeam = dict2?.value(forKey: "opponentTeam") as! Int64
                // print(opponentTeam)
            }
            
            if (dict2?.value(forKey: "mySupportedTeam")) != nil
            {
                //opponentTeam = dict2?.value(forKey: "mySupportedTeam") as! Int
               mySupportedTeam = dict2?.value(forKey: "mySupportedTeam") as! Int64
                //print(dict2?.value(forKey: "mySupportedTeam") ?? "")
            }
            
            
            
            let isOpen = appDelegate().isBanterIsOpen(supportedTeam: supportedTeam, opponentTeam: opponentTeam)
            
            if(isOpen == false)
            {
               isBanterClosed = "closed"
            }
            
           // showChatWindow()
                self.showChatWindow(roomid: toUserJID, BanterClosed: isBanterClosed, roomtype: curRoomType, roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
            
        } else
        {
            let cell = tableView.cellForRow(at: indexPath) as! AllChatsCell
            var dict: [String : AnyObject] = dictAllChats[indexPath.row] as! [String : AnyObject]
            if let ischecked = dict["checkimage"]{
                if(ischecked as! String == "check"){
                    dict["checkimage"] = "uncheck" as AnyObject
                    cell.contentView.backgroundColor = UIColor.white
                    Selectedcount = Selectedcount - 1
                    if(Selectedcount <= 0){
                        isMultiSelection = false
                        storyTableView?.allowsMultipleSelection = false
                        banterdelete?.isHidden = true
                        removelist?.isHidden = true
                       // self.parent?.navigationItem.rightBarButtonItems = nil
                       // self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "banters_add"), style: .plain, target: self, action: #selector(showNewBanterNotify))
                    }
                }
                else{
                    dict["checkimage"] = "check" as AnyObject
                    cell.contentView.backgroundColor = UIColor.init(hex: "eeeeee")
                    Selectedcount = Selectedcount + 1
                    
                }
                
                
                dictAllChats[indexPath.row] = dict as AnyObject
            }
            let roomid: String = dict["JID"] as! String
            
            deleteChatAtIndex(roomid: roomid, indexPath: indexPath.row)
            
        }
         // print(Selectedcount)
    }
    
    func deleteChatAtIndex(roomid: String,indexPath: Int){
        let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
        if localArrAllChats != nil
        {
            //Code to parse json data
            if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        
        for tmpAllUserChats in self.appDelegate().arrAllChats
        {
            let tmpSingleUserChat: String = tmpAllUserChats.key
            
            if(tmpSingleUserChat == roomid)
            {
                let dict: [String : AnyObject] = dictAllChats[indexPath] as! [String : AnyObject]
                let tmpArrChatDetails: [String: AnyObject] = dict//tmpAllUserChats.value as! [String: AnyObject]
                
                
                self.appDelegate().arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject//removeValue(forKey: tmpAllUserChats.key)
                
                break
                
                //self.arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                
                
            }
            
        }
        
        //Save array to local temp
        do {
            if(self.appDelegate().arrAllChats.count > 0)
            {
                let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                UserDefaults.standard.synchronize()
            }
            else{
                UserDefaults.standard.setValue(nil, forKey: "arrAllChats")
                UserDefaults.standard.synchronize()
            }
        } catch {
            print(error.localizedDescription)
        }
        /* if(self.appDelegate().isOnBantersView == true)
         {
         //Post notification if user is on chats window and received any message
         let notificationName = Notification.Name("RefreshBantersView")
         NotificationCenter.default.post(name: notificationName, object: nil)
         }*/
        
    }
    
    /*  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     if (isMultiSelection) {
     let allSelected = self.storyTableView?.indexPathsForSelectedRows
     print(allSelected ?? " Failed")
     
     if(allSelected == nil)
     {
     storyTableView?.allowsMultipleSelection = false
     storyTableView?.allowsSelection = true
     isMultiSelection = false
     self.parent?.navigationItem.rightBarButtonItem = nil
     
     self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showNewBanterNotify))
     // let cell = tableView.cellForRow(at: indexPath) as! ChatCell
     //cell.backgroundColor = UIColor.clear
     
     }
     // let cell = tableView.cellForRow(at: indexPath) as! ChatCell
     
     }
     
     }*/
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            if(!isMultiSelection)
            {
                let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
                if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
                    
                    //self.storyTableView?.allowsMultipleSelectionDuringEditing = true
                    // storyTableView?.allowsMultipleSelection=true
                    isMultiSelection = true
                    Selectedcount = 0
                  /*  self.parent?.navigationItem.rightBarButtonItem = nil
                    let rightSearchBarButtonItem2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(BantersViewController.BanterRemoveFormList))
                    
                    // 2
                    let button1 = UIBarButtonItem(image: UIImage(named: "close_b"), style: .plain, target: self, action: #selector(BantersViewController.Banterdelete(sender:)))
                    let rightSearchBarButtonItem:UIBarButtonItem = button1 //UIBarButtonItem(barButtonSystemItem: UIImage(named: "imagename"), target: self, action: .plain, action: Selector(Banterdelete))//UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
                    // 3
                   // let rightSearchBarButtonItem1:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(BantersViewController.Banterrefresh))
                    parent?.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem2,rightSearchBarButtonItem], animated: true)*/
                    storyTableView?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                                       storyTableView?.delegate?.tableView!(storyTableView!, didSelectRowAt: indexPath)
                    banterdelete?.isHidden = false
                    removelist?.isHidden = false
                   
                    //self.storyTableView setEditing:YES animated:YES
                    // your code here, get the row for the indexPath or do whatever you want
                }
            }
        }
    }
    @IBAction func Banterdelete(sender:UIButton) {
        //print("search pressed")
        if ClassReachability.isConnectedToNetwork()
        {
            var msg = ""
            print(Selectedcount)
            if(Selectedcount > 1){
                             msg = "Do you want to quit these Banter Rooms?"
                       }
                       else{
                          
                msg = "Do you want to quit this Banter Room?"
                       }
            //"Do you want to quit and close this Banter Room?" change according to amit sir 13 mar 20
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                
            });
            let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
              //  LoadingIndicatorView.show((self.appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while quit and close these Banter Rooms")
                if(self.appDelegate().isUserOnline){
                let temparrUserChat = self.dictAllChats.count
                //var counter = 2//self.dictAllChats.count + 2
                var leaveRoomIds = ""
               var deleteroomid = ""
                var teambrroomid = ""
                    var time: Int64 = self.appDelegate().getUTCFormateDate()
                for i in (0 ..< temparrUserChat).reversed(){
                    time = time + 100
                    let message: NSDictionary = self.dictAllChats[i] as! NSDictionary
                    if let ischecked = message["checkimage"]{
                        if(ischecked as! String == "check"){
                            //counter = counter  + 1
                           
                                let dict2: NSDictionary? = self.dictAllChats[i] as? NSDictionary
                                
                                //let tmpSingleUserChat: [String: AnyObject] = dict2.value as! [String: AnyObject]
                                let chatType: String = dict2!["chatType"] as! String
                                if(chatType == "banter")
                                {
                                    let isJoined: String = dict2!["isJoined"] as! String
                                    let isAdmin: String = dict2!["isAdmin"] as! String
                                    
                                    
                                    let roomid: String = dict2!["roomJID"] as! String
                                    
                                    if(isJoined == "yes")
                                    {
                                        if(isAdmin == "yes")
                                        {
                                            if(deleteroomid == ""){
                                                deleteroomid = roomid
                                            }
                                            else{
                                                deleteroomid = "\(deleteroomid),\(roomid)"
                                            }
                                            
                                            let roomJID = XMPPJID(string: roomid)
                                            let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                            
                                            let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                            
                                            room.activate(self.appDelegate().xmppStream!)
                                            
                                            room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                            //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                            if(!room.isJoined){
                                                
                                                let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                                history.addAttribute(withName: "maxchars", stringValue: "0")
                                                let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                
                                                
                                                room.join(usingNickname: myJID!, history: history)
                                                
                                            }
                                                
                                                
                                                _ = self.appDelegate().db.query(sql: " Delete from blockeduser  WHERE roomId = '\(roomid )'")
                                                
                                                let uuid = UUID().uuidString
                                                let messageId = uuid
                                               // let time: Int64 = self.appDelegate().getUTCFormateDate()
                                                //let messageTo = UserDefaults.standard.string(forKey: "userJID")
                                                if(chatType == "banter"){
                                                    self.appDelegate().sendMessageToServer(roomid , messageContent: "Banter Room closed.", messageType: "header", messageTime: time, messageId: messageId, roomType: "banter", messageSubType: "deletegroup")
                                                }
                                                else if(chatType == "group"){
                                                    self.appDelegate().sendMessageToServer(roomid , messageContent: "Group closed.", messageType: "header", messageTime: time, messageId: messageId, roomType: "group", messageSubType: "deletegroup")
                                                }
                                                //Save banter status
                                                //print(self.toName)
                                                //  self.prepareMessageForServerIn(roomid as! String, messageContent: "Sorry to see you delete this Banter Room.", messageType: "header", messageTime: time , messageId: messageId, filePath: "", fileLocalId: "", fromUser: messageTo!, isIncoming: "YES", chatType: "banter", recBanterNickName: "", banterRoomName: self.toName, banterStatus: "closed")
                                                
                                                //End
                                                let notificationName = Notification.Name("RedirecttoBanters")
                                                NotificationCenter.default.post(name: notificationName, object: nil)
                                          
                                                
                                            }
                                            else
                                            {
                                                if(leaveRoomIds == ""){
                                                    leaveRoomIds = roomid
                                                }
                                                else{
                                                    leaveRoomIds = "\(leaveRoomIds),\(roomid)"
                                                }
                                                let roomJID = XMPPJID(string: roomid)
                                                                                           let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                                                                           
                                                                                           let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                                                                           
                                                                                           room.activate(self.appDelegate().xmppStream!)
                                                                                           
                                                                                           room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                                                                           //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                           if(!room.isJoined){
                                                                                               
                                                                                               let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                                                                               history.addAttribute(withName: "maxchars", stringValue: "0")
                                                                                               let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                               
                                                                                               
                                                                                               room.join(usingNickname: myJID!, history: history)
                                                                                               
                                                                                           }
                                                
                                                //New code to get all joined users
                                                let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                                                if localArrAllChats != nil
                                                {
                                                    //Code to parse json data
                                                    if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                        do {
                                                            self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                                        } catch let error as NSError {
                                                            print(error)
                                                        }
                                                    }
                                                }
                                                
                                                
                                                for tmpAllUserChats in self.appDelegate().arrAllChats
                                                {
                                                    let tmpSingleUserChat: String = tmpAllUserChats.key
                                                    
                                                    if(tmpSingleUserChat == (roomid ))
                                                    {
                                                        var tmpArrChatDetails: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
                                                        tmpArrChatDetails["isJoined"] = "no" as AnyObject
                                                        
                                                        self.appDelegate().arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                //Save array to local temp
                                                do {
                                                    if(self.appDelegate().arrAllChats.count > 0)
                                                    {
                                                        let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                                                        let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                                                        UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                                                        UserDefaults.standard.synchronize()
                                                    }
                                                } catch {
                                                    // print(error.localizedDescription)
                                                }
                                                //End
                                                //End
                                                
                                                //Send message to all users that I am left
                                                //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                let uuid = UUID().uuidString
                                                let messageId = uuid
                                                //let time: Int64 = self.appDelegate().getUTCFormateDate()
                                                
                                                let username: String = UserDefaults.standard.string(forKey: "registerusername")!
                                                if(chatType == "banter"){
                                                    self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "banter", messageSubType: "roomuserleft")
                                                }
                                                if(chatType == "group"){
                                                    self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "group", messageSubType: "roomuserleft")
                                                }
                                                
                                                
                                                /* var dictRequest = [String: AnyObject]()
                                                 dictRequest["cmd"] = "deletebanterroomdetails" as AnyObject
                                                 
                                                 do {
                                                 //Creating Request Data
                                                 var dictRequestData = [String: AnyObject]()
                                                 
                                                 let login: String? = UserDefaults.standard.string(forKey: "userJID")
                                                 let arrReadUserJid = login?.components(separatedBy: "@")
                                                 let myMobile: String? = arrReadUserJid?[0]
                                                 
                                                 dictRequestData["roomid"] = roomid as AnyObject
                                                 dictRequestData["username"] = myMobile as AnyObject
                                                 
                                                 dictRequest["requestData"] = dictRequestData as AnyObject
                                                 //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                                 //print(dictRequest)
                                                 
                                                 let dataSaveBanter = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                                 let strSaveBanter = NSString(data: dataSaveBanter, encoding: String.Encoding.utf8.rawValue)! as String
                                                 //print(strSaveBanter)
                                                 self.appDelegate().sendRequestToAPI(strRequestDict: strSaveBanter)
                                                 } catch {
                                                 print(error.localizedDescription)
                                                 }
                                                 //Close this banter
                                                 //print("leave")*/
                                                
                                                
                                                
                                                
                                                
                                                
                                            }
                                        }
                                    
                                }
                                else if(chatType == "teambr"){
                                    let roomid: String = dict2!["roomJID"] as! String
                                    if(teambrroomid == ""){
                                        teambrroomid = roomid
                                    }
                                    else{
                                        teambrroomid = "\(teambrroomid),\(roomid)"
                                    }
                                     let isJoined: String = dict2!["isJoined"] as! String
                                    if(isJoined == "yes")
                                    {
                                        let roomJID = XMPPJID(string: roomid)
                                                                                   let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                                                                   
                                                                                   let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                                                                   
                                                                                   room.activate(self.appDelegate().xmppStream!)
                                                                                   
                                                                                   room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                                                                   //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                   if(!room.isJoined){
                                                                                       
                                                                                       let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                                                                       history.addAttribute(withName: "maxchars", stringValue: "0")
                                                                                       let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                       
                                                                                       
                                                                                       room.join(usingNickname: myJID!, history: history)
                                                                                       
                                                                                   }
                                        
                                        let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                                        if localArrAllChats != nil
                                        {
                                            //Code to parse json data
                                            if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                do {
                                                    self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                            }
                                        }
                                        
                                        
                                        for tmpAllUserChats in self.appDelegate().arrAllChats
                                        {
                                            let tmpSingleUserChat: String = tmpAllUserChats.key
                                            
                                            if(tmpSingleUserChat == roomid)
                                            {
                                                var tmpArrChatDetails: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
                                                tmpArrChatDetails["isJoined"] = "no" as AnyObject
                                                
                                                self.appDelegate().arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        //Save array to local temp
                                        do {
                                            if(self.appDelegate().arrAllChats.count > 0)
                                            {
                                                let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                                                let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                                                UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                                                UserDefaults.standard.synchronize()
                                            }
                                        } catch {
                                            // print(error.localizedDescription)
                                        }
                                        //End
                                        //End
                                        
                                        //Send message to all users that I am left
                                        //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        let uuid = UUID().uuidString
                                        let messageId = uuid
                                       // let time: Int64 = self.appDelegate().getUTCFormateDate()
                                        
                                        let username: String = UserDefaults.standard.string(forKey: "registerusername")!
                                        
                                        self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "teambr", messageSubType: "roomuserleft")
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                            }
                                
                                
                                
                           
                            
                            
                        }
                        
                    }
                    
                }
                    self.calldeleteroom(leaveRoomIds: leaveRoomIds, Deleteroomids: deleteroomid, Teambrroomid: teambrroomid)
                for i in 0...self.dictAllChats.count-1 {
                    //print(i)
                    var dict: [String : AnyObject] = self.dictAllChats[i] as! [String : AnyObject]
                    dict["checkimage"] = "uncheck" as AnyObject
                    
                    self.dictAllChats[i] = dict as AnyObject
                    let roomid: String = dict["JID"] as! String
                    
                    self.deleteChatAtIndex(roomid: roomid, indexPath: i)
                }
                
                /*DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter*2)) {
                    LoadingIndicatorView.hide()
                }*/
                self.storyTableView?.reloadData()
                self.Selectedcount = 0
                self.isMultiSelection = false
                self.storyTableView?.allowsMultipleSelection = false
               // self.parent?.navigationItem.rightBarButtonItems = nil
                    
                //self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "banters_add"), style: .plain, target: self, action: #selector(self.showNewBanterNotify))
                    self.banterdelete?.isHidden = true
                    self.removelist?.isHidden = true
                
            }
                else{
                    self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
                               
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
    
    @IBAction func BanterRemoveFormList(sender:UIButton) {
        // print("search pressed")
        if ClassReachability.isConnectedToNetwork()
        {
            var msg = ""
             if(Selectedcount > 1){
                                        msg = "Do you want to quit and delete these Banter Rooms?"
                                  }
                                  else{
                                     
                           msg = "Do you want to quit and delete this Banter Room?"
                                  }
            //"Do you want to quit, close and remove this Banter Room?" change according to amit sir 13 mar 20
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                
            });
            let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                
                //Forward chats
                //LoadingIndicatorView.show((self.appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while quit, close and remove these Banter Rooms")
                if(self.appDelegate().isUserOnline){
                    let temparrUserChat = self.dictAllChats.count
                    // var counter = 2//self.dictAllChats.count + 2
                    var leaveRoomIds = ""
                    var deleteroomid = ""
                    var teambrroomid = ""
                    var time: Int64 = self.appDelegate().getUTCFormateDate()
                    for i in (0 ..< temparrUserChat).reversed(){
                        time = time + 100
                        let message: NSDictionary = self.dictAllChats[i] as! NSDictionary
                        if let ischecked = message["checkimage"]{
                            if(ischecked as! String == "check"){
                                //counter = counter + 1
                                // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                
                                let dict2: NSDictionary? = self.dictAllChats[i] as? NSDictionary
                                
                                //let tmpSingleUserChat: [String: AnyObject] = dict2.value as! [String: AnyObject]
                                let chatType: String = dict2!["chatType"] as! String
                                
                                if(chatType == "banter")
                                {
                                    let isJoined: String = dict2!["isJoined"] as! String
                                    let isAdmin: String = dict2!["isAdmin"] as! String
                                    // let isclose: String = dict2!["banterStatus"] as! String
                                    //print(isclose)
                                    let roomid: String = dict2!["roomJID"] as! String
                                    
                                    if(isJoined == "yes")
                                    {
                                        var dictRequest1 = [String: AnyObject]()
                                        dictRequest1["roomJID"] = roomid as AnyObject
                                        // self.appDelegate().arrBanterDeleteLocal.add(dictRequest1 as AnyObject)
                                        if(isAdmin == "yes")
                                        {
                                            
                                            if(deleteroomid == ""){
                                                deleteroomid = roomid
                                            }
                                            else{
                                                deleteroomid = "\(deleteroomid),\(roomid)"
                                            }
                                            let uuid = UUID().uuidString
                                                                                      let messageId = uuid
                                                                                      //let time: Int64 = self.appDelegate().getUTCFormateDate()
                                            let roomJID = XMPPJID(string: roomid)
                                                                                                         let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                                                                                         
                                                                                                         let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                                                                                         
                                            room.activate(self.appDelegate().xmppStream!)
                                                                                                         
                                                                                                         room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                                                                                         //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                         if(room.isJoined){
                                                                                                             if(chatType == "banter"){
                                                                                                                   self.appDelegate().sendMessageToServer(roomid , messageContent: "Banter Room closed.", messageType: "header", messageTime: time, messageId: messageId, roomType: "banter", messageSubType: "deletegroup")
                                                                                                               }
                                                                                                               else if(chatType == "group"){
                                                                                                                   self.appDelegate().sendMessageToServer(roomid , messageContent: "Group closed.", messageType: "header", messageTime: time, messageId: messageId, roomType: "group", messageSubType: "deletegroup")
                                                                                                               }
                                                                                                             
                                                                                                             room.leave()
                                                                                                         }
                                                                                                         else{
                                                                                                             let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                                                                                             history.addAttribute(withName: "maxchars", stringValue: "0")
                                                                                                             let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                             
                                                                                                             
                                                                                                             room.join(usingNickname: myJID!, history: history)
                                                                                                             
                                                                                                             if(chatType == "banter"){
                                                                                                                   self.appDelegate().sendMessageToServer(roomid , messageContent: "Banter Room closed.", messageType: "header", messageTime: time, messageId: messageId, roomType: "banter", messageSubType: "deletegroup")
                                                                                                               }
                                                                                                               else if(chatType == "group"){
                                                                                                                   self.appDelegate().sendMessageToServer(roomid , messageContent: "Group closed.", messageType: "header", messageTime: time, messageId: messageId, roomType: "group", messageSubType: "deletegroup")
                                                                                                               }
                                                                                                             room.leave()
                                                                                                         }
                                            self.appDelegate().updateBadgeCount(roomid, type: chatType, count: 0)
                                            _ = self.appDelegate().db.query(sql: " Delete from blockeduser  WHERE roomId = '\(roomid )'")
                                            
                                          
                                            //let messageTo = UserDefaults.standard.string(forKey: "userJID")
                                            
                                            //Save banter status
                                            //print(self.toName)
                                            //  self.prepareMessageForServerIn(roomid as! String, messageContent: "Sorry to see you delete this Banter Room.", messageType: "header", messageTime: time , messageId: messageId, filePath: "", fileLocalId: "", fromUser: messageTo!, isIncoming: "YES", chatType: "banter", recBanterNickName: "", banterRoomName: self.toName, banterStatus: "closed")
                                            
                                            //End
                                            let notificationName = Notification.Name("RedirecttoBanters")
                                            NotificationCenter.default.post(name: notificationName, object: nil)
                                          
                                            let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                                            if localArrAllChats != nil
                                            {
                                                //Code to parse json data
                                                if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                    do {
                                                        self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
                                            }
                                            
                                            
                                            for tmpAllUserChats in self.appDelegate().arrAllChats
                                            {
                                                let tmpSingleUserChat: String = tmpAllUserChats.key
                                                
                                                if(tmpSingleUserChat == roomid)
                                                {
                                                    
                                                    //var tmpArrChatDetails: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
                                                    
                                                    
                                                    self.appDelegate().arrAllChats.removeValue(forKey: tmpAllUserChats.key)
                                                    
                                                    break
                                                    
                                                    //self.arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                            //Save array to local temp
                                            do {
                                                if(self.appDelegate().arrAllChats.count > 0)
                                                {
                                                    let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                                                    let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                                                    UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                                                    UserDefaults.standard.synchronize()
                                                }
                                                else{
                                                    UserDefaults.standard.setValue(nil, forKey: "arrAllChats")
                                                    UserDefaults.standard.synchronize()
                                                }
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            if(self.appDelegate().isOnBantersView == true)
                                            {
                                                //Post notification if user is on chats window and received any message
                                                let notificationName = Notification.Name("RefreshBantersView")
                                                NotificationCenter.default.post(name: notificationName, object: nil)
                                            }
                                            
                                            
                                            
                                        }
                                        else
                                        {
                                            
                                            if(leaveRoomIds == ""){
                                                leaveRoomIds = roomid
                                            }
                                            else{
                                                leaveRoomIds = "\(leaveRoomIds),\(roomid)"
                                            }
                                            self.appDelegate().updateBadgeCount(roomid, type: chatType, count: 0)
                                            let uuid = UUID().uuidString
                                            let messageId = uuid
                                           // let time: Int64 = self.appDelegate().getUTCFormateDate()
                                            let roomJID = XMPPJID(string: roomid)
                                                                                                           let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                                                                                           
                                                                                                           let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                                                                                           
                                            room.activate(self.appDelegate().xmppStream!)
                                                                                                           
                                                                                                           room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                                                                                           //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                           if(room.isJoined){
                                                                                                               let username: String = UserDefaults.standard.string(forKey: "registerusername")!
                                                                                                                                                          if(chatType == "banter"){
                                                                                                                                                              self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "banter", messageSubType: "roomuserleft")
                                                                                                                                                          }
                                                                                                                                                          if(chatType == "group"){
                                                                                                                                                              self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "group", messageSubType: "roomuserleft")
                                                                                                                                                          }
                                                                                                               room.leave()
                                                                                                           }
                                                                                                           else{
                                                                                                               let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                                                                                               history.addAttribute(withName: "maxchars", stringValue: "0")
                                                                                                               let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                               
                                                                                                               
                                                                                                               room.join(usingNickname: myJID!, history: history)
                                                                                                               let username: String = UserDefaults.standard.string(forKey: "registerusername")!
                                                                                                                                                          if(chatType == "banter"){
                                                                                                                                                              self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "banter", messageSubType: "roomuserleft")
                                                                                                                                                          }
                                                                                                                                                          if(chatType == "group"){
                                                                                                                                                              self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "group", messageSubType: "roomuserleft")
                                                                                                                                                          }
                                                                                                               room.leave()
                                                                                                           }
                                           
                                       
                                            let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                                            if localArrAllChats != nil
                                            {
                                                //Code to parse json data
                                                if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                    do {
                                                        self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                                        
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
                                            }
                                            
                                            
                                            for tmpAllUserChats in self.appDelegate().arrAllChats
                                            {
                                                let tmpSingleUserChat: String = tmpAllUserChats.key
                                                
                                                if(tmpSingleUserChat == roomid)
                                                {
                                                    
                                                    //var tmpArrChatDetails: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
                                                    
                                                    
                                                    self.appDelegate().arrAllChats.removeValue(forKey: tmpAllUserChats.key)
                                                    
                                                    break
                                                    
                                                    //self.arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                            //Save array to local temp
                                            do {
                                                if(self.appDelegate().arrAllChats.count > 0)
                                                {
                                                    let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                                                    let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                                                    UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                                                    UserDefaults.standard.synchronize()
                                                }
                                                else{
                                                    UserDefaults.standard.setValue(nil, forKey: "arrAllChats")
                                                    UserDefaults.standard.synchronize()
                                                }
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            if(self.appDelegate().isOnBantersView == true)
                                            {
                                                //Post notification if user is on chats window and received any message
                                                let notificationName = Notification.Name("RefreshBantersView")
                                                NotificationCenter.default.post(name: notificationName, object: nil)
                                            }
                                            
                                            
                                        }
                                        //End
                                    }
                                    else{
                                        if(leaveRoomIds == ""){
                                            leaveRoomIds = roomid
                                        }
                                        else{
                                            leaveRoomIds = "\(leaveRoomIds),\(roomid)"
                                        }
                                        self.appDelegate().updateBadgeCount(roomid, type: chatType, count: 0)
                                        let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                                        if localArrAllChats != nil
                                        {
                                            //Code to parse json data
                                            if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                do {
                                                    self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                                    
                                                } catch let error as NSError {
                                                    print(error)
                                                }
                                            }
                                        }
                                        
                                        
                                        for tmpAllUserChats in self.appDelegate().arrAllChats
                                        {
                                            let tmpSingleUserChat: String = tmpAllUserChats.key
                                            
                                            if(tmpSingleUserChat == roomid)
                                            {
                                                
                                                //var tmpArrChatDetails: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
                                                
                                                
                                                self.appDelegate().arrAllChats.removeValue(forKey: tmpAllUserChats.key)
                                                
                                                break
                                                
                                                //self.arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        //Save array to local temp
                                        do {
                                            if(self.appDelegate().arrAllChats.count > 0)
                                            {
                                                let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                                                let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                                                UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                                                UserDefaults.standard.synchronize()
                                            }
                                            else{
                                                UserDefaults.standard.setValue(nil, forKey: "arrAllChats")
                                                UserDefaults.standard.synchronize()
                                            }
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                        if(self.appDelegate().isOnBantersView == true)
                                        {
                                            //Post notification if user is on chats window and received any message
                                            let notificationName = Notification.Name("RefreshBantersView")
                                            NotificationCenter.default.post(name: notificationName, object: nil)
                                        }
                                        
                                    }
                                    self.dictAllChats.remove(i)
                                }
                                else if(chatType == "teambr"){
                                        let roomid: String = dict2!["roomJID"] as! String
                                        if(teambrroomid == ""){
                                            teambrroomid = roomid
                                        }
                                        else{
                                            teambrroomid = "\(teambrroomid),\(roomid)"
                                        }
                                         let isJoined: String = dict2!["isJoined"] as! String
                                        if(isJoined == "yes")
                                        {
                                            let roomJID = XMPPJID(string: roomid)
                                                                                       let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                                                                       
                                                                                       let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                                                                                       
                                                                                       room.activate(self.appDelegate().xmppStream!)
                                                                                       
                                                                                       room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                                                                       //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                       if(!room.isJoined){
                                                                                           
                                                                                           let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                                                                           history.addAttribute(withName: "maxchars", stringValue: "0")
                                                                                           let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                           
                                                                                           
                                                                                           room.join(usingNickname: myJID!, history: history)
                                                                                           
                                                                                       }
                                            
                                            let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                                            if localArrAllChats != nil
                                            {
                                                //Code to parse json data
                                                if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                    do {
                                                        self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                                    } catch let error as NSError {
                                                        print(error)
                                                    }
                                                }
                                            }
                                            
                                            
                                            for tmpAllUserChats in self.appDelegate().arrAllChats
                                            {
                                                let tmpSingleUserChat: String = tmpAllUserChats.key
                                                
                                                if(tmpSingleUserChat == roomid)
                                                {
                                                    var tmpArrChatDetails: [String: AnyObject] = tmpAllUserChats.value as! [String: AnyObject]
                                                    tmpArrChatDetails["isJoined"] = "no" as AnyObject
                                                    
                                                    self.appDelegate().arrAllChats[tmpAllUserChats.key] = tmpArrChatDetails as AnyObject
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                            //Save array to local temp
                                            do {
                                                if(self.appDelegate().arrAllChats.count > 0)
                                                {
                                                    let dataArrAllChats = try JSONSerialization.data(withJSONObject: self.appDelegate().arrAllChats, options: .prettyPrinted)
                                                    let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                                                    UserDefaults.standard.setValue(strArrAllChats, forKey: "arrAllChats")
                                                    UserDefaults.standard.synchronize()
                                                }
                                            } catch {
                                                // print(error.localizedDescription)
                                            }
                                            //End
                                            //End
                                            
                                            //Send message to all users that I am left
                                            //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            let uuid = UUID().uuidString
                                            let messageId = uuid
                                            //let time: Int64 = self.appDelegate().getUTCFormateDate()
                                            
                                            let username: String = UserDefaults.standard.string(forKey: "registerusername")!
                                            
                                            self.appDelegate().sendMessageToServer(roomid , messageContent: username + " quit.", messageType: "header", messageTime: time, messageId: messageId, roomType: "teambr", messageSubType: "roomuserleft")
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                }
                                                               
                                // let indexP: NSIndexPath = sel as NSIndexPath
                                
                                //}
                            }
                        }
                    }
                    
                    self.calldeleteroom(leaveRoomIds: leaveRoomIds, Deleteroomids: deleteroomid, Teambrroomid: teambrroomid)
                    
                    /* DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter*2)) {
                     LoadingIndicatorView.hide()
                     }*/
                    self.storyTableView?.reloadData()
                    self.Selectedcount = 0
                    self.isMultiSelection = false
                    self.storyTableView?.allowsMultipleSelection = false
                   // self.parent?.navigationItem.rightBarButtonItems = nil
                    //self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "banters_add"), style: .plain, target: self, action: #selector(self.showNewBanterNotify))
                    self.banterdelete?.isHidden = true
                    self.removelist?.isHidden = true
                }else{
                    self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
                    
                }
            });
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion:nil)
            
            
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        
    }
    // 5
    @IBAction func Banterrefresh(sender:UIButton) {
        //print("add pressed")
        isMultiSelection = false
        storyTableView?.allowsMultipleSelection = false
        //self.parent?.navigationItem.rightBarButtonItems = nil
        //self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "banters_add"), style: .plain, target: self, action: #selector(showNewBanterNotify))
        banterdelete?.isHidden = true
                           removelist?.isHidden = true
        for i in 0...dictAllChats.count-1 {
            //print(i)
            var dict: [String : AnyObject] = dictAllChats[i] as! [String : AnyObject]
            dict["checkimage"] = "uncheck" as AnyObject
            
            dictAllChats[i] = dict as AnyObject
            let roomid: String = dict["JID"] as! String
            
            deleteChatAtIndex(roomid: roomid, indexPath: i)
        }
        if(self.appDelegate().isOnBantersView == true)
        {
            //Post notification if user is on chats window and received any message
            let notificationName = Notification.Name("RefreshBantersView")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    @IBAction func addBanterRoom () {
        showNewBanterNotify()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            BantersViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return BantersViewController.realDelegate!;
    }
    
    func xmppStream() -> XMPPStream {
        return appDelegate().xmppStream!
    }
    
    @IBAction func modleAction(){
        let action: String? = UserDefaults.standard.string(forKey: "banterloginaction")
        if(action == "login"){
            appDelegate().LoginwithModelPopUp()
            
        }
    }
    func calldeleteroom(leaveRoomIds: String,Deleteroomids: String ,Teambrroomid: String) {
          var dictRequest = [String: AnyObject]()
          dictRequest["cmd"] = "deleteroom" as AnyObject
          dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
          dictRequest["device"] = "ios" as AnyObject
          do {
               
              //Creating Request Data
              var dictRequestData = [String: AnyObject]()
              
              let login: String? = UserDefaults.standard.string(forKey: "userJID")
              let arrReadUserJid = login?.components(separatedBy: "@")
              let myMobile: String? = arrReadUserJid?[0]
              dictRequestData["leaveroomid"] = leaveRoomIds as AnyObject
            dictRequestData["deleteroomid"] = Deleteroomids as AnyObject
            dictRequestData["teambrroomid"] = Teambrroomid as AnyObject
              dictRequestData["username"] = myMobile as AnyObject
             
              dictRequest["requestData"] = dictRequestData as AnyObject
              
     
                                                                       AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                                                                                                       headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                                                                                                         // 2
                                                                                                         .responseJSON { response in
                                                                                                            switch response.result {
                                                                                                                                                    case .success(let value):
                                                                                                                                                        if let json = value as? [String: Any] {
                                                                                                                                                                                                                                                                                 let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                                                                                                             // self.finishSyncContacts()
                                                                                                                                                             //print(" status:", status1)
                                                                                                                                                            if(status1){
                                                                                                                                                                self.appDelegate().getblockusers()
                                                                                                                                                            }
                                                                                                                                                             else{
                                                                                                                                                                                                               
                                                                                                                                                                 //Show Error
                                                                                                                                                             }
                                                                                                                                                        }
                                                                                                                                                    case .failure(let error):
                                                                                                                debugPrint(error)
                                                                                                                break
                                                                                                                                                        // error handling
                                                                                                                                         
                                                                                                                                                    }
                                                                                                             
                                                                                                     }
              } catch {
                         print(error.localizedDescription)
                     }
      }
}
