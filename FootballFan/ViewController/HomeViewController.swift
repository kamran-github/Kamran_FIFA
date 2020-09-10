//
//  HomeViewController.swift
//  FootballFan
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import UserNotifications
import MapKit
import Crashlytics
import XMPPFramework
import AVKit
//import FirebaseAnalytics
class HomeViewController: UIViewController,UIScrollViewDelegate,CLLocationManagerDelegate {
      @IBOutlet weak var Slider1: UIView?
      @IBOutlet weak var Slider2: UIView?
      @IBOutlet weak var Slider3: UIView?
    @IBOutlet weak var Fixedsection: UIView?
    @IBOutlet weak var mediasection: UIView?
     @IBOutlet weak var FixedscrollView: UIScrollView!
     @IBOutlet weak var scrollView1: UIScrollView!
     @IBOutlet weak var scrollView2: UIScrollView!
     @IBOutlet weak var scrollView3: UIScrollView!
     @IBOutlet weak var mediascrollView: UIScrollView!
    @IBOutlet weak var FixedpageControl: UIPageControl!
    @IBOutlet weak var pageControl1: UIPageControl!
    @IBOutlet weak var pageControl2: UIPageControl!
    @IBOutlet weak var pageControl3: UIPageControl!
     @IBOutlet weak var MediapageControl: UIPageControl!
    var supportedTeam: Int64 = 0
    var opponentTeam: Int64 = 0
   
      lazy var lazyImage:LazyImage = LazyImage()
     @IBOutlet weak var view1Constraint2: NSLayoutConstraint!
      @IBOutlet weak var slidertopConstraint2: NSLayoutConstraint!
      @IBOutlet weak var childConstraint2: NSLayoutConstraint!
     @IBOutlet weak var triviaTime: UILabel?
     //@IBOutlet weak var triviadescription: UILabel?
    // @IBOutlet weak var triviastatus: UILabel?
   // @IBOutlet weak var triviaprice: UILabel?
     @IBOutlet weak var fixedsectiontopConstraint2: NSLayoutConstraint!
     @IBOutlet weak var fixedsectionHeightConstraint2: NSLayoutConstraint!
     @IBOutlet weak var timerConstraint2: NSLayoutConstraint!
    var curentTriviaindex: Int = 0
     var couponTimer : Timer?
     var selectedindex : Int = 0
     var locationManager: CLLocationManager!
     var currentLocation: CLLocation!
     var infoAlertVC = MessageAlertViewController.instantiate()
     var TermsAlert = FancoinAlertViewController.instantiate()
     var ConfermationAlert = TriviaPurchaseAlert.instantiate()
    var freetriviaAlert = FreeTriviaPurchaseAlert.instantiate()
     var temphomenews: NSArray = NSArray()
     var temphomefanupdate = [AnyObject]()
    //Ravi Media
    var temphomemedia = [AnyObject]()
    //Ravi Media
    var temphometrivia = [AnyObject]()
     var temphomeFixedsection: NSArray = NSArray()
     var temptriviamoreOption:Bool = true
     //var triviamoreOption:Bool = true
     var refreshTable: UIRefreshControl!
    @IBOutlet weak var scrollViewmain: UIScrollView!
    var totelteams = ""
     @IBOutlet weak var butlatestview: UIButton!
      @IBOutlet weak var lbltrivia: UIView?
    @IBOutlet weak var lblfanstory: UIView?
     @IBOutlet weak var lblnews: UIView?
     @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint!
     @IBOutlet weak var Connectinglabel: UILabel?
    
    @IBOutlet weak var lblmedia: UIView?
    
override func viewDidLoad() {
    super.viewDidLoad()
   parent?.navigationItem.title = "Home"
    appDelegate().fillMyTeams()
        
    scrollViewmain.isScrollEnabled = true
   scrollViewmain.alwaysBounceVertical = true
    let notificationName9 = Notification.Name("learnMore")
       // Register to receive notification
       NotificationCenter.default.addObserver(self, selector: #selector(self.learnMore), name: notificationName9, object: nil)
    let notification_pemission = Notification.Name("gotosettingForPush")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.pushGotosetting), name: notification_pemission, object: nil)
    let notificationName8 = Notification.Name("RefreshBadgeCount")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadgeCount), name: notificationName8, object: nil)
    let notificationName_ffdeeplink = Notification.Name("tabindexffdeeplink")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTabindexsNotificationFFDeepLink), name: notificationName_ffdeeplink, object: nil)
    let notificationName4 = Notification.Name("ShowChatWindowFromNotification")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.showChatWindowWithNotify(notification:)), name: notificationName4, object: nil)
    let notificationName5 = Notification.Name("tabindexchange")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTabindexsNotification), name: notificationName5, object: nil)
    let notificationName7 = Notification.Name("Showprofile")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.showMyprofile(notification:)), name: notificationName7, object: nil)
    
    let notificationName6 = Notification.Name("NewVersionOfApp")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.showForNewupdateWithNotify(notification:)), name: notificationName6, object: nil)
   
    let notificatonUpcommingPurchse = Notification.Name("hometriviapurchse")
                 // Register to receive notification
                 NotificationCenter.default.addObserver(self, selector: #selector(self.Buynow), name: notificatonUpcommingPurchse, object: nil)
    /*let notificationName10 = Notification.Name("_GetlocationPermissionsForhome")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.GetPermissionsForLocation), name: notificationName10, object: nil)*/
    let notificationNamelive = Notification.Name("trivialiveonhome")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(self.tirivialive), name: notificationNamelive, object: nil)
    refreshTable = UIRefreshControl()
           refreshTable.attributedTitle = NSAttributedString(string: "")
    refreshTable.addTarget(self, action: #selector(self.Getsliderdata), for: UIControl.Event.valueChanged)
           
           
           scrollViewmain?.addSubview(refreshTable)
           let notificationresetslider = Notification.Name("resetslider")
             // Register to receive notification
             NotificationCenter.default.addObserver(self, selector: #selector(self.reset), name: notificationresetslider, object: nil)
    let longPressGesturetrivia:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(triviabutAction(_:)))
                   //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                   longPressGesturetrivia.delegate = self as? UIGestureRecognizerDelegate
    lbltrivia?.addGestureRecognizer(longPressGesturetrivia)
    lbltrivia?.isUserInteractionEnabled = true
    
    let longPressGesturefanstory:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(storybutAction(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    longPressGesturefanstory.delegate = self as? UIGestureRecognizerDelegate
    lblfanstory?.addGestureRecognizer(longPressGesturefanstory)
    lblfanstory?.isUserInteractionEnabled = true
    
    let longPressGesturenew:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newsbutAction(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    longPressGesturenew.delegate = self as? UIGestureRecognizerDelegate
    lblnews?.addGestureRecognizer(longPressGesturenew)
    lblnews?.isUserInteractionEnabled = true
          let notifyresetStoryslider = Notification.Name("resetStoryslider")
                      // Register to receive notification
                      NotificationCenter.default.addObserver(self, selector: #selector(self.reset), name: notifyresetStoryslider, object: nil)
           
  let notifyresethomeApi = Notification.Name("resethomeApi")
                       // Register to receive notification
                       NotificationCenter.default.addObserver(self, selector: #selector(self.Getsliderdata), name: notifyresethomeApi, object: nil)
    let notificationisonline = Notification.Name("_isUserOnlineNotifyhome")
    // Register to receive notification
    NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.isUserOnline), name: notificationisonline, object: nil)
    let tabindexffdeeplinkFail = Notification.Name("tabindexffdeeplinkFail")
          // Register to receive notification
          NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTabindexsNotificationFFDeepLinkFail), name: tabindexffdeeplinkFail, object: nil)
    
    
    let longPressGesturemedia:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mediabutAction(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    longPressGesturemedia.delegate = self as? UIGestureRecognizerDelegate
    lblmedia?.addGestureRecognizer(longPressGesturemedia)
    lblmedia?.isUserInteractionEnabled = true
    let buttonbadge = Notification.Name("buttonbadge")
       // Register to receive notification
       NotificationCenter.default.addObserver(self, selector: #selector(self.buttonbadge), name: buttonbadge, object: nil)
   
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate().isOnHomeView = true
       appDelegate().toUserJID = ""
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.title = "Home"
        butlatestview.isHidden = true
        self.parent?.navigationItem.rightBarButtonItem = nil
             self.parent?.navigationItem.leftBarButtonItem = nil
             let button1 = UIBarButtonItem(image: UIImage(named: "nav_profile"), style: .plain, target: self, action: #selector(self.Showprofile(sender:)))
                             let rightSearchBarButtonItem:UIBarButtonItem = button1
                              parent?.navigationItem.setLeftBarButtonItems([rightSearchBarButtonItem], animated: true)
             let button2 = UIBarButtonItem(image: UIImage(named: "alert"), style: .plain, target: self, action: #selector(self.Shownotificationlist(sender:)))
                    let rightSearchBarButtonItem1:UIBarButtonItem = button2
        
                  /*  let rightSearchBarButtonItem2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.Getsliderdata))*/
                    
                    
                    parent?.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
      
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
              if(login != nil){
                   afterloginstatemanage()
              }
              else{
                  appDelegate().pageafterlogin = ""
                                    appDelegate().idafterlogin = 0
              }
        if(appDelegate().arrhomenews.count == 0){
             Getsliderdata()
        }
        else{
           /* if(appDelegate().returnHomeToOtherView){
                                  appDelegate().returnHomeToOtherView = false
                              Getsliderdata()
                             }
            else{*/
                Getlatestsliderdata()
            //}
        }
             
                  
                   if(appDelegate().HomeSetSlider){
                       appDelegate().HomeSetSlider = false
                       setSliderSetting()
                    //getbackgroundapi()
                   }
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
        if(!appDelegate().isnotificationpermission){
            appDelegate().isnotificationpermission = true
        let notify: String? = UserDefaults.standard.string(forKey: "notification")
        if(notify != nil){
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.delegate = self as? UNUserNotificationCenterDelegate
                center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                    if error == nil {
                        if grant {
                            DispatchQueue.main.async {
                                // application.registerForRemoteNotifications()
                                //application.unregisterForRemoteNotifications()
                            }
                        } else {
                            //User didn't grant permission
                            
                            self.ShowNotificationPermission()
                            
                        }
                    } else {
                        print("error: ",error ?? "")
                    }
                })
            }
        }
        else{
            self.ShowNotificationPermission()
        }
        }
          refreshBadgeCount()
     buttonbadge()
        if(appDelegate().PushHomeDic.count > 0){
            appDelegate().ShowPushNotification(pushUserinfo: appDelegate().PushHomeDic)
            appDelegate().PushHomeDic = [String : AnyObject]()
        }
        if (appDelegate().openffdeepurl != "") {
            appDelegate().ShowDiplink()
        }
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
                  
             
      // AnimationIndicatorView.show(view, loadingText: "You won 10 FanCoins",fancoins: String(300))
    }
    
    @objc func mediabutAction(_ longPressGestureRecognizer: UITapGestureRecognizer){
              let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                      let settingsController : MediaSubCategoriesViewControler = storyBoard.instantiateViewController(withIdentifier: "MediaSubCategories") as! MediaSubCategoriesViewControler
                      settingsController.cid = Int64.init(0)
                      settingsController.maintitel = "Videos"
                      show(settingsController, sender: self)
    }
    
    
    @objc func refreshTabindexsNotificationFFDeepLinkFail(notification: NSNotification)
       {
           let blocked = (notification.userInfo?["blocked"] )as! Bool
            let error = (notification.userInfo?["error"] )as! String
           DispatchQueue.main.async {
               if(blocked){
                   let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
                                let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                                    
                                });
                                let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                                   self.showStoriesBlockedUser()
                                   });
                                               alert.addAction(action1)
                                               alert.addAction(action)
                                               self.present(alert, animated: true, completion:nil)
               }
               else{
               self.alertWithTitle1(title: nil, message: error, ViewController: self)
               }
           }
       }
    func showStoriesBlockedUser()
            {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let myTeamsController : StoriesBlockesUserViewController = storyBoard.instantiateViewController(withIdentifier: "StoriesBlockesUser") as! StoriesBlockesUserViewController
                //  appDelegate().isFromSettings = true
                show(myTeamsController, sender: self)
               // self.present(myTeamsController, animated: true, completion: nil)
            }
    @objc func isUserOnline()
       {
           DispatchQueue.main.async {
              // let login: String? = UserDefaults.standard.string(forKey: "userJID")
               //if(login != nil){
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
                    if(self.appDelegate().arrhomenews.count == 0){
                        self.Getsliderdata()
                    }
                       
                   } else {
                       //TransperentLoadingIndicatorView.hide()
                       //self.parent?.title = "Waiting for network.."
                       self.Connectinglabel?.text = "Waiting for network..."
                       self.ConectingHightConstraint.constant = CGFloat(20.0)
                   }
               
              
           //}
       }
       }
     
    func afterloginstatemanage()  {
        if(appDelegate().pageafterlogin == "fanupdate"){
            self.tabBarController?.selectedIndex = 0
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                          let myTeamsController : FanUpdatesListViewController = storyBoard.instantiateViewController(withIdentifier: "FanUpdate") as! FanUpdatesListViewController
                         
                          //show(myTeamsController, sender: self)
                          self.show(myTeamsController, sender: self)
            if(appDelegate().idafterlogin != 0){
                if ClassReachability.isConnectedToNetwork() {
                    var dictRequest = [String: AnyObject]()
                    dictRequest["cmd"] = "getfanupdatebyid" as AnyObject
                    dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                    dictRequest["device"] = "ios" as AnyObject
                    var reqParams = [String: AnyObject]()
                    //reqParams["cmd"] = "getfanupdates" as AnyObject
                    
                    reqParams["id"] = appDelegate().idafterlogin as AnyObject
                    
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
                                                                                      let response: NSArray = json["responseData"]  as! NSArray
                                                                                      
                                                                                      //print(response)
                                                                                      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                                      let registerController : FanUpdateDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "fanupdatedetail") as? FanUpdateDetailViewController
                                                                                      //present(registerController as! UIViewController, animated: true, completion: nil)
                                                                                      registerController.fanupdatedetail = response as [AnyObject]
                                                                                      registerController.fromBanter = true
                                                                                      self.show(registerController, sender: self)
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
                    
                }
            }
            appDelegate().pageafterlogin = ""
            appDelegate().idafterlogin = 0
        }
        else if(appDelegate().pageafterlogin == "banter"){
            self.tabBarController?.selectedIndex = 1
            appDelegate().pageafterlogin = ""
            appDelegate().idafterlogin = 0
        }
        else if(appDelegate().pageafterlogin == "product"){
            self.tabBarController?.selectedIndex = 2
            if(appDelegate().idafterlogin != 0){
                if ClassReachability.isConnectedToNetwork() {
                    
                    // LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading")
                    
                    let boundary = appDelegate().generateBoundaryString()
                    var request = URLRequest(url: URL(string: MediaAPI)!)
                    request.httpMethod = "POST"
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    var reqParams = [String: AnyObject]()
                    reqParams["cmd"] = "getproductbyid" as AnyObject
                    reqParams["id"] =   appDelegate().idafterlogin as AnyObject//String(describing:  lastindex)
                    reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    if(myjid != nil){
                        let arrdUserJid = myjid?.components(separatedBy: "@")
                        let userUserJid = arrdUserJid?[0]
                        reqParams["username"] = userUserJid as AnyObject?
                    }
                    else{
                        reqParams["username"] = "" as AnyObject
                    }
                    
                    
                    // request.httpBody = createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
                    request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
                    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                        if let data = data {
                            if String(data: data, encoding: String.Encoding.utf8) != nil {
                                //print(stringData) //JSONSerialization
                                
                                
                                
                                //print(time)
                                do {
                                    let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                                    
                                    let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                                    // print(jsonData)
                                    if(isSuccess)
                                    {DispatchQueue.main.async {
                                        let arr = jsonData?.value(forKey: "data") as! NSArray
                                        let dic = arr[0] as! NSDictionary
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let settingsController : MerchantDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MerchantDetail") as! MerchantDetailViewController
                                        
                                        settingsController.dic = dic
                                        settingsController.maintitel = dic.value(forKey: "productName") as! String
                                        self.show(settingsController, sender: self)
                                        
                                        }
                                        
                                    }
                                    else
                                    { DispatchQueue.main.async
                                        {
                                            
                                        }
                                        //Show Error
                                    }
                                } catch let error as NSError {
                                    print(error)
                                    //Show Error
                                }
                                
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async
                                {
                                    //LoadingIndicatorView.hide()
                                    self.alertWithTitle1(title: nil, message: "Something went wrong.Please try again later", ViewController: self)
                            }
                            
                        }
                    })
                    task.resume()
                    
                    
                    /*var dictRequest = [String: AnyObject]()
                     dictRequest["cmd"] = "getnews" as AnyObject
                     
                     if(lastindex == 0)
                     {
                     LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you")
                     appDelegate().isNewsPageRefresh = true
                     } else
                     {
                     appDelegate().isNewsPageRefresh = false
                     }
                     do {
                     //Creating Request Data
                     var dictRequestData = [String: AnyObject]()
                     let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                     let arrdUserJid = myjid?.components(separatedBy: "@")
                     let userUserJid = arrdUserJid?[0]
                     
                     let myjidtrim: String? = userUserJid
                     dictRequestData["version"] = 1 as AnyObject
                     dictRequestData["lastindex"] = lastindex as AnyObject
                     dictRequestData["username"] = myjidtrim as AnyObject
                     dictRequestData["catid"] = catid as AnyObject
                     dictRequest["requestData"] = dictRequestData as AnyObject
                     //dictRequest.setValue(dictMobiles, forKey: "requestData")
                     //print(dictRequest)
                     
                     let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                     let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                     //print(strFanUpdates)
                     self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
                     } catch {
                     print(error.localizedDescription)
                     }*/
                }
            }
            appDelegate().pageafterlogin = ""
            appDelegate().idafterlogin = 0
        }
        else if(appDelegate().pageafterlogin == "news"){
            self.tabBarController?.selectedIndex = 0
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myTeamsController : NewsViewController = storyBoard.instantiateViewController(withIdentifier: "news") as! NewsViewController
                       
                        //show(myTeamsController, sender: self)
                           self.show(myTeamsController, sender: self)
            if(appDelegate().idafterlogin != 0){
                if ClassReachability.isConnectedToNetwork() {
                    //LoadingIndicatorView.show((window?.rootViewController?.view)!, loadingText: "\n Loading News")
                    
                    let boundary = appDelegate().generateBoundaryString()
                    var request = URLRequest(url: URL(string: MediaAPI)!)
                    request.httpMethod = "POST"
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    var reqParams = [String: AnyObject]()
                    reqParams["cmd"] = "getnewsbyid" as AnyObject
                    //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
                    reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
                    reqParams["id"] = appDelegate().idafterlogin as AnyObject
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    if(myjid != nil){
                        let arrdUserJid = myjid?.components(separatedBy: "@")
                        let userUserJid = arrdUserJid?[0]
                        reqParams["username"] = userUserJid as AnyObject?
                    }
                    else{
                        reqParams["username"] = "" as AnyObject
                    }
                    
                    
                    // request.httpBody = createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
                    request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
                    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                        if let data = data {
                            if String(data: data, encoding: String.Encoding.utf8) != nil {
                                //print(stringData) //JSONSerialization
                                
                                
                                
                                //print(time)
                                do {
                                    let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                                    
                                    let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                                    
                                    if(isSuccess)
                                    {  let response = jsonData?.value(forKey: "data") as! NSDictionary
                                        
                                        print(response)
                                        //let notificationName = Notification.Name("tabindexchange")
                                        //NotificationCenter.default.post(name: notificationName, object: nil)
                                        DispatchQueue.main.async
                                            {
                                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                let registerController : NewsDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "newsdetail") as? NewsDetailViewController
                                                //present(registerController as! UIViewController, animated: true, completion: nil)
                                                registerController.newsdetail = response
                                                registerController.fromBanter = true
                                                self.show(registerController, sender: self)
                                        }
                                    }
                                    else
                                    {
                                        //LoadingIndicatorView.hide() //Show Error
                                    }
                                } catch let error as NSError {
                                    print(error)
                                    //Show Error
                                }
                                
                            }
                        }
                        else
                        {
                            //Show Error
                        }
                    })
                    task.resume()
                    /*  let id: Int64 = (jsonData?.value(forKey: "id") as? Int64)!
                     let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                     let arrdUserJid = myjid?.components(separatedBy: "@")
                     let userUserJid = arrdUserJid?[0]
                     let myjidtrim: String? = userUserJid
                     var dictRequest = [String: AnyObject]()
                     dictRequest["cmd"] = "getnewsbyid" as AnyObject
                     var dictRequestData = [String: AnyObject]()
                     dictRequestData["id"] = id as AnyObject
                     dictRequestData["username"] = myjidtrim as AnyObject
                     dictRequest["requestData"] = dictRequestData as AnyObject
                     
                     let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                     let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                     // do stuff 3 seconds later
                     self.sendRequestToAPI(strRequestDict: strFanUpdates)
                     }*/
                }
            }
            appDelegate().pageafterlogin = ""
            appDelegate().idafterlogin = 0
        }
        else if(appDelegate().pageafterlogin == "more"){
            self.tabBarController?.selectedIndex = 1
            appDelegate().pageafterlogin = ""
            appDelegate().idafterlogin = 0
        }
        else if(appDelegate().pageafterlogin == "nearby"){
            self.tabBarController?.selectedIndex = 3
            appDelegate().pageafterlogin = ""
            appDelegate().idafterlogin = 0
        }
        else if(appDelegate().pageafterlogin == "leader"){
            appDelegate().pageafterlogin = ""
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                       let myTeamsController : LeaderBoardViewController = storyBoard.instantiateViewController(withIdentifier: "leaderboard") as! LeaderBoardViewController
                      
                       //show(myTeamsController, sender: self)
                       show(myTeamsController, sender: self)
                       
        }
    }
    func Getlatestsliderdata(){
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "gethome" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            Clslogging.logdebug(State: "Getlatestsliderdata start")
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
               
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                if(myjid != nil){
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    reqParams["username"] = userUserJid as AnyObject?
                }
                else{
                    let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                           if(!istriviauser){
                            let triviauser: String? = UserDefaults.standard.string(forKey: "triviauser")
                            let arrdUserJid = triviauser?.components(separatedBy: "@")
                                     let userUserJid = arrdUserJid?[0]
                                     reqParams["username"] = userUserJid as AnyObject?
                           }else{
                             reqParams["username"] = "" as AnyObject
                    }
                   //dictRequestData1["username"] = "" as AnyObject
                }
                reqParams["lasttime"] = appDelegate().APIhometime as AnyObject//1571460948000 as AnyObject//appDelegate().APIhometime as AnyObject
                dictRequest["requestData"] = reqParams as AnyObject
                AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                  headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                    // 2
                    .responseJSON { response in
                        switch response.result {
                                                                  case .success(let value):
                                                                      if let json = value as? [String: Any] {
                                                                          // print(" JSON:", json)
                                                                          let status1: Bool = json["success"] as! Bool
                                                                          Clslogging.loginfo(State: "Getlatestsliderdata for latest records", userinfo: json as [String : AnyObject])
                                                                          if(status1){DispatchQueue.main.async {
                                                                             // LoadingIndicatorView.hide()
                                                                              
                                                                              let isNewData = json["isNewData"]  as! Bool
                                                                               let response: NSDictionary = json["responseData"]  as! NSDictionary
                                                                              if(isNewData){
                                                                                  self.butlatestview.isHidden = false
                                                                                
                                                                                      // self.setView(view: self.butlatestview)
                                                                                  self.butlatestview.transform = self.butlatestview.transform.scaledBy(x: 0.01, y: 0.01)
                                                                                  UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromTop, animations: {
                                                                                    // 3
                                                                                      self.butlatestview.transform = CGAffineTransform.identity
                                                                                  }, completion: nil)

                                                                                  
                                                                                  self.temphomenews = response.value(forKey: "news") as! NSArray
                                                                                                                    
                                                                                  self.temphomefanupdate = response.value(forKey: "fanupdate") as! [AnyObject]
                                                                                  
                                                                                  //Ravi Media
                                                                                  self.temphomemedia = response.value(forKey: "media") as! [AnyObject]
                                                                                  //Ravi Media
                                                                                  
                                                                                  self.temphometrivia = response.value(forKey: "trivia") as! [AnyObject]
                                                                                  self.temptriviamoreOption = response.value(forKey: "OldTrivia") as! Bool
                                                                                  self.temphomeFixedsection = response.value(forKey: "homefixed") as! NSArray
                                                                                 
                                                                                  
                                                                              }
                                                                              UserDefaults.standard.setValue(json["notificationcount"], forKey: "notificationcount")
                                                                                                                      UserDefaults.standard.synchronize()
                                                                              self.buttonbadge()
                                                                                let isNewNotification = json["isNewNotification"]  as! Bool
                                                                              if(isNewNotification){
                                                                              self.appDelegate().arrnotification = response.value(forKey:"getnotifications") as! [AnyObject]
                                                                              }
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                    TransperentLoadingIndicatorView.hide()
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                            if(self.refreshTable.isRefreshing)
                                                              {
                                                               self.refreshTable.endRefreshing()
                                                              }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                                                                                               let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                                               Clslogging.logerror(State: "getlatestFanUpdate", userinfo: errorinfo)
                            break
                                                                      // error handling
                                                       
                                                                  }
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
            Clslogging.logdebug(State: "Getlatestsliderdata End")
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
     @objc func Getsliderdata() {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "gethome" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
             self.butlatestview.isHidden = true
           /* if(appDelegate().arrhomenews.count == 0){
           TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            }*/
             Clslogging.logdebug(State: "Getsliderdata start")
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
               
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                if(myjid != nil){
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    reqParams["username"] = userUserJid as AnyObject?
                }
                else{
                    let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                           if(!istriviauser){
                            let triviauser: String? = UserDefaults.standard.string(forKey: "triviauser")
                            let arrdUserJid = triviauser?.components(separatedBy: "@")
                                     let userUserJid = arrdUserJid?[0]
                                     reqParams["username"] = userUserJid as AnyObject?
                           }else{
                             reqParams["username"] = "" as AnyObject
                    }
                   //dictRequestData1["username"] = "" as AnyObject
                }
                
                dictRequest["requestData"] = reqParams as AnyObject
             
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
                                                                          Clslogging.loginfo(State: "Getsliderdata", userinfo: json as [String : AnyObject])
                                                                          if(status1){DispatchQueue.main.async {
                                                                             // LoadingIndicatorView.hide()
                                                                               self.appDelegate().APIhometime = self.appDelegate().getUTCFormateDate()
                                                                              let response: NSDictionary = json["responseData"]  as! NSDictionary
                                                                              self.Slider1?.isHidden = true
                                                                              self.Slider2?.isHidden = true
                                                                              self.Slider3?.isHidden = true
                                                                              if response.value(forKey: "trivia") != nil
                                                                              {
                                                                                  self.appDelegate().arrhometrivia = response.value(forKey: "trivia") as! [AnyObject]
                                                                                  if(self.appDelegate().arrhometrivia.count == 0){
                                                                                      self.slidertopConstraint2.constant = 0
                                                                                      self.childConstraint2.constant = 420
                                                                                      self.view1Constraint2.constant = 0
                                                                                  }
                                                                                  else{
                                                                                      self.slidertopConstraint2.constant = 8
                                                                                      self.view1Constraint2.constant = 200
                                                                                      self.childConstraint2.constant = 620
                                                                                      /* DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                                       self.setTriviaSlider()
                                                                                      }*/
                                                                                      self.appDelegate().triviamoreOption = response.value(forKey: "OldTrivia") as! Bool
                                                                                  }
                                                                             
                                                                                  
                                                                              }
                                                                              else{
                                                                                  self.slidertopConstraint2.constant = 0
                                                                                  self.childConstraint2.constant = 420
                                                                                  self.view1Constraint2.constant = 0
                                                                              }
                                                                              self.appDelegate().arrhomenews = response.value(forKey: "news") as! NSArray
                                                                              //self.setNewsSlider()
                                                                              self.appDelegate().arrhomefanupdate = response.value(forKey: "fanupdate") as! [AnyObject]
                                                                              
                                                                              //Ravi Media
                                                                              self.appDelegate().arrhomemedia = response.value(forKey: "media") as! [AnyObject]
                                                                              //Ravi Media
                                                                              
                                                                              //self.setStorySlider()
                                                                              self.appDelegate().arrhomeFixedsection = response.value(forKey: "homefixed") as! NSArray
                                                                              self.setSliderSetting()
                                                                               self.appDelegate().arrnotification = response.value(forKey: "getnotifications") as! [AnyObject]
                                                                              TransperentLoadingIndicatorView.hide()
                                                                            UserDefaults.standard.setValue(json["notificationcount"], forKey: "notificationcount")
                                                                                                                UserDefaults.standard.synchronize()
                                                                              self.buttonbadge()
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                    TransperentLoadingIndicatorView.hide()
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                            if(self.refreshTable.isRefreshing)
                            {
                             self.refreshTable.endRefreshing()
                            }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                                                                    let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                    Clslogging.logerror(State: "Getsliderdata", userinfo: errorinfo)
                                                                    if(self.refreshTable.isRefreshing)
                                                                    {
                                                                     self.refreshTable.endRefreshing()
                                                                    }
                            break
                                                                      // error handling
                                                       
                                                                  }
                        
                }
                
                
            } catch {
                print(error.localizedDescription)
                if(self.refreshTable.isRefreshing)
                {
                 self.refreshTable.endRefreshing()
                }
            }
             Clslogging.logdebug(State: "Getsliderdata End")
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            if(self.refreshTable.isRefreshing)
            {
             self.refreshTable.endRefreshing()
            }
        }
    }
    func setSliderSetting(){
    
    /* if(self.appDelegate().arrhometrivia.count == 0){
         self.slidertopConstraint2.constant = 0
         self.childConstraint2.constant = 420
         self.view1Constraint2.constant = 0
     }
     else{
         self.slidertopConstraint2.constant = 8
         self.view1Constraint2.constant = 200
         self.childConstraint2.constant = 630
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.setTriviaSlider()
         }
         
     }*/
         if(appDelegate().arrhomeFixedsection.count != 0 && appDelegate().arrhometrivia.count != 0 && appDelegate().arrhomenews.count != 0 && appDelegate().arrhomefanupdate.count != 0){
             self.childConstraint2.constant = 1030
             self.view1Constraint2.constant = 200
              fixedsectionHeightConstraint2.constant = 200
             setFixedSlider()
         self.setTriviaSlider()
             self.setMediaStory()
            
            self.setStorySlider()
             self.setNewsSlider()
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //Splashindicator.hide()
              self.Fixedsection?.isHidden = false
             self.Slider1?.isHidden = false
                self.Slider2?.isHidden = false
                self.Slider3?.isHidden = false
             self.mediasection?.isHidden = false
                }
         }
             else  if(appDelegate().arrhomeFixedsection.count != 0 && appDelegate().arrhometrivia.count == 0 && appDelegate().arrhomenews.count != 0 && appDelegate().arrhomefanupdate.count != 0){
                        self.childConstraint2.constant = 830
              self.slidertopConstraint2.constant = 0
             self.view1Constraint2.constant = 0
              fixedsectionHeightConstraint2.constant = 200
             setFixedSlider()
             
                   // self.setTriviaSlider()
                       
                        self.setMediaStory()
                       self.setStorySlider()
                        self.setNewsSlider()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           //Splashindicator.hide()
                     self.Fixedsection?.isHidden = false
                        self.Slider1?.isHidden = true
                           self.Slider2?.isHidden = false
                           self.Slider3?.isHidden = false
                     self.mediasection?.isHidden = false
                           }
                    }
        else if(appDelegate().arrhometrivia.count != 0 && appDelegate().arrhomenews.count != 0 && appDelegate().arrhomefanupdate.count != 0){
             self.childConstraint2.constant = 830
             self.view1Constraint2.constant = 200
             fixedsectiontopConstraint2.constant = 0
             fixedsectionHeightConstraint2.constant = 0
         self.setTriviaSlider()
            
             self.setMediaStory()
            self.setStorySlider()
             self.setNewsSlider()
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //Splashindicator.hide()
             self.Fixedsection?.isHidden = true
             self.Slider1?.isHidden = false
                self.Slider2?.isHidden = false
                self.Slider3?.isHidden = false
             self.mediasection?.isHidden = false
                }
         }
         else if( appDelegate().arrhomenews.count != 0 && appDelegate().arrhomefanupdate.count != 0){
             self.slidertopConstraint2.constant = 0
             self.childConstraint2.constant = 630
             self.view1Constraint2.constant = 0
             fixedsectionHeightConstraint2.constant = 0
             self.setNewsSlider()
                         self.setMediaStory()
                       self.setStorySlider()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           //Splashindicator.hide()
                     self.Fixedsection?.isHidden = true
                        self.Slider1?.isHidden = true
                           self.Slider2?.isHidden = false
                           self.Slider3?.isHidden = false
                     self.mediasection?.isHidden = false
                           }
             
         }
         //LoadingIndicatorView.hide()
     }
    func setMediaStory(){
        if(appDelegate().arrhomemedia.count>0){
                self.mediascrollView.frame = CGRect(x:0, y:0, width:self.mediasection!.frame.width, height:(self.mediasection?.frame.height)!)
                
                let scrollViewWidth:CGFloat = self.mediascrollView.frame.width
                let scrollViewHeight:CGFloat = self.mediascrollView.frame.height
        
                for i in 0...appDelegate().arrhomemedia.count-1 {
                    let dict: NSDictionary? = appDelegate().arrhomemedia[i] as? NSDictionary
                    let isblocked = dict?.value(forKey: "isblocked") as! Bool
                    if(isblocked){
                        let imgstory = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                        imgstory.contentMode = .scaleToFill
                        imgstory.image = UIImage(named: "BlockedContent")
                         self.mediascrollView.addSubview(imgstory)
                    }
                    else{
                        if(dict != nil)
                        {
                            
                            
                            //let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                            // let decodedString = String(data: decodedData, encoding: .utf8)!
                            
                            
                            // cell.newsTitle?.text = decodedString
                            let messageContent = dict?.value(forKey: "message")as! String
                            
                            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                            {
                                do {
                                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                    let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                                     let decodedString = String(data: decodedData, encoding: .utf8)!
                                    
                            var thumbLink: String = ""
                            
                            
                            if(jsonDataMessage?.value(forKey: "type") as! String == "video")
                                            {
                                            if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                            {
                                                thumbLink = thumb as! String
                                            }
                                            } else {
                                                if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                                {
                                                    thumbLink = thumb as! String
                                                }
                                            }
                                            





                            if(!thumbLink.isEmpty)
                            {
                               let imgstory = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                                imgstory.contentMode = .scaleAspectFill//.scaleAspectFit//image show perfect if user skysports link
                                imgstory.tag = i
                                lazyImage.show(imageView: imgstory, url: thumbLink)
                               //imgstory.imageURL = thumbLink
                                let slidergradient = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                                slidergradient.contentMode = .scaleToFill
                                //slidergradient.image = UIImage(named: "")
                               
                                let mainview = UIView(frame: CGRect(x: scrollViewWidth - 150 , y: 10, width: 140, height: self.mediasection!.frame.height))
                                mainview.backgroundColor = UIColor.clear
                                slidergradient.isUserInteractionEnabled = true
                                mainview.isUserInteractionEnabled = true
                                //let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowbrekingPreviewClick(_:)))
                                
                                // longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
                                
                                
                                //imgOne.addGestureRecognizer(longPressGesture_showpreview2)
                                //imgOne.isUserInteractionEnabled = true
                                
                                //imgOne.image = UIImage(named: "slide1")
                                /*let lbl = UILabel(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:scrollViewHeight-90,width:scrollViewWidth, height:50))
                                 lbl.backgroundColor = UIColor.white
                                 lbl.alpha = 0.9
                                 lbl.text = decodedString
                                 //  let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
                                 imgOne.addSubview(lbl)*/
                                let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenmediaAction(_:)))
                                let layer = CALayer()
                                                   let deshieght:CGFloat = 10.0
                                let Description = UILabel(frame: CGRect(x: 10.0, y: deshieght, width: 120, height: CGFloat.greatestFiniteMagnitude))
                                Description.font = UIFont.boldSystemFont(ofSize: 11.0)
                                Description.text = decodedString//"\nSimple Moving before acceleration"
                                Description.textAlignment = .left
                                Description.textColor = UIColor.white
                                Description.lineBreakMode = .byWordWrapping
                                Description.numberOfLines = 6
                                Description.sizeToFit()
                                      
                                let height = Description.frame.height + 20
                                                 //  let mainview1 = UIView(frame: CGRect(x: 0 , y: 10, width: 140, height: height))
                                                  //mainview.Height = CGFloat(Description.frame.height + 20.0)
                                                 
                                                  layer.frame = CGRect(x: 0 , y: 0, width: 140, height: height)//someView.bounds
                                                  layer.backgroundColor = UIColor(red: 0.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
                                                  layer.opacity = 0.5
                                                  layer.cornerRadius = 10
                                /*let triviastaus = UIView(frame: CGRect(x: 0 , y: Description.frame.origin.y + Description.frame.height + 10, width: mainview.frame.width, height: 30))
                                triviastaus.backgroundColor = UIColor.clear
                                triviastaus.layer.borderWidth = 1
                                triviastaus.layer.cornerRadius = 5
                                triviastaus.layer.borderColor = UIColor.init(hex: "FFFFFF").cgColor
                                triviastaus.tag = i
                                triviastaus.addGestureRecognizer(longPressGesture)
                                triviastaus.isUserInteractionEnabled = true
                                
                                let trivibuttext = UILabel(frame: CGRect(x: 5, y: 0, width: triviastaus.frame.width - 5, height: triviastaus.frame.height))
                                trivibuttext.font = UIFont.boldSystemFont(ofSize: 11.0)
                                trivibuttext.text = "VIEW POST"
                                trivibuttext.textAlignment = .center
                                trivibuttext.textColor = UIColor.white
                                trivibuttext.lineBreakMode = .byWordWrapping
                                trivibuttext.numberOfLines = 1*/
                                mainview.tag = i
                                 mainview.addGestureRecognizer(longPressGesture)
                                slidergradient.tag = i
                                slidergradient.addGestureRecognizer(longPressGesture)
                                self.mediascrollView.addSubview(imgstory)
                                self.mediascrollView.addSubview(slidergradient)
                                slidergradient.addSubview(mainview)
                                 Description.frame.origin = CGPoint(x:10.0, y:10.0 )
                                mainview.addSubview(Description)
                                mainview.layer.insertSublayer(layer, at: 0)
                               // mainview.addSubview(triviastaus)
                                //triviastaus.addSubview(trivibuttext)
                                //Description.topAnchor.constraint(equalTo: mainview.topAnchor,constant: 30).isActive = true
                                               
                            }
                            }
                            catch let error as NSError {
                                    print(error)
                                }
                            }
                        }
                    }
                    
                }
                let count: CGFloat = CGFloat(appDelegate().arrhomemedia.count)
                self.mediascrollView.contentSize = CGSize(width:scrollViewWidth * count, height:self.mediascrollView.frame.height)
                mediascrollView.contentOffset.x = 0
                self.mediascrollView.delegate = self
                self.MediapageControl.numberOfPages = appDelegate().arrhomemedia.count
                self.MediapageControl.currentPage = 0
        }
        else{
           // let count: CGFloat = CGFloat(appDelegate().arrhomemedia.count)
                           self.mediascrollView.contentSize = CGSize(width:0, height:self.mediascrollView.frame.height)
                           mediascrollView.contentOffset.x = 0
                           self.mediascrollView.delegate = self
                           self.MediapageControl.numberOfPages = appDelegate().arrhomemedia.count
                           self.MediapageControl.currentPage = 0
            
        }
                
            }
    func setFixedSlider(){
        
        self.FixedscrollView.frame = CGRect(x:0, y:0, width:self.Fixedsection!.frame.width, height:(self.Fixedsection?.frame.height)!)
        
        let scrollViewWidth:CGFloat = self.FixedscrollView.frame.width
        let scrollViewHeight:CGFloat = self.FixedscrollView.frame.height
        for i in 0...appDelegate().arrhomeFixedsection.count-1 {
            let dict: NSDictionary? = appDelegate().arrhomeFixedsection[i] as? NSDictionary
            if(dict != nil)
            {
                
                
                //let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                // let decodedString = String(data: decodedData, encoding: .utf8)!
                
                
                // cell.newsTitle?.text = decodedString
                let type = dict?.value(forKey: "type")as! String
                
                
                var thumbLink: String = ""
                
                if(type == "image"){
                    thumbLink = dict?.value(forKey: "thumb")as! String
                   //thumbLink = dict?.value(forKey: "url")as! String
                }
                else{
                    thumbLink = dict?.value(forKey: "thumb")as! String
                }



                if(!thumbLink.isEmpty)
                {
                   let imgstory = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                    imgstory.contentMode = .scaleAspectFill//.scaleAspectFit//image show perfect if user skysports link
                    imgstory.tag = i
                    imgstory.image = UIImage(named:"img_thumb")
                    lazyImage.show(imageView: imgstory, url: thumbLink)
                   //imgstory.imageURL = thumbLink
                    let slidergradient = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                    slidergradient.contentMode = .scaleToFill
                    slidergradient.image = UIImage(named: "")
                   //let imgplay = UIImageView(frame: CGRect(x:0, y:0,width:40, height:40))
                   //imgplay.contentMode = .scaleToFill
                   //imgplay.image = UIImage(named: "play")
                    //imgplay.center = slidergradient.center
                   // let mainview = UIView(frame: CGRect(x: scrollViewWidth - 150 , y: 10, width: 140, height: self.Fixedsection!.frame.height))
                    //mainview.backgroundColor = UIColor.clear
                    slidergradient.isUserInteractionEnabled = true
                   // mainview.isUserInteractionEnabled = true
                    //let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowbrekingPreviewClick(_:)))
                    
                    // longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    //imgOne.addGestureRecognizer(longPressGesture_showpreview2)
                    //imgOne.isUserInteractionEnabled = true
                    
                    //imgOne.image = UIImage(named: "slide1")
                    /*let lbl = UILabel(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:scrollViewHeight-90,width:scrollViewWidth, height:50))
                     lbl.backgroundColor = UIColor.white
                     lbl.alpha = 0.9
                     lbl.text = decodedString
                     //  let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
                     imgOne.addSubview(lbl)*/
                    let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenFixedAction))
                    let layer = CALayer()
                                      // let deshieght:CGFloat = 10.0
                    let Description = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: CGFloat.greatestFiniteMagnitude, height: 24))
                    Description.font = UIFont.systemFont(ofSize: 11.0, weight: .bold)
                    //Description.font = UIFont.boldSystemFont(ofSize: 11.0)
                   // Description.font.bold()
                    Description.text = dict?.value(forKey: "name") as? String//"\nSimple Moving before acceleration"
                    Description.textAlignment = .left
                   // Description.textColor = UIColor.black
                    
                   // Description.lineBreakMode = .byWordWrapping
                    //Description.numberOfLines = 1
                    Description.sizeToFit()
                          
                    let width = Description.frame.width + 16.5
                                     //  let mainview1 = UIView(frame: CGRect(x: 0 , y: 10, width: 140, height: height))
                                      //mainview.Height = CGFloat(Description.frame.height + 20.0)
                                     
                                      layer.frame = CGRect(x: 10 , y: 10, width: width, height: 24)//someView.bounds
                    layer.backgroundColor = UIColor.init(hex: "FFD401").cgColor//UIColor(red: 255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor
                                      //layer.opacity = 0.5
                                      layer.cornerRadius = 10
                    /*let triviastaus = UIView(frame: CGRect(x: 0 , y: Description.frame.origin.y + Description.frame.height + 10, width: mainview.frame.width, height: 30))
                    triviastaus.backgroundColor = UIColor.clear
                    triviastaus.layer.borderWidth = 1
                    triviastaus.layer.cornerRadius = 5
                    triviastaus.layer.borderColor = UIColor.init(hex: "FFFFFF").cgColor
                    triviastaus.tag = i
                    triviastaus.addGestureRecognizer(longPressGesture)
                    triviastaus.isUserInteractionEnabled = true
                    
                    let trivibuttext = UILabel(frame: CGRect(x: 5, y: 0, width: triviastaus.frame.width - 5, height: triviastaus.frame.height))
                    trivibuttext.font = UIFont.boldSystemFont(ofSize: 11.0)
                    trivibuttext.text = "VIEW POST"
                    trivibuttext.textAlignment = .center
                    trivibuttext.textColor = UIColor.white
                    trivibuttext.lineBreakMode = .byWordWrapping
                    trivibuttext.numberOfLines = 1*/
                    //mainview.tag = i
                     //mainview.addGestureRecognizer(longPressGesture)
                    //label.center = CGPoint(x: gryview.frame.width/2, y: 160)
                    let button:UIButton = UIButton(frame: CGRect(x: scrollViewWidth/2, y: scrollViewHeight/2, width: 40, height: 40))
                    button.backgroundColor = .clear
                    button.setImage(UIImage(named: "ff_play"), for: .normal)//setTitle("Button", for: .normal)
                    //button.addTarget(self, action:#selector(HomeViewController.OpenFixedAction), for: .touchUpInside)
                   // button.center = slidergradient.center
                    
                    slidergradient.tag = i
                    Description.frame.origin = CGPoint(x:17.0, y:15.0 )
                    button.frame.origin = CGPoint(x:(scrollViewWidth/2) - 20, y:(scrollViewHeight/2) - 20 )
                    slidergradient.addSubview(Description)
                   
                    if(type != "image"){
                                      imgstory.addSubview(button)
                                      //thumbLink = dict?.value(forKey: "url")as! String
                                   }
                                  
                    slidergradient.addGestureRecognizer(longPressGesture)
                    self.FixedscrollView.addSubview(imgstory)
                    self.FixedscrollView.addSubview(slidergradient)
                   // slidergradient.addSubview(mainview)
                      //imgplay.center = slidergradient.center
                     
                    slidergradient.layer.insertSublayer(layer, at: 0)
                    
                   // mainview.addSubview(triviastaus)
                    //triviastaus.addSubview(trivibuttext)
                    //Description.topAnchor.constraint(equalTo: mainview.topAnchor,constant: 30).isActive = true
                                   
                }
               
            }
        }
        let count: CGFloat = CGFloat(appDelegate().arrhomeFixedsection.count)
        self.FixedscrollView.contentSize = CGSize(width:scrollViewWidth * count, height:self.FixedscrollView.frame.height)
        FixedscrollView.contentOffset.x = 0
        self.FixedscrollView.delegate = self
        self.FixedpageControl.numberOfPages = appDelegate().arrhomeFixedsection.count
        self.FixedpageControl.currentPage = 0
        
        
    }
    func setTriviaSlider(){
        //sliderConstraint2.constant = (Slider1?.frame.width)!
         // view1Constraint2.constant = (Slider1?.frame.width)! + 60
        
        self.scrollView1.frame = CGRect(x:0, y:0, width:self.Slider1!.frame.width, height:(self.Slider1?.frame.height)!)
        scrollView1.isUserInteractionEnabled =  true
        let scrollViewWidth:CGFloat = self.scrollView1.frame.width
        let scrollViewHeight:CGFloat = self.scrollView1.frame.height
       // print("sliderview\(Slider1)")
        // print("scrollViewWidth\(scrollViewWidth)")
        if(self.appDelegate().arrhometrivia.count > 0){
        for i in 0...self.appDelegate().arrhometrivia.count-1 {
            let dict: NSDictionary? = self.appDelegate().arrhometrivia[i] as? NSDictionary
            if(dict != nil)
            {
               
                let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenTriviaAction(_:)))
                //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                longPressGesture.delegate = self as? UIGestureRecognizerDelegate
                
                
                
              //  let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
                //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                //longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
                
                
               
                
                //let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
               // let decodedString = String(data: decodedData, encoding: .utf8)!
                
                
                // cell.newsTitle?.text = decodedString
                
                
                var thumbLink: String = ""
                if let thumb = dict?.value(forKey: "TriviaImage")
                {
                    thumbLink = thumb as! String
                }
                  let slide1:Slidertrivia = Bundle.main.loadNibNamed("Slidertrivia", owner: self, options: nil)?.first as! Slidertrivia
                slide1.frame = CGRect(x: scrollViewWidth * CGFloat(i), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                lazyImage.show(imageView: slide1.ContentImage, url: thumbLink)
                //print("slid X\(slide1.frame.minX)")
                //slide1.ContentImage.imageURL = thumbLink
                var caption: String = ""
                if let capText = dict?.value(forKey: "Description")
                     {
                         caption = capText as! String
                     }
                     slide1.Description?.text = caption
                   /*  let label1 = UILabel(frame: CGRect(x: 0.0, y: 0, width: (slide1.Description?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
                     label1.font = UIFont.systemFont(ofSize: 10.0)
                     label1.text = slide1.Description?.text
                     label1.textAlignment = .left
                     //label.textColor = self.strokeColor
                     label1.lineBreakMode = .byWordWrapping
                     label1.numberOfLines = 2
                     label1.sizeToFit()
                     
                     
                     if((label1.frame.height) > 13)
                     {
                         slide1.descriptionConstraint2.constant = label1.frame.height
                         //let height = (label.frame.height) + 410.0
                         //print("Height \((label.frame.height)).")
                         //storyTableView?.rowHeight = CGFloat(height)
                     }
                     else
                     {
                         slide1.descriptionConstraint2.constant = label1.frame.height
                         //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                         //print("Height \((label.frame.height)).")
                         // storyTableView?.rowHeight = CGFloat(height)
                     }*/
                slide1.title?.text = dict?.value(forKey: "Title") as? String
                     
                     //cell.ContentImage?.contentMode = .scaleAspectFill
                     //cell.ContentImage?.clipsToBounds = true
                     
                     //cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
                let status = dict?.value(forKey: "Status") as! String
                     let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                     if(myjid != nil){
                         
                         if(status == "Finished"){
                             slide1.triviastartview?.isHidden = true

                             slide1.triviastatus?.text = "RECORDING AWAITED"
                            slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                                                      slide1.triviastatus?.isUserInteractionEnabled = true
                             //slide1.triviastatus?.removeGestureRecognizer(longPressGesture)
                         }
                         else if(status == "Completed"){
                            slide1.triviastartview?.isHidden = true

                                                        slide1.triviastatus?.text = "PLAY VIDEO"
                            slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                            slide1.triviastatus?.isUserInteractionEnabled = true
                         }
                         else if(status == "Live"){
                             slide1.triviastartview?.isHidden = true

                            let Purchased = dict?.value(forKey: "Purchased") as! Bool
                             if(Purchased){
                                 slide1.triviastatus?.text = "PLAY NOW"
                             }else{
                                 slide1.triviastatus?.text = "VIEW NOW"
                             }
                             
                            
                             slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                             slide1.triviastatus?.isUserInteractionEnabled = true
                         }
                             
                         else if(status == "Published"){
                             slide1.triviastartview?.isHidden = false

                            let Purchased = dict?.value(forKey: "Purchased") as! Bool
                             if(Purchased){
                                 slide1.triviastatus?.text = "WAIT TO START"
                               slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                                                           slide1.triviastatus?.isUserInteractionEnabled = true
                                 //slide1.triviastatus?.removeGestureRecognizer(longPressGesture)
                             }
                             else{
                                let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                                let soldout = dict?.value(forKey: "soldout") as! Bool
                                 if(soldout){
                                     slide1.triviastatus?.text = "SOLD OUT"
                                 }
                                 else{
                                 if(FreeTrivia){
                                     slide1.triviastatus?.text = "ENTER NOW"
                                     slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                                     slide1.triviastatus?.isUserInteractionEnabled = true
                                 }
                                 else{
                                    let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                                     let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                     if(avilablecoin > ticketprize){
                                         slide1.triviastatus?.text = "ENTER NOW"
                                     }
                                     else{
                                         slide1.triviastatus?.text = "ENTER NOW"
                                     }
                                     slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                                     slide1.triviastatus?.isUserInteractionEnabled = true
                                 }
                                 }
                             }
                             
                         }
                     }else{
                         //let status = upcomingtriviadetail.value(forKey: "Status") as! String
                         if(status == "Live"){
                             slide1.triviastartview?.isHidden = true

                             slide1.triviastatus?.text = "VIEW NOW"
                         }
                          else  if(status == "Finished"){
                                slide1.triviastartview?.isHidden = true

                                slide1.triviastatus?.text = "RECORDING AWAITED"
                             
                                //slide1.triviastatus?.removeGestureRecognizer(longPressGesture)
                            }
                            else if(status == "Completed"){
                               slide1.triviastartview?.isHidden = true

                                                           slide1.triviastatus?.text = "PLAY VIDEO"
                              
                            }

                         else{
                            slide1.triviastartview?.isHidden = false
                             slide1.triviastatus?.text = "ENTER NOW"
                         }
                         slide1.triviastatus?.addGestureRecognizer(longPressGesture)
                         slide1.triviastatus?.isUserInteractionEnabled = true
                     }
                    
                                         if(myjid != nil){
                     if(status == "Published"){
                        
                        let Purchased = dict?.value(forKey: "Purchased") as! Bool
                         if(Purchased){
                             slide1.ticketprizeView?.isHidden = true
                            
                            slide1.avialableticket?.isHidden = true
                         }
                         else{
                             slide1.ticketprizeView?.isHidden = false
                            slide1.avialableticket?.isHidden = false
                            let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                            let soldout = dict?.value(forKey: "soldout") as! Bool
                             if(soldout){
                               
                                 slide1.ticketprizeView?.isHidden = true
                                slide1.avialableticket?.isHidden = false
                                slide1.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                             }
                             else{
                                 if(FreeTrivia){
                                     slide1.ticketprize?.text = "FREE TO PLAY"
                                    slide1.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                                 }
                                 else{
                                    let ticketprice = dict?.value(forKey: "TicketPrice") as! Double
                                     let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                     if(avilablecoin > ticketprice){
                                         slide1.ticketprize?.text = "\(self.appDelegate().formatNumber(Int(ticketprice))) FanCoins TO PLAY"
                                        slide1.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                                     }
                                     else{
                                         slide1.ticketprize?.text = "\(self.appDelegate().formatNumber(Int(ticketprice))) FanCoins TO PLAY"
                                        slide1.avialableticket?.text = dict?.value(forKey: "AvailableTickets") as? String
                                     }
                                 }
                             }
                         }
                         
                     }
                     else{
                         slide1.ticketprizeView?.isHidden = true
                        slide1.avialableticket?.isHidden = true
                     }
                                         }else{
                                            slide1.ticketprizeView?.isHidden = true
                                                                   slide1.avialableticket?.isHidden = true
                                            
                }
                if(status == "Published"){
                if let mili1 = dict?.value(forKey: "StartTime")
                     {
                         
                         let number: Int64? = Int64(mili1 as! String)
                         let mili: Double = Double(truncating: number! as NSNumber)
                         let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        slide1.setupTimer(with: mili, indexPath: i)
                         let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd MMM yy HH:mm"
                        dateFormatter.timeZone = TimeZone(abbreviation: "BST")
                                        slide1.triviastart?.text = "STARTS @ \(dateFormatter.string(from:myMilliseconds.dateFull)) UK TIME"
                     }
                }
                     
                     
                     //let screenSize = UIScreen.main.bounds
                    /* let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (slide1.title?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
                     label.font = UIFont.systemFont(ofSize: 11.0)
                     label.text = slide1.title?.text
                     label.textAlignment = .left
                     //label.textColor = self.strokeColor
                     label.lineBreakMode = .byWordWrapping
                     label.numberOfLines = 2
                     label.sizeToFit()
                     
                     
                     if((label.frame.height) > 12)
                     {
                         slide1.widthConstraint2.constant = label.frame.height
                         //let height = (label.frame.height) + 410.0
                         //print("Height \((label.frame.height)).")
                         //storyTableView?.rowHeight = CGFloat(height)
                     }
                     else
                     {
                         slide1.widthConstraint2.constant = label.frame.height
                         //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                         //print("Height \((label.frame.height)).")
                         // storyTableView?.rowHeight = CGFloat(height)
                     }*/
                     
                     
                     
                     let lbleltime = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (slide1.triviastart?.frame.height)!))
                                  lbleltime.font = UIFont.boldSystemFont(ofSize: 11.0)
                                  lbleltime.text = slide1.triviastart?.text
                                  lbleltime.textAlignment = .left
                                  //label.textColor = self.strokeColor
                                  lbleltime.lineBreakMode = .byWordWrapping
                                  lbleltime.numberOfLines = 1
                                  lbleltime.sizeToFit()
                                  
                          // slide1.triviastartwidth.constant = lbleltime.frame.width + 15
               // slide1.share?.addGestureRecognizer(longPressGesture_share)
                //slide1.share?.isUserInteractionEnabled = true
                  slide1.isUserInteractionEnabled = true
               // slide1.title?.isUserInteractionEnabled = true
                //slide1.title?.addGestureRecognizer(longPressGesture)
                 // mainview.isUserInteractionEnabled = true
                slide1.issoldout = dict?.value(forKey: "soldout") as! Bool
                 slide1.ispurchase = dict?.value(forKey: "Purchased") as! Bool
                slide1.triviastatus?.tag = i
                scrollView1.addSubview(slide1)
               /* if(!thumbLink.isEmpty)
                {
                    let imgOne = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                    imgOne.contentMode = .scaleAspectFit//.scaleAspectFit//image show perfect if user skysports link
                    imgOne.tag = i
                    lazyImage.show(imageView: imgOne, url: thumbLink)
                    //let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowbrekingPreviewClick(_:)))
                    
                   // longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    //imgOne.addGestureRecognizer(longPressGesture_showpreview2)
                    imgOne.isUserInteractionEnabled = true
                    let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenTriviaAction(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    let slidergradient = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                    slidergradient.contentMode = .scaleAspectFit
                    slidergradient.image = UIImage(named: "slidergradient")
                    var mainheight: CGFloat = 40
                    let status = dict?.value(forKey: "Status") as! String
                    let istoday = dict?.value(forKey: "IsToday") as! Bool
                    if(status == "Live"){
                        mainheight = 27
                    }
                    else if(!istoday){
                        mainheight = 27
                    }
                    let mainview = UIView(frame: CGRect(x: scrollViewWidth - 155 , y: mainheight, width: 140, height: self.Slider1!.frame.height))
                    mainview.backgroundColor = UIColor.clear
                    slidergradient.isUserInteractionEnabled = true
                    mainview.isUserInteractionEnabled = true
                   /*  var timevalue = ""
                    if let mili1 = dict?.value(forKey: "StartTime")
                    {
                        
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        //let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        // cell.setupTimer(with: mili)
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        let dateFormatter = DateFormatter()
                        let timeNow = Date()
                        var timeEnd : Date?
                        
                        timeEnd = myMilliseconds.dateFull as Date
                        if timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
                            
                            let interval = timeEnd?.timeIntervalSince(timeNow)
                            
                            let days =  (interval! / (60*60*24)).rounded(.down)
                            
                            let daysRemainder = interval?.truncatingRemainder(dividingBy: 60*60*24)
                            
                            let hours = (daysRemainder! / (60 * 60)).rounded(.down)
                            
                            let hoursRemainder = daysRemainder?.truncatingRemainder(dividingBy: 60 * 60).rounded(.down)
                            
                            let minites  = (hoursRemainder! / 60).rounded(.down)
                            
                            let minitesRemainder = hoursRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
                            
                            let scondes = minitesRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
                            // print(days)
                            // print(hours)
                            // print(minites)
                            //print(scondes)
                            // header?.DaysProgress.setProgress(days/360, animated: false)
                            // header?.hoursProgress.setProgress(hours/24, animated: false)
                            //header?.minitesProgress.setProgress(minites/60, animated: false)
                            // header?.secondesProgress.setProgress(scondes!/60, animated: false)
                           timevalue = "\(Int(days)) DAYS \(Int(hours)) HOURS \(Int(minites)) MIN. \(Int(scondes as! Double)) SEC. TO PLAY"
                            
                            // header?.valueDay.text = formatter.string(from: NSNumber(value:days))
                            // header?.valueHour.text = formatter.string(from: NSNumber(value:hours))
                            // header?.valueMinites.text = formatter.string(from: NSNumber(value:minites))
                            //header?.valueSeconds.text = formatter.string(from: NSNumber(value:scondes!))
                            
                            
                            
                        } else {
                            // header?.fadeOut()
                            timevalue = "3 more days to play"
                        }
                    }*/
                   
                    let Description = UILabel(frame: CGRect(x: 0.0, y: 40, width: mainview.frame.width, height: CGFloat.greatestFiniteMagnitude))
                    Description.font = UIFont.systemFont(ofSize: 10.0)
                    Description.text = dict?.value(forKey: "Description") as? String
                    Description.textAlignment = .left
                    Description.textColor = UIColor.white
                    Description.lineBreakMode = .byWordWrapping
                    Description.numberOfLines = 4
                    Description.sizeToFit()
                    
                    let triviastaus = UIView(frame: CGRect(x: 0 , y: Description.frame.origin.y + Description.frame.height + 10, width: mainview.frame.width, height: 30))
                    triviastaus.backgroundColor = UIColor.clear
                    triviastaus.layer.borderWidth = 1
                    triviastaus.layer.cornerRadius = 5
                    triviastaus.layer.borderColor = UIColor.init(hex: "FFFFFF").cgColor
                    triviastaus.tag = i
                    var buttitle = ""
                    var lblticketmesShow:Bool = true
                    var ticketpriceShow:Bool = true
                    var lblticketmesText = ""
                    var ticketpriceText = ""
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    if(myjid != nil){
                        let status = dict?.value(forKey: "Status") as! String
                        if(status == "Finished"){
                           buttitle = "VIEW RECORDING"
                            lblticketmesShow = false
                            ticketpriceShow = false
                        }
                        else if(status == "Live"){
                            let Purchased = dict?.value(forKey: "Purchased") as! Bool
                            if(Purchased){
                                buttitle = "JOIN TO PLAY"
                            }else{
                                buttitle = "JOIN TO VIEW"
                            }
                            lblticketmesShow = false
                            ticketpriceShow = false
                            
                            triviastaus.addGestureRecognizer(longPressGesture)
                            triviastaus.isUserInteractionEnabled = true
                        }
                            
                        else if(status == "Published"){
                            let Purchased = dict?.value(forKey: "Purchased") as! Bool
                            if(Purchased){
                                buttitle = "WAIT TO START"
                                lblticketmesShow = false
                                ticketpriceShow = false
                            }
                            else{
                                let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                                let soldout = dict?.value(forKey: "soldout") as! Bool
                                if(soldout){
                                    buttitle = "SOLD OUT"
                                    lblticketmesShow = false
                                    ticketpriceShow = false
                                }
                                else{
                                if(FreeTrivia){
                                    buttitle = "SECURE YOUR ENTRY"
                                    triviastaus.addGestureRecognizer(longPressGesture)
                                    triviastaus.isUserInteractionEnabled = true
                                    ticketpriceText = "Play for free"
                                    lblticketmesText = dict?.value(forKey: "AvailableTickets") as! String
                                }
                                else{
                                    let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                                    let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                    if(avilablecoin > ticketprize){
                                        buttitle = "SECURE YOUR ENTRY"
                                        ticketpriceText = "Redeem from \(self.appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as? Int ?? 0)) FCs"
                                       lblticketmesText = dict?.value(forKey: "AvailableTickets") as! String
                                    }
                                    else{
                                        buttitle = "BUY FANCOINS"
                                        ticketpriceText = "Buy or earn more FCs"
                                        lblticketmesText = dict?.value(forKey: "AvailableTickets") as! String
                                    }
                                    triviastaus.addGestureRecognizer(longPressGesture)
                                    triviastaus.isUserInteractionEnabled = true
                                    }
                                    
                                }
                            }
                            
                        }
                    }else{
                        let status = dict?.value(forKey: "Status") as! String
                        if(status == "Live"){
                            buttitle = "JOIN TO VIEW"
                        }else{
                            buttitle = "SIGN IN"
                        }
                        triviastaus.addGestureRecognizer(longPressGesture)
                        triviastaus.isUserInteractionEnabled = true
                        lblticketmesShow = false
                        ticketpriceShow = false
                    }
                    
                    
                    let trivibuttext = UILabel(frame: CGRect(x: 5, y: 0, width: triviastaus.frame.width - 5, height: triviastaus.frame.height))
                    trivibuttext.font = UIFont.boldSystemFont(ofSize: 11.0)
                    trivibuttext.text = buttitle
                    trivibuttext.textAlignment = .center
                    trivibuttext.textColor = UIColor.white
                    trivibuttext.lineBreakMode = .byWordWrapping
                    trivibuttext.numberOfLines = 1
                    
                    let ticketprice = UIView(frame: CGRect(x: 0 , y: triviastaus.frame.origin.y + triviastaus.frame.height + 10, width: mainview.frame.width, height: 15))
                    ticketprice.backgroundColor = UIColor.clear
                    let ffcoin = UIImageView(frame: CGRect(x:0, y:0,width:15, height:15))
                     ffcoin.image = UIImage(named: "ffcoin")
                    
                    let lblprice = UILabel(frame: CGRect(x: 20, y: 0, width: ticketprice.frame.width - 25, height: ticketprice.frame.height))
                    lblprice.font = UIFont.boldSystemFont(ofSize: 9.0)
                    
                    //lblprice.textAlignment = .center
                    if(ticketpriceShow){
                        lblprice.text = ticketpriceText
                    }
                    else{
                        ticketprice.isHidden = true
                        lblprice.text = ""
                    }
                    lblprice.textColor = UIColor.white
                    lblprice.lineBreakMode = .byWordWrapping
                    lblprice.numberOfLines = 1
                    let lblticketmes = UILabel(frame: CGRect(x: 0, y: ticketprice.frame.origin.y + ticketprice.frame.height + 5, width: mainview.frame.width, height: 15))
                    lblticketmes.font = UIFont.boldSystemFont(ofSize: 9.0)
                    if(lblticketmesShow){
                        lblticketmes.text = lblticketmesText
                    }
                    else{
                        lblticketmes.isHidden = true
                        lblticketmes.text = ""
                    }
                    
                    //lblprice.textAlignment = .center
                    lblticketmes.textColor = UIColor.white
                    lblticketmes.lineBreakMode = .byWordWrapping
                    lblticketmes.numberOfLines = 1
                    
                    self.scrollView1.addSubview(imgOne)
                    //imgOne.addSubview(slidergradient)
                    self.scrollView1.addSubview(slidergradient)
                    slidergradient.addSubview(mainview)
                   // mainview.addSubview(lbltime)
                    mainview.addSubview(Description)
                    mainview.addSubview(triviastaus)
                    triviastaus.addSubview(trivibuttext)
                    mainview.addSubview(ticketprice)
                    ticketprice.addSubview(ffcoin)
                    ticketprice.addSubview(lblprice)
                    mainview.addSubview(lblticketmes)*/
               // }
            }
        }
            let count: CGFloat = CGFloat(appDelegate().arrhometrivia.count)
            self.scrollView1.contentSize = CGSize(width:scrollViewWidth * count, height:self.scrollView1.frame.height)
            scrollView1.contentOffset.x = 0
            self.scrollView1.delegate = self
            self.pageControl1.numberOfPages = appDelegate().arrhometrivia.count
            self.pageControl1.currentPage = 0
            curentTriviaindex = 0
            //settriviadetails()
           /* couponTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.settriviadetails), userInfo: nil, repeats: true);
            
            RunLoop.current.add(couponTimer!, forMode: RunLoop.Mode.common)
            couponTimer?.fire()*/
    }
        else{
            couponTimer?.invalidate()
        }
    }
    func setNewsSlider(){
    
        self.scrollView3.frame = CGRect(x:0, y:0, width:self.Slider3!.frame.width, height:(self.Slider3?.frame.height)!)
        
        let scrollViewWidth:CGFloat = self.scrollView3.frame.width
        let scrollViewHeight:CGFloat = self.scrollView3.frame.height
        for i in 0...appDelegate().arrhomenews.count-1 {
            let dict: NSDictionary? = appDelegate().arrhomenews[i] as? NSDictionary
            if(dict != nil)
            {
                
                
                let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                
                
                // cell.newsTitle?.text = decodedString
                
                
                var thumbLink: String = ""
                if let thumb = dict?.value(forKey: "urls")
                {
                    thumbLink = thumb as! String
                }
                
                
                if(!thumbLink.isEmpty)
                {
                    
                    let imgnews = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                    imgnews.contentMode = .center//.scaleAspectFit//image show perfect if user skysports link
                    imgnews.tag = i
                    lazyImage.show(imageView: imgnews, url: thumbLink)
                    let slidergradient = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                    slidergradient.contentMode = .scaleToFill
                    slidergradient.image = UIImage(named: "")
                   
                   
                    //let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowbrekingPreviewClick(_:)))
                    
                    // longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
                    
                    
                    //imgOne.addGestureRecognizer(longPressGesture_showpreview2)
                    //imgOne.isUserInteractionEnabled = true
                    
                    //imgOne.image = UIImage(named: "slide1")
                    /*let lbl = UILabel(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:scrollViewHeight-90,width:scrollViewWidth, height:50))
                     lbl.backgroundColor = UIColor.white
                     lbl.alpha = 0.9
                     lbl.text = decodedString
                     //  let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
                     imgOne.addSubview(lbl)*/
                    let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpennewsAction(_:)))
                    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                    longPressGesture.delegate = self as? UIGestureRecognizerDelegate
                     let layer = CALayer()
                    
                    let Description = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: 120, height: CGFloat.greatestFiniteMagnitude))
                    Description.font = UIFont.boldSystemFont(ofSize: 11.0)
                    Description.text = decodedString//"\nDefending champions Morocco face Algeria without injured stars"//decodedString
                    Description.textAlignment = .left
                    Description.textColor = UIColor.white
                    Description.lineBreakMode = .byWordWrapping
                    Description.numberOfLines = 6
                    Description.sizeToFit()
                    let height = Description.frame.height + 20
                   //  let mainview1 = UIView(frame: CGRect(x: 0 , y: 10, width: 140, height: height))
                    //mainview.Height = CGFloat(Description.frame.height + 20.0)
                   
                    layer.frame = CGRect(x: 0 , y: 0, width: 140, height: height)//someView.bounds
                    layer.backgroundColor = UIColor(red: 0.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
                    layer.opacity = 0.5
                    layer.cornerRadius = 10
                    let mainview = CustomBorderView(frame: CGRect(x: scrollViewWidth - 150 , y: 10, width: 140, height: height))
                                       mainview.backgroundColor = UIColor.clear
                                       slidergradient.isUserInteractionEnabled = true
                                       mainview.isUserInteractionEnabled = true
                    //mainview.cornerRadius = 10
/*let textLayer = CATextLayer()
                    textLayer.frame = Description.bounds
                    textLayer.string = decodedString
                    textLayer.font = UIFont.boldSystemFont(ofSize: 11)
                    textLayer.foregroundColor = UIColor.darkGray.cgColor
                    textLayer.isWrapped = true*/
                    
                    //lblName.sizeToFit()
                    /*let triviastaus = UIView(frame: CGRect(x: 0 , y: Description.frame.origin.y + Description.frame.height + 10, width: mainview.frame.width, height: 30))
                    triviastaus.backgroundColor = UIColor.clear
                    triviastaus.layer.borderWidth = 1
                    triviastaus.layer.cornerRadius = 5
                    triviastaus.layer.borderColor = UIColor.init(hex: "FFFFFF").cgColor
                    triviastaus.tag = i
                    triviastaus.addGestureRecognizer(longPressGesture)
                    triviastaus.isUserInteractionEnabled = true
                    
                    let trivibuttext = UILabel(frame: CGRect(x: 5, y: 0, width: triviastaus.frame.width - 5, height: triviastaus.frame.height))
                    trivibuttext.font = UIFont.boldSystemFont(ofSize: 11.0)
                    trivibuttext.text = "VIEW NEWS"
                    trivibuttext.textAlignment = .center
                    trivibuttext.textColor = UIColor.white
                    trivibuttext.lineBreakMode = .byWordWrapping
                    trivibuttext.numberOfLines = 1*/
                    mainview.tag = i
                     mainview.addGestureRecognizer(longPressGesture)
                    slidergradient.tag = i
                    slidergradient.addGestureRecognizer(longPressGesture)
                    self.scrollView3.addSubview(imgnews)
                    self.scrollView3.addSubview(slidergradient)
                    slidergradient.addSubview(mainview)
                    mainview.layer.insertSublayer(layer, at: 0)
                   // mainview.layer.insertSublayer(textLayer, at: 1)
                     Description.frame.origin = CGPoint(x:10.0, y:10.0 )
                   mainview.addSubview(Description)
                    //mainview.addSubview(triviastaus)
                    //triviastaus.addSubview(trivibuttext)
                    //Description.center = mainview.center
                    //mainview.center = Description.center
                }
            }
        }
        let count: CGFloat = CGFloat(appDelegate().arrhomenews.count)
        self.scrollView3.contentSize = CGSize(width:scrollViewWidth * count, height:self.scrollView3.frame.height)
        scrollView3.contentOffset.x = 0
        self.scrollView3.delegate = self
        self.pageControl3.numberOfPages = appDelegate().arrhomenews.count
        self.pageControl3.currentPage = 0
        
        
    }
    func setStorySlider(){
          
          self.scrollView2.frame = CGRect(x:0, y:0, width:self.Slider2!.frame.width, height:(self.Slider2?.frame.height)!)
          
          let scrollViewWidth:CGFloat = self.scrollView2.frame.width
          let scrollViewHeight:CGFloat = self.scrollView2.frame.height
          for i in 0...appDelegate().arrhomefanupdate.count-1 {
              let dict: NSDictionary? = appDelegate().arrhomefanupdate[i] as? NSDictionary
              let isblocked = dict?.value(forKey: "isblocked") as! Bool
              if(isblocked){
                  let imgstory = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                  imgstory.contentMode = .scaleToFill
                  imgstory.image = UIImage(named: "BlockedContent")
                   self.scrollView2.addSubview(imgstory)
              }
              else{
                  if(dict != nil)
                  {
                      
                      
                      //let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                      // let decodedString = String(data: decodedData, encoding: .utf8)!
                      
                      
                      // cell.newsTitle?.text = decodedString
                      let messageContent = dict?.value(forKey: "message")as! String
                      
                      if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                      {
                          do {
                              let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                              let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                               let decodedString = String(data: decodedData, encoding: .utf8)!
                              
                      var thumbLink: String = ""
                      
                      
                      if(jsonDataMessage?.value(forKey: "type") as! String == "video")
                                      {
                                      if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                      {
                                          thumbLink = thumb as! String
                                      }
                                      } else {
                                          if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                          {
                                              thumbLink = thumb as! String
                                          }
                                      }
                                      





                      if(!thumbLink.isEmpty)
                      {
                         let imgstory = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                          imgstory.contentMode = .scaleAspectFill//.scaleAspectFit//image show perfect if user skysports link
                          imgstory.tag = i
                          lazyImage.show(imageView: imgstory, url: thumbLink)
                         //imgstory.imageURL = thumbLink
                          let slidergradient = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                          slidergradient.contentMode = .scaleToFill
                          //slidergradient.image = UIImage(named: "")
                         
                          let mainview = UIView(frame: CGRect(x: scrollViewWidth - 150 , y: 10, width: 140, height: self.Slider2!.frame.height))
                          mainview.backgroundColor = UIColor.clear
                          slidergradient.isUserInteractionEnabled = true
                          mainview.isUserInteractionEnabled = true
                          //let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowbrekingPreviewClick(_:)))
                          
                          // longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
                          
                          
                          //imgOne.addGestureRecognizer(longPressGesture_showpreview2)
                          //imgOne.isUserInteractionEnabled = true
                          
                          //imgOne.image = UIImage(named: "slide1")
                          /*let lbl = UILabel(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:scrollViewHeight-90,width:scrollViewWidth, height:50))
                           lbl.backgroundColor = UIColor.white
                           lbl.alpha = 0.9
                           lbl.text = decodedString
                           //  let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
                           imgOne.addSubview(lbl)*/
                          let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenstoryAction(_:)))
                          let layer = CALayer()
                                             let deshieght:CGFloat = 10.0
                          let Description = UILabel(frame: CGRect(x: 10.0, y: deshieght, width: 120, height: CGFloat.greatestFiniteMagnitude))
                          Description.font = UIFont.boldSystemFont(ofSize: 11.0)
                          Description.text = decodedString//"\nSimple Moving before acceleration"
                          Description.textAlignment = .left
                          Description.textColor = UIColor.white
                          Description.lineBreakMode = .byWordWrapping
                          Description.numberOfLines = 6
                          Description.sizeToFit()
                                
                          let height = Description.frame.height + 20
                                           //  let mainview1 = UIView(frame: CGRect(x: 0 , y: 10, width: 140, height: height))
                                            //mainview.Height = CGFloat(Description.frame.height + 20.0)
                                           
                                            layer.frame = CGRect(x: 0 , y: 0, width: 140, height: height)//someView.bounds
                                            layer.backgroundColor = UIColor(red: 0.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
                                            layer.opacity = 0.5
                                            layer.cornerRadius = 10
                          /*let triviastaus = UIView(frame: CGRect(x: 0 , y: Description.frame.origin.y + Description.frame.height + 10, width: mainview.frame.width, height: 30))
                          triviastaus.backgroundColor = UIColor.clear
                          triviastaus.layer.borderWidth = 1
                          triviastaus.layer.cornerRadius = 5
                          triviastaus.layer.borderColor = UIColor.init(hex: "FFFFFF").cgColor
                          triviastaus.tag = i
                          triviastaus.addGestureRecognizer(longPressGesture)
                          triviastaus.isUserInteractionEnabled = true
                          
                          let trivibuttext = UILabel(frame: CGRect(x: 5, y: 0, width: triviastaus.frame.width - 5, height: triviastaus.frame.height))
                          trivibuttext.font = UIFont.boldSystemFont(ofSize: 11.0)
                          trivibuttext.text = "VIEW POST"
                          trivibuttext.textAlignment = .center
                          trivibuttext.textColor = UIColor.white
                          trivibuttext.lineBreakMode = .byWordWrapping
                          trivibuttext.numberOfLines = 1*/
                          mainview.tag = i
                           mainview.addGestureRecognizer(longPressGesture)
                          slidergradient.tag = i
                          slidergradient.addGestureRecognizer(longPressGesture)
                          self.scrollView2.addSubview(imgstory)
                          self.scrollView2.addSubview(slidergradient)
                          slidergradient.addSubview(mainview)
                           Description.frame.origin = CGPoint(x:10.0, y:10.0 )
                          mainview.addSubview(Description)
                          mainview.layer.insertSublayer(layer, at: 0)
                         // mainview.addSubview(triviastaus)
                          //triviastaus.addSubview(trivibuttext)
                          //Description.topAnchor.constraint(equalTo: mainview.topAnchor,constant: 30).isActive = true
                                         
                      }
                      }
                      catch let error as NSError {
                              print(error)
                          }
                      }
                  }
              }
              
          }
          let count: CGFloat = CGFloat(appDelegate().arrhomefanupdate.count)
          self.scrollView2.contentSize = CGSize(width:scrollViewWidth * count, height:self.scrollView2.frame.height)
          scrollView2.contentOffset.x = 0
          self.scrollView2.delegate = self
          self.pageControl2.numberOfPages = appDelegate().arrhomefanupdate.count
          self.pageControl2.currentPage = 0
          
          
      }

    
    @objc func triviabutAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
       
       // Crashlytics.sharedInstance().crash()
       // let testarray = ["hello","hi"]
            //  print(testarray[3])
             DispatchQueue.main.async {
                if(!self.appDelegate().triviamoreOption)
                 {
                 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                 let myTeamsController : UpcomingTriviaViewController = storyBoard.instantiateViewController(withIdentifier: "upcommingtrivia") as! UpcomingTriviaViewController
                 
                    self.show(myTeamsController, sender: self)
                 }
                 else{
                     let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let registerController : PastTriviaViewController! = storyBoard.instantiateViewController(withIdentifier: "PastTrivia") as? PastTriviaViewController
                     //self.appDelegate().returnHomeToOtherView = true
                            self.show(registerController, sender: self)
                 }
                /* self.infoAlertVC = MessageAlertViewController.instantiate()
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
                 self.present(popupVC, animated: true, completion: nil)*/
             }
        
    }
    @objc func newsbutAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
     
         DispatchQueue.main.async {
             let storyBoard = UIStoryboard(name: "Main", bundle: nil)
             let myTeamsController : NewsViewController = storyBoard.instantiateViewController(withIdentifier: "news") as! NewsViewController
            
             //show(myTeamsController, sender: self)
                self.show(myTeamsController, sender: self)
         }
        
    }
    @objc func storybutAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //Crashlytics.sharedInstance().crash()
            DispatchQueue.main.async {
               // let testarray = ["hello","hi"]
                        //    print(testarray[3])
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let myTeamsController : FanUpdatesListViewController = storyBoard.instantiateViewController(withIdentifier: "FanUpdate") as! FanUpdatesListViewController
               
                //show(myTeamsController, sender: self)
                self.show(myTeamsController, sender: self)
            }
    }
     @IBAction func triviabut(){
        if(!appDelegate().triviamoreOption)
        {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : UpcomingTriviaViewController = storyBoard.instantiateViewController(withIdentifier: "upcommingtrivia") as! UpcomingTriviaViewController
        
        show(myTeamsController, sender: self)
        }
        else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                   let registerController : PastTriviaViewController! = storyBoard.instantiateViewController(withIdentifier: "PastTrivia") as? PastTriviaViewController
            //self.appDelegate().returnHomeToOtherView = true
                   self.show(registerController, sender: self)
        }
    }
        @IBAction func mediabut(){
              let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                      let settingsController : MediaSubCategoriesViewControler = storyBoard.instantiateViewController(withIdentifier: "MediaSubCategories") as! MediaSubCategoriesViewControler
                      settingsController.cid = Int64.init(0)
                      settingsController.maintitel = "Videos"
                      show(settingsController, sender: self)
    }
    @IBAction func newsbut(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : NewsViewController = storyBoard.instantiateViewController(withIdentifier: "news") as! NewsViewController
       
        //show(myTeamsController, sender: self)
        show(myTeamsController, sender: self)
    }
    @IBAction func storybut(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : FanUpdatesListViewController = storyBoard.instantiateViewController(withIdentifier: "FanUpdate") as! FanUpdatesListViewController
       
        //show(myTeamsController, sender: self)
        show(myTeamsController, sender: self)
    }
    @objc func Showprofile(sender:UIButton) {
        //print("Show Filter")
      
             appDelegate().countrySelected = ""
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let myTeamsController : ProfileViewController = storyBoard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
             appDelegate().isFromSettings = true
            myTeamsController.isFromSettings = true
            //show(myTeamsController, sender: self)
             show(myTeamsController, sender: self)
            
    }
   @objc func Shownotificationlist(sender:UIButton) {
          //print("Show Filter")
   
              let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let myTeamsController : NotificationListViewController = storyBoard.instantiateViewController(withIdentifier: "notificationlist") as! NotificationListViewController
               show(myTeamsController, sender: self)
              
      }
    func ShowNotificationPermission()  {
       // DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
          DispatchQueue.main.async {
            let popController: VideoPermissionScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoPermissionScreen") as! VideoPermissionScreen
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.notifyType = "notification"
            // present the popover
            self.present(popController, animated: true, completion: nil)
            
    }
        //}
    }
    @objc func buttonbadge(){
    let rightBarButtons = parent?.navigationItem.rightBarButtonItems
           
           let lastBarButton = rightBarButtons?.last
            let notificationcount: String? = UserDefaults.standard.string(forKey: "notificationcount")
        if(notificationcount == "0"){
             lastBarButton?.setBadge(text: "")
        }
        else{
            lastBarButton?.setBadge(text: ".")
        }
      
                  
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
    @objc func refreshBadgeCount(){
        DispatchQueue.main.async {
            let tabItems = self.tabBarController?.tabBar.items
            // In this case we want to modify the badge number of the third tab:
            
            if( tabItems != nil){
                let tabItem = tabItems![1]
              
                // Now set the badge of the third tab
                if(self.appDelegate().badgeCount("all") != 0)
                {
                    if(self.appDelegate().badgeCount("all") > 9){
                        tabItem.badgeValue = "9+"
                    }
                    else{
                        tabItem.badgeValue = self.appDelegate().badgeCount("all").description
                    }
                    //
                    //tabItem.badgeColor = UIColor.init(hex: "FFD401")
                } else {
                    tabItem.badgeValue = nil
                }
                
              /*  let tabItem1 = tabItems![4]
                
                // Now set the badge of the third tab
                if(self.appDelegate().badgeCount("chat") != 0)
                {
                    tabItem1.badgeValue = self.appDelegate().badgeCount("chat").description
                } else
                {
                    tabItem1.badgeValue = nil
                }*/
                let notificationName = Notification.Name("RefreshmoreView")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }
    @objc func showChatWindowWithNotify(notification: NSNotification)
    {
       
       // LoadingIndicatorView.show(view, loadingText: "Please wait while loading Messages")
         var Roomname: String = (notification.userInfo?["roomname"] as? String)!
                     var isjoin: String =  "yes"
                     var isBanterClosed: String =  "active"
                    let curRoomType: String = (notification.userInfo?["roomtype"] as? String)!
                    let toUserJID: String =  (notification.userInfo?["roomid"] as? String)!
                    var mySupportedTeam: Int64 =  0
                    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
            if localArrAllChats != nil
            {
                //Code to parse json data
                if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    do {
                        self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            if let dict2 = self.appDelegate().arrAllChats[toUserJID]
            {
                
                
                if(dict2.value(forKey: "userAvatar") != nil)
                {
                    self.appDelegate().toAvatarURL = (dict2.value(forKey: "userAvatar") as? String)!
                }
                else
                {
                    self.appDelegate().toAvatarURL = ""
                }
                if (curRoomType == "chat")
                {
                    self.appDelegate().isFromNewChat = true
                    self.tabBarController?.selectedIndex = 1
                    self.appDelegate().messageTabindex = 1
                     Roomname =  self.appDelegate().ExistingContact(username: toUserJID)!//(dict.value(forKey: "username") as? String)!
                                                           }
                else
                {
                    if let joined = dict2.value(forKey: "isJoined")
                    {
                       isjoin = joined as! String
                    }
                    else
                    {
                      isjoin = "no"
                    }
                    
                    if let closed = dict2.value(forKey: "banterStatus")
                    {
                        if((closed as! String) == "closed")
                        {
                           isBanterClosed = closed as! String
                        }
                        else
                        {
                            isBanterClosed = "active"
                        }
                        
                    }
                    else
                    {
                        isBanterClosed = "active"
                    }
                    
                    
                    
                    /*if (dict2?.value(forKey: "banterUsers")) != nil
                     {
                     banterUsers = dict2?.value(forKey: "banterUsers") as! NSMutableArray
                     print(banterUsers)
                     }*/
                    
                    if (dict2.value(forKey: "supportedTeam")) != nil
                    {
                        self.supportedTeam = dict2.value(forKey: "supportedTeam") as! Int64
                        // print(supportedTeam)
                    }
                    
                    if (dict2.value(forKey: "opponentTeam")) != nil
                    {
                        self.opponentTeam = dict2.value(forKey: "opponentTeam") as! Int64
                        // print(opponentTeam)
                    }
                    
                    if (dict2.value(forKey: "mySupportedTeam")) != nil
                    {
                        //opponentTeam = dict2?.value(forKey: "mySupportedTeam") as! Int
                        mySupportedTeam = dict2.value(forKey: "mySupportedTeam") as! Int64
                        //print(dict2?.value(forKey: "mySupportedTeam") ?? "")
                    }
                    
                    
                    
                    
                    let chatType: String = dict2.value(forKey: "chatType") as! String
                   
                    if(chatType == "banter")
                    {
                        
                        
                        let isOpen =  self.appDelegate().isBanterIsOpen(supportedTeam: self.supportedTeam, opponentTeam: self.opponentTeam)
                        
                        if(isOpen == false)
                        {
                            isBanterClosed = "closed"
                        }
                    }
                        else if(chatType == "teambr")
                            {
                                let isLeave = self.appDelegate().isCloseLeaveTeambr(mySupportedTeam: Int(self.supportedTeam))
                                if(!isLeave)
                                {
                                    isBanterClosed = "closed"
                                }
                        }
                    else{
                        self.appDelegate().isFromNewChat = true
                        self.tabBarController?.selectedIndex = 1
                        self.appDelegate().messageTabindex = 1
                        if let closed = dict2.value(forKey: "banterStatus")
                        {
                            if((closed as! String) == "closed")
                            {
                                isBanterClosed = closed as! String
                            }
                            else
                            {
                               isBanterClosed = "active"
                            }
                            
                        }
                        else
                        {
                           isBanterClosed = "active"
                        }
                        
                        
                    }
                    
                }
                
            }
            else{
                let subtypevalue = (notification.userInfo?["subtype"] as? Int)!
                if(subtypevalue == 1){
                    // "opponentTeam": opponentTeam , "supportedTeam":
                    /* let alert = UIAlertController(title: "", message: "\((notification.userInfo?["opponentTeam"] as? Int64)!)", preferredStyle: .alert)
                     let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
                     
                     });
                     alert.addAction(action)
                     self.present(alert, animated: true, completion:nil)*/
                    
                    
                    self.appDelegate().isBanterClosed = "active"
                    
                    self.opponentTeam = (notification.userInfo?["opponentTeam"] as? AnyObject)! as! Int64
                    self.supportedTeam = (notification.userInfo?["supportedTeam"] as? AnyObject)! as! Int64
                }
                else if(subtypevalue == 2){
                    // "opponentTeam": opponentTeam , "supportedTeam":
                    /* let alert = UIAlertController(title: "", message: "\((notification.userInfo?["opponentTeam"] as? Int64)!)", preferredStyle: .alert)
                     let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
                     
                     });
                     alert.addAction(action)
                     self.present(alert, animated: true, completion:nil)*/
                    
                    
                    self.appDelegate().isBanterClosed = "active"
                    self.appDelegate().isJoined = "no"
                    self.appDelegate().curRoomType = "banter"
                    
                    self.opponentTeam = (notification.userInfo?["opponentTeam"] as? AnyObject)! as! Int64
                    self.supportedTeam = (notification.userInfo?["supportedTeam"] as? AnyObject)! as! Int64
                }
            }
            //let chatType = dict2?.value(forKey: "chatType") as? String
            //self.appDelegate().joinRoomOnly(with: appDelegate().toUserJID, delegate: self.appDelegate())
            
            
            
            if(self.appDelegate().isOnChatView)
            {
                // self.appDelegate().curRoomType = "banter"ShowChatWindowFromChats
                let notificationName = Notification.Name("showWindowFromNotification")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
            else
            {
               /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
                //present(registerController as! UIViewController, animated: true, completion: nil)
                registerController.opponentTeam = self.opponentTeam
                registerController.supportedTeam = self.supportedTeam
                //self.appDelegate().curRoomType = "banter"
                self.show(registerController, sender: self)*/
                  self.showChatWindow(roomid: toUserJID, BanterClosed: isBanterClosed, roomtype: curRoomType, roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
            }
            
            
            
            LoadingIndicatorView.hide()
            //self.dismiss(animated: false, completion: nil)
            //self.dismiss(animated: false, completion: nil)
            //self.dismiss(animated: false, completion: nil)
        }
        
        /* }
         else{
         DispatchQueue.main.async {
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
         //present(registerController as! UIViewController, animated: true, completion: nil)
         registerController.opponentTeam = (notification.userInfo?["opponentTeam"] as? Int)!
         registerController.supportedTeam = (notification.userInfo?["supportedTeam"] as? Int)!
         self.appDelegate().curRoomType = "banter"
         self.show(registerController, sender: self)
         }
         }*/
        
        
        
    }
    @objc func refreshTabindexsNotificationFFDeepLink(notification: NSNotification)
    {
        let Status = (notification.userInfo?["index"] )as! String
        
        if(Status == "fanupdate")
        {DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 0
             LoadingIndicatorView.hide()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : FanUpdateDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "fanupdatedetail") as? FanUpdateDetailViewController
            //present(registerController as! UIViewController, animated: true, completion: nil)
            registerController.fanupdatedetail = notification.userInfo?["response"] as! [AnyObject]
            registerController.fromBanter = true
            self.show(registerController, sender: self)
            }
        }
            else if(Status == "media")
            {DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 0
                 LoadingIndicatorView.hide()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let registerController : MediaDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "mediadetail") as? MediaDetailViewController
                //present(registerController as! UIViewController, animated: true, completion: nil)
                registerController.fanupdatedetail = notification.userInfo?["response"] as! [AnyObject]
                registerController.fromBanter = true
                self.show(registerController, sender: self)
                }
            }
        else if(Status == "news")
        {DispatchQueue.main.async {
             LoadingIndicatorView.hide()
            self.tabBarController?.selectedIndex = 0
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : NewsDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "newsdetail") as? NewsDetailViewController
            //present(registerController as! UIViewController, animated: true, completion: nil)
            registerController.newsdetail = notification.userInfo?["response"] as! NSDictionary
            registerController.fromBanter = true
            self.show(registerController, sender: self)
            }
        }  else if(Status == "roominvite")
        {
            self.tabBarController?.selectedIndex = 1
            // print(notification.userInfo?["response"] as! [AnyObject])
            let response: NSArray = notification.userInfo?["response"]  as! NSArray
            // for record in response {
            let roomDetailsDict = response[0] as! [String : AnyObject]
            var Roomname: String =  ""
                       var isjoin: String =  ""
                       var isBanterClosed: String =  ""
                      //var curRoomType: String =  ""
                     
                      var mySupportedTeam: Int64 =  0
                      
                            
            let roomid = roomDetailsDict["roomid"] as! String
            let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
            if localArrAllChats != nil
            {
                //Code to parse json data
                if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    do {
                        appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
            }
            //print( appDelegate().arrAllChats.count)
            if let dict2 = appDelegate().arrAllChats[roomid]
            {
                
               
               Roomname = (dict2.value(forKey: "userName") as? String)!
                
                let chatType: String = dict2.value(forKey: "chatType") as! String
                
                
                if(dict2.value(forKey: "userAvatar") != nil)
                {
                    self.appDelegate().toAvatarURL = (dict2.value(forKey: "userAvatar") as? String)!
                }
                else
                {
                    self.appDelegate().toAvatarURL = ""
                }
                if (chatType == "chat")
                {
                    self.appDelegate().isFromNewChat = true
                    self.tabBarController?.selectedIndex = 1
                    appDelegate().messageTabindex = 1
                    Roomname = (dict2.value(forKey: "userName") as? String)!
                }
                else
                {
                    if let joined = dict2.value(forKey: "isJoined")
                    {
                       isjoin = joined as! String
                    }
                    else
                    {
                       isjoin = "no"
                    }
                    
                    if let closed = dict2.value(forKey: "banterStatus")
                    {
                        if((closed as! String) == "closed")
                        {
                            isBanterClosed = closed as! String
                        }
                        else
                        {
                            isBanterClosed = "active"
                        }
                        
                    }
                    else
                    {
                        isBanterClosed = "active"
                    }
                    
                    
                    
                    /*if (dict2?.value(forKey: "banterUsers")) != nil
                     {
                     banterUsers = dict2?.value(forKey: "banterUsers") as! NSMutableArray
                     print(banterUsers)
                     }*/
                    
                    if (dict2.value(forKey: "supportedTeam")) != nil
                    {
                        self.supportedTeam = dict2.value(forKey: "supportedTeam") as! Int64
                        // print(supportedTeam)
                    }
                    
                    if (dict2.value(forKey: "opponentTeam")) != nil
                    {
                        self.opponentTeam = dict2.value(forKey: "opponentTeam") as! Int64
                        // print(opponentTeam)
                    }
                    
                    if (dict2.value(forKey: "mySupportedTeam")) != nil
                    {
                        //opponentTeam = dict2?.value(forKey: "mySupportedTeam") as! Int
                        mySupportedTeam = dict2.value(forKey: "mySupportedTeam") as! Int64
                        //print(dict2?.value(forKey: "mySupportedTeam") ?? "")
                    }
                    
                    
                    
                    
                    
                    if(chatType == "banter")
                    {
                        
                        
                        let isOpen =  appDelegate().isBanterIsOpen(supportedTeam: self.supportedTeam, opponentTeam: self.opponentTeam)
                        
                        if(isOpen == false)
                        {
                           isBanterClosed = "closed"
                        }
                    }
                        else if(chatType == "teambr")
                        {
                            let isLeave = appDelegate().isCloseLeaveTeambr(mySupportedTeam: Int(supportedTeam))
                            if(!isLeave)
                            {
                                isBanterClosed = "closed"
                            }
                    }
                    else{
                        self.appDelegate().isFromNewChat = true
                        self.tabBarController?.selectedIndex = 1
                        appDelegate().messageTabindex = 1
                        if let closed = dict2.value(forKey: "banterStatus")
                        {
                            if((closed as! String) == "closed")
                            {
                                isBanterClosed = closed as! String
                            }
                            else
                            {
                               isBanterClosed = "active"
                            }
                            
                        }
                        else
                        {
                            isBanterClosed = "active"
                        }
                        
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                   /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
                    //present(registerController as! UIViewController, animated: true, completion: nil)
                    registerController.opponentTeam = self.opponentTeam
                    registerController.supportedTeam = self.supportedTeam
                    //self.appDelegate().curRoomType = "banter"
                    self.show(registerController, sender: self)*/
                     self.showChatWindow(roomid: roomid, BanterClosed: isBanterClosed, roomtype: chatType, roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
                }
                /*let banterTeams:[String: Int] = ["opponentTeam": appDelegate().opponentTeam , "supportedTeam": appDelegate().supportedTeam, "subtype": 0]
                 let notificationName = Notification.Name("ShowChatWindowFromNotification")
                 NotificationCenter.default.post(name: notificationName, object: nil, userInfo: banterTeams)*/
            }
            else{
                let roomstatus = roomDetailsDict["roomstatus"] as! String
                if( roomstatus == "active"){
                    isBanterClosed = "active"
                    let roomtype = roomDetailsDict["roomtype"] as! String
                    
                    if(roomtype == "banter"){
                        //(dict2.value(forKey: "toUserJID") as? String)!
                        isjoin = "no"
                        Roomname = roomDetailsDict["roomname"] as! String
                        self.supportedTeam = roomDetailsDict["supportteam"] as! Int64
                        self.opponentTeam = roomDetailsDict["opponentteam"] as! Int64
                        //let banterUsers: NSArray = roomDetailsDict["banterUser"] as! NSArray
                        var isOpen: Bool = true
                        isOpen =  appDelegate().isBanterIsOpen(supportedTeam: self.supportedTeam, opponentTeam: self.opponentTeam)
                        
                        if(isOpen == false)
                        {
                            var teamone = ""
                            var teamtwo = ""
                            let array1 = Teams_details.rows(filter:"team_Id = \(self.supportedTeam)") as! [Teams_details]
                            if(array1.count != 0) {
                                let disnarysound = array1[0]
                                teamone = disnarysound.team_name
                            }
                            let array2 = Teams_details.rows(filter:"team_Id = \(self.opponentTeam)") as! [Teams_details]
                            if(array2.count != 0) {
                                let disnarysound = array2[0]
                                teamtwo = disnarysound.team_name
                            }
                            let message = "Sorry, you can’t join this Banter Room as you don’t follow either \(teamone) or \(teamtwo) involved in this Banter Room.\n\nIn order to join this Banter Room please change your team(s) by going to Settings->My Teams."
                            
                            alertWithButtonGOTOSeting(title: nil, message: message, ViewController: self)
                            // self.appDelegate().isBanterClosed = "closed"
                        }
                        else{
                            
                            let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                            
                            let mili: Int64 = appDelegate().getUTCFormateDate()
                            appDelegate().prepareMessageForServerIn(roomid, messageContent: "You are invited to this Banter Room.\nYou can join this Banter Room by tapping on Join button.", messageType: "header", messageTime: mili, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: myJID!, isIncoming: "YES", chatType: roomtype , banterRoomName: Roomname, isJoined: "no", isAdmin: "no", supportedTeam:  self.supportedTeam , opponentTeam: opponentTeam)
                            if(isOpen == true){
                                DispatchQueue.main.async {
                                   /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
                                    //present(registerController as! UIViewController, animated: true, completion: nil)
                                    registerController.opponentTeam = self.opponentTeam
                                    registerController.supportedTeam = self.supportedTeam
                                    self.appDelegate().curRoomType = roomtype
                                    self.show(registerController, sender: self)*/
                                     self.showChatWindow(roomid: roomid, BanterClosed: isBanterClosed, roomtype: roomtype, roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
                                }
                            }
                        }
                    }
                        else  if(roomtype == "teambr"){
                                               
                                              isjoin = "no"
                                               Roomname = roomDetailsDict["roomname"] as! String
                                               self.supportedTeam = roomDetailsDict["supportteam"] as! Int64
                                               self.opponentTeam = roomDetailsDict["opponentteam"] as! Int64
                                              // let banterUsers: NSArray = roomDetailsDict["banterUser"] as! NSArray
                                               var isLeave: Bool = true
                                                isLeave = appDelegate().isCloseLeaveTeambr(mySupportedTeam: Int(supportedTeam))
                                                                          
                                               if(isLeave == false)
                                               {
                                                   var teamone = ""
                                                   var teamtwo = ""
                                                   let array1 = Teams_details.rows(filter:"team_Id = \(self.supportedTeam)") as! [Teams_details]
                                                   if(array1.count != 0) {
                                                       let disnarysound = array1[0]
                                                       teamone = disnarysound.team_name
                                                   }
                                                   let array2 = Teams_details.rows(filter:"team_Id = \(self.opponentTeam)") as! [Teams_details]
                                                   if(array2.count != 0) {
                                                       let disnarysound = array2[0]
                                                       teamtwo = disnarysound.team_name
                                                   }
                                                   let message = "Sorry, you can’t join this Banter Room as you don’t follow \(teamone) involved in this Banter Room.\n\nIn order to join this Banter Room please change your team by going to Settings->My Teams."
                                                   
                                                   alertWithButtonGOTOSeting(title: nil, message: message, ViewController: self)
                                                   // self.appDelegate().isBanterClosed = "closed"
                                               }
                                               else{
                                                   
                                                   let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                                   
                                                   let mili: Int64 = appDelegate().getUTCFormateDate()
                                                   appDelegate().prepareMessageForServerIn(roomid, messageContent: "You are invited to this Banter Room.\nYou can join this Banter Room by tapping on Join button.", messageType: "header", messageTime: mili, messageId: "", filePath: "", fileLocalId: "", caption: "", thumbLink: "", fromUser: myJID!, isIncoming: "YES", chatType: roomtype , banterRoomName: Roomname, isJoined: "no", isAdmin: "no", supportedTeam:  self.supportedTeam , opponentTeam: opponentTeam)
                                                   if(isLeave == true){
                                                       DispatchQueue.main.async {
                                                          /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                           let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
                                                           //present(registerController as! UIViewController, animated: true, completion: nil)
                                                           registerController.opponentTeam = self.opponentTeam
                                                           registerController.supportedTeam = self.supportedTeam
                                                           self.appDelegate().curRoomType = roomtype
                                                           self.show(registerController, sender: self)*/
                                                         self.showChatWindow(roomid: roomid, BanterClosed: isBanterClosed, roomtype: roomtype, roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
                                                       }
                                                   }
                                               }
                                           }
                    else{
                        /* self.appDelegate().toUserJID = roomid//(dict2.value(forKey: "toUserJID") as? String)!
                         self.appDelegate().isJoined = "yes"
                         self.appDelegate().toName = roomDetailsDict["roomname"] as! String
                         self.supportedTeam = roomDetailsDict["supportteam"] as! Int64
                         self.opponentTeam = roomDetailsDict["opponentteam"] as! Int64
                         let banterUsers: NSArray = roomDetailsDict["banterUser"] as! NSArray
                         
                         let mili: Int64 = self.appDelegate().getUTCFormateDate()
                         let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                         let uuid = UUID().uuidString
                         // self.appDelegate().sendMessageToServer(myJID as AnyObject as! String, messageContent: "Invitation to join Banter Room: " + self.appDelegate().toName , messageType: "header", messageTime: mili, messageId: uuid, roomType: "group", messageSubType: "invite", roomid: roomid , roomName: self.appDelegate().toName)
                         self.appDelegate().prepareMessageForServerIn(roomid, messageContent: "You are now ready to post messages, pictures, videos in this group.", messageType: "header", messageTime: mili, messageId: uuid, filePath: "", fileLocalId: "", caption: "", thumbLink: "", isIncoming: "YES", chatType: "group", recBanterNickName: self.appDelegate().toName, banterRoomName: self.appDelegate().toName, isJoined: "yes", isAdmin: "no", supportedTeam: 0, opponentTeam: 0, mySupportTeam : 0,fansCount:Int64(banterUsers.count))
                         /*  let arrReadUserJid = inviteArrUser.components(separatedBy: "@")
                         let userReadUserJid = arrReadUserJid[0]
                         
                         let username: String? = userReadUserJid
                         let uuid = UUID().uuidString
                         let time: Int64 = self.appDelegate().getUTCFormateDate()
                         self.appDelegate().sendMessageToServer(inviteArrUser as AnyObject as! String, messageContent: userUserJid! + " has added you in Group: "  + self.appDelegate().toName, messageType: "header", messageTime: time, messageId: uuid, roomType: "group", messageSubType: "invite", roomid: self.appDelegate().toUserJID , roomName: self.appDelegate().toName)
                         
                         
                         */
                         print(roomid)
                         DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                         let roomJID = XMPPJID(string: self.appDelegate().toUserJID)
                         let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                         
                         let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
                         
                         room.activate(self.appDelegate().xmppStream!)
                         
                         room.addDelegate(self, delegateQueue: DispatchQueue.main)
                         
                         //let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                         let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                         history.addAttribute(withName: "maxchars", stringValue: "0")
                         if(!room.isJoined){
                         room.join(usingNickname: myJID!, history: history)
                         }
                         }*/
                        /*  if appDelegate().connect(){
                         
                         }*/
                        // DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        /* let roomJID = XMPPJID(string: roomid)
                         let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                         
                         let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!)
                         
                         room.activate(self.appDelegate().xmppStream!)
                         
                         room.addDelegate(self, delegateQueue: DispatchQueue.main)
                         
                         
                         
                         
                         let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                         history.addAttribute(withName: "maxchars", stringValue: "0")
                         
                         // room.join(usingNickname: myJID!, history: history)
                         // if(!room.isJoined){
                         room.join(usingNickname: myJID!, history: history)
                         
                         
                         // }
                         // }
                         let arrReadUserJid = myJID?.components(separatedBy: "@")
                         let userReadUserJid = arrReadUserJid![0]
                         
                         let username: String? = userReadUserJid
                         var dictRequest = [String: AnyObject]()
                         dictRequest["cmd"] = "savebanterroom" as AnyObject
                         
                         do {
                         //Creating Request Data
                         var dictRequestData = [String: AnyObject]()
                         
                         // let myMobile: String? = UserDefaults.standard.string(forKey: "myMobileNo")
                         
                         dictRequestData["roomid"] = self.appDelegate().toUserJID as AnyObject
                         dictRequestData["supportteam"] = 0 as AnyObject
                         
                         dictRequestData["username"] = username as AnyObject
                         dictRequestData["status"] = "active" as AnyObject
                         
                         dictRequest["requestData"] = dictRequestData as AnyObject
                         //dictRequest.setValue(dictMobiles, forKey: "requestData")
                         //print(dictRequest)
                         
                         let dataSaveBanter = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                         let strSaveBanter = NSString(data: dataSaveBanter, encoding: String.Encoding.utf8.rawValue)! as String
                         //print(strSaveBanter)
                         self.appDelegate().sendRequestToAPI(strRequestDict: strSaveBanter)
                         } catch {
                         print(error.localizedDescription)
                         }
                         let messageId = UUID().uuidString
                         let time2: Int64 = self.appDelegate().getUTCFormateDate()
                         // self.appDelegate().sendMessageToServer(roomid as AnyObject as! String, messageContent: username! + " joined via Link.", messageType: "header", messageTime: time2, messageId: messageId, roomType: "group", messageSubType: "roomuseradd", mySupportTeam: 0, JoindUserName: myJID!)
                         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                         let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
                         //present(registerController as! UIViewController, animated: true, completion: nil)
                         registerController.opponentTeam = self.opponentTeam
                         registerController.supportedTeam = self.supportedTeam
                         self.appDelegate().curRoomType = roomtype
                         self.show(registerController, sender: self)*/
                        let alert = UIAlertController(title: "", message: "Do you want to Join \"\(roomDetailsDict["roomname"] as! String)\" Group?", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                            
                            let isOpen: Bool = true
                            /*let closed = roomDetailsDict["banterStatus"] as! String
                             
                             if((closed as! String) == "closed")
                             {
                             isOpen = false
                             // self.appDelegate().isBanterClosed = closed as! String
                             }
                             else
                             {
                             self.appDelegate().isBanterClosed = "active"
                             }
                             */
                            
                            if(isOpen == true){
                               // self.appDelegate().toUserJID = roomid//(dict2.value(forKey: "toUserJID") as? String)!
                                 
                                 // var Roomname: String = "yes"
                                  Roomname = roomDetailsDict["roomname"] as! String
                                self.supportedTeam = roomDetailsDict["supportteam"] as! Int64
                                self.opponentTeam = roomDetailsDict["opponentteam"] as! Int64
                                let userCount: Int64 = roomDetailsDict["userCount"] as! Int64
                                let roomavatar: String = roomDetailsDict["avatar"] as! String
                                
                                let mili: Int64 = self.appDelegate().getUTCFormateDate()
                                let myJID: String? = UserDefaults.standard.string(forKey: "userJID")
                                let uuid = UUID().uuidString
                                // self.appDelegate().sendMessageToServer(myJID as AnyObject as! String, messageContent: "Invitation to join Banter Room: " + self.appDelegate().toName , messageType: "header", messageTime: mili, messageId: uuid, roomType: "group", messageSubType: "invite", roomid: roomid , roomName: self.appDelegate().toName)
                                self.appDelegate().prepareMessageForServerIn(roomid, messageContent: "You are now ready to post messages, pictures, videos in this group.", messageType: "header", messageTime: mili, messageId: uuid, filePath: "", fileLocalId: "", caption: "", thumbLink: "", isIncoming: "YES", chatType: "group", recBanterNickName: Roomname, banterRoomName: Roomname, isJoined: "yes", isAdmin: "no", supportedTeam: 0, opponentTeam: 0, mySupportTeam : 0,fansCount:userCount,roomavatar:roomavatar)
                                self.appDelegate().joinRoomOnly(with: roomid, delegate: self.appDelegate())
                                self.appDelegate().isFromBanterDeepLink = true
                                /*  let arrReadUserJid = inviteArrUser.components(separatedBy: "@")
                                 let userReadUserJid = arrReadUserJid[0]
                                 
                                 let username: String? = userReadUserJid
                                 let uuid = UUID().uuidString
                                 let time: Int64 = self.appDelegate().getUTCFormateDate()
                                 self.appDelegate().sendMessageToServer(inviteArrUser as AnyObject as! String, messageContent: userUserJid! + " has added you in Group: "  + self.appDelegate().toName, messageType: "header", messageTime: time, messageId: uuid, roomType: "group", messageSubType: "invite", roomid: self.appDelegate().toUserJID , roomName: self.appDelegate().toName)
                                 
                                 
                                 */
                                
                                
                                // DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                /*   let roomJID = XMPPJID(string: roomid)
                                 let roomStorage = XMPPRoomCoreDataStorage.sharedInstance()
                                 
                                 let room = XMPPRoom(roomStorage: roomStorage!, jid: roomJID!)
                                 
                                 room.activate(self.appDelegate().xmppStream!)
                                 
                                 room.addDelegate(self, delegateQueue: DispatchQueue.main)
                                 
                                 
                                 
                                 
                                 let history: XMLElement = XMLElement.element(withName: "history") as! XMLElement
                                 history.addAttribute(withName: "maxchars", stringValue: "0")
                                 
                                 // room.join(usingNickname: myJID!, history: history)
                                 // if(!room.isJoined){
                                 room.join(usingNickname: myJID!, history: history)
                                 
                                 
                                 // }
                                 // }*/
                                self.appDelegate().savebanterroom(supportteam: 0, roomtype: "group", roomid: roomid)
                               /* let arrReadUserJid = myJID?.components(separatedBy: "@")
                                let userReadUserJid = arrReadUserJid![0]
                                
                                let username: String? = userReadUserJid
                                var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "savebanterroom" as AnyObject
                                
                                do {
                                    //Creating Request Data
                                    var dictRequestData = [String: AnyObject]()
                                    
                                    // let myMobile: String? = UserDefaults.standard.string(forKey: "myMobileNo")
                                    
                                    dictRequestData["roomid"] = self.appDelegate().toUserJID as AnyObject
                                    dictRequestData["supportteam"] = 0 as AnyObject
                                    
                                    dictRequestData["username"] = username as AnyObject
                                    dictRequestData["status"] = "active" as AnyObject
                                    
                                    dictRequest["requestData"] = dictRequestData as AnyObject
                                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                    //print(dictRequest)
                                    
                                    let dataSaveBanter = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                    let strSaveBanter = NSString(data: dataSaveBanter, encoding: String.Encoding.utf8.rawValue)! as String
                                    //print(strSaveBanter)
                                    self.appDelegate().sendRequestToAPI(strRequestDict: strSaveBanter)
                                } catch {
                                    print(error.localizedDescription)
                                }*/
                               
                               // let _: Int64 = self.appDelegate().getUTCFormateDate()
                                // self.appDelegate().sendMessageToServer(roomid as AnyObject as! String, messageContent: username! + " joined via Link.", messageType: "header", messageTime: time2, messageId: messageId, roomType: "group", messageSubType: "roomuseradd", mySupportTeam: 0, JoindUserName: myJID!)
                                DispatchQueue.main.async {
                                     self.showChatWindow(roomid: roomid, BanterClosed: isBanterClosed, roomtype: "group", roomname: Roomname, join: isjoin, mySupportedTeam: mySupportedTeam)
                                   /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
                                    //present(registerController as! UIViewController, animated: true, completion: nil)
                                    registerController.opponentTeam = self.opponentTeam
                                                  registerController.supportedTeam = self.supportedTeam
                                                  // registerController.BanterClosed = BanterClosed
                                                   registerController.RoomType = roomtype
                                                 // registerController.Roomname = roomname
                                                  registerController.isjoin = "yes"
                                                   registerController.mySupportedTeam = 0
                                                  registerController.Roomid = roomid
                                    
                                    self.show(registerController, sender: self)*/
                                }
                            }
                            else{
                                
                            }
                        });
                        alert.addAction(action)
                        let action1 = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                            
                        });
                        alert.addAction(action1)
                        self.present(alert, animated: true, completion:nil)
                        
                    }
                    
                }
                else{
                    let roomtype = roomDetailsDict["roomtype"] as! String
                    if(roomtype == "banter"){
                        let message = "Sorry, you can’t join this Banter room.\n\nThis Banter room is closed by its Manager."
                        
                        alertWithTitle1(title: nil, message: message, ViewController: self)
                    }
                    else{
                        let message = "Sorry, you can’t join this Group.\n\nThis Group is closed by its Manager."
                        
                        alertWithTitle1(title: nil, message: message, ViewController: self)
                    }
                }
            }
            LoadingIndicatorView.hide()
        }
        else if(Status == "product")
        {
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 2
                LoadingIndicatorView.hide()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let settingsController : MerchantDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MerchantDetail") as! MerchantDetailViewController
                let dic = notification.userInfo?["response"] as! NSDictionary
                settingsController.dic = dic
                settingsController.maintitel = dic.value(forKey: "productName") as! String
                self.show(settingsController, sender: self)
                
            }
        }
        else if(Status == "trivia")
        {
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 0
                 let dic = notification.userInfo?["response"] as! NSDictionary
                let status: String = dic.value(forKey: "Status") as! String
                if(status == "Completed" || status == "Finished"){
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let settingsController : OldTriviaDetailViewController = storyBoard.instantiateViewController(withIdentifier: "OldTriviaDetail") as! OldTriviaDetailViewController
                   
                    settingsController.oldtriviadetail = dic
                    //settingsController.maintitel = dic.value(forKey: "productName") as! String
                    self.show(settingsController, sender: self)
                }
                else{
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let settingsController : UpcomingTriviaDetailViewController = storyBoard.instantiateViewController(withIdentifier: "UpcomingTriviaDetail") as! UpcomingTriviaDetailViewController
                    
                    settingsController.upcomingtriviadetail = dic
                    //settingsController.maintitel = dic.value(forKey: "productName") as! String
                    self.show(settingsController, sender: self)
                }
              //  LoadingIndicatorView.hide()
                
               
                
            }
        }
        else if(Status == "profileinvite"){
            let id = notification.userInfo?["jid"] as! String

            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                        let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                                                        myTeamsController.RoomJid = id + JIDPostfix
                                       show(myTeamsController, sender: self)
        }
        else if(Status == "homefixed")
                  {DispatchQueue.main.async {
                      self.tabBarController?.selectedIndex = 0
                     let dict = notification.userInfo?["response"] as! NSDictionary
                    let type = dict.value(forKey: "type")as! String
                                         
                                         
                                         var thumbLink: String = ""
                                         
                                         if(type == "image"){
                                         let thumbLink = dict.value(forKey: "url")as! String
                                            var media = [AnyObject]()
                                                                   media.append(LightboxImage(
                                                                   imageURL: NSURL(string: thumbLink)! as URL,
                                                                       text: ""
                                                                   ))
                                                                   if(media.count>0)
                                                                   {
                                                                    self.appDelegate().isFromPreview = true
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
                                         else if(type == "video"){
                                             thumbLink = dict.value(forKey: "thumb")as! String
                                          let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                 let previewController : Previewmidia! = storyBoard.instantiateViewController(withIdentifier: "Previewmidia") as? Previewmidia
                                           previewController.videoURL = dict.value(forKey: "url") as! String
                                          previewController.mediaType = "video"
                                            self.show(previewController!, sender: self)
                                                                // self.present(previewController, animated: true, completion: nil)
                                         }
                                      else if(type == "live"){
                                            thumbLink = dict.value(forKey: "thumb")as! String
                                       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                              let previewController : LiveStrimingViewController! = storyBoard.instantiateViewController(withIdentifier: "LiveStriming") as? LiveStrimingViewController
                                            previewController.videoURL = dict.value(forKey: "url") as! String
                                      // previewController.mediaType = "video"
                                                self.show(previewController!, sender: self)
                                                              //self.present(previewController, animated: true, completion: nil)
                                      }
                       //LoadingIndicatorView.hide()
                      /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                      let registerController : MediaDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "mediadetail") as? MediaDetailViewController
                      //present(registerController as! UIViewController, animated: true, completion: nil)
                      registerController.fanupdatedetail = notification.userInfo?["response"] as! [AnyObject]
                      registerController.fromBanter = true
                      self.show(registerController, sender: self)*/
                      }
                  }
    }
    @objc func refreshTabindexsNotification()
    {
        self.tabBarController?.selectedIndex = 0
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : TotalFCViewController! = storyBoard.instantiateViewController(withIdentifier: "totalfc") as? TotalFCViewController
        appDelegate().isTotalFCRefresh = true
        show(registerController, sender: self)
    }
    @objc func showMyprofile(notification: NSNotification)
    {
        appDelegate().countryCodeSelected = ""
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : ProfileViewController = storyBoard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        myTeamsController.isFromSettings = false
        //show(myTeamsController, sender: self)
        self.present(myTeamsController, animated: true, completion: nil)
    }
    @objc func learnMore()
    {
        UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
        UserDefaults.standard.synchronize()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewcontroller = storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewcontroller
        show(myTeamsController, sender: self)
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            if(self.refreshTable.isRefreshing)
            {
             self.refreshTable.endRefreshing()
            }
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
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
    @objc func showSettings() {
        //print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    @objc func showForNewupdateWithNotify(notification: NSNotification)
    {
        /* if let fetchedCaption = notification.userInfo?["caption"] as? Int64
         {
         let alert = UIAlertController(title: "New App Update", message: "Do you want to update Football Fan app to a newer version?", preferredStyle: .alert)
         let action = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel,handler: {_ in
         UserDefaults.standard.setValue(fetchedCaption, forKey: "cancelversion")
         
         UserDefaults.standard.synchronize()
         });
         let action1 = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: {_ in
         UIApplication.shared.openURL(NSURL(string : "https://itunes.apple.com/us/app/football-fan/id1335286217?ls=1&mt=8")! as URL)
         UserDefaults.standard.setValue(fetchedCaption, forKey: "cancelversion")
         
         UserDefaults.standard.synchronize()
         });
         alert.addAction(action)
         alert.addAction(action1)
         self.present(alert, animated: true, completion:nil)
         }*/
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            HomeViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return HomeViewController.realDelegate!;
    }
    /* @objc func settriviadetails()  {
          if(arrtrivia.count > 0){
            let dict: NSDictionary? = arrtrivia[curentTriviaindex] as? NSDictionary
            if(dict != nil)
            {
                
                
                DispatchQueue.main.async {
                    //let mili = dict?.value(forKey: "StartTime")
                    if let mili1 = dict?.value(forKey: "StartTime")
                    {
                        
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        //let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        // cell.setupTimer(with: mili)
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        let dateFormatter = DateFormatter()
                        let timeNow = Date()
                        var timeEnd : Date?
                        
                        timeEnd = myMilliseconds.dateFull as Date
                        if timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
                            
                            let interval = timeEnd?.timeIntervalSince(timeNow)
                            
                            let days =  (interval! / (60*60*24)).rounded(.down)
                            
                            let daysRemainder = interval?.truncatingRemainder(dividingBy: 60*60*24)
                            
                            let hours = (daysRemainder! / (60 * 60)).rounded(.down)
                            
                            let hoursRemainder = daysRemainder?.truncatingRemainder(dividingBy: 60 * 60).rounded(.down)
                            
                            let minites  = (hoursRemainder! / 60).rounded(.down)
                            
                            let minitesRemainder = hoursRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
                            
                            let scondes = minitesRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
                            // print(days)
                            // print(hours)
                            // print(minites)
                            //print(scondes)
                            // header?.DaysProgress.setProgress(days/360, animated: false)
                            // header?.hoursProgress.setProgress(hours/24, animated: false)
                            //header?.minitesProgress.setProgress(minites/60, animated: false)
                            // header?.secondesProgress.setProgress(scondes!/60, animated: false)
                            
                            if(days == 0){
                                self.triviaTime?.text = "\(Int(hours)) HOURS \(Int(minites)) MIN. \(Int(scondes as! Double)) SEC. TO PLAY"
                            }
                            else{
                                self.triviaTime?.text = "\(Int(days)) MORE DAYS TO PLAY"
                            }
                            // header?.valueDay.text = formatter.string(from: NSNumber(value:days))
                            // header?.valueHour.text = formatter.string(from: NSNumber(value:hours))
                            // header?.valueMinites.text = formatter.string(from: NSNumber(value:minites))
                            //header?.valueSeconds.text = formatter.string(from: NSNumber(value:scondes!))
                            
                            if(days == 0.0 && hours == 0.0 && minites == 0.0 && scondes == 0.0){
                                let tabIndex:[String: Any] = ["index": self.curentTriviaindex]
                                let notificationName = Notification.Name("trivialiveonhome")
                                NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
                            }
                            
                        } else {
                            // header?.fadeOut()
                            self.triviaTime?.text = "LIVE NOW"
                        }
                    }
                    
                    
                    
                    let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (self.triviaTime?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
                    label.font = UIFont.boldSystemFont(ofSize: 11.0)
                    label.text = self.triviaTime?.text
                    label.textAlignment = .left
                    //label.textColor = self.strokeColor
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 2
                    label.sizeToFit()
                    
                    
                    self.timerConstraint2.constant = label.frame.height
                    
                    
                }
                
                
                
            }
        }
          else{
            couponTimer?.invalidate()
        }
       
    }*/
    @objc func reset(notification: NSNotification)
    {
        DispatchQueue.main.async {
            self.Fixedsection?.isHidden = true
            self.Slider1?.isHidden = true
                                              self.Slider2?.isHidden = true
                                              self.Slider3?.isHidden = true
            self.setSliderSetting()
        }
    }
    @objc func tirivialive(notification: NSNotification)
    {
        DispatchQueue.main.async {
            let lastindex = (notification.userInfo?["index"] )as! Int
            var dict1: [String: AnyObject] = self.appDelegate().arrhometrivia[lastindex] as! [String: AnyObject]
            dict1["Status"] = "Live" as AnyObject
            
            self.appDelegate().arrhometrivia[lastindex] = dict1 as AnyObject
            
            self.setTriviaSlider()
        }
    }
    @objc func OpenstoryAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
         if ClassReachability.isConnectedToNetwork() {
        let dict: NSDictionary? = appDelegate().arrhomefanupdate[longPressGestureRecognizer.view?.tag ?? 0] as? NSDictionary
        var arr:[AnyObject] = []
        arr.append(dict as AnyObject)
        
        //arr[0] = dict!
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : FanUpdateDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "fanupdatedetail") as? FanUpdateDetailViewController
        //present(registerController as! UIViewController, animated: true, completion: nil)
        registerController.fanupdatedetail = arr
        registerController.fromBanter = true
        self.show(registerController, sender: self)
        }
               else {
                   alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                   
               }
    }
    @objc func OpenmediaAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
         if ClassReachability.isConnectedToNetwork() {
        let dict: NSDictionary? = appDelegate().arrhomemedia[longPressGestureRecognizer.view?.tag ?? 0] as? NSDictionary
        var arr:[AnyObject] = []
        arr.append(dict as AnyObject)
        
        //arr[0] = dict!
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : MediaDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "mediadetail") as? MediaDetailViewController
        //present(registerController as! UIViewController, animated: true, completion: nil)
        registerController.fanupdatedetail = arr
        registerController.fromBanter = true
        self.show(registerController, sender: self)
        }
               else {
                   alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                   
               }
    }
    @objc func OpenFixedAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        if ClassReachability.isConnectedToNetwork() {
        let dict: NSDictionary? = appDelegate().arrhomeFixedsection[longPressGestureRecognizer.view?.tag ?? 0] as? NSDictionary
        
                   if(dict != nil)
                   {
                       
                       
                       //let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                       // let decodedString = String(data: decodedData, encoding: .utf8)!
                       
                       
                       // cell.newsTitle?.text = decodedString
                       let type = dict?.value(forKey: "type")as! String
                       
                       
                       var thumbLink: String = ""
                       
                       if(type == "image"){
                       let thumbLink = dict?.value(forKey: "url")as! String
                          var media = [AnyObject]()
                                                 media.append(LightboxImage(
                                                 imageURL: NSURL(string: thumbLink)! as URL,
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
                       else if(type == "video"){
                         /*  thumbLink = dict?.value(forKey: "thumb")as! String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                               let previewController : Previewmidia! = storyBoard.instantiateViewController(withIdentifier: "Previewmidia") as? Previewmidia
                         previewController.videoURL = dict?.value(forKey: "url")as! String
                        previewController.mediaType = "video"
                                               show(previewController!, sender: self)*/
                        let videopath = dict?.value(forKey: "url")as! String
                        
                         let urlvalue = URL(string:videopath)
                        let yourplayer = AVPlayer(url: urlvalue!)

                        //Create player controller and set it’s player
                        //let playerController = LandscapePlayer()
                        let playerController = AVPlayerViewController()
                        playerController.player = yourplayer
                       
                        //Final step To present controller  with player in your view controller
                        present(playerController, animated: true, completion: {
                           playerController.player!.play()
                        })
                                              // self.present(previewController, animated: true, completion: nil)
                    /*    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                               let previewController : MediaPreviewController! = storyBoard.instantiateViewController(withIdentifier: "MediaPreview") as? MediaPreviewController
                                               
                                               
                                               previewController.videoPath = dict?.value(forKey: "url")as! String
                                                   
                                               
                                               previewController.isLocalMedia = false
                                               previewController.mediaType = "video"
                                               show(previewController!, sender: self)*/
                       }
                    else if(type == "live"){
                        thumbLink = dict?.value(forKey: "thumb")as! String
                     let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                            let previewController : LiveStrimingViewController! = storyBoard.instantiateViewController(withIdentifier: "LiveStriming") as? LiveStrimingViewController
                      previewController.videoURL = dict?.value(forKey: "url") as! String
                    // previewController.mediaType = "video"
                                            show(previewController!, sender: self)
                                            //self.present(previewController, animated: true, completion: nil)
                    }
                    Getlatestsliderdata()
        }
        //arr[0] = dict!
      /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : FanUpdateDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "fanupdatedetail") as? FanUpdateDetailViewController
        //present(registerController as! UIViewController, animated: true, completion: nil)
        registerController.fanupdatedetail = arr
        registerController.fromBanter = true
        self.show(registerController, sender: self)*/
        }
        else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    @objc func OpennewsAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        if ClassReachability.isConnectedToNetwork() {
            let dict: NSDictionary? = appDelegate().arrhomenews[longPressGestureRecognizer.view?.tag ?? 0] as? NSDictionary
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : NewsDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "newsdetail") as? NewsDetailViewController
        //present(registerController as! UIViewController, animated: true, completion: nil)
        registerController.newsdetail = dict!
        registerController.fromBanter = true
        self.show(registerController, sender: self)
        }
        else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    @objc func OpenTriviaAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
       if ClassReachability.isConnectedToNetwork() {
          DispatchQueue.main.async {
            self.selectedindex =   longPressGestureRecognizer.view?.tag ?? 0
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
                if ClassReachability.isConnectedToNetwork() {
                    let dict: NSDictionary? = self.appDelegate().arrhometrivia[self.selectedindex] as? NSDictionary
                    let status = dict?.value(forKey: "Status") as! String
                    if(status == "Finished"){
                        
                    }
                    else if(status == "Live"){
                        let mili1 = dict?.value(forKey: "EndTime")
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        let timeNow = Date()
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        let timeEnd:Date  = myMilliseconds.dateFull as Date
                        if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                            
                        self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                        self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                        myTeamsController.triviadetail = dict!
                           // self.appDelegate().returnHomeToOtherView = true
                        self.show(myTeamsController, sender: self)
                        }
                        else{
                            self.Getsliderdata()
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
                    if(status == "Completed"){
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                         let registerController : PotratepreviewMediaViewController! = storyBoard.instantiateViewController(withIdentifier: "PotratePreviewmidia") as? PotratepreviewMediaViewController
                        //self.appDelegate().returnHomeToOtherView = true
                         registerController.videoURL = dict?.value(forKey: "VideoLink") as? String
                         registerController.mediaType = "video"
                        self.present(registerController, animated: true, completion: nil)
                    }
                    else if(status == "Published"){
                        let Purchased = dict?.value(forKey: "Purchased") as! Bool
                        if(Purchased){
                            //cell.triviastatus?.text = "Already Booked"
                        }
                        else{
                            let FreeTrivia = dict?.value(forKey: "FreeTrivia") as! Bool
                            if(FreeTrivia){
                                //self.Buynow()
                                 self.freetriviaAlert = FreeTriviaPurchaseAlert.instantiate()
                                                                         guard let customAlertVC = self.freetriviaAlert else { return }
                                                                         
                                                          
                                                                                      // customAlertVC.upcomingtriviadetail = dict!
                                                               customAlertVC.onpageview = "home"
                                                                                             let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 450)
                                                                                                    // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                                    popupVC.cornerRadius = 20
                                                                                                    self.present(popupVC, animated: true, completion: nil)
                            }
                            else{
                                let ticketprize = dict?.value(forKey: "TicketPrice") as! Double
                                let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                if(avilablecoin > ticketprize){
                                   // self.Buynow()
                                    self.ConfermationAlert = TriviaPurchaseAlert.instantiate()
                                                                                                                                       guard let customAlertVC = self.ConfermationAlert else { return }
                                                                                                                                       
                                                                                                                         // customAlertVC.upcomingtriviadetail = dict!
                                                                customAlertVC.onpageview = "home"
                                                                                                  
                                    customAlertVC.triviaprice = ticketprize;                                                                     let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 467)
                                                                                                                                       // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                                                                       popupVC.cornerRadius = 20
                                                                                                                                       self.present(popupVC, animated: true, completion: nil)
                                }else{
                                    self.TermsAlert = FancoinAlertViewController.instantiate()
                                                                                                            guard let customAlertVC = self.TermsAlert else { return }
                                                                                                            
                                                                                                            //customAlertVC.upcomingtriviadetail = dict!
                                                                                                             customAlertVC.onpageview = "upcomming"
                                                                                                                                               customAlertVC.triviaTypeString = "buyfc"
                                                                                                            let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 417)
                                                                                                            // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                                            popupVC.cornerRadius = 20
                                                                                                            self.present(popupVC, animated: true, completion: nil)
                                                                        
                                   /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                    self.returnToOtherView = true
                                    self.show(registerController, sender: self)*/
                                    
                                    //InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
                                }
                            }
                            
                        }
                        
                    }
                } else {
                    self.alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                    
                }
            }else{
                let dict: NSDictionary? = self.appDelegate().arrhometrivia[self.selectedindex] as? NSDictionary
                let status = dict?.value(forKey: "Status") as! String
                if(status == "Live"){
                    if ClassReachability.isConnectedToNetwork() {
                        let mili1 = dict?.value(forKey: "EndTime")
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        let timeNow = Date()
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        let timeEnd:Date  = myMilliseconds.dateFull as Date
                        if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                            
                        self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                        self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                        myTeamsController.triviadetail = dict!
                            //self.appDelegate().returnHomeToOtherView = true
                        self.show(myTeamsController, sender: self)
                        }else{
                            self.Getsliderdata()
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
                        self.alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                        
                    }
                    
                    
                }
                    else if(status == "Finished"){
                                           
                                       }
                else   if(status == "Completed"){
                                      let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                       let registerController : PotratepreviewMediaViewController! = storyBoard.instantiateViewController(withIdentifier: "PotratePreviewmidia") as? PotratepreviewMediaViewController
                   // self.appDelegate().returnHomeToOtherView = true
                                       registerController.videoURL = dict?.value(forKey: "VideoLink") as? String
                                       registerController.mediaType = "video"
                                      self.present(registerController, animated: true, completion: nil)
                                  }
                else {
                    self.appDelegate().LoginwithModelPopUp()
                }
            }
        
    }
        }
        else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
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
                    let dict: NSDictionary? = self.arrtrivia[self.selectedindex] as? NSDictionary
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
                                let timeEnd:Date  = myMilliseconds.dateFull as Date
                                if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                                    
                                self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                                self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                                myTeamsController.triviadetail = dict!
                                self.returnToOtherView = true
                                self.show(myTeamsController, sender: self)
                                }
                                else{
                                    self.Getsliderdata()
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
                            let timeEnd:Date  = myMilliseconds.dateFull as Date
                            if timeEnd.compare(timeNow) == ComparisonResult.orderedDescending {
                                
                            self.appDelegate().toUserJID = dict?.value(forKey: "GroupID") as! String
                            self.appDelegate().toName = dict?.value(forKey: "Title") as! String
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                            myTeamsController.triviadetail = dict!
                            self.returnToOtherView = true
                            self.show(myTeamsController, sender: self)
                            }else{
                                self.Getsliderdata()
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
    }*/
    @objc func Buynow()  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "buyticket" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            
           // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
                let dict: NSDictionary? = appDelegate().arrhometrivia[selectedindex] as? NSDictionary
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
                                                                              let myProfileDict: NSDictionary = response[0] as! NSDictionary
                                                                              let totalcoins = myProfileDict.value(forKey: "totalcoins") as! Int
                                                                              
                                                                              let availablecoins = myProfileDict.value(forKey: "availablecoins") as! Int
                                                                              //print(response)
                                                                              self.appDelegate().AddCoin(fctotalcoin: totalcoins, fcavailablecoin: availablecoins)
                                                                              var dict1: [String: AnyObject] = self.appDelegate().arrhometrivia[self.selectedindex] as! [String: AnyObject]
                                                                              dict1["Purchased"] = true as AnyObject
                                                                              
                                                                              self.appDelegate().arrhometrivia[self.selectedindex] = dict1 as AnyObject
                                                                              
                                                                              self.setTriviaSlider()
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
                                                                                                                   customAlertVC.mediaurl = "thumbs_up"
                                                                                                                 customAlertVC.ActionTitle = "Ok"
                                                                                                                 // customAlertVC.actioncommand = action
                                                                                                                 //customAlertVC.actionlink = link
                                                                                                                 //customAlertVC.LinkTitle = linktitle
                                                                                                                 
                                                                                                                 let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                                                                                                                 // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                                                 popupVC.cornerRadius = 20
                                                                                                                 self.present(popupVC, animated: true, completion: nil)
                                                                              // self.gettrivia(0)
                                                                              if(self.appDelegate().arrupcommingTrivia.count>0){
                                                                                                                     for i in 0...self.appDelegate().arrupcommingTrivia.count-1 {
                                                                                                                         let dict: NSDictionary? = self.appDelegate().arrupcommingTrivia[i] as? NSDictionary
                                                                                                                                if(dict != nil)
                                                                                                                                {
                                                                                                                                 let GroupID = dict?.value(forKey: "GroupID") as! String
                                                                                                                                 if(roomjid == GroupID){
                                                                                                                                     var dict1: [String: AnyObject] = self.appDelegate().arrupcommingTrivia[i] as! [String: AnyObject]
                                                                                                                                                dict1["Purchased"] = true as AnyObject
                                                                                                                                                
                                                                                                                                     self.appDelegate().arrupcommingTrivia[i] = dict1 as AnyObject
                                                                                                            let notificationName = Notification.Name("reloadtable")
                                                                                                                                                                                                                                           NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                  
                                                                                                                                     
                                                                                                                                     break
                                                                                                                                                
                                                                                                                                 }
                                                                                                                         }
                                                                                                                     }
                                                                                                                 }
                                                                              //TransperentLoadingIndicatorView.hide()
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                          
                                                                                         
                                                                                          let soldout = json["soldout"] as! Bool
                                                                                          let error = json["error"]  as! String
                                                                                          if(soldout){
                                                                                              
                                                                                              var dict1: [String: AnyObject] = self.appDelegate().arrhometrivia[self.selectedindex] as! [String: AnyObject]
                                                                                              dict1["soldout"] = true as AnyObject
                                                                                              
                                                                                              self.appDelegate().arrhometrivia[self.selectedindex] = dict1 as AnyObject
                                                                                                                                 
                                                                                             self.setTriviaSlider()
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
/*    // Below Mehtod will print error if not able to update location.
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
    }
    */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        if(scrollView == self.FixedscrollView){
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.FixedpageControl.currentPage = Int(currentPage);
           // curentTriviaindex = Int(currentPage);
           // settriviadetails()
        }
        else if(scrollView == self.scrollView1){
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.pageControl1.currentPage = Int(currentPage);
            curentTriviaindex = Int(currentPage);
           // settriviadetails()
        }
        else if(scrollView == self.scrollView2){
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.pageControl2.currentPage = Int(currentPage);
        }
        else if(scrollView == self.scrollView3){
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.pageControl3.currentPage = Int(currentPage);
        }
            else if(scrollView == self.mediascrollView){
                       let pageWidth:CGFloat = scrollView.frame.width
                       let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
                       // Change the indicator
                       self.MediapageControl.currentPage = Int(currentPage);
                   }
        else{
            print(scrollView.contentOffset.y)
        }
    }
     @IBAction func latestAction(){
        self.butlatestview.isHidden = true
                 self.appDelegate().APIhometime = self.appDelegate().getUTCFormateDate()
                appDelegate().arrhomenews = self.temphomenews
               appDelegate().arrhomefanupdate = self.temphomefanupdate
        
        //Ravi Media
        appDelegate().arrhomemedia = self.temphomemedia
        //Ravi Media
               appDelegate().arrhometrivia = self.temphometrivia
               appDelegate().triviamoreOption = self.temptriviamoreOption
                appDelegate().arrhomeFixedsection = self.temphomeFixedsection
                setSliderSetting()
     }
    
    func showChatWindow(roomid: String,BanterClosed : String,roomtype : String, roomname : String, join : String,mySupportedTeam : Int64) {
          // self.dismiss(animated: true, completion: nil)
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : ChatViewController! = storyBoard.instantiateViewController(withIdentifier: "Chat") as? ChatViewController
           //present(registerController as! UIViewController, animated: true, completion: nil)
          // self.appDelegate().curRoomType = "chat"
          // appDelegate().isBanterClosed = ""
        registerController.opponentTeam = opponentTeam
               registerController.supportedTeam = supportedTeam
                registerController.BanterClosed = BanterClosed
                registerController.RoomType = roomtype
               registerController.Roomname = roomname
               registerController.isjoin = join
                registerController.mySupportedTeam = mySupportedTeam
               registerController.Roomid = roomid
           show(registerController as! UIViewController, sender: self)
           //let notificationName = Notification.Name("showWindowFromNotification")
           //NotificationCenter.default.post(name: notificationName, object: nil)
       }
    func setView(view: UIView) {
        UIView.transition(with: view, duration: 1.0, options: .transitionFlipFromTop, animations: {
        })
    }
    
   
}
