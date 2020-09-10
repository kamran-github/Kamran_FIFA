//
//  NotificationListViewController.swift
//  FootballFan
//
//  Created by Apple on 30/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
class NotificationListViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var apd = UIApplication.shared.delegate as! AppDelegate
       
    var fanupdateid = 0 as Int64
   // var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var note: UILabel!
    var SelectedTitel = ""
     // var arrnotification: [AnyObject] = []
    var lastposition = 0
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var isFollowerRefresh:Bool = true
    var followusername = ""
      lazy var lazyImage:LazyImage = LazyImage()
    var customAlertVC = CustomAlertViewController.instantiate()
    var infoAlertVC = InfoAlertViewController.instantiate()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
       
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdateLikes(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        storyTableView.estimatedRowHeight = 120
        storyTableView.rowHeight = UITableView.automaticDimension
        
       // let notificationName1 = Notification.Name("_NewsGetLikes")
        // Register to receive notification
       // NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateGetLikes), name: notificationName1, object: nil)
        
        
       // self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        
        lastposition = 0
        isFollowerRefresh = true
        if(apd.arrnotification.count == 0){
        getfollowers(lastposition)
        }
        else{
            self.updatereadnotify(0)  
        }
        UserDefaults.standard.setValue(0, forKey: "notificationcount")
        UserDefaults.standard.synchronize()
    }
    
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    @objc func refreshFanUpdateLikes(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
        if ClassReachability.isConnectedToNetwork() {
            
        isFollowerRefresh = true
          
       getfollowers(lastindex)
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
            
    }
    
    @objc func getfollowers(_ lastindex : Int)
    {
          if ClassReachability.isConnectedToNetwork() {
        if(lastindex == 0)
        {
           // LoadingIndicatorView.show(self.view, loadingText: "Getting latest likes for you")
           // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
           isFollowerRefresh = true
        } else
        {
           isFollowerRefresh = false
        }
    
       var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "getnotifications" as AnyObject
                                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                                dictRequest["device"] = "ios" as AnyObject
                                do {
                                    
                                  
                                    var dictRequestData = [String: AnyObject]()
                                      let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                          if(myjid != nil){
                                              let arrdUserJid = myjid?.components(separatedBy: "@")
                                              let userUserJid = arrdUserJid?[0]
                                              dictRequestData["username"] = userUserJid as AnyObject?
                                             // dictRequestData1["user"] = userUserJid as AnyObject?
                                          }
                                          else{
                                              let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                                                     if(!istriviauser){
                                                      let triviauser: String? = UserDefaults.standard.string(forKey: "triviauser")
                                                      let arrdUserJid = triviauser?.components(separatedBy: "@")
                                                               let userUserJid = arrdUserJid?[0]
                                                               dictRequestData["username"] = userUserJid as AnyObject?
                                                     }else{
                                                       dictRequestData["username"] = "" as AnyObject
                                              }
                                             //dictRequestData1["username"] = "" as AnyObject
                                          }
                                   // let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    
                                 
                                    dictRequestData["lastindex"] = lastindex as AnyObject
                                    //dictRequestData["username"] = myjidtrim as AnyObject
                                    dictRequest["requestData"] = dictRequestData as AnyObject
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
                                                                                                                                                                                                      //arrFanUpdateLikes = response
                                                                                                                                                           if(self.isFollowerRefresh)
                                                                                                                                                                                                      {
                                                                                                                                                                                                       self.apd.arrnotification = response  as [AnyObject]
                                                                                                                                                                                                      }
                                                                                                                                                                                                      else
                                                                                                                                                                                                      {
                                                                                                                                                                                                       self.apd.arrnotification += response  as [AnyObject]
                                                                                                                                                                                                      }
                                                                                                                                                           self.storyTableView.reloadData()
                                                                                                                                                           self.closeRefresh()
                                                                                                                                                                                                      //let notificationName = Notification.Name("_FanUpdateGetLikes")
                                                                                                                                                                                                      //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                      
                                                                                                                                                           self.updatereadnotify(0)                                    }
                                                                                                                                                          
                                                                                                                                                      }
                                                                                                                                                      else{
                                                                                                                                                          DispatchQueue.main.async
                                                                                                                                                              {
                                                                                                                                                               if(self.isFollowerRefresh)
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                       self.apd.arrnotification = [AnyObject]()
                                                                                                                                                                                                                       self.storyTableView.reloadData()
                                                                                                                                                                                                                         //let notificationName = Notification.Name("_FanUpdateGetLikes")
                                                                                                                                                                                                                         //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                       self.closeRefresh()
                                                                                                                                                                                                                     }
                                                                                                                                                                                                                     
                                                                                                                                                          }
                                                                                                                                                          //Show Error
                                                                                                                                                      }
                                                                                                                                                  }
                                                                                                                                              case .failure(let error):
                                                                                  debugPrint(error)
                                                                                  self.closeRefresh()
                                                                                                        
                                                                                                        break
                                                                                                                                                  // error handling
                                                                                                                                   
                                                                                                                                              }
                                                                                      
                                                                                               }
                                 
                                } catch {
                                    print(error.localizedDescription)
                                     closeRefresh()
                                }
        } else {
                           alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            closeRefresh()
                           
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
        storyTableView?.isScrollEnabled = true
        if(apd.arrnotification.count == 0){
                  storyTableView.isHidden = true
                  note.isHidden = false
                  note.text = "Notification will appear here."
              }
              else{
                  storyTableView.isHidden = false
                  note.isHidden = true
              }
    }
    
    @objc func refreshFanUpdateGetLikes()
    {
        storyTableView?.reloadData()
      
      
        closeRefresh()
        if(apd.arrnotification.count == 0){
            storyTableView.isHidden = true
            note.isHidden = false
            note.text = "Notification will appear here."
        }
        else{
            storyTableView.isHidden = false
            note.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("fanupdateid")
        //print(fanupdateid)
        self.navigationItem.title = "Notifications"
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(apd.arrnotification.count > 19)
        {
            let lastElement = apd.arrnotification.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                lastposition = apd.arrnotification.count
                getfollowers(lastposition)
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
            FollowerViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return FollowerViewController.realDelegate!;
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               
               let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
                   self.closeRefresh()
               });
               
               alert.addAction(action1)
               self.present(alert, animated: true, completion:nil)
    }
   
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        //print(appDelegate().arrNewsLikes.count)
        return apd.arrnotification.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationlistCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! NotificationlistCell
        let dic: NSDictionary? = apd.arrnotification[indexPath.row] as? NSDictionary
       // print(dic)
        
       if(dic?.value(forKey: "Avatar") != nil)
              {
                  let avatar:String = (dic!.value(forKey: "Avatar") as? String)!
                  if(!avatar.isEmpty)
                  {
                    let url = URL(string:avatar)!
                    cell.contactImage?.af.setImage(withURL: url)
                               //cell.contactImage.af_setImage(withURL: url!)
                      //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                      //appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                      //self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "user")
                  }
                  else
                  {
                      cell.contactImage?.image = UIImage(named: "user")
                  }
              }
              else
              {
                  cell.contactImage?.image = UIImage(named: "user")
              }
        cell.notifytitel?.text = dic?.value(forKey: "Event_header") as? String//Event_header
        let Event_message = dic?.value(forKey: "Event_message") as? String
        if(Event_message == ""){
             cell.notifydescription?.text = "pl"
            cell.notifydescription?.isHidden = true
        }
        else{
            
            cell.notifydescription?.isHidden = false
            cell.notifydescription?.text = Event_message
        }
       
        var msgtime = ""
        if let mili1 = dic?.value(forKey: "Date_notification_sent")
                       {
                           
                           let mili: Double = Double(mili1  as! String)!
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
                               //dateFormatter.dateFormat = "HH:mm"
                               // msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                           }
                       }
        
        cell.notifyTime?.text = msgtime
        let Is_read = dic?.value(forKey: "Is_read") as! Bool
        if(Is_read){
            cell.mainview?.backgroundColor = UIColor.white
            cell.notifydescription?.textColor = UIColor.init(hex: "9A9A9A")
            cell.mainview?.alpha = 1.0
        }
        else{
            cell.mainview?.backgroundColor = UIColor.init(hex: "cdcdcd")
            cell.mainview?.alpha = 0.5
            cell.notifydescription?.textColor = UIColor.black
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic: NSDictionary? = apd.arrnotification[indexPath.row] as? NSDictionary
             // print(dic)
        showevent(dic: dic!)
              //cell.contactName?.text = dic?.value(forKey: "username") as? String
            
        var dict1: [String: AnyObject] = apd.arrnotification[indexPath.row] as! [String: AnyObject]
       dict1["Is_read"] = 1 as AnyObject
     
        apd.arrnotification[indexPath.row] = dict1 as AnyObject
                 
        
    }
  
    func showevent(dic:NSDictionary) {
        let AppScreen:String = dic.value(forKey: "AppScreen") as! String
              // if(Event_subtype_id == 205 || Event_subtype_id == 201 || Event_subtype_id == 202 || Event_subtype_id == 203){
        if(AppScreen == "FanStory"){
                // Fan Story
                let id:Int = dic.value(forKey: "Source_item_id") as! Int
                 var dictRequest = [String: AnyObject]()
                 dictRequest["cmd"] = "getfanupdatebyid" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                 var reqParams = [String: AnyObject]()
                 
                 reqParams["id"] = id as AnyObject
                 
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
                                                                                          let blocked: Bool = json["blocked"] as! Bool
                                                                                          let error: String = json["error"] as! String
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
                                                                                  //Show Error
                                                                              }
                                                                          }
                                                                      case .failure(let error):
                                                                        debugPrint(error as Any)
                                break
                                                                          // error handling
                                                           
                                                                      }
                             
                     }
               

               }
        else  if(AppScreen == "Profile"){//if(Event_subtype_id == 101 || Event_subtype_id == 102 ){
                //follow or unfollow
                let id:String = dic.value(forKey: "Followusername") as! String

         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                     let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                                                     myTeamsController.RoomJid = id + JIDPostfix
                                    show(myTeamsController, sender: self)
        }
        else if(AppScreen == "TopSlider"){//if(Event_subtype_id == 301  ){
                //Top slider
                let id:Int = dic.value(forKey: "Source_item_id") as! Int
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "gethomefixedbyid" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
             
                    var reqParams = [String: AnyObject]()
                   
                    reqParams["id"] = id as AnyObject
                    
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
                                                                                  
                                                                                  let arr = json["responseData"] as! NSArray
                                                                                  let response = arr[0] as! NSDictionary
                                                                                  print(response)
                                                                                  //let notificationName = Notification.Name("tabindexchange")
                                                                                  //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                  
                                                                                  
                                                                                let type = response.value(forKey: "type")as! String
                                                                                    
                                                                                    
                                                                                    var thumbLink: String = ""
                                                                                    
                                                                                    if(type == "image"){
                                                                                     thumbLink = response.value(forKey: "url")as! String
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
                                                                                        thumbLink = response.value(forKey: "thumb")as! String
                                                                                     let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                                                            let previewController : Previewmidia! = storyBoard.instantiateViewController(withIdentifier: "Previewmidia") as? Previewmidia
                                                                                      previewController.videoURL = response.value(forKey: "url") as? String
                                                                                     previewController.mediaType = "video"
                                                                                       self.show(previewController!, sender: self)
                                                                                                           // self.present(previewController, animated: true, completion: nil)
                                                                                    }
                                                                                 else if(type == "live"){
                                                                                       thumbLink = response.value(forKey: "thumb")as! String
                                                                                  let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                                                         let previewController : LiveStrimingViewController! = storyBoard.instantiateViewController(withIdentifier: "LiveStriming") as? LiveStrimingViewController
                                                                                      previewController.videoURL = response.value(forKey: "url") as? String
                                                                                 // previewController.mediaType = "video"
                                                                                           self.show(previewController!, sender: self)
                                                                                                         //self.present(previewController, animated: true, completion: nil)
                                                                                 }
                                                                                  }}
                                                                              else{
                                                                                  DispatchQueue.main.async
                                                                                      {
                                                                                          //LoadingIndicatorView.hide()
                                                                                          
                                                                                          
                                                                                          
                                                                                          
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
                    
                    
               
               }
        else if(AppScreen == "News"){//if(Event_subtype_id == 401  ){
                //News
                let id:Int = dic.value(forKey: "Source_item_id") as! Int
                
                   var dictRequest = [String: AnyObject]()
                          dictRequest["cmd"] = "getnewsbyid" as AnyObject
                          dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                          dictRequest["device"] = "ios" as AnyObject
                            
                              var reqParams = [String: AnyObject]()
                             
                            reqParams["id"] = id as AnyObject
                              
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
                                                                                          
                                                                                          let arr = json["responseData"] as! NSArray
                                                                                          let response = arr[0] as! NSDictionary
                                                                                          print(response)
                                                                                          //let notificationName = Notification.Name("tabindexchange")
                                                                                          //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                          
                                                                                           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                                                    let registerController : NewsDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "newsdetail") as? NewsDetailViewController
                                                                                                    //present(registerController as! UIViewController, animated: true, completion: nil)
                                                                                                    registerController.newsdetail = response
                                                                                                    registerController.fromBanter = true
                                                                                                    self.show(registerController, sender: self)
                                                                                          
                                                                                          }}
                                                                                      else{
                                                                                          DispatchQueue.main.async
                                                                                              {
                                                                                                  //LoadingIndicatorView.hide()
                                                                                                  
                                                                                                  
                                                                                                  
                                                                                                  
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
                              
                              
                          
                
               }
        else if(AppScreen == "Video"){
                //Video
                let id:Int = dic.value(forKey: "Source_item_id") as! Int
                var dictRequest = [String: AnyObject]()
                                                 dictRequest["cmd"] = "getvideobyid" as AnyObject
                                                 dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                                                 dictRequest["device"] = "ios" as AnyObject
                                                 var reqParams = [String: AnyObject]()
                                                 //reqParams["cmd"] = "getfanupdates" as AnyObject
                                               //let id: AnyObject = pushUserinfo["id"] as AnyObject
                                                // let id: Int64 = (jsonData?.value(forKey: "id") as? Int64)!
                                                 reqParams["id"] = id as AnyObject
                                                 
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
                                                                                                                  
                                                                                                                  // print(response)
                                                                                                                  //let notificationName = Notification.Name("tabindexchange")
                                                                                                                  //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                  let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                                                                                 let registerController : MediaDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "mediadetail") as? MediaDetailViewController
                                                                                                                                 //present(registerController as! UIViewController, animated: true, completion: nil)
                                                                                                                 registerController.fanupdatedetail = response as [AnyObject]
                                                                                                                                 registerController.fromBanter = true
                                                                                                                                 self.show(registerController, sender: self)
                                                                                                                  }
                                                                                                                  
                                                                                                              }
                                                                                                              else{
                                                                                                                 DispatchQueue.main.async
                                                                                                                      {
                                                                                                                          let blocked: Bool = json["blocked"] as! Bool
                                                                                                                          let error: String = json["error"] as! String
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
                                                                                                                  //Show Error
                                                                                                              }
                                                                                                          }
                                                                                                      case .failure(let error):
                                                                                                         debugPrint(error as Any)
                                                                break
                                                                                                          // error handling
                                                                                           
                                                                                                      }
                                                            
                                                     }
                                                 
               }
        else  if(AppScreen == "Broadcast"){//if(Event_subtype_id == 601 || Event_subtype_id == 602 || Event_subtype_id == 603 || Event_subtype_id == 604 || Event_subtype_id == 701 || Event_subtype_id == 702 || Event_subtype_id == 703 || Event_subtype_id == 704){
                // Broadcast Active
                       let Event_body:String = dic.value(forKey: "Event_body") as! String
                if let dataMessage = Event_body.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                                 {
                                     do {
                                         let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                        if(!apd.ismodalshow){
                                            apd.ismodalshow = true
                                                           //let dictNotify: [String : AnyObject] = jsonDataMessage["data"] as! [String : AnyObject]
                                                          
                                                           // let roomIdNotify = dictNotify["modaltype"] as! String
                                            let receivedMessageType = jsonDataMessage?.value(forKey: "modaltype") as! String
                                                           
                                                           if(receivedMessageType == "action"){
                                                               let mediatype = jsonDataMessage?.value(forKey:"mediatype")
                                                                as! String
                                                               let mediaurl = jsonDataMessage?.value(forKey:"mediaurl") as! String
                                                               let actionbtn = jsonDataMessage?.value(forKey:"actionbtn") as! String
                                                               let action = jsonDataMessage?.value(forKey:"action") as! String
                                                               let link = jsonDataMessage?.value(forKey:"link") as! String
                                                               let linktitle = jsonDataMessage?.value(forKey:"linktitle") as! String
                                                               let message = jsonDataMessage?.value(forKey:"message") as! String
                                                               customAlertVC = CustomAlertViewController.instantiate()
                                                               guard let customAlertVC = customAlertVC else { return }
                                                               
                                                               customAlertVC.titleString = "contactsync"
                                                               customAlertVC.messageString = message
                                                               customAlertVC.mediatype = mediatype
                                                               customAlertVC.mediaurl = mediaurl
                                                               customAlertVC.ActionTitle = actionbtn
                                                               customAlertVC.actioncommand = action
                                                               customAlertVC.actionlink = link
                                                               customAlertVC.LinkTitle = linktitle
                                                               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                   let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 420)
                                                                   // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                   popupVC.cornerRadius = 20
                                                                self.apd.window?.visibleViewController?.navigationController?.present(popupVC, animated: true, completion: nil)
                                                               }
                                                           }
                                                           else{
                                                               let mediatype = jsonDataMessage?.value(forKey:"mediatype")
                                                                                                                              as! String
                                                                                                                             let mediaurl = jsonDataMessage?.value(forKey:"mediaurl") as! String
                                                                                                                             let actionbtn = jsonDataMessage?.value(forKey:"actionbtn") as! String
                                                                                                                             let action = jsonDataMessage?.value(forKey:"action") as! String
                                                                                                                             let link = jsonDataMessage?.value(forKey:"link") as! String
                                                                                                                             let linktitle = jsonDataMessage?.value(forKey:"linktitle") as! String
                                                                                                                             let message = jsonDataMessage?.value(forKey:"message") as! String
                                                               infoAlertVC = InfoAlertViewController.instantiate()
                                                               guard let customAlertVC = infoAlertVC else { return }
                                                               
                                                               customAlertVC.titleString = "contactsync"
                                                               customAlertVC.messageString = message
                                                               customAlertVC.mediatype = mediatype
                                                               customAlertVC.mediaurl = mediaurl
                                                               customAlertVC.ActionTitle = actionbtn
                                                               customAlertVC.actioncommand = action
                                                               customAlertVC.actionlink = link
                                                               customAlertVC.LinkTitle = linktitle
                                                               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                   let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 420)
                                                                   // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                   popupVC.cornerRadius = 20
                                                                self.apd.window?.visibleViewController?.navigationController?.present(popupVC, animated: true, completion: nil)
                                                               }
                                                               
                                                           }
                                                       }
                                        
                                                          } catch let error as NSError {
                                                              print(error)
                                                          }
                                                          
                                                      }
                                         
                      }
       /* else  if(Event_subtype_id == 701 || Event_subtype_id == 702 || Event_subtype_id == 703 || Event_subtype_id == 704){
                //Broadcast Inactive
         let id:Int = dic.value(forKey: "id") as! Int
        }*/
        storyTableView.reloadData()
    }
    func showStoriesBlockedUser()
               {
                   let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                   let myTeamsController : StoriesBlockesUserViewController = storyBoard.instantiateViewController(withIdentifier: "StoriesBlockesUser") as! StoriesBlockesUserViewController
                   //  appDelegate().isFromSettings = true
                   show(myTeamsController, sender: self)
                  // self.present(myTeamsController, animated: true, completion: nil)
               }
    @objc func updatereadnotify(_ lastindex : Int)
      {
            if ClassReachability.isConnectedToNetwork() {
         
         var dictRequest = [String: AnyObject]()
                                  dictRequest["cmd"] = "updatereadnotificationtime" as AnyObject
                                  dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                                  dictRequest["device"] = "ios" as AnyObject
                                  do {
                                      
                                    
                                      var dictRequestData = [String: AnyObject]()
                                        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                            if(myjid != nil){
                                                let arrdUserJid = myjid?.components(separatedBy: "@")
                                                let userUserJid = arrdUserJid?[0]
                                                dictRequestData["username"] = userUserJid as AnyObject?
                                               // dictRequestData1["user"] = userUserJid as AnyObject?
                                            }
                                            else{
                                                let istriviauser = UserDefaults.standard.bool(forKey: "istriviauser")
                                                       if(!istriviauser){
                                                        let triviauser: String? = UserDefaults.standard.string(forKey: "triviauser")
                                                        let arrdUserJid = triviauser?.components(separatedBy: "@")
                                                                 let userUserJid = arrdUserJid?[0]
                                                                 dictRequestData["username"] = userUserJid as AnyObject?
                                                       }else{
                                                         dictRequestData["username"] = "" as AnyObject
                                                }
                                               //dictRequestData1["username"] = "" as AnyObject
                                            }
                                     // let time: Int64 = self.appDelegate().getUTCFormateDate()
                                      
                                   
                                      dictRequestData["lastindex"] = lastindex as AnyObject
                                      //dictRequestData["username"] = myjidtrim as AnyObject
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
                                                                                                                                                 if(status1){
                                                                                                                                                     DispatchQueue.main.async {
                                                                                                                                                                    //let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                               
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
                                                                                                    self.closeRefresh()
                                                                                                    
                                                                                                    break
                                                                                                                                               // error handling
                                                                                                                                
                                                                                                                                           }
                                                                                         
                                                                                                 }
                                    
                                  } catch {
                                      print(error.localizedDescription)
                                       closeRefresh()
                                  }
          } else {
                             alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
              closeRefresh()
                             
                         }
      }
}



