//
//  SettingsViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 23/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import XMPPFramework

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate {
     @IBOutlet weak var profileview: UIView?
    @IBOutlet weak var storyTableView: UITableView?
    @IBOutlet weak var contactName: UILabel?
    @IBOutlet weak var contactStatus: UILabel?
    @IBOutlet weak var contactImage: UIImageView?
      @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var settingOptions: [AnyObject] = []
    let cellReuseIdentifier = "settings"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
      
        var tempDict2 = [String: String]()
        tempDict2["logo"] = "per_notification"
        tempDict2["name"] = "Notifications"
        self.settingOptions.append(tempDict2 as AnyObject)
        var tempDict5 = [String: String]()
        tempDict5["logo"] = "Invite_users"
        tempDict5["name"] = "Invite a Friend"
        self.settingOptions.append(tempDict5 as AnyObject)
        var tempDict6 = [String: String]()
        tempDict6["logo"] = "FAQ"
        tempDict6["name"] = "Help"
        self.settingOptions.append(tempDict6 as AnyObject)
        var tempDict7 = [String: String]()
        tempDict7["logo"] = "Terms"
        tempDict7["name"] = "Terms & Conditions "
        self.settingOptions.append(tempDict7 as AnyObject)
        var tempDict4 = [String: String]()
        tempDict4["logo"] = "Privacy"
        tempDict4["name"] = "Privacy Policy"
        self.settingOptions.append(tempDict4 as AnyObject)
        var tempDict8 = [String: String]()
        tempDict8["logo"] = "About"
        tempDict8["name"] = "App Info"
        self.settingOptions.append(tempDict8 as AnyObject)
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
       var tempDict10 = [String: String]()
        tempDict10["logo"] = "Signout"
        tempDict10["name"] = "Sign Out"
        self.settingOptions.append(tempDict10 as AnyObject)
        }else{
            topConstraint.constant = 10.0
            profileview?.isHidden = true
            var tempDict10 = [String: String]()
            tempDict10["logo"] = "Signout"
            tempDict10["name"] = "Sign In"
            self.settingOptions.append(tempDict10 as AnyObject)
        }
        
        // Comment by Mayank 18 Jun 2018
        /*
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "teamsync" as AnyObject
        var dictRequestData = [String: AnyObject]()
        
        dictRequestData["version"] = appDelegate().Realeseversion as AnyObject
        dictRequest["requestData"] = dictRequestData as AnyObject
        do {
            let dataTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strTeams = NSString(data: dataTeams, encoding: String.Encoding.utf8.rawValue)! as String
            // print(strTeams)
            appDelegate().sendRequestToAPI(strRequestDict: strTeams)
        } catch {
           // print(error.localizedDescription)
        }
        */
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.navigationItem.title = "Settings"
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if ClassReachability.isConnectedToNetwork() {
            //  if(appDelegate().isvCardUpdated)
            // {
          /*  appDelegate().xmppvCardStorage = XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
            
            if(appDelegate().xmppvCardStorage != nil)
            {
                appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage!)
                appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                appDelegate().xmppvCardTempModule?.addDelegate(self, delegateQueue: DispatchQueue.main)
                do {
                      appDelegate().xmppvCardTempModule?.fetchvCardTemp(for: try appDelegate().xmppStream!.myJID!, ignoreStorage: true)
                   // print("i eat it \(sandwich)")
                
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }*/
             }
            
            }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.parent?.title = "Settings"
        
       
        appDelegate().countrySelected = ""
       
        contactImage?.layer.masksToBounds = true;
        contactImage?.clipsToBounds=true;
       // contactImage?.layer.borderWidth = 1.0
      //  contactImage?.layer.borderColor = UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0).cgColor
        contactImage?.contentMode =  UIView.ContentMode.scaleAspectFit
        contactImage?.layer.cornerRadius = 25.0
        
        if let userName = UserDefaults.standard.string(forKey: "userName")
        {
            contactName?.text = userName
        }
        if let userAvatar = UserDefaults.standard.string(forKey: "userAvatar")
        {
            let avatar: String = userAvatar as String
            if(!avatar.isEmpty)
            {
                contactImage?.image = appDelegate().loadProfileImage(filePath: userAvatar)
            }
            else
            {
                contactImage?.image = UIImage(named: "user")
            }
            
        }
        
        if let userStatus = UserDefaults.standard.string(forKey: "userStatus")
        {
            contactStatus?.text = userStatus
        }
        else
        {
            contactStatus?.text = "Hello! I am a Football Fan"
            UserDefaults.standard.setValue("Hello! I am a Football Fan", forKey: "userStatus")
            UserDefaults.standard.synchronize()
        }
        storyTableView?.reloadData()
        
        if(appDelegate().isTeamsUpdated){
            appDelegate().isTeamsUpdated = false
            appDelegate().GetmyTeam()
          
                    
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return settingOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingsCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SettingsCell
        //print(phoneFilteredContacts)
        
            //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
        let dict: [String : String] = settingOptions[indexPath.row] as! [String : String]
        cell.optionName?.text = dict["name"]
        cell.optionImage?.image = UIImage(named: dict["logo"]!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if(indexPath.row == 0) //My Teams
        { let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
            self.showWNotificationScreen()
            }else{
                appDelegate().LoginwithModelPopUp()
            }
        }
        if(indexPath.row == 1) //My Teams
        {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
            share()
            }else{
                appDelegate().LoginwithModelPopUp()
            }
        }
        if(indexPath.row == 2) //My Teams
        {
            UserDefaults.standard.setValue("FAQ", forKey: "terms")
            UserDefaults.standard.synchronize()
            //showWEBVIEWScreen()
            self.showHelpVideo()
        }
        if(indexPath.row == 3) //My Teams
        {
            UserDefaults.standard.setValue("Terms & Conditions", forKey: "terms")
            UserDefaults.standard.synchronize()
            showWEBVIEWScreen()
        }
        if(indexPath.row == 4) //My Teams
        {
            UserDefaults.standard.setValue("Privacy Policy", forKey: "terms")
            UserDefaults.standard.synchronize()
            showWEBVIEWScreen()
        }
        if(indexPath.row == 5) //My Teams
        {
           showAppInfo()
        }
        if(indexPath.row == 6) //My Teams
        {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
            alertWithTitle(title: "", message: "Do you really want to Sign Out?", ViewController: self)
            }else{
                appDelegate().LoginwithModelPopUp()
            }
        }
       
        /*if(indexPath.row == 2) //My Teams
         {
         self.showRedeem()
         }*/
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
            self.storyTableView?.reloadData()
        });
        let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
            if ClassReachability.isConnectedToNetwork() {
                self.settingOptions = []
               /* var tempDict1 = [String: String]()
                tempDict1["logo"] = "user"
                tempDict1["name"] = "Account"
                self.settingOptions.append(tempDict1 as AnyObject)
                */
                /*var tempDict3 = [String: String]()
                tempDict3["logo"] = "team"
                tempDict3["name"] = "My Teams"
                self.settingOptions.append(tempDict3 as AnyObject)*/
                /* var tempDict9 = [String: String]()
                 tempDict9["logo"] = "leaderboard"
                 tempDict9["name"] = "FanCoins Leader Board"
                 self.settingOptions.append(tempDict9 as AnyObject)
                 */
                var tempDict2 = [String: String]()
                tempDict2["logo"] = "per_notification"
                tempDict2["name"] = "Notifications"
                self.settingOptions.append(tempDict2 as AnyObject)
                var tempDict5 = [String: String]()
                tempDict5["logo"] = "Invite_users"
                tempDict5["name"] = "Invite a Friend"
                self.settingOptions.append(tempDict5 as AnyObject)
                var tempDict6 = [String: String]()
                tempDict6["logo"] = "FAQ"
                tempDict6["name"] = "Help"
                self.settingOptions.append(tempDict6 as AnyObject)
                var tempDict7 = [String: String]()
                tempDict7["logo"] = "Terms"
                tempDict7["name"] = "Terms & Conditions "
                self.settingOptions.append(tempDict7 as AnyObject)
                var tempDict4 = [String: String]()
                tempDict4["logo"] = "Privacy"
                tempDict4["name"] = "Privacy Policy"
                self.settingOptions.append(tempDict4 as AnyObject)
                var tempDict8 = [String: String]()
                tempDict8["logo"] = "About"
                tempDict8["name"] = "App Info"
                self.settingOptions.append(tempDict8 as AnyObject)
                
                
                    var tempDict10 = [String: String]()
                    tempDict10["logo"] = "Signout"
                    tempDict10["name"] = "Sign In"
                    self.settingOptions.append(tempDict10 as AnyObject)
                self.appDelegate().HomeSetSlider = true
               self.appDelegate().SignOut()
                DispatchQueue.main.async {
                self.storyTableView?.reloadData()
                    self.profileview?.isHidden = true
                    self.topConstraint.constant = 10.0
                    self.contactImage?.image = UIImage(named: "user")
                    self.contactStatus?.text = "Hello! I am a Football Fan"
                    self.contactName?.text = ""
                }
            } else {
                self.alertWithTitle1(title: "Error", message: "Please check your Internet connection.", ViewController: self)
                
            }
            
            
        });
        alert.addAction(action)
        alert.addAction(action1)
        self.present(alert, animated: false, completion:nil)
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
        });
        
        alert.addAction(action)
        
        self.present(alert, animated: false, completion:nil)
    }
    
    func showMyTeams()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : MyTeamsViewController = storyBoard.instantiateViewController(withIdentifier: "MyTeams") as! MyTeamsViewController
        appDelegate().isFromSettings = true
        //show(myTeamsController, sender: self)
        //show(myTeamsController, sender: self)
       // self.present(myTeamsController, animated: true, completion: nil)
         show(myTeamsController, sender: self)
    }
    func showMyprofile()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : AccountViewController = storyBoard.instantiateViewController(withIdentifier: "Account") as! AccountViewController
        appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
    func showAppInfo()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : AppInfoViewController = storyBoard.instantiateViewController(withIdentifier: "appinfo") as! AppInfoViewController
        appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
    func showHelpVideo()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : HelpViewController = storyBoard.instantiateViewController(withIdentifier: "help") as! HelpViewController
        appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
    func showRedeem()
    {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : LeaderBoardViewController! = storyBoard.instantiateViewController(withIdentifier: "leaderboard") as? LeaderBoardViewController
        show(registerController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
   
    
    @IBAction func cancelForward () {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            SettingsViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return SettingsViewController.realDelegate!;
    }
    func showWEBVIEWScreen()
    {
        
        
      /*  let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webview")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        
        // present the popover
        self.present(popController, animated: true, completion: nil)*/
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewcontroller = storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewcontroller
        
        show(myTeamsController, sender: self)
    }
    func showWNotificationScreen()
    {
        
        
        /*let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Notification")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        
        // present the popover
        self.present(popController, animated: true, completion: nil)*/
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : NotificationViewController = storyBoard.instantiateViewController(withIdentifier: "Notification") as! NotificationViewController
        
        show(myTeamsController, sender: self)
    }
    func share() {
        let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
        //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
        let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
        let userReadUserJid = arrReadUserJid[0]
        let textToShare = "Check out this cool app called \"Football Fan\". I use it watch Football videos, create stories, banter, find fans, news and collect FanCoins rewards.\n\nGet it free for your iPhone or Android phone at:\nwww.ifootballfan.com/app\n\nSign Up to the app and you will instantly get \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsignup)) FanCoins rewards.\n\nUse my referral code \"\(userReadUserJid)\" during Sign Up to collect extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins."//"Check out this cool app called \"Football Fan\". I use it to earn FanCoins, participate in Football banter, post my Football stories, find fans nearby, Football news from around the world, share messages, pictures and videos.\n\nGet it free for your iPhone at:\nhttps://apple.co/2OSoN6p\n\nGet it free for your Android phone at:\nhttp://bit.ly/ff8g \n\nUse my referral code \"\(userReadUserJid)\" to earn extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins."
        
        //if let myWebsite = NSURL(string: "https://www.tridecimal.com") {
            let objectsToShare = [textToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        //}
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
