//
//  TriviaViewController.swift
//  FootballFan
//
//  Created by Apple on 19/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Alamofire
class TriviaViewController: VideoSplashViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
     @IBOutlet weak var storyTableView: UITableView?
     @IBOutlet weak var messageBox: UITextField!
     var iskeybordHide = false
     let cellReuseIdentifier = "triviaCell"
     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
     var historyIndex: Int = 0
      var isAutoScroll = false
     var isSendMessage = false
     @IBOutlet weak var btnCamera: UIButton?
     @IBOutlet weak var countComment: UILabel!
    @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var Connectinglabel: UILabel?
     @IBOutlet weak var playerview: UIView!
    @IBOutlet weak var floaterView: Floater!
     @IBOutlet weak var onlineusercount: UILabel?
      @IBOutlet weak var loginbut: UIButton?
     @IBOutlet weak var messageboxview: UIView?
    //var moviePlayer:MPMoviePlayerController!
    //var player: AVPlayer = AVPlayer()
     @IBOutlet weak var viewcountConstraint: NSLayoutConstraint!
    var triviadetail: NSDictionary = [:]
    var url: URL!
    var asset: AVAsset!
    var player: AVPlayer = AVPlayer()
    var playerItem: AVPlayerItem!
    var timeObserverToken: Any?
     @IBOutlet weak var viewcountView: UIView?
    private var playerItemContext = 0
    
    var gameTimer: Timer?
    
    let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    var justStalled = 0
     @IBOutlet weak var lblmesg: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        messageBox.delegate = self
      // playerview.isHidden = true
        let notificationName = Notification.Name("triviaMessageReceivedFromServer")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(TriviaViewController.messageReceivedFromServer), name: notificationName, object: nil)
        storyTableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TriviaViewController.minimiseKeyboard(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        storyTableView?.isUserInteractionEnabled = true
        let notificationName2 = Notification.Name("_isUserOnlinetrivia")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(TriviaViewController.isUserOnline), name: notificationName2, object: nil)
        
        let notificationName12 = Notification.Name("chatHistoryFailontrivia")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(TriviaViewController.historyFail), name: notificationName12, object: nil)
        //refreshTable = UIRefreshControl()
        //refreshTable.attributedTitle = NSAttributedString(string: "Contacts sync in progress...")
        //refreshTable.addTarget(self, action: #selector(ChatViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        //storyTableView?.addSubview(refreshTable)
        let notificationName13 = Notification.Name("MessageReceivedFromhistorytrivia")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(TriviaViewController.messageReceivedFromHistory), name: notificationName13, object: nil)
        let notificationName14 = Notification.Name("LikeMessageReceived")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(TriviaViewController.likemessageReceived), name: notificationName14, object: nil)
         //loadVideoStreamSample()
        let notificationName_ffdeeplink = Notification.Name("triviauseronline")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTonlineuser(notification:)), name: notificationName_ffdeeplink, object: nil)
        //print(url.absoluteString)
        //let hlsLink = 'http://thelinktomyHLSmovie'
      /*  player = AVPlayer(url: url)
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
           playerVC.player?.play()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVCaptureSessionDidStopRunning,
                                               object:player)*/
        /*let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()*/
         url = URL(string:triviadetail.value(forKey: "TriviaLink") as! String)!
        prepareToPlay()
        //gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(createPlayerObserver), userInfo: nil, repeats: true)
        
        if #available(iOS 10.0, *) {
           startTimerShort()
        } else {
            // Fallback on earlier versions
        }
        navigationController?.isNavigationBarHidden = true
        let notificationName_triviaClose = Notification.Name("triviaclose")
               // Register to receive notification
               NotificationCenter.default.addObserver(self, selector: #selector(self.roomclose(notification:)), name: notificationName_triviaClose, object: nil)
    }
   /* override var prefersStatusBarHidden: Bool {
          return true
      }*/
    @objc func roomclose(notification: NSNotification)
       {
           DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
            self.player.pause()
            self.player = AVPlayer()
            self.stopTimerTest()
            
                  self.navigationController?.popViewController(animated: true)
                  
        }
    }
    @objc func refreshTonlineuser(notification: NSNotification)
    {
        DispatchQueue.main.async {
            let count = (notification.userInfo?["index"] )as AnyObject
            let lblecount = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (self.onlineusercount?.frame.height)!))
        lblecount.font = UIFont.systemFont(ofSize: 17.0)
            lblecount.text = "\(self.appDelegate().formatNumber(count as? Int ?? 0 ))"
        lblecount.textAlignment = .left
        //label.textColor = self.strokeColor
        lblecount.lineBreakMode = .byWordWrapping
        lblecount.numberOfLines = 1
        lblecount.sizeToFit()
            self.viewcountConstraint.constant = lblecount.frame.width + 47
        
            self.onlineusercount?.text = "\(self.appDelegate().formatNumber( count as? Int ??  0))"
            if(count as! Int > 0){
                self.viewcountView?.isHidden = false
            }
            else{
                self.viewcountView?.isHidden = true
            }
        }
        
    }
   
     @IBAction func login(_ sender: UIButton) {
         navigationController?.isNavigationBarHidden = false
        appDelegate().LoginwithModelPopUp()
    }
    @IBAction func hearted(_ sender: UIButton) {
        //postLike()
        if(!appDelegate().toUserJID.isEmpty)
        {
           // var newBanterNickName: String = ""
           
            //If Internet connected
            //print(appDelegate().isOnline)
            //  print(appDelegate().mySupportedTeam)
            if(currentReachabilityStatus != .notReachable && appDelegate().isUserOnline == true)
            {
                print("buttonclick")
                 startEndAnimation()
                let uuid = UUID().uuidString
                let time: Int64 = appDelegate().getUTCFormateDate()
                //print(time)
                //var name : String = "GALERIA DOMINIKAŃSKA"
                let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                if(!istriviauser){
                    
                  let login: String? = UserDefaults.standard.string(forKey: "userJID")
                self.appDelegate().sendMessageToServer(appDelegate().toUserJID as AnyObject as! String, messageContent: login! + " has liked.", messageType: "header", messageTime: time, messageId: uuid, roomType: "trivia", messageSubType: "trivialike", mySupportTeam: 0, JoindUserName: login!)
                }else{
                    let login: String? = UserDefaults.standard.string(forKey: "triviauser")
                    self.appDelegate().sendMessageToServer(appDelegate().toUserJID as AnyObject as! String, messageContent: login! + " has liked.", messageType: "header", messageTime: time, messageId: uuid, roomType: "trivia", messageSubType: "trivialike", mySupportTeam: 0, JoindUserName: login!)
                }
                    
               
               
            }
            else{
                
            }
            
            
            
        }
       
    }
    @objc func likemessageReceived()
    {
        startEndAnimation()
    }
    private func startEndAnimation() {
         DispatchQueue.main.async {
            print("startAnimation on triviaview")
            self.floaterView.startAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.floaterView.stopAnimation()
             print("stopAnimation on triviaview")
        })
    }
    
     @IBAction func inviteFan(sender:UIButton)
    {
        do {
            
            var dictRequest = [String: AnyObject]()
            dictRequest["id"] = triviadetail.value(forKey: "ID") as AnyObject
            dictRequest["type"] = "trivia" as AnyObject
            let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
           
           
            let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            
            let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
            
            let param = resultNSString as String?
            
            let inviteurl = InviteHost + "?q=" + param!
          
           let title = triviadetail.value(forKey: "Title") as! String
              var text =  "\(title)\n\nPlay live Football Trivia and win prizes with me on Football Fan App\n\n"
                                                                                             //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                                                                                            let recReadUserJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                             if(recReadUserJid != nil){
                                                                                                 let arrReadUserJid = recReadUserJid?.components(separatedBy: "@")
                                                                                                 let userReadUserJid = arrReadUserJid?[0]
                                                                                                 text = text + "Use my code \"\(userReadUserJid!)\" to Sign Up!\n\n"
                                                                                             }
                                                                                                        //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                                          text = text + "\(inviteurl)"
                             let objectsToShare = [text] as [Any]
                                                                              let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                                              
                                                                              //New Excluded Activities Code
                                                                              activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                                                              //
                                                                              
                                                                              activityVC.popoverPresentationController?.sourceView = self.view
                                                                              self.present(activityVC, animated: true, completion: nil)
           /* let myWebsite = NSURL(string: inviteurl)
            let shareAll = [text, myWebsite as Any] as [Any]
            
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)*/
            
            //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          appDelegate().ismodalshow = false
        appDelegate().isOntriviaChatsView = false
       /* navigationController?.isNavigationBarHidden = false
        player.pause()
        player = AVPlayer()
        stopTimerTest()*/
      appDelegate().toUserJID = ""
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          appDelegate().ismodalshow = true
        appDelegate().isOntriviaChatsView = true
         appDelegate().curRoomType = "trivia"
       // print(appDelegate().toUserJID)
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
           loginbut?.isHidden = true
            let Purchased = triviadetail.value(forKey: "Purchased") as! Bool
            if(Purchased){
                messageboxview?.isHidden = false
               
            }
            else{
                messageboxview?.isHidden = true
                 lblmesg?.isHidden = false
            }
            
                if ClassReachability.isConnectedToNetwork() {
                    
                    if(self.appDelegate().isUserOnline)
                    {
                        roomJoin()
                        // LoadingIndicatorView.hide()
                        // self.parent?.title = "Banter Rooms"
                        // self.parent?.title = "Banter"
                        self.ConectingHightConstraint.constant = CGFloat(0.0)
                    }
                    else
                    {
                        self.ConectingHightConstraint.constant = CGFloat(0.0)
                        DispatchQueue.main.async {
                            // self.Connectinglabel?.text = "Connecting..."
                            // self.ConectingHightConstraint.constant = CGFloat(0.0)
                        }
                        //LoadingIndicatorView.hide()
                        // self.parent?.title = "Banter Rooms"
                        //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading banters.")
                        // self.parent?.title = "Connecting.."
                    }
                    
                    
                } else {
                    
                    TransperentLoadingIndicatorView.hide()
                    self.Connectinglabel?.text = "Waiting for network..."
                    self.ConectingHightConstraint.constant = CGFloat(20.0)
                    //  }
                    //self.parent?.title = "Waiting for network.."
                    
                }
            
        }
        else{
            loginbut?.isHidden = false
            messageboxview?.isHidden = true
            if ClassReachability.isConnectedToNetwork() {
                // self.Connectinglabel?.text = "Connecting..."
                 self.ConectingHightConstraint.constant = CGFloat(0.0)
                 let triviauser: String? = UserDefaults.standard.string(forKey: "triviauser")
                if(triviauser == nil){
                let user = appDelegate().shortCodeGenerator(length: 7) + JIDPostfix
                 let password = appDelegate().shortCodeGenerator(length: 7)
                UserDefaults.standard.setValue(user, forKey: "triviauser")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(true, forKey: "istriviauser")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(password, forKey: "tuserpassword")
                UserDefaults.standard.synchronize()
                   if appDelegate().connect()
                   {
                    }
                }
                else{
                    appDelegate().connect()
                }
            }else{
                 self.Connectinglabel?.text = "Waiting for network..."
                 self.ConectingHightConstraint.constant = CGFloat(20.0)
            }
            // ConectingHightConstraint.constant = CGFloat(0.0)
        }
      //GetViewcount()
    }
    func roomJoin()  {
        if(appDelegate().toUserJID != ""){
        appDelegate().joinRoomTrivia(with: appDelegate().toUserJID)
       // appDelegate().toUserJID = "trivia1234@conference.oftest.ifootballfan.com"
       
        let uuid = UUID().uuidString
        let messageId = uuid
       
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           
            let time2: Int64 = self.appDelegate().getUTCFormateDate()
            let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
            if(!istriviauser){
                 let login: String? = UserDefaults.standard.string(forKey: "userJID")
                self.appDelegate().sendMessageToServer(self.appDelegate().toUserJID as AnyObject as! String, messageContent: login! + " has joined.", messageType: "header", messageTime: time2, messageId: messageId, roomType: "trivia", messageSubType: "roomuseradd", mySupportTeam: 0, JoindUserName: login!)
            }
            else{
                let login: String? = UserDefaults.standard.string(forKey: "triviauser")
                self.appDelegate().sendMessageToServer(self.appDelegate().toUserJID as AnyObject as! String, messageContent: login! + " has joined.", messageType: "header", messageTime: time2, messageId: messageId, roomType: "trivia", messageSubType: "roomuseradd", mySupportTeam: 0, JoindUserName: login!)
            }
            
           
            if(self.appDelegate().arrAllChats.count > 0)
            {
                if let dt = self.appDelegate().arrAllChats[self.appDelegate().toUserJID]
                {
                    // self.appDelegate().arrUserChat = dt["Chats"] as! [AnyObject]
                    let sortedArray = (dt["Chats"] as! [[String:Any]]).sorted(by: { (dictOne, dictTwo) -> Bool in
                        let date1 =  dictOne
                        let date2 =  dictTwo
                        var dt1: Date = Date()
                        var dt2: Date = Date()
                        
                        if date1["time"] != nil
                        {
                            // print(date1["lastDate"] as AnyObject)
                            let mili1: Double = Double(truncating: (date1["time"] as AnyObject) as! NSNumber) //(date1["lastTime"] as! NSString).doubleValue //Double((val1 as AnyObject) as! NSNumber)
                            let myMilliseconds1: UnixTime = UnixTime(mili1/1000.0)
                            dt1 = myMilliseconds1.dateFull
                            // print("Date1: " + dt1.description)
                        }
                        
                        if date2["time"] != nil
                        {
                            let mili2: Double = Double(truncating: (date2["time"] as AnyObject) as! NSNumber) //(date2["lastTime"] as! NSString).doubleValue
                            let myMilliseconds2: UnixTime = UnixTime(mili2/1000.0)
                            dt2 = myMilliseconds2.dateFull
                            //print("Date2: " + dt2.description)
                        }
                        
                        
                        
                        return dt1.compare(dt2) == ComparisonResult.orderedAscending
                    })
                    self.appDelegate().arrUserChat = sortedArray as [AnyObject]
                    /* for arr in sortedArray
                     {
                     //print(arr.key)
                     //arrAllChats[arr.key] = arr.value
                     //dictAllChats.setValue(arr.value, forUndefinedKey: arr.key as! String)
                     //dictAllChats.setValue(arr.value, forKey: arr.key)
                     //dictAllChats.setValue(arr.value, forKey: arr.key as! String)
                     var tmpDict = arr
                     
                     self.appDelegate().arrUserChat.append(tmpDict as AnyObject)
                     }*/
                    //New code to manage read badge counts
                    var tmpArrChatDetails = [String : AnyObject]()
                    
                    tmpArrChatDetails = dt as! [String : AnyObject]
                    //tmpArrChatDetails["Chats"] = dt["Chats"] as AnyObject
                    //tmpArrChatDetails["userName"] = dt["userName"] as AnyObject
                    //tmpArrChatDetails["userAvatar"] = dt["userAvatar"] as AnyObject
                    tmpArrChatDetails["badgeCounts"] = 0 as AnyObject
                    //tmpArrChatDetails["lastMessage"] = dt["lastMessage"] as AnyObject
                    //tmpArrChatDetails["lastTime"] = dt["lastTime"] as AnyObject
                    self.appDelegate().isJoined = tmpArrChatDetails["isJoined"]! as AnyObject as! String
                    //Temp fix
                    if tmpArrChatDetails["isAdmin"] != nil
                    {
                        self.appDelegate().isAdmin = tmpArrChatDetails["isAdmin"]! as AnyObject as! String
                    }
                    else
                    {
                        self.appDelegate().isAdmin = "no"
                    }
                    if tmpArrChatDetails["isHistory"] != nil
                    {
                        self.appDelegate().isgetHistory = tmpArrChatDetails["isHistory"]! as AnyObject as! Bool
                    }
                    else
                    {
                        self.appDelegate().isgetHistory = true
                    }
                    
                    self.appDelegate().arrAllChats[self.appDelegate().toUserJID] = tmpArrChatDetails as AnyObject
                    
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
                        print(error.localizedDescription)
                    }
                    //End
                    
                    
                    //New code to send read receipt
                    //We have recevied message from user so he will always To for me
                    if(self.appDelegate().curRoomType == "chat")
                    {
                        let dataToRead: [AnyObject] = self.appDelegate().arrUserChat.filter({ (text) -> Bool in
                            let tmp: NSDictionary = text as! NSDictionary
                            let status: String = tmp.value(forKey: "status") as! String
                            let isIncoming: String = tmp.value(forKey: "isIncoming") as! String
                            if(isIncoming == "YES" && status == "received")
                            {
                                return true
                            }
                            else
                            {
                                return false
                            }
                            
                        })
                        
                        for dict in dataToRead
                        {
                            let msgDict: [String: AnyObject] = dict as! [String: AnyObject]
                            self.appDelegate().funSendMessageReceived(messageTo: msgDict["toUserJID"] as! String, messageFrom: msgDict["fromUserJID"] as! String, messageId: msgDict["messageId"] as! String)
                            self.appDelegate().funGetSetLocalChats(messageId: msgDict["messageId"] as! String, chatStatus: "read")
                            
                        }
                    }
                    
                    //End
                    
                    //End
                    // self.isAutoScroll = true
                    self.storyTableView?.reloadData()
                    //storyTableView?.reloadData()
                    //self.scrollToBottom()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        //if(self.appDelegate().isSendingMedia)
                        //{
                        //self.scrollToBottom()
                        //}
                      /*  if(self.appDelegate().isgetHistory){
                                       self.historyIndex = 0
                                       self.funGetSetChat()
                                       }*/
                    }
                    
                    self.isAutoScroll = true
                }
                else{
                     self.appDelegate().arrUserChat = []
                    let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                    if(!istriviauser){
                        let login: String? = UserDefaults.standard.string(forKey: "userJID")
                        self.appDelegate().prepareMessageForServerIn(self.appDelegate().toUserJID, messageContent: "You have joined", messageType: "header", messageTime: time2, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: login!, isIncoming: "YES", chatType: "trivia", recBanterNickName: "", banterRoomName: self.appDelegate().toName, isJoined: "no", isAdmin: "no", supportedTeam: 0, opponentTeam: 0, mySupportTeam : 0,fansCount:1)
                    }
                    else{
                        let login: String? = UserDefaults.standard.string(forKey: "triviauser")
                        self.appDelegate().prepareMessageForServerIn(self.appDelegate().toUserJID, messageContent: "You have joined", messageType: "header", messageTime: time2, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: login!, isIncoming: "YES", chatType: "trivia", recBanterNickName: "", banterRoomName: self.appDelegate().toName, isJoined: "no", isAdmin: "no", supportedTeam: 0, opponentTeam: 0, mySupportTeam : 0,fansCount:1)
                    }
                }
               
            }
            else
            {
                self.appDelegate().arrUserChat = []
                let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                if(!istriviauser){
                    let login: String? = UserDefaults.standard.string(forKey: "userJID")
                    self.appDelegate().prepareMessageForServerIn(self.appDelegate().toUserJID, messageContent: "You have joined", messageType: "header", messageTime: time2, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: login!, isIncoming: "YES", chatType: "trivia", recBanterNickName: "", banterRoomName: self.appDelegate().toName, isJoined: "no", isAdmin: "no", supportedTeam: 0, opponentTeam: 0, mySupportTeam : 0,fansCount:1)
                }
                else{
                    let login: String? = UserDefaults.standard.string(forKey: "triviauser")
                    self.appDelegate().prepareMessageForServerIn(self.appDelegate().toUserJID, messageContent: "You have joined", messageType: "header", messageTime: time2, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: login!, isIncoming: "YES", chatType: "trivia", recBanterNickName: "", banterRoomName: self.appDelegate().toName, isJoined: "no", isAdmin: "no", supportedTeam: 0, opponentTeam: 0, mySupportTeam : 0,fansCount:1)
                }
                //let message = "No Chats found."
                // alertWithTitle(title: "Error", message: message, ViewController: self)
            }
        }
        }
    }
    @objc func isUserOnline()
    {
        DispatchQueue.main.async {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
               
                    if ClassReachability.isConnectedToNetwork() {
                        
                        if(self.appDelegate().isUserOnline)
                        {
                            self.roomJoin()
                            // LoadingIndicatorView.hide()
                            // self.parent?.title = "Banter Rooms"
                           // self.parent?.title = "Banter"
                            self.ConectingHightConstraint.constant = CGFloat(0.0)
                        }
                        else
                        {
                           
                               // self.Connectinglabel?.text = "Connecting..."
                                self.ConectingHightConstraint.constant = CGFloat(0.0)
                            
                            
                        }
                        
                        
                    } else {
                        
                        TransperentLoadingIndicatorView.hide()
                        self.Connectinglabel?.text = "Waiting for network..."
                       self.ConectingHightConstraint.constant = CGFloat(20.0)
                        //  }
                        //self.parent?.title = "Waiting for network.."
                        
                    }
               
            }
            else{
                if ClassReachability.isConnectedToNetwork() {
                    self.roomJoin()
                   // self.Connectinglabel?.text = "Connecting..."
                    self.ConectingHightConstraint.constant = CGFloat(0.0)
                }else{
                    self.Connectinglabel?.text = "Waiting for network..."
                    self.ConectingHightConstraint.constant = CGFloat(20.0)
                }
                // ConectingHightConstraint.constant = CGFloat(0.0)
            }
        }
    }
   
   
    @objc func messageReceivedFromServer()
    {
        //if (!isMultiSelection) {
        DispatchQueue.main.async {
            //print(appDelegate().arrAllChats)
            //print(appDelegate().toUserJID)
            if(self.appDelegate().arrAllChats.count > 0)
            {
                //self.appDelegate().arrUserChat = dt["Chats"] as! [AnyObject]
                if let dt = self.appDelegate().arrAllChats[self.appDelegate().toUserJID]
                { var tmpArrChatDetails = [String : AnyObject]()
                    
                    tmpArrChatDetails = dt as! [String : AnyObject]
                    //tmpArrChatDetails["Chats"] = dt["Chats"] as AnyObject
                    //tmpArrChatDetails["userName"] = dt["userName"] as AnyObject
                    //tmpArrChatDetails["userAvatar"] = dt["userAvatar"] as AnyObject
                    // tmpArrChatDetails["badgeCounts"] = 0 as AnyObject
                    //tmpArrChatDetails["lastMessage"] = dt["lastMessage"] as AnyObject
                    //tmpArrChatDetails["lastTime"] = dt["lastTime"] as AnyObject
                    self.appDelegate().isJoined = tmpArrChatDetails["isJoined"]! as AnyObject as! String
                    //Temp fix
                    if tmpArrChatDetails["isAdmin"] != nil
                    {
                        self.appDelegate().isAdmin = tmpArrChatDetails["isAdmin"]! as AnyObject as! String
                    }
                    else
                    {
                        self.appDelegate().isAdmin = "no"
                    }
                    let sortedArray = (dt["Chats"] as! [[String:Any]]).sorted(by: { (dictOne, dictTwo) -> Bool in
                        let date1 =  dictOne
                        let date2 =  dictTwo
                        var dt1: Date = Date()
                        var dt2: Date = Date()
                        
                        if date1["time"] != nil
                        {
                            // print(date1["lastDate"] as AnyObject)
                            let mili1: Double = Double(truncating: (date1["time"] as AnyObject) as! NSNumber) //(date1["lastTime"] as! NSString).doubleValue //Double((val1 as AnyObject) as! NSNumber)
                            let myMilliseconds1: UnixTime = UnixTime(mili1/1000.0)
                            dt1 = myMilliseconds1.dateFull
                            //print("Date1: " + dt1.description)
                        }
                        
                        if date2["time"] != nil
                        {
                            let mili2: Double = Double(truncating: (date2["time"] as AnyObject) as! NSNumber) //(date2["lastTime"] as! NSString).doubleValue
                            let myMilliseconds2: UnixTime = UnixTime(mili2/1000.0)
                            dt2 = myMilliseconds2.dateFull
                            //print("Date2: " + dt2.description)
                        }
                        
                        
                        
                        return dt1.compare(dt2) == ComparisonResult.orderedAscending
                    })
                    self.appDelegate().arrUserChat = sortedArray as [AnyObject]
                    
                    //storyTableView?.reloadData()
                }
                else
                {
                    self.appDelegate().arrUserChat = []
                }
            }
            
            /*if(self.appDelegate().isOnChatView)
             {
             //New code to send read receipt
             //We have recevied message from user so he will always To for me
             
             let dataToRead: NSMutableArray = appDelegate().arrUserChat.filter({ (text) -> Bool in
             let tmp: NSDictionary = text as! NSDictionary
             let status: String = tmp.value(forKey: "status") as! String
             let isIncoming: String = tmp.value(forKey: "isIncoming") as! String
             if(isIncoming == "YES" && status == "received")
             {
             return true
             }
             else
             {
             return false
             }
             
             }) as! NSMutableArray
             
             for dict in dataToRead
             {
             let msgDict: [String: AnyObject] = dict as! [String: AnyObject]
             self.appDelegate().funSendMessageReceived(messageTo: msgDict["toUserJID"] as! String, messageFrom: msgDict["fromUserJID"] as! String, messageId: msgDict["messageId"] as! String)
             self.appDelegate().funGetSetLocalChats(messageId: msgDict["messageId"] as! String, chatStatus: "read", recReadUserJid: msgDict["toUserJID"] as! String)
             
             }
             
             
             
             
             //End
             
             }*/
            
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {F
             self.storyTableView?.reloadData()
             }*/
            
            
            //storyTableView?.layoutIfNeeded()
            //self.scrollToBottom()
            self.isAutoScroll = true
            self.storyTableView?.reloadData()
            
            //self.scrollToBottom()
            /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             //if(self.appDelegate().isSendingMedia)
             //{
             self.scrollToBottom()
             //}
             }*/
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //if(self.appDelegate().isSendingMedia)
            //{
            //self.scrollToBottom()
            //}
          /*  if(self.appDelegate().curRoomType == "group")
            {
                
                if(self.appDelegate().isBanterClosed == "closed")
                {
                    //self.isAutoScroll = true
                    
                    self.btnPicker?.isHidden = true
                    self.btnCamera?.isHidden = true
                    self.messageBox.isHidden = true
                    self.btnJoinBanter?.isHidden = true
                    
                }
                else
                {
                    if(self.appDelegate().curRoomType == "banter" && self.appDelegate().isJoined == "yes")
                    {
                        if(self.appDelegate().isAdmin == "yes")
                        {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.leaveBanterRoom))
                        }
                        else
                        {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.leaveBanterRoom))
                        }
                    }
                        
                    else if(self.appDelegate().curRoomType == "group" && self.appDelegate().isJoined == "yes"){
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.leaveBanterRoom))
                        self.supportedTeam = 0
                        self.opponentTeam = 0
                        self.btnPicker?.isHidden = false
                        self.btnCamera?.isHidden = false
                        self.messageBox.isHidden = false
                        self.btnJoinBanter?.isHidden = true//
                    }
                        
                    else if(self.appDelegate().curRoomType == "group" && self.appDelegate().isJoined == "blocked" || self.appDelegate().isJoined == "no")
                    {
                       // self.btnPicker?.isHidden = true
                        self.btnCamera?.isHidden = true
                        self.messageBox.isHidden = true
                       // self.btnJoinBanter?.isHidden = true
                       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.chatmenu))
                    }
                    
                    /*var dictRequest = [String: AnyObject]()
                     dictRequest["cmd"] = "getbanterroomusers" as AnyObject
                     
                     //Creating Request Datap
                     var dictRequestData = [String: AnyObject]()
                     
                     dictRequestData["roomid"] = appDelegate().toUserJID as AnyObject
                     dictRequest["requestData"] = dictRequestData as AnyObject
                     //dictRequest.setValue(dictMobiles, forKey: "requestData")
                     //print(dictRequest)
                     do {
                     let dataMyTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                     let strMyTeams = NSString(data: dataMyTeams, encoding: String.Encoding.utf8.rawValue)! as String
                     print(strMyTeams)
                     appDelegate().sendRequestToAPI(strRequestDict: strMyTeams)
                     } catch {
                     print(error.localizedDescription)
                     }*/
                    
                    
                    
                    
                    self.appDelegate().isUpdatesLoaded = false
                    
                    
                    
                    
                    
                    
                    
                    //storyTableView?.layoutSubviews()
                    //storyTableView?.layoutIfNeeded()
                    //self.scrollToBottom()
                }
            }*/
            //if(self.appDelegate().curRoomType == "chat")
        }
        
        //}
        
    }
    @IBAction func close(_ sender: UIButton) {
        //postLike()
        navigationController?.isNavigationBarHidden = false
        player.pause()
        player = AVPlayer()
        stopTimerTest()
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func historyFail()
    {
        TransperentLoadingIndicatorView.hide()
        appDelegate().isApplyHistory = false
        // self.storyTableView?.isScrollEnabled = true
        // storyTableView?.reloadData()
    }
    
    @objc func messageReceivedFromHistory()
    {
        //if (!isMultiSelection) {
        DispatchQueue.main.async {
            //print(appDelegate().arrAllChats)
            //print(appDelegate().toUserJID)
            if(self.appDelegate().arrAllChats.count > 0)
            {
                //self.appDelegate().arrUserChat = dt["Chats"] as! [AnyObject]
                if let dt = self.appDelegate().arrAllChats[self.appDelegate().toUserJID]
                { var tmpArrChatDetails = [String : AnyObject]()
                    
                    tmpArrChatDetails = dt as! [String : AnyObject]
                    //tmpArrChatDetails["Chats"] = dt["Chats"] as AnyObject
                    //tmpArrChatDetails["userName"] = dt["userName"] as AnyObject
                    //tmpArrChatDetails["userAvatar"] = dt["userAvatar"] as AnyObject
                    // tmpArrChatDetails["badgeCounts"] = 0 as AnyObject
                    //tmpArrChatDetails["lastMessage"] = dt["lastMessage"] as AnyObject
                    //tmpArrChatDetails["lastTime"] = dt["lastTime"] as AnyObject
                    self.appDelegate().isJoined = tmpArrChatDetails["isJoined"]! as AnyObject as! String
                    //Temp fix
                    if tmpArrChatDetails["isAdmin"] != nil
                    {
                        self.appDelegate().isAdmin = tmpArrChatDetails["isAdmin"]! as AnyObject as! String
                    }
                    else
                    {
                        self.appDelegate().isAdmin = "no"
                    }
                    let sortedArray = (dt["Chats"] as! [[String:Any]]).sorted(by: { (dictOne, dictTwo) -> Bool in
                        let date1 =  dictOne
                        let date2 =  dictTwo
                        var dt1: Date = Date()
                        var dt2: Date = Date()
                        
                        if date1["time"] != nil
                        {
                            // print(date1["lastDate"] as AnyObject)
                            let mili1: Double = Double(truncating: (date1["time"] as AnyObject) as! NSNumber) //(date1["lastTime"] as! NSString).doubleValue //Double((val1 as AnyObject) as! NSNumber)
                            let myMilliseconds1: UnixTime = UnixTime(mili1/1000.0)
                            dt1 = myMilliseconds1.dateFull
                            // print("Date1: " + dt1.description)
                        }
                        
                        if date2["time"] != nil
                        {
                            let mili2: Double = Double(truncating: (date2["time"] as AnyObject) as! NSNumber) //(date2["lastTime"] as! NSString).doubleValue
                            let myMilliseconds2: UnixTime = UnixTime(mili2/1000.0)
                            dt2 = myMilliseconds2.dateFull
                            //print("Date2: " + dt2.description)
                        }
                        
                        
                        
                        return dt1.compare(dt2) == ComparisonResult.orderedAscending
                    })
                    self.appDelegate().arrUserChat = sortedArray as [AnyObject]
                    
                    //storyTableView?.reloadData()
                }
                else
                {
                    self.appDelegate().arrUserChat = []
                }
            }
            
            /*if(self.appDelegate().isOnChatView)
             {
             //New code to send read receipt
             //We have recevied message from user so he will always To for me
             
             let dataToRead: NSMutableArray = appDelegate().arrUserChat.filter({ (text) -> Bool in
             let tmp: NSDictionary = text as! NSDictionary
             let status: String = tmp.value(forKey: "status") as! String
             let isIncoming: String = tmp.value(forKey: "isIncoming") as! String
             if(isIncoming == "YES" && status == "received")
             {
             return true
             }
             else
             {
             return false
             }
             
             }) as! NSMutableArray
             
             for dict in dataToRead
             {
             let msgDict: [String: AnyObject] = dict as! [String: AnyObject]
             self.appDelegate().funSendMessageReceived(messageTo: msgDict["toUserJID"] as! String, messageFrom: msgDict["fromUserJID"] as! String, messageId: msgDict["messageId"] as! String)
             self.appDelegate().funGetSetLocalChats(messageId: msgDict["messageId"] as! String, chatStatus: "read", recReadUserJid: msgDict["toUserJID"] as! String)
             
             }
             
             
             
             
             //End
             
             }*/
            
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {F
             self.storyTableView?.reloadData()
             }*/
            
            
            //storyTableView?.layoutIfNeeded()
            //self.scrollToBottom()
            //self.isAutoScroll = false
            self.storyTableView?.reloadData()
            if(self.historyIndex == 0){
                self.isAutoScroll = true
            }
            
            //self.scrollToBottom()
            /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             //if(self.appDelegate().isSendingMedia)
             //{
             self.scrollToBottom()
             //}
             }*/
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //if(self.appDelegate().isSendingMedia)
            //{
            //self.scrollToBottom()
            //}
            // self.storyTableView?.isScrollEnabled = true
            if(self.historyIndex == 0){
                //self.isAutoScroll = true
            }
            else{
                self.historyIndex = self.historyIndex + 1
                if(self.appDelegate().arrUserChat.count > 0)
                {
                    //print(self.historyIndex)
                    //print(self.appDelegate().arrUserChat.count)
                    //let myindex = self.appDelegate().arrUserChat.count - self.historyIndex
                    let indexPath = IndexPath(row: self.historyIndex - 1 , section: 0)
                    //self.storyTableView?.selectRow(at: indexPath , animated: false, scrollPosition: .bottom)
                    //self.storyTableView?.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    
                    self.storyTableView?.scrollToRow(at: indexPath, at: .top, animated: false)
                    // }
                }
            }
            TransperentLoadingIndicatorView.hide()
            
            //if(self.appDelegate().curRoomType == "chat")
        }
        //LoadingIndicatorView.hide()
        //}
        //isApplyHistory = true
        
    }
    func funGetSetChat()
    {
        // self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        // self.activityIndicator?.startAnimating()
        // self.storyTableView?.isScrollEnabled = false
        if(appDelegate().lastcreateroom != appDelegate().toUserJID){
            if(appDelegate().isUserOnline == true && self.currentReachabilityStatus != .notReachable  ){
               // LoadingIndicatorView.show((appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while loading Messages")
                
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "getchathistory" as AnyObject
                
                
                do {
                    
                    /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                     let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                     print(strInvited)*/
                    //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                    //let arrReadUserJid = login?.components(separatedBy: "@")
                    //let userReadUserJid = arrReadUserJid?[0]
                    
                    
                    //Creating Request Data
                    var dictRequestData = [String: AnyObject]()
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    
                    let myjidtrim: String? = userUserJid
                    let roomjid: String? = appDelegate().toUserJID
                    let arrroomjid = roomjid?.components(separatedBy: "@")
                    let room = arrroomjid?[0]
                    
                    let roomjidtrim: String? = room
                    var time: Int64 = appDelegate().getUTCFormateDate()
                    var messageId: String = ""
                    if(self.appDelegate().arrUserChat.count > 0){
                        let message: NSDictionary = self.appDelegate().arrUserChat[0] as! NSDictionary
                        
                        // let isIncoming: String = message.value(forKey: "isIncoming") as! String
                        messageId = message.value(forKey: "messageId") as! String
                        
                        // print("\(indexPath.row) \(message.value(forKey: "status") as! String)")
                        
                        if let mili = message.value(forKey: "time")
                        {
                            time = mili as! Int64
                        }
                    }
                    
                    dictRequestData["time"] = time as AnyObject
                    dictRequestData["to"] = roomjidtrim as AnyObject
                    dictRequestData["from"] = myjidtrim as AnyObject
                    dictRequestData["messageid"] = messageId as AnyObject
                    dictRequestData["chattype"] = appDelegate().curRoomType as AnyObject
                    dictRequest["requestData"] = dictRequestData as AnyObject
                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                    // print(dictRequest)
                    
                    let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                    // historyIndex = 0
                    appDelegate().isApplyHistory = false
                    // print(strFanUpdates)
                    self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
     func sendMessage () {
        
        // messageBox?.endEditing(true)
        //NSDictionary *Dictmessage=[[NSDictionary alloc]initWithObjectsAndKeys:[self.xmppStream myJID].bare,@"username",jid,@"jid",Type,@"message",Type,@"messagetype",name,@"name",@"sending",@"status",messageid,@"messageid",time,@"time",@"NO",@"isincoming",[results objectForKey:@"link"],@"filepath",@"NO",@"isfile",@"",@"filetype",@"",@"filename",@"",@"caption",@"",@"latitude",@"",@"longitude", nil];
        //appDelegate().toUserJID = "+919826615203@amazomcdn.com"
        
        // if(isSendMessage)
        //{
        if(messageBox.text != "Answer here..."){
        if(!(messageBox.text?.isEmpty)!) //Sending Text
        {
            if(!appDelegate().toUserJID.isEmpty)
            {
                var newBanterNickName: String = ""
                if(self.appDelegate().curRoomType == "banter")
                {
                    //Generate unique name
                    let banternick: String? = UserDefaults.standard.string(forKey: "banterNickName")
                    if banternick != nil
                    {
                        newBanterNickName = banternick!
                    }
                    
                }
                
                //If Internet connected
                //print(appDelegate().isOnline)
                //  print(appDelegate().mySupportedTeam)
                if(currentReachabilityStatus != .notReachable && appDelegate().isUserOnline == true)
                {
                    let uuid = UUID().uuidString
                    let time: Int64 = appDelegate().getUTCFormateDate()
                    //print(time)
                    let trimMessage: String = messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    //var name : String = "GALERIA DOMINIKAŃSKA"
                    messageBox.resignFirstResponder()
                    //let encMessage: String = self.appDelegate().msgEncode(trimMessage)
                    if(trimMessage != ""){
                        self.appDelegate().prepareMessageForServerOut(self.appDelegate().toUserJID, messageContent: trimMessage, chatType: self.appDelegate().curRoomType, messageType: "text", messageTime: time, messageId: uuid, chatStatus: "sent", newBanterNickName: newBanterNickName, mySupportedTeam: appDelegate().mySupportedTeam)
                        // print(appDelegate().toUserJID)
                        appDelegate().sendMessageToServer(appDelegate().toUserJID, messageContent: trimMessage, messageType: "text", messageTime: time, messageId: uuid, roomType: self.appDelegate().curRoomType, mySupportTeam: appDelegate().mySupportedTeam)
                        
                        
                        
                        //print(appDelegate().arrUserChat)
                        messageBox.text = "Answer here..."
                        self.isAutoScroll = true
                        // self.massageBoXHightConstraint.constant = CGFloat(30.0)
                        // self.coustumBorderHightConstraint.constant = CGFloat(40.0)
                        storyTableView?.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            //if(self.appDelegate().isSendingMedia)
                            //{
                            //self.scrollToBottom()
                            //}
                            // self.isAutoScroll = true
                            //self.storyTableView?.reloadData()
                            //self.scrollToBottom()
                            if(self.appDelegate().curRoomType == "banter"){
                                if(self.appDelegate().ActivityPermissionCheck(massegeId: 0, Type: ThisIsBanter)){
                                    self.appDelegate().ActivityCountManage()
                                }
                                
                            }
                            else if(self.appDelegate().curRoomType == "group"){
                                if(self.appDelegate().ActivityPermissionCheck(massegeId: 0, Type: ThisIsGroup)){
                                    self.appDelegate().ActivityCountManage()
                                }
                            }
                            
                        }
                        //storyTableView?.layoutIfNeeded()
                        /********DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                         self.scrollToBottom()
                         }*/
                        ////////self.scrollToBottom()
                        //isAutoScroll = true
                        isSendMessage = true
                        let imgMsg: UIImage = UIImage(named: "send_gray")!
                        btnCamera?.setImage(imgMsg, for: UIControl.State.normal)
                        
                    }
                }
               // else
                
                
                
            }
            iskeybordHide = true
        }
        }
        /* }
         else
         {
         messageBox?.endEditing(true)
         let notified: String? = UserDefaults.standard.string(forKey: "notifiedcamera")
         if notified == nil
         {
         //Show notify before get permissions
         let popController: NotifyPermissionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Notify") as! NotifyPermissionController
         
         // set the presentation style
         popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         //popController.modalPresentationStyle = .popover
         popController.modalTransitionStyle = .crossDissolve
         
         // set up the popover presentation controller
         popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
         popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
         popController.popoverPresentationController?.sourceView = self.view // button
         //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
         popController.notifyType = "camera"
         // present the popover
         self.present(popController, animated: true, completion: nil)
         }
         else
         {
         /*let picker = NohanaImagePickerController.init(assetCollectionSubtypes: [PHAssetCollectionSubtype.any], mediaType: MediaType.any, enableExpandingPhotoAnimation: true)
         picker.delegate = self
         picker.toolbarHidden = true
         picker.isShowCamera = true
         picker.navigationController?.isNavigationBarHidden = true
         present(picker, animated: true, completion: nil)*/
         
         /*  AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
         if response {
         //access granted
         let picker = NohanaImagePickerController.init(assetCollectionSubtypes: [PHAssetCollectionSubtype.any], mediaType: MediaType.any, enableExpandingPhotoAnimation: true)
         picker.delegate = self
         picker.toolbarHidden = true
         picker.isShowCamera = true
         picker.navigationController?.isNavigationBarHidden = true
         self.present(picker, animated: true, completion: nil)
         } else {
         self.displayCameraSettingsAlert()
         }
         }*/
         }
         }*/
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.appDelegate().arrUserChat.count
        //return (appDelegate().allAppContacts.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:triviaCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! triviaCell
      //  if(!isMultiSelection && !isMultiSelectionbyForward){
            if(appDelegate().isgetHistory){
                if(appDelegate().isApplyHistory){
                    if(indexPath.row == 0){
                        /*if(appDelegate().curRoomType == "group" && appDelegate().isJoined == "yes"){
                         funGetSetChat()
                         }
                         else{
                         funGetSetChat()
                         }*/
                        historyIndex = 1
                        funGetSetChat()
                    }
                }
            }
      //  }
        
        
        //Code for banter room only
        /*if(self.appDelegate().chatType == "banter")
         {
         let roomJID = XMPPJID(string: self.appDelegate().toUserJID)
         let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
         
         let room = XMPPRoom(roomStorage: roomStorage, jid: roomJID, dispatchQueue: DispatchQueue.main)!
         
         room.activate(self.appDelegate().xmppStream)
         
         room.addDelegate(self, delegateQueue: DispatchQueue.main)
         
         if(room.isJoined)
         {
         print("Joined")
         }
         else
         {
         print("Not Joined")
         }
         //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
         
         //let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
         //history.addAttribute(withName: "maxchars", stringValue: "0")
         
         //let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
         //history.addAttribute(withName: "maxchars", stringValue: "0")
         
         //room.join(usingNickname: myJID, history: history)
         }*/
        
        //let chatBubbleL: ChatBubbleLeft = ChatBubbleLeft(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        //cell.chatBubble = chatBubbleL
        //chatBubbleL.chatMessage?.text = "This message is only for test2. This message is only for test. This message is only for test."
        
        //let chatBubbleL: ChatBubbleLeft = ChatBubbleLeft(baseView: cell.chatBubble!, text: "Yay! Bark! Yay! Bark!", fontSize: 16.0)
        //cell.chatBubble?.addSubview(chatBubbleL)
        
        /*let foo = UIImage(named: "bubble_out") // 328 x 328
         let fooWithInsets = foo?.resizableImageWithStretchingProperties(
         X: 0.48, width: 0, Y: 0.45, height: 0) ?? UIImage()
         
         let imageView = UIImageView(image: fooWithInsets)
         imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
         
         cell.chatBubble?.addSubview(imageView)*/
      
        if(appDelegate().arrUserChat.count>0){
            
            let message: NSDictionary = self.appDelegate().arrUserChat[indexPath.row] as! NSDictionary
            
            let isIncoming: String = message.value(forKey: "isIncoming") as! String
            var userjid: String = ""
            let userName: String = message.value(forKey: "userName") as! String
            if(userName == nil || userName == ""){
                let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                if(!istriviauser){
                    
                 let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                userjid = userUserJid!
                }else{
                    let myjid: String? = UserDefaults.standard.string(forKey: "triviauser")
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    userjid = userUserJid!
                }
            }else{
                userjid = userName
            }
            // print("\(indexPath.row) \(message.value(forKey: "status") as! String)")
            var msgtime = ""
            if let mili = message.value(forKey: "time")
            {
                let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                let dateFormatter = DateFormatter()
                //dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
                //dateFormatter.dateStyle = .short
                dateFormatter.dateFormat = "dd MMM yy HH:mm"
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
            
           
                
                let messageType = message.value(forKey: "messageType") as! String
               // let caption = message.value(forKey: "caption") as! String
                //let chatStatus = message.value(forKey: "status") as! String
               // let mysupportteam = message.value(forKey: "supportteam") as! Int
                var messageSubType = ""
                if let isOppTeam = message.value(forKey: "sub_type")
                {
                    if(isOppTeam != nil)
                    {
                        messageSubType = isOppTeam as! String
                    }
                }
               
                 if(messageType == "header")
                {
                    cell.messagesview?.isHidden = true
                    cell.headerview?.isHidden = false
                    cell.header?.text = message.value(forKey: "messageContent") as? String
                }
                else
                {
                    cell.messagesview?.isHidden = false
                    cell.headerview?.isHidden = true
                  cell.username?.text = appDelegate().ExistingContact(username: userjid)
                    cell.message?.text = message.value(forKey: "messageContent") as? String
                    let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.message?.frame.width)! , height: CGFloat.greatestFiniteMagnitude))
                    label.font = UIFont.systemFont(ofSize: 17.0)
                    label.textAlignment = .left
                    label.text = message.value(forKey: "messageContent") as? String
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 0
                    label.sizeToFit()
                    if((label.frame.height) > 17)
                    {
                        let height = (label.frame.height) + 31
                        cell.messagesviewHightConstraint.constant = height
                         cell.messagesHightConstraint.constant = label.frame.height
                        // cell.mainViewConstraint.constant = CGFloat(height)
                        //print("Height \(height).")
                        //storyTableView?.rowHeight = CGFloat(height)
                       
                    }
                    else
                    {
                        let height = 40
                        cell.messagesviewHightConstraint.constant = CGFloat(height)
                        cell.messagesHightConstraint.constant = 20
                        // cell.mainViewConstraint.constant = CGFloat(height)
                        //print("Height \(height).")
                        // storyTableView?.rowHeight = CGFloat(height)
                      
                    }
                    
                }
           
            
           
            /*if(indexPath.row == 0)
             {
             storyTableView?.rowHeight = chatBubbleL.frame.height
             }
             else
             {
             storyTableView?.rowHeight = 44.0
             }*/
            
            
            //cell.chatMessage?.text = "This message is only for test and its changed."
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
        // cellHeights[indexPath] = cell.frame.size.height
        // lastindex = indexPath.row
        /*  if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
         // do here...
         //print("display cell")
         //
         //print(self.appDelegate().arrUserChat.count)
         if (indexPath == lastVisibleIndexPath && isAutoScroll) {
         // do here...
         self.scrollToBottom()
         if(indexPath.row == self.appDelegate().arrUserChat.count-1)
         {
         isAutoScroll = false
         //tableView.reloadData()
         }
         }
         }*/
        //}
        if(indexPath.row == self.appDelegate().arrUserChat.count-1)
        {
            isAutoScroll = false
            //print(isAutoScroll)
            //tableView.reloadData()
            appDelegate().isApplyHistory = true
        }
        if(isAutoScroll){
            //  print(isAutoScroll)
            self.scrollToBottom()
            /* if(indexPath.row == self.appDelegate().arrUserChat.count-1)
             {
             isAutoScroll = false
             //tableView.reloadData()
             }*/
        }
    }
   func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell:triviaCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! triviaCell
        
        let message: NSDictionary = self.appDelegate().arrUserChat[indexPath.row] as! NSDictionary
        
        // let isIncoming: String = message.value(forKey: "isIncoming") as! String
       // let userName: String = message.value(forKey: "userName") as! String
        
        // print("\(indexPath.row) \(message.value(forKey: "status") as! String)")
    
        
        // let message: NSDictionary = self.appDelegate().arrUserChat[indexPath.row] as! NSDictionary
        let messageType = message.value(forKey: "messageType") as! String
    
    if(messageType == "header")
    {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (cell.header?.frame.height)!))
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .left
        //label.textColor = self.strokeColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return 40
    }
    else
    {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.message?.frame.width)! , height: CGFloat.greatestFiniteMagnitude))
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .left
        label.text = message.value(forKey: "messageContent") as? String
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        if((label.frame.height) > 17)
        {
            let height = (label.frame.height) + 42
            // cell.mainViewConstraint.constant = CGFloat(height)
            //print("Height \(height).")
            //storyTableView?.rowHeight = CGFloat(height)
            return height
        }
        else
        {
            let height = 80
            // cell.mainViewConstraint.constant = CGFloat(height)
            //print("Height \(height).")
            // storyTableView?.rowHeight = CGFloat(height)
            return CGFloat(height)
        }
    }
       // return 80
    }
   /* func GetViewcount()  {
         if ClassReachability.isConnectedToNetwork() {
        var dictRequest = [String: AnyObject]()
         dictRequest["cmd"] = "gettriviacount" as AnyObject
         dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
         dictRequest["device"] = "ios" as AnyObject
         var reqParams = [String: AnyObject]()
         //reqParams["cmd"] = "getfanupdates" as AnyObject
        let arrdRoomJid = appDelegate().toUserJID.components(separatedBy: "@")
        let roomid = arrdRoomJid[0]
         reqParams["groupid"] = roomid as AnyObject
        
         reqParams["type"] = "viewcount" as AnyObject
         let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
         if(myjid != nil){
             let arrdUserJid = myjid?.components(separatedBy: "@")
             let userUserJid = arrdUserJid?[0]
             reqParams["username"] = userUserJid as AnyObject?
         }
         else{
             reqParams["username"] = "" as AnyObject
         }
         
         dictRequest["requestData"] = reqParams as AnyObject
         //dictRequest.setValue(dictMobiles, forKey: "requestData")
         //print(dictRequest)
         do {
            /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
             let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
             let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
             //  print(escapedString!)
             // print(strFanUpdates)
             var reqParams1 = [String: AnyObject]()
             reqParams1["request"] = strFanUpdates as AnyObject
             let url = MediaAPIjava + "request=" + escapedString!*/
             //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
             Alamofire.request(url, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                               headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                 // 2
                 .responseJSON { response in
                     //print(response.result.value)
                     if response.result.error == nil {
                         if let json = response.result.value as? Dictionary<String, Any>{
                             // print(" JSON:", json)
                             let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                             // self.finishSyncContacts()
                             //print(" status:", status1)
                             if(status1){
                                 let response: NSArray = json["responseData"]  as! NSArray
                                 let roomDetailsDict = response[0] as! [String : AnyObject]
                                 
                                let count = roomDetailsDict["viewcount"] as AnyObject
                                  let tabIndex:[String: Any] = ["index": count]
                                 let notificationName = Notification.Name("triviauseronline")
                                 NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
                             }
                             else{
                                 
                             }
                         }
                     } else {
                         debugPrint(response.result.error as Any)
                     }
             }
         } catch {
             print(error.localizedDescription)
         }
        }
        else {
           // TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }*/
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
               
           });
           
           alert.addAction(action1)
           self.present(alert, animated: true, completion:nil)
       }
    func scrollToBottom(){
        //DispatchQueue.global(qos: .background).async {
        DispatchQueue.main.async {
            
            
            
            /*let indexPath = IndexPath(row: self.appDelegate().arrUserChat.count-1, section: 0)
             self.storyTableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)*/
            if(self.appDelegate().arrUserChat.count > 0)
            {
                let tRows = (self.storyTableView?.numberOfRows(inSection: 0))! - 1
                //print(self.appDelegate().arrUserChat.count)
                //let indexPath = IndexPath(row: self.appDelegate().arrUserChat.count-1, section: 0)
                let indexPath = IndexPath(row: tRows , section: 0)
                //self.storyTableView?.selectRow(at: indexPath , animated: false, scrollPosition: .bottom)
                //self.storyTableView?.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                if(tRows > 0)
                {
                    self.storyTableView?.scrollToRow(at: indexPath, at: .none, animated: false)
                }
                
                
            }
            
            
            
            // let indexPath = IndexPath(row: self.appDelegate().arrUserChat.count-1, section: 0)
            
        }
        //tableViewScrollToBottom(true)
        
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            messageBox?.endEditing(true)
        }
        // scrollToBottom()
        sender.cancelsTouchesInView = false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 400
        
    }
    
 
    
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
     return true
     }
     
     //print("Returned")
     //print("Text did changed")
     let trimMessage: String = messageBox.text!//messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     //let trimMessage = messageBox.text!
     //messageBox.text = trimMessage
     if(!trimMessage.isEmpty)
     {
     isSendMessage = true
     let imgMsg: UIImage = UIImage(named: "send")!
     btnCamera?.setImage(imgMsg, for: UIControlState.normal)
     
     //New code to send composing event
     self.appDelegate().sendComposingChatToUser(messageTo: self.appDelegate().toUserJID)
     //End
     let layoutManager:NSLayoutManager = textView.layoutManager
     let numberOfGlyphs = layoutManager.numberOfGlyphs
     var numberOfLines = 0
     var index = 0
     var lineRange:NSRange = NSRange()
     
     while (index < numberOfGlyphs) {
     layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
     index = NSMaxRange(lineRange);
     numberOfLines = numberOfLines + 1
     }
     
     if(numberOfLines>=1 && numberOfLines<8){
     let changeConstant = numberOfLines * 15
     self.massageBoXHightConstraint.constant = CGFloat(changeConstant+30)
     self.coustumBorderHightConstraint.constant = CGFloat(changeConstant+40)
     messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
     }
     else if(numberOfLines>=8){
     let changeConstant = 8 * 15
     self.massageBoXHightConstraint.constant = CGFloat(changeConstant+30)
     self.coustumBorderHightConstraint.constant = CGFloat(changeConstant+40)
     messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
     
     }
     
     DispatchQueue.main.asyncAfter(deadline: .now()) {
     
     let range = NSMakeRange(trimMessage.lengthOfBytes(using: String.Encoding.utf8), 0)
     textView.scrollRangeToVisible(range)
     }
     
     
     }
     else
     {
     self.massageBoXHightConstraint.constant = CGFloat(30.0)
     self.coustumBorderHightConstraint.constant = CGFloat(40.0)
     isSendMessage = false
     let imgMsg: UIImage = UIImage(named: "camera")!
     btnCamera?.setImage(imgMsg, for: UIControlState.normal)
     textView.isScrollEnabled = false
     }
     
     /*if(trimMessage == UIPasteboard.general.string)
     {
     self.messageBox?.text = trimMessage + " "
     
     DispatchQueue.main.asyncAfter(deadline: .now()) {
     
     let range = NSMakeRange(trimMessage.lengthOfBytes(using: String.Encoding.utf8), 0)
     textView.scrollRangeToVisible(range)
     }
     
     
     }*/
     
     
     
     
     //textView.scrollRectToVisible(messageBox.frame, animated: true)
     
     messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
     
     return true
     }*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        
        sendMessage()
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // print("TextField did begin editing method called")
        if(messageBox.text == "Answer here..."){
            messageBox.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextField)
    {
        
        
        //print("Text did changed")
        let trimMessage: String = messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let trimMessage = messageBox.text!
        //messageBox.text = trimMessage
        if(!trimMessage.isEmpty)
        {
           // messageBox?.isScrollEnabled = true
            
            
            
        }
        else
        {
        }
        
        if(trimMessage == UIPasteboard.general.string)
        {
            //self.messageBox?.text = trimMessage + " "
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                let range = NSMakeRange(trimMessage.lengthOfBytes(using: String.Encoding.utf8), 0)
               // textView.scrollRangeToVisible(range)
            }
        }
        //print(messageBox?.text.characters.count)
       
        //messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
        //textView.scrollRectToVisible(messageBox.frame, animated: true)
        
    }
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        /*var userInfo = notification.userInfo!
         var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
         keyboardFrame = self.view.convert(keyboardFrame, from: nil)
         
         var contentInset:UIEdgeInsets = self.storyToolbar?. //.contentInset
         contentInset.bottom = keyboardFrame.size.height
         self.storyToolbar.contentInset = contentInset*/
        //adjustingHeight(show: true, notification: notification)
        //Working Very good
        //animateViewMoving(up: true, moveValue: 200)
        
        isKeyboardHiding = false
        self.storyTableView?.allowsSelection = false
        //scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        /*let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         self.storyToolbar.contentInset = contentInset*/
        isKeyboardHiding = true
        adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        
        
    }
    @objc func UIKeyboardDidHide(notification:NSNotification){
        self.storyTableView?.allowsSelection = true
    }
    
    
    
    @objc func keyboardDidChangeFrame(notification:NSNotification){
        if(isKeyboardHiding == false)
        {
            adjustingHeight(show: true, notification: notification)
        }
        //isKeyboardHiding = false
        //self.scrollToBottom()
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        let userInfo = notification.userInfo!
        //print(userInfo)
        self.keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        if(isKeyboardHiding == true)
        {
            let trimMessage: String = messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //let trimMessage = messageBox.text!
            //messageBox.text = trimMessage
            if(trimMessage.isEmpty)
            {
                  messageBox.text = "Answer here..."
            }
            let changeInHeight = 0.0
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = CGFloat(changeInHeight)
                
            })
        }
        else
        {
            let changeInHeight = (self.keyboardFrame.height) //* (show ? 1 : -1)
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = changeInHeight
                
            })
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
            TriviaViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return TriviaViewController.realDelegate!;
    }
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) {
                                                            [weak self] time in
                                                            // update player transport UI
        }
    }
    
    func prepareToPlay() {
        // Create the asset to play
        asset = AVAsset(url: url)
        
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: requiredAssetKeys)
        
        // Register as an observer of the player item's status property
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        
        
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
        
        
        
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerview.layer.addSublayer(playerLayer)
        player.play()
        //player.automaticallyWaitsToMinimizeStalling = true
        //player.playImmediately(atRate: 0.1)
        //player.preventsDisplaySleepDuringVideoPlayback = true
        
        
        // Add observer for AVPlayer status and AVPlayerItem status
        /*playerLayer.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
         playerLayer.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)*/
        
        
        
        
        /* NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlay(_:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
         
         
         
         playerItem?.observe(\AVPlayerItem.status, changeHandler: { observedPlayerItem, change in
         if (observedPlayerItem.status == AVPlayerItem.Status.readyToPlay) {
         print("Current stream duration \(observedPlayerItem.duration.seconds)")
         }
         })*///
        
        //let timeScale = CMTimeScale(NSEC_PER_SEC)
        //let time = CMTime(seconds: 3.0, preferredTimescale: timeScale)
        
        
    }
    
    
    // Observe If AVPlayerItem.status Changed to Fail
    /*override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
     if ((object as? AVPlayer) != nil) && keyPath == #keyPath(AVPlayer.currentItem.status) {
     let newStatus: AVPlayerItem.Status
     if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
     newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
     } else {
     newStatus = .unknown
     }
     if newStatus == .failed {
     NSLog("Error: \(String(describing: self.player?.currentItem?.error?.localizedDescription)), error: \(String(describing: self.player?.currentItem?.error))")
     }
     }
     }*/
    
    /*@objc func playerItemFailedToPlay(_ notification: Notification) {
     let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
     
     player.play()
     
     }*/
    
  
    @objc func createPlayerObserver()
    {
       
          DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                print(self.player.timeControlStatus.rawValue)
            } else {
                // Fallback on earlier versions
            }
            
            
            //print(player.isPlaying)
            if #available(iOS 10.0, *) {
                if(self.player.timeControlStatus.rawValue == 0)
                {
                    self.justStalled = 0
                    print(self.player.timeControlStatus.rawValue)
                    self.prepareToPlay()
                }
                else if(self.player.timeControlStatus.rawValue == 1)
                {
                    if(self.justStalled == 1)
                    {
                        self.stopTimerTest()
                        self.startTimer()
                        self.prepareToPlay()
                        //stopTimerTest()
                        //startTimer()
                    }
                    else
                    {
                        self.stopTimerTest()
                        self.startTimer()
                        self.justStalled = 1
                    }
                }
                else if(self.player.timeControlStatus.rawValue == 2)
                {
                    self.justStalled = 0
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
        /*playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
         
         playerItem.addObserver(self,
         forKeyPath: #keyPath(AVPlayerItem.status),
         options: [.new],
         context: &playerItemContext)*/
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                
                //addPeriodicTimeObserver()
                stopTimerTest()
                startTimer()
                /*timeObserverToken = player.addBoundaryTimeObserver(
                 forTimes: [0.5 as NSValue],
                 queue: DispatchQueue.main) { [weak self] in
                 print("The audio is in fact beginning about now...")
                 }*/
                
                
                break
            // Player item is ready to play.
            case .failed:
                justStalled = 0
                stopTimerTest()
                if #available(iOS 10.0, *) {
                    startTimerShort()
                } else {
                    // Fallback on earlier versions
                }
                print("Failed...")
                break
                // Player item failed. See error.
                
            case .unknown:
                print("Unknown...")
                break
                // Player item is not yet ready.
                
            @unknown default:
                print("Fatal...")
                fatalError()
                
            }
        }
    }
    
    
    func startTimer () {
        guard gameTimer == nil else { return }
        
        gameTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(5),
            target      : self,
            selector    : #selector(createPlayerObserver),
            userInfo    : nil,
            repeats     : true)
    }
    
    @available(iOS 10.0, *)
    func startTimerShort () {
        guard gameTimer == nil else { return }
        
        gameTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(5),
            target      : self,
            selector    : #selector(createPlayerObserver),
            userInfo    : nil,
            repeats     : true)
    }
    
    func stopTimerTest() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}

/*extension TriviaViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}*/
