//
//  NewBanterRoomController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 07/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import XMPPFramework

class NewBanterRoomController: UIViewController {
    @IBOutlet weak var myTeam: UILabel?
    @IBOutlet weak var aponentTeam: UILabel?
    @IBOutlet weak var banterRoomName: UITextField?
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnMyTeam: UIButton!
    @IBOutlet weak var btnOpponentTeam: UIButton!
     @IBOutlet weak var Bottomlable: UILabel?
    @IBOutlet weak var HeadingText: UILabel!
     @IBOutlet weak var Banternamecount: UILabel?
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    
    var xmppMUC: XMPPMUC? = nil
    //var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewBanterRoomController.minimiseKeyboard(_:))))
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if(screenHeight <= 480)
        {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
        myTeam?.layer.masksToBounds = true;
        myTeam?.layer.borderWidth = 1.0
        myTeam?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //UIColor.lightGray.cgColor
        myTeam?.layer.cornerRadius = 5.0
        
        aponentTeam?.layer.masksToBounds = true;
        aponentTeam?.layer.borderWidth = 1.0
        aponentTeam?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //UIColor.lightGray.cgColor
        aponentTeam?.layer.cornerRadius = 5.0
        
        let notificationName = Notification.Name("_BanterRoomCreated")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewBanterRoomController.banterRoomCreated), name: notificationName, object: nil)
        
        /*Bottomlable?.text = "Invite your friends to download Football Fan app and instantly start a banter with them. \n - Banters are meant to be fun between fans of 2 football teams, please keep it funny for everyone to enjoy. \n - To make your banter room interesting, we send an instant invitation to all the fans of the football teams involved in your banter room, provided fans have enabled notification settings on the phone. \n - To maintain security and identity protection, we never reveal anyone's identity in a banter room expect username. \n - Participants in a banter room can send funniest messages or pictures or videos. \n - You may change your team by going to Settings. Most importantly have fun in good spirit and keep your banter room funny."
        let text = (Bottomlable?.text)!
        Bottomlable?.sizeToFit()
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Invite")
        underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hex: "197DF6"), range: range1)
        let range2 = (text as NSString).range(of: "Settings.")
        underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hex: "197DF6"), range: range2)
        Bottomlable?.attributedText = underlineAttriString
        
        
        Bottomlable?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewBanterRoomController.tapLabel(_:))))
        Bottomlable?.isUserInteractionEnabled = true*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.appDelegate().myTeamId > 0)
        {
            myTeam?.text = " " + self.appDelegate().myTeamName
        }
        else
        {
            // Do any additional setup after loading the view.
            let pTeamId: Int64? = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
            let pTeamName: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? " "
            
            if((pTeamId) != 0)
            {
                self.appDelegate().myTeamId = pTeamId!
                self.appDelegate().myTeamName = pTeamName!
                myTeam?.text = " " + pTeamName!
            }
        }
        
        if(self.appDelegate().aponentTeamId > 0)
        {
            aponentTeam?.text = " " + self.appDelegate().aponentTeamName
        }
        
        
        
        
        //Temp Code
        //xmppMUC = XMPPMUC()
        //xmppMUC?.activate(appDelegate().xmppStream)
        //xmppMUC?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        
        
        /*<message
        from='coven@chat.shakespeare.lit/firstwitch'
        id='162BEBB1-F6DB-4D9A-9BD8-CFDCC801A0B2'
        to='hecate@shakespeare.lit/broom'
        type='groupchat'>
        <body>Thrice the brinded cat hath mew'd.</body>
        <delay xmlns='urn:xmpp:delay'
        from='coven@chat.shakespeare.lit'
        stamp='2002-10-13T23:58:37Z'/>
        </message>*/
        
        
    }
    @IBAction func Bantertxtchange(){
        
       
            Banternamecount?.text=String(describing: banterRoomName?.text?.count ?? 0)+"/"+String(describing: banterRoomName?.maxLength ?? 0)
      
        
    }
    @objc func banterRoomCreated()
    {
        self.appDelegate().banterJIDs = [String]()
        self.appDelegate().strBanterJIDs = [AnyObject]()
        //self.activityIndicator?.stopAnimating()
        TransperentLoadingIndicatorView.hide()
        self.appDelegate().isJoiningBanterRoom = false
        self.appDelegate().aponentTeamId = 0
        self.appDelegate().aponentTeamName = ""
       appDelegate().banterRoomName = ""
        self.dismiss(animated: false, completion: nil)
       // ShowFreedomview.show((appDelegate().window?.rootViewController?.view)!, loadingText: "Start earning FanCoins by being active in Banter.\n\nLearn more\n\nSpeak out your mind with complete freedom of speech.\n\nHappy Bantering!",fancoins: String(0))
        let notificationName = Notification.Name("closeNotifyWindow")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    @IBAction func createBanterRoom () {
          banterRoomName?.resignFirstResponder()
        
        if ClassReachability.isConnectedToNetwork() {
          
            if(appDelegate().isUserOnline){
            let thereWereErrors = checkForErrors()
            if !thereWereErrors
            {
                //LoadingIndicatorView.show(self.view, loadingText: "Please wait while we create this Banter Room")
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                let code = appDelegate().shortCodeGenerator(length: 4)
                let ticks = String(Date().ticks)
                appDelegate().banterRoomId = code + ticks + "@conference." + HostName
                
                _ = appDelegate().joinRoom(with: appDelegate().banterRoomId, delegate: self.appDelegate())
                //Show loader
               
                btnDone.isHidden = true
                btnMyTeam.isHidden = true
                btnOpponentTeam.isHidden = true
                var trimMessage: String = banterRoomName!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                //print(trimMessage)
                trimMessage = trimMessage.condenseWhitespace()
                self.appDelegate().banterRoomName = trimMessage
                self.appDelegate().curRoomType = "banter"
                //print("trimMessage\(trimMessage)")
                //print("creatbanterRoomName\(self.appDelegate().banterRoomName)")
                //Code to get getbanterinviteusers.
               /* var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "getbanterinviteusers" as AnyObject
                
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let userJID: String? = UserDefaults.standard.string(forKey: "userJID")
                
                dictRequestData["jid"] = userJID as AnyObject
                dictRequestData["supportteam"] = self.appDelegate().myTeamId as AnyObject
                dictRequestData["opponentteam"] = self.appDelegate().aponentTeamId as AnyObject
                
                dictRequest["requestData"] = dictRequestData as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
                do {
                    let dataCreateBanter = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strCreateBanter = NSString(data: dataCreateBanter, encoding: String.Encoding.utf8.rawValue)! as String
                    //print(strCreateBanter)
                    self.appDelegate().sendRequestToAPI(strRequestDict: strCreateBanter)
                } catch {
                    print(error.localizedDescription)
                }*/
                //End Code to get getbanterinviteusers.
                
            }
        }
        else{
                alertWithTitle(title: nil, message: "Connecting...", ViewController: self, toFocus:self.banterRoomName!)
            }
        } else {
            alertWithTitle(title: nil, message: "Please check your Internet connection to create this Banter Room.", ViewController: self, toFocus:self.banterRoomName!)
            
        }
        
        
        /*if(appDelegate().xmppStream?.isConnected())!
        {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil)
            {
                print("goOnline")
                let presence = XMPPPresence()
                presence?.addAttribute(withName: "to", stringValue: "8y0n6lu9twtolajhq07c@conference.amazomcdn.com/ravinagar79")
                //presence?.addAttribute(withName: "id", stringValue: "n13mt3lds")
                
                presence?.addAttribute(withName: "from", stringValue: "+919826615203@amazomcdn.com")
                
                //let pwd: XMLElement = XMLElement.element(withName: "password") as! XMLElement
                //pwd.stringValue = ""
                
                
                let x: XMLElement = XMLElement.element(withName: "x") as! XMLElement
                
                x.addAttribute(withName: "xmlns", stringValue: "http://jabber.org/protocol/muc")
                
                //x.addChild(pwd)
                
                presence?.addChild(x)
                appDelegate().xmppStream!.send(presence)
                
                
            }
            
            
            
            let uuid = UUID().uuidString
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            
            do {
                
                //Code to send message to XMPP Server
                var messageDict = [String: AnyObject]()
                //type //value //time //caption //banternickname //ip
                messageDict["type"] = "text" as AnyObject
                messageDict["value"] = "Test Group Chat" as AnyObject
                messageDict["time"] = time as AnyObject
                messageDict["caption"] = "" as AnyObject
                messageDict["banternickname"] = "ravinagar79" as AnyObject
                messageDict["ip"] = "" as AnyObject
                messageDict["thumblink"] = "" as AnyObject
                
                let dataMessage = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
                let strMessage = NSString(data: dataMessage, encoding: String.Encoding.utf8.rawValue)! as String
                print(strMessage)
                
                let body: XMLElement = XMLElement.element(withName: "body") as! XMLElement
                body.stringValue = strMessage
                
                let message: XMLElement = XMLElement.element(withName: "message") as! XMLElement
                
                message.addAttribute(withName: "type", stringValue: "groupchat")
                message.addAttribute(withName: "id", stringValue: uuid)
                message.addAttribute(withName: "to", stringValue: "8y0n6lu9twtolajhq07c@conference.amazomcdn.com")
                message.addAttribute(withName: "from", stringValue: "+919826615203@amazomcdn.com")
                message.addChild(body)
                
                //print(message)
                
                appDelegate().xmppStream?.send(message)
                
                //End Code to send message to XMPP Server
                
            } catch {
                print(error.localizedDescription)
            }
        }*/
    }
    
    @IBAction func cancelCreateBanterRoom () {
        
        //Working code for send invite
        /*let roomJID = XMPPJID(string: "ny9r636404829420412032@conference.amazomcdn.com")
        let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
        
        let room = XMPPRoom(roomStorage: roomStorage, jid: roomJID, dispatchQueue: DispatchQueue.main)!
        
        room.activate(self.appDelegate().xmppStream)
        
        room.addDelegate(self.appDelegate(), delegateQueue: DispatchQueue.main)
        
        // If the room is not existing, server will create one.
        //room.join(usingNickname: xmppStream?.myJID.user, history: nil)
        let newBanterNick: String = UserDefaults.standard.string(forKey: "banterNickName")!
        
        room.join(usingNickname: newBanterNick, history: nil)
        room.changeSubject(self.appDelegate().banterRoomName)
        
        let UserJid = XMPPJID(string: "+9144555556@amazomcdn.com")
        room.inviteUser(UserJid, withMessage: "Test message")*/
        
        /*let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
        let roomJID = XMPPJID(string: "49i0636405547471207040@conference.amazomcdn.com")
        let room = XMPPRoom(roomStorage: roomStorage, jid: roomJID, dispatchQueue: DispatchQueue.main)!
        room.activate(self.appDelegate().xmppStream)
        let banterName = room.roomSubject
        print(banterName ?? " Room is nil")*/
        
        
        // Do any additional setup after loading the view.
        let pTeamId: Int64? = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
        let pTeamName: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? " "
        
        if((pTeamId) != 0)
        {
            self.appDelegate().myTeamId = pTeamId!
            self.appDelegate().myTeamName = pTeamName!
        }
        
        self.appDelegate().aponentTeamId = 0
        self.appDelegate().aponentTeamName = ""
        
        
        
        dismiss(animated: false, completion: nil)
        let notificationName = Notification.Name("closeNotifyWindow")
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        
        
    }
    
    @IBAction func selectMyTeam() {
        //isShowForBanterRoom = true
        //teamType = "my"
        appDelegate().arrDataTeams =  appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
        // get a reference to the view controller for the popover
        let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        popController.isShowForBanterRoom = true
        popController.teamType = "my"
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func selectAponentTeam() {
        //isShowForBanterRoom = true
        //teamType = "aponent"
        // get a reference to the view controller for the popoverCategory
        let popController: CategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category") as! CategoryViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        popController.isShowForBanterRoom = true
        popController.teamType = "aponent"
        // present the popover
        self.present(popController, animated: true, completion: nil)
       /* let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        popController.isShowForBanterRoom = true
        popController.teamType = "aponent"
        // present the popover
        self.present(popController, animated: true, completion: nil)*/
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
        //self.storyTableView?.allowsSelection = false
        HeadingText.isHidden = true
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        /*let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         self.storyToolbar.contentInset = contentInset*/
        isKeyboardHiding = true
        adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        HeadingText.isHidden = false
        
    }
    @objc func UIKeyboardDidHide(notification:NSNotification){
        //self.storyTableView?.allowsSelection = true
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
        
        if(UIScreen.main.bounds.height <= 480)
        {
            var userInfo = notification.userInfo!
            //print(userInfo)
            self.keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
            if(isKeyboardHiding == true)
            {
                //let changeInHeight = 0.0
                UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                    //print(self.messageBox.keyboardType.rawValue)
                    //self.bottomConstraint.constant = CGFloat(changeInHeight)
                    //self.view.frame.origin.y = 0.0
                    self.topConstraint.constant = 0.0
                })
            }
            else
            {
                let changeInHeight = UIScreen.main.bounds.height - self.keyboardFrame.height - 120
                UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                    //print(self.messageBox.keyboardType.rawValue)
                    //self.bottomConstraint.constant = changeInHeight
                    self.topConstraint.constant = -changeInHeight
                    //self.view.frame.origin.y = -50//-changeInHeight
                    
                })
            }
        }
        else
        {
            var userInfo = notification.userInfo!
            //print(userInfo)
            self.keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
            if(isKeyboardHiding == true)
            {
                //let changeInHeight = 0.0
                UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                    //print(self.messageBox.keyboardType.rawValue)
                    //self.bottomConstraint.constant = CGFloat(changeInHeight)
                    //self.view.frame.origin.y = 0.0
                    self.topConstraint.constant = 0.0
                })
            }
            else
            {
                let changeInHeight = CGFloat(70.0) //UIScreen.main.bounds.height - self.keyboardFrame.height - 50
                UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                    //print(self.messageBox.keyboardType.rawValue)
                    //self.bottomConstraint.constant = changeInHeight
                    self.topConstraint.constant = -changeInHeight
                    //self.view.frame.origin.y = -50//-changeInHeight
                    
                })
            }
        }
        
    }
    
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            banterRoomName?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func checkForErrors() -> Bool
    {
        var errors = false
       // let title = "Error"
        var message = ""
        if (banterRoomName?.text?.isEmpty)! {
            errors = true
            message += "Banter Room name cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.banterRoomName!)
            
        }
        else if (self.appDelegate().myTeamId == 0) {
            errors = true
            message += "Please select your team for creating Banter Room"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.banterRoomName!)
            
        }
        else if (self.appDelegate().aponentTeamId == 0) {
            errors = true
            message += "Please select an opposition team for creating Banter Room"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.banterRoomName!)
            
        }
        else if (self.appDelegate().aponentTeamId == self.appDelegate().myTeamId) {
            errors = true
            message += "Banter Rooms can only be created between fans of 2 different teams"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.banterRoomName!)
            
        }
        
        return errors
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField, isFocus: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            if(isFocus)
            {
                toFocus.becomeFirstResponder()
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            NewBanterRoomController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewBanterRoomController.realDelegate!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapLabel(_ gesture: UITapGestureRecognizer) {
        let text = (Bottomlable!.text)!
        let termsRange = (text as NSString).range(of: "Invite")
        let privacyRange = (text as NSString).range(of: "Settings.")
        
        if gesture.didTapAttributedTextInLabel(label: Bottomlable!, inRange: termsRange) {
            //print("Tapped terms")
            //banterRoomName?.endEditing(true)
           self.share()
            
        } else if gesture.didTapAttributedTextInLabel(label: Bottomlable!, inRange: privacyRange) {
            
           self.showSettings()
        } else {
            
        }
        
        banterRoomName?.endEditing(true)
    }
    func showSettings() {
       // print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    func share() {
        let textToShare = "Join biggest community of football fans for FREE on \"Football Fan\" app today.\n\nJoin the most funniest banters going around football world or find another Football Fan nearby to chat or create a group of friends to send messages, pictures, videos and many more.\n\nTap link below to download \"Football Fan\" app from https://itunes.apple.com/footballfan/dp/ or https://play.google.com/store/apps/footballfan"
        
        if let myWebsite = NSURL(string: "https://www.cinefuntv.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
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
