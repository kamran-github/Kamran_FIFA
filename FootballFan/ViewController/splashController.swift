//
//  splashController.swift
//  FootballFan
//
//  Created by Apple on 22/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
//import FirebaseAnalytics
class splashController: UIViewController {
     var totelteams = ""
    override func viewDidLoad() {
           super.viewDidLoad()
      // DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
       
        self.getbackgroundapi()
       // }
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
       // alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func getbackgroundapi() {
           if ClassReachability.isConnectedToNetwork() {
               var dictRequest = [String: AnyObject]()
               dictRequest["cmd"] = "getbackgroundapi" as AnyObject
               dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
               dictRequest["device"] = "ios" as AnyObject
               
             // LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading")
               
               do {
                   
                   totelteams = ""
                            appDelegate().arrDataTeams =  appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
                if(appDelegate().arrDataTeams.count == 0){
                    totelteams = "all"
                    
                }else{
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
                                               }
                }
                           
                   
                   var reqParams = [String: AnyObject]()
                   //reqParams["cmd"] = "getfanupdates" as AnyObject teams
                reqParams["teams"] = totelteams as AnyObject
                  reqParams["lastindex"] = 0 as AnyObject?
                reqParams["version"] = 1 as AnyObject
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
                                                                                                         let status1: Bool = json["success"] as! Bool
                                                                                                      
                                                                                                          Clslogging.loginfo(State: "getbackgroundapi", userinfo: json as [String : AnyObject])
                                                                                                     
                                                                                                      
                                                                                                      if(status1){DispatchQueue.main.async {
                                                                                                           let response: NSDictionary = json["responseData"]  as! NSDictionary
                                                                                                          self.appDelegate().arrupcommingTrivia = response.value(forKey: "gettrivia") as! [AnyObject]
                                                                                                          let arrgetnews = response.value(forKey: "getnews") as! NSArray
                                                                                                          let dicgetnews: NSDictionary = arrgetnews[0] as! NSDictionary
                                                                                                          self.appDelegate().BrakingNews = dicgetnews.value(forKey: "breakingnews") as! [AnyObject]
                                                                                                          self.appDelegate().arrNews = dicgetnews.value(forKey: "news") as! [AnyObject]
                                                                                                          self.appDelegate().arrFanUpdatesTeams = response.value(forKey: "getfanupdate") as! [AnyObject]
                                                                                                          let dicgethome: NSDictionary = response.value(forKey: "gethome")  as! NSDictionary
                                                                                                          self.appDelegate().arrhometrivia = dicgethome.value(forKey: "trivia") as! [AnyObject]
                                                                                                          self.appDelegate().arrhomenews = dicgethome.value(forKey: "news") as! NSArray
                                                                                                          self.appDelegate().arrhomefanupdate = dicgethome.value(forKey: "fanupdate") as! [AnyObject]
                                                                                                          self.appDelegate().triviamoreOption = dicgethome.value(forKey: "OldTrivia") as! Bool
                                                                                                          self.appDelegate().arrhomeFixedsection = dicgethome.value(forKey: "homefixed") as! NSArray
                                                                                                          self.appDelegate().arrpasttrivia = response.value(forKey: "getoldtrivia") as! [AnyObject]
                                                                                                          //Ravi Media
                                                                                                          self.appDelegate().arrhomemedia = dicgethome.value(forKey: "media") as! [AnyObject]
                                                                                                          //Ravi Media
                                                                                                          self.appDelegate().APIhometime = self.appDelegate().getUTCFormateDate()
                                                                                                          self.appDelegate().APIgetfanupdatestime = self.appDelegate().getUTCFormateDate()
                                                                                                          self.appDelegate().APIgetnewstime = self.appDelegate().getUTCFormateDate()
                                                                                                          self.appDelegate().returnHomeToOtherView = false
                                                                                                          self.appDelegate().APIgettriviatime = self.appDelegate().getUTCFormateDate()
                                                                                                           self.appDelegate().APIgetoldtriviatime = self.appDelegate().getUTCFormateDate()
                                                                                                          self.appDelegate().arrnotification = response.value(forKey: "getnotifications") as! [AnyObject]
                                                                                                           UserDefaults.standard.setValue(json["notificationcount"], forKey: "notificationcount")
                                                                                                           UserDefaults.standard.synchronize()
                                                                                                           DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                                                                              self.callopenScreen()
                                                                                                          }
                                                                      }
                                                                                                          
                                                                                                         }
                                                                                                         else{
                                                                       DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                                          Clslogging.loginfo(State: "getbackgroundapi", userinfo: json as [String : AnyObject])
                                                                          
                                                                                                                   self.callopenScreen()
                                                                                                                     
                                                                                                                     
                                                                                                             }
                                                                                                             //Show Error
                                                                                                         }
                                                                                                     }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                                                                let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                                               Clslogging.logerror(State: "getbackgroundapi", userinfo: errorinfo)
                                                                                               self.callopenScreen()
                            break
                                                                      // error handling
                                                       
                                                                  }
                          
                   }
                   
                   
               } catch {
                   print(error.localizedDescription)
                self.callopenScreen()
                                                              
               }
           }else {
              // LoadingIndicatorView.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
           // self.alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                self.callopenScreen()
            }
           }
       }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          
          let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
            self.callopenScreen()
          });
          
          alert.addAction(action1)
          self.present(alert, animated: true, completion:nil)
      }
    func callopenScreen(){
       /* let notified: String? = UserDefaults.standard.string(forKey: "openslider")
                   if notified == nil
                   {
                       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                       let registerController : NotifyPermissionController = storyBoard.instantiateViewController(withIdentifier: "Notify") as! NotifyPermissionController
                       
                       //registerController.notifyImage?.image = UIImage(named: "user")
                       //registerController.notifyText?.text = "Please allow notifications for Football Fan to get notifications of messages."
                       registerController.notifyType = "notification"
                       
                    self.appDelegate().window = UIWindow(frame: UIScreen.main.bounds)
                       
                    self.appDelegate().window?.rootViewController = registerController
                    self.appDelegate().window?.makeKeyAndVisible()
                   }
                   else
                   {*/
                       //DispatchQueue.main.async {
                       /* let notified: String? = UserDefaults.standard.string(forKey: "notification")
                        if notified != nil
                        {
                        
                        if #available(iOS 10.0, *) {
                        let center = UNUserNotificationCenter.current()
                        center.delegate = self
                        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                        if error == nil {
                        if grant {
                        DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                        //application.unregisterForRemoteNotifications()
                        }
                        } else {
                        //User didn't grant permission
                        }
                        } else {
                        print("error: ",error ?? "")
                        }
                        })
                        } else {
                        // Fallback on earlier versions
                        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                        UIApplication.shared.registerUserNotificationSettings(settings)
                        }
                        }*/
                       
                       //}
                       //End code to register for push notification
                       if ClassReachability.isConnectedToNetwork() {
                           // Override point for customization after application launch.
                           let login: String? = UserDefaults.standard.string(forKey: "userJID")
                           let isShowTeams: String? = UserDefaults.standard.string(forKey: "isShowTeams")
                           let isMaintanece: Bool = UserDefaults.standard.bool(forKey: "maintance")
                                                     if(isMaintanece){
                                                      self.appDelegate().showmaintainScreen()
                                                     }
                                                     else{
                           let isShowProfile: String? = UserDefaults.standard.string(forKey: "isShowProfile")
                           let isLoggedin: String? = UserDefaults.standard.string(forKey: "isLoggedin")
                           if isShowTeams != nil
                           {
                               // if(self.connect()){
                            appDelegate().showMyTeams()
                               // }
                               
                           }
                           //Check if user is already logged in
                           if isLoggedin == nil || isLoggedin == "NO"
                           {
                               if isShowTeams != nil
                               {
                                   //if(self.connect()){
                                appDelegate().showMyTeams()
                                   //}
                                   
                               }
                               else
                               {
                                   if isShowProfile == nil {
                                       if (login != nil) {
                                           let isforgate: String? = UserDefaults.standard.string(forKey: "forgate")
                                           if(isforgate != nil){
                                               let tempotp = UserDefaults.standard.string(forKey: "tempotp")
                                               if(tempotp == nil){
                                                appDelegate().showChangepassword()
                                                   
                                               }
                                           }
                                           
                                           
                                        if self.appDelegate().connect() {
                                               //show buddy list
                                               
                                           } else {
                                            appDelegate().showLogin()
                                           }
                                           
                                           
                                       }
                                       else
                                       {
                                           //showLogin()
                                        appDelegate().showMainTab()
                                       }
                                   }
                                   else
                                   {
                                       //Authenticate and fetch profile data
                                    if(self.appDelegate().xmppStream?.isDisconnected)!
                                       {
                                           // if self.connect() {
                                        appDelegate().showMyTeams()
                                           //}
                                       }
                                       
                                   }
                               }
                               
                           }
                           else
                           {
                               
                            if(self.appDelegate().connect())
                               {
                                   //Get from local user defaults temp
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
                                   
                                   //End
                               }
                               appDelegate().showMainTab()
                           }
                        //appDelegate().showMainTab()
                        //appDelegate().profileAvtarTemp = UIImage(named:"user")
                        }
                       }
                       else{
                           let isMaintanece: Bool = UserDefaults.standard.bool(forKey: "maintance")
                           if(isMaintanece){
                            self.appDelegate().showmaintainScreen()
                           }
                           else{
                               // Override point for customization after application launch.
                               let login: String? = UserDefaults.standard.string(forKey: "userJID")
                               let isShowTeams: String? = UserDefaults.standard.string(forKey: "isShowTeams")
                               
                               let isShowProfile: String? = UserDefaults.standard.string(forKey: "isShowProfile")
                               let isLoggedin: String? = UserDefaults.standard.string(forKey: "isLoggedin")
                               if isShowTeams != nil
                               {
                                appDelegate().showMyTeams()
                               }
                               //Check if user is already logged in
                               if isLoggedin == nil || isLoggedin == "NO"
                               {
                                   if isShowTeams != nil
                                   {
                                    appDelegate().showMyTeams()
                                   }
                                   else
                                   {
                                       if isShowProfile == nil {
                                           if (login != nil) {
                                               let isforgate: String? = UserDefaults.standard.string(forKey: "forgate")
                                               if(isforgate != nil){
                                                   let tempotp = UserDefaults.standard.string(forKey: "tempotp")
                                                   if(tempotp == nil){
                                                    appDelegate().showChangepassword()
                                                       
                                                   }
                                               }
                                               
                                               
                                            if self.appDelegate().connect() {
                                                   //show buddy list
                                                   
                                               } else {
                                                appDelegate().showLogin()
                                               }
                                               
                                               
                                           }
                                           else
                                           {
                                               //showLogin()
                                            appDelegate().showMainTab()
                                           }
                                       }
                                       else
                                       {
                                           //Authenticate and fetch profile data
                                        if(self.appDelegate().xmppStream?.isDisconnected)!
                                           {
                                               //  if self.connect() {
                                            appDelegate().showMyTeams()
                                               // }
                                           }
                                           
                                       }
                                   }
                                   
                               }
                               else
                               {
                                   
                                if(self.appDelegate().connect())
                                   {
                                       //Get from local user defaults temp
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
                                       
                                       //End
                                   }
                                   appDelegate().showMainTab()
                                   appDelegate().profileAvtarTemp = UIImage(named:"user")
                               }
                               
                               
                           }
                       }
                       
                       //End
                       
                       /*//Temp
                        if self.connect() {
                        showProfile()
                        }*/
                       
                       
                       let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
                       if strAllContacts != nil
                       {
                           //Code to parse json data
                           if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                               do {
                                   let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                                   
                                    appDelegate().allContacts = NSMutableArray()
                                   for record in tmpAllContacts {
                                    appDelegate().allContacts[appDelegate().allContacts.count] = record
                                   }
                                   
                                let tmpAllAppContacts = appDelegate().allContacts[0] as! NSArray
                                   
                                    appDelegate().allAppContacts = NSMutableArray()
                                   for record in tmpAllAppContacts {
                                    appDelegate().allAppContacts[appDelegate().allAppContacts.count] = record
                                   }
                                   
                               }
                               catch let error as NSError {
                                   print(error)
                               }
                           }
                           
                       }
                       
                  // }
        let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
        if(istriviauser){
            if self.appDelegate().connect(){
                
            }
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
               splashController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
               dg.leave();
           }
           dg.wait();
           return splashController.realDelegate!;
       }
}
