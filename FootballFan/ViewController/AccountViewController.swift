//
//  AcountViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 21/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

//import Foundation
import UIKit
import XMPPFramework
class AccountViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    var settingOptions: [AnyObject] = []
    let cellReuseIdentifier = "settings"
    @IBOutlet weak var storyTableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        var tempDict1 = [String: String]()
        tempDict1["logo"] = "user"
        tempDict1["name"] = "Profile"
        self.settingOptions.append(tempDict1 as AnyObject)
        var tempDict2 = [String: String]()
        tempDict2["logo"] = "Privacy"
        tempDict2["name"] = "Privacy"
        self.settingOptions.append(tempDict2 as AnyObject)
        var tempDict3 = [String: String]()
        tempDict3["logo"] = "key"
        tempDict3["name"] = "Change Password"
        self.settingOptions.append(tempDict3 as AnyObject)
       /* var tempDict4 = [String: String]()
        tempDict4["logo"] = "PurchaseHistory"
        tempDict4["name"] = "Purchase history"
        self.settingOptions.append(tempDict4 as AnyObject)*/
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.parent?.title = "Settings"
        self.navigationItem.title = "Account"
        storyTableView?.reloadData()
        if ClassReachability.isConnectedToNetwork() {
            //  if(appDelegate().isvCardUpdated)
            // {
           /* appDelegate().xmppvCardStorage = XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
            
            if(appDelegate().xmppvCardStorage != nil)
            {
                appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage!)
                appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                appDelegate().xmppvCardTempModule?.addDelegate(self, delegateQueue: DispatchQueue.main)
                
                appDelegate().xmppvCardTempModule?.fetchvCardTemp(for: appDelegate().xmppStream!.myJID!, ignoreStorage: true)
            }
            else
            {
                appDelegate().xmppvCardStorage2 = XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                
                if(appDelegate().xmppvCardStorage2 != nil)
                {
                    appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage2!)
                    appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                    appDelegate().xmppvCardTempModule?.addDelegate(self, delegateQueue: DispatchQueue.main)
                    
                    appDelegate().xmppvCardTempModule?.fetchvCardTemp(for: appDelegate().xmppStream!.myJID!, ignoreStorage: true)
                }
            }*/
            
            
            //}
        }
        appDelegate().countrySelected = ""
        
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
        
        //let cell = tableView.cellForRow(at: indexPath) as! SettingsCell
        if(indexPath.row == 0) //My Teams
        {
            self.showMyprofile()
        }
        if(indexPath.row == 1) //My Teams
        {
            self.showPrivacy()
        }
        if(indexPath.row == 2) //My Teams
        {
            self.showChangePassword()
        }
        if(indexPath.row == 3) //My Teams
        {
            self.showpurchaseHistory()
        }
        
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            AccountViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return AccountViewController.realDelegate!;
    }
    func showMyprofile()
    {
        appDelegate().countryCodeSelected = ""
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : ProfileViewController = storyBoard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        myTeamsController.isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
    func showChangePassword()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : ChangePasswordFromSettingViewController = storyBoard.instantiateViewController(withIdentifier: "cpassword") as! ChangePasswordFromSettingViewController
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
    func showpurchaseHistory()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : purchasedHistoryViewContriller = storyBoard.instantiateViewController(withIdentifier: "purchasedHistory") as! purchasedHistoryViewContriller
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
    func showPrivacy()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : PrivacySettingViewController = storyBoard.instantiateViewController(withIdentifier: "privacysetting") as! PrivacySettingViewController
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
       // self.present(myTeamsController, animated: true, completion: nil)
    }
    @IBAction func cancelTeam () {
       // userIBName?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
}
