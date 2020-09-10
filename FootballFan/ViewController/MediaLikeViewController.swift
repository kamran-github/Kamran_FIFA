//
//  LikeViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 23/05/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
import Alamofire
class MediaLikeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var fanupdateid = 0 as Int64
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var storyTableView: UITableView!
     @IBOutlet weak var note: UILabel!
    var SelectedTitel = ""
var isFanPageLikeRefresh: Bool = false
    var lastposition = 0
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var likecount = 0 as Int64
    var viewcount = 0 as Int64
    var commentcount = 0 as Int64
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
        //print("fanupdateid")
        //print(fanupdateid)
        storyTableView?.backgroundView = UIImageView(image: UIImage(named: "background"))
        storyTableView?.backgroundView?.contentMode = .scaleAspectFill
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdateLikes(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        
        
        //let notificationName1 = Notification.Name("_FanUpdateGetLikes")
        let notificationName1 = Notification.Name("_MediaGetLikes")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateGetLikes), name: notificationName1, object: nil)
        
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        
        
    }
    
    @objc func refreshFanUpdateLikes(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
        //appDelegate().isFanPageLikeRefresh = true
       FanUpdateGetLikes(lastindex)
    }
    
    @objc func FanUpdateGetLikes(_ lastindex : Int)
    {
          if ClassReachability.isConnectedToNetwork() {
        if(lastindex == 0)
        {
           // LoadingIndicatorView.show(self.view, loadingText: "Getting latest likes for you")
           // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
           isFanPageLikeRefresh = true
        } else
        {
           isFanPageLikeRefresh = false
        }
    
       var dictRequest = [String: AnyObject]()
                                dictRequest["cmd"] = "getvideolikes" as AnyObject
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
                                   
                                    
                                    let myjidtrim: String? = userUserJid
                                    dictRequestData["fanupdateid"] = fanupdateid as AnyObject
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
                                                                                                                                                             self.likecount = json["likecount"] as! Int64
                                                                                                                                                                                                                                     self.commentcount = json["commentcount"] as! Int64
                                                                                                                                                                                                                                    self.viewcount = json["viewcount"] as! Int64
                                                                                                                                                                                                                                    self.updatecommentOnArrays()
                                                                                                                                                         let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                                                                                        //arrMediaLikes = response
                                                                                                                                                             if(self.isFanPageLikeRefresh)
                                                                                                                                                                                                        {
                                                                                                                                                                                                         self.appDelegate().arrMediaLikes = response  as [AnyObject]
                                                                                                                                                                                                        }
                                                                                                                                                                                                        else
                                                                                                                                                                                                        {
                                                                                                                                                                                                         self.appDelegate().arrMediaLikes += response  as [AnyObject]
                                                                                                                                                                                                        }
                                                                                                                                                                                                        
                                                                                                                                                                                                        let notificationName = Notification.Name("_MediaGetLikes")
                                                                                                                                                                                                        NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                        
                                                                                                                                                         }
                                                                                                                                                            
                                                                                                                                                        }
                                                                                                                                                        else{
                                                                                                                                                            DispatchQueue.main.async
                                                                                                                                                                {
                                                                                                                                                                 if(self.isFanPageLikeRefresh)
                                                                                                                                                                                                                       {
                                                                                                                                                                                                                         self.appDelegate().arrMediaLikes = [AnyObject]()
                                                                                                                                                                                                                           
                                                                                                                                                                                                                           let notificationName = Notification.Name("_MediaGetLikes")
                                                                                                                                                                                                                           NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                           
                                                                                                                                                                                                                       }
                                                                                                                                                                                                                       
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
    
    @objc func refreshFanUpdateGetLikes()
    {
        storyTableView?.reloadData()
        if(self.activityIndicator?.isAnimating)!
        {
            self.activityIndicator?.stopAnimating()
        }
        storyTableView?.reloadData()
        //TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(self.appDelegate().arrMediaLikes.count == 0){
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
        self.navigationItem.title = SelectedTitel
        
        lastposition = 0
        
        FanUpdateGetLikes(lastposition)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(appDelegate().arrMediaLikes.count > 19)
        {
        let lastElement = appDelegate().arrMediaLikes.count - 1
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            lastposition = lastposition + 1
            FanUpdateGetLikes(lastposition)
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
            LikeViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return LikeViewController.realDelegate!;
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        print(appDelegate().arrMediaLikes.count)
        return self.appDelegate().arrMediaLikes.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikesViewCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! LikesViewCell
        let dic: NSDictionary? = self.appDelegate().arrMediaLikes[indexPath.row] as? NSDictionary
        //print(dic)
        
        //cell.contactName?.text = dic?.value(forKey: "username") as? String
        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
        let arrdUserJid = myjid?.components(separatedBy: "@")
        let userUserJid = arrdUserJid?[0]
        if(userUserJid == (dic?.value(forKey: "username") as! String))
        {
            cell.contactName?.text = "You"
        } else {
            if(appDelegate().allAppContacts.count>0){
                
                
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
            }
        }
        
        if(dic?.value(forKey: "avatar") != nil)
        {
            let avatar:String = (dic!.value(forKey: "avatar") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
               // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
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
        
    }
  
    func updatecommentOnArrays(){
           let tabIndex:[String: Any] = ["commentcount": commentcount, "likecount": likecount, "viewcount":viewcount]
           let notificationName = Notification.Name("_fanupdatecount")
           NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
           if(self.appDelegate().arrMedia.count>0){
                                                 for i in 0...self.appDelegate().arrMedia.count-1 {
                                                     let dict: NSDictionary? = self.appDelegate().arrMedia[i] as? NSDictionary
                                                            if(dict != nil)
                                                            {
                                                             let GroupID = dict?.value(forKey: "id") as! Int64
                                                             if(fanupdateid == GroupID){
                                                                 var dict1: [String: AnyObject] = self.appDelegate().arrMedia[i] as! [String: AnyObject]
                                                               dict1["likecount"] = likecount as AnyObject
                                                                       dict1["commentcount"] = commentcount as AnyObject
                                                               dict1["viewcount"] = viewcount as AnyObject //print("comment\(fanupdateid)\(appDelegate().arrFanUpdateComments.count)")
                                                               self.appDelegate().arrMedia[i] = dict1 as AnyObject
                                                                 let notificationName = Notification.Name("resetMedia")
                                                                                                                                                                       NotificationCenter.default.post(name: notificationName, object: nil)
                                                                 
                                                                 break
                                                                            
                                                             }
                                                     }
                                                 }
                                             }
           if(self.appDelegate().arrMedia.count>0) {
               for i in 0...self.appDelegate().arrMedia.count-1 {
                   let dict: NSDictionary? = self.appDelegate().arrMedia[i] as? NSDictionary
                          if(dict != nil)
                          {
                           let GroupID = dict?.value(forKey: "id") as! Int64
                           if(fanupdateid == GroupID){
                               var dict1: [String: AnyObject] = self.appDelegate().arrMedia[i] as! [String: AnyObject]
                                dict1["likecount"] = likecount as AnyObject
                               dict1["commentcount"] = commentcount as AnyObject
                               dict1["viewcount"] = viewcount as AnyObject
                               self.appDelegate().arrMedia[i] = dict1 as AnyObject
                               let notificationName = Notification.Name("resetmyStory")
                                                                                                                                     NotificationCenter.default.post(name: notificationName, object: nil)
                               
                               break
                                          
                           }
                   }
               }
           }
           if(self.appDelegate().arrhomemedia.count>0) {
                      for i in 0...self.appDelegate().arrhomemedia.count-1 {
                          let dict: NSDictionary? = self.appDelegate().arrhomemedia[i] as? NSDictionary
                                 if(dict != nil)
                                 {
                                  let GroupID = dict?.value(forKey: "id") as! Int64
                                  if(fanupdateid == GroupID){
                                      var dict1: [String: AnyObject] = self.appDelegate().arrhomemedia[i] as! [String: AnyObject]
                                   dict1["likecount"] = likecount as AnyObject
                                   dict1["commentcount"] = commentcount as AnyObject
                                   dict1["viewcount"] = viewcount as AnyObject
                                                 
                                      self.appDelegate().arrhomemedia[i] = dict1 as AnyObject
                                      let notificationName = Notification.Name("resetStoryslider")
                                                                                                                                            NotificationCenter.default.post(name: notificationName, object: nil)
                                      
                                      break
                                                 
                                  }
                          }
                      }
                  }
       }
}


