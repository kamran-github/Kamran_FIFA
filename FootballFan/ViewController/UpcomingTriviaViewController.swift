//
//  UpcomingTriviaViewController.swift
//  FootballFan
//
//  Created by Apple on 30/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MapKit
import Alamofire
import UserNotifications
class UpcomingTriviaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate {
     var isupcomingtriviaPageRefresh: Bool = false
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "UpcomingTriviaCell"
    var dictAllTeams = NSMutableArray()
    var lastposition = 0
   // var returnToOtherView:Bool = false
    //var returnToPreView:Bool = false
    var locationManager: CLLocationManager!
   // var fanupdateOnForgroundView:Bool = true
    @IBOutlet weak var Buttomloader: UIView?
    @IBOutlet weak var tableviewButtomConstraint: NSLayoutConstraint!
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var totelteams = ""
    var SelectedTitel = ""
    var strings:[String] = []
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var Connectinglabel: UILabel?
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
   var currentLocation: CLLocation!
    var selectedindex : Int = 0
     var infoAlertVC = MessageAlertViewController.instantiate()
      var TermsAlert = FancoinAlertViewController.instantiate()
    var ConfermationAlert = TriviaPurchaseAlert.instantiate()
     var freetriviaAlert = FreeTriviaPurchaseAlert.instantiate()
     @IBOutlet weak var butlatestview: UIButton!
     var tempupcommingTrivia: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        parent?.navigationItem.rightBarButtonItems = nil
      
        
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
      
       
        let notificationName = Notification.Name("_FechedFanUpdateTeams")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fechedFanUpdateTeams), name: notificationName, object: nil)
        let notificationNamelive = Notification.Name("trivialive")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.tirivialive), name: notificationNamelive, object: nil)
        let notificationName2 = Notification.Name("_FetchedFanUpdates")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedFanUpdates), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_FechedFanUpdate")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdate(_:)), name: notificationName3, object: nil)
        
        let notificationName1 = Notification.Name("_FanUpdateSaveLike")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.FanUpdateSaveLike), name: notificationName1, object: nil)
        let notification_pemission = Notification.Name("gotosettingForPush")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushGotosetting), name: notification_pemission, object: nil)
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdate(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        //  self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        
        let notificationName5 = Notification.Name("_isUserOnlineNotifyUpdate")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(UpcomingTriviaViewController.isUserOnline), name: notificationName5, object: nil)
        let notificatonUpcommingPurchse = Notification.Name("upcomingtriviapurchse")
              // Register to receive notification
              NotificationCenter.default.addObserver(self, selector: #selector(UpcomingTriviaViewController.Buynow), name: notificatonUpcommingPurchse, object: nil)
       /* let notificationName6 = Notification.Name("_GetPermissionsForupcoming")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetPermissionsForLocation), name: notificationName6, object: nil)*/
        //getFanUpdate(lastposition)
        let cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
        storyTableView!.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
        storyTableView!.separatorStyle = .none
       let notificatonreload = Notification.Name("reloadtable")
                   // Register to receive notification
                   NotificationCenter.default.addObserver(self, selector: #selector(reloadnow), name: notificatonreload, object: nil)
        //gettrivia(0)
        if(appDelegate().arrupcommingTrivia.count == 0)
               {
                  gettrivia(0)
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "Fan Stories"
        
        navigationController?.isNavigationBarHidden = false
        /*if(!(self.activityIndicator?.isAnimating)!)
         {
         self.activityIndicator?.startAnimating()
         }*/
       
        let button2 = UIBarButtonItem(image: UIImage(named: "pasttrivia"), style: .plain, target: self, action: #selector(self.showoldtrivia))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2
        //let settingsImage   = UIImage(named: "refresh")!
        // let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.refreshView))
        navigationItem.rightBarButtonItem = rightSearchBarButtonItem1
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
           
            // lastposition = 0
           
            if ClassReachability.isConnectedToNetwork() {
                
                if(appDelegate().isUserOnline)
                {
                    ConectingHightConstraint.constant = CGFloat(0.0)
                    //self.parent?.title = "Fan Stories"
                }
                else
                {
                    Connectinglabel?.text = "Connecting..."
                    ConectingHightConstraint.constant = CGFloat(0.0)
                    // self.parent?.title = "Connecting.."
                }
                
            } else {
                // self.parent?.title = "Waiting for network.."
                Connectinglabel?.text = "Waiting for network..."
                ConectingHightConstraint.constant = CGFloat(20.0)
            }
            
        }
        else{
            
            if ClassReachability.isConnectedToNetwork() {
                Connectinglabel?.text = "Connecting..."
                ConectingHightConstraint.constant = CGFloat(0.0)
            }else{
                Connectinglabel?.text = "Waiting for network..."
                ConectingHightConstraint.constant = CGFloat(20.0)
            }
            //self.ConectingHightConstraint.constant = CGFloat(0.0)
        }
        
        
      
        
         if(appDelegate().arrupcommingTrivia.count > 0)
                      
        {
            getlastetrivia()

         /* if(returnToOtherView){
                gettrivia(lastposition)
            } else {
                if(appDelegate().arrupcommingTrivia.count == 0)
                {
                    lastposition = 0
                    gettrivia(lastposition)
                   
                }else{
                     getlastetrivia()
                }
            }*/
        }
        //fanupdateOnForgroundView = true
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
                        // self.parent?.title = "Fan Stories"
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
                    LoadingIndicatorView.hide()
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
                // self.ConectingHightConstraint.constant = CGFloat(0.0)
            }
            
            //}
        }
    }
   
    
    
    
   
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func getlastetrivia()  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "gettrivia" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            
                isupcomingtriviaPageRefresh = true
           
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
               
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
                
               
                reqParams["lastindex"] = 0 as AnyObject
                 reqParams["lasttime"] = appDelegate().APIgettriviatime as AnyObject
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
              /*  let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                var reqParams1 = [String: AnyObject]()
                reqParams1["request"] = strFanUpdates as AnyObject
                let url = MediaAPIjava + "request=" + escapedString!*/
                //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
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
                                                                              let response: NSArray = json["responseData"]  as! NSArray
                                                                               
                                                                              let isNewData = json["isNewData"]  as! Bool
                                                                                                                 if(isNewData){
                                                                                                                     self.butlatestview.isHidden = false
                                                                                                                   
                                                                                                                         // self.setView(view: self.butlatestview)
                                                                                                                     self.butlatestview.transform = self.butlatestview.transform.scaledBy(x: 0.01, y: 0.01)
                                                                                                                     UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromTop, animations: {
                                                                                                                       // 3
                                                                                                                         self.butlatestview.transform = CGAffineTransform.identity
                                                                                                                     }, completion: nil)

                                                                                                                   
                                                                                                                  self.tempupcommingTrivia = response as [AnyObject]
                                                                                                                 }
                                                                              
                                                                              
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
                                                                    debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                        
                }
              
              
            } catch {
                print(error.localizedDescription)
            }
        }else {
            //LoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func gettrivia(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "gettrivia" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            /*if(appDelegate().arrupcommingTrivia.count == 0){
                 TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            }*/
            if(lastindex == 0)
            {
                //LoadingIndicatorView.show(self.view, loadingText: "")
                isupcomingtriviaPageRefresh = true
            } else
            {
                isupcomingtriviaPageRefresh = false
            }
            do {
                self.butlatestview.isHidden = true
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
               
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
                
               
                reqParams["lastindex"] = lastindex as AnyObject
                
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
               /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                var reqParams1 = [String: AnyObject]()
                reqParams1["request"] = strFanUpdates as AnyObject
                let url = MediaAPIjava + "request=" + escapedString!*/
                //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
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
                                                                              self.butlatestview.isHidden = true
                                                                              let response: NSArray = json["responseData"]  as! NSArray
                                                                               self.appDelegate().APIgettriviatime = self.appDelegate().getUTCFormateDate()
                                                                              //print(response)
                                                                              if(self.isupcomingtriviaPageRefresh)
                                                                              {
                                                                                  //arrFanUpdatesTeams
                                                                                  self.appDelegate().arrupcommingTrivia = response  as [AnyObject]
                                                                              }
                                                                              else
                                                                              {
                                                                                  self.appDelegate().arrupcommingTrivia += response  as [AnyObject]
                                                                              }
                                                                              //print(arrFanUpdatesTeams.count)
                                                                              // print(fanUpdates)
                                                                              let notificationName = Notification.Name("_FechedFanUpdateTeams")
                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                              
                                                                              
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                     self.butlatestview.isHidden = true
                                                                                      
                                                                                      if(self.isupcomingtriviaPageRefresh)
                                                                                      {
                                                                                          self.appDelegate().arrupcommingTrivia  = [AnyObject]()
                                                                                          let notificationName = Notification.Name("_FechedFanUpdateTeams")
                                                                                          NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                      } else
                                                                                      {
                                                                                          let notificationName = Notification.Name("_FetchedFanUpdates")
                                                                                          NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                          
                                                                                      }
                                                                                      
                                                                                      
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                                                                     debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                        
                }
              
              
            } catch {
                print(error.localizedDescription)
            }
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    
    @objc func refreshFanUpdate(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
       isupcomingtriviaPageRefresh = true
        if ClassReachability.isConnectedToNetwork() {
            gettrivia(lastindex)
           
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
        //ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: storyTableView!, appEnteredFromBackground: true)
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : CommentViewController! = storyBoard.instantiateViewController(withIdentifier: "Comment") as? CommentViewController
            registerController.fanupdateid = fanuid
            registerController.SelectedTitel = SelectedTitel
            //present(registerController as! UIViewController, animated: true, completion: nil)
            // self.appDelegate().curRoomType = "chat"
            show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    func showEditWindow(dict: NSDictionary) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : EditFanUpdateViewController! = storyBoard.instantiateViewController(withIdentifier: "EditFanUpdate") as? EditFanUpdateViewController
        registerController.dict = dict
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }
    
    
    func showLikeWindow(fanuid: Int64) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : LikeViewController! = storyBoard.instantiateViewController(withIdentifier: "likes") as? LikeViewController
        registerController.fanupdateid = fanuid
        registerController.SelectedTitel = SelectedTitel
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }

    @objc func FanUpdateSaveLike(notification: NSNotification)
    {
        let subtypevalue = (notification.userInfo?["savelike"] )as! NSDictionary
        print(subtypevalue)
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        //storyTableView?.reloadData()
    }
    @objc func pushGotosetting(notification: NSNotification)
    {
        DispatchQueue.main.async {
            let cantAddContactAlert = UIAlertController(title: "Enable Notifications",
                                                        message: "Football Fan is fun when notifications are enabled.",
                                                        preferredStyle: .alert)
            cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                        style: .default,
                                                        handler: { action in
                                                            let url = NSURL(string: UIApplication.openSettingsURLString)
                                                            UIApplication.shared.openURL(url! as URL)
            }))
            cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                
            }))
            self.present(cantAddContactAlert, animated: true, completion: nil)
        }
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        //storyTableView?.reloadData()
    }
    @objc func tirivialive(notification: NSNotification)
    {
        DispatchQueue.main.async {
             let lastindex = (notification.userInfo?["index"] )as! Int
        var dict1: [String: AnyObject] = self.appDelegate().arrupcommingTrivia[lastindex] as! [String: AnyObject]
        dict1["Status"] = "Live" as AnyObject
        
        self.appDelegate().arrupcommingTrivia[lastindex] = dict1 as AnyObject
        
        self.storyTableView?.reloadData()
        }
    }
    @objc func fechedFanUpdateTeams()
    {
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        Buttomloader?.isHidden = true
        
        closeRefresh()
        if(appDelegate().arrupcommingTrivia.count == 0){
            TransperentLoadingIndicatorView.hide()
            notelable?.isHidden = false
            storyTableView?.reloadData()
            storyTableView?.isHidden = false
            let bullet1 = "No trivia available"
           // let bullet2 = "Please try again later or post your own update."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1]
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                TransperentLoadingIndicatorView.hide()
                // Code you want to be delayed
            }
            
            tableviewButtomConstraint.constant = 5
            notelable?.isHidden = true
            storyTableView?.reloadData()
            storyTableView?.isHidden = false
          
        }
    }
    
    @objc func fetchedFanUpdates()
    {
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        Buttomloader?.isHidden = true
        if(appDelegate().arrupcommingTrivia.count == 0){
            
            notelable?.isHidden = false
            
            storyTableView?.isHidden = true
             let bullet1 = "No trivia available"
           // let bullet2 = "Please try again later or post your own update."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1]
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
            tableviewButtomConstraint.constant = 5
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
            UpcomingTriviaViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return UpcomingTriviaViewController.realDelegate!;
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
        
        return appDelegate().arrupcommingTrivia.count
    }
    
    @objc func OpenTriviaAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            selectedindex = indexPath.row
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
                if ClassReachability.isConnectedToNetwork() {
                 let dict: NSDictionary? = self.appDelegate().arrupcommingTrivia[self.selectedindex] as? NSDictionary
                      let status = dict?.value(forKey: "Status") as! String
                      if(status == "Finished"){
                          
                      }
                      else if(status == "Live"){
                          let mili1 = dict?.value(forKey: "EndTime")
                          let number: Int64? = Int64(mili1 as! String)
                          let mili: Double = Double(truncating: number! as NSNumber)
                          let timeNow = Date()
                          let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                          let timeEnd : Date = myMilliseconds.dateFull as Date
                          if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                              
                          self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                           self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                          let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                          myTeamsController.triviadetail = dict!
                          //self.returnToOtherView = true
                          self.show(myTeamsController, sender: self)
                          }
                          else{
                              self.gettrivia(0)
                              self.infoAlertVC = MessageAlertViewController.instantiate()
                              guard let customAlertVC = self.infoAlertVC else { return }
                              
                              customAlertVC.titleString = "Sorry!"
                            customAlertVC.mediaurl = "thumb_down"
                              customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                              //   customAlertVC.mediatype = mediatype
                              //  customAlertVC.mediaurl = mediaurl
                              customAlertVC.ActionTitle = "Ok"
                              // customAlertVC.actioncommand = action
                              //customAlertVC.actionlink = link
                              //customAlertVC.LinkTitle = linktitle
                              
                              let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                              // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                              popupVC.cornerRadius = 20
                              self.present(popupVC, animated: true, completion: nil)
                          }
                      }
                      if(status == "Finished"){
                          
                      }
                      else if(status == "Published"){
                          let Purchased = dict?.value(forKey: "Purchased") as! Bool
                          if(Purchased){
                              //cell.triviastatus?.text = "Already Booked"
                          }
                          else{
                              let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                              if(FreeTrivia){
                                    self.freetriviaAlert = FreeTriviaPurchaseAlert.instantiate()
                                                                            guard let customAlertVC = self.freetriviaAlert else { return }
                                                                            
                                                             
                                                                     
                                                       // customAlertVC.upcomingtriviadetail = dict!
                                customAlertVC.onpageview = "upcomming"
                               // customAlertVC.triviaTypeString = "FreeTrivia"
                                                                     let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 450)
                                                                     // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                     popupVC.cornerRadius = 20
                                                                     self.present(popupVC, animated: true, completion: nil)
                              }
                              else{
                                  let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                                  let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                  if(avilablecoin > ticketprize){
                                     self.ConfermationAlert = TriviaPurchaseAlert.instantiate()
                                                                                                        guard let customAlertVC = self.ConfermationAlert else { return }
                                                                                                        
                                   // customAlertVC.upcomingtriviadetail = dict!
                                    customAlertVC.triviaprice = ticketprize
                                    customAlertVC.onpageview = "upcomming"
                                   // customAlertVC.triviaTypeString = "Trivia"
                                    let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 467)
                                    // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                    popupVC.cornerRadius = 20
                                    self.present(popupVC, animated: true, completion: nil)
                                     // self.Buynow(self.selectedindex)
                                  }else{
                                      
                                     /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                      let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                      self.returnToOtherView = true
                                      self.show(registerController, sender: self)*/
                                      self.TermsAlert = FancoinAlertViewController.instantiate()
                                                                         guard let customAlertVC = self.TermsAlert else { return }
                                                                         
                                                                         //customAlertVC.upcomingtriviadetail = dict!
                                                                          customAlertVC.onpageview = "upcomming"
                                                                                                            customAlertVC.triviaTypeString = "buyfc"
                                                                         let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 417)
                                                                         // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                         popupVC.cornerRadius = 20
                                                                         self.present(popupVC, animated: true, completion: nil)
                                      //InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
                                  }
                              }
                             
                          }
                         
                      }
                  } else {
                    alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                    
                }
            }else{
                let dict: NSDictionary? = appDelegate().arrupcommingTrivia[indexPath.row] as? NSDictionary
                let status = dict?.value(forKey: "Status") as! String
                if(status == "Live"){
                    if ClassReachability.isConnectedToNetwork() {
                        let mili1 = dict?.value(forKey: "EndTime")
                                               let number: Int64? = Int64(mili1 as! String)
                                               let mili: Double = Double(truncating: number! as NSNumber)
                                               let timeNow = Date()
                                               let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                               let timeEnd : Date = myMilliseconds.dateFull as Date
                                               if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                                               self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                                               self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                                               let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                               let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                                                myTeamsController.triviadetail = dict!
                                               
                                               self.show(myTeamsController, sender: self)
                                               }else{
                                                   self.gettrivia(0)
                                                   self.infoAlertVC = MessageAlertViewController.instantiate()
                                                   guard let customAlertVC = self.infoAlertVC else { return }
                                                   customAlertVC.titleString = "Sorry!"
                                                                              customAlertVC.mediaurl = "thumb_down"
                                                   
                                                   customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                                                   //   customAlertVC.mediatype = mediatype
                                                   //  customAlertVC.mediaurl = mediaurl
                                                   customAlertVC.ActionTitle = "Ok"
                                                   // customAlertVC.actioncommand = action
                                                   //customAlertVC.actionlink = link
                                                   //customAlertVC.LinkTitle = linktitle
                                                   
                                                   let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                                                   // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                   popupVC.cornerRadius = 20
                                                   self.present(popupVC, animated: true, completion: nil)
                                                   
                                               }
                        
                    } else {
                        alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                        
                    }
                   
                   
                }
                else {
                appDelegate().LoginwithModelPopUp()
                }
            }
        }
        
    }
    
  /*  @objc func GetPermissionsForLocation(notification: NSNotification)
    {
       
        LoadingIndicatorView.show(self.view, loadingText: "Retrieving your current location")
       
        locationManager = CLLocationManager()
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
           
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
        else if status == .authorizedAlways {
            //print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //currentLocation = locations.last
        // aTextField?.endEditing(true)
        if currentLocation == nil {
            currentLocation = locations.last
            manager.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            // print("locations = \(locationValue)")
            
            manager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil)
                {
                    //print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks!.count > 0)
                {
                    let containsPlacemark = placemarks![0] as CLPlacemark
                   
                        //stop updating location to save battery life
                    //print(containsPlacemark.isoCountryCode)
                    let isoCountryCode: String = (containsPlacemark.isoCountryCode != nil) ? containsPlacemark.isoCountryCode! : ""
                    let dict: NSDictionary? = self.appDelegate().arrupcommingTrivia[self.selectedindex] as? NSDictionary
                    let AvailableCountries: String = dict?.value(forKey: "AvailableCountries") as! String
                    LoadingIndicatorView.hide()
                    if(AvailableCountries.contains(isoCountryCode)){
                    let login: String? = UserDefaults.standard.string(forKey: "userJID")
                    if(login != nil){
                  
                        let status = dict?.value(forKey: "Status") as! String
                        if(status == "Finished"){
                            
                        }
                        else if(status == "Live"){
                            let mili1 = dict?.value(forKey: "EndTime")
                            let number: Int64? = Int64(mili1 as! String)
                            let mili: Double = Double(truncating: number! as NSNumber)
                            let timeNow = Date()
                            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                            let timeEnd : Date = myMilliseconds.dateFull as Date
                            if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                                
                            self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                             self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                            myTeamsController.triviadetail = dict!
                           
                            self.show(myTeamsController, sender: self)
                            }
                            else{
                                self.gettrivia(0)
                                self.infoAlertVC = MessageAlertViewController.instantiate()
                                guard let customAlertVC = self.infoAlertVC else { return }
                                
                                customAlertVC.titleString = "contactsync"
                                customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                                //   customAlertVC.mediatype = mediatype
                                //  customAlertVC.mediaurl = mediaurl
                                customAlertVC.ActionTitle = "Ok"
                                // customAlertVC.actioncommand = action
                                //customAlertVC.actionlink = link
                                //customAlertVC.LinkTitle = linktitle
                                
                                let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 265)
                                // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                popupVC.cornerRadius = 20
                                self.present(popupVC, animated: true, completion: nil)
                            }
                        }
                        if(status == "Finished"){
                            
                        }
                        else if(status == "Published"){
                            let Purchased = dict?.value(forKey: "Purchased") as! Bool
                            if(Purchased){
                                //cell.triviastatus?.text = "Already Booked"
                            }
                            else{
                                let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                                if(FreeTrivia){
                                    self.Buynow(self.selectedindex)
                                }
                                else{
                                    let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                                    let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                    if(avilablecoin > ticketprize){
                                        self.Buynow(self.selectedindex)
                                    }else{
                                        
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                        self.returnToOtherView = true
                                        self.show(registerController, sender: self)
                                        
                                        //InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
                                    }
                                }
                               
                            }
                           
                        }
                    }
                    else{
                        let mili1 = dict?.value(forKey: "EndTime")
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        let timeNow = Date()
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        let timeEnd : Date = myMilliseconds.dateFull as Date
                        if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                        self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                        self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                         myTeamsController.triviadetail = dict!
                        self.returnToOtherView = true
                        self.show(myTeamsController, sender: self)
                        }else{
                            self.gettrivia(0)
                            self.infoAlertVC = MessageAlertViewController.instantiate()
                            guard let customAlertVC = self.infoAlertVC else { return }
                            
                            customAlertVC.titleString = "contactsync"
                            customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                            //   customAlertVC.mediatype = mediatype
                            //  customAlertVC.mediaurl = mediaurl
                            customAlertVC.ActionTitle = "Ok"
                            // customAlertVC.actioncommand = action
                            //customAlertVC.actionlink = link
                            //customAlertVC.LinkTitle = linktitle
                            
                            let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 265)
                            // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                            popupVC.cornerRadius = 20
                            self.present(popupVC, animated: true, completion: nil)
                            
                        }
                    }
                    }
                    else{
                        self.infoAlertVC = MessageAlertViewController.instantiate()
                        guard let customAlertVC = self.infoAlertVC else { return }
                        
                        customAlertVC.titleString = "contactsync"
                        customAlertVC.messageString = "This Trivia is only available in United Kingdom."
                     //   customAlertVC.mediatype = mediatype
                      //  customAlertVC.mediaurl = mediaurl
                        customAlertVC.ActionTitle = "Ok"
                       // customAlertVC.actioncommand = action
                        //customAlertVC.actionlink = link
                        //customAlertVC.LinkTitle = linktitle
                        
                        let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 265)
                            // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                            popupVC.cornerRadius = 20
                          self.present(popupVC, animated: true, completion: nil)
                        
                    }
                       // let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
                        // let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
                        //let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
                        //let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
                   
                }
                else
                {
                    //print("Problem with the data received from geocoder")
                }
            })
            //Call API to save current location
           
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        displayCantAddContactAlert()
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot get location",
                                                    message: "You must give the app permission to get your current location.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        LoadingIndicatorView.hide()
                                                        self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            LoadingIndicatorView.hide()
            self.closeRefresh()
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    func openSettings() {
        /*if(refreshTable.isRefreshing)
         {
         refreshTable.endRefreshing()
         }
         else
         {
         if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }
         
         }
         isLoadingContacts = false
         storyTableView?.isScrollEnabled = true*/
        
        let url = NSURL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(url! as URL)
    }*/
    @objc func reloadnow()  {
        DispatchQueue.main.async {
            if(self.appDelegate().arrupcommingTrivia.count == 0){
                       TransperentLoadingIndicatorView.hide()
                self.notelable?.isHidden = false
                self.storyTableView?.reloadData()
                self.storyTableView?.isHidden = false
                       let bullet1 = "No trivia available"
                      // let bullet2 = "Please try again later or post your own update."
                       //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
                       // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
                       
                self.strings = [bullet1]
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
                       
                   }
                   else{
            self.storyTableView?.reloadData()
            }
        }
    }
    @objc func Buynow()  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "buyticket" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            
            //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
                let dict: NSDictionary? = appDelegate().arrupcommingTrivia[selectedindex] as? NSDictionary
                let roomjid = dict?.value(forKey: "GroupID") as! String
                 let Title = dict?.value(forKey: "Title") as! String
                reqParams["redeemcoins"] = dict?.value(forKey: "TicketPrice") as AnyObject
                let arrdRoomJid = roomjid.components(separatedBy: "@")
                let roomid = arrdRoomJid[0]
                reqParams["roomid"] = roomid as AnyObject
                 let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                if(FreeTrivia){
                    reqParams["termsaccepted"] = "Good News!\nYou can play this Trivia for free\nYou confirm that you are 18+ years old, have a UK mailing address to receive prize, and agree to our\nTrivia Terms and Conditions" as AnyObject
                }
                else{
                    let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                     reqParams["termsaccepted"] = "Good News!\nRedeem \(dict?.value(forKey: "TicketPrice") as! Double) from \(avilablecoin) FanCoins\nto play\nYou confirm that you are 18+ years old, have a UK mailing address to receive prize, and agree to our\nTrivia Terms and Conditions" as AnyObject
                }
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
               /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                var reqParams1 = [String: AnyObject]()
                reqParams1["request"] = strFanUpdates as AnyObject
                let url = MediaAPIjava + "request=" + escapedString!*/
                //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
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
                                                                              
                                                                              let response: NSArray = json["responseData"]  as! NSArray
                                                                              let myProfileDict: NSDictionary = response[0] as! NSDictionary
                                                                              let totalcoins = myProfileDict.value(forKey: "totalcoins") as! Int
                                                                              
                                                                              let availablecoins = myProfileDict.value(forKey: "availablecoins") as! Int
                                                                              //print(response)
                                                                              self.appDelegate().AddCoin(fctotalcoin: totalcoins, fcavailablecoin: availablecoins)
                                                                              var dict1: [String: AnyObject] = self.appDelegate().arrupcommingTrivia[self.selectedindex] as! [String: AnyObject]
                                                                              dict1["Purchased"] = true as AnyObject
                                                                              
                                                                              self.appDelegate().arrupcommingTrivia[self.selectedindex] = dict1 as AnyObject
                                                                              
                                                                              self.storyTableView?.reloadData()
                                                                              // self.gettrivia(0)
                                                                              
                                                                               //TransperentLoadingIndicatorView.hide()
                                                                              self.infoAlertVC = MessageAlertViewController.instantiate()
                                                                              guard let customAlertVC = self.infoAlertVC else { return }
                                                                              
                                                                              customAlertVC.titleString = "Congratulations!"
                                                                              if let mili1 = dict?.value(forKey: "StartTime")
                                                                                        {
                                                                                            
                                                                                            let number: Int64? = Int64(mili1 as! String)
                                                                                            let mili: Double = Double(truncating: number! as NSNumber)
                                                                                            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                                                                            
                                                                                            let dateFormatter = DateFormatter()
                                                                                            dateFormatter.dateFormat = "dd MMM yy HH:mm"
                                                                                             dateFormatter.timeZone = TimeZone(abbreviation: "BST")
                                                                                           
                                                                                           customAlertVC.messageString = "Your entry to \(Title) starting at \(dateFormatter.string(from:myMilliseconds.dateFull)) is secured"
                                                                                        }
                                                                               customAlertVC.messageString = "Your entry to \(Title) is secured"
                                                                              //   customAlertVC.mediatype = mediatype
                                                                                customAlertVC.mediaurl = "thumbs_up"
                                                                              customAlertVC.ActionTitle = "Ok"
                                                                              // customAlertVC.actioncommand = action
                                                                              //customAlertVC.actionlink = link
                                                                              //customAlertVC.LinkTitle = linktitle
                                                                              
                                                                              let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                                                                              // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                              popupVC.cornerRadius = 20
                                                                              self.present(popupVC, animated: true, completion: nil)
                                                                              if(self.appDelegate().arrhometrivia.count>0){
                                                                                  for i in 0...self.appDelegate().arrhometrivia.count-1 {
                                                                                      let dict: NSDictionary? = self.appDelegate().arrhometrivia[i] as? NSDictionary
                                                                                             if(dict != nil)
                                                                                             {
                                                                                              let GroupID = dict?.value(forKey: "GroupID") as! String
                                                                                              if(roomjid == GroupID){
                                                                                                  var dict1: [String: AnyObject] = self.appDelegate().arrhometrivia[i] as! [String: AnyObject]
                                                                                                             dict1["Purchased"] = true as AnyObject
                                                                                                             
                                                                                                  self.appDelegate().arrhometrivia[i] = dict1 as AnyObject
                                                                                                  let notificationName = Notification.Name("resetslider")
                                                                                                                                                                                                        NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                  
                                                                                                  break
                                                                                                             
                                                                                              }
                                                                                      }
                                                                                  }
                                                                              }
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                          
                                                                                         
                                                                                          let soldout = json["soldout"] as! Bool
                                                                                          let error = json["error"]  as! String
                                                                                          if(soldout){
                                                                                              
                                                                                             var dict1: [String: AnyObject] = self.appDelegate().arrupcommingTrivia[self.selectedindex] as! [String: AnyObject]
                                                                                              dict1["soldout"] = true as AnyObject
                                                                                              
                                                                                                self.appDelegate().arrupcommingTrivia[self.selectedindex] = dict1 as AnyObject
                                                                                                                                
                                                                                                                                self.storyTableView?.reloadData()
                                                                                          }
                                                                                          self.infoAlertVC = MessageAlertViewController.instantiate()
                                                                                          guard let customAlertVC = self.infoAlertVC else { return }
                                                                                          
                                                                                          customAlertVC.titleString = "Sorry!"
                                                                                          customAlertVC.messageString = error
                                                                                          //   customAlertVC.mediatype = mediatype
                                                                                            customAlertVC.mediaurl = "thumb_down"
                                                                                          customAlertVC.ActionTitle = "Ok"
                                                                                          // customAlertVC.actioncommand = action
                                                                                          //customAlertVC.actionlink = link
                                                                                          //customAlertVC.LinkTitle = linktitle
                                                                                          
                                                                                          let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                                                                                          // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                          popupVC.cornerRadius = 20
                                                                                          self.present(popupVC, animated: true, completion: nil)
                                                                                          
                                                                                          
                                                                                          
                                                                                          
                                                                                  }
                                                                              //Show Error
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                       
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }else {
            //TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
       
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = appDelegate().arrupcommingTrivia[indexPath.row] as? NSDictionary
            // print(dict)
            // print(dict?.value(forKey: "username"))
            do {
                let fanupdateid = dict?.value(forKey: "ID") as! Int64
                var dictRequest = [String: AnyObject]()
                dictRequest["id"] = fanupdateid as AnyObject
                dictRequest["type"] = "trivia" as AnyObject
                let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                
                let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                
                let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                
                let title = dict?.value(forKey: "Title") as! String
                
                let param = resultNSString as String?
                
                let inviteurl = InviteHost + "?q=" + param!
               
                                          //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
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
                /*let myWebsite = NSURL(string: inviteurl)
                let shareAll = [text, myWebsite as Any] as [Any]
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)*/
                
                
                
            } catch {
                print(error.localizedDescription)
            }
            
           
        }
        
    }
    
   
    
    func saveImageToLocalWithNameReturnPath(_ image: UIImage, fileName: String) -> String{
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + fileName + ".png")
        //print(paths)
        if(fileManager.fileExists(atPath: paths))
        {
            print(paths)
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
        if(appDelegate().arrupcommingTrivia.count > 19)
        {
            
            let lastElement = appDelegate().arrupcommingTrivia.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                Buttomloader?.isHidden = false
                tableviewButtomConstraint.constant = 35
                lastposition = lastposition + 1
                gettrivia(lastposition)
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! UpcomingTriviaCell
        
        
        let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenTriviaAction(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        
    
        
        let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
        
        
        cell.share?.addGestureRecognizer(longPressGesture_share)
        cell.share?.isUserInteractionEnabled = true
        
       
        
        /*  let PressGesture_sound:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(soundClick(_:)))
         //longPressGesture.minimumPressDuration = 1.0 // 1 second press
         PressGesture_sound.delegate = self as? UIGestureRecognizerDelegate
         cell.soundImg?.addGestureRecognizer(PressGesture_sound)
         cell.soundImg?.isUserInteractionEnabled = true*/
      
       // let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        //longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
        
        //let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        //longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
        
        //cell.PlayImage?.addGestureRecognizer(longPressGesture_showpreview)
        //cell.PlayImage?.isUserInteractionEnabled = true
        
        
        //cell.ContentImage?.addGestureRecognizer(longPressGesture_showpreview1)
        //cell.ContentImage?.isUserInteractionEnabled = true
        
        
       
        
      
        // Configure the cell...
        let dict: NSDictionary? = appDelegate().arrupcommingTrivia[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
          
            var thumbLink: String = ""
            if let thumb = dict?.value(forKey: "TriviaImage")
            {
                thumbLink = thumb as! String
            }
            //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
            cell.ContentImage.imageURL = thumbLink
            
                        //cell.soundImg?.isHidden = true
                        cell.ContentImage?.isHidden = false
                        var caption: String = ""
                        if let capText = dict?.value(forKey: "Description")
                        {
                            caption = capText as! String
                        }
            cell.title?.text = dict?.value(forKey: "Title") as? String
                         cell.Description?.text = caption
         /*   let label1 = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.Description?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
            label1.font = UIFont.systemFont(ofSize: 10.0)
            label1.text = cell.Description?.text
            label1.textAlignment = .left
            //label.textColor = self.strokeColor
            label1.lineBreakMode = .byWordWrapping
            label1.numberOfLines = 2
            label1.sizeToFit()
            
            
            if((label1.frame.height) > 13)
            {
                cell.descriptionConstraint2.constant = label1.frame.height
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
                cell.descriptionConstraint2.constant = label1.frame.height
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }*/
                        
                       
                        //cell.ContentImage?.contentMode = .scaleAspectFill
                        //cell.ContentImage?.clipsToBounds = true
            
                        //cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
             let status = dict?.value(forKey: "Status") as! String
            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
            if(myjid != nil){
               
                if(status == "Finished"){
                    cell.triviastatus?.text = "RECORDING AWAITED"
                    cell.triviastartview?.isHidden = true
                }
                else if(status == "Live"){
                     cell.triviastartview?.isHidden = true
                    let Purchased = dict?.value(forKey: "Purchased") as! Bool
                    if(Purchased){
                        cell.triviastatus?.text = "PLAY NOW"
                    }else{
                         cell.triviastatus?.text = "VIEW NOW"
                    }
                   
                    cell.triviastatus?.addGestureRecognizer(longPressGesture)
                    cell.triviastatus?.isUserInteractionEnabled = true
                    }
               
                else if(status == "Published"){
                     cell.triviastartview?.isHidden = false
                     let Purchased = dict?.value(forKey: "Purchased") as! Bool
                   
                    if(Purchased){
                       // cell.triviastatus?.text = "WAIT TO START"
                        cell.triviastatus?.removeGestureRecognizer(longPressGesture)
                    }
                    else{
                        let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                         let soldout = dict?.value(forKey: "soldout") as! Bool
                        if(soldout){
                              cell.triviastatus?.text = "SOLD OUT"
                        }
                        else{
                            if(FreeTrivia){
                                cell.triviastatus?.text = "ENTER NOW"
                                cell.triviastatus?.addGestureRecognizer(longPressGesture)
                                cell.triviastatus?.isUserInteractionEnabled = true
                            }
                            else{
                                let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                                let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                if(avilablecoin > ticketprize){
                                    cell.triviastatus?.text = "ENTER NOW"
                                }
                                else{
                                    cell.triviastatus?.text = "ENTER NOW"
                                }
                                cell.triviastatus?.addGestureRecognizer(longPressGesture)
                                cell.triviastatus?.isUserInteractionEnabled = true
                            }
                        }
                       
                        }
                    
                }
            }else{
               
                if(status == "Live"){
                     cell.triviastatus?.text = "VIEW NOW"
                     cell.triviastartview?.isHidden = true
                }
                    else  if(status == "Finished"){
                        cell.triviastartview?.isHidden = true

                        cell.triviastatus?.text = "RECORDING AWAITED"
                     
                        //slide1.triviastatus?.removeGestureRecognizer(longPressGesture)
                    }
                    else if(status == "Completed"){
                       cell.triviastartview?.isHidden = true

                                                   cell.triviastatus?.text = "PLAY VIDEO"
                      
                    }
                else{
                    cell.triviastatus?.text = "ENTER NOW"
                }
                cell.triviastatus?.addGestureRecognizer(longPressGesture)
                cell.triviastatus?.isUserInteractionEnabled = true
            }
           if(myjid != nil){
            if(status == "Published"){
                let Purchased = dict?.value(forKey: "Purchased") as! Bool
                if(Purchased){
                cell.ticketprizeView?.isHidden = true
                     cell.avialableticket?.isHidden = true
                }
                else{
                     cell.ticketprizeView?.isHidden = false
                     cell.avialableticket?.isHidden = false
                    let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                    let soldout = dict?.value(forKey: "soldout") as! Bool
                    if(soldout){
                        cell.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                         cell.ticketprizeView?.isHidden = true
                         cell.avialableticket?.isHidden = false
                    }
                    else{
                    if(FreeTrivia){
                        cell.ticketprize?.text = "FREE TO PLAY"
                        cell.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                    }
                    else{
                        let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                        let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                        if(avilablecoin > ticketprize){
 cell.ticketprize?.text = "\(self.appDelegate().formatNumber(Int(ticketprize))) FanCoins TO PLAY"
                            cell.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                        }
                        else{
                             cell.ticketprize?.text = "\(self.appDelegate().formatNumber(Int(ticketprize))) FanCoins TO PLAY"
                            cell.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                        }
                    }
                    }
                }
                
            }
            else{
                cell.ticketprizeView?.isHidden = true
                cell.avialableticket?.isHidden = true
            }
           }else{
            cell.ticketprizeView?.isHidden = true
            cell.avialableticket?.isHidden = true
            }
           
            //let mili = dict?.value(forKey: "StartTime")
            cell.ispurchase = dict?.value(forKey: "Purchased") as! Bool
            cell.issoldout = dict?.value(forKey: "soldout") as! Bool
             if(status == "Published"){
            if let mili1 = dict?.value(forKey: "StartTime")
            {
                
                let number: Int64? = Int64(mili1 as! String)
                let mili: Double = Double(truncating: number! as NSNumber)
                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                cell.setupTimer(with: mili, indexPath: indexPath.row)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yy HH:mm"
                 dateFormatter.timeZone = TimeZone(abbreviation: "BST")
                cell.triviastart?.text = "STARTS @ \(dateFormatter.string(from:myMilliseconds.dateFull)) UK TIME"
            }
            }
            
                   
          /*  let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.title?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
                    label.font = UIFont.systemFont(ofSize: 11.0)
                    label.text = cell.title?.text
                    label.textAlignment = .left
                    //label.textColor = self.strokeColor
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 2
                    label.sizeToFit()
                    
                  
                        if((label.frame.height) > 12)
                        {
                            cell.widthConstraint2.constant = label.frame.height
                            //let height = (label.frame.height) + 410.0
                            //print("Height \((label.frame.height)).")
                            //storyTableView?.rowHeight = CGFloat(height)
                        }
                        else
                        {
                             cell.widthConstraint2.constant = label.frame.height
                            //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                            //print("Height \((label.frame.height)).")
                           // storyTableView?.rowHeight = CGFloat(height)
                        }
                        */
                        
                   
                    
               
        }
       
   /*  let lbleltime = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (cell.triviastart?.frame.height)!))
               lbleltime.font = UIFont.boldSystemFont(ofSize: 11.0)
               lbleltime.text = cell.triviastart?.text
               lbleltime.textAlignment = .left
               //label.textColor = self.strokeColor
               lbleltime.lineBreakMode = .byWordWrapping
               lbleltime.numberOfLines = 1
               lbleltime.sizeToFit()*/
               
        //cell.triviastartwidth.constant = lbleltime.frame.width + 15
        
        return cell
    }
    
   /* func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
    let cell:UpcomingTriviaCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UpcomingTriviaCell
       
        return cell.ContentImage.frame.width
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("You tapped cell number \(indexPath.row).")
        
       
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            //ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
        
    }
  
    @objc func showoldtrivia() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : PastTriviaViewController! = storyBoard.instantiateViewController(withIdentifier: "PastTrivia") as? PastTriviaViewController
       
        self.show(registerController, sender: self)
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
   
   
    func alertWithButtonGOTOSeting(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.default,handler: {_ in
            self.showSettings()
        });
        alert.addAction(action)
        let action1 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
     @IBAction func latestAction(){
        butlatestview.isHidden = true
        self.appDelegate().APIgettriviatime = self.appDelegate().getUTCFormateDate()
        appDelegate().arrupcommingTrivia = tempupcommingTrivia
        storyTableView?.reloadData()
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
extension String{
    func todayDate(format : String) -> Date{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
}
