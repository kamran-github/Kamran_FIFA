//
//  MyFanUpdateViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 12/11/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire

class MyFanUpdateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "updates"
    var dictAllTeams = NSMutableArray()
    var lastposition = 0
    var returnToOtherView:Bool = false
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var totelteams = ""
    var SelectedTitel = ""
    var strings:[String] = []
    @IBOutlet weak var notelable: UILabel?
       let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
     var folowedusername = ""
    var arrMyFanUpdatesTeams:[AnyObject] = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        parent?.navigationItem.rightBarButtonItems = nil
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        //storyTableView?.rowHeight = UITableViewAutomaticDimension
        //storyTableView?.estimatedRowHeight = 480
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      arrMyFanUpdatesTeams = [AnyObject]()
        self.appDelegate().CreateFanUpdateFolder()
        self.appDelegate().CreateProfileFolder()
        
        let notificationName = Notification.Name("_MyFechedFanUpdateTeams")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fechedFanUpdateTeams), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("_MyFetchedFanUpdates")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedFanUpdates), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_MyFechedFanUpdate")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdate(_:)), name: notificationName3, object: nil)
        
        let notificationName1 = Notification.Name("_FanUpdateSaveLike")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.FanUpdateSaveLike), name: notificationName1, object: nil)
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdate(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        //  self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        
        
        var cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
        storyTableView!.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
        storyTableView!.separatorStyle = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //getFanUpdate(lastposition)
        let notifyresetmyStory = Notification.Name("resetmyStory")
               // Register to receive notification
               NotificationCenter.default.addObserver(self, selector: #selector(self.storyTablereload), name: notifyresetmyStory, object: nil)
        let mystoryblock = Notification.Name("mystoryblock")
              // Register to receive notification
              NotificationCenter.default.addObserver(self, selector: #selector(self.mystoryblock), name: mystoryblock, object: nil)
        let mystoryblockfail = Notification.Name("mystoryblockfail")
                   
                   NotificationCenter.default.addObserver(self, selector: #selector(self.blockuserfail), name: mystoryblockfail, object: nil)
        
        let contentmyStory = Notification.Name("contentmyStory")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.contentstoryTablereload), name: contentmyStory, object: nil)
    }
    @objc func blockuserfail(notification: NSNotification)
        {
            //let subtypevalue = (notification.userInfo?["savelike"] )as! NSDictionary
           // print(subtypevalue)
            //storyTableView?.reloadData()
            /* if(self.activityIndicator?.isAnimating)!
             {
             self.activityIndicator?.stopAnimating()
             }*/
            //storyTableView?.reloadData()
            DispatchQueue.main.async {
                self.alertWithTitle1(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
           }
        }
    @objc func mystoryblock()
       {
            self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          navigationController?.isNavigationBarHidden = false
        self.appDelegate().isUpdatesLoaded = false
        
        /*if(!(self.activityIndicator?.isAnimating)!)
         {
         self.activityIndicator?.startAnimating()
         }*/
        appDelegate().isOnMyFanStories = true
        appDelegate().isReturnToMyFanUpdateWindow = false
         if(folowedusername != ""){
        //self.parent?.title = "Posts"
            self.navigationItem.title = "Posts"
         }else{
           // self.parent?.title = "My Fan Stories"
            self.navigationItem.title = "My Fan Stories"
        }
         
        /* let settingsImage   = UIImage(named: "settings")!
         let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.showSettings))
         self.parent?.navigationItem.leftBarButtonItem = settingsButton*/
        self.navigationItem.rightBarButtonItem = nil
        
        
        //let button1 = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(FanUpdatesListViewController.ShowFilter(sender:)))
       // let rightSearchBarButtonItem:UIBarButtonItem = button1
        
        
        let button2 = UIBarButtonItem(image: UIImage(named: "add_update"), style: .plain, target: self, action: #selector(MyFanUpdateViewController.AddPost(sender:)))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2
        
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
        // lastposition = 0
          if(self.appDelegate().temparrMyFanUpdatesTeams.count>0) {
            arrMyFanUpdatesTeams = appDelegate().temparrMyFanUpdatesTeams
                appDelegate().temparrMyFanUpdatesTeams = []
            storyTableView?.reloadData()
        }
        
        let defalteamSelection: String? = UserDefaults.standard.string(forKey: "defalteamSelection")
        if((defalteamSelection) == nil)
        {
            ShowFilterByDefault()
            UserDefaults.standard.setValue("ishave", forKey: "defalteamSelection")
            UserDefaults.standard.synchronize()
        } else
        {
            if(returnToOtherView){
                if(folowedusername != ""){
                               getuserfanupdates(lastposition)
                           }
                           else{
                               getFanUpdate(lastposition)
                           }
            } else {
                if(arrMyFanUpdatesTeams.count == 0)
                {
                    lastposition = 0
                    if(appDelegate().isUserOnline)
                    {
                         if(folowedusername != ""){
                                       getuserfanupdates(lastposition)
                                   }
                                   else{
                                       getFanUpdate(lastposition)
                                   }
                    } else {
                       // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            // do stuff 3 seconds later
                            if(self.folowedusername != ""){
                                self.getuserfanupdates(self.lastposition)
                                       }
                                       else{
                                self.getFanUpdate(self.lastposition)
                                       }
                        }
                    }
                }
                
                 
            }
        }
        //pausePlayeVideos()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.playOn = false
         appDelegate().isOnMyFanStories = false
    }
    
    @objc func contentstoryTablereload()
        {
            DispatchQueue.main.async {
                self.arrMyFanUpdatesTeams = self.appDelegate().temparrMyFanUpdatesTeams
                self.appDelegate().temparrMyFanUpdatesTeams = []
               self.storyTableView?.reloadData()
           }
           
       }
    @objc func storyTablereload()
           {
               DispatchQueue.main.async {
                   //self.arrMyFanUpdatesTeams = self.appDelegate().temparrMyFanUpdatesTeams
                   //self.appDelegate().temparrMyFanUpdatesTeams = []
                  self.storyTableView?.reloadData()
              }
              
          }
    @objc func ShowFilter(sender:UIButton) {
        //print("Show Filter")
        let popController: CategoriesMultiTeamViewControlle = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryM") as! CategoriesMultiTeamViewControlle
        
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
        popController.teamType = "multi"
        //  popController.variableString = totelteams
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    func ShowFilterByDefault()
    {
         ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.playOn = false
        let popController: CategoriesMultiTeamViewControlle = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryM") as! CategoriesMultiTeamViewControlle
        
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
        popController.teamType = "multi"
        //  popController.variableString = totelteams
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    
    @objc func AddPost(sender:UIButton) {
        // print("Add post")
         ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.playOn = false
         if ClassReachability.isConnectedToNetwork() {
        showNewPostWindow()
        }
        else {
            //TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func getuserfanupdates(_ lastindex : Int)  {
           if ClassReachability.isConnectedToNetwork() {
               var dictRequest = [String: AnyObject]()
               dictRequest["cmd"] = "getuserfanupdates" as AnyObject
               dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
               dictRequest["device"] = "ios" as AnyObject
               /*if(appDelegate().arrMyFanUpdatesTeams.count == 0){
                   TransperentLoadingIndicatorView.show(self.view, loadingText: "")
               }*/
               Clslogging.logdebug(State: "getuserfanupdates start")
               if(lastindex == 0)
               {
                   
                   appDelegate().isMyFanPageRefresh = true
               } else
               {
                   appDelegate().isMyFanPageRefresh = false
               }
               do {
                   
                   /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                    let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                    print(strInvited)*/
                   //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                   //let arrReadUserJid = login?.components(separatedBy: "@")
                   //let userReadUserJid = arrReadUserJid?[0]
                   totelteams = ""
                  /* appDelegate().arrDataTeams =  appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
                   let teamselected = appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
                   if(teamselected.count == appDelegate().arrDataTeams.count){
                       totelteams = "all"
                   }
                   else if(teamselected.count == 0){
                       totelteams = "none"
                   }
                   else{
                       for cat in teamselected
                       {
                           
                           let team_Id =  (cat as! NSDictionary).value(forKey: "team_Id") as! String
                           if( totelteams == ""){
                               totelteams += "\(String(describing: team_Id))"
                           }
                           else{
                               totelteams += ",\(String(describing: team_Id))"
                           }
                       }
                   }*/
                   //Creating Request Data
                   var dictRequestData = [String: AnyObject]()
                   let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                   let arrdUserJid = myjid?.components(separatedBy: "@")
                   let userUserJid = arrdUserJid?[0]
                   
                   let myjidtrim: String? = userUserJid
                  // dictRequestData["teams"] = totelteams as AnyObject
                dictRequestData["followusername"] = folowedusername as AnyObject
                   dictRequestData["lastindex"] = lastindex as AnyObject
                   dictRequestData["username"] = myjidtrim as AnyObject
                   dictRequest["requestData"] = dictRequestData as AnyObject
                   //dictRequest.setValue(dictMobiles, forKey: "requestData")
                   //print(dictRequest)
                  /* let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                                   Clslogging.loginfo(State: "getuserfanupdates ", userinfo: json as [String : AnyObject])
                                                                                                                                   if(status1){DispatchQueue.main.async {
                                                                                                                                       let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                                                                      
                                                                                                                                                                                      if(self.appDelegate().isMyFanPageRefresh)
                                                                                                                                                                                      {
                                                                                                                                                                                          //arrFanUpdatesTeams
                                                                                                                                                                                       self.arrMyFanUpdatesTeams = response  as [AnyObject]
                                                                                                                                                                                      }
                                                                                                                                                                                      else
                                                                                                                                                                                      {
                                                                                                                                                                                       self.arrMyFanUpdatesTeams += response  as [AnyObject]
                                                                                                                                                                                      }
                                                                                                                                                                                      //print(arrFanUpdatesTeams.count)
                                                                                                                                                                                      // print(fanUpdates)
                                                                                                                                                                                      let notificationName = Notification.Name("_MyFechedFanUpdateTeams")
                                                                                                                                                                                      NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                      
                                                                                                                                                                                      
                                                                                                                                       }
                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else{
                                                                                                                                        DispatchQueue.main.async
                                                                                                                                            {
                                                                                                                                               if(self.appDelegate().isMyFanPageRefresh)
                                                                                                                                                                                                   {
                                                                                                                                                                                                       self.arrMyFanUpdatesTeams  = [AnyObject]()
                                                                                                                                                                                                       let notificationName = Notification.Name("_MyFechedFanUpdateTeams")
                                                                                                                                                                                                       NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                   } else
                                                                                                                                                                                                   {
                                                                                                                                                                                                       let notificationName = Notification.Name("_MyFetchedFanUpdates")
                                                                                                                                                                                                       NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                       
                                                                                                                                                                                                   }
                                                                                                                                        }
                                                                                                                                        //Show Error
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            case .failure(let error):
                                                                                         debugPrint(error as Any)
                                                                                        self.closeRefresh()
                                                                                         let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                                                       Clslogging.logerror(State: "getuserfanupdates", userinfo: errorinfo)
                                                                                        
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
                   closeRefresh()
                   let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                   Clslogging.logerror(State: "getuserfanupdates", userinfo: errorinfo)
               }
               Clslogging.logdebug(State: "getuserfanupdates End")
           }else {
               TransperentLoadingIndicatorView.hide()
               alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
               closeRefresh()
           }
       }
    func getFanUpdate(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getmyfanupdates" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            /*if(appDelegate().arrMyFanUpdatesTeams.count == 0){
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            }*/
            Clslogging.logdebug(State: "getmyfanupdates start")
            if(lastindex == 0)
            {
                
                appDelegate().isMyFanPageRefresh = true
            } else
            {
                appDelegate().isMyFanPageRefresh = false
            }
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
               /* totelteams = ""
                appDelegate().arrDataTeams =  appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
                let teamselected = appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
                if(teamselected.count == appDelegate().arrDataTeams.count){
                    totelteams = "all"
                }
                else if(teamselected.count == 0){
                    totelteams = "none"
                }
                else{
                    for cat in teamselected
                    {
                        
                        let team_Id =  (cat as! NSDictionary).value(forKey: "team_Id") as! String
                        if( totelteams == ""){
                            totelteams += "\(String(describing: team_Id))"
                        }
                        else{
                            totelteams += ",\(String(describing: team_Id))"
                        }
                    }
                }*/
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                
                let myjidtrim: String? = userUserJid
               // dictRequestData["teams"] = totelteams as AnyObject
                dictRequestData["lastindex"] = lastindex as AnyObject
                dictRequestData["username"] = myjidtrim as AnyObject
                dictRequest["requestData"] = dictRequestData as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
               /* let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                               Clslogging.loginfo(State: "getmyfanupdates ", userinfo: json as [String : AnyObject])
                                                                                                                               if(status1){DispatchQueue.main.async {
                                                                                                                                   let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                                                                  
                                                                                                                                                                                  if(self.appDelegate().isMyFanPageRefresh)
                                                                                                                                                                                  {
                                                                                                                                                                                      //arrFanUpdatesTeams
                                                                                                                                                                                   self.arrMyFanUpdatesTeams = response  as [AnyObject]
                                                                                                                                                                                  }
                                                                                                                                                                                  else
                                                                                                                                                                                  {
                                                                                                                                                                                   self.arrMyFanUpdatesTeams += response  as [AnyObject]
                                                                                                                                                                                  }
                                                                                                                                                                                  //print(arrFanUpdatesTeams.count)
                                                                                                                                                                                  // print(fanUpdates)
                                                                                                                                                                                  let notificationName = Notification.Name("_MyFechedFanUpdateTeams")
                                                                                                                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                  
                                                                                                                                                                                  
                                                                                                                                   }
                                                                                                                                    
                                                                                                                                }
                                                                                                                                else{
                                                                                                                                    DispatchQueue.main.async
                                                                                                                                        {
                                                                                                                                           if(self.appDelegate().isMyFanPageRefresh)
                                                                                                                                                                                               {
                                                                                                                                                                                                   self.arrMyFanUpdatesTeams  = [AnyObject]()
                                                                                                                                                                                                   let notificationName = Notification.Name("_MyFechedFanUpdateTeams")
                                                                                                                                                                                                   NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                               } else
                                                                                                                                                                                               {
                                                                                                                                                                                                   let notificationName = Notification.Name("_MyFetchedFanUpdates")
                                                                                                                                                                                                   NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                   
                                                                                                                                                                                               }
                                                                                                                                    }
                                                                                                                                    //Show Error
                                                                                                                                }
                                                                                                                            }
                                                                                                                        case .failure(let error):
                                                                                     debugPrint(error as Any)
                                                                                    self.closeRefresh()
                                                                                     let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                                                   Clslogging.logerror(State: "getlatestFanUpdate", userinfo: errorinfo)
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
                closeRefresh()
                let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                Clslogging.logerror(State: "getlatestFanUpdate", userinfo: errorinfo)
            }
            Clslogging.logdebug(State: "getmyfanupdates End")
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            closeRefresh()
        }
    }
   

    @objc func refreshFanUpdate(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
        appDelegate().isMyFanPageRefresh = true
        if ClassReachability.isConnectedToNetwork() {
            if(folowedusername != ""){
                getuserfanupdates(lastposition)
            }
            else{
                getFanUpdate(lastposition)
            }
            
        }
        else {
            closeRefresh()
            storyTableView?.setContentOffset(CGPoint.zero, animated: true)
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        
    }
    
    func closeRefresh()
    {
        if(refreshTable.isRefreshing)
        {
            refreshTable.endRefreshing()
        }
        else
        {
            /* if(self.activityIndicator?.isAnimating)!
             {
             self.activityIndicator?.stopAnimating()
             }*/
            TransperentLoadingIndicatorView.hide()
            
        }
        //storyTableView?.isScrollEnabled = true
    }
    
    @objc func showSettings() {
        //print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    
    func showCommentWindow(fanuid: Int64) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : CommentViewController! = storyBoard.instantiateViewController(withIdentifier: "Comment") as? CommentViewController
        registerController.fanupdateid = fanuid
        registerController.SelectedTitel = SelectedTitel
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }
    
    func showEditWindow(dict: NSDictionary) {
         ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.playOn = false
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : EditFanUpdateViewController! = storyBoard.instantiateViewController(withIdentifier: "EditFanUpdate") as? EditFanUpdateViewController
        registerController.dict = dict
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }
    
    
    func showLikeWindow(fanuid: Int64) {
         ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.playOn = false
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : LikeViewController! = storyBoard.instantiateViewController(withIdentifier: "likes") as? LikeViewController
        registerController.fanupdateid = fanuid
        registerController.SelectedTitel = SelectedTitel
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }
    
    
    func showNewPostWindow() {
        appDelegate().isReturnToMyFanUpdateWindow = true
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : NewFanUpdateViewController! = storyBoard.instantiateViewController(withIdentifier: "newpost") as? NewFanUpdateViewController
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }
    
    @objc func FanUpdateSaveLike(notification: NSNotification)
    {
        _ = (notification.userInfo?["savelike"] )as! NSDictionary
       // print(subtypevalue)
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        //storyTableView?.reloadData()
    }
    
    @objc func fechedFanUpdateTeams()
    {
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(arrMyFanUpdatesTeams.count == 0){
            
            notelable?.isHidden = false
            storyTableView?.reloadData()
            storyTableView?.isHidden = false
            var bullet1: String = ""
                       var bullet2: String = ""
                       
                        bullet1 = "Sorry, you have not posted any update yet."
                        bullet2 = "Please try posting an update by tapping ‘+’ icon on top right corner of this screen."
                       if(folowedusername != ""){
                           let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                           let arrdUserJid = myjid?.components(separatedBy: "@")
                           let userUserJid = arrdUserJid?[0]
                           if(userUserJid != folowedusername)
                           {
                               bullet1 = "Posts unavailable as they are reported for abuse."
                               bullet2 = ""
                           }
                       }
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
            
        }
        else{
            notelable?.isHidden = true
            storyTableView?.reloadData()
            storyTableView?.isHidden = false
            pausePlayeVideos()
        }
    }
    
    @objc func fetchedFanUpdates()
    {
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(arrMyFanUpdatesTeams.count == 0){
            
            notelable?.isHidden = false
            
            storyTableView?.isHidden = true
            var bullet1: String = ""
            var bullet2: String = ""
            
             bullet1 = "Sorry, you have not posted any update yet."
             bullet2 = "Please try posting an update by tapping ‘+’ icon on top right corner of this screen."
            if(folowedusername != ""){
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                if(userUserJid == folowedusername)
                {
                    bullet1 = "Posts unavailable as they are reported for abuse."
                    bullet2 = ""
                }
            }
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
            
        }
        else{
            notelable?.isHidden = true
            
            storyTableView?.isHidden = false
        }
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
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MyFanUpdateViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MyFanUpdateViewController.realDelegate!;
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
        //print(appDelegate().arrMyFanUpdatesTeams.count)
        return arrMyFanUpdatesTeams.count
    }
    @objc func MenuClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
         
          if(arrMyFanUpdatesTeams.count > 0){
              let dict: NSDictionary? = self.arrMyFanUpdatesTeams[longPressGestureRecognizer.view!.tag] as? NSDictionary
              let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
             
             
              let NobodyAction = UIAlertAction(title: "Report & Block Content", style: .default, handler: {
                  (alert: UIAlertAction!) -> Void in
                  //print("Choose Photo")
                  //Code to show gallery
                  let login: String? = UserDefaults.standard.string(forKey: "userJID")
                         if(login != nil){
                          let myjid =   dict?.value(forKey: "username") as! String
                          let arrdUserJid = myjid.components(separatedBy: "@")
                          let userUserJid = arrdUserJid[0]
                            self.appDelegate().temparrMyFanUpdatesTeams = self.arrMyFanUpdatesTeams
                 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let myTeamsController : ReportViewController = storyBoard.instantiateViewController(withIdentifier: "report") as! ReportViewController
                  myTeamsController.contentid =  dict?.value(forKey: "id") as! Int64
                           myTeamsController.s_owner =  userUserJid
                                //show(myTeamsController, sender: self)
                          
                          //New code by Ravi to pass Title as well 08-02-2020
                          let messageContent = dict?.value(forKey: "message")as! String
                          
                          if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                          {
                              do {
                                  let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                  
                                  let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                                  let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                                  myTeamsController.contenttitle = decodedString1
                                  
                                  
                              } catch let error as NSError {
                                  print(error)
                              }
                              
                          }
                          
                          //End
                          
                          
                                self.show(myTeamsController, sender: self)
                 }
                        else{
                          self.appDelegate().LoginwithModelPopUp()
                        }
                  
              })
              let blockAction = UIAlertAction(title: "Block Fan", style: .default, handler: {
                                        (alert: UIAlertAction!) -> Void in
                                        //print("Choose Photo")
                                        //Code to show gallery
                                        let login: String? = UserDefaults.standard.string(forKey: "userJID")
                                               if(login != nil){
                                                  let name:String = self.appDelegate().ExistingContact(username: (dict?.value(forKey: "username") as? String)!)!
                                                  let alert = UIAlertController(title: nil, message: "Blocking \"\(name)\" will block all their content.\n\nDo you really want to block this fan?", preferredStyle: .alert)
                                                               let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                                                                   
                                                               });
                                                               let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                                                  let login: String? = dict?.value(forKey: "username") as? String
                                                                                let arrReadUserJid = login?.components(separatedBy: "@")
                                                                                let userReadUserJid = arrReadUserJid?[0]
                                                                                
                                                                                let myMobile: String? = userReadUserJid
                                                                                  self.appDelegate().fanstoryUserBlock(blockuser: myMobile!)
                                                                  });
                                                                              alert.addAction(action)
                                                                              alert.addAction(action1)
                                                                              self.present(alert, animated: true, completion:nil)
                                                                              
                                      
                                       }
                                              else{
                                                self.appDelegate().LoginwithModelPopUp()
                                              }
                                        
                                    })
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                  (alert: UIAlertAction!) -> Void in
                  //print("Cancelled")
                  
                   //self.storyTableView?.reloadData()
              })
             
              optionMenu.addAction(NobodyAction)
               optionMenu.addAction(blockAction)
              optionMenu.addAction(cancelAction)
              
              self.present(optionMenu, animated: true, completion: nil)
          }
         
      }
    @objc func LikeClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
                //print(dict)likecount
                let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
                let Likedcount: Int32 = dict?.value(forKey: "likecount") as! Int32
                if let cell: FanUpdatesCell = storyTableView!.cellForRow(at: indexPath as IndexPath) as? FanUpdatesCell{
                    
                if(isLiked){
                    
                    var dict1: [String: AnyObject] = arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                    dict1["liked"] = 0 as AnyObject
                    dict1["likecount"] = Likedcount-1 as AnyObject
                   arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                    cell.likeImage.image = UIImage(named: "like")
                    cell.likeText?.setTitle("Like", for: .normal)
                    let lcount =  Likedcount - 1 as Int32
                    
                    if(lcount < 2)
                    {
                        cell.LikeCount?.text = "\(self.appDelegate().formatNumber(Int(lcount ))) Like"
                        
                    }
                    else{
                        cell.LikeCount?.text = "\(self.appDelegate().formatNumber(Int(lcount ))) Likes"
                        
                    }
                    
                }
                else{
                    var dict1: [String: AnyObject] = arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                    dict1["liked"] = 1 as AnyObject
                    dict1["likecount"] = Likedcount + 1 as AnyObject
                    arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                    cell.likeImage.image = UIImage(named: "like")
                    cell.likeText?.setTitle("Like", for: .normal)
                    let lcount =  Likedcount + 1 as Int32
                    
                    if(lcount < 2)
                    {
                        cell.LikeCount?.text = "\(self.appDelegate().formatNumber(Int(lcount ))) Like"
                        
                    }
                    else{
                        cell.LikeCount?.text = "\(self.appDelegate().formatNumber(Int(lcount ))) Likes"
                        
                    }
                }
                    //updateLikecount(fanuid: dict?.value(forKey: "id") as! Int64)
                }
                
                fechedFanUpdateTeams()
                //print(dict?.value(forKey: "username"))liked
                
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "savelike" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
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
                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                    
                    
                    let myjidtrim: String? = userUserJid
                    dictRequestData["fanupdateid"] = dict?.value(forKey: "id") as AnyObject
                    dictRequestData["time"] = time as AnyObject
                    dictRequestData["username"] = myjidtrim as AnyObject
                    dictRequest["requestData"] = dictRequestData as AnyObject
                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                    //print(dictRequest)
                   /* let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                                 if(status1){DispatchQueue.main.async {
                                                                                                                                     let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                     
                                                                                                                                     let dic = response[0] as! NSDictionary
                                                                                                                                     self.appDelegate().updateLikecount(fanuid: dict?.value(forKey: "id") as! Int64, likecount: json["likecount"] as! Int64, commentcount: json["commentcount"] as! Int64, viewcount: json["viewcount"] as! Int64, islike: dic.value(forKey: "liked") as! Bool)
                                                                                                                                     }
                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else{
                                                                                                                                        DispatchQueue.main.async
                                                                                                                                            {
                                                                                                                                                
                                                                                                                                        }
                                                                                                                                        //Show Error
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            case .failure(let error):
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
                }
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
            
        }
        
    }
    
    @objc func CommentClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
                // print(dict)
                // print(dict?.value(forKey: "username"))
                let fanupdateid = dict?.value(forKey: "id") as! Int64
                //returnToOtherView = true
                let messageContent = dict?.value(forKey: "message")as! String
                
                if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                {
                    do {
                        let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                        let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                        let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                        
                        SelectedTitel = decodedString1//(jsonDataMessage?.value(forKey: "title") as? String)!
                        
                        
                    } catch let error as NSError {
                        print(error)
                    }
                    
                }
                 appDelegate().temparrMyFanUpdatesTeams = arrMyFanUpdatesTeams
                showCommentWindow(fanuid: fanupdateid)
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
            
        }
    }
    @objc func LikeCountClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Count Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
                // print(dict)
                // print(dict?.value(forKey: "username"))
                let fanupdateid = dict?.value(forKey: "id") as! Int64
                //returnToOtherView = true
                let messageContent = dict?.value(forKey: "message")as! String
                
                if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                {
                    do {
                        let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                        let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                        let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                        
                        SelectedTitel = decodedString1//(jsonDataMessage?.value(forKey: "title") as? String)!
                        
                        
                    } catch let error as NSError {
                        print(error)
                    }
                    
                }
                showLikeWindow(fanuid: fanupdateid)
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
        }
        
    }
    
    @objc func EditClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
       // print("Edit Click")
        if ClassReachability.isConnectedToNetwork() {
        appDelegate().isReturnToMyFanUpdateWindow = true
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
            showEditWindow(dict: dict!)
            
        }
        }
               else {
                   alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                   
               }
    }
    
    @objc func DeleteClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
       // print("Delete Click")
         if ClassReachability.isConnectedToNetwork() {
        let touchPoint = longPressGestureRecognizer.location(in: self.storyTableView)
        if let indexPath = self.storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = self.arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                // print(dict)
                // print(dict?.value(forKey: "username"))
                let fanupdateid = dict?.value(forKey: "id") as! Int64
                
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "deletefanupdate" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                  
                do {
                    
                    
                    //Creating Request Data
                    var dictRequestData = [String: AnyObject]()
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    //let time: Int64 = self.appDelegate().getUTCFormateDate()
                    
                    
                    let myjidtrim: String? = userUserJid
                    dictRequestData["fanupdateid"] = fanupdateid as AnyObject
                    dictRequestData["username"] = myjidtrim as AnyObject
                    dictRequest["requestData"] = dictRequestData as AnyObject
                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                    //print(dictRequest)
                    
                   /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                    //print(strFanUpdates)
                    self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)*/
                   /* let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                                                                                                      Clslogging.loginfo(State: "savefanupdates", userinfo: json as [String : AnyObject])
                                                                                                                                                                                                       if(status1){
                                                                                                                                                                                                           if(self.appDelegate().isOnMyFanStories){
                                                                                                                                                                                                                                                              let notificationName = Notification.Name("_MyFechedFanUpdate")
                                                                                                                                                                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                          }
                                                                                                                                                                                                           else if(self.appDelegate().isOnFanDetail){
                                                                                                                                                                                                                                                              let notificationName = Notification.Name("_fanupdatedelete")
                                                                                                                                                                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                          }
                                                                                                                                                                                                                                                          else{
                                                                                                                                                                                                                                                              let notificationName = Notification.Name("_FechedFanUpdate")
                                                                                                                                                                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                          }
                                                                                                                                                                                                       }
                                                                                                                                                                                                       else{
                                                                                                                                                                                                           if(self.appDelegate().isOnMyFanStories){
                                                                                                                                                                                                                                                                  let notificationName = Notification.Name("_MyFechedFanUpdate")
                                                                                                                                                                                                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                              else{
                                                                                                                                                                                                                                                                  let notificationName = Notification.Name("_FechedFanUpdate")
                                                                                                                                                                                                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                       }
                                                                                                                                                                                                   }
                                                                                                                                                                                               case .failure(let error):
                                                                                                                                                        debugPrint(error as Any)
                                                                                                                                                        if(self.appDelegate().isOnMyFanStories){
                                                                                                                                                                                                              let notificationName = Notification.Name("_MyFechedFanUpdate")
                                                                                                                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                          }
                                                                                                                                                                                                          else{
                                                                                                                                                                                                              let notificationName = Notification.Name("_FechedFanUpdate")
                                                                                                                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                          }
                                                                                                                                                        break
                                                                                                                                                                                                   // error handling
                                                                                                                                                                                    
                                                                                                                                                                                               }                                                                  }
                } catch {
                    print(error.localizedDescription)
                }
                
                
            });
            let action1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default,handler: {_ in
            });
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion:nil)
        }
        }
               else {
                   alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                   
               }
        
    }
    
    
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
            // print(dict)
            // print(dict?.value(forKey: "username"))
            do {
                let fanupdateid = dict?.value(forKey: "id") as! Int64
                var dictRequest = [String: AnyObject]()
                dictRequest["id"] = fanupdateid as AnyObject
                dictRequest["type"] = "fanupdate" as AnyObject
                let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                
                let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                
                let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                
                let messageContent = dict?.value(forKey: "message")as! String
                
                if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                {
                    do {
                        let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                        let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                        let decodedString = String(data: decodedData1, encoding: .utf8)!
                        
                        let title = decodedString
                        
                        let param = resultNSString as String?
                        
                        let inviteurl = InviteHost + "?q=" + param!
                        
                             let text = "\(title)\n\nFan Story shared via Football Fan App.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."
                                                        //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                                                      
                                                        let objectsToShare = [text] as [Any]
                                                                                              let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                                                              
                                                                                              //New Excluded Activities Code
                                                                                              activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                                                                              //
                                                                                              
                                                                                      activityVC.popoverPresentationController?.sourceView = self.view
                                                                                              self.present(activityVC, animated: true, completion: nil)
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            /* let dict: NSDictionary? = appDelegate().arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
             let messageContent = dict?.value(forKey: "message")as! String
             
             if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
             {
             do {
             let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
             
             let selMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
             let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
             let arrReadselVideoPath = selVideoPath.components(separatedBy: "/")
             let imageId = arrReadselVideoPath.last
             let arrReadimageId = imageId?.components(separatedBy: ".")
             
             let url = NSURL(string: selVideoPath)!
             
             if(selMessageType == "text")
             {
             //cell.ContentText?.text = "Hello" //jsonDataMessage?.value(forKey: "value") as? String
             let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
             let decodedString = String(data: decodedData, encoding: .utf8)!
             
             let shareAll = [decodedString] as [Any]
             let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
             activityViewController.popoverPresentationController?.sourceView = self.view
             self.present(activityViewController, animated: true, completion: nil)
             }
             else if(selMessageType == "image")
             {
             //let mediaURL = message.value(forKey: "filePath") as! String
             //let asset: PHAsset = PHAssetForFileURL(url: NSURL(string: mediaURL)!)!
             let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".png")
             
             do {
             let fileManager = FileManager.default
             //try fileManager.removeItem(atPath: imageId)
             // Check if file exists
             if fileManager.fileExists(atPath: paths) {
             // Delete file
             //  print("File  exist")
             
             var caption: String = ""
             if let capText = jsonDataMessage?.value(forKey: "caption")
             {
             caption = capText as! String
             }
             
             if(!caption.isEmpty)
             {
             let decodedData = Data(base64Encoded: caption)!
             let decodedString = String(data: decodedData, encoding: .utf8)!
             caption = decodedString
             }
             
             let image = UIImage(contentsOfFile: paths)
             //let text = "This is the text...."
             //let image = UIImage(named: "share")
             //let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
             let shareAll = [image!] as [Any]
             let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
             activityViewController.popoverPresentationController?.sourceView = self.view
             self.present(activityViewController, animated: true, completion: nil)
             } else {
             //print("File does not exist")
             let cell = storyTableView?.cellForRow(at: indexPath) as! FanUpdatesCell
             let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height))
             //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
             cell.ContentImage?.addSubview(overlay)
             LoadingIndicatorView.show(cell.ContentImage!, loadingText: "Downloading Image...")
             
             
             var dict1: [String: AnyObject] = appDelegate().arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
             dict1["status"] = "downloading" as AnyObject
             appDelegate().arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
             let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
             // if responseData is not null...
             if let data = responseData{
             
             // execute in UI thread
             DispatchQueue.main.async(execute: { () -> Void in
             //let tmpImg = UIImage(data: data)
             //Store image to local path
             //self.saveImageToLocalWithName(UIImage(data: data)!,fileName: "")
             //let uuid = UUID().uuidString
             let filePath = self.saveImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: arrReadimageId![0])
             
             // print(filePath)
             var dict1: [String: AnyObject] = self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
             dict1["status"] = "exist" as AnyObject
             self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
             LoadingIndicatorView.hide()
             cell.PlayImage?.image = UIImage(named: "uncheck")
             cell.ContentImage?.removeAllSubviews()
             
             })
             }
             
             }
             
             // Run task
             task.resume()
             //End Code to fetch media from live URL
             
             }
             
             }
             catch let error as NSError {
             print("An error took place: \(error)")
             LoadingIndicatorView.hide()
             }
             
             
             }
             else if(selMessageType == "video")
             {
             
             do {
             
             let documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".mp4")
             let filePath = "file://" + documentsPath;
             
             
             let fileManager = FileManager.default
             //try fileManager.removeItem(atPath: imageId)
             // Check if file exists
             if fileManager.fileExists(atPath: documentsPath) {
             // Delete file
             // print("File  exist")
             
             
             //let image = UIImage(contentsOfFile: paths)
             //let text = "This is the text...."
             //let image = UIImage(named: "share")
             var caption: String = ""
             if let capText = jsonDataMessage?.value(forKey: "caption")
             {
             caption = capText as! String
             }
             
             if(!caption.isEmpty)
             {
             let decodedData = Data(base64Encoded: caption)!
             let decodedString = String(data: decodedData, encoding: .utf8)!
             caption = decodedString
             }
             
             let videoLink = NSURL(fileURLWithPath: documentsPath)
             
             //let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
             let shareAll = [videoLink] as [Any]
             let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
             activityViewController.popoverPresentationController?.sourceView = self.view
             self.present(activityViewController, animated: true, completion: nil)
             } else {
             let cell = storyTableView?.cellForRow(at: indexPath) as! FanUpdatesCell
             let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height))
             //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
             cell.ContentImage?.addSubview(overlay)
             LoadingIndicatorView.show(cell.ContentImage!, loadingText: "\n Downloading Video...")
             
             
             var dict1: [String: AnyObject] = appDelegate().arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
             dict1["status"] = "downloading" as AnyObject
             appDelegate().arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
             let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
             // if responseData is not null...
             if let data = responseData{
             // print(responseUrl ?? "")
             // print(data)
             // execute in UI thread
             DispatchQueue.main.async(execute: { () -> Void in
             //let tmpImg = UIImage(data: data)
             //Store image to local path
             //self.saveImageToLocalWithName(UIImage(data: data)!,fileName: fileName)
             
             do
             {
             try data.write(to: NSURL(string:filePath)! as URL, options: NSData.WritingOptions.atomicWrite)
             //print(filePath)
             //print(url)
             var dict1: [String: AnyObject] = self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
             dict1["status"] = "exist" as AnyObject
             self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
             LoadingIndicatorView.hide()
             cell.ContentImage?.removeAllSubviews()
             cell.PlayImage?.image = UIImage(named: "play")
             
             }
             catch let error as NSError {
             print("An error took place: \(error)")
             LoadingIndicatorView.hide()
             cell.ContentImage?.removeAllSubviews()
             }
             })
             }
             
             }
             
             // Run task
             task.resume()
             //End Code to fetch media from live URL
             }
             }
             }
             
             }  catch let error as NSError {
             print(error)
             }
             } */
        }
        
    }
    @objc func Showchat(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
            // print(dict)
            // print(dict?.value(forKey: "username"))
            // Configure the cell...
            let messageContent = dict?.value(forKey: "message")as! String
            
            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                do {
                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                    
                    let _: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                    if(jsonDataMessage?.value(forKey: "subtype") == nil)
                    {
                        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                        let arrdUserJid = myjid?.components(separatedBy: "@")
                        let userUserJid = arrdUserJid?[0]
                       // if(userUserJid != dict?.value(forKey: "username") as? String)
                        //{
                            //appDelegate().toUserJID = (dict?.value(forKey: "username") as? String)! + JIDPostfix//(dict?.value(forKey: "jid") as? String)!
                            //appDelegate().toName = appDelegate().ExistingContact(username: (dict?.value(forKey: "username") as? String)!)!//(dict?.value(forKey: "username") as? String)!
                            if let tmpAvatar = dict?.value(forKey: "avatar")
                            {
                                appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
                            }
                            else
                            {
                                appDelegate().toAvatarURL = ""
                            }
                           // showChatWindow()
                             showChatWindow(roomid: (dict?.value(forKey: "username") as? String)! + JIDPostfix)
                       // }
                    }
                    else{
                        let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                        if(subtype.contains("post")){
                            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                            let arrdUserJid = myjid?.components(separatedBy: "@")
                            let userUserJid = arrdUserJid?[0]
                            //if(userUserJid != dict?.value(forKey: "username") as? String)
                           // {
                                //appDelegate().toUserJID = (dict?.value(forKey: "username") as? String)! + JIDPostfix//(dict?.value(forKey: "jid") as? String)!
                                //appDelegate().toName = appDelegate().ExistingContact(username: (dict?.value(forKey: "username") as? String)!)!//(dict?.value(forKey: "username") as? String)!
                                if let tmpAvatar = dict?.value(forKey: "avatar")
                                {
                                    appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
                                }
                                else
                                {
                                    appDelegate().toAvatarURL = ""
                                }
                                showChatWindow(roomid: (dict?.value(forKey: "username") as? String)! + JIDPostfix)
                            //}
                        }
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }
    }
    func showChatWindow(roomid: String) {
         /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
          let registerController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "Chat")
          //present(registerController as! UIViewController, animated: true, completion: nil)
          self.appDelegate().curRoomType = "chat"
          appDelegate().isBanterClosed = ""
          show(registerController as! UIViewController, sender: self)*/
          let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                      let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                                     myTeamsController.RoomJid = roomid//dict.value(forKey: "jid") as! String //+ JIDPostfix
                                                      show(myTeamsController, sender: self)
         
      }
   
    @objc func ShowPreviewClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
         if ClassReachability.isConnectedToNetwork() {
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
            // print(dict)
            // print(dict?.value(forKey: "username"))
            // Configure the cell...
             self.appDelegate().updateViewCount("fanupdate", id: dict?.value(forKey: "id") as! Int64)
           
            var dict1: [String: AnyObject] = arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
            var vcount = dict?.value(forKey: "viewcount") as? Int
            
            dict1["viewcount"] = vcount!+1 as AnyObject
            arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
            vcount = vcount! + 1
            if let cell: FanUpdatesCell = storyTableView!.cellForRow(at: indexPath as IndexPath) as? FanUpdatesCell{
                
                
                if(vcount ?? 0 < 2)
                {
                    cell.ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) View"
                    
                }
                else{
                    cell.ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"
                    
                }
            }
            let messageContent = dict?.value(forKey: "message")as! String
            
            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                do {
                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                    
                    let selMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                    let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                   // let arrReadselVideoPath = selVideoPath.components(separatedBy: "/")
                   // let imageId = arrReadselVideoPath.last
                   // let arrReadimageId = imageId?.components(separatedBy: ".")
                    //print(userReadselVideoPath)
                    //let selMessageType = dict?.value(forKey: "type") as! String
                    // let selVideoPath = dict?.value(forKey: "value") as! String
                    //var imageId = message.value(forKey: "filePath") as! String
                    
                    //let fileManager = FileManager.default
                    //imageId = imageId.replace(target: "file://", withString: "")
                    //let url = NSURL(string: selVideoPath)!
                    
                    
                    if(selMessageType == "image")
                    {
                        
                        /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                         let previewController : Previewmidia! = storyBoard.instantiateViewController(withIdentifier: "Previewmidia") as! Previewmidia
                         previewController.videoURL = selVideoPath//videos[indexPath.row]
                         previewController.mediaType = "image"
                         //show(previewController!, sender: self)
                         self.present(previewController, animated: true, completion: nil)*/
                        var media = [AnyObject]()
                        media.append(LightboxImage(
                            imageURL: NSURL(string: selVideoPath)! as URL,
                            text: ""
                        ))
                        if(media.count>0)
                        {
                            appDelegate().isFromPreview = true
                            let controller = LightboxController(images: media as! [LightboxImage], startIndex: 0)
                            
                            // Set delegates.
                            controller.pageDelegate = self as? LightboxControllerPageDelegate
                            //controller.dismissalDelegate = self
                            
                            // Use dynamic background.
                            controller.dynamicBackground = true
                            //controller.currentPage = 2
                            // Present your controller.
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                    else if(selMessageType == "video")
                    {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                       /* let previewController : Previewmidia! = storyBoard.instantiateViewController(withIdentifier: "Previewmidia") as? Previewmidia*/
                        var videoURL = ""
                                                 
                        if(appDelegate().GetvalueFromInsentiveConfigTable(Key: isstream)).boolValue{
                            if let smillink = jsonDataMessage?.value(forKey: "smillink")
                            {
                                
                                var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                if(selVideoPath.isEmpty){
                                    selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                    // cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                                    videoURL = selVideoPath
                                }
                                else{
                                    //cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                                    videoURL = selVideoPath
                                }
                                
                            }
                            else{
                                let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                // cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                                videoURL = selVideoPath
                            }
                        }
                        else{
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            // cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                            videoURL = selVideoPath
                        }
                        //previewController.videoURL = selVideoPath//videos[indexPath.row]
                        let urlvalue = URL(string:videoURL)
                                                                                                                                         let yourplayer = AVPlayer(url: urlvalue!)

                                                                                                                                         //Create player controller and set it’s player
                                                                                                                                         //let playerController = LandscapePlayer()
                                                                                                                                         let playerController = AVPlayerViewController()
                                                                                                                                         playerController.player = yourplayer
                                                                                                                                        
                                                                                                                                         //Final step To present controller  with player in your view controller
                                                                                                                                         present(playerController, animated: true, completion: {
                                                                                                                                            playerController.player!.play()
                                                                                                                                         })
                      /*  previewController.mediaType = "video"
                        show(previewController!, sender: self)*/
                         //self.present(previewController, animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        }
                     else {
                         alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                         
                     }
    }
    
    func saveImageToLocalWithNameReturnPath(_ image: UIImage, fileName: String) -> String{
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + fileName + ".png")
        //print(paths)
        if(fileManager.fileExists(atPath: paths))
        {
           // print(paths)
        }
        else
        {
            let imageData = image.jpegData(compressionQuality: 1)
            
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        }
        
        return "file://" + paths
    }
    
    func saveFanImageToLocalWithNameReturnPath(_ image: UIImage, fileName: String) -> String{
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + fileName + ".png")
        //print(paths)
        if(fileManager.fileExists(atPath: paths))
        {
            //print(paths)
        }
        else
        {
            let imageData = image.jpegData(compressionQuality: 1)
            
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        }
        
        return "file://" + paths
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(arrMyFanUpdatesTeams.count > 19)
        {
            
            let lastElement = arrMyFanUpdatesTeams.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                 if ClassReachability.isConnectedToNetwork() {
                lastposition = lastposition + 1
                   if(folowedusername != ""){
                                    getuserfanupdates(lastposition)
                                }
                                else{
                                    getFanUpdate(lastposition)
                                }
                }
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if(folowedusername != ""){
             let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
             let isblocked = dict?.value(forKey: "isblocked") as! Bool
            
             if(isblocked){
                 
                 let cell = tableView.dequeueReusableCell(withIdentifier: "fanstoryblock", for: indexPath) as! SettingsCell//UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "fanstoryblock")
                 //set the data here
                 storyTableView?.rowHeight = CGFloat(200)
                 return cell
             }
             else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FanUpdatesCell
                    
                    
                    let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    let longPressGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture2.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    cell.like?.addGestureRecognizer(longPressGesture)
                    cell.like?.isUserInteractionEnabled = true
                    
                    cell.likeImage?.addGestureRecognizer(longPressGesture1)
                    cell.likeImage?.isUserInteractionEnabled = true
                    
                    cell.likeText?.addGestureRecognizer(longPressGesture2)
                    cell.likeText?.isUserInteractionEnabled = true
                    
                    
                    let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_share2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_share2.delegate = self as? UIGestureRecognizerDelegate
                    
                    cell.share?.addGestureRecognizer(longPressGesture_share)
                    cell.share?.isUserInteractionEnabled = true
                    
                    cell.shareImage?.addGestureRecognizer(longPressGesture_share1)
                    cell.shareImage?.isUserInteractionEnabled = true
                    
                    cell.shareText?.addGestureRecognizer(longPressGesture_share2)
                    cell.shareText?.isUserInteractionEnabled = true
                    
                    
                  /*  let PressGesture_sound:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(soundClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    PressGesture_sound.delegate = self as? UIGestureRecognizerDelegate
                    cell.soundImg?.addGestureRecognizer(PressGesture_sound)
                    cell.soundImg?.isUserInteractionEnabled = true*/
                    
                    let longPressGesture_comment:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_comment.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_comment1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_comment1.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_comment2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_comment2.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    let longPressGesture_comment3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_comment3.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    cell.comment?.addGestureRecognizer(longPressGesture_comment)
                    cell.comment?.isUserInteractionEnabled = true
                    
                    cell.commentImage?.addGestureRecognizer(longPressGesture_comment1)
                    cell.commentImage?.isUserInteractionEnabled = true
                    
                    cell.commentText?.addGestureRecognizer(longPressGesture_comment2)
                    cell.commentText?.isUserInteractionEnabled = true
                    
                    
                    cell.CommentCount?.addGestureRecognizer(longPressGesture_comment3)
                    cell.CommentCount?.isUserInteractionEnabled = true
                    
                    
                    let longPressGesture_like_count:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeCountClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_like_count.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    cell.LikeCount?.addGestureRecognizer(longPressGesture_like_count)
                    cell.LikeCount?.isUserInteractionEnabled = true
                    
                    
                    let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
                    
                    cell.PlayImage?.addGestureRecognizer(longPressGesture_showpreview)
                    cell.PlayImage?.isUserInteractionEnabled = true
                    
                    
                    cell.ContentImage?.addGestureRecognizer(longPressGesture_showpreview1)
                    cell.ContentImage?.isUserInteractionEnabled = true
                    
                    
                    let longPressGesture_editUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
                    longPressGesture_editUpdate.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_editUpdate1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
                    longPressGesture_editUpdate1.delegate = self as? UIGestureRecognizerDelegate
                    
                    let longPressGesture_editUpdate2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
                    longPressGesture_editUpdate2.delegate = self as? UIGestureRecognizerDelegate
                    
                    cell.editUpdate?.addGestureRecognizer(longPressGesture_editUpdate)
                    cell.editUpdate?.isUserInteractionEnabled = true
                    
                    cell.editImage?.addGestureRecognizer(longPressGesture_editUpdate1)
                    cell.editImage?.isUserInteractionEnabled = true
                    
                    cell.editView?.addGestureRecognizer(longPressGesture_editUpdate2)
                    cell.editView?.isUserInteractionEnabled = true
                    
                    
                    let longPressGesture_deleteUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
                    longPressGesture_deleteUpdate.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    let longPressGesture_deleteUpdate1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
                    longPressGesture_deleteUpdate1.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    let longPressGesture_deleteUpdate2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
                    longPressGesture_deleteUpdate2.delegate = self as? UIGestureRecognizerDelegate
                    
                    cell.deleteUpdate?.addGestureRecognizer(longPressGesture_deleteUpdate)
                    cell.deleteUpdate?.isUserInteractionEnabled = true
                   
                    cell.deleteImage?.addGestureRecognizer(longPressGesture_deleteUpdate1)
                    cell.deleteImage?.isUserInteractionEnabled = true
                    
                    cell.deleteView?.addGestureRecognizer(longPressGesture_deleteUpdate2)
                    cell.deleteView?.isUserInteractionEnabled = true
                    let longPressGesture_block:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuClick(_:)))
                           longPressGesture_block.delegate = self as? UIGestureRecognizerDelegate
                    cell.imgmenu?.tag = indexPath.row
                           cell.imgmenu?.addGestureRecognizer(longPressGesture_block)
                           cell.imgmenu?.isUserInteractionEnabled = true
                          
                    
                    // Configure the cell...
                    
                        //print(dict)
                        let fanname = appDelegate().ExistingContact(username: (dict?.value(forKey: "username") as? String)!)
                        
                        if(fanname == "You")
                        {
                            cell.editView.isHidden = false
                            cell.deleteView.isHidden = false
                            cell.imgmenu?.isHidden = true
                        } else
                        {
                            cell.editView.isHidden = true
                            cell.deleteView.isHidden = true
                             cell.imgmenu?.isHidden = false
                        }
                        
                        
                        cell.fanName?.text = fanname
                        let lcount = dict?.value(forKey: "likecount") as? Int
                        if(lcount ?? 0 < 2)
                        {
                          cell.LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Like"
                            
                        }
                        else{
                          cell.LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Likes"
                            
                        }
                        //"\(appDelegate().formatPoints(num: 10666660.00 ?? 0) ) Likes"
                        let ccount = dict?.value(forKey: "commentcount") as? Int
                       
                        if(ccount ?? 0 < 2)
                        {
                        cell.CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comment"
                        }
                        else{
                             cell.CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comments"
                            
                        }
                        let vcount = dict?.value(forKey: "viewcount") as? Int
                        if(vcount ?? 0 < 2)
                        {
                            cell.ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) View"
                            
                        }
                        else{
                            cell.ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"
                            
                        }
                        
                        /*
                        if(indexPath.row == 0){
                            cell.LikeCount?.text = "1K Likes"
                            cell.ViewCount?.text = "2.5K Views"
                        }
                        if(indexPath.row == 1){
                            cell.LikeCount?.text = "4K Likes"
                            cell.ViewCount?.text = "7K Views"
                            
                        }
                        if(indexPath.row == 2){
                            cell.LikeCount?.text = "9K Likes"
                            cell.ViewCount?.text = "15K Views"
                            
                        }
                        if(indexPath.row == 3){
                            cell.LikeCount?.text = "3K Likes"
                            cell.ViewCount?.text = "8K Views"
                            
                        }
                        if(indexPath.row == 0){
                            cell.CommentCount?.text = "2K Comments"
                        }
                        if(indexPath.row == 1){
                            cell.CommentCount?.text = "1K Comments"
                            
                        }
                        if(indexPath.row == 2){
                            cell.CommentCount?.text = "2K Comments"
                            
                        }
                        if(indexPath.row == 3){
                            cell.CommentCount?.text = "800 Comments"
                            
                        }
                        */
                        
                        
                       
                        // cell.ContentText?.frame.height = CGFloat.greatestFiniteMagnitude
                        let teamId = dict?.value(forKey: "relatedteam") as! Int
                        let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                        let array1 = Teams_details.rows(filter:"team_Id = \(teamId)") as! [Teams_details]
                        if(array1.count != 0) {
                            let disnarysound = array1[0]
                            cell.TeamName?.text = disnarysound.team_name
                        }
                        let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                        if((teamImage) != nil)
                        {
                            cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                            
                            /*if(cell.chatImage?.image == nil)
                             {
                             appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                             }*/
                        }
                        else
                        {
                            cell.teamImage?.image = UIImage(named: "team")
                        }
                        let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
                        if(isLiked){
                            cell.likeImage.image = UIImage(named: "liked")
                            cell.likeText?.setTitle("Liked", for: .normal)
                        }
                        else{
                            cell.likeImage.image = UIImage(named: "like")
                            cell.likeText?.setTitle("Like", for: .normal)
                        }
                        
                        //var msgtime = ""
                        /*if let mili1 = dict?.value(forKey: "time")
                         {
                         
                         let mili: Double = Double(mili1  as! NSNumber)
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
                         cell.Time?.text = msgtime
                         } */
                        
                        //let mesgdict: NSDictionary = dict?.value(forKey: "message") as! NSDictionary
                        //cell.teamImage?.image = UIImage(named: "team")
                        let longPressGesture_showchat:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                        longPressGesture_showchat.delegate = self as? UIGestureRecognizerDelegate
                let longPressGesture_showchat1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                longPressGesture_showchat1.delegate = self as? UIGestureRecognizerDelegate
                       cell.fanName?.addGestureRecognizer(longPressGesture_showchat1)
                                  cell.fanName?.isUserInteractionEnabled = true
                        cell.fanImage?.addGestureRecognizer(longPressGesture_showchat)
                       
                        cell.fanImage?.isUserInteractionEnabled = true
                        cell.fanImage?.image = UIImage(named: "user")
                        if(dict?.value(forKey: "avatar") != nil)
                        {
                            let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                            if(!avatar.isEmpty)
                            {
                                let arrReadselVideoPath = avatar.components(separatedBy: "/")
                                let imageId = arrReadselVideoPath.last
                                let arrReadimageId = imageId?.components(separatedBy: ".")
                                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                                let url = NSURL(string: avatar)!
                                let filenameforupdate = arrReadimageId![0] as String
                                do {
                                    let fileManager = FileManager.default
                                    //try fileManager.removeItem(atPath: imageId)
                                    // Check if file exists
                                    if fileManager.fileExists(atPath: paths) {
                                        // Delete file
                                        //print("File  exist")
                                        
                                        if(!paths.isEmpty)
                                        {
                                            //let path_file = "file://" + paths
                                            let imageURL = URL(fileURLWithPath: paths)
                                            cell.fanImage?.image = UIImage(contentsOfFile: imageURL.path)
                                        }
                                    } else {
                                       // print("File does not exist")
                                        appDelegate().loadImageFromUrl(url: avatar, view: cell.fanImage!)
                                        
                                        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                                            // if responseData is not null...
                                            if let data = responseData{
                                                
                                                // execute in UI thread
                                                DispatchQueue.main.async(execute: { () -> Void in
                                                    _ = self.saveFanImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: filenameforupdate)
                                                    //print(filePath)
                                                    
                                                })
                                            }
                                            
                                        }
                                        
                                        // Run task
                                        task.resume()
                                        //End Code to fetch media from live URL
                                        
                                    }
                                    
                                }
                                catch let error as NSError {
                                    print("An error took place: \(error)")
                                    //TransperentLoadingIndicatorView.hide()
                                    
                                }
                                
                            }
                            else
                            {
                                cell.fanImage?.image = UIImage(named: "user")
                            }
                        }
                        else
                        {
                            //cell.contactImage?.image = UIImage(named: "user")
                            
                            cell.fanImage?.image = UIImage(named: "user")
                        }
                        
                        let messageContent = dict?.value(forKey: "message")as! String
                        
                        if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        {
                            do {
                                let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                
                                let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                                if(jsonDataMessage?.value(forKey: "subtype") != nil)
                                {
                                    let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                                    if(subtype.contains("post")){
                                        cell.TeamName?.isHidden = false
                                        cell.teamImage?.isHidden = false
                                        //cell.Time?.isHidden = false
                                        cell.subType.isHidden = true
                                    }
                                    else{
                                       cell.fanName?.text = dict?.value(forKey: "nickname") as? String//(jsonDataMessage?.value(forKey: "nickname") as? String)!
                                        cell.TeamName?.isHidden = true
                                        cell.teamImage?.isHidden = true
                                        //cell.Time?.isHidden = true
                                        cell.subType.isHidden = false
                                        cell.subType.text = subtype.capitalizingFirstLetter()
                                    }
                                }
                                else{
                                    cell.TeamName?.isHidden = false
                                     cell.teamImage?.isHidden = false
                                    //cell.Time?.isHidden = false
                                    cell.subType.isHidden = true
                                }
                               /* if(recMessageType == "image" || recMessageType == "video")
                                {
                                    if((dict?.value(forKey: "status") as? String) != "downloading")
                                    {
                                        cell.ContentImage?.removeAllSubviews()
                                        let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                        let arrReadselVideoPath = selVideoPath.components(separatedBy: "/")
                                        let imageId = arrReadselVideoPath.last
                                        let arrReadimageId = imageId?.components(separatedBy: ".")
                                        var documentsPath: String = ""
                                        if(recMessageType == "image")
                                        {
                                            documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".png")
                                        }
                                        else if (recMessageType == "video")
                                        {
                                            documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".mp4")
                                        }
                                        
                                        
                                        
                                        let fileManager = FileManager.default
                                        //try fileManager.removeItem(atPath: imageId)
                                        // Check if file exists
                                        if fileManager.fileExists(atPath: documentsPath) {
                                            var dict1: [String: AnyObject] = self.appDelegate().arrFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                                            dict1["status"] = "exist" as AnyObject
                                            self.appDelegate().arrFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                                            if(recMessageType == "video") {
                                                cell.PlayImage?.image = UIImage(named: "play")
                                                let videoLogo = self.getVideoThumbnailImage(forUrl: NSURL(string: "file://" + documentsPath)! as URL)!
                                                
                                                if(videoLogo.imageAsset != nil)
                                                {
                                                    cell.ContentImage?.image = videoLogo
                                                }
                                                
                                            }
                                            else{
                                                
                                                let imageURL = URL(fileURLWithPath:  documentsPath)
                                                cell.ContentImage?.image = UIImage(contentsOfFile: imageURL.path)
                                                
                                                cell.PlayImage?.image = UIImage(named: "uncheck")
                                            }
                                        } else
                                        {
                                            
                                            var thumbLink: String = ""
                                            if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                            {
                                                thumbLink = thumb as! String
                                            }
                                            
                                            appDelegate().loadImageFromUrl(url: thumbLink,view: cell.ContentImage!)
                                            
                                            var dict1: [String: AnyObject] = self.appDelegate().arrFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                                            dict1["status"] = "notexists" as AnyObject
                                            self.appDelegate().arrFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                                            if(recMessageType == "video") {
                                                cell.PlayImage?.image = UIImage(named: "Dowload")
                                            }
                                            else{
                                                cell.PlayImage?.image = UIImage(named: "Dowload")
                                            }
                                        }
                                    } else
                                    {
                                        var thumbLink: String = ""
                                        if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                        {
                                            thumbLink = thumb as! String
                                        }
                                        
                                        appDelegate().loadImageFromUrl(url: thumbLink,view: cell.ContentImage!)
                                       
                                        if(recMessageType == "video") {
                                            cell.PlayImage?.image = UIImage(named: "uncheck")
                                            
                                        }
                                        else {
                                            cell.PlayImage?.image = UIImage(named: "uncheck")
                                           
                                        }
                                    }
                                } else {
                                    cell.PlayImage?.image = UIImage(named: "uncheck")
                                }*/
                                
                                var msgtime = ""
                                if let mili1 = dict?.value(forKey: "time")
                                {
                                 let posttime: Int64? = Int64(dict!.value(forKey: "time") as! String)
                                 let mili: Double = Double(truncating: posttime as! NSNumber )
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
                                        msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                        // dateFormatter.dateFormat = "HH:mm"
                                        //msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                    }
                                    if(jsonDataMessage?.value(forKey: "subtype") != nil)
                                    {
                                        let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                                        if(subtype.contains("post")){
                                           cell.Time?.text = msgtime
                                        }
                                        else{
                                            let mili: Double = Double(truncating: mili1  as! NSNumber)
                                            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "dd MMM yy"
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
                                                msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                                // dateFormatter.dateFormat = "HH:mm"
                                                //msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                            }
                                            cell.Time?.text = "End Date: " + msgtime
                                        }
                                    }
                                    else{
                                       cell.Time?.text = msgtime
                                    }
                                    
                                }
                                //  let banterNick = jsonDataMessage?.value(forKey: "banternickname") as! String
                                
                                if(recMessageType == "text")
                                {
                                    //cell.ContentText?.text = "Hello" //jsonDataMessage?.value(forKey: "value") as? String
                                    let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
                                    let decodedString = String(data: decodedData, encoding: .utf8)!
                                    cell.ContentText?.text = decodedString
                                    // cell.ContentText?.lineBreakMode = .byWordWrapping
                                    
                                    // cell.ContentText?.sizeToFit()
                                    
                                    cell.ContentText?.isHidden = false
                                    //cell.PlayImage?.isHidden = true
                                    cell.PlayImage?.image = UIImage(named: "uncheck")
                                    cell.ContentImage?.isHidden = true
                                     //cell.soundImg?.isHidden = true
                                    // cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)!)
                                }
                                else if(recMessageType == "image")
                                {
                                     cell.progress?.isHidden = true
                                     //cell.soundImg?.isHidden = true
                                    cell.ContentImage?.isHidden = false
                                    var caption: String = ""
                                    if let capText = jsonDataMessage?.value(forKey: "caption")
                                    {
                                        caption = capText as! String
                                    }
                                    
                                    if(!caption.isEmpty)
                                    {
                                        let decodedData = Data(base64Encoded: caption)!
                                        let decodedString = String(data: decodedData, encoding: .utf8)!
                                        cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                        
                                        cell.ContentText?.isHidden = false
                                    } else
                                    { cell.ContentText?.text = " "
                                        cell.ContentText?.isHidden = true
                                    }
                                    
                                    //cell.ContentImage?.image = UIImage(named: "img_thumb")
                                    /*
                                     var thumbLink: String = ""
                                     if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                     {
                                     thumbLink = thumb as! String
                                     }
                                     //appDelegate().loadImageFromUrl(url: thumbLink,view: cell.ContentImage!)
                                     DispatchQueue.global(qos: .userInitiated).async {
                                     let imageUrl:URL = URL(string: thumbLink)!
                                     
                                     let imageData:NSData = NSData(contentsOf: imageUrl)!
                                     
                                     
                                     // When from background thread, UI needs to be updated on main_queue
                                     DispatchQueue.main.async {
                                     let image = UIImage(data: imageData as Data)
                                     cell.ContentImage?.image = image
                                     
                                     }
                                     } */
                                    cell.PlayImage?.isHidden = true
                                    cell.ContentImage?.contentMode = .scaleAspectFill
                                    cell.ContentImage?.clipsToBounds = true
                                    var thumbLink: String = ""
                                    if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                    {
                                        thumbLink = thumb as! String
                                    }
                                    //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                    cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
                                    cell.TypeImage.image = UIImage(named: "photo")
                                 /*   if((dict?.value(forKey: "status") as? String) == "downloading")
                                    {
                                        /*let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height))
                                        //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                                        cell.ContentImage?.addSubview(overlay)
                                        LoadingIndicatorView.show(cell.ContentImage!, loadingText: "Downloading Image...")*/
                                        let viewForActivityIndicator = UIView()
                                        
                                        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height)
                                        viewForActivityIndicator.alpha = 0.7
                                        viewForActivityIndicator.backgroundColor = UIColor.darkGray
                                        //imageViewObject.addSubview(viewForActivityIndicator)
                                        cell.ContentImage?.addSubview(viewForActivityIndicator)
                                        
                                        let activityIndicatorView = UIActivityIndicatorView()
                                        activityIndicatorView.center = CGPoint(x:cell.ContentImage!.frame.size.width/2 , y: cell.ContentImage!.frame.size.height/2)
                                        let loadingTextLabel = UILabel()
                                        
                                        loadingTextLabel.textColor = UIColor.white
                                        loadingTextLabel.text = "Downloading Image..."
                                        //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                                        loadingTextLabel.sizeToFit()
                                        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
                                        viewForActivityIndicator.addSubview(loadingTextLabel)
                                        
                                        activityIndicatorView.hidesWhenStopped = true
                                        activityIndicatorView.activityIndicatorViewStyle = .white
                                        viewForActivityIndicator.addSubview(activityIndicatorView)
                                        
                                        //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
                                        activityIndicatorView.startAnimating()
                                        
                                    } else
                                    {
                                       // LoadingIndicatorView.hide()
                                        cell.ContentImage?.removeAllSubviews()
                                    }*/
                                    
                                    //cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)! + (cell.ContentImage?.frame.height)!)
                                }
                                else if(recMessageType == "video")
                                {
                                    cell.soundImg?.isHidden = false
                                    cell.ContentImage?.isHidden = false
                                    var caption: String = ""
                                    if let capText = jsonDataMessage?.value(forKey: "caption")
                                    {
                                        caption = capText as! String
                                    }
                                    
                                    if(!caption.isEmpty)
                                    {
                                        let decodedData = Data(base64Encoded: caption)!
                                        let decodedString = String(data: decodedData, encoding: .utf8)!
                                        cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                        cell.ContentText?.isHidden = false
                                    } else
                                    {
                                        cell.ContentText?.text = ""
                                        cell.ContentText?.isHidden = true
                                    }
                                    
                                    
                                    
                                    cell.ContentImage?.contentMode = .scaleAspectFill
                                    cell.ContentImage?.clipsToBounds = true
                                    var thumbLink: String = ""
                                    if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                    {
                                        thumbLink = thumb as! String
                                    }
                                   /* if(appDelegate().GetvalueFromInsentiveConfigTable(Key: isstream)).boolValue{
                                        if let smillink = jsonDataMessage?.value(forKey: "smillink")
                                        {
                                            
                                            var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                            if(selVideoPath.isEmpty){
                                                selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                                cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                            }
                                            else{
                                                cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                            }
                                            
                                        }
                                        else{
                                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                            cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                        }
                                        
                                    }
                                    else{
                                        let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                        cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                    }*/
                                     cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
                                     cell.TypeImage.image = UIImage(named: "video")
                                      cell.PlayImage?.isHidden = false
                                    /* let isloader = dict?.value(forKey: "isloader") as! Bool
                                    if(isloader){
                                        //cell.PlayImage?.isHidden = false
                                        //let newProgress: CGFloat = cell.progress.progress == 0.0 ? 1.45 : 1.00
                                        cell.progress?.isHidden = false
                                        //animateProg(progressBar: cell.progress)
                                        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "progress", withExtension: "gif")!)
                                       // let advTimeGif = UIImage.gifImageWithData(imageData!)
                                        cell.progress.image = UIImage.gifImageWithData(imageData!)
                                    }
                                    else{
                                       cell.progress?.isHidden = true
                                    }*/
                                     //let ismute = dict?.value(forKey: "mute")as! Bool
                                  /*  if((dict?.value(forKey: "status") as? String) == "downloading")
                                    {
                                        //let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height))
                                        //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                                        let viewForActivityIndicator = UIView()
                                        
                                        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height)
                                        viewForActivityIndicator.alpha = 0.7
                                        viewForActivityIndicator.backgroundColor = UIColor.darkGray
                                        //imageViewObject.addSubview(viewForActivityIndicator)
                                        cell.ContentImage?.addSubview(viewForActivityIndicator)
                                        
                                        let activityIndicatorView = UIActivityIndicatorView()
                                        activityIndicatorView.center = CGPoint(x:cell.ContentImage!.frame.size.width/2 , y: cell.ContentImage!.frame.size.height/2)
                                        let loadingTextLabel = UILabel()
                                        
                                        loadingTextLabel.textColor = UIColor.white
                                        loadingTextLabel.text = "Downloading Video..."
                                        //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                                        loadingTextLabel.sizeToFit()
                                        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
                                        viewForActivityIndicator.addSubview(loadingTextLabel)
                                        
                                        activityIndicatorView.hidesWhenStopped = true
                                        activityIndicatorView.activityIndicatorViewStyle = .white
                                        viewForActivityIndicator.addSubview(activityIndicatorView)
                                        
                                        //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
                                        activityIndicatorView.startAnimating()
                                        //LoadingIndicatorView.show(overlay, load
                                        //cell.ContentImage?.addSubview(overlay)
                                        //LoadingIndicatorView.show(cell.ContentImage!, loadingText: "\nDownloading Video...")
                                        
                                    } else
                                    {
                                        //LoadingIndicatorView.hide()
                                        cell.ContentImage?.removeAllSubviews()
                                    }*/
                                    //cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)! + (cell.ContentImage?.frame.height)!)
                                }
                                
                                let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                                let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                                
                                cell.TitelName?.text = decodedString1//jsonDataMessage?.value(forKey: "title") as? String
                                
                                /* var caption: String = ""
                                 if let capText = jsonDataMessage?.value(forKey: "caption")
                                 {
                                 caption = capText as! String
                                 }
                                 
                                 let valueText = jsonDataMessage?.value(forKey: "value") as! String
                                 var thumbLink: String = ""
                                 if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                 {
                                 thumbLink = thumb as! String
                                 }
                                 cell.TitelName?.text = jsonDataMessage?.value(forKey: "title") as? String
                                 
                                 //let roomType = jsonDataMessage?.value(forKey: "roomtype") as! String
                                 var messageId: String = ""
                                 if let msgId = jsonDataMessage?.value(forKey: "messageid")
                                 {
                                 messageId = msgId as! String
                                 }
                                 else
                                 {
                                 let uuid = UUID().uuidString
                                 messageId = uuid
                                 } */
                                
                                let screenSize = UIScreen.main.bounds
                                let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width, height: CGFloat.greatestFiniteMagnitude))
                                label.font = UIFont.systemFont(ofSize: 14.0)
                                label.text = cell.ContentText!.text
                                label.textAlignment = .left
                                //label.textColor = self.strokeColor
                                label.lineBreakMode = .byWordWrapping
                                label.numberOfLines = 0
                                label.sizeToFit()
                                
                                if(recMessageType == "text")
                                {
                                    /*let height = 240.0
                                     // cell.mainViewConstraint.constant = CGFloat(height)
                                     print("Height \(height).")
                                     storyTableView?.rowHeight = CGFloat(height)*/
                                    
                                    
                                    
                                    if((label.frame.height) > 17)
                                    {
                                        let height = (label.frame.height) + 210.0
                                        // cell.mainViewConstraint.constant = CGFloat(height)
                                        //print("Height \(height).")
                                        storyTableView?.rowHeight = CGFloat(height)
                                    }
                                    else
                                    {
                                        let height = 210.0
                                        // cell.mainViewConstraint.constant = CGFloat(height)
                                        //print("Height \(height).")
                                        storyTableView?.rowHeight = CGFloat(height)
                                    }
                                    
                                    
                                }
                                else
                                {
                                    /*let height = 470.0
                                     // cell.mainViewConstraint.constant = CGFloat(height)
                                     print("Height \(height).")
                                     storyTableView?.rowHeight = CGFloat(height)*/
                                    //print(cell.ContentText?.text)
                                    if((label.frame.height) > 17)
                                    {
                                        let height = (label.frame.height) + 410.0
                                        //print("Height \((label.frame.height)).")
                                        storyTableView?.rowHeight = CGFloat(height)
                                    }
                                    else
                                    {
                                        let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                                        //print("Height \((label.frame.height)).")
                                        storyTableView?.rowHeight = CGFloat(height)
                                    }
                                    
                                    
                                }
                                
                                
                            } catch let error as NSError {
                                print(error)
                            }
                            
                        }
                   
                    /* let teamId = mesgdict?.value(forKey: "relatedteam") as? Int
                     let teamImageName = "Team" + teamId.description
                     //print(teamImageName)
                     
                     let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                     if((teamImage) != nil)
                     {
                     cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                     
                     if(cell.teamImage?.image == nil)
                     {
                     appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "logo") as? String)!,view: (cell.teamImage)!, fileName: teamImageName as String)
                     }
                     }
                     else
                     {
                     appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "logo") as? String)!,view: (cell.teamImage)!, fileName: teamImageName as String)
                     }*/
                    // cell.Mainview?.removeAllSubviews()
                    //let height = cell.Headerview.frame.height + cell.coontentview.frame.height + cell.LCcounttview.frame.height + cell.LCSview.frame.height + 20.0
                 /*   let lastElement = appDelegate().arrFanUpdatesTeams.count - 1
                    if(lastElement >= indexPath.row+1){
                        let dict: NSDictionary? = appDelegate().arrFanUpdatesTeams[indexPath.row + 1] as? NSDictionary
                        if(dict != nil)
                        {
                            let messageContent = dict?.value(forKey: "message")as! String
                            
                            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                            {
                                do {
                                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                    
                                    let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                                     if(recMessageType == "video")
                                    {
                                        if let smillink = jsonDataMessage?.value(forKey: "smillink")
                                        {
                                            
                                            var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                            if(selVideoPath.isEmpty){
                                                selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                                 ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                            }
                                            else{
                                                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                            }
                                            
                                        }
                                        else{
                                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                            ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                        }
                                       // let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                        //ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                    }
                                }
                             catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                    }
                    
                    if(lastElement >= indexPath.row+2){
                        let dict: NSDictionary? = appDelegate().arrFanUpdatesTeams[indexPath.row + 2] as? NSDictionary
                        if(dict != nil)
                        {
                            let messageContent = dict?.value(forKey: "message")as! String
                            
                            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                            {
                                do {
                                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                    
                                    let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                                    if(recMessageType == "video")
                                    {
                                        if let smillink = jsonDataMessage?.value(forKey: "smillink")
                                        {
                                            
                                            var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                            if(selVideoPath.isEmpty){
                                                selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                            }
                                            else{
                                                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                            }
                                            
                                        }
                                        else{
                                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                            ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                        }
                                        //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                        //ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                    }
                                }
                                catch let error as NSError {
                                    print(error)
                                }
                            }
                        }
                    }
                    
                    */
                    
                    return cell
             }

         }else{
             let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FanUpdatesCell
             
             
             let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
             
             
             let longPressGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture2.delegate = self as? UIGestureRecognizerDelegate
             
             
             cell.like?.addGestureRecognizer(longPressGesture)
             cell.like?.isUserInteractionEnabled = true
             
             cell.likeImage?.addGestureRecognizer(longPressGesture1)
             cell.likeImage?.isUserInteractionEnabled = true
             
             cell.likeText?.addGestureRecognizer(longPressGesture2)
             cell.likeText?.isUserInteractionEnabled = true
             
             
             let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_share2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_share2.delegate = self as? UIGestureRecognizerDelegate
             
             cell.share?.addGestureRecognizer(longPressGesture_share)
             cell.share?.isUserInteractionEnabled = true
             
             cell.shareImage?.addGestureRecognizer(longPressGesture_share1)
             cell.shareImage?.isUserInteractionEnabled = true
             
             cell.shareText?.addGestureRecognizer(longPressGesture_share2)
             cell.shareText?.isUserInteractionEnabled = true
              cell.imgmenu?.isHidden = true
             
             
             let longPressGesture_comment:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_comment.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_comment1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_comment1.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_comment2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_comment2.delegate = self as? UIGestureRecognizerDelegate
             
             
             let longPressGesture_comment3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_comment3.delegate = self as? UIGestureRecognizerDelegate
             
             
             cell.comment?.addGestureRecognizer(longPressGesture_comment)
             cell.comment?.isUserInteractionEnabled = true
             
             cell.commentImage?.addGestureRecognizer(longPressGesture_comment1)
             cell.commentImage?.isUserInteractionEnabled = true
             
             cell.commentText?.addGestureRecognizer(longPressGesture_comment2)
             cell.commentText?.isUserInteractionEnabled = true
             
             
             cell.CommentCount?.addGestureRecognizer(longPressGesture_comment3)
             cell.CommentCount?.isUserInteractionEnabled = true
             
             
             let longPressGesture_like_count:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeCountClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_like_count.delegate = self as? UIGestureRecognizerDelegate
             
             
             cell.LikeCount?.addGestureRecognizer(longPressGesture_like_count)
             cell.LikeCount?.isUserInteractionEnabled = true
             
             
             let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
             //longPressGesture.minimumPressDuration = 1.0 // 1 second press
             longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
             
             cell.PlayImage?.addGestureRecognizer(longPressGesture_showpreview)
             cell.PlayImage?.isUserInteractionEnabled = true
             
             
             cell.ContentImage?.addGestureRecognizer(longPressGesture_showpreview1)
             cell.ContentImage?.isUserInteractionEnabled = true
             
             
             let longPressGesture_editUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
             longPressGesture_editUpdate.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_editUpdate1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
             longPressGesture_editUpdate1.delegate = self as? UIGestureRecognizerDelegate
             
             let longPressGesture_editUpdate2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
             longPressGesture_editUpdate2.delegate = self as? UIGestureRecognizerDelegate
             
             cell.editUpdate?.addGestureRecognizer(longPressGesture_editUpdate)
             cell.editUpdate?.isUserInteractionEnabled = true
             
             cell.editImage?.addGestureRecognizer(longPressGesture_editUpdate1)
             cell.editImage?.isUserInteractionEnabled = true
             
             cell.editView?.addGestureRecognizer(longPressGesture_editUpdate2)
             cell.editView?.isUserInteractionEnabled = true
             
             
             let longPressGesture_deleteUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
             longPressGesture_deleteUpdate.delegate = self as? UIGestureRecognizerDelegate
             
             
             let longPressGesture_deleteUpdate1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
             longPressGesture_deleteUpdate1.delegate = self as? UIGestureRecognizerDelegate
             
             
             let longPressGesture_deleteUpdate2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
             longPressGesture_deleteUpdate2.delegate = self as? UIGestureRecognizerDelegate
             
             cell.deleteUpdate?.addGestureRecognizer(longPressGesture_deleteUpdate)
             cell.deleteUpdate?.isUserInteractionEnabled = true
             
             cell.deleteImage?.addGestureRecognizer(longPressGesture_deleteUpdate1)
             cell.deleteImage?.isUserInteractionEnabled = true
             
             cell.deleteView?.addGestureRecognizer(longPressGesture_deleteUpdate2)
             cell.deleteView?.isUserInteractionEnabled = true
             
             
             // Configure the cell...
             let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
             
             if(dict != nil)
             {
                 //print(dict)
                 let fanname = appDelegate().ExistingContact(username: (dict?.value(forKey: "username") as? String)!)
                 
                 if(fanname == "You")
                 {
                     cell.editView.isHidden = false
                     cell.deleteView.isHidden = false
                 } else
                 {
                     cell.editView.isHidden = true
                     cell.deleteView.isHidden = true
                 }
                 
                 
                 cell.fanName?.text = fanname
                 let lcount = dict?.value(forKey: "likecount") as? Int
                 cell.LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Likes"//"\(appDelegate().formatPoints(num: 10666660.00 ?? 0) ) Likes"
                 let ccount = dict?.value(forKey: "commentcount") as? Int
                 cell.CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comments"
                 
                 let vcount = dict?.value(forKey: "viewcount") as? Int
                 cell.ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"
                 
                 /*
                 if(indexPath.row == 0){
                     cell.LikeCount?.text = "1K Likes"
                     cell.ViewCount?.text = "2.5K Views"
                 }
                 if(indexPath.row == 1){
                     cell.LikeCount?.text = "4K Likes"
                     cell.ViewCount?.text = "7K Views"
                     
                 }
                 if(indexPath.row == 2){
                     cell.LikeCount?.text = "9K Likes"
                     cell.ViewCount?.text = "15K Views"
                     
                 }
                 if(indexPath.row == 3){
                     cell.LikeCount?.text = "3K Likes"
                     cell.ViewCount?.text = "8K Views"
                     
                 }
                 if(indexPath.row == 0){
                     cell.CommentCount?.text = "2K Comments"
                 }
                 if(indexPath.row == 1){
                     cell.CommentCount?.text = "400 Comments"
                     
                 }
                 if(indexPath.row == 2){
                     cell.CommentCount?.text = "2K Comments"
                     
                 }
                 if(indexPath.row == 3){
                     cell.CommentCount?.text = "800 Comments"
                     
                 } */
                 
                 // cell.ContentText?.frame.height = CGFloat.greatestFiniteMagnitude
                 let teamId = dict?.value(forKey: "relatedteam") as! Int
                 let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                 let array1 = Teams_details.rows(filter:"team_Id = \(teamId)") as! [Teams_details]
                 if(array1.count != 0) {
                     let disnarysound = array1[0]
                     cell.TeamName?.text = disnarysound.team_name
                 }
                 let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                 if((teamImage) != nil)
                 {
                     cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                     
                     /*if(cell.chatImage?.image == nil)
                      {
                      appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                      }*/
                 }
                 else
                 {
                     cell.teamImage?.image = UIImage(named: "team")
                 }
                 let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
                 if(isLiked){
                     cell.likeImage.image = UIImage(named: "liked")
                     cell.likeText?.setTitle("Liked", for: .normal)
                 }
                 else{
                     cell.likeImage.image = UIImage(named: "like")
                     cell.likeText?.setTitle("Like", for: .normal)
                 }
                 
                 //var msgtime = ""
                 /*if let mili1 = dict?.value(forKey: "time")
                  {
                  
                  let mili: Double = Double(mili1  as! NSNumber)
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
                  cell.Time?.text = msgtime
                  } */
                 
                 //let mesgdict: NSDictionary = dict?.value(forKey: "message") as! NSDictionary
                 //cell.teamImage?.image = UIImage(named: "team")
                 let longPressGesture_showchat:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                 longPressGesture_showchat.delegate = self as? UIGestureRecognizerDelegate
                 cell.fanName?.addGestureRecognizer(longPressGesture_showchat)
                            cell.fanName?.isUserInteractionEnabled = true
                 cell.fanImage?.addGestureRecognizer(longPressGesture_showchat)
                 cell.fanImage?.isUserInteractionEnabled = true
                 cell.fanImage?.image = UIImage(named: "user")
                 if(dict?.value(forKey: "avatar") != nil)
                 {
                     let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                     if(!avatar.isEmpty)
                     {
                         let arrReadselVideoPath = avatar.components(separatedBy: "/")
                         let imageId = arrReadselVideoPath.last
                         let arrReadimageId = imageId?.components(separatedBy: ".")
                         let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                         let url = NSURL(string: avatar)!
                         let filenameforupdate = arrReadimageId![0] as String
                         do {
                             let fileManager = FileManager.default
                             //try fileManager.removeItem(atPath: imageId)
                             // Check if file exists
                             if fileManager.fileExists(atPath: paths) {
                                 // Delete file
                                 //print("File  exist")
                                 
                                 if(!paths.isEmpty)
                                 {
                                     //let path_file = "file://" + paths
                                     let imageURL = URL(fileURLWithPath: paths)
                                     cell.fanImage?.image = UIImage(contentsOfFile: imageURL.path)
                                 }
                             } else {
                                 // print("File does not exist")
                                 appDelegate().loadImageFromUrl(url: avatar, view: cell.fanImage!)
                                 
                                 let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                                     // if responseData is not null...
                                     if let data = responseData{
                                         
                                         // execute in UI thread
                                         DispatchQueue.main.async(execute: { () -> Void in
                                             let filePath = self.saveFanImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: filenameforupdate)
                                             //print(filePath)
                                             
                                         })
                                     }
                                     
                                 }
                                 
                                 // Run task
                                 task.resume()
                                 //End Code to fetch media from live URL
                                 
                             }
                             
                         }
                         catch let error as NSError {
                             print("An error took place: \(error)")
                             TransperentLoadingIndicatorView.hide()
                             
                         }
                         
                     }
                     else
                     {
                         cell.fanImage?.image = UIImage(named: "user")
                     }
                 }
                 else
                 {
                     //cell.contactImage?.image = UIImage(named: "user")
                     
                     cell.fanImage?.image = UIImage(named: "user")
                 }
                 
                 let messageContent = dict?.value(forKey: "message")as! String
                 
                 if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                 {
                     do {
                         let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                         
                         let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                         if(jsonDataMessage?.value(forKey: "subtype") != nil)
                         {
                             let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                             if(subtype.contains("post")){
                                 cell.TeamName?.isHidden = false
                                 cell.teamImage?.isHidden = false
                                 //cell.Time?.isHidden = false
                                 cell.subType.isHidden = true
                             }
                             else{
                                 cell.fanName?.text = dict?.value(forKey: "nickname") as? String//(jsonDataMessage?.value(forKey: "nickname") as? String)!
                                 cell.TeamName?.isHidden = true
                                 cell.teamImage?.isHidden = true
                                 //cell.Time?.isHidden = true
                                 cell.subType.isHidden = false
                                 cell.subType.text = subtype.capitalizingFirstLetter()
                             }
                         }
                         else{
                             cell.TeamName?.isHidden = false
                             cell.teamImage?.isHidden = false
                             //cell.Time?.isHidden = false
                             cell.subType.isHidden = true
                         }
                        /* if(recMessageType == "image" || recMessageType == "video")
                         {
                             if((dict?.value(forKey: "status") as? String) != "downloading")
                             {
                                 cell.ContentImage?.removeAllSubviews()
                                 let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                 let arrReadselVideoPath = selVideoPath.components(separatedBy: "/")
                                 let imageId = arrReadselVideoPath.last
                                 let arrReadimageId = imageId?.components(separatedBy: ".")
                                 var documentsPath: String = ""
                                 if(recMessageType == "image")
                                 {
                                     documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".png")
                                 }
                                 else if (recMessageType == "video")
                                 {
                                     documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".mp4")
                                 }
                                 
                                 
                                 
                                 let fileManager = FileManager.default
                                 //try fileManager.removeItem(atPath: imageId)
                                 // Check if file exists
                                 if fileManager.fileExists(atPath: documentsPath) {
                                     var dict1: [String: AnyObject] = self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                                     dict1["status"] = "exist" as AnyObject
                                     self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                                     if(recMessageType == "video") {
                                         cell.PlayImage?.image = UIImage(named: "play")
                                         let videoLogo = self.getVideoThumbnailImage(forUrl: NSURL(string: "file://" + documentsPath)! as URL)!
                                         
                                         if(videoLogo.imageAsset != nil)
                                         {
                                             cell.ContentImage?.image = videoLogo
                                         }
                                         
                                     }
                                     else{
                                         
                                         let imageURL = URL(fileURLWithPath:  documentsPath)
                                         cell.ContentImage?.image = UIImage(contentsOfFile: imageURL.path)
                                         
                                         cell.PlayImage?.image = UIImage(named: "uncheck")
                                     }
                                 } else
                                 {
                                     
                                     var thumbLink: String = ""
                                     if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                     {
                                         thumbLink = thumb as! String
                                     }
                                     
                                     appDelegate().loadImageFromUrl(url: thumbLink,view: cell.ContentImage!)
                                     
                                     var dict1: [String: AnyObject] = self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                                     dict1["status"] = "notexists" as AnyObject
                                     self.appDelegate().arrMyFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                                     if(recMessageType == "video") {
                                         cell.PlayImage?.image = UIImage(named: "Dowload")
                                     }
                                     else{
                                         cell.PlayImage?.image = UIImage(named: "Dowload")
                                     }
                                 }
                             } else
                             {
                                 var thumbLink: String = ""
                                 if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                 {
                                     thumbLink = thumb as! String
                                 }
                                 
                                 appDelegate().loadImageFromUrl(url: thumbLink,view: cell.ContentImage!)
                                 
                                 if(recMessageType == "video") {
                                     cell.PlayImage?.image = UIImage(named: "uncheck")
                                     
                                 }
                                 else {
                                     cell.PlayImage?.image = UIImage(named: "uncheck")
                                     
                                 }
                             }
                         } else {
                             cell.PlayImage?.image = UIImage(named: "uncheck")
                         }
                         */
                         var msgtime = ""
                         if let mili1 = dict?.value(forKey: "time")
                         {
                             
                            let posttime: Int64? = Int64(dict!.value(forKey: "time") as! String)
                             let mili: Double = Double(truncating: posttime  as! NSNumber)
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
                                 msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                 // dateFormatter.dateFormat = "HH:mm"
                                 //msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                             }
                             if(jsonDataMessage?.value(forKey: "subtype") != nil)
                             {
                                 let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                                 if(subtype.contains("post")){
                                     cell.Time?.text = msgtime
                                 }
                                 else{
                                     let mili: Double = Double(mili1  as! NSNumber)
                                     let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                     let dateFormatter = DateFormatter()
                                     dateFormatter.dateFormat = "dd MMM yy"
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
                                         msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                         // dateFormatter.dateFormat = "HH:mm"
                                         //msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                     }
                                     cell.Time?.text = "End Date: " + msgtime
                                 }
                             }
                             else{
                                 cell.Time?.text = msgtime
                             }
                             
                         }
                         //  let banterNick = jsonDataMessage?.value(forKey: "banternickname") as! String
                         
                         if(recMessageType == "text")
                         {
                             //cell.ContentText?.text = "Hello" //jsonDataMessage?.value(forKey: "value") as? String
                             let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
                             let decodedString = String(data: decodedData, encoding: .utf8)!
                             cell.ContentText?.text = decodedString
                             // cell.ContentText?.lineBreakMode = .byWordWrapping
                             
                             // cell.ContentText?.sizeToFit()
                             
                             cell.ContentText?.isHidden = false
                             //cell.PlayImage?.isHidden = true
                             //cell.PlayImage?.image = UIImage(named: "uncheck")
                             cell.ContentImage?.isHidden = true
                             // cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)!)
                         }
                         else if(recMessageType == "image")
                         {
                             
                             cell.ContentImage?.isHidden = false
                             var caption: String = ""
                             if let capText = jsonDataMessage?.value(forKey: "caption")
                             {
                                 caption = capText as! String
                             }
                             
                             if(!caption.isEmpty)
                             {
                                 let decodedData = Data(base64Encoded: caption)!
                                 let decodedString = String(data: decodedData, encoding: .utf8)!
                                 cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                 
                                 cell.ContentText?.isHidden = false
                             } else
                             { cell.ContentText?.text = " "
                                 cell.ContentText?.isHidden = true
                             }
                             var thumbLink: String = ""
                             if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                             {
                                 thumbLink = thumb as! String
                             }
                             //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                             cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
                             cell.TypeImage.image = UIImage(named: "photo")
                             //cell.ContentImage?.image = UIImage(named: "img_thumb")
                             /*
                              var thumbLink: String = ""
                              if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                              {
                              thumbLink = thumb as! String
                              }
                              //appDelegate().loadImageFromUrl(url: thumbLink,view: cell.ContentImage!)
                              DispatchQueue.global(qos: .userInitiated).async {
                              let imageUrl:URL = URL(string: thumbLink)!
                              
                              let imageData:NSData = NSData(contentsOf: imageUrl)!
                              
                              
                              // When from background thread, UI needs to be updated on main_queue
                              DispatchQueue.main.async {
                              let image = UIImage(data: imageData as Data)
                              cell.ContentImage?.image = image
                              
                              }
                              } */
                             //cell.PlayImage?.isHidden = true
                             cell.ContentImage?.contentMode = .scaleAspectFill
                             cell.ContentImage?.clipsToBounds = true
                              cell.PlayImage?.isHidden = true
                            /* if((dict?.value(forKey: "status") as? String) == "downloading")
                             {
                                 /*let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height))
                                  //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                                  cell.ContentImage?.addSubview(overlay)
                                  LoadingIndicatorView.show(cell.ContentImage!, loadingText: "Downloading Image...")*/
                                 let viewForActivityIndicator = UIView()
                                 
                                 viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height)
                                 viewForActivityIndicator.alpha = 0.7
                                 viewForActivityIndicator.backgroundColor = UIColor.darkGray
                                 //imageViewObject.addSubview(viewForActivityIndicator)
                                 cell.ContentImage?.addSubview(viewForActivityIndicator)
                                 
                                 let activityIndicatorView = UIActivityIndicatorView()
                                 activityIndicatorView.center = CGPoint(x:cell.ContentImage!.frame.size.width/2 , y: cell.ContentImage!.frame.size.height/2)
                                 let loadingTextLabel = UILabel()
                                 
                                 loadingTextLabel.textColor = UIColor.white
                                 loadingTextLabel.text = "Downloading Image..."
                                 //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                                 loadingTextLabel.sizeToFit()
                                 loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
                                 viewForActivityIndicator.addSubview(loadingTextLabel)
                                 
                                 activityIndicatorView.hidesWhenStopped = true
                                 activityIndicatorView.activityIndicatorViewStyle = .white
                                 viewForActivityIndicator.addSubview(activityIndicatorView)
                                 
                                 //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
                                 activityIndicatorView.startAnimating()
                                 
                             } else
                             {
                                 // LoadingIndicatorView.hide()
                                 cell.ContentImage?.removeAllSubviews()
                             }*/
                             
                             //cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)! + (cell.ContentImage?.frame.height)!)
                         }
                         else if(recMessageType == "video")
                         {
                             cell.PlayImage?.isHidden = false
                             cell.ContentImage?.isHidden = false
                             var caption: String = ""
                             if let capText = jsonDataMessage?.value(forKey: "caption")
                             {
                                 caption = capText as! String
                             }
                             
                             if(!caption.isEmpty)
                             {
                                 let decodedData = Data(base64Encoded: caption)!
                                 let decodedString = String(data: decodedData, encoding: .utf8)!
                                 cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                 cell.ContentText?.isHidden = false
                             } else
                             {
                                 cell.ContentText?.text = ""
                                 cell.ContentText?.isHidden = true
                             }
                             
                             
                             
                             cell.ContentImage?.contentMode = .scaleAspectFill
                             cell.ContentImage?.clipsToBounds = true
                             var thumbLink: String = ""
                             if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                             {
                                 thumbLink = thumb as! String
                             }
                             /*if(appDelegate().GetvalueFromInsentiveConfigTable(Key: isstream)).boolValue{
                                 if let smillink = jsonDataMessage?.value(forKey: "smillink")
                                 {
                                     
                                     var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                     if(selVideoPath.isEmpty){
                                         selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                         cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                     }
                                     else{
                                         cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                     }
                                     
                                 }
                                 else{
                                     let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                     cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                                 }
                                 
                             }
                             else{
                                 let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                 cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath, layertag: String(indexPath.row))
                             }*/
                              cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
                              cell.TypeImage.image = UIImage(named: "video")
                            /* let isloader = dict?.value(forKey: "isloader") as! Bool
                             if(isloader){
                                 cell.progress?.isHidden = false
                                 //animateProg(progressBar: cell.progress)
                                 let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "progress", withExtension: "gif")!)
                                 // let advTimeGif = UIImage.gifImageWithData(imageData!)
                                 cell.progress.image = UIImage.gifImageWithData(imageData!)
                             }
                             else{
                                 cell.progress?.isHidden = true
                             }*/
                             //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                             //cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                             /*if((dict?.value(forKey: "status") as? String) == "downloading")
                             {
                                 //let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height))
                                 //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                                 let viewForActivityIndicator = UIView()
                                 
                                 viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: cell.ContentImage!.frame.size.width, height: cell.ContentImage!.frame.size.height)
                                 viewForActivityIndicator.alpha = 0.7
                                 viewForActivityIndicator.backgroundColor = UIColor.darkGray
                                 //imageViewObject.addSubview(viewForActivityIndicator)
                                 cell.ContentImage?.addSubview(viewForActivityIndicator)
                                 
                                 let activityIndicatorView = UIActivityIndicatorView()
                                 activityIndicatorView.center = CGPoint(x:cell.ContentImage!.frame.size.width/2 , y: cell.ContentImage!.frame.size.height/2)
                                 let loadingTextLabel = UILabel()
                                 
                                 loadingTextLabel.textColor = UIColor.white
                                 loadingTextLabel.text = "Downloading Video..."
                                 //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                                 loadingTextLabel.sizeToFit()
                                 loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
                                 viewForActivityIndicator.addSubview(loadingTextLabel)
                                 
                                 activityIndicatorView.hidesWhenStopped = true
                                 activityIndicatorView.activityIndicatorViewStyle = .white
                                 viewForActivityIndicator.addSubview(activityIndicatorView)
                                 
                                 //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
                                 activityIndicatorView.startAnimating()
                                 //LoadingIndicatorView.show(overlay, load
                                 //cell.ContentImage?.addSubview(overlay)
                                 //LoadingIndicatorView.show(cell.ContentImage!, loadingText: "\nDownloading Video...")
                                 
                             } else
                             {
                                 //LoadingIndicatorView.hide()
                                 cell.ContentImage?.removeAllSubviews()
                             }*/
                             //cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)! + (cell.ContentImage?.frame.height)!)
                         }
                         
                         let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                         let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                         
                         cell.TitelName?.text = decodedString1//jsonDataMessage?.value(forKey: "title") as? String
                         
                         /* var caption: String = ""
                          if let capText = jsonDataMessage?.value(forKey: "caption")
                          {
                          caption = capText as! String
                          }
                          
                          let valueText = jsonDataMessage?.value(forKey: "value") as! String
                          var thumbLink: String = ""
                          if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                          {
                          thumbLink = thumb as! String
                          }
                          cell.TitelName?.text = jsonDataMessage?.value(forKey: "title") as? String
                          
                          //let roomType = jsonDataMessage?.value(forKey: "roomtype") as! String
                          var messageId: String = ""
                          if let msgId = jsonDataMessage?.value(forKey: "messageid")
                          {
                          messageId = msgId as! String
                          }
                          else
                          {
                          let uuid = UUID().uuidString
                          messageId = uuid
                          } */
                         
                         let screenSize = UIScreen.main.bounds
                         let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width, height: CGFloat.greatestFiniteMagnitude))
                         label.font = UIFont.systemFont(ofSize: 14.0)
                         label.text = cell.ContentText!.text
                         label.textAlignment = .left
                         //label.textColor = self.strokeColor
                         label.lineBreakMode = .byWordWrapping
                         label.numberOfLines = 0
                         label.sizeToFit()
                         
                         if(recMessageType == "text")
                         {
                             /*let height = 240.0
                              // cell.mainViewConstraint.constant = CGFloat(height)
                              print("Height \(height).")
                              storyTableView?.rowHeight = CGFloat(height)*/
                             
                             
                             
                             if((label.frame.height) > 17)
                             {
                                 let height = (label.frame.height) + 210.0
                                 // cell.mainViewConstraint.constant = CGFloat(height)
                                 //print("Height \(height).")
                                 storyTableView?.rowHeight = CGFloat(height)
                             }
                             else
                             {
                                 let height = 210.0
                                 // cell.mainViewConstraint.constant = CGFloat(height)
                                 //print("Height \(height).")
                                 storyTableView?.rowHeight = CGFloat(height)
                             }
                             
                             
                         }
                         else
                         {
                             /*let height = 470.0
                              // cell.mainViewConstraint.constant = CGFloat(height)
                              print("Height \(height).")
                              storyTableView?.rowHeight = CGFloat(height)*/
                             //print(cell.ContentText?.text)
                             if((label.frame.height) > 17)
                             {
                                 let height = (label.frame.height) + 410.0
                                 //print("Height \((label.frame.height)).")
                                 storyTableView?.rowHeight = CGFloat(height)
                             }
                             else
                             {
                                 let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                                 //print("Height \((label.frame.height)).")
                                 storyTableView?.rowHeight = CGFloat(height)
                             }
                             
                             
                         }
                         
                         
                     } catch let error as NSError {
                         print(error)
                     }
                     
                 }
             }
             /* let teamId = mesgdict?.value(forKey: "relatedteam") as? Int
              let teamImageName = "Team" + teamId.description
              //print(teamImageName)
              
              let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
              if((teamImage) != nil)
              {
              cell.teamImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
              
              if(cell.teamImage?.image == nil)
              {
              appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "logo") as? String)!,view: (cell.teamImage)!, fileName: teamImageName as String)
              }
              }
              else
              {
              appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "logo") as? String)!,view: (cell.teamImage)!, fileName: teamImageName as String)
              }*/
             // cell.Mainview?.removeAllSubviews()
             //let height = cell.Headerview.frame.height + cell.coontentview.frame.height + cell.LCcounttview.frame.height + cell.LCSview.frame.height + 20.0
             
             
            /* let lastElement = appDelegate().arrMyFanUpdatesTeams.count - 1
             if(lastElement >= indexPath.row+1){
                 let dict: NSDictionary? = appDelegate().arrMyFanUpdatesTeams[indexPath.row + 1] as? NSDictionary
                 if(dict != nil)
                 {
                     let messageContent = dict?.value(forKey: "message")as! String
                     
                     if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                     {
                         do {
                             let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                             
                             let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                             if(recMessageType == "video")
                             {
                                 if let smillink = jsonDataMessage?.value(forKey: "smillink")
                                 {
                                     
                                     var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                     if(selVideoPath.isEmpty){
                                         selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                         ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                     }
                                     else{
                                         ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                     }
                                     
                                 }
                                 else{
                                     let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                     ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                 }
                                 //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                 //ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                             }
                         }
                         catch let error as NSError {
                             print(error)
                         }
                     }
                 }
             }
             
             if(lastElement >= indexPath.row+2){
                 let dict: NSDictionary? = appDelegate().arrMyFanUpdatesTeams[indexPath.row + 2] as? NSDictionary
                 if(dict != nil)
                 {
                     let messageContent = dict?.value(forKey: "message")as! String
                     
                     if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                     {
                         do {
                             let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                             
                             let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                             if(recMessageType == "video")
                             {
                                 if let smillink = jsonDataMessage?.value(forKey: "smillink")
                                 {
                                     
                                     var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                                     if(selVideoPath.isEmpty){
                                         selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                         ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                     }
                                     else{
                                         ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                     }
                                     
                                 }
                                 else{
                                     let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                     ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                 }
                                 //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                                 //ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                             }
                         }
                         catch let error as NSError {
                             print(error)
                         }
                     }
                 }
             }
             */
             
             
             
             
             return cell
        }

    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(folowedusername != ""){
             let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
             let isblocked = dict?.value(forKey: "isblocked") as! Bool
                                   if(isblocked){
                
                     return 200
                 }
                 else{
                                let messageContent = dict?.value(forKey: "message")as! String
                                
                                if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                                {
                                    do {
                                        let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                        
                                        let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                                        let screenSize = UIScreen.main.bounds
                                        let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width, height: CGFloat.greatestFiniteMagnitude))
                                        label.font = UIFont.systemFont(ofSize: 14.0)
                                        if(recMessageType == "text")
                                        {
                                            //cell.ContentText?.text = "Hello" //jsonDataMessage?.value(forKey: "value") as? String
                                            let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
                                            let decodedString = String(data: decodedData, encoding: .utf8)!
                                            label.text = decodedString
                                        }
                                        else if(recMessageType == "image")
                                        {
                                            //cell.PlayImage?.isHidden = false
                                            //cell.ContentImage?.isHidden = false
                                            var caption: String = ""
                                            if let capText = jsonDataMessage?.value(forKey: "caption")
                                            {
                                                caption = capText as! String
                                            }
                                            
                                            if(!caption.isEmpty)
                                            {
                                                let decodedData = Data(base64Encoded: caption)!
                                                let decodedString = String(data: decodedData, encoding: .utf8)!
                                                // cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                                //cell.ContentText?.isHidden = false
                                                label.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                            } else
                                            {
                                                label.text =  ""
                                                //cell.ContentText?.isHidden = true
                                            }
                                        }
                                        else if(recMessageType == "video")
                                        {
                                            //cell.PlayImage?.isHidden = false
                                           // cell.ContentImage?.isHidden = false
                                            var caption: String = ""
                                            if let capText = jsonDataMessage?.value(forKey: "caption")
                                            {
                                                caption = capText as! String
                                            }
                                            
                                            if(!caption.isEmpty)
                                            {
                                                let decodedData = Data(base64Encoded: caption)!
                                                let decodedString = String(data: decodedData, encoding: .utf8)!
                                               // cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                                //cell.ContentText?.isHidden = false
                                                label.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                            } else
                                            {
                                               label.text  = ""
                                                //cell.ContentText?.isHidden = true
                                            }
                                        }
                                       // label.text = cell.ContentText!.text
                                        label.textAlignment = .left
                                        //label.textColor = self.strokeColor
                                        label.lineBreakMode = .byWordWrapping
                                        label.numberOfLines = 0
                                        label.sizeToFit()
                                        
                                        if(recMessageType == "text")
                                        {
                                            /*let height = 240.0
                                             // cell.mainViewConstraint.constant = CGFloat(height)
                                             print("Height \(height).")
                                             storyTableView?.rowHeight = CGFloat(height)*/
                                            
                                            
                                            
                                            if((label.frame.height) > 17)
                                            {
                                                let height = (label.frame.height) + 210.0
                                                // cell.mainViewConstraint.constant = CGFloat(height)
                                                //print("Height \(height).")
                                                //storyTableView?.rowHeight = CGFloat(height)
                                                return height
                                            }
                                            else
                                            {
                                                let height = 210.0
                                                // cell.mainViewConstraint.constant = CGFloat(height)
                                                //print("Height \(height).")
                                                // storyTableView?.rowHeight = CGFloat(height)
                                                return CGFloat(height)
                                            }
                                            
                                            
                                        }
                                        else
                                        {
                                            /*let height = 470.0
                                             // cell.mainViewConstraint.constant = CGFloat(height)
                                             print("Height \(height).")
                                             storyTableView?.rowHeight = CGFloat(height)*/
                                            //print(cell.ContentText?.text)
                                           // print(label.frame.height)
                                            if((label.frame.height) > 16)
                                            {
                                                let height = (label.frame.height) + 410.0
                                                //print("Height \((label.frame.height)).")
                                                //storyTableView?.rowHeight = CGFloat(height)
                                                return height
                                            }
                                            else
                                            {
                                                let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                                                //print("Height \((label.frame.height)).")
                                                return CGFloat(height)
                                                //storyTableView?.rowHeight = CGFloat(height)
                                            }
                                            
                                            
                                        }
                                        
                                    } catch let error as NSError {
                                        print(error)
                                    }
                                    
                                }
                            }

             
            
             return 80
            
        }
        else{
            let cell:FanUpdatesCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FanUpdatesCell
                   let dict: NSDictionary? = arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
                   if(dict != nil)
                   {
                       let messageContent = dict?.value(forKey: "message")as! String
                       
                       if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                       {
                           do {
                               let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                               
                               let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                               let screenSize = UIScreen.main.bounds
                               let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width, height: CGFloat.greatestFiniteMagnitude))
                               label.font = UIFont.systemFont(ofSize: 14.0)
                               if(recMessageType == "text")
                               {
                                   //cell.ContentText?.text = "Hello" //jsonDataMessage?.value(forKey: "value") as? String
                                   let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
                                   let decodedString = String(data: decodedData, encoding: .utf8)!
                                   label.text = decodedString
                               }
                               else if(recMessageType == "image")
                               {
                                   //cell.PlayImage?.isHidden = false
                                   //cell.ContentImage?.isHidden = false
                                   var caption: String = ""
                                   if let capText = jsonDataMessage?.value(forKey: "caption")
                                   {
                                       caption = capText as! String
                                   }
                                   
                                   if(!caption.isEmpty)
                                   {
                                       let decodedData = Data(base64Encoded: caption)!
                                       let decodedString = String(data: decodedData, encoding: .utf8)!
                                       // cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                       //cell.ContentText?.isHidden = false
                                       label.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                   } else
                                   {
                                       label.text =  ""
                                       //cell.ContentText?.isHidden = true
                                   }
                               }
                               else if(recMessageType == "video")
                               {
                                   //cell.PlayImage?.isHidden = false
                                   // cell.ContentImage?.isHidden = false
                                   var caption: String = ""
                                   if let capText = jsonDataMessage?.value(forKey: "caption")
                                   {
                                       caption = capText as! String
                                   }
                                   
                                   if(!caption.isEmpty)
                                   {
                                       let decodedData = Data(base64Encoded: caption)!
                                       let decodedString = String(data: decodedData, encoding: .utf8)!
                                       // cell.ContentText?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                       //cell.ContentText?.isHidden = false
                                       label.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                                   } else
                                   {
                                       label.text  = ""
                                       //cell.ContentText?.isHidden = true
                                   }
                               }
                               // label.text = cell.ContentText!.text
                               label.textAlignment = .left
                               //label.textColor = self.strokeColor
                               label.lineBreakMode = .byWordWrapping
                               label.numberOfLines = 0
                               label.sizeToFit()
                               
                               if(recMessageType == "text")
                               {
                                   /*let height = 240.0
                                    // cell.mainViewConstraint.constant = CGFloat(height)
                                    print("Height \(height).")
                                    storyTableView?.rowHeight = CGFloat(height)*/
                                   
                                   
                                   
                                   if((label.frame.height) > 17)
                                   {
                                       let height = (label.frame.height) + 210.0
                                       // cell.mainViewConstraint.constant = CGFloat(height)
                                       //print("Height \(height).")
                                       //storyTableView?.rowHeight = CGFloat(height)
                                       return height
                                   }
                                   else
                                   {
                                       let height = 210.0
                                       // cell.mainViewConstraint.constant = CGFloat(height)
                                       //print("Height \(height).")
                                       // storyTableView?.rowHeight = CGFloat(height)
                                       return CGFloat(height)
                                   }
                                   
                                   
                               }
                               else
                               {
                                   /*let height = 470.0
                                    // cell.mainViewConstraint.constant = CGFloat(height)
                                    print("Height \(height).")
                                    storyTableView?.rowHeight = CGFloat(height)*/
                                   //print(cell.ContentText?.text)
                                   if((label.frame.height) > 16)
                                   {
                                       let height = (label.frame.height) + 410.0
                                       //print("Height \((label.frame.height)).")
                                       //storyTableView?.rowHeight = CGFloat(height)
                                       return height
                                   }
                                   else
                                   {
                                       let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                                       //print("Height \((label.frame.height)).")
                                       return CGFloat(height)
                                       //storyTableView?.rowHeight = CGFloat(height)
                                   }
                                   
                                   
                               }
                               
                           } catch let error as NSError {
                               print(error)
                           }
                           
                       }
                   }
                   
                   return 80
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("You tapped cell number \(indexPath.row).")
        
        /*
         // Configure the cell...
         let dict: NSDictionary? = appDelegate().arrMyFanUpdatesTeams[indexPath.row] as? NSDictionary
         
         let messageContent = dict?.value(forKey: "message")as! String
         
         if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
         {
         do {
         let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
         
         let selMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
         let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
         
         //let selMessageType = dict?.value(forKey: "type") as! String
         // let selVideoPath = dict?.value(forKey: "value") as! String
         
         q  d
         if(selMessageType == "image")
         {
         //let mediaURL = message.value(forKey: "filePath") as! String
         //let asset: PHAsset = PHAssetForFileURL(url: NSURL(string: mediaURL)!)!
         
         appDelegate().isFromPreview = true
         
         if(!selVideoPath.isEmpty)
         {
         showMediaPreview(selMessageType, mediaPath: selVideoPath, isLocalMedia: false)
         
         }
         }
         else if(selMessageType == "video")
         {
         
         appDelegate().isFromPreview = true
         //selVideoPath = selVideoPath.replace(target: "///", withString: "//")
         if(!selVideoPath.isEmpty)
         {
         DispatchQueue.main.async {
         
         let playerItem = AVPlayerItem.init(url:URL.init(string: selVideoPath)!)
         let player = AVPlayer(playerItem: playerItem)
         
         let playerViewController = AVPlayerViewController()
         playerViewController.player = player
         self.present(playerViewController, animated: true) {
         playerViewController.player!.play()
         }
         
         
         }
         }
         
         }
         
         } catch let error as NSError {
         print(error)
         }
         }
         */
        
        /* appDelegate().fanUpdatesTeamId = (dict?.value(forKey: "id") as? Int)!
         appDelegate().fanUpdatesTeamName = (dict?.value(forKey: "name") as? String)!
         
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let registerController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "Updates")
         //present(registerController as! UIViewController, animated: true, completion: nil)
         self.appDelegate().curRoomType = "fanupdates"
         show(registerController as! UIViewController, sender: self)*/
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
           // pausePlayeVideos()
        }
    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: storyTableView!)
        
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: storyTableView!, appEnteredFromBackground: true)
    }
    func getVideoThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = CGSize(width: 320, height: 180) //.maximumSize = CGSize
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            let img: UIImage = UIImage(cgImage: thumbnailImage)
            return img
        } catch let error {
            // print(error)
            let img: UIImage = UIImage(named: "splash_bg")!
            return img
        }
    }
    
    func showMediaPreview(_ mediaType: String, mediaPath: String, isLocalMedia: Bool = false) {
        if(!mediaType.isEmpty && !mediaPath.isEmpty)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let previewController : MediaPreviewController! = storyBoard.instantiateViewController(withIdentifier: "MediaPreview") as? MediaPreviewController
            
            if(mediaType == "image")
            {
                previewController.imagePath = mediaPath
            }
            else if(mediaType == "video")
            {
                previewController.videoPath = mediaPath
                
            }
            previewController.isLocalMedia = isLocalMedia
            previewController.mediaType = mediaType
            /*show(previewController!, sender: self)*/
            self.present(previewController, animated: true, completion: nil)
        }
    }
   
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}