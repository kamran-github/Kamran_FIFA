//
//  StoriesBlockesUserViewController.swift
//  FootballFan
//
//  Created by Apple on 05/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire
class StoriesBlockesUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var fanupdateid = 0 as Int64
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var storyTableView: UITableView!
     @IBOutlet weak var note: UILabel!
    var SelectedTitel = ""
var isFanRefresh: Bool = false
    var lastposition = 0
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var likecount = 0 as Int64
    var viewcount = 0 as Int64
    var commentcount = 0 as Int64
    var arrFanUpdatefans: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
          self.parent?.title = "Blocked Fans"
       
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
        //print("fanupdateid")
        //print(fanupdateid)
        //storyTableView?.backgroundView = UIImageView(image: UIImage(named: "background"))
        //storyTableView?.backgroundView?.contentMode = .scaleAspectFill
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdateLikes(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
    
    }
    
    @objc func refreshFanUpdateLikes(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
        //appDelegate().isFanPageLikeRefresh = true
        self.navigationItem.rightBarButtonItem = nil
       FanUpdateGeunblock(lastindex)
    }
    
    @objc func FanUpdateGeunblock(_ lastindex : Int)
    {
          if ClassReachability.isConnectedToNetwork() {
        if(lastindex == 0)
        {
           // LoadingIndicatorView.show(self.view, loadingText: "Getting latest likes for you")
           // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
           isFanRefresh = true
        } else
        {
           isFanRefresh = false
        }
    
       var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "fanstoryblockusers" as AnyObject
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
                                    //let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    
                                    
                                    let myjidtrim: String? = userUserJid
                                   // dictRequestData["fanupdateid"] = fanupdateid as AnyObject
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
                                                                                                                                                                                                                                  if(self.isFanRefresh)
                                                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                                              self.arrFanUpdatefans = response  as [AnyObject]
                                                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                                                             else
                                                                                                                                                                                                                                                                             {
                                                                                                                                                                                                                                                                              self.arrFanUpdatefans += response  as [AnyObject]
                                                                                                                                                                                                                                                                             }
                                                                                                                                                                                                                                  self.refreshFanUpdateGetblock()
                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                 
                                                                                                                                                                                                                             }
                                                                                                                                                                                                                             else{
                                                                                                                                                                                                                                 DispatchQueue.main.async
                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                      if(self.isFanRefresh)
                                                                                                                                                                                                                                                                                            {
                                                                                                                                                                                                                                                                                              self.arrFanUpdatefans = [AnyObject]()
                                                                                                                                                                                                                                                                                              self.refreshFanUpdateGetblock()
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 //Show Error
                                                                                                                                                                                                                             }
                                                                                                                                                }
                                                                                                                                            case .failure(let error): break
                                                                                                                                                // error handling
                                                                                                                                 debugPrint(error)
                                                                                                                                 DispatchQueue.main.async {                                                     self.alertWithTitle(title: nil, message: "We apologies for a technical issue on our server. Please try again later.", ViewController: self)
                                                                                                                                                                                                                                                    }
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
                           alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                           
                       }
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
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
           // TransperentLoadingIndicatorView.hide()
            
        }
        storyTableView?.isScrollEnabled = true
    }
    
     func refreshFanUpdateGetblock()
    {
        storyTableView?.reloadData()
       
        //storyTableView?.reloadData()
        //TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(self.arrFanUpdatefans.count == 0){
            storyTableView.isHidden = true
            note.isHidden = false
            note.text = "No fans blocked for Fan Stories content.\n\nYou can block all Fan Stories content posted by a particular fan by going to that particular content and selecting “Block Fan” from the menu options.\n\nYou will no longer be able to see all the Fan Stories content from blocked fans."
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
        //self.navigationItem.title = SelectedTitel
        self.parent?.title = "Blocked Fans"
              
        lastposition = 0
        
        FanUpdateGeunblock(lastposition)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       let allSelected = self.storyTableView?.indexPathsForSelectedRows
                     if(allSelected == nil)
                     {
            let lastElement = arrFanUpdatefans.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            lastposition = arrFanUpdatefans.count
            FanUpdateGeunblock(lastposition)
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
            StoriesBlockesUserViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return StoriesBlockesUserViewController.realDelegate!;
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        //print(appDelegate().arrFanUpdateLikes.count)
        return arrFanUpdatefans.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikesViewCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! LikesViewCell
        let dic: NSDictionary? = self.arrFanUpdatefans[indexPath.row] as? NSDictionary
        //print(dic)
        
        //cell.contactName?.text = dic?.value(forKey: "username") as? String
        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
        let arrdUserJid = myjid?.components(separatedBy: "@")
        let userUserJid = arrdUserJid?[0]
        if(userUserJid == (dic?.value(forKey: "blockedusername") as! String))
        {
            cell.contactName?.text = "You"
        } else {
            if(appDelegate().allAppContacts.count>0){
                
                
                var strName1: String = ""
                _ = appDelegate().allAppContacts.filter({ (text) -> Bool in
                    let tmp: NSDictionary = text as! NSDictionary
                    let val: String = tmp.value(forKey: "jid") as! String
                    let val2: String = dic?.value(forKey: "blockedusername") as! String
                    
                    
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
                    let recReadUserJid = dic?.value(forKey: "blockedusername") as! String
                    
                    let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                    let userReadUserJid = arrReadUserJid[0]
                    cell.contactName?.text = userReadUserJid
                }
            }
            else{
                let recReadUserJid = dic?.value(forKey: "blockedusername") as! String
                
                let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                let userReadUserJid = arrReadUserJid[0]
                cell.contactName?.text = userReadUserJid
            }
        }
        
        if(dic?.value(forKey: "avatar") != nil)
        {
            let avatar:String = (dic!.value(forKey: "avatar") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                
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
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
               if(allSelected == nil)
               {
                   
                   self.navigationItem.rightBarButtonItem = nil
                   
               }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
        if((allSelected?.count)! == 1)
        {
             self.navigationItem.rightBarButtonItem = nil
            let infoimage   = UIImage(named: "listunblock")!
            let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.unblockedUser(sender:)))
            self.navigationItem.rightBarButtonItem = infoButton
            
        }
    }
  
   @IBAction func unblockedUser(sender:UIButton) {
          //print("search pressed")
          if ClassReachability.isConnectedToNetwork()
          {
            var messages: String = ""
             let allSelected = self.storyTableView?.indexPathsForSelectedRows
            if((allSelected!.count) > 1)
                             {
                                messages = "Do you really want to unblock these fans?"
            }else{
                 messages = "Do you really want to unblock this fan?"
            }
              let alert = UIAlertController(title: nil, message: messages, preferredStyle: .alert)
              let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                  
              });
              let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                 // LoadingIndicatorView.show((self.appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while unblock these fans")
                 
                  if((allSelected?.count)! > 0)
                  {
                      //Forward chats
                    var blocked: String = ""
                      for sel in allSelected!
                      {
                         /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                              
                              
                          }*/
                          let indexP: NSIndexPath = sel as NSIndexPath
                             //let arrrow = self.resultArry[indexP.section] as! NSArray
                          
                           let dict2 = self.arrFanUpdatefans[indexP.row] as! NSDictionary
                            
                             //let tmpSingleUserChat: [String: AnyObject] = dict2.value as! [String: AnyObject]
                             let username: String = dict2["blockedusername"] as! String
                             let arrReadChatJid = username.components(separatedBy: "@")
                             let to: String = arrReadChatJid[0]
                           if(blocked == ""){
                               blocked = to
                           }
                           else{
                               blocked = "\(blocked),\(String(describing: to))"
                           }
                             //self.arrFanUpdatefans.remove(at: indexP.row)
                        
                      }
                    
                     self.calluserunblock(blockeduser: blocked)
                      /*let counter = (allSelected?.count)! + 2
                      DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter)) {
                          LoadingIndicatorView.hide()
                      }*/
                     // self.storyTableView?.reloadData()
                      
                  }
                  else{
                      self.alertWithTitle(title: "Error", message: "No fan select for Unblock.", ViewController: self)
                  }
                 
                
                  
                  //   self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(showNewBanterNotify))
              });
              alert.addAction(action)
              alert.addAction(action1)
              self.present(alert, animated: true, completion:nil)
              
              
          }
          else {
              alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
              
          }
      }
    func calluserunblock(blockeduser:String) {
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "userunblock" as AnyObject
        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
        dictRequest["device"] = "ios" as AnyObject
        do {
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let arrReadUserJid = login?.components(separatedBy: "@")
            let myMobile: String? = arrReadUserJid?[0]
            
            //appDelegate().mySupportedTeam = joinTeamId
            
            dictRequestData["username"] = myMobile as AnyObject
            dictRequestData["type"] = "stories" as AnyObject
            dictRequestData["blockedusername"] = blockeduser as AnyObject
            
                dictRequestData["blockedtime"] = 0 as AnyObject
            
            dictRequestData["unblockedtime"] = time as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
       
      /*  let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                                                                              self.navigationItem.rightBarButtonItem = nil
                                                                                                                                                                             //self.storyTableView.reloadData()
                                                                                                                                                                             self.FanUpdateGeunblock(0)
                                                                                                                                                                             self.appDelegate().getbackgroundapi()
                                                                                                                                                                                                     }
                                                                                                                                                                                                 }
                                                                                                                                                                                                 else{
                                                                                                                                                DispatchQueue.main.async {                                                     self.alertWithTitle(title: nil, message: "We apologies for a technical issue on our server. Please try again later.", ViewController: self)
                                                                                                                                                                                                     }                                              }
                                                                                                                                                                  
                                                                                                                                            }
                                                                                                                                        case .failure(let error):
                                                                                                    
                                                                                                    debugPrint(error)
                                                                                                    DispatchQueue.main.async {                                                     self.alertWithTitle(title: nil, message: "We apologies for a technical issue on our server. Please try again later.", ViewController: self)
                                                                                                                                                                                                                       }
                                                                                                    
                                                                                                    break
                                                                                                                                            // error handling
                                                                                                                             
                                                                                                                                        }
                                                                                                        
                                                                                
                                                                                                   }
            } catch {
                       print(error.localizedDescription)
                   }
    }
}


