//
//  MoreViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 17/09/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var storyTableView: UITableView!
    
    var items: [String] = ["Fixtures","Chats","Contacts", "Settings"]
    var itemsImage: [String] = ["fixture","chats","contacts", "settings"]
     @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var Connectinglabel: UILabel?
    // MARK: - Table view data source
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
        
        let notificationName = Notification.Name("RefreshmoreView")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MoreViewController.refreshChats), name: notificationName, object: nil)
        let notificationName1 = Notification.Name("_isUserOnlineNotifyMore")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MoreViewController.isUserOnline), name: notificationName1, object: nil)
        
       
    }
    @objc func isUserOnline()
    {
       DispatchQueue.main.async {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            if ClassReachability.isConnectedToNetwork() {
                
                if(self.appDelegate().isUserOnline)
                {
                    // LoadingIndicatorView.hide()
                    //self.parent?.title = "More"
                    self.ConectingHightConstraint.constant = CGFloat(0.0)
                }
                else
                {
                    self.Connectinglabel?.text = "Connecting..."
                    self.ConectingHightConstraint.constant = CGFloat(0.0)
                    //LoadingIndicatorView.hide()
                    // self.parent?.title = "Banter Rooms"
                    //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading banters.")
                    //self.parent?.title = "Connecting.."
                }
                
                
            } else {
               // LoadingIndicatorView.hide()
                //self.parent?.title = "Waiting for network.."
                self.Connectinglabel?.text = "Waiting for network..."
                self.ConectingHightConstraint.constant = CGFloat(20.0)
            }
        }
        else{
            if ClassReachability.isConnectedToNetwork() {
                self.Connectinglabel?.text = "Connecting..."
                self.ConectingHightConstraint.constant = CGFloat(0.0)
            }else{
                self.Connectinglabel?.text = "Waiting for network..."
                self.ConectingHightConstraint.constant = CGFloat(20.0)
            }
             // ConectingHightConstraint.constant = CGFloat(0.0)
        }
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "More"
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.parent?.navigationItem.leftBarButtonItem = nil
        
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if ClassReachability.isConnectedToNetwork() {
            
            if(appDelegate().isUserOnline)
            {
               // self.parent?.title = "More"
                 ConectingHightConstraint.constant = CGFloat(0.0)
            }
            else
            {
                 Connectinglabel?.text = "Connecting..."
                //self.parent?.title = "Connecting.."
                 ConectingHightConstraint.constant = CGFloat(0.0)
            }
            
        } else {
           // self.parent?.title = "Waiting for network.."
            Connectinglabel?.text = "Waiting for network..."
            ConectingHightConstraint.constant = CGFloat(20.0)
        }
    }else{
            appDelegate().pageafterlogin = "more"
            appDelegate().idafterlogin = 0
            if ClassReachability.isConnectedToNetwork() {
                Connectinglabel?.text = "Connecting..."
                ConectingHightConstraint.constant = CGFloat(0.0)
            }else{
                Connectinglabel?.text = "Waiting for network..."
                ConectingHightConstraint.constant = CGFloat(20.0)
            }
              //ConectingHightConstraint.constant = CGFloat(0.0)
    }
       
         storyTableView.reloadData()
        if(appDelegate().isFromNewChat == false){
            appDelegate().toUserJID = ""
            
        }
        let pTeamId: Int64? = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
        let _: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? ""
        
        if (pTeamId! > 0)
        {
           
        }
        else{
            //Code to get my teams.
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
                appDelegate().GetmyTeam()
               
                
            }
        }
        
    }
    
    @objc func refreshChats()
    {
        storyTableView.reloadData()
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
      /*  if(indexPath.row == 0)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let myTeamsController : UpcomingTriviaViewController = storyBoard.instantiateViewController(withIdentifier: "upcommingtrivia") as! UpcomingTriviaViewController
            
            show(myTeamsController, sender: self)
        }
        else if(indexPath.row == 1)
        {
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let myTeamsController : FanUpdatesListViewController = storyBoard.instantiateViewController(withIdentifier: "FanUpdate") as! FanUpdatesListViewController
            
            //show(myTeamsController, sender: self)
            show(myTeamsController, sender: self)
        }
        else if(indexPath.row == 2)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let myTeamsController : NewsViewController = storyBoard.instantiateViewController(withIdentifier: "news") as! NewsViewController
            
            //show(myTeamsController, sender: self)
            show(myTeamsController, sender: self)
        }*/
         if(indexPath.row == 0)
        {
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : FixtureViewController! = storyBoard.instantiateViewController(withIdentifier: "Fixture") as? FixtureViewController
            show(registerController, sender: self)
        }
        /*else if(indexPath.row == 1)
        {
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : LeaderBoardViewController! = storyBoard.instantiateViewController(withIdentifier: "leaderboard") as? LeaderBoardViewController
            show(registerController, sender: self)
        }*/
        else if(indexPath.row == 1)
        {
            let registerController : ChatsViewController! = storyBoard.instantiateViewController(withIdentifier: "Chats") as? ChatsViewController
            show(registerController, sender: self)
        }
        else if(indexPath.row == 2)
        {
            let registerController : ContactsTableViewController! = storyBoard.instantiateViewController(withIdentifier: "Contacts") as? ContactsTableViewController
            show(registerController, sender: self)
        } else if(indexPath.row == 3)
        {
            let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
            
            show(settingsController, sender: self)
        }
        
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MoreCell = storyTableView!.dequeueReusableCell(withIdentifier: "morecell") as! MoreCell
        
        cell.itemName?.text = items[indexPath.row]
        
        cell.itemImage?.image = UIImage(named: itemsImage[indexPath.row])
         if(indexPath.row == 1)
        {
            let badgeCnt: Int = (appDelegate().badgeCount("chat")  as? Int)!
            
            if(badgeCnt > 0)
            {
                if(badgeCnt>99 && badgeCnt<1000){
                    cell.badgeCountsConstraint.constant = CGFloat(45.0)
                }
                else if(badgeCnt>999){
                    cell.badgeCountsConstraint.constant = CGFloat(65.0)
                }
                else{
                    cell.badgeCountsConstraint.constant = CGFloat(25.0)
                }
                cell.badgeCount?.isHidden = false
                cell.badgeCount?.text = String(badgeCnt)
                //cell.badgeCount?.sizeToFit()
                //cell.badgeCount?.frame.size = CGSize(width: (cell.badgeCount?.intrinsicContentSize.width)!, height: (cell.badgeCount?.frame.height)!)
                cell.badgeCount?.backgroundColor = UIColor.init(hex: "FFD401")//self.view.tintColor
                cell.badgeCount?.layer.masksToBounds = true;
                cell.badgeCount?.layer.borderWidth = 1.0
                cell.badgeCount?.layer.borderColor = UIColor.init(hex: "FFD401").cgColor
                cell.badgeCount?.layer.cornerRadius = 12.5
                
            }
            else
            {
                cell.badgeCount?.text = ""
                cell.badgeCount?.isHidden = true
            }
        }
         else
         {
            cell.badgeCount?.text = ""
            cell.badgeCount?.isHidden = true
        }
        return cell
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MoreViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MoreViewController.realDelegate!;
    }
}
