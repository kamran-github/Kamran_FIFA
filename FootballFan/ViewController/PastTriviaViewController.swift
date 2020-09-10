//
//  PastTriviaViewController.swift
//  FootballFan
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation


import UIKit
import AVFoundation
import AVKit
//import GTProgressBar
import Alamofire
import UserNotifications
class PastTriviaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "UpcomingTriviaCell"
    var dictAllTeams = NSMutableArray()
    var lastposition = 0
    var returnToOtherView:Bool = false
    var returnToPreView:Bool = false
    var pastTriviaOnForgroundView:Bool = true
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
    var supportedTeam: Int64 = 0
    var opponentTeam: Int64 = 0
     var istriviaPageRefresh: Bool = false
    // var arrtrivia: [AnyObject] = []
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
        
        let notificationName2 = Notification.Name("_FetchedFanUpdates")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedFanUpdates), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_FechedFanUpdate")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdate(_:)), name: notificationName3, object: nil)
        
       
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
        
        //getFanUpdate(lastposition)
        let cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
        storyTableView!.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
        storyTableView!.separatorStyle = .none
        
        //getFanUpdate(0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "Fan Stories"
        
        navigationController?.isNavigationBarHidden = false
        /*if(!(self.activityIndicator?.isAnimating)!)
         {
         self.activityIndicator?.startAnimating()
         }*/
        
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
        
        
        
       
        if(appDelegate().arrpasttrivia.count == 0)
        {
            getFanUpdate(0)
        } else
        {
            if(returnToPreView){
                //storyTableView?.reloadData()
                returnToPreView = false
            }
            else if(returnToOtherView){
                getFanUpdate(lastposition)
            } else {
                if(appDelegate().arrpasttrivia.count == 0)
                {
                    lastposition = 0
                    getFanUpdate(lastposition)
                    
                }
                else{
                    getlatestoldtrivia()
                }
            }
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
                    TransperentLoadingIndicatorView.hide()
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
    func getlatestoldtrivia() {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getoldtrivia" as AnyObject
           dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
           dictRequest["device"] = "ios" as AnyObject
                istriviaPageRefresh = true
           
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
                 reqParams["lasttime"] = appDelegate().APIgetoldtriviatime as AnyObject//1571460948000 as AnyObject//
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
                                                                              
                                                                              //print(response)
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
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func getFanUpdate(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getoldtrivia" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            /*if(appDelegate().arrpasttrivia.count == 0){
                 TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            }*/
            if(lastindex == 0)
            {
                
                istriviaPageRefresh = true
            } else
            {
                istriviaPageRefresh = false
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
                /*let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                               self.appDelegate().APIgetoldtriviatime = self.appDelegate().getUTCFormateDate()
                                                                              //print(response)
                                                                              if(self.istriviaPageRefresh)
                                                                              {
                                                                                  //arrFanUpdatesTeams
                                                                                  self.appDelegate().arrpasttrivia = response  as [AnyObject]
                                                                              }
                                                                              else
                                                                              {
                                                                                  self.appDelegate().arrpasttrivia += response  as [AnyObject]
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
                                                                                      
                                                                                      if(self.istriviaPageRefresh)
                                                                                      {
                                                                                          self.appDelegate().arrpasttrivia  = [AnyObject]()
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
        istriviaPageRefresh = true
        if ClassReachability.isConnectedToNetwork() {
            getFanUpdate(lastindex)
            
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
    @objc func fechedFanUpdateTeams()
    {
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        Buttomloader?.isHidden = true
        
        closeRefresh()
        if(appDelegate().arrpasttrivia.count == 0){
            TransperentLoadingIndicatorView.hide()
            notelable?.isHidden = false
            storyTableView?.reloadData()
            storyTableView?.isHidden = false
            let bullet1 = "No trivia available"
            //let bullet2 = "Please try again later or post your own update."
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
        if(appDelegate().arrpasttrivia.count == 0){
            
            notelable?.isHidden = false
            
            storyTableView?.isHidden = true
             let bullet1 = "No trivia available"
            //let bullet2 = "Please try again later or post your own update."
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
            FanUpdatesListViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return FanUpdatesListViewController.realDelegate!;
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
        
        return appDelegate().arrpasttrivia.count
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
        if(appDelegate().arrpasttrivia.count > 19)
        {
            
            let lastElement = appDelegate().arrpasttrivia.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                Buttomloader?.isHidden = false
                tableviewButtomConstraint.constant = 35
                lastposition = lastposition + 1
                getFanUpdate(lastposition)
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! UpcomingTriviaCell
        let dict: NSDictionary? = appDelegate().arrpasttrivia[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
            
            
            cell.share?.addGestureRecognizer(longPressGesture_share)
            cell.share?.isUserInteractionEnabled = true
            
            
            
           // cell.ContentImage?.contentMode = .scaleAspectFill
           // cell.ContentImage?.clipsToBounds = true
            var thumbLink: String = ""
            if let thumb = dict?.value(forKey: "TriviaImage")
            {
                thumbLink = thumb as! String
            }
            //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
            cell.ContentImage.imageURL = thumbLink
        var caption: String = ""
        if let capText = dict?.value(forKey: "Description")
        {
            caption = capText as! String
        }
        cell.Description?.text = caption
            cell.title?.text = dict?.value(forKey: "Title") as! String//"TRIVIA FINISHED"
        
       /* let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.title?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.text = cell.title?.text
        label.textAlignment = .left
        //label.textColor = self.strokeColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.sizeToFit()
        
        
        if((label.frame.height) > 13)
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
            let label1 = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.Description?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
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
            cell.viewcount?.text = "\(self.appDelegate().formatNumber(Int(dict?.value(forKey: "ViewCount") as! String ) ??  0))"
            cell.likecount?.text = "\(self.appDelegate().formatNumber(Int(dict?.value(forKey: "LikeCount") as! String ) ??  0))"
          /*  let lblecount = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (cell.viewcount?.frame.height)!))
            lblecount.font = UIFont.boldSystemFont(ofSize: 11.0)
            lblecount.text = cell.viewcount?.text
            lblecount.textAlignment = .left
            //label.textColor = self.strokeColor
            lblecount.lineBreakMode = .byWordWrapping
            lblecount.numberOfLines = 1
            lblecount.sizeToFit()
            
            
            if((lblecount.frame.width) > 11)
            {
                cell.countviewConstraint2.constant = lblecount.frame.width + 25
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
                cell.countviewConstraint2.constant = lblecount.frame.width + 25
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }
            let lblelcount = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (cell.likecount?.frame.height)!))
            lblelcount.font = UIFont.boldSystemFont(ofSize: 11.0)
            lblelcount.text = cell.likecount?.text
            lblelcount.textAlignment = .left
            //label.textColor = self.strokeColor
            lblelcount.lineBreakMode = .byWordWrapping
            lblelcount.numberOfLines = 1
            lblelcount.sizeToFit()
            
            
            if((lblelcount.frame.width) > 11)
            {
                cell.likeviewConstraint2.constant = lblelcount.frame.width + 25
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
                cell.likeviewConstraint2.constant = lblelcount.frame.width + 25
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }*/
            let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenTriviaAction(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture.delegate = self as? UIGestureRecognizerDelegate
            
            
            //cell.buttomviewConstraint2.constant = lblelcount.frame.width + lblecount.frame.width + 80 + 25 + 25
            let status = dict?.value(forKey: "Status") as! String
            if(status == "Completed"){
                cell.triviastatus?.isHidden = false
                cell.triviastatus?.text = "PLAY VIDEO"
                cell.triviastatus?.addGestureRecognizer(longPressGesture)
                cell.triviastatus?.isUserInteractionEnabled = true
            }
            else  if(status == "Finished"){
                 cell.triviastatus?.isHidden = false
                cell.triviastatus?.text = "RECORDING AWAITED"
                cell.triviastatus?.removeGestureRecognizer(longPressGesture)
            }
            else{
                cell.triviastatus?.isHidden = true
            }
        }
        
        return cell
    }
    
  /*  func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        //let cell:FanUpdatesCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FanUpdatesCell
        let dict: NSDictionary? = arrtrivia[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            
            
            
            let screenSize = UIScreen.main.bounds
            let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width, height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 14.0)
            
            var caption: String = ""
            if let capText = dict?.value(forKey: "Description")
            {
                caption = capText as! String
            }
            
            if(!caption.isEmpty)
            {
                
                label.text = dict?.value(forKey: "Description")  as! String
            } else
            {
                label.text =  ""
                //cell.ContentText?.isHidden = true
            }
            //   }
            
            // label.text = cell.ContentText!.text
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            
            
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
        
        return 80
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("You tapped cell number \(indexPath.row).")
        
        
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            //ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
        
    }
    
    @objc func OpenTriviaAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = appDelegate().arrpasttrivia[indexPath.row] as? NSDictionary
                let status = dict?.value(forKey: "Status") as! String
                if(status == "Completed"){
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let registerController : PotratepreviewMediaViewController! = storyBoard.instantiateViewController(withIdentifier: "PotratePreviewmidia") as? PotratepreviewMediaViewController
                self.returnToOtherView = true
                registerController.videoURL = dict?.value(forKey: "VideoLink") as? String
                registerController.mediaType = "video"
               self.present(registerController, animated: true, completion: nil)
                }
            }
            else{
                   alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            }
            
        }
    }
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
        
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            let dict: NSDictionary? = appDelegate().arrpasttrivia[indexPath.row] as? NSDictionary
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
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
        
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
             print(error)
            let img: UIImage = UIImage(named: "splash_bg")!
            return img
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
         self.appDelegate().APIgetoldtriviatime = self.appDelegate().getUTCFormateDate()
           appDelegate().arrpasttrivia = tempupcommingTrivia
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

