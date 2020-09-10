//
//  ProfileDetailsViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 27/03/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework
import Alamofire
class ProfileDetailsViewController: UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var usernamelabel: UILabel?
    @IBOutlet weak var statuslabel: UILabel?
    @IBOutlet weak var primaryTeamlabel: UILabel?
    @IBOutlet weak var emaillabel: UILabel?
    @IBOutlet weak var countrycodelabel: UILabel?
    @IBOutlet weak var mobilelabel: UILabel?
    @IBOutlet weak var Imgmute: UIImageView!
    @IBOutlet weak var Imgcountry: UIImageView!
    @IBOutlet weak var Imgteam: UIImageView!
     @IBOutlet weak var ImguserAvtar: UIImageView!
      @IBOutlet weak var navItem: UINavigationItem!
     @IBOutlet weak var ibBanterSound: UISwitch!
     @IBOutlet weak var ibsoundStatus: UILabel?
      @IBOutlet weak var ismute: UIImageView!
    var RoomJid: String = ""
     @IBOutlet weak var imgblockstatus: UIImageView?
     @IBOutlet weak var mobileprivacylabel: UILabel?
    var subtypevalue: NSDictionary = [:]
    @IBOutlet weak var scrollView: UIScrollView!
     @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avtarhightConstraint: NSLayoutConstraint!
     @IBOutlet weak var parenthightConstraint: NSLayoutConstraint!
     @IBOutlet weak var btnblock: UIButton?
    var isBlocked: Bool = false
    @IBOutlet weak var followerviewwidth: NSLayoutConstraint!
        @IBOutlet weak var postviewwidth: NSLayoutConstraint!
        @IBOutlet weak var followingviewwidth: NSLayoutConstraint!
    @IBOutlet weak var followteam1label: UILabel?
    @IBOutlet weak var followteam2label: UILabel?
    @IBOutlet weak var followteam3label: UILabel?
     @IBOutlet weak var Imgfollowteam3: UIImageView!
     @IBOutlet weak var Imgfollowteam2: UIImageView!
    @IBOutlet weak var Imgfollowteam1: UIImageView!
     @IBOutlet weak var biolabel: UILabel?
    @IBOutlet weak var namelabel: UILabel?
    @IBOutlet weak var butfollowercount: UIButton?
@IBOutlet weak var butfollowingcount: UIButton?
    @IBOutlet weak var butpostcount: UIButton?
    @IBOutlet weak var butfollower: UIButton?
    @IBOutlet weak var butfollowing: UIButton?
        @IBOutlet weak var butpost: UIButton?
     // @IBOutlet weak var butfolloweedStatus: UIButton?
    var  isfollowed:Bool = false
   // var  profileusername:String = ""
    @IBOutlet weak var imgsisverify: UIImageView?
       @IBOutlet weak var imglavel: UIImageView?
     @IBOutlet weak var optionalteamviewheight: NSLayoutConstraint!
    @IBOutlet weak var bioviewheight: NSLayoutConstraint!
     var fanstoryblockedstatus: Bool = false
    var followerscount: Int64 = 0
    var followingcount: Int64 = 0
    var fanstorycount: Int64 = 0
    var fanmessge: String = ""
       @IBOutlet weak var share: UIView!
    @IBOutlet weak var shareImage: UIImageView!
       @IBOutlet weak var shareText: UIButton!
    @IBOutlet weak var message: UIView!
      @IBOutlet weak var messageImage: UIImageView!
         @IBOutlet weak var messageText: UIButton!
    @IBOutlet weak var followview: UIView!
         @IBOutlet weak var followviewImage: UIImageView!
            @IBOutlet weak var followviewText: UIButton!
     @IBOutlet weak var optionalteamviewledding: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
         //navItem.title = appDelegate().toName
        let arrdUserJid = RoomJid.components(separatedBy: "@")
        let userUserJid = arrdUserJid[0]
        let localname = appDelegate().ExistingContact(username: userUserJid)
        self.navigationItem.title = localname
       // TransperentLoadingIndicatorView.show(view, loadingText: "")
        followteam1label!.text = "No Team"
        primaryTeamlabel?.text = "No Team"
        let notificationName = Notification.Name("showProfileWithNotify")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileDetailsViewController.showProfileWithNotify), name: notificationName, object: nil)
        let notificationName1 = Notification.Name("getsubcribeWithNotify")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileDetailsViewController.getsubcribeWithNotify), name: notificationName1, object: nil)
        let notificationName2 = Notification.Name("singlechat")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileDetailsViewController.UpdateBlockUnblockStatus), name: notificationName2, object: nil)
        let notificationName3 = Notification.Name("singlechatfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileDetailsViewController.FailUpdateBlockUnblockStatus), name: notificationName3, object: nil)
        
        let notificationName4 = Notification.Name("getsubcribeFail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileDetailsViewController.getsubcribeFail), name: notificationName4, object: nil)
       
     scrollView.delegate = self
        scrollView.isScrollEnabled = true
        let bounds: CGRect = UIScreen.main.bounds
                      //var width:CGFloat = bounds.size.width
                      let width:CGFloat = bounds.size.width
               
               followerviewwidth.constant = width / 3
               followingviewwidth.constant = width / 3
               postviewwidth.constant = width / 3
        self.avtarhightConstraint.constant = width
        self.hightConstraint.constant = width//self.view.frame.width//CGFloat(self.view.frame.width + 50.0)
        self.parenthightConstraint.constant = CGFloat(self.view.frame.width + 0.0 + 490.0)
       // RoomJid = self.appDelegate().toUserJID
         optionalteamviewheight.constant = 50
        let array1 = Bantersound.rows(filter:"toUserJID = '\(RoomJid)'") as! [Bantersound]
        if(array1.count != 0){
        let disnarysound = array1[0]
        
        let soundValue = disnarysound.value(forKey: "soundValue") as! Int
        if (soundValue == 1) {
            ibBanterSound.setOn(true, animated: false)
            ibsoundStatus?.text = "Sound On"
            ismute.image = UIImage(named:"sound_on")
        } else {
            ibBanterSound.setOn(false, animated: false)
            ibsoundStatus?.text = "Sound Off"
            ismute.image = UIImage(named:"sound_off")
            }
            
        }
        else{
            let bantersoundTable = Bantersound()
            bantersoundTable.soundValue = 1
            bantersoundTable.toUsername = appDelegate().toName //tmpArrChatDetails["userName"] as! String
            bantersoundTable.toUserJID = RoomJid//tmpArrChatDetails["roomJID"] as! String
            if bantersoundTable.save() != 0 {
               // print("bantersoundTable save")
                appDelegate().BantersoundUpdateForNotification()
            }
            else{
                if bantersoundTable.save() != 0 {
                   // print("bantersoundTable  save")
                    appDelegate().BantersoundUpdateForNotification()
                }
                else{
                  //  print("bantersoundTable not save")
                }
                
            }
            ibBanterSound.setOn(true, animated: false)
            ibsoundStatus?.text = "Sound On"
            ismute.image = UIImage(named:"sound_on")
        }
         let array =  appDelegate().db.query(sql: "SELECT * FROM Blockeduser where roomId = '\(RoomJid)' And chatType = 'chat'")
        //let array = Blockeduser.rows(filter:"roomId = '\(RoomJid)'") as! [Blockeduser]
        if(array.count != 0){
            let disnarysound:NSDictionary = array[0] as NSDictionary
            //for res in array {
            let status = disnarysound.value(forKey: "status") as! String
            if(status == "Blocked"){
                 isBlocked = true
                btnblock?.setTitle("Unblock", for:  UIControl.State.normal)
                imgblockstatus?.image = UIImage(named: "unblock")
                btnblock?.setTitleColor(UIColor(hex: "069c06"), for: .normal)
            }
            else{
                 isBlocked = false
                btnblock?.setTitle("Block", for:  UIControl.State.normal)
                 imgblockstatus?.image = UIImage(named: "blocked")
                 btnblock?.setTitleColor(UIColor(hex: "FF3939"), for: .normal)
            }
        }
        else{
            isBlocked = false
btnblock?.setTitle("Block", for:  UIControl.State.normal)
          imgblockstatus?.image = UIImage(named: "blocked")
             btnblock?.setTitleColor(UIColor(hex: "FF3939"), for: .normal)
        }
       
        // self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuoption))
       let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                 longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
                 
                 share?.addGestureRecognizer(longPressGesture_share)
                 share?.isUserInteractionEnabled = true
                 let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                           //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                           longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
                           
                           let longPressGesture_share2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                           //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                           longPressGesture_share2.delegate = self as? UIGestureRecognizerDelegate
                           

                 shareImage?.addGestureRecognizer(longPressGesture_share1)
                           shareImage?.isUserInteractionEnabled = true
                           
                           shareText?.addGestureRecognizer(longPressGesture_share2)
                           shareText?.isUserInteractionEnabled = true
        
        let longPressGesture_follow:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followedAction(_:)))
                        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                        longPressGesture_follow.delegate = self as? UIGestureRecognizerDelegate
                        
                        followview?.addGestureRecognizer(longPressGesture_follow)
                        followview?.isUserInteractionEnabled = true
                        let longPressGesture_follow1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followedAction(_:)))
                                  //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                                  longPressGesture_follow1.delegate = self as? UIGestureRecognizerDelegate
                                  
                                  let longPressGesture_follow2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followedAction(_:)))
                                  //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                                  longPressGesture_follow2.delegate = self as? UIGestureRecognizerDelegate
                                  

                        followviewImage?.addGestureRecognizer(longPressGesture_follow1)
                                  followviewImage?.isUserInteractionEnabled = true
                                  
                                  followviewText?.addGestureRecognizer(longPressGesture_follow2)
                                  followviewText?.isUserInteractionEnabled = true
        
        
        let longPressGesture_message:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageAction(_:)))
                               //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                               longPressGesture_message.delegate = self as? UIGestureRecognizerDelegate
                               
                               message?.addGestureRecognizer(longPressGesture_message)
                               message?.isUserInteractionEnabled = true
                               let longPressGesture_message1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageAction(_:)))
                                         //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                                         longPressGesture_message1.delegate = self as? UIGestureRecognizerDelegate
                                         
                                         let longPressGesture_message2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageAction(_:)))
                                         //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                                         longPressGesture_message2.delegate = self as? UIGestureRecognizerDelegate
                                         

                               messageImage?.addGestureRecognizer(longPressGesture_message1)
                                         messageImage?.isUserInteractionEnabled = true
                                         
                                         messageText?.addGestureRecognizer(longPressGesture_message2)
                                         messageText?.isUserInteractionEnabled = true
                           
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        getuserdetail()
    }
    @objc func menuoption () {
              
              //messageBox?.resignFirstResponder()
              let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
             
              let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
              //let arrdUserJid = myjid?.components(separatedBy: "@")
              //let userUserJid = arrdUserJid?[0]
              if(myjid != RoomJid)
              {
              let team1Action = UIAlertAction(title: "Send Message", style: .default, imageNamed: "uncheck", handler: {
                  (alert: UIAlertAction!) -> Void in
               //self.showPrivacy()
                  self.appDelegate().isJoined = "yes"
                                //self.appDelegate().curRoomType = "chat"
              
                //self.appDelegate().toUserJID = self.RoomJid//(dict.value(forKey: "jid") as? String)!
                               
                 var Roomname: String =  self.appDelegate().ExistingContact(username: self.RoomJid)!//(dict.value(forKey: "username") as? String)!
                         
                               
                self.showChatWindow(roomid: self.RoomJid, BanterClosed: "active", roomtype: "chat", roomname: Roomname, join: "yes", mySupportedTeam: 0)
                          
              })
         optionMenu.addAction(team1Action!)
        }
              let team2Action = UIAlertAction(title: "Share Profile", style: .default, imageNamed: "uncheck" , handler: {
                  (alert: UIAlertAction!) -> Void in
                 
               self.inviteFan()
              })
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                  (alert: UIAlertAction!) -> Void in
                  
                  //print("Cancelled")
              })
             
              optionMenu.addAction(team2Action!)
              optionMenu.addAction(cancelAction)
              
              self.present(optionMenu, animated: true, completion: nil)
          }
    func showChatWindow(roomid: String,BanterClosed : String,roomtype : String, roomname : String, join : String,mySupportedTeam : Int64) {
          // self.dismiss(animated: true, completion: nil)
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
           //present(registerController as! UIViewController, animated: true, completion: nil)
          // self.appDelegate().curRoomType = "chat"
          // appDelegate().isBanterClosed = ""
        registerController.opponentTeam = 0
               registerController.supportedTeam = 0
                registerController.BanterClosed = BanterClosed
                registerController.RoomType = roomtype
               registerController.Roomname = roomname
               registerController.isjoin = join
                registerController.mySupportedTeam = 0
               registerController.Roomid = roomid
           show(registerController as! UIViewController, sender: self)
           //let notificationName = Notification.Name("showWindowFromNotification")
           //NotificationCenter.default.post(name: notificationName, object: nil)
       }
    func inviteFan()
         {
             do {
               
                 let arrdUserJid = RoomJid.components(separatedBy: "@")
                 let userUserJid = arrdUserJid[0]
                 let myjidtrim: String = userUserJid
                 
                 var dictRequest = [String: AnyObject]()
                 dictRequest["id"] = myjidtrim as AnyObject
                 dictRequest["type"] = "profileinvite" as AnyObject
                 let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
               //  print(appDelegate().toName)
                 let title = appDelegate().toName
                 
                 let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                 
                 let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                 
                 let param = resultNSString as String?
                 
                 let inviteurl = InviteHost + "?q=" + param!
                
                  let text =  "Connect with \(String(describing: myjidtrim)) and others on Football Fan app.\n\nWatch Football videos, create stories, banter, find fans, news and collect FanCoins rewards.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."//title + "\n\nBanter Invite shared via Football Fan App.\n\nPlease follow the link:\n"
                            
                          let objectsToShare = [text] as [Any]
                                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        
                                        //New Excluded Activities Code
                                        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                        //
                                        
                                        activityVC.popoverPresentationController?.sourceView = self.view
                                        self.present(activityVC, animated: true, completion: nil)
                             
                 
             } catch {
                 print(error.localizedDescription)
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
            ProfileDetailsViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ProfileDetailsViewController.realDelegate!;
    }
    @IBAction func soundIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            var msgDict3 = [String: AnyObject]()
            msgDict3["toUserJID"] = RoomJid as AnyObject
            msgDict3["soundValue"] = 1 as AnyObject
            ibsoundStatus?.text = "Sound On"
            ismute.image = UIImage(named:"sound_on")
            _ = appDelegate().db.execute(sql:" UPDATE bantersound SET soundValue = 1 WHERE toUserJID = '\(RoomJid)'")
            
            
        } else {
            var msgDict3 = [String: AnyObject]()
            msgDict3["toUserJID"] = RoomJid as AnyObject
            msgDict3["soundValue"] = 0 as AnyObject
            ibsoundStatus?.text = "Sound Off"
            ismute.image = UIImage(named:"sound_off")
            _ = appDelegate().db.execute(sql:" UPDATE bantersound SET soundValue = 0 WHERE toUserJID = '\(RoomJid)'")
        }
        appDelegate().BantersoundUpdateForNotification()
    }
    
    
    // By Mayank on 25 Sep 2018
    
    @objc func getsubcribeFail()
    {
        //let inmycontacts = (notification.userInfo?["subcriptiontype"] )as! String
        if(subtypevalue != nil){
        let profilemobile = (subtypevalue.value(forKey: "profilemobile") as! String)
        var showMobile: Bool = false
        if(profilemobile == "None")
        {
            showMobile = false
        }
        else if(profilemobile == "My contacts"){
            showMobile = false
        }
        else{
            showMobile = true
        }
        
        if(showMobile)
        { mobilelabel?.isHidden = false
            countrycodelabel?.isHidden = false
            Imgcountry.isHidden = false
            mobileprivacylabel?.isHidden = true
            let Mobileno = (subtypevalue.value(forKey: "mobile") as! String)
            if(Mobileno != ""){
                mobilelabel?.text = (subtypevalue.value(forKey: "mobile") as! String)
                if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    
                    do {
                        let countrycode: String? = subtypevalue.value(forKey: "shortcode") as? String //((subtypevalue.value(forKey: "countrycode") as! NSString) as String)
                        
                        if(countrycode != nil  && !(countrycode?.isEmpty)!){
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                            
                            countrycodelabel!.text = dictCountry.value(forKey: "code") as? String
                            // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            // Imgcountry.setImage(UIImage(named:(dict1["flag"] as? String)!), for: UIControlState.normal)
                            Imgcountry.image = UIImage(named: (dictCountry.value(forKey: "flag") as? String)!)
                            
                            
                            
                            
                        }
                        else{
                            
                            countrycodelabel!.text = ""//dictCountry.value(forKey: "code") as? String
                            // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            // btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControlState.normal)
                            
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            else{
                mobilelabel?.isHidden = true
                countrycodelabel?.isHidden = true
                Imgcountry.isHidden = true
                mobileprivacylabel?.text = "-"
                mobileprivacylabel?.isHidden = false
            }
            
        }
        else{
            mobilelabel?.isHidden = true
            countrycodelabel?.isHidden = true
            Imgcountry.isHidden = true
            mobileprivacylabel?.text = "Privacy Protected"
            mobileprivacylabel?.isHidden = false
        }
        let profileemail = (subtypevalue.value(forKey: "profileemail") as! String)
        var showEmail: Bool = false
        if(profileemail == "None")
        {
            showEmail = false
        }
        else if(profileemail == "My contacts"){
            showEmail = false
            
        }
        else{
            showEmail = true
        }
        if(showEmail)
        {
            emaillabel?.text = (subtypevalue.value(forKey: "email") as! String)
        }
        else{
            emaillabel?.text = "Privacy Protected"
        }
        }
    }
    func getuserdetail(){
          if ClassReachability.isConnectedToNetwork() {
         var dictRequest = [String: AnyObject]()
         dictRequest["cmd"] = "userdetail" as AnyObject
         dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
         dictRequest["device"] = "ios" as AnyObject
         do {
           // let time: Int64 = self.appDelegate().getUTCFormateDate()
             //Creating Request Data
             var dictRequestData = [String: AnyObject]()
             
             let login: String? = UserDefaults.standard.string(forKey: "userJID")
             let arrReadUserJid = login?.components(separatedBy: "@")
             let myMobile: String? = arrReadUserJid?[0]
             let arrReadChatJid = RoomJid.components(separatedBy: "@")
             let to: String? = arrReadChatJid[0]
             //appDelegate().mySupportedTeam = joinTeamId
             dictRequestData["blockedusername"] = to as AnyObject
            
             dictRequestData["username"] = myMobile as AnyObject
             
             dictRequest["requestData"] = dictRequestData as AnyObject
             //dictRequest.setValue(dictMobiles, forKey: "requestData")
             //print(dictRequest)
             
            // let dataSaveBanter = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            // let strSaveBanter = NSString(data: dataSaveBanter, encoding: String.Encoding.utf8.rawValue)! as String
             //print(strSaveBanter)
             //sendRequestToAPI(strRequestDict: strSaveBanter)
        
      /*   let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                                                       let strByPlace = NSString(data: dataByPlace, encoding: String.Encoding.utf8.rawValue)! as String
                                                                       //print(strByPlace)
                                                                       let escapedString = strByPlace.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                                                                       
                                                                       let url = MediaAPIjava + "request=" + escapedString!*/
                                                                      AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                                                                                                      headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                                                                                                        // 2
                                                                                                        .responseJSON { response in
                                                                                                            switch response.result {
                                                                                                                                                      case .success(let value):
                                                                                                                                                          if let json = value as? [String: Any] {
                                                                                                                                                              // print(" JSON:", json)
                                                                                                                                                              let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                                                                                                              // self.finishSyncContacts()
                                                                                                                                                              //print(" status:", status1)
                                                                                                                                                           if(status1){
                                                                                                                                                                  let response: NSArray = json[ "responseData"] as! NSArray
                                                                                                                                                                                                                let pickedCaption:[String: Any] = ["userdetail": response[0]]
                                                                                                                                                                                                                let notificationName = Notification.Name("showProfileWithNotify")
                                                                                                                                                                                                                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: pickedCaption)
                                                                                                                                                              }
                                                                                                                                                              else{
                                                                                                                                                              self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
                                                                                                                                                                  //Show Error
                                                                                                                                                              }
                                                                                                                                                          }
                                                                                                                                                      case .failure(let error):
                                                                                                                debugPrint(error as Any)
                                                                                                                self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
                                                                                                                break
                                                                                                                                                          // error handling
                                                                                                                                           
                                                                                                                                                      }
                                                                                    
                                                                                                    }
             } catch {
                                                        self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
                        print(error.localizedDescription)
                    }
        } else {
                                  alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                //   closeRefresh()
                                  
                              }
     }
    // By Mayank on 25 Sep 2018
    
    @objc func showProfileWithNotify(notification: NSNotification)
    {
        var totelsize = 490
         subtypevalue = (notification.userInfo?["userdetail"] )as! NSDictionary
        let blockstatus = subtypevalue.value(forKey: "blockedstatus") as! Bool
        if blockstatus == true {
            usernamelabel?.text = (subtypevalue.value(forKey: "username") as! String)
            //primaryTeamlabel?.text = (subtypevalue.value(forKey: "username") as! String)
            
            if(subtypevalue.value(forKey: "status") != nil)
                       {
                   statuslabel?.text = (subtypevalue.value(forKey: "status") as! String)
                       }
            else{
                statuslabel?.text = "Hello! I am a Football Fan"
            }
            var userAvatar: String = subtypevalue.value(forKey: "avatar") as! String
            if(!(userAvatar.isEmpty))
            {
                //userIBAvtar?.image = appDelegate().loadProfileImage(filePath: userAvatar!)
                //ImguserAvtar.image = appDelegate().loadProfileImage(filePath: userAvatar!)
               // appDelegate().loadImageFromUrl(url: userAvatar,view: ImguserAvtar, fileName: (subtypevalue.value(forKey: "username") as! String)+"avtar")
                ImguserAvtar.imageURL = userAvatar
            }
            else
            {
                ImguserAvtar.image = UIImage(named: "avatar")
            }
            let teamcode =  subtypevalue.value(forKey: "primaryteam") as AnyObject
                      let array1 = Teams_details.rows(filter:"team_Id = \(teamcode)") as! [Teams_details]
                      if(array1.count != 0){
                          let disnarysound = array1[0]
                          
                          let teamid = disnarysound.team_Id
                          let teamImageName = "Team" + teamid.description
                          
                           primaryTeamlabel!.text = disnarysound.team_name
                          let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                          if((teamImage) != nil)
                          {
                              Imgteam.image = appDelegate().loadProfileImage(filePath: teamImage!)
                              
                              if(Imgteam.image == nil)
                              {
                                  appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: Imgteam, fileName: teamImageName as String)
                              }
                          }
                          else
                          {
                              appDelegate().loadImageFromUrl(url: (disnarysound.team_logo) ,view: Imgteam, fileName: teamImageName as String)
                          }
                      }
        }
        else{
        // appDelegate().sendRequestToGetsubscription()
       
        usernamelabel?.text = (subtypevalue.value(forKey: "username") as! String)
        //primaryTeamlabel?.text = (subtypevalue.value(forKey: "username") as! String)
            if(subtypevalue.value(forKey: "status") != nil)
            {
        statuslabel?.text = (subtypevalue.value(forKey: "status") as! String)
            }
            else{
                statuslabel?.text = "Hello! I am a Football Fan"
            }
        var userAvatar: String? = ""
        if(subtypevalue.value(forKey: "avatar") != nil)
        {
            userAvatar = subtypevalue.value(forKey: "avatar") as? String
        }
        
       // var jidList = appDelegate().xmppRosterStorage.jidsForXMPPStream(appDelegate().xmppStream)
        //print("List=\(jidList)")
        //if((userName) != nil)
        //{
        //userIBName?.text = userName
        //}
        /*RoomJid = (subtypevalue.value(forKey: "jid") as! String)
        let array = Bantersound.rows(filter:"toUserJID = '\(RoomJid)'") as! [Bantersound]
        let disnarysound = array[0]
        
        let soundValue = disnarysound.value(forKey: "soundValue") as! Int
        if (soundValue == 1) {
            ibBanterSound.setOn(true, animated: false)
            ibsoundStatus?.text = "Sound On"
            Imgmute.image = UIImage(named:"sound_on")
        } else {
            ibBanterSound.setOn(false, animated: false)
            ibsoundStatus?.text = "Sound Off"
            ismute.image = UIImage(named:"sound_off")
        }*/
        if(!(userAvatar?.isEmpty)!)
        {
            //userIBAvtar?.image = appDelegate().loadProfileImage(filePath: userAvatar!)
            //ImguserAvtar.image = appDelegate().loadProfileImage(filePath: userAvatar!)
            //appDelegate().loadImageFromUrl(url: userAvatar!,view: ImguserAvtar, fileName: (subtypevalue.value(forKey: "username") as! String)+"avtar")
             ImguserAvtar.imageURL = userAvatar
        }
        else
        {
            ImguserAvtar.image = UIImage(named: "avatar")
        }
                //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                // countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                let teamcode =  subtypevalue.value(forKey: "primaryteam") as AnyObject
            let array1 = Teams_details.rows(filter:"team_Id = \(teamcode)") as! [Teams_details]
            if(array1.count != 0){
                let disnarysound = array1[0]
                
                let teamid = disnarysound.team_Id
                let teamImageName = "Team" + teamid.description
                
                 primaryTeamlabel!.text = disnarysound.team_name
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    Imgteam.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    if(Imgteam.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: Imgteam, fileName: teamImageName as String)
                    }
                }
                else
                {
                    appDelegate().loadImageFromUrl(url: (disnarysound.team_logo) ,view: Imgteam, fileName: teamImageName as String)
                }
            }
                /*for res in appDelegate().arrDataTeams
                {
                    //print(res)
                     let dict: NSDictionary! = res as! NSDictionary
                    let phoneCode = String(describing: dict.value(forKey: "id") as AnyObject) //(dict["id"] as? String)!
                    
                    if(phoneCode == teamcode)
                    {
                        primaryTeamlabel!.text = (dict["name"] as? String)!
                        // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)name
                        // Imgcountry.setImage(UIImage(named:(dict1["flag"] as? String)!), for: UIControlState.normal)
                         let teamImageName = "Team" + String(describing: dict.value(forKey: "id") as AnyObject)
                       
                        
                        let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                        if((teamImage) != nil)
                        {
                            Imgteam.image = appDelegate().loadProfileImage(filePath: teamImage!)
                            
                            if(Imgteam.image == nil)
                            {
                                appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "logo") as? String)!,view: Imgteam, fileName: teamImageName as String)
                            }
                        }
                        else
                        {
                            appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "logo") as? String)!,view: Imgteam, fileName: teamImageName as String)
                        }
                        break
                    }
                    
                }
                */
        let profilemobile = (subtypevalue.value(forKey: "profilemobile") as! String)
        var showMobile: Bool = false
        if(profilemobile == "None")
        {
            showMobile = false
        }
       
        else {
            showMobile = false
        }
        
        if(showMobile)
        {
            mobilelabel?.isHidden = false
            countrycodelabel?.isHidden = false
            Imgcountry.isHidden = false
            mobileprivacylabel?.isHidden = true
            let Mobileno = (subtypevalue.value(forKey: "mobile") as! String)
            if(Mobileno != ""){
                mobilelabel?.text = (subtypevalue.value(forKey: "mobile") as! String)
                if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    
                    do {
                        let countrycode: String? = subtypevalue.value(forKey: "shortcode") as? String //((subtypevalue.value(forKey: "countrycode") as! NSString) as String)
                        
                        if(countrycode != nil && !(countrycode?.isEmpty)!){
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                            
                            countrycodelabel!.text = dictCountry.value(forKey: "code") as? String
                            // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            // Imgcountry.setImage(UIImage(named:(dict1["flag"] as? String)!), for: UIControlState.normal)
                            Imgcountry.image = UIImage(named: (dictCountry.value(forKey: "flag") as? String)!)
                            
                            
                            
                            
                        }
                        else{
                            
                            countrycodelabel!.text = ""//dictCountry.value(forKey: "code") as? String
                            // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            // btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControlState.normal)
                            
                        }
                    } catch let _ as NSError {
                       // print(error)
                    }
                }
            }
            else{
                mobilelabel?.isHidden = true
                countrycodelabel?.isHidden = true
                Imgcountry.isHidden = true
                mobileprivacylabel?.text = "-"
                mobileprivacylabel?.isHidden = false
            }
            
        }
        else{
            mobilelabel?.isHidden = true
            countrycodelabel?.isHidden = true
            Imgcountry.isHidden = true
            mobileprivacylabel?.text = "Privacy Protected"
            mobileprivacylabel?.isHidden = false
        }
        let profileemail = (subtypevalue.value(forKey: "profileemail") as! String)
        var showEmail: Bool = false
        if(profileemail == "None")
        {
            showEmail = false
        }
      
        else{
            showEmail = false
        }
        if(showEmail)
        {
            emaillabel?.text = (subtypevalue.value(forKey: "email") as! String)
        }
        else{
            emaillabel?.text = "Privacy Protected"
        }
        }
        
         namelabel?.text = (subtypevalue.value(forKey: "name") as! String)
        var arrfollowteam: [AnyObject] = []
           let teamcode1 =  subtypevalue.value(forKey: "followteam1") as AnyObject
                                let array1 = Teams_details.rows(filter:"team_Id = \(teamcode1)") as! [Teams_details]
                                if(array1.count != 0){
                                    let disnarysound = array1[0]
                                    
                                    let teamid = disnarysound.team_Id
                                    let teamImageName = "Team" + teamid.description
                                    var tempDict3 = [String: String]()
                                           tempDict3["logo"] = teamImageName
                                           tempDict3["name"] = disnarysound.team_name
                                    tempDict3["logourl"] = disnarysound.team_logo
                                           arrfollowteam.append(tempDict3 as AnyObject)
                                    /* followteam1label!.text = disnarysound.team_name
                                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                                    if((teamImage) != nil)
                                    {
                                        Imgfollowteam1.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                        
                                        if(Imgteam.image == nil)
                                        {
                                            appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: Imgfollowteam1, fileName: teamImageName as String)
                                        }
                                    }
                                    else
                                    {
                                        appDelegate().loadImageFromUrl(url: (disnarysound.team_logo) ,view: Imgfollowteam1, fileName: teamImageName as String)
                                    }*/
                                }
        let teamcode2 =  subtypevalue.value(forKey: "followteam2") as AnyObject
                             let array2 = Teams_details.rows(filter:"team_Id = \(teamcode2)") as! [Teams_details]
                             if(array2.count != 0){
                                 let disnarysound = array2[0]
                                 
                                 let teamid = disnarysound.team_Id
                                 let teamImageName = "Team" + teamid.description
                                 var tempDict3 = [String: String]()
                                                                           tempDict3["logo"] = teamImageName
                                                                           tempDict3["name"] = disnarysound.team_name
                                 tempDict3["logourl"] = disnarysound.team_logo
                                                                           arrfollowteam.append(tempDict3 as AnyObject)
                                 /* followteam2label!.text = disnarysound.team_name
                                 let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                                 if((teamImage) != nil)
                                 {
                                     Imgfollowteam2.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                     
                                     if(Imgfollowteam2.image == nil)
                                     {
                                         appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: Imgfollowteam2, fileName: teamImageName as String)
                                     }
                                 }
                                 else
                                 {
                                     appDelegate().loadImageFromUrl(url: (disnarysound.team_logo) ,view: Imgfollowteam2, fileName: teamImageName as String)
                                 }*/
                             }
        let teamcode3 =  subtypevalue.value(forKey: "followteam3") as AnyObject
                             let array3 = Teams_details.rows(filter:"team_Id = \(teamcode3)") as! [Teams_details]
                             if(array3.count != 0){
                                 let disnarysound = array3[0]
                                 
                                 let teamid = disnarysound.team_Id
                                 let teamImageName = "Team" + teamid.description
                                 var tempDict3 = [String: String]()
                                                                           tempDict3["logo"] = teamImageName
                                                                           tempDict3["name"] = disnarysound.team_name
                                 tempDict3["logourl"] = disnarysound.team_logo
                                                                           arrfollowteam.append(tempDict3 as AnyObject)
                                 /* followteam3label!.text = disnarysound.team_name
                                 let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                                 if((teamImage) != nil)
                                 {
                                     Imgfollowteam3.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                     
                                     if(Imgfollowteam3.image == nil)
                                     {
                                         appDelegate().loadImageFromUrl(url: (disnarysound.team_logo),view: Imgfollowteam3, fileName: teamImageName as String)
                                     }
                                 }
                                 else
                                 {
                                     appDelegate().loadImageFromUrl(url: (disnarysound.team_logo) ,view: Imgfollowteam3, fileName: teamImageName as String)
                                 }*/
                             }
        TransperentLoadingIndicatorView.hide()
        if(arrfollowteam.count == 2){
            let dict: [String : String] = arrfollowteam[0] as! [String : String]
            followteam1label!.text = dict["name"]
            let teamImage: String? = UserDefaults.standard.string(forKey: dict["logo"]!)
                                              if((teamImage) != nil)
                                              {
                                                  Imgfollowteam1.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                                  
                                                  if(Imgfollowteam1.image == nil)
                                                  {
                                                    appDelegate().loadImageFromUrl(url: dict["logourl"]!,view: Imgfollowteam1, fileName: dict["logo"]! )
                                                  }
                                              }
                                              else
                                              {
                                                appDelegate().loadImageFromUrl(url: (dict["logourl"]!) ,view: Imgfollowteam1, fileName: dict["logo"]!)
                                              }
            let dict1: [String : String] = arrfollowteam[1] as! [String : String]
            followteam2label!.text = dict1["name"]
            let teamImage1: String? = UserDefaults.standard.string(forKey: dict1["logo"]!)
                                              if((teamImage1) != nil)
                                              {
                                                  Imgfollowteam2.image = appDelegate().loadProfileImage(filePath: teamImage1!)
                                                  
                                                  if(Imgfollowteam2.image == nil)
                                                  {
                                                    appDelegate().loadImageFromUrl(url: dict1["logourl"]!,view: Imgfollowteam2, fileName: dict1["logo"]! )
                                                  }
                                              }
                                              else
                                              {
                                                appDelegate().loadImageFromUrl(url: (dict1["logourl"]!) ,view: Imgfollowteam2, fileName: dict1["logo"]!)
                                              }
            optionalteamviewheight.constant = 80
            totelsize = totelsize - 40
        }
        else if(arrfollowteam.count == 3){
            let dict: [String : String] = arrfollowteam[0] as! [String : String]
                      followteam1label!.text = dict["name"]
                      let teamImage: String? = UserDefaults.standard.string(forKey: dict["logo"]!)
                                                        if((teamImage) != nil)
                                                        {
                                                            Imgfollowteam1.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                                            
                                                            if(Imgfollowteam1.image == nil)
                                                            {
                                                              appDelegate().loadImageFromUrl(url: dict["logourl"]!,view: Imgfollowteam1, fileName: dict["logo"]! )
                                                            }
                                                        }
                                                        else
                                                        {
                                                          appDelegate().loadImageFromUrl(url: (dict["logourl"]!) ,view: Imgfollowteam1, fileName: dict["logo"]!)
                                                        }
                      let dict1: [String : String] = arrfollowteam[1] as! [String : String]
                      followteam2label!.text = dict1["name"]
                      let teamImage1: String? = UserDefaults.standard.string(forKey: dict1["logo"]!)
                                                        if((teamImage1) != nil)
                                                        {
                                                            Imgfollowteam2.image = appDelegate().loadProfileImage(filePath: teamImage1!)
                                                            
                                                            if(Imgfollowteam2.image == nil)
                                                            {
                                                              appDelegate().loadImageFromUrl(url: dict1["logourl"]!,view: Imgfollowteam2, fileName: dict1["logo"]! )
                                                            }
                                                        }
                                                        else
                                                        {
                                                          appDelegate().loadImageFromUrl(url: (dict1["logourl"]!) ,view: Imgfollowteam2, fileName: dict1["logo"]!)
                                                        }
            let dict2: [String : String] = arrfollowteam[2] as! [String : String]
                                 followteam3label!.text = dict2["name"]
                                 let teamImage3: String? = UserDefaults.standard.string(forKey: dict2["logo"]!)
                                                                   if((teamImage3) != nil)
                                                                   {
                                                                       Imgfollowteam3.image = appDelegate().loadProfileImage(filePath: teamImage3!)
                                                                       
                                                                       if(Imgfollowteam3.image == nil)
                                                                       {
                                                                         appDelegate().loadImageFromUrl(url: dict2["logourl"]!,view: Imgfollowteam3, fileName: dict2["logo"]! )
                                                                       }
                                                                   }
                                                                   else
                                                                   {
                                                                     appDelegate().loadImageFromUrl(url: (dict2["logourl"]!) ,view: Imgfollowteam3, fileName: dict2["logo"]!)
                                                                   }
            optionalteamviewheight.constant = 120
        }
        else if(arrfollowteam.count == 0)   {
            followteam1label!.text = "Not Available"
                optionalteamviewheight.constant = 40
            Imgfollowteam1.isHidden = true
            optionalteamviewledding.constant = -30
            totelsize = totelsize - 80
            }
        else{
            let dict: [String : String] = arrfollowteam[0] as! [String : String]
                                 followteam1label!.text = dict["name"]
                                 let teamImage: String? = UserDefaults.standard.string(forKey: dict["logo"]!)
                                                                   if((teamImage) != nil)
                                                                   {
                                                                       Imgfollowteam1.image = appDelegate().loadProfileImage(filePath: teamImage!)
                                                                       
                                                                       if(Imgfollowteam1.image == nil)
                                                                       {
                                                                         appDelegate().loadImageFromUrl(url: dict["logourl"]!,view: Imgfollowteam1, fileName: dict["logo"]! )
                                                                       }
                                                                   }
                                                                   else
                                                                   {
                                                                     appDelegate().loadImageFromUrl(url: (dict["logourl"]!) ,view: Imgfollowteam1, fileName: dict["logo"]!)
                                                                   }
            optionalteamviewheight.constant = 40
            totelsize = totelsize - 80
        }
        
        fanstoryblockedstatus =  subtypevalue.value(forKey: "fanstoryblockedstatus") as! Bool
          isfollowed = subtypevalue.value(forKey: "followed") as! Bool
        if(isfollowed){
             followviewText?.setTitle("Unfollow" , for: UIControl.State.normal)
            followviewImage.image = UIImage(named: "UnfollowFan")
           // butfolloweedStatus?.backgroundColor = UIColor.init(hex: "AAAAAA")
        }
        else{
             followviewText?.setTitle("Follow" , for: UIControl.State.normal)
             followviewImage.image = UIImage(named: "FollowFan")
           // butfolloweedStatus?.backgroundColor = UIColor.init(hex: "2185F7")
        }
        if let bioData =  subtypevalue.value(forKey: "bio")
                                       {
                                        let bio = (subtypevalue.value(forKey: "bio") as! String)
                                        if(bio == ""){
                                            biolabel?.text = "Not Available"
                                        }
                                        else{
                                        biolabel?.text = (subtypevalue.value(forKey: "bio") as! String)
                                        let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (biolabel?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
                                                                  label.font = UIFont.systemFont(ofSize: 14.0)
                                        label.text = biolabel?.text
                                                                  label.textAlignment = .left
                                                                  //label.textColor = self.strokeColor
                                                                  label.lineBreakMode = .byWordWrapping
                                                                  label.numberOfLines = 0
                                                                  label.sizeToFit()
                                        if((label.frame.height) > 39)
                                        {
                                            bioviewheight.constant = label.frame.height + 10
                                            let height = (label.frame.height) - 40
                                            totelsize = totelsize + Int(height)
                                        }
                                        }
        }
        else{
              biolabel?.text = "Not Available"
            
        }
         followerscount = subtypevalue.value(forKey: "followerscount") as! Int64
         followingcount = subtypevalue.value(forKey: "followingcount") as! Int64
         fanstorycount = subtypevalue.value(forKey: "fanstorycount") as! Int64
        if(fanstorycount>1){
            butpost?.setTitle("Posts" , for: UIControl.State.normal)
        }
        else{
            butpost?.setTitle("Post" , for: UIControl.State.normal)
        }
        if(followingcount>1){
            butfollowing?.setTitle("Following" , for: UIControl.State.normal)
        }
        else{
            butfollowing?.setTitle("Following", for: UIControl.State.normal)
        }
        if(followerscount>1){
            butfollower?.setTitle("Followers" , for: UIControl.State.normal)
        }
        else{
            butfollower?.setTitle("Follower" , for: UIControl.State.normal)
        }
        butfollowercount?.setTitle( self.appDelegate().formatNumber(Int(followerscount )) , for: UIControl.State.normal)
        butfollowingcount?.setTitle(self.appDelegate().formatNumber(Int(followingcount )) , for: UIControl.State.normal)
        butpostcount?.setTitle(self.appDelegate().formatNumber(Int(fanstorycount )) , for: UIControl.State.normal)
        let CurentLevel = (subtypevalue.value(forKey: "level") as! String)
                
            if(CurentLevel == "Bronze")
                   {
                    let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbronzeimageh) as? String
                       
                       let fileManager = FileManager.default
                       
                    if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                           // print("file")
                        self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                       } else {
                        self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                       }
                   } else if(CurentLevel  == "Silver")
                   {
                    let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsilverimageh) as? String
                       
                       let fileManager = FileManager.default
                       
                    if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                           // print("file")
                        self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                       } else {
                        self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                       }
                   } else if(CurentLevel == "Gold")
                   {
                    let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcgoldimageh) as? String
                       
                       let fileManager = FileManager.default
                       
                    if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                           // print("file")
                        self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                       } else {
                        self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                       }
                   } else if(CurentLevel == "Platinum")
                   {
                    let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcplatinumimageh) as? String
                       
                       let fileManager = FileManager.default
                       
                    if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                           // print("file")
                        self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                       } else {
                        self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                       }
                   } else if(CurentLevel == "Diamond")
                   {
                    let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcdiamondimageh) as? String
                       
                       let fileManager = FileManager.default
                       
                    if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                           // print("file")
                        self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                       } else {
                        self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                       }
                   }
            else{
                imglavel?.isHidden = true
            }
        let isverify = (subtypevalue.value(forKey: "verified") as! String)//subtypevalue.value(forKey: "verified") as! Bool
            if (isverify == "yes") {
                imgsisverify?.image = UIImage(named: "like")
            }
            else{
                imgsisverify?.isHighlighted = true
            }
        let bounds: CGRect = UIScreen.main.bounds
                             //var width:CGFloat = bounds.size.width
                             let width:CGFloat = bounds.size.width
                     
        self.parenthightConstraint.constant = width + 0.0 + CGFloat(totelsize)
        fanmessge = (subtypevalue.value(forKey: "message") as! String)
    }
    @objc func getsubcribeWithNotify(notification: NSNotification)
    {
        let inmycontacts = (notification.userInfo?["subcriptiontype"] )as! String
        let profilemobile = (subtypevalue.value(forKey: "profilemobile") as! String)
        var showMobile: Bool = false
        if(profilemobile == "None")
        {
            showMobile = false
        }
        else if(profilemobile == "My contacts"){
            if(inmycontacts == "to" || inmycontacts == "both" )
            {
                showMobile = true
            }
            else{
                showMobile = false
            }
            
        }
        else{
            showMobile = true
        }
       
        if(showMobile)
        { mobilelabel?.isHidden = false
            countrycodelabel?.isHidden = false
            Imgcountry.isHidden = false
            mobileprivacylabel?.isHidden = true
            let Mobileno = (subtypevalue.value(forKey: "mobile") as! String)
            if(Mobileno != ""){
                mobilelabel?.text = (subtypevalue.value(forKey: "mobile") as! String)
                if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    
                    do {
                        let countrycode: String? = subtypevalue.value(forKey: "shortcode") as? String //((subtypevalue.value(forKey: "countrycode") as! NSString) as String)
                      
                        if(countrycode != nil  && !(countrycode?.isEmpty)!){
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                            
                            countrycodelabel!.text = dictCountry.value(forKey: "code") as? String
                            // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            // Imgcountry.setImage(UIImage(named:(dict1["flag"] as? String)!), for: UIControlState.normal)
                            Imgcountry.image = UIImage(named: (dictCountry.value(forKey: "flag") as? String)!)
                            
                          
                            
                            
                        }
                        else{
                            
                            countrycodelabel!.text = ""//dictCountry.value(forKey: "code") as? String
                            // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            // btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControlState.normal)
                            
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            else{
                mobilelabel?.isHidden = true
                countrycodelabel?.isHidden = true
                Imgcountry.isHidden = true
                mobileprivacylabel?.text = "-"
                mobileprivacylabel?.isHidden = false
            }
            
        }
        else{
            mobilelabel?.isHidden = true
            countrycodelabel?.isHidden = true
            Imgcountry.isHidden = true
            mobileprivacylabel?.text = "Privacy Protected"
            mobileprivacylabel?.isHidden = false
        }
        let profileemail = (subtypevalue.value(forKey: "profileemail") as! String)
        var showEmail: Bool = false
        if(profileemail == "None")
        {
            showEmail = false
        }
        else if(profileemail == "My contacts"){
            if(inmycontacts == "to" || inmycontacts == "both" )
            {
                showEmail = true
            }
            else{
                showEmail = false
            }
            
        }
        else{
            showEmail = true
        }
        if(showEmail)
        {
            emaillabel?.text = (subtypevalue.value(forKey: "email") as! String)
        }
        else{
            emaillabel?.text = "Privacy Protected"
        }
        
      
        
        
    }
    func getFilePath(url : String) -> String
        {
            let arrReadselVideoPath = url.components(separatedBy: "/")
            let imageId = arrReadselVideoPath.last
            let arrReadimageId = imageId?.components(separatedBy: ".")
            //let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".png")
            return paths
        }
    @IBAction func FollowerAction () {
       
          if(followerscount>0){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myController : FollowerViewController = storyBoard.instantiateViewController(withIdentifier: "follower") as! FollowerViewController
        myController.followusername = RoomJid
                         show(myController, sender: self)
        }
      }
      @IBAction func FollowingAction () {
          
                 if(followingcount>0){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myController : FollowingViewController = storyBoard.instantiateViewController(withIdentifier: "following") as! FollowingViewController
        myController.followusername = RoomJid
                         show(myController, sender: self)
        }
         }
      @IBAction func PostAction () {
       
        
         if(fanstorycount>0){
         if(fanstoryblockedstatus){
            let alert = UIAlertController(title: nil, message: fanmessge, preferredStyle: .alert)
            let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                
            });
            let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
               self.showStoriesBlockedUser()
               });
                           alert.addAction(action1)
                           alert.addAction(action)
                           self.present(alert, animated: true, completion:nil)
        }
         else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                 let registerController : MyFanUpdateViewController! = storyBoard.instantiateViewController(withIdentifier: "MyFanUpdate") as? MyFanUpdateViewController
            let arrdUserJid = RoomJid.components(separatedBy: "@")
                  let userUserJid = arrdUserJid[0]
            registerController.folowedusername = userUserJid
                 //present(registerController as! UIViewController, animated: true, completion: nil)
                 // self.appDelegate().curRoomType = "chat"
                 show(registerController, sender: self)
        }
        }
      }
    @objc func messageAction (_ longPressGestureRecognizer: UITapGestureRecognizer) {
         // self.appDelegate().isJoined = "yes"
                                        //self.appDelegate().curRoomType = "chat"
                      
                        //self.appDelegate().toUserJID = self.RoomJid//(dict.value(forKey: "jid") as? String)!
                                       let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                         //let arrdUserJid = myjid?.components(separatedBy: "@")
                                                         //let userUserJid = arrdUserJid?[0]
                                                         if(myjid != RoomJid)
                                                         {
                                                            let Roomname: String =  self.appDelegate().ExistingContact(username: self.RoomJid)!//(dict.value(forKey: "username") as? String)!
                                 
                                       
                        self.showChatWindow(roomid: self.RoomJid, BanterClosed: "active", roomtype: "chat", roomname: Roomname, join: "yes", mySupportedTeam: 0)
        }
         }
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
           //print("Share Click")
        inviteFan()
    }
    func showStoriesBlockedUser()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : StoriesBlockesUserViewController = storyBoard.instantiateViewController(withIdentifier: "StoriesBlockesUser") as! StoriesBlockesUserViewController
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
       // self.present(myTeamsController, animated: true, completion: nil)
    }
      @objc func followedAction (_ longPressGestureRecognizer: UITapGestureRecognizer) {
        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    //let arrdUserJid = myjid?.components(separatedBy: "@")
                    //let userUserJid = arrdUserJid?[0]
                    if(myjid != RoomJid)
                    {
        SaveFollow()
        }
    }
    func SaveFollow()  {
        if ClassReachability.isConnectedToNetwork()
               {
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "savefollowers" as AnyObject
        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
        dictRequest["device"] = "ios" as AnyObject
        
        let time: Int64 = self.appDelegate().getUTCFormateDate()
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let arrReadUserJid = login?.components(separatedBy: "@")
            let myMobile: String? = arrReadUserJid?[0]
                let followusernameUserJid = RoomJid.components(separatedBy: "@")
                let    followusername: String? = followusernameUserJid[0]
            
            dictRequestData["username"] = myMobile as AnyObject
            dictRequestData["followusername"] = followusername as AnyObject
        dictRequestData["type"] = "fan" as AnyObject
         dictRequestData["time"] = time as AnyObject
           
            dictRequest["requestData"] = dictRequestData as AnyObject
        AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                                                                                                              // 2
                                                                                                              .responseJSON { response in
                                                                            switch response.result {
                                                                                                                      case .success(let value):
                                                                                                                          if let json = value as? [String: Any] {
                                                                                                                                                                     // print(" JSON:", json)
                                                                                                                                                                     let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                                                                                                                     // self.finishSyncContacts()
                                                                                                                                                                     //print(" status:", status1)
                                                                                                                                                                   if(status1){
                                                                                                                          // self.isfollowed = json["followed"]
                                                                                                                                                                       if(self.isfollowed){
                                                                                                                                                                           self.isfollowed = false
                                                                                                                                                                           self.followviewText?.setTitle("Follow" , for: UIControl.State.normal)
                                                                                                                                                                           
                                                                                                                                                                           self.followviewImage.image = UIImage(named: "FollowFan")                                                     //self.butfolloweedStatus?.backgroundColor = UIColor.init(hex: "2185F7")
                                                                                                                                                                              }
                                                                                                                                                                              else{
                                                                                                                                                                           self.isfollowed = true
                                                                                                                                                                           self.followviewText?.setTitle("Unfollow" , for: UIControl.State.normal)
                                                                                                                                                                           self.followviewImage.image = UIImage(named: "UnfollowFan")
                                                                                                                                                                           //self.butfolloweedStatus?.backgroundColor = UIColor.init(hex: "AAAAAA")
                                                                                                                                                                              }
                                                                                                                                                                       
                                                                                                                                                                       let response: NSArray = json[ "responseData"] as! NSArray
                                                                                                                                                                       let dic:NSDictionary = response[0] as! NSDictionary
                                                                                                                                                                       let followerscount = dic.value(forKey: "followerscount") as! Int64
                                                                                                                                                                              let followingcount = dic.value(forKey: "followingcount") as! Int64
                                                                                                                                                                              let fanstorycount = dic.value(forKey: "fanstorycount") as! Int64
                                                                                                                                                                              if(fanstorycount>1){
                                                                                                                                                                               self.butpost?.setTitle("Posts" , for: UIControl.State.normal)
                                                                                                                                                                              }
                                                                                                                                                                              else{
                                                                                                                                                                               self.butpost?.setTitle("Post" , for: UIControl.State.normal)
                                                                                                                                                                              }
                                                                                                                                                                              if(followingcount>1){
                                                                                                                                                                               self.butfollowing?.setTitle("Following" , for: UIControl.State.normal)
                                                                                                                                                                              }
                                                                                                                                                                              else{
                                                                                                                                                                               self.butfollowing?.setTitle("Following", for: UIControl.State.normal)
                                                                                                                                                                              }
                                                                                                                                                                              if(followerscount>1){
                                                                                                                                                                               self.butfollower?.setTitle("Followers" , for: UIControl.State.normal)
                                                                                                                                                                              }
                                                                                                                                                                              else{
                                                                                                                                                                               self.butfollower?.setTitle("Follower" , for: UIControl.State.normal)
                                                                                                                                                                              }
                                                                                                                                                                       self.butfollowercount?.setTitle( self.appDelegate().formatNumber(Int(followerscount )) , for: UIControl.State.normal)
                                                                                                                                                                       self.butfollowingcount?.setTitle(self.appDelegate().formatNumber(Int(followingcount )) , for: UIControl.State.normal)
                                                                                                                                                                       self.butpostcount?.setTitle(self.appDelegate().formatNumber(Int(fanstorycount )) , for: UIControl.State.normal)
                                                                                                                                                                       
                                                                                                                                                                   }
                                                                                                                                                                   else{
                                                                                                                                                                       
                                                                                                                                                                   }
                                                                                                                                                                 }
                                                                                                                      case .failure(let error):
                                                                                                                        debugPrint(error)
                                                                                break
                                                                                                                          // error handling
                                                                                                           
                                                                                                                      }
                                                                                                                
                                                                                                          }
        
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    @IBAction func blockAction () {
       // var title = "Block"
        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    //let arrdUserJid = myjid?.components(separatedBy: "@")
                    //let userUserJid = arrdUserJid?[0]
                    if(myjid != RoomJid)
                    {
        var messages = "Do you really want to block "+appDelegate().toName+"?"
        
        if(isBlocked)
        {
            //title = "Unblock"
            messages = "Do you really want to unblock "+appDelegate().toName+"?"
        }
        else
        {
           // title = "Block"
            messages = "Do you really want to block "+appDelegate().toName+"?"
        }
        let alert = UIAlertController(title: "", message: messages, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel,handler: {_ in
            
            if ClassReachability.isConnectedToNetwork()
            {
                // self.adminDeleteBanterRoom ()
               
                if(self.isBlocked){
                   // TransperentLoadingIndicatorView.show((self.view)!, loadingText: "")
                   
                    self.appDelegate().calluserunblock(blockeduser: self.appDelegate().toUserJID)
                                                                    /*
                      let login: String? = self.appDelegate().toUserJID
                     let arrReadUserJid = login?.components(separatedBy: "@")
                                                                    let userReadUserJid = arrReadUserJid?[0]
                                                                    
                                                                    let myMobile: String? = userReadUserJid
                                      if(self.appDelegate().isUserOnline){
                                            self.appDelegate().calluserunblock(blockeduser: self.appDelegate().toUserJID)
                                           let uuid = UUID().uuidString
                                           let time: Int64 = self.appDelegate().getUTCFormateDate()
                                           self.appDelegate().sendMessageToServer(self.appDelegate().toUserJID as AnyObject as! String, messageContent: "Manager has unblocked you.", messageType: "header", messageTime: time, messageId: uuid, roomType: "chat", messageSubType: "singleunblock" )
                                       }
                                       else{
                                           let pickedCaption:[String: Any] = ["userdetail": "unblocked"]
                                                                                                                                                                                      let notificationName = Notification.Name("singlechatfail")
                                                                                                                                                                                      NotificationCenter.default.post(name: notificationName, object: nil, userInfo: pickedCaption)//Show Error
                                           
                                       }*/
                   
                    /*    var dictRequest = [String: AnyObject]()
                        dictRequest["cmd"] = "userunblock" as AnyObject
                        
                        
                        
                        do {
                            //Creating Request Data
                            var dictRequestData = [String: AnyObject]()
                            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                            let arrdUserJid = myjid?.components(separatedBy: "@")
                            let userUserJid = arrdUserJid?[0]
                            
                            let myjidtrim: String? = userUserJid
                            let login: String? = self.appDelegate().toUserJID
                            let arrReadUserJid = login?.components(separatedBy: "@")
                            let userReadUserJid = arrReadUserJid?[0]
                             let time: Int64 = self.appDelegate().getUTCFormateDate()
                            let myMobile: String? = userReadUserJid//UserDefaults.standard.string(forKey: "myMobileNo")
                            dictRequestData["username"] = myjidtrim as AnyObject
                            dictRequestData["blockedusername"] = myMobile as AnyObject
                            let array = Blockeduser.rows(filter:"roomId = '\(self.RoomJid)'") as! [Blockeduser]
                            if(array.count != 0){
                                let disnarysound = array[0]
                                
                              //  let status = disnarysound.value(forKey: "blocked_time") as AnyObject
                                dictRequestData["blockedtime"] = myjidtrim as AnyObject
                                
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
                            //print(strGetBanterDetails)
                            self.appDelegate().sendRequestToAPI(strRequestDict: strGetBanterDetails)
                        } catch {
                            print(error.localizedDescription)
                        }
                       */
                    
                   
                }
                else{
                    //LoadingIndicatorView.show((self.appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while we process block request")
                   // TransperentLoadingIndicatorView.show((self.view)!, loadingText: "")
                    
                  let login: String? = self.appDelegate().toUserJID
                                                 let arrReadUserJid = login?.components(separatedBy: "@")
                                                 let userReadUserJid = arrReadUserJid?[0]
                                                 
                                                 let myMobile: String? = userReadUserJid
                   /* if(self.appDelegate().isUserOnline){
                        self.appDelegate().getuserblock(blockuser: myMobile!)
                        let uuid = UUID().uuidString
                        let time: Int64 = self.appDelegate().getUTCFormateDate()
                        self.appDelegate().sendMessageToServer(self.appDelegate().toUserJID as AnyObject as! String, messageContent: "Manager has blocked you.", messageType: "header", messageTime: time, messageId: uuid, roomType: "chat", messageSubType: "singleblock" )
                    }
                    else{
                        let pickedCaption:[String: Any] = ["userdetail": "Blocked"]
                                                                                                                                                                   let notificationName = Notification.Name("singlechatfail")
                                                                                                                                                                   NotificationCenter.default.post(name: notificationName, object: nil, userInfo: pickedCaption)//Show Error
                        
                    }*/
                     self.appDelegate().getuserblock(blockuser: myMobile!)
                    /*var dictRequest = [String: AnyObject]()
                    dictRequest["cmd"] = "userblock" as AnyObject
                    
                    
                    
                    do {
                        //Creating Request Data
                        var dictRequestData = [String: AnyObject]()
                        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                        let arrdUserJid = myjid?.components(separatedBy: "@")
                        let userUserJid = arrdUserJid?[0]
                        
                        let myjidtrim: String? = userUserJid
                        let login: String? = self.appDelegate().toUserJID
                        let arrReadUserJid = login?.components(separatedBy: "@")
                        let userReadUserJid = arrReadUserJid?[0]
                        
                        let myMobile: String? = userReadUserJid//UserDefaults.standard.string(forKey: "myMobileNo")
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
                        //print(error.localizedDescription)
                    }*/
                    
                }
            }
            else {
                 self.alertWithTitle(title: "Error", message: "Please check your Internet connection.", ViewController: self)
                
            }
            
            
        });
        let action1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        alert.addAction(action)
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
        }
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func cancel () {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func FailUpdateBlockUnblockStatus(notification: NSNotification)
    {
        let  Status = (notification.userInfo?["userdetail"] )as! String
        TransperentLoadingIndicatorView.hide()
        if(Status == "Blocked"){
            self.alertWithTitle(title: "Error", message: "Oops! Something went wrong while processing block request. Please try later.", ViewController: self)
            
        }
        else{
            self.alertWithTitle(title: "Error", message: "Oops! Something went wrong while processing unblock request. Please try later.", ViewController: self)
            
        }
    }
    @objc func UpdateBlockUnblockStatus(notification: NSNotification)
    {
      let  Status = (notification.userInfo?["userdetail"] )as! String
        TransperentLoadingIndicatorView.hide()
        if(Status == "Blocked"){
           
            let login: String? = self.appDelegate().toUserJID
           
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            //let array = Blockeduser.rows(filter:"roomId = '\(RoomJid)'") as! [Blockeduser]
            let array =  appDelegate().db.query(sql: "SELECT * FROM Blockeduser where roomId = '\(self.appDelegate().toUserJID)' And chatType = 'chat'")
            if(array.count == 0){
            let BlockeduserTable = Blockeduser()
            BlockeduserTable.chatType = "chat"
            BlockeduserTable.roomId = login!
                 BlockeduserTable.touser = login!
            BlockeduserTable.unblocked_time = 0
            BlockeduserTable.status = "Blocked"
            BlockeduserTable.blocked_time = time
            if BlockeduserTable.save() != 0 {
                isBlocked = true
               
            }
            }
            else{
                isBlocked = true
                let time: Int64 = self.appDelegate().getUTCFormateDate()
                let login = self.appDelegate().toUserJID as String
                
                _ = appDelegate().db.query(sql: " UPDATE blockeduser SET status = 'Blocked', unblocked_time = 0,blocked_time = \(time) WHERE roomId = '\(login)' And chatType = 'chat'")
                //print(result)
            }
            btnblock?.setTitle("Unblock", for:  UIControl.State.normal)
            imgblockstatus?.image = UIImage(named: "unblock")
           btnblock?.setTitleColor(UIColor(hex: "069c06"), for: .normal)
        }
        else{
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            let login = self.appDelegate().toUserJID as String
            
            _ = appDelegate().db.query(sql: " UPDATE blockeduser SET status = 'unblocked', unblocked_time = \(time) WHERE roomId = '\(login)' And chatType = 'chat'")
            //print(result)
            isBlocked = false
            btnblock?.setTitle("Block", for:  UIControl.State.normal)
            imgblockstatus?.image = UIImage(named: "blocked")
             btnblock?.setTitleColor(UIColor(hex: "FF3939"), for: .normal)
        }
        
    }
}
