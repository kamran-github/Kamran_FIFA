//
//  FollowerViewController.swift
//  FootballFan
//
//  Created by Apple on 26/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class FollowerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var fanupdateid = 0 as Int64
   // var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var note: UILabel!
    var SelectedTitel = ""
      var arrfollowers: [AnyObject] = []
    var lastposition = 0
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var isFollowerRefresh:Bool = true
    var followusername = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
       
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdateLikes(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        
        
       // let notificationName1 = Notification.Name("_NewsGetLikes")
        // Register to receive notification
       // NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateGetLikes), name: notificationName1, object: nil)
        
        
       // self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        
        
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
                                dictRequest["cmd"] = "getfollowers" as AnyObject
                                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                                dictRequest["device"] = "ios" as AnyObject
                                do {
                                    
                                  
                                    var dictRequestData = [String: AnyObject]()
                                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                    let arrdUserJid = myjid?.components(separatedBy: "@")
                                    
                                    let myjidtrim = arrdUserJid?[0]
                                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    
                                   
                                    let arrfUserJid = followusername.components(separatedBy: "@")
                                    let spltUserJid = arrfUserJid[0]
                                    let followjidtrim: String? = spltUserJid
                                     dictRequestData["followusername"] = followjidtrim as AnyObject
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
                                                                                                                                                                                                                                                                   let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                                                                                                       // self.finishSyncContacts()
                                                                                                                                                       //print(" status:", status1)
                                                                                                                                                    if(status1){
                                                                                                                                                        DispatchQueue.main.async {
                                                                                                                                                                       let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                                                                                       //arrFanUpdateLikes = response
                                                                                                                                                            if(self.isFollowerRefresh)
                                                                                                                                                                                                       {
                                                                                                                                                                                                        self.arrfollowers = response  as [AnyObject]
                                                                                                                                                                                                       }
                                                                                                                                                                                                       else
                                                                                                                                                                                                       {
                                                                                                                                                                                                        self.arrfollowers += response  as [AnyObject]
                                                                                                                                                                                                       }
                                                                                                                                                            self.storyTableView.reloadData()
                                                                                                                                                            self.closeRefresh()
                                                                                                                                                                                                       //let notificationName = Notification.Name("_FanUpdateGetLikes")
                                                                                                                                                                                                       //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                       
                                                                                                                                                        }
                                                                                                                                                           
                                                                                                                                                       }
                                                                                                                                                       else{
                                                                                                                                                           DispatchQueue.main.async
                                                                                                                                                               {
                                                                                                                                                                if(self.isFollowerRefresh)
                                                                                                                                                                                                                      {
                                                                                                                                                                                                                        self.arrfollowers = [AnyObject]()
                                                                                                                                                                                                                        self.storyTableView.reloadData()
                                                                                                                                                                                                                        self.closeRefresh()
                                                                                                                                                                                                                          //let notificationName = Notification.Name("_FanUpdateGetLikes")
                                                                                                                                                                                                                          //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                          
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
                                   /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                                    //print(strFanUpdates)
                                    self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)*/
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
        if(arrfollowers.count == 0){
                 storyTableView.isHidden = true
                 note.isHidden = false
                 note.text = "No Follower yet."
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
        if(arrfollowers.count == 0){
            storyTableView.isHidden = true
            note.isHidden = false
            note.text = "No likes yet."
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
        self.navigationItem.title = "Followers"
        
        lastposition = 0
        isFollowerRefresh = true
        getfollowers(lastposition)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(arrfollowers.count > 19)
        {
            let lastElement = arrfollowers.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                lastposition = arrfollowers.count
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
        return arrfollowers.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikesViewCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! LikesViewCell
        let dic: NSDictionary? = arrfollowers[indexPath.row] as? NSDictionary
       // print(dic)
        
        //cell.contactName?.text = dic?.value(forKey: "username") as? String
        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
        let arrdUserJid = myjid?.components(separatedBy: "@")
        let userUserJid = arrdUserJid?[0]
        if(userUserJid == (dic?.value(forKey: "followusername") as! String))
        {
            cell.contactName?.text = "You"
            cell.btnFollowed.isHidden = true
        } else {
            let userjid = dic?.value(forKey: "followusername") as! String + JIDPostfix
            let userReadUserJid = appDelegate().ExistingContact(username: userjid)
             cell.contactName?.text = userReadUserJid
            let isfollowed = dic?.value(forKey: "followed") as! Bool
            if(isfollowed){
                cell.btnFollowed?.setTitle("Unfollow" , for: UIControl.State.normal)
                cell.btnFollowed.backgroundColor = UIColor.init(hex: "AAAAAA")
                   }
                   else{
                       cell.btnFollowed?.setTitle("Follow" , for: UIControl.State.normal)
                 cell.btnFollowed.backgroundColor = UIColor.init(hex: "2185F7")
                   }
            cell.btnFollowed.isHidden = false
            let longPressGesture_follow:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_follow.delegate = self as? UIGestureRecognizerDelegate
            
            
            cell.btnFollowed?.addGestureRecognizer(longPressGesture_follow)
            cell.btnFollowed?.isUserInteractionEnabled = true
            
           /* if(appDelegate().allAppContacts.count>0){
                
                
                var strName1: String = ""
                _ = appDelegate().allAppContacts.filter({ (text) -> Bool in
                    let tmp: NSDictionary = text as! NSDictionary
                    let val: String = tmp.value(forKey: "jid") as! String
                    let val2: String = dic?.value(forKey: "username") as! String
                    
                    
                    if(val.contains(val2))
                    {
                        strName1 = tmp.value(forKey: "name") as! String
                        
                    }
                    
                    return false
                })
                if(!strName1.isEmpty){
                    cell.contactName?.text = strName1//dict2?.value(forKey: "userName") as? String
                }
                else{
                    let recReadUserJid = dic?.value(forKey: "username") as! String
                    
                    let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                    let userReadUserJid = arrReadUserJid[0]
                    cell.contactName?.text = userReadUserJid
                }
            }
            else{
                let recReadUserJid = dic?.value(forKey: "username") as! String
                
                let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                let userReadUserJid = arrReadUserJid[0]
                cell.contactName?.text = userReadUserJid
            }*/
        }
        
        if(dic?.value(forKey: "avatar") != nil)
        {
            let avatar:String = (dic!.value(forKey: "avatar") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
               // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                //cell.contactImage.imageURL = avatar
                let url = URL(string:avatar)!
                                   cell.contactImage?.af_setImage(withURL: url)
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic: NSDictionary? = arrfollowers[indexPath.row] as? NSDictionary
             // print(dic)
              
              //cell.contactName?.text = dic?.value(forKey: "username") as? String
            
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                  let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                  myTeamsController.RoomJid = dic?.value(forKey: "followusername") as! String + JIDPostfix
                  show(myTeamsController, sender: self)
                 
        
    }
    @objc func followClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
        
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            
            let dict: NSDictionary? = arrfollowers[indexPath.row] as? NSDictionary
            // print(dict)
            if ClassReachability.isConnectedToNetwork()
            {
                let isfollowed: Bool = dict?.value(forKey: "followed") as! Bool
                if(isfollowed){
                    
                    var dict1: [String: AnyObject] = arrfollowers[indexPath.row] as! [String: AnyObject]
                    dict1["followed"] = false as AnyObject
                    
                    arrfollowers[indexPath.row] = dict1 as AnyObject
                }
                else{
                    
                    var dict1: [String: AnyObject] = arrfollowers[indexPath.row] as! [String: AnyObject]
                    dict1["followed"] = true as AnyObject
                    
                    arrfollowers[indexPath.row] = dict1 as AnyObject
                    
                }
                    
                SaveFollow(tfollowusername: dict?.value(forKey: "followusername") as! String)
                storyTableView.reloadData()
                }
                else {
                    self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                    
                }
            }
        }
        func SaveFollow(tfollowusername : String)  {
            if ClassReachability.isConnectedToNetwork()
            {
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "savefollowers" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                
                let time: Int64 = self.appDelegate().getUTCFormateDate()
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                
                let login: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrReadUserJid = login?.components(separatedBy: "@")
                let myMobile: String? = arrReadUserJid?[0]
                //let followusernameUserJid = RoomJid.components(separatedBy: "@")
                // let    followusername: String? = followusernameUserJid[0]
                
                dictRequestData["username"] = myMobile as AnyObject
                dictRequestData["followusername"] = tfollowusername as AnyObject
                dictRequestData["type"] = "fan" as AnyObject
                dictRequestData["time"] = time as AnyObject
                
                dictRequest["requestData"] = dictRequestData as AnyObject
                AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                  headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                    // 2
                    .responseJSON { response in
                        switch response.result {
                                                                case .success(let value):
                                                                    if let json = value as? [String: Any] {
                                                                        let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                        // self.finishSyncContacts()
                                                                        //print(" status:", status1)
                                                                        if(status1){
                                                                            // self.isfollowed = json["followed"]
                                                                           /* if(login == self.followusername){
                                                                            let response: NSArray = json[ "responseData"] as! NSArray
                                                                            let dic:NSDictionary = response[0] as! NSDictionary
                                                                            let followerscount = dic.value(forKey: "followerscount") as! Int64
                                                                                   let followingcount = dic.value(forKey: "followingcount") as! Int64
                                                                                   let fanstorycount = dic.value(forKey: "fanstorycount") as! Int64
                                                                                UserDefaults.standard.setValue(followerscount, forKey: "followerscount")
                                                                                UserDefaults.standard.setValue(fanstorycount, forKey: "fanstorycount")
                                                                                UserDefaults.standard.setValue(followingcount, forKey: "followingcount")
                                                                            }*/
                                                                        }
                                                                        else{
                                                                            
                                                                        }
                                                                    }
                                                                case .failure(let error):
                            debugPrint(error)
                            break
                                                                    // error handling
                                                     
                                                                }
                      
                }
                
            }
            else {
                alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
        }
    
}



