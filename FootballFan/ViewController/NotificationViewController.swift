//
//  NotificationViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 18/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//


import Foundation
import UIKit
import UserNotifications
import Alamofire
class NotificationViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    let sections = [" Message Notifications"]
    
   // let items = ["Available"]
    @IBOutlet weak var btnTone: UIButton?
    @IBOutlet weak var storyTableView: UITableView?
    var settingOptions: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notifications"
        // Do any additional setup after loading the view.
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
        //UserStaus?.text=UserDefaults.standard.string(forKey: "userStatus")
        
        var tempDict1 = [String: String]()
        tempDict1["mode"] = UserDefaults.standard.string(forKey: "BanterNotification")
        tempDict1["name"] = "Banter notifications"
        self.settingOptions.append(tempDict1 as AnyObject)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.parent?.title = "Settings"
        let Tone = UserDefaults.standard.bool(forKey: "ConvertationTone")
        if (Tone) {
           
           
            btnTone?.setImage(UIImage(named: "failtick"), for: UIControl.State.normal)
        }
        else{
            btnTone?.setImage(UIImage(named: "green_tick"), for: UIControl.State.normal)
           
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.sections.count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if(section == 0)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
            // headerView.tintColor=UIColor(hex:"FFFFFF")
        }
        else if(section == 1)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.sections[section]
        label.textColor=UIColor(hex: "FFFFFF")
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingOptions.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
        let dict: [String : String] = settingOptions[indexPath.row] as! [String : String]
        //cell.optionName?.text = dict["name"]
        cell.optionmode?.text = dict["mode"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        var priority = ""
        
        //self.items[indexPath.section][indexPath.row
        let optionMenu = UIAlertController(title: "Select Priority", message: "", preferredStyle: .actionSheet)
        let EveryoneAction = UIAlertAction(title: "Everyone", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Take Photo")
            //Code to show camera
           /* if ClassReachability.isConnectedToNetwork()
            {
                priority = "Everyone"
                UserDefaults.standard.setValue(priority, forKey: "BanterNotification")
                UserDefaults.standard.synchronize()
                var tempDict1 = [String: String]()
                tempDict1["mode"] = priority
                tempDict1["name"] = "Banter notifications"
                self.settingOptions[0]=tempDict1 as AnyObject
                self.storyTableView?.reloadData()
                
               /* if #available(iOS 10.0, *) {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                } else {
                    // Fallback on earlier versions
                    let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }*/
                let deviceToken: String? = UserDefaults.standard.string(forKey: "DeviceToken")
                 if(deviceToken != nil){
                self.appDelegate().updatetoken(token: deviceToken!)
                }
            } else {
                self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                    
                }*/
            self.updateNotificationStatus(Status: "yes")
            
        })
        
      /*  let ContactsAction = UIAlertAction(title: "My Contacts", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Choose Photo")
            //Code to show gallery
             priority = "My Contacts"
            UserDefaults.standard.setValue(priority, forKey: "BanterNotification")
            UserDefaults.standard.synchronize()
            var tempDict1 = [String: String]()
            tempDict1["mode"] = priority
            tempDict1["name"] = "Banter notifications"
            self.settingOptions[0]=tempDict1 as AnyObject
            self.storyTableView?.reloadData()
        })*/
        let NobodyAction = UIAlertAction(title: "Nobody", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Choose Photo")
            //Code to show gallery
             priority = "Nobody"
           /* UserDefaults.standard.setValue(priority, forKey: "BanterNotification")
            UserDefaults.standard.synchronize()
            var tempDict1 = [String: String]()
            tempDict1["mode"] = priority
            tempDict1["name"] = "Banter notifications"
            self.settingOptions[0]=tempDict1 as AnyObject
            self.storyTableView?.reloadData()*/
           /* DispatchQueue.main.async {
                //application.registerForRemoteNotifications()
                UIApplication.shared.unregisterForRemoteNotifications()
            }*/
            self.updateNotificationStatus(Status: "no")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
            self.storyTableView?.reloadData()
        })
        optionMenu.addAction(EveryoneAction)
       // optionMenu.addAction(ContactsAction)
        optionMenu.addAction(NobodyAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTeam () {
      //  UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
   
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            NotificationViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NotificationViewController.realDelegate!;
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    @IBAction func showConvertationTonevalue () {
        // let passwordtag = ""
        let Tone = UserDefaults.standard.bool(forKey: "ConvertationTone")
        if (Tone) {
           // userpassword?.isSecureTextEntry = false
            //userpassword?.font = UIFont(name:sy, size: 18)
            //btnShow?.setTitle("Hide Password", for: UIControlState.normal)
            UserDefaults.standard.setValue(false, forKey: "ConvertationTone")
            UserDefaults.standard.synchronize()
            btnTone?.setImage(UIImage(named: "failtick"), for: UIControl.State.normal)
        }
        else{
            btnTone?.setImage(UIImage(named: "green_tick"), for: UIControl.State.normal)
            UserDefaults.standard.setValue(true, forKey: "ConvertationTone")
            UserDefaults.standard.synchronize()
           // userpassword?.isSecureTextEntry = true
            //btnShow?.setTitle("Show Password", for: UIControlState.normal)
        }
       
    }
    func updateNotificationStatus(Status:String) {
         if ClassReachability.isConnectedToNetwork() {
       
        var dictRequest = [String: AnyObject]()
               dictRequest["cmd"] = "updatenotification" as AnyObject
               dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                      dictRequest["device"] = "ios" as AnyObject
               
                   //Creating Request Data
                   var dictRequestData = [String: AnyObject]()
                   let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                  let arrdUserJid = myjid?.components(separatedBy: "@")
                                  let userUserJid = arrdUserJid?[0]
                                  
                                  
                   
                   
                   dictRequestData["status"] = Status as AnyObject
                  
                   dictRequestData["username"] = userUserJid as AnyObject
                   dictRequest["requestData"] = dictRequestData as AnyObject
                   
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
                                                                                                                        let notifications:String = dic.value(forKey: "notifications") as! String
                                                                                                                        if(notifications == "yes"){
                                                                                                                          //  priority = "Everyone"
                                                                                                                            UserDefaults.standard.setValue("Everyone", forKey: "BanterNotification")
                                                                                                                            UserDefaults.standard.synchronize()
                                                                                                                            var tempDict1 = [String: String]()
                                                                                                                            tempDict1["mode"] = "Everyone"
                                                                                                                            tempDict1["name"] = "Banter notifications"
                                                                                                                            self.settingOptions[0]=tempDict1 as AnyObject
                                                                                                                            self.storyTableView?.reloadData()
                                                                                                                            
                                                                                                                            
                                                                                                                        }else{
                                                                                                                            UserDefaults.standard.setValue("Nobody", forKey: "BanterNotification")
                                                                                                                             UserDefaults.standard.synchronize()
                                                                                                                             var tempDict1 = [String: String]()
                                                                                                                             tempDict1["mode"] = "Nobody"
                                                                                                                             tempDict1["name"] = "Banter notifications"
                                                                                                                             self.settingOptions[0]=tempDict1 as AnyObject
                                                                                                                             self.storyTableView?.reloadData()
                                                                                                                            
                                                                                                                        }
                                                                                                                        }
                                                                                                                        
                                                                                                                    }
                                                                                                                    else{
                                                                                                                        DispatchQueue.main.async
                                                                                                                            {
                                                                                                                             let error: String = json["error"] as! String
                                                                                                                                self.alertWithTitle(title: nil, message: error, ViewController: self)
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
             
    }
    else{
              self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
         }
    }
}
