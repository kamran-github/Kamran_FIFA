//
//  NewsLikeViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 14/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

class NewsLikeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var fanupdateid = 0 as Int64
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var note: UILabel!
    var SelectedTitel = ""
    
    var lastposition = 0
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    
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
        
        
        
        let notificationName1 = Notification.Name("_NewsGetLikes")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateGetLikes), name: notificationName1, object: nil)
        
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .large, color: .gray,  placeInTheCenterOf: self.view)
        
        
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
            
        appDelegate().isNewsPageLikeRefresh = true
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnewslikes" as AnyObject
            reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
            reqParams["newsid"] = fanupdateid as AnyObject
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
                            {DispatchQueue.main.async {
                                let response: NSArray = jsonData?.value(forKey: "data") as! NSArray
                                //arrFanUpdateLikes = response
                                if(self.appDelegate().isNewsPageLikeRefresh)
                                {
                                    self.appDelegate().arrNewsLikes = response  as [AnyObject]
                                }
                                else
                                {
                                    self.appDelegate().arrNewsLikes += response  as [AnyObject]
                                }
                                
                                let notificationName = Notification.Name("_NewsGetLikes")
                                NotificationCenter.default.post(name: notificationName, object: nil)
                                
                                
                                }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageLikeRefresh)
                                {
                                    self.appDelegate().arrNewsLikes = [AnyObject]()
                                    let notificationName = Notification.Name("_NewsGetLikes")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                }
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
                    //Show Error
                }
            })
            task.resume()
            
       /* var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "getnewslikes" as AnyObject
        
        do {
            
            
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            
            
            dictRequestData["newsid"] = fanupdateid as AnyObject
            dictRequestData["lastindex"] = lastindex as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
            
            let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
            self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
        } catch {
            print(error.localizedDescription)
        }*/
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
            
    }
    
    @objc func FanUpdateGetLikes(_ lastindex : Int)
    {
        if ClassReachability.isConnectedToNetwork() {
        if(lastindex == 0)
        {
            TransperentLoadingIndicatorView.show(self.view, loadingText: "Getting latest likes for you.")
            appDelegate().isNewsPageLikeRefresh = true
        } else
        {
            appDelegate().isNewsPageLikeRefresh = false
        }
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnewslikes" as AnyObject
            reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
            reqParams["newsid"] = fanupdateid as AnyObject
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
                            {DispatchQueue.main.async {
                                let response: NSArray = jsonData?.value(forKey: "data") as! NSArray
                                //arrFanUpdateLikes = response
                                if(self.appDelegate().isNewsPageLikeRefresh)
                                {
                                    self.appDelegate().arrNewsLikes = response  as [AnyObject]
                                }
                                else
                                {
                                    self.appDelegate().arrNewsLikes += response  as [AnyObject]
                                }
                                
                                let notificationName = Notification.Name("_NewsGetLikes")
                                NotificationCenter.default.post(name: notificationName, object: nil)
                                
                                
                                }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageLikeRefresh)
                                {
                                    self.appDelegate().arrNewsLikes = [AnyObject]()
                                    let notificationName = Notification.Name("_NewsGetLikes")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                }
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
                    //Show Error
                }
            })
            task.resume()
      /*  var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "getnewslikes" as AnyObject
        
        do {
            
            
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            
            
            dictRequestData["newsid"] = fanupdateid as AnyObject
            dictRequestData["lastindex"] = lastindex as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
            
            let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
            self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
        } catch {
            print(error.localizedDescription)
        }*/
    } else {
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
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(self.appDelegate().arrNewsLikes.count == 0){
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
        appDelegate().isNewsPageLikeRefresh = true
        FanUpdateGetLikes(lastposition)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(appDelegate().arrNewsLikes.count > 19)
        {
            let lastElement = appDelegate().arrNewsLikes.count - 1
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
            NewsLikeViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewsLikeViewController.realDelegate!;
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        //print(appDelegate().arrNewsLikes.count)
        return self.appDelegate().arrNewsLikes.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikesViewCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! LikesViewCell
        let dic: NSDictionary? = self.appDelegate().arrNewsLikes[indexPath.row] as? NSDictionary
       // print(dic)
        
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
                cell.contactImage?.af.setImage(withURL: url)
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
    
    
}



