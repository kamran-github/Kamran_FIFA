//
//  MyTeamsViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 28/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import XMPPFramework
import Photos
import YPImagePicker
import Alamofire
class MyTeamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    @IBOutlet weak var storyTableView: UITableView?
    @IBOutlet weak var viewMyProfile: UIView?
    // @IBOutlet weak var userIBName: UITextField?
    @IBOutlet weak var userIBAvtar: UIButton?
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var storyTableTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var notlabel: UILabel?
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var viewNavigation: UINavigationBar!
    let sections = [" My Team (Mandatory)", " Followed Team (Optional)", "You can always change your team in app Settings later."]
    
    let items = [["Add Team"], ["Add Team", "Add Team", "Add Team"]]
    
    @IBOutlet weak var btnTeamDone: UIButton?
    @IBOutlet weak var btnCancelTeam: UIButton?
    // var activityIndicator: UIActivityIndicatorView?
    var apicalling: Bool = false
     var removeimage: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
        //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        //self.activityIndicator?.startAnimating()
       // LoadingIndicatorView.show(self.view, loadingText: "Looking up your team details")
       
        //Set Contacts synced notification
        let notificationName = Notification.Name("FetchedMyTeamsDetails")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MyTeamsViewController.showMyTeams), name: notificationName, object: nil)
        
       /* let notificationName2 = Notification.Name("_GetPermissionsForMediaProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MyTeamsViewController.GetPermissionsForMediaProfile), name: notificationName2, object: nil)*/
        
      /*  let notificationName3 = Notification.Name("_GetPermissionsForCameraProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MyTeamsViewController.GetPermissionsForCameraProfile), name: notificationName3, object: nil)*/
        let notificationName4 = Notification.Name("_fanDidRegister")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MyTeamsViewController.fanDidRegister), name: notificationName4, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!appDelegate().isTeamsUpdated){
        if(appDelegate().isFromSettings)
        {
              appDelegate().isTeamsUpdated = false
            appDelegate().GetmyTeam()
          
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(appDelegate().isFromSettings)
        {
            btnCancelTeam?.isHidden = false
            viewMyProfile?.isHidden=true
            self.storyTableTopConstaint.constant = -CGFloat(160.0)
            //navItem.title = "My Teams"
            self.navigationItem.title = "My Teams"
            notlabel?.isHidden = true
            viewNavigation.isHidden = true
            let infoButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.teamDone(sender:)))//UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
            //UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
            // 3
            self.navigationItem.rightBarButtonItem = infoButton
        }
        else{
           /* LoadingIndicatorView.show(self.view, loadingText: "Please wait while teams sync.")
            let counter =  2
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter)) {
                LoadingIndicatorView.hide()
            }*/
             self.navigationItem.title = "Profile"
            if(appDelegate().isTeamNotSelected){
                btnCancelTeam?.isHidden = true
            }
            else{
                if(appDelegate().usernotcomplete){
                     //viewNavigation.isHidden = true
                }
                else{
                    viewNavigation.isHidden = true
                     btnCancelTeam?.isHidden = false
                    
                     let infoButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.teamDone(sender:)))//UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
                     //UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
                     // 3
                     if(appDelegate().primaryTeamId != 0)
                     {
                     self.navigationItem.rightBarButtonItem = infoButton
                     }
                }
                
               
            }
            
        }
        
        if appDelegate().isAvtarChanged == false
        {
            //Prepare Avtar View
            userIBAvtar?.layer.masksToBounds = true;
            userIBAvtar?.clipsToBounds=true;
            userIBAvtar?.layer.borderWidth = 1.0
            userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor //UIColor.cyan.cgColor
            userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            userIBAvtar?.layer.cornerRadius = 55.0
            
            //Check if user comes after register or just reinstalled app
            //let isRegistering: String? = UserDefaults.standard.string(forKey: "isRegistering")
            //if (isRegistering != nil) {
            //User comes after register, so we have to give option to make his profile
            
            
            //}
            //else
            //{
            //User just reinstalled app so we have to just show fetched profile of him
            let _: String? = UserDefaults.standard.string(forKey: "userStatus")
            //let userAvatar: String? = UserDefaults.standard.string(forKey: "userAvatar")
            let temavtar = UserDefaults.standard.value(forKey: "tempavtar")
            if(temavtar != nil)
            {
            let myPicture = UIImage(data: temavtar as! Data)
            
            userIBAvtar?.setImage(myPicture, for: UIControl.State.normal)
                self.appDelegate().profileAvtarTemp = myPicture
            }
            else{
                removeimage = true
            }
           
           /* if(!appDelegate().isFromSettings)
                   {
             userIBAvtar?.setImage(appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
            }*/
           /* else if((userAvatar) != nil)
            {
                //userIBAvtar?.image = appDelegate().loadProfileImage(filePath: userAvatar!)
                userIBAvtar?.setImage(appDelegate().loadProfileImage(filePath: userAvatar!), for: UIControlState.normal)
            }*/
            /*if((userName) != nil)
             {
             userIBName?.text = userName
             }*/
            
            
            //}
            
        }
        else
        {
            userIBAvtar?.layer.masksToBounds = true;
            userIBAvtar?.clipsToBounds=true;
            userIBAvtar?.layer.borderWidth = 1.0
            userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor//UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0).cgColor
            userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            userIBAvtar?.layer.cornerRadius = 55.0
            //userIBAvtar?.image = appDelegate().profileAvtarTemp!
            userIBAvtar?.setImage(appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
            
            let _: String? = UserDefaults.standard.string(forKey: "userStatus")
            
            /* if((userName) != nil)
             {
             userIBName?.text = userName
             }*/
            
        }
        
        //showMyTeams()
       
        //Code to show team images
      
        
        self.showMyTeams()
        
        
        
        /*self.storyTableView?.reloadData()
         
         if(appDelegate().isLoadingMyTeams == false)
         {
         if (self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }
         }*/
        
        /*if(appDelegate().optionalTeam1Id != 0)
         {
         let teamImageName = "Team" + appDelegate().optionalTeam1Id.description
         print(teamImageName)
         
         let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
         if((teamImage) != nil)
         {
         btnOptionalTeam1?.setImage(appDelegate().loadProfileImage(filePath: teamImage!), for: UIControlState.normal)
         
         }
         
         }
         else
         {
         btnOptionalTeam1?.setImage(nil, for: UIControlState.normal)
         }
         
         if(appDelegate().optionalTeam2Id != 0)
         {
         let teamImageName = "Team" + appDelegate().optionalTeam2Id.description
         print(teamImageName)
         
         let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
         if((teamImage) != nil)
         {
         btnOptionalTeam2?.setImage(appDelegate().loadProfileImage(filePath: teamImage!), for: UIControlState.normal)
         
         }
         
         }
         else
         {
         btnOptionalTeam2?.setImage(nil, for: UIControlState.normal)
         }
         
         if(appDelegate().optionalTeam3Id != 0)
         {
         let teamImageName = "Team" + appDelegate().optionalTeam3Id.description
         print(teamImageName)
         
         let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
         if((teamImage) != nil)
         {
         btnOptionalTeam3?.setImage(appDelegate().loadProfileImage(filePath: teamImage!), for: UIControlState.normal)
         
         }
         
         }
         else
         {
         btnOptionalTeam3?.setImage(nil, for: UIControlState.normal)
         }*/
        
        
    }
    
    @objc func GetPermissionsForCameraProfile(notification: NSNotification){
        //Code to show camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @objc func GetPermissionsForMediaProfile(notification: NSNotification){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            //Show loader
            //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
            // self.activityIndicator?.startAnimating()
           // LoadingIndicatorView.show(self.view, loadingText: "Showing your image album.")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc func fanDidRegister(notification: NSNotification){
        appDelegate().NameTemp = ""//= UserDefaults.standard.string(forKey: "userName") as! String
        Clslogging.logdebug(State: "fanDidRegister Start")
        //New code to save profile image
        let tempuserName = UserDefaults.standard.string(forKey: "userName")
        if(tempuserName != nil){
            appDelegate().NameTemp = tempuserName!
        }
        UserDefaults.standard.setValue("Hello! I am a Football Fan", forKey: "userStatus")
        UserDefaults.standard.synchronize()
        if(appDelegate().isvCardUpdated == true)
        {
            
            Clslogging.logdebug(State: "fanDidRegister isvCardUpdated=true")
            /* if(!(userIBName?.text?.isEmpty)!)
             {
             UserDefaults.standard.setValue(userIBName?.text, forKey: "userStatus")
             UserDefaults.standard.synchronize()
             }
             else
             {
             UserDefaults.standard.setValue("Hey there! I am using Football Fan", forKey: "userStatus")
             UserDefaults.standard.synchronize()
             }
             */
            
            
            //This code will move to response of PHPAPI
            //if(appDelegate().isAvtarChanged){
               sendAvatarImageToPHPAPI()
           // }
           
            //appDelegate().saveProfileImage(appDelegate().profileAvtarTemp!)
        }
        else
        {
             Clslogging.logdebug(State: "fanDidRegister isvCardUpdated=false")
            let userJID = UserDefaults.standard.string(forKey: "registerJID")
            UserDefaults.standard.setValue(nil, forKey: "isShowProfile")
            UserDefaults.standard.setValue(nil, forKey: "isRegistering")
            UserDefaults.standard.setValue("YES", forKey: "isLoggedin")
            if(!appDelegate().isTeamNotSelected){
                 Clslogging.logdebug(State: "fanDidRegister isTeamNotSelected=false")
                 UserDefaults.standard.setValue(userJID, forKey: "userJID")
            }
           
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(nil, forKey: "registerJID")
            UserDefaults.standard.synchronize()
            appDelegate().isAvtarChanged = false
            appDelegate().isvCardUpdated = false
            UserDefaults.standard.setValue(userAvtar, forKey: "userAvatarURL")
                                       UserDefaults.standard.synchronize()
             teamsaveForSignup()
        }
        //Code to save my teams
       // var dictRequest = [String: AnyObject]()
        //dictRequest["cmd"] = "teamsave" as AnyObject
       
       
        //If user is not connected then connect him
        if(self.appDelegate().xmppStream != nil)
        {
            if(self.appDelegate().xmppStream?.isDisconnected)!
            {
                if(self.appDelegate().connect())
                {
                    
                }
            }
            else
            {
                let login: String? = UserDefaults.standard.string(forKey: "userJID")
                if(login != nil)
                {
                    self.appDelegate().goOnline(self.appDelegate().xmppStream!)
                }
            }
        }
        
        
        Clslogging.logdebug(State: "fanDidRegister End")
    }
    func teamsaveForSignup()  {
        let shortcode = UserDefaults.standard.string(forKey: "usercountryshortcode")
             appDelegate().CountryShotcutTemp  = "gb"
             if(shortcode != nil){
                 appDelegate().CountryShotcutTemp  = shortcode!
             }
             
             //End
             // if(appDelegate().connect()){
             if (appDelegate().xmppStream?.isConnected)!
             {
                 Clslogging.logdebug(State: "fanDidRegister isConnected=true")
               /*  appDelegate().xmppvCardStorage = XMPPvCardCoreDataStorage.init()
                 //XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                 if(appDelegate().xmppvCardStorage != nil){
                       Clslogging.logdebug(State: "fanDidRegister xmppvCardStorage!=nil")
                   do
                   {
                     appDelegate().xmppvCardTempModule =  try XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage!)
                     
                     appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                     
                     let vCardXML = XMLElement(name: "vCard", xmlns:"vcard-temp")
                     
                     let newvCardTemp: XMPPvCardTemp  = XMPPvCardTemp.vCardTemp(from: vCardXML)
                     //newvCardTemp.addAttribute(withName: "id", stringValue: "profileUpdated")
                     // print(UserDefaults.standard.string(forKey: "userAvatarURL") ?? 0)
                     if UserDefaults.standard.string(forKey: "userAvatarURL") != nil
                     {
                         let avatarField: XMLElement = XMLElement.element(withName: "avatar") as! XMLElement
                         avatarField.stringValue = UserDefaults.standard.string(forKey: "userAvatarURL")
                         newvCardTemp.addChild(avatarField)
                         
                     }
                     else{
                         let avatarField: XMLElement = XMLElement.element(withName: "avatar") as! XMLElement
                         avatarField.stringValue = userAvtar//UserDefaults.standard.string(forKey: "userAvatarURL")
                         newvCardTemp.addChild(avatarField)
                     }
                     //New code for custom field
                     
                     let statusField: XMLElement = XMLElement.element(withName: "status") as! XMLElement
                     statusField.stringValue = UserDefaults.standard.string(forKey: "userStatus")
                     newvCardTemp.addChild(statusField)
                     //End
                     
                     //newvCardTemp.photo = imageData
                     //newvCardTemp.nickname = appDelegate().NameTemp
                     let nameField: XMLElement = XMLElement.element(withName: "name") as! XMLElement
                     nameField.stringValue = UserDefaults.standard.string(forKey: "userName")
                     newvCardTemp.addChild(nameField)
                     let MobilesettingField: XMLElement = XMLElement.element(withName: "profilemobile") as! XMLElement
                     MobilesettingField.stringValue = UserDefaults.standard.string(forKey: "Mobilesetting")
                     newvCardTemp.addChild(MobilesettingField)
                     
                     let EmailsettingField: XMLElement = XMLElement.element(withName: "profileemail") as! XMLElement
                     EmailsettingField.stringValue = UserDefaults.standard.string(forKey: "Emailsetting")
                     newvCardTemp.addChild(EmailsettingField)
                     //newvCardTemp.status = "Hey there! I am using Football Fan"
                     appDelegate().xmppvCardTempModule?.updateMyvCardTemp(newvCardTemp)
                    } catch let error as NSError {
                    print(error.localizedDescription)
                    }
                 }
                 else{
                      Clslogging.logdebug(State: "fanDidRegister xmppvCardStorage init")
                     appDelegate().xmppvCardStorage2 = XMPPvCardCoreDataStorage.init()
                     //XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                     if(appDelegate().xmppvCardStorage2 != nil){
                        do {
                         appDelegate().xmppvCardTempModule =  try XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage2!)
                         
                         appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                         
                         let vCardXML = XMLElement(name: "vCard", xmlns:"vcard-temp")
                         
                         let newvCardTemp: XMPPvCardTemp  = XMPPvCardTemp.vCardTemp(from: vCardXML)
                         //newvCardTemp.addAttribute(withName: "id", stringValue: "profileUpdated")
                         // print(UserDefaults.standard.string(forKey: "userAvatarURL") ?? 0)
                         if UserDefaults.standard.string(forKey: "userAvatarURL") != nil
                         {
                             let avatarField: XMLElement = XMLElement.element(withName: "avatar") as! XMLElement
                             avatarField.stringValue = UserDefaults.standard.string(forKey: "userAvatarURL")
                             newvCardTemp.addChild(avatarField)
                             
                         }
                         else{
                             let avatarField: XMLElement = XMLElement.element(withName: "avatar") as! XMLElement
                             avatarField.stringValue = userAvtar//UserDefaults.standard.string(forKey: "userAvatarURL")
                             newvCardTemp.addChild(avatarField)
                         }
                         //New code for custom field
                         
                         let statusField: XMLElement = XMLElement.element(withName: "status") as! XMLElement
                         statusField.stringValue = UserDefaults.standard.string(forKey: "userStatus")
                         newvCardTemp.addChild(statusField)
                         //End
                         
                         //newvCardTemp.photo = imageData
                         //newvCardTemp.nickname = appDelegate().NameTemp
                         let nameField: XMLElement = XMLElement.element(withName: "name") as! XMLElement
                         nameField.stringValue = UserDefaults.standard.string(forKey: "userName")
                         newvCardTemp.addChild(nameField)
                         let MobilesettingField: XMLElement = XMLElement.element(withName: "profilemobile") as! XMLElement
                         MobilesettingField.stringValue = UserDefaults.standard.string(forKey: "Mobilesetting")
                         newvCardTemp.addChild(MobilesettingField)
                         
                         let EmailsettingField: XMLElement = XMLElement.element(withName: "profileemail") as! XMLElement
                         EmailsettingField.stringValue = UserDefaults.standard.string(forKey: "Emailsetting")
                         newvCardTemp.addChild(EmailsettingField)
                         //newvCardTemp.status = "Hey there! I am using Football Fan"
                         appDelegate().xmppvCardTempModule?.updateMyvCardTemp(newvCardTemp)
                        } catch let error as NSError {
                                           print(error.localizedDescription)
                                           }
                     }
                    
                 }*/
                 
             }
             else{
                   Clslogging.logdebug(State: "fanDidRegister isConnected=false")
             }
             //  }
             //code to save my teams to database and show Tabs
             UserDefaults.standard.setValue(nil, forKey: "isShowTeams")
             UserDefaults.standard.setValue("YES", forKey: "isRegisterProcess")
            UserDefaults.standard.setValue("", forKey: "userbio")
             UserDefaults.standard.synchronize()
              Clslogging.logdebug(State: "fanDidRegister team save Start")
          
         var dictRequest = [String: AnyObject]()
                                              dictRequest["cmd"] = "teamsave" as AnyObject
                                              dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                                              dictRequest["device"] = "ios" as AnyObject
               //Creating Request Data
               var dictRequestData = [String: AnyObject]()
               
               var userJID: String? = ""
               if let jid = UserDefaults.standard.string(forKey: "userJID")
               {
                   userJID = jid
               }
               else
               {
                   userJID = UserDefaults.standard.string(forKey: "registerJID")
               }
               
               
               let deviceToken: String? = UserDefaults.standard.string(forKey: "DeviceToken")
               
               let arrUserJid = userJID?.components(separatedBy: "@")
               let userJidTrim = arrUserJid?[0]
               
               /*if(userJID?.isEmpty)!
                {
                userJID = UserDefaults.standard.string(forKey: "registerJID")
                }*/
               var countrycode: String? = UserDefaults.standard.string(forKey: "usercountrycode")
               let usercity: String? = UserDefaults.standard.string(forKey: "userecity")
               let userstate: String? = UserDefaults.standard.string(forKey: "userstate")
               let usercontry: String? = UserDefaults.standard.string(forKey: "usercountry")
               var usermobileno: String? = UserDefaults.standard.string(forKey: "registerMobile")
               let userdob: Int64? = Int64(UserDefaults.standard.integer(forKey: "userdob"))
               let userlat: Double? = UserDefaults.standard.double(forKey: "latitude")
               let userlong: Double? = UserDefaults.standard.double(forKey: "longitude")
               let useremail: String? = UserDefaults.standard.string(forKey: "useremail")
               let userName: String? = UserDefaults.standard.string(forKey: "userName")
                let refralcode: String? = UserDefaults.standard.string(forKey: "refralcode")
               if(countrycode == nil){
                   countrycode = "0"
               }
               if(usermobileno == nil){
                   usermobileno = "0"
               }
        var mobilewithcc: String? = "+" + countrycode!.replace(target: " ", withString: "") + usermobileno!
               //var mobilewithcc: String? = "+" + countrycode! + usermobileno!
               if(mobilewithcc?.hasPrefix("++"))!{
                   //registermo = registermo.replacingOccurrences(of: "0", with: "")
                   mobilewithcc = "" + String((mobilewithcc?.dropFirst())!)
               }
               dictRequestData["jid"] = userJID as AnyObject
               dictRequestData["username"] = userJidTrim as AnyObject
               dictRequestData["primaryteam"] = appDelegate().primaryTeamId as AnyObject
               dictRequestData["followedteam1"] = appDelegate().optionalTeam1Id as AnyObject
               dictRequestData["followedteam2"] = appDelegate().optionalTeam2Id as AnyObject
               dictRequestData["followedteam3"] = appDelegate().optionalTeam3Id as AnyObject
               if(deviceToken != nil){
               dictRequestData["devicetocken"] = deviceToken as AnyObject
               }else{
                   dictRequestData["devicetocken"] = "none" as AnyObject
               }
               dictRequestData["latitude"] = userlat as AnyObject
               dictRequestData["longitude"] = userlong as AnyObject
        dictRequestData["mobile"] = usermobileno!.replacingOccurrences(of: " ", with: "") as AnyObject
               dictRequestData["birthday"] = userdob as AnyObject
               dictRequestData["city"] = usercity as AnyObject
               dictRequestData["state"] = userstate as AnyObject
               dictRequestData["country"] = usercontry as AnyObject
              // dictRequestData["countrycode"] = countrycode?.replace(target: "+", withString: "") as AnyObject
               dictRequestData["shortcode"] = appDelegate().CountryShotcutTemp as AnyObject
               dictRequestData["method"] = "register" as AnyObject
               dictRequestData["email"] = useremail as AnyObject
               dictRequestData["name"] = userName as AnyObject
                dictRequestData["mobilewithcc"] = mobilewithcc?.replacingOccurrences(of: " ", with: "") as AnyObject
                dictRequestData["isfcsignup"] = appDelegate().GetvalueFromInsentiveConfigTable(Key: isfcsignup)
                dictRequestData["fcsignup"] = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsignup)
         if(refralcode != nil){
               if(refralcode != ""){
                   dictRequestData["isfcreferral"] = appDelegate().GetvalueFromInsentiveConfigTable(Key: isfcreferral)
                   dictRequestData["fcreferral"] = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)
                   dictRequestData["referralusername"] = refralcode as AnyObject
               }
        }
               if(countrycode != nil)
               {
                   dictRequestData["countrycode"] = countrycode?.replace(target: "+", withString: "") as AnyObject
               }
               else{
                   dictRequestData["countrycode"] = "44" as AnyObject
               }
               dictRequestData["avatar"] = UserDefaults.standard.string(forKey: "userAvatarURL") as AnyObject
      
               dictRequestData["status"] = UserDefaults.standard.string(forKey: "userStatus") as AnyObject
               dictRequestData["bio"] = "" as AnyObject
         dictRequestData["type"] = "fan" as AnyObject
               dictRequestData["profilestatus"] = "active" as AnyObject
               dictRequest["requestData"] = dictRequestData as AnyObject
               //dictRequest.setValue(dictMobiles, forKey: "requestData")
               // print(dictRequest)
               
           
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
                                                                                                                                                                       DispatchQueue.main.async {
                                                                                                                                                                           let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                                                           //print(response)
                                                                                                                                                                           let myProfileDict: NSDictionary = response[0] as! NSDictionary
                                                                                                                                                                           //Save my teams in user defaults here
                                                                                                                                                                           //Primary
                                                                                                                                                                                                                                                                                                                                                                                       self.appDelegate().OnSignupGetbanter(myProfileDict: myProfileDict)
                                                                                                                                                                        //self.appDelegate().getUserGroupsData()
                                                                                                                                                                                                                                                                                                           Clslogging.logdebug(State: "fanDidRegister team save End")
                                                                                                                                                                        self.appDelegate().HomeSetSlider = true
                                                                                                                                                                        self.appDelegate().showMainTab()
                                                                                                                                                                                LoadingIndicatorView.hide()
                                                                            }
                                                                                                                                                                   }
                                                                                                                                                                      else{
                                                                                                                                                                          DispatchQueue.main.async
                                                                                                                                                                           {
                                                                                                                                                                            self.apicalling = false
                                                                                                                     LoadingIndicatorView.hide()
                                                                                                                                                                       }
                                                                                                                                                                          //Show Error
                                                                                                                                                                      }
                                                                                                                                                                  }
                                                                        case .failure(let error):
                                    self.apicalling = false
                                                                                      LoadingIndicatorView.hide()
                                    debugPrint(error as Any)
                                    
                                    break
                                                                            // error handling
                                                             
                                                                        }
                                                  
                                                                                                                  }
                   var myteam = ""
                   
                   
                   myteam += "\(String(describing: appDelegate().primaryTeamId))"
                   
                   if(appDelegate().optionalTeam1Id != 0)
                   {
                       myteam += ",\(String(describing: appDelegate().optionalTeam1Id))"
                   }
                   if(appDelegate().optionalTeam2Id != 0)
                   {
                       myteam += ",\(String(describing: appDelegate().optionalTeam2Id))"
                   }
                   if(appDelegate().optionalTeam3Id != 0)
                   {
                       myteam += ",\(String(describing: appDelegate().optionalTeam3Id))"
                   }
                 
               
        if let event = KochavaEvent(eventTypeEnum: .registrationComplete) {
            event.nameString = userJID//"nitsh"
            //event.priceDoubleNumber = 0.99
            
            KochavaTracker.shared.send(event)
        }
    }
    @objc func showMyTeams()
    {
        //Code to show team images
        
        let pTeamId: Int64? = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
        let pTeamName: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? " "
        let pTeamLogo: String? = UserDefaults.standard.string(forKey: "primaryTeamLogo") ?? " "
        
        if((pTeamId) != 0)
        {
            appDelegate().primaryTeamId = pTeamId!
            appDelegate().primaryTeamName = pTeamName!
            appDelegate().primaryTeamLogo = pTeamLogo!
            btnTeamDone?.isHidden = false
        }
        else
        {
            btnTeamDone?.isHidden = true
        }
        
        let oTeam1Id: Int64? = Int64(UserDefaults.standard.integer(forKey: "optionalTeam1Id"))
        let oTeam1Name: String? = UserDefaults.standard.string(forKey: "optionalTeam1Name") ?? " "
        let oTeam1Logo: String? = UserDefaults.standard.string(forKey: "optionalTeam1Logo") ?? " "
        
        if((oTeam1Id) != 0)
        {
            appDelegate().optionalTeam1Id = oTeam1Id!
            appDelegate().optionalTeam1Name = oTeam1Name!
            appDelegate().optionalTeam1Logo = oTeam1Logo!
        }
        
        let oTeam2Id: Int64? = Int64(UserDefaults.standard.integer(forKey: "optionalTeam2Id"))
        let oTeam2Name: String? = UserDefaults.standard.string(forKey: "optionalTeam2Name") ?? " "
        let oTeam2Logo: String? = UserDefaults.standard.string(forKey: "optionalTeam2Logo") ?? " "
        
        if((oTeam2Id) != 0)
        {
            appDelegate().optionalTeam2Id = oTeam2Id!
            appDelegate().optionalTeam2Name = oTeam2Name!
            appDelegate().optionalTeam2Logo = oTeam2Logo!
        }
        
        let oTeam3Id: Int64? = Int64(UserDefaults.standard.integer(forKey: "optionalTeam3Id"))
        let oTeam3Name: String? = UserDefaults.standard.string(forKey: "optionalTeam3Name") ?? " "
        let oTeam3Logo: String? = UserDefaults.standard.string(forKey: "optionalTeam3Logo") ?? " "
        
        if((oTeam3Id) != 0)
        {
            appDelegate().optionalTeam3Id = oTeam3Id!
            appDelegate().optionalTeam3Name = oTeam3Name!
            appDelegate().optionalTeam3Logo = oTeam3Logo!
        }
        
        self.storyTableView?.reloadData()
        
        /*if (self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
       // LoadingIndicatorView.hide()
        
        appDelegate().isLoadingMyTeams = false
        
    }
    
    @IBAction func showImagePicker () {
        
        
        /* if(!(userIBName?.text?.isEmpty)!)
         {
         UserDefaults.standard.setValue(userIBName?.text, forKey: "userStatus")
         UserDefaults.standard.synchronize()
         }*/
        
        
        let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
        let RemoveAction = UIAlertAction(title: "Delete Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
            self.appDelegate().profileAvtarTemp = UIImage(named:"avatar")
            self.appDelegate().isvCardUpdated = true
            self.appDelegate().isAvtarChanged = false
            self.removeimage = true
            self.userIBAvtar?.layer.masksToBounds = true;
            self.userIBAvtar?.clipsToBounds=true;
            self.userIBAvtar?.layer.borderWidth = 1.0
            self.userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor
            UserDefaults.standard.setValue(nil, forKey: "tempavtar")
                                              UserDefaults.standard.synchronize()
            self.userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            self.userIBAvtar?.layer.cornerRadius = 55.0
            //userIBAvtar?.image = appDelegate().profileAvtarTemp!
            self.appDelegate().isFromSettings = false
            self.userIBAvtar?.setImage(self.appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
            
        })
        RemoveAction.setValue(UIColor.red, forKey: "titleTextColor")
       
        let saveAction = UIAlertAction(title: "Choose Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Choose Photo")
            //Code to show gallery
            self.showCustomGallery()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
        })
        if(!removeimage){
        optionMenu.addAction(RemoveAction)
        }
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    func showCustomGallery() {
          
          var config = YPImagePickerConfiguration()
          config.library.mediaType = .photo
          config.library.onlySquare  = true
          
          //let maskViewP = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
          
          //let maskView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
          
          //maskView.layer.cornerRadius = 160
         // redView.mask = maskView
      
          //maskView.backgroundColor = .white
          //maskView.alpha = 0.5
          //config.overlayView.
          //config.overlayView?.mask = maskView
          
          
          let cgRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
          let myView = UIImageView()
          myView.image = UIImage(named: "cameraoverlay")
          myView.frame = cgRect
          myView.backgroundColor = UIColor.clear
          myView.isOpaque = true
          //myView.layer.cornerRadius = self.view.bounds.width/2
          //myView.layer.borderColor =  UIColor.lightGray.cgColor
          //myView.layer.borderWidth = 1
          //myView.layer.masksToBounds = true
      
          config.overlayView = myView
          
          config.onlySquareImagesFromCamera = true
          config.targetImageSize = .original
          config.usesFrontCamera = true
          config.showsPhotoFilters = true
          config.filters = [YPFilter(name: "Normal", coreImageFilterName: ""),
                            YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
                            YPFilter(name: "Tonal", coreImageFilterName: "CIPhotoEffectTonal"),
                            YPFilter(name: "Noir", coreImageFilterName: "CIPhotoEffectNoir"),
                            YPFilter(name: "Fade", coreImageFilterName: "CIPhotoEffectFade"),
                            YPFilter(name: "Chrome", coreImageFilterName: "CIPhotoEffectChrome"),
                            YPFilter(name: "Process", coreImageFilterName: "CIPhotoEffectProcess"),
                            YPFilter(name: "Transfer", coreImageFilterName: "CIPhotoEffectTransfer"),
                            YPFilter(name: "Instant", coreImageFilterName: "CIPhotoEffectInstant"),
                            YPFilter(name: "Sepia", coreImageFilterName: "CISepiaTone")]
        
          config.shouldSaveNewPicturesToAlbum = false
          // config.video.compression = AVAssetExportPresetHighestQuality
          config.video.compression = AVAssetExportPresetMediumQuality
         // config.showsCrop = .rectangle(ratio: 1.0)
          config.albumName = "Football Fan"
          config.screens = [.library, .photo]
          config.startOnScreen = .library
          config.video.recordingTimeLimit = 300
          config.video.libraryTimeLimit = 900
          config.video.trimmerMaxDuration = 900
          // config.video.fileType = .mp4
          config.wordings.libraryTitle = "Gallery"
          config.hidesStatusBar = true
          //config.overlayView = myOverlayView
          config.library.maxNumberOfItems = 1
          config.library.minNumberOfItems = 1
          config.library.numberOfItemsInRow = 3
          config.library.spacingBetweenItems = 2
          config.isScrollToChangeModesEnabled = false
          config.isScrollToChangeModesEnabled = true
          config.hidesStatusBar = false
          config.wordings.cameraTitle = "Camera"
          config.wordings.videoTitle = "Video"
          config.wordings.cancel = "Cancel"
          config.wordings.albumsTitle = "Albums"
          config.wordings.trim = "Trim"
          config.wordings.cover = "Cover"
          config.wordings.crop = "Crop"
          config.wordings.done = "Done"
          config.wordings.filter = "Filter"
          config.wordings.next = "Done"
          config.colors.progressBarTrackColor = UIColor.init(hex: "E6E6E6")
          config.colors.progressBarCompletedColor = UIColor.init(hex: "FFD401")
          config.colors.trimmerHandleColor = UIColor.init(hex: "FFD401")
          config.colors.multipleItemsSelectedCircleColor = UIColor.init(hex: "FFD401")
          config.wordings.warningMaxItemsLimit = "The limit is 3 Images or Videos."
          config.icons.playImage = UIImage(named: "gallery_play")!
          config.wordings.videoDurationPopup.tooLongMessage = "Pick a video less than 15 minutes long"
                     config.wordings.videoDurationPopup.title = "Video Duration"
                     config.wordings.videoDurationPopup.tooShortMessage = "The video must be at least 3 seconds"
          //UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
          UINavigationBar.appearance().barTintColor = UIColor.init(hex: "FFD401")
          UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black ] // Title color
          UINavigationBar.appearance().tintColor = .black // Left. bar buttons
          config.colors.tintColor = .black
          //config.showsCrop = YPCropType.none
          
          // Build a picker with your configuration
          let picker = YPImagePicker(configuration: config)
          
          picker.didFinishPicking { [unowned picker] items, _ in
              
              for item in items {
                  switch item {
                  case .photo(let photo):
                      //print(photo)
                    self.appDelegate().isAvtarChanged = true
                    self.appDelegate().isvCardUpdated = true
                    var tempImg = photo.modifiedImage
                    if(tempImg == nil){
                        tempImg = photo.originalImage
                    }
                    self.removeimage = false
                    self.appDelegate().profileAvtarTemp! = tempImg!
                    self.userIBAvtar?.layer.masksToBounds = true;
                    self.userIBAvtar?.clipsToBounds=true;
                    self.userIBAvtar?.layer.borderWidth = 1.0
                    self.userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor//UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0).cgColor
                    self.userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
                    self.userIBAvtar?.layer.cornerRadius = 55.0
                    self.userIBAvtar?.setImage(self.appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
                    let data = tempImg!.pngData()
                    UserDefaults.standard.setValue(data, forKey: "tempavtar")
                                   UserDefaults.standard.synchronize()
                      break
                  case .video(let video):
                      //print(video)
                    
                      break
                  }
              }
             
              picker.dismiss(animated: true, completion: nil)
              
              
          }
          present(picker, animated: true, completion: nil)
          
      }
  /*  func displayPhotoSettingsAlert() {
        let cantAddContactAlert = UIAlertController(title: "",
                                                    message: "Please allow access for Football Fan to your media library.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        
                                                        let url = NSURL(string: UIApplication.openSettingsURLString)
                                                        UIApplication.shared.openURL(url! as URL)
                                                        
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func displayCameraSettingsAlert() {
        let cantAddContactAlert = UIAlertController(title: "",
                                                    message: "Please allow access for Football Fan to your camera and media library.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        
                                                        let url = NSURL(string: UIApplication.openSettingsURLString)
                                                        UIApplication.shared.openURL(url! as URL)
                                                        
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //let newImageData = UIImageJPEGRepresentation(image, 1)
        //userIBAvtar!.image = UIImage(data: newImageData!)
        //userIBAvtar!.image = image
        appDelegate().isAvtarChanged = true
        appDelegate().profileAvtarTemp! = image!
        //userIBAvtar!.image = appDelegate().profileAvtarTemp!
        //userIBAvtar!.setImage(appDelegate().profileAvtarTemp!, for: UIControlState.normal)
        self.dismiss(animated: true, completion: nil)
        appDelegate().showCropAvtar()
        //
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            appDelegate().isAvtarChanged = true
            appDelegate().profileAvtarTemp! = pickedImage
            //dismiss(animated: true, completion: nil)
            // dismiss(animated: true)
            // dismiss(animated: true, completion: nil)
            appDelegate().isvCardUpdated = true
            appDelegate().isAvtarChanged = true
            // appDelegate().showCropAvtar()
            if let pngImageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage)!.pngData(){
                UserDefaults.standard.setValue(pngImageData, forKey: "tempavtar")
                UserDefaults.standard.synchronize()
            }
           
        }
        
    }*/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(appDelegate().isFromSettings)
        {
            return 2
            
        }
        else{
             return self.sections.count
        }
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2){
            return 0
        }
        else{
            return self.items[section].count
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if(section == 0)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        }
        else if(section == 1)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        }
        else if(section == 2)
        {
            headerView.backgroundColor = UIColor.clear// #FD7A5C
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.sections[section]
        if(section == 2){
            label.textColor=UIColor(hex: "9A9A9A")
            label.textAlignment = .center
            label.numberOfLines=2
            let  screenHeight = self.view.frame.height
            
            if(screenHeight <= 568)
            {
                label.font = UIFont.systemFont(ofSize: 11)
            }
            else{
                label.font = UIFont.systemFont(ofSize: 13)
            }
        }
        else{
           
            label.textColor=UIColor(hex: "FFFFFF")
        }
        
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
           // label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if(section == 2){
             return 60.0
        }
        else{
            return 30.0
        }
    }
    
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 80.0
     }*/
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyTeamsCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyTeamsCell
        
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            if(appDelegate().primaryTeamId != 0)
            {
                
                cell.teamName?.text = appDelegate().primaryTeamName
                
                let teamImageName = "Team" + appDelegate().primaryTeamId.description
                //print(teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                else
                {
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                
            }
            else
            {
                cell.teamName?.text = self.items[indexPath.section][indexPath.row]
                cell.teamImage?.image = UIImage(named:"team")
            }
        }
        else if(indexPath.section == 1 && indexPath.row == 0)
        {
            if(appDelegate().optionalTeam1Id != 0)
            {
                cell.teamName?.text = appDelegate().optionalTeam1Name
                
                let teamImageName = "Team" + appDelegate().optionalTeam1Id.description
                //print(teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().optionalTeam1Logo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                else
                {
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().optionalTeam1Logo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                
            }
            else
            {
                cell.teamName?.text = self.items[indexPath.section][indexPath.row]
                cell.teamImage?.image = UIImage(named:"team")
            }
        }
        else if(indexPath.section == 1 && indexPath.row == 1)
        {
            if(appDelegate().optionalTeam2Id != 0)
            {
                cell.teamName?.text = appDelegate().optionalTeam2Name
                
                let teamImageName = "Team" + appDelegate().optionalTeam2Id.description
                //print(teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().optionalTeam2Logo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                else
                {
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().optionalTeam2Logo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                
            }
            else
            {
                cell.teamName?.text = self.items[indexPath.section][indexPath.row]
                cell.teamImage?.image = UIImage(named:"team")
            }
        }
        else if(indexPath.section == 1 && indexPath.row == 2)
        {
            if(appDelegate().optionalTeam3Id != 0)
            {
                cell.teamName?.text = appDelegate().optionalTeam3Name
                
                let teamImageName = "Team" + appDelegate().optionalTeam3Id.description
                //print(teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().optionalTeam3Logo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                else
                {
                    if(cell.teamImage?.image == nil)
                    {
                        appDelegate().loadImageFromUrl(url: appDelegate().optionalTeam3Logo,view: (cell.teamImage)!, fileName: teamImageName as String)
                    }
                }
                
            }
            else
            {
                cell.teamName?.text = self.items[indexPath.section][indexPath.row]
                cell.teamImage?.image = UIImage(named:"team")
            }
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("You tapped cell number \(indexPath.row).")
        
        //self.items[indexPath.section][indexPath.row
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            appDelegate().teamToSet = 1
            self.showAddTeam()
        }
        else if(indexPath.section == 1 && indexPath.row == 0)
        {
            appDelegate().teamToSet = 2
            self.showAddTeam()
        }
        else if(indexPath.section == 1 && indexPath.row == 1)
        {
            appDelegate().teamToSet = 3
            self.showAddTeam()
        }
        else if(indexPath.section == 1 && indexPath.row == 2)
        {
            appDelegate().teamToSet = 4
            self.showAddTeam()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            return false
        }
        else if(indexPath.section == 1 && indexPath.row == 0 && appDelegate().optionalTeam1Id != 0)
        {
            return true
        }
        else if(indexPath.section == 1 && indexPath.row == 1 && appDelegate().optionalTeam2Id != 0)
        {
            return true
        }
        else if(indexPath.section == 1 && indexPath.row == 2 && appDelegate().optionalTeam3Id != 0)
        {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
           
            if(indexPath.section == 0 && indexPath.row == 0)
            {
                
            }
            else if(indexPath.section == 1 && indexPath.row == 0)
            {
                
                appDelegate().optionalTeam1Id = 0
                appDelegate().optionalTeam1Name = ""
                UserDefaults.standard.setValue(0, forKey: "optionalTeam1Id")
                UserDefaults.standard.setValue(nil, forKey: "optionalTeam1Name")
                UserDefaults.standard.synchronize()
                self.storyTableView?.reloadData()
                 appDelegate().isTeamsUpdated = true
            }
            else if(indexPath.section == 1 && indexPath.row == 1)
            {
                appDelegate().optionalTeam2Id = 0
                appDelegate().optionalTeam2Name = ""
                UserDefaults.standard.setValue(0, forKey: "optionalTeam2Id")
                UserDefaults.standard.setValue(nil, forKey: "optionalTeam2Name")
                UserDefaults.standard.synchronize()
                self.storyTableView?.reloadData()
                 appDelegate().isTeamsUpdated = true
            }
            else if(indexPath.section == 1 && indexPath.row == 2)
            {
                appDelegate().optionalTeam3Id = 0
                appDelegate().optionalTeam3Name = ""
                UserDefaults.standard.setValue(0, forKey: "optionalTeam3Id")
                UserDefaults.standard.setValue(nil, forKey: "optionalTeam3Name")
                UserDefaults.standard.synchronize()
                self.storyTableView?.reloadData()
                 appDelegate().isTeamsUpdated = true
            }
        }
    }
    
    @IBAction func cancelTeam () {
        //Code to get my teams.
        appDelegate().isTeamsUpdated = false
        if(appDelegate().isFromSettings)
        {
            appDelegate().GetmyTeam()
           self.dismiss(animated: true, completion: nil)
        }
        else{
            appDelegate().showregister()
        }
        
        
       
    }
    
    @IBAction func teamDone (sender:UIButton) {
        if(!apicalling){
            apicalling = true
        if(appDelegate().primaryTeamId != 0)
                   {
                    
        if ClassReachability.isConnectedToNetwork() {
            if(appDelegate().isFromSettings)
            {
                /*let pTeamId: Int? = UserDefaults.standard.integer(forKey: "primaryTeamId")
                 let oTeam1Id: Int? = UserDefaults.standard.integer(forKey: "optionalTeam1Id")
                 let oTeam2Id: Int? = UserDefaults.standard.integer(forKey: "optionalTeam2Id")
                 let oTeam3Id: Int? = UserDefaults.standard.integer(forKey: "optionalTeam3Id")
                 */
                //  let pTeamName: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? " "
                //let pTeamLogo: String? = UserDefaults.standard.string(forKey: "primaryTeamLogo") ?? " "
                if(appDelegate().isTeamsUpdated ){
                    alertWithTitle(title: "Warning", message: "Do you really want to change your teams? You will automatically quit from related banter.", ViewController: self)
                    
                }
                else{
                    apicalling = false
                   alertWithTitle2(title: nil, message: "No teams changed.", ViewController: self)
                }
                
                
            }
            else
            {
                if(appDelegate().isTeamNotSelected){
                    let notificationName = Notification.Name("_fanDidRegister")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                }
                else{
                    LoadingIndicatorView.show(self.view, loadingText: "Creating your Football Fan profile")
                    UserDefaults.standard.setValue("yes", forKey: "allowregistration")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.setValue(false, forKey: "istriviauser")
                    UserDefaults.standard.synchronize()
                    //UserDefaults.standard.setValue(nil, forKey: "triviauser")
                   // UserDefaults.standard.synchronize()
                    if appDelegate().connect(){
                        
                    }
                }
                
               
                
            }
            
        } else {
            apicalling = false
            alertWithTitle1(title: nil, message: "F check your Internet connection.", ViewController: self)
            
        }
        }
        else{
            apicalling = false
            alertWithTitle1(title: nil, message: "Please select your Team(s)", ViewController: self)
        }
        }
    }
    
    func sendAvatarImageToPHPAPI()
    {
        let registorusername: String? = UserDefaults.standard.string(forKey: "registerusername")
        
        let boundary = appDelegate().generateBoundaryString()
        var request = URLRequest(url: URL(string: MediaAPI)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var reqParams = [String: String]()
        reqParams["cmd"] = "avatar"
        reqParams["key"] = "kXfqS9wUug6gVKDB"  
        reqParams["jid"] = registorusername
        if(removeimage){
             reqParams["isdefaultimage"] = "yes"
        }
        self.dismiss(animated: false, completion: nil)
        
        request.httpBody = appDelegate().createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                if String(data: data, encoding: String.Encoding.utf8) != nil {
                    //print(stringData) //JSONSerialization
                    
                    
                    
                    //print(time)
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                        
                        let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                        
                        if(isSuccess)
                        {
                            let avatarLink = (jsonData?.value(forKey: "link") as? String)!
                            self.appDelegate().saveProfileImageURL(self.appDelegate().profileAvtarTemp!, strAvatarURL: avatarLink)
                            UserDefaults.standard.setValue(avatarLink, forKey: "userAvatarURL")
                            UserDefaults.standard.synchronize()
                             Clslogging.logdebug(State: "fanDidRegister Avtar updated URL:\(avatarLink)")
                            self.teamsaveForSignup()
                        }
                        else
                        {
                            self.apicalling = false
                            //Show Error
                            Clslogging.logdebug(State: "fanDidRegister Avtar uploaded failed")
                        }
                    } catch let error as NSError {
                        print(error)
                        //Show Error
                        self.apicalling = false
                        let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                        Clslogging.logerror(State: "fanDidRegister", userinfo: errorinfo)
                    }
                    
                }
                else{
                    self.apicalling = false
                }
            }
            else
            {
                //Show Error
                self.apicalling = false
                Clslogging.logdebug(State: "fanDidRegister Avtar uploaded response DATA = nil")
            }
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*@IBAction func addPrimaryTeam () {
     appDelegate().teamToSet = 1
     showAddTeam()
     }
     
     @IBAction func addOptionalTeam1 () {
     appDelegate().teamToSet = 2
     showAddTeam()
     }
     
     @IBAction func addOptionalTeam2 () {
     appDelegate().teamToSet = 3
     showAddTeam()
     }
     
     @IBAction func addOptionalTeam3 () {
     appDelegate().teamToSet = 4
     showAddTeam()
     }*/
    
    func showAddTeam()
    {
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
        //popController.isShowForBanterRoom = true
        popController.teamType = ""
        // present the popover
        self.present(popController, animated: true, completion: nil)
        // get a reference to the view controller for the popover
        /*let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam")
        
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
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
            self.apicalling = false
        });
        let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
            // self.appDelegate().isFromSettings = false
            self.SaveTeamFromSetting()
        });
        alert.addAction(action)
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       
        let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func alertWithTitle2(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
       
        alert.addAction(action1)
        //alert.addAction(action2)

        self.present(alert, animated: true, completion:nil)
    }
    
    func SaveTeamFromSetting()
    {
        if(self.appDelegate().isUserOnline){
        //Code to save my teams
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "teamsave" as AnyObject
        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
        dictRequest["device"] = "ios" as AnyObject
        //Creating Request Datap
        var dictRequestData = [String: AnyObject]()
        let userJID: String? = UserDefaults.standard.string(forKey: "userJID")
        let deviceToken: String? = UserDefaults.standard.string(forKey: "DeviceToken")
        
        let arrUserJid = userJID?.components(separatedBy: "@")
        let userJidTrim = arrUserJid?[0]
        // let name: String? = UserDefaults.standard.string(forKey: "userJID")
        //let useremail: String? = UserDefaults.standard.string(forKey: "userJID")
        //  let usercity: String? = UserDefaults.standard.string(forKey: "userecity")
        //  let userstate: String? = UserDefaults.standard.string(forKey: "userstate")
        //  let usercontry: String? = UserDefaults.standard.string(forKey: "usercountry")
        let usermobileno: String? = UserDefaults.standard.string(forKey: "registerMobile")
        let userdob: String? = UserDefaults.standard.string(forKey: "userdob")
        let countrycode: String? = UserDefaults.standard.string(forKey: "usercountrycode")
        let mobilewithcc: String? = "+" + countrycode!.replace(target: " ", withString: "") + usermobileno!
        let useremail: String? = UserDefaults.standard.string(forKey: "useremail")
         let userName: String? = UserDefaults.standard.string(forKey: "userName")
        //  let userlat: String? = UserDefaults.standard.string(forKey: "latitude")
        //  let userlong: String? = UserDefaults.standard.string(forKey: "longitude")
        /*if(userJID?.isEmpty)!
         {
         userJID = UserDefaults.standard.string(forKey: "registerJID")
         }*/
         let CountryShotcutTemp: String? = UserDefaults.standard.string(forKey: "usercountryshortcode")
        dictRequestData["jid"] = userJID as AnyObject
        dictRequestData["username"] = userJidTrim as AnyObject
        dictRequestData["primaryteam"] = appDelegate().primaryTeamId as AnyObject
        dictRequestData["followedteam1"] = appDelegate().optionalTeam1Id as AnyObject
        dictRequestData["followedteam2"] = appDelegate().optionalTeam2Id as AnyObject
        dictRequestData["followedteam3"] = appDelegate().optionalTeam3Id as AnyObject
        if(deviceToken != nil){

        dictRequestData["devicetocken"] = deviceToken as AnyObject
        }else{
           dictRequestData["devicetocken"] = "none" as AnyObject
        }
         dictRequestData["name"] = userName as AnyObject
        dictRequestData["shortcode"] = CountryShotcutTemp as AnyObject
        // dictRequestData["longitude"] = userlong as AnyObject
        dictRequestData["mobile"] = usermobileno!.replacingOccurrences(of: " ", with: "") as AnyObject
        dictRequestData["birthday"] = userdob as AnyObject
        dictRequestData["email"] = useremail as AnyObject
        // dictRequestData["city"] = usercity as AnyObject
        // dictRequestData["state"] = userstate as AnyObject
        // dictRequestData["country"] = usercontry as AnyObject
        if(countrycode != nil)
        {
            dictRequestData["countrycode"] = countrycode?.replace(target: "+", withString: "") as AnyObject
        }
        else{
            dictRequestData["countrycode"] = "44" as AnyObject
        }
        dictRequestData["mobilewithcc"] = mobilewithcc!.replacingOccurrences(of: " ", with: "") as AnyObject
        dictRequestData["avatar"] = UserDefaults.standard.string(forKey: "userAvatarURL") as AnyObject
            dictRequestData["status"] = UserDefaults.standard.string(forKey: "userStatus") as AnyObject
                         dictRequestData["bio"] = "" as AnyObject
            dictRequestData["type"] = "fan" as AnyObject
                          dictRequestData["profilestatus"] = "active" as AnyObject
        dictRequest["requestData"] = dictRequestData as AnyObject
       
            AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
            headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                                                                                                            // 2
                .responseJSON{ response in
                    
                    switch response.result {
                                                            case .success(let value):
                                                                if let json = value as? [String: Any] {
                                                                    // print(" JSON:", json)
                                                                    let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                    // self.finishSyncContacts()
                                                                    //print(" status:", status1)
                                                                 if(status1){
                                                                    DispatchQueue.main.async {
                                                                        self.appDelegate().isTeamsUpdated = false
                                                                        self.appDelegate().AfterTeamChange()
                                                                        self.navigationController?.popViewController(animated: true)
                                                                        
                                                                    }
                                                                        
                                                                    }
                                                                    else{
                                                                        DispatchQueue.main.async
                                                                            {
                                                                                self.apicalling = false
                                                                                
                                                                    }
                                                                        //Show Error
                                                                    }
                                                                }
                                                            case .failure(let error):
                        self.apicalling = false
                        debugPrint(error as Any)
                        break
                                                                // error handling
                                                 
                                                            }
                       
                }
      
        
      //  self.dismiss(animated: true, completion: nil)
        
        }
        else{
            self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
               apicalling = false
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
            MyTeamsViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MyTeamsViewController.realDelegate!;
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
