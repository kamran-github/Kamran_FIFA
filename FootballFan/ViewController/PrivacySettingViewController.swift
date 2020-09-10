//
//  PrivacySettingViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 03/04/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework
class PrivacySettingViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    //let sections = [" Mobile"," Email Address"," Messaging"," Fan Stories"]
    let sections = [" Rooms"," Fan Stories"]
       
    // let items = ["Available"]
    @IBOutlet weak var btnTone: UIButton?
    @IBOutlet weak var storyTableView: UITableView?
    var settingOptions: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
        //UserStaus?.text=UserDefaults.standard.string(forKey: "userStatus")
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.parent?.title = "Settings"
        self.navigationItem.title = "Privacy"
     
       
        var tempDict3 = [String: String]()
        tempDict3["mode"] = "Blocked Fans"
        tempDict3["name"] = "List of fans that have been blocked."
        self.settingOptions.append(tempDict3 as AnyObject)
        var tempDict4 = [String: String]()
        tempDict4["mode"] = "Blocked Fans"
        tempDict4["name"] = "List of fans that have been blocked."
        self.settingOptions.append(tempDict4 as AnyObject)
        let Tone = UserDefaults.standard.bool(forKey: "ConvertationTone")
        if (Tone) {
            btnTone?.setImage(UIImage(named: "failtick"), for: UIControl.State.normal)
        }
        else{
            btnTone?.setImage(UIImage(named: "green_tick"), for: UIControl.State.normal)
            
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.sections.count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
      
        headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.sections[section]
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
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
        
      
          if(indexPath.section == 0){
            let dict: [String : String] = settingOptions[0] as! [String : String]
            cell.optionmode?.text = dict["name"]
            cell.optionName?.text = dict["mode"]
            cell.bottomConstraint1.constant = 60.0
            cell.optionmode?.isHidden = false
            
        }
        else if(indexPath.section == 1){
                   let dict: [String : String] = settingOptions[1] as! [String : String]
                   cell.optionmode?.text = dict["name"]
                   cell.optionName?.text = dict["mode"]
                   cell.bottomConstraint1.constant = 60.0
                   cell.optionmode?.isHidden = false
                   
               }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section == 0 ){
            return 70.0
        }
        else if(indexPath.section == 1 ){
            return 70.0
        }
        
        return 50.0//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        var priority = ""
        //let indexvalue = indexPath.row
        if(indexPath.section == 0){
            showBlockedUser()
        }
            else  if(indexPath.section == 1){
                       showStoriesBlockedUser()
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
            
            self.vcardupdate()
            
            
        })
          let ContactsAction = UIAlertAction(title: "My Contacts", style: .default, handler: {
         (alert: UIAlertAction!) -> Void in
        
         priority = "My contacts"
            if(indexPath.section == 0 && indexPath.row == 0){
                
                UserDefaults.standard.setValue(priority, forKey: "Mobilesetting")
                UserDefaults.standard.synchronize()
                var tempDict1 = [String: String]()
                tempDict1["mode"] = "My Contacts"
                tempDict1["name"] = "Mobile"
                self.settingOptions[0]=tempDict1 as AnyObject
            }
            else if(indexPath.section == 1 && indexPath.row == 0){
                UserDefaults.standard.setValue(priority, forKey: "Emailsetting")
                UserDefaults.standard.synchronize()
                var tempDict1 = [String: String]()
                tempDict1["mode"] = "My Contacts"
                tempDict1["name"] = "Email"
                self.settingOptions[1]=tempDict1 as AnyObject
            }
         self.storyTableView?.reloadData()
            self.vcardupdate()
           
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
           self.vcardupdate()
            
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
    }
    }
    
    @IBAction func cancelTeam () {
        //  UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
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
            PrivacySettingViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return PrivacySettingViewController.realDelegate!;
    }
    @IBAction func showConvertationTonevalue () {
        // let passwordtag = ""
        let Tone = UserDefaults.standard.bool(forKey: "ConvertationTone")
        if (Tone) {
            // userpassword?.isSecureTextEntry = false
            //userpassword?.font = UIFont(name:sy, size: 18)
            //btnShow?.setTitle("Hide Password", for: UIControlState.normal)
            UserDefaults.standard.setValue(false, forKey: "ConvertationTone")
            UserDefaults.standard.synchronize()
            btnTone?.setImage(UIImage(named: "failtick"), for: UIControl.State.normal)
        }
        else{
            btnTone?.setImage(UIImage(named: "green_tick"), for: UIControl.State.normal)
            UserDefaults.standard.setValue(true, forKey: "ConvertationTone")
            UserDefaults.standard.synchronize()
            // userpassword?.isSecureTextEntry = true
            //btnShow?.setTitle("Show Password", for: UIControlState.normal)
        }
        
    }
    func showBlockedUser()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : BlockedViewController = storyBoard.instantiateViewController(withIdentifier: "BlockedView") as! BlockedViewController
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
       // self.present(myTeamsController, animated: true, completion: nil)
    }
    func showStoriesBlockedUser()
       {
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let myTeamsController : StoriesBlockesUserViewController = storyBoard.instantiateViewController(withIdentifier: "StoriesBlockesUser") as! StoriesBlockesUserViewController
           //  appDelegate().isFromSettings = true
           show(myTeamsController, sender: self)
          // self.present(myTeamsController, animated: true, completion: nil)
       }
    func vcardupdate()  {
        if (appDelegate().xmppStream?.isConnected)!
        {
           /* appDelegate().xmppvCardStorage = XMPPvCardCoreDataStorage.init()
            //XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
            if(appDelegate().xmppvCardStorage != nil)
            {
            appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage!)
            
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
        }
            else{
                appDelegate().xmppvCardStorage2 = XMPPvCardCoreDataStorage.init()
                //XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                if(appDelegate().xmppvCardStorage2 != nil)
                {
                    appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage2!)
                    
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
                }
                
            }*/
        }
    }
}
