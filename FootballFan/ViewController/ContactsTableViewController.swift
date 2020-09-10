//
//  ContactsTableViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 19/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import AddressBook
import MessageUI
import Foundation
import XMPPFramework
import Contacts


class ContactsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var storyTableView: UITableView?
    @IBOutlet weak var storySearchBar: UISearchBar?
    //var phoneContacts = NSMutableArray()
    var phoneFilteredContacts = NSMutableArray()
    var searchActive : Bool = false
    var searchStarting : Bool = false
    var addressBookRef: ABAddressBook? = nil
     var strings:[String] = []
     @IBOutlet weak var butcontacts: UIButton?
     @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var noContactFound: UILabel?
    let cellReuseIdentifier = "contacts"
    @IBOutlet weak var loginimageview: UIImageView?
    @IBOutlet weak var loginmsg: UILabel?
    @IBOutlet weak var loginbut: UIButton?
    var sections = ["FF","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    //var activityIndicator: UIActivityIndicatorView?
    var isLoadingContacts : Bool = false
    var refreshTable: UIRefreshControl!
    lazy var lazyImage:LazyImage = LazyImage()
     @IBOutlet weak var loginview: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set ProfileUpdate notification
        let notificationName = Notification.Name("_GetPermissionsForContact")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsTableViewController.GetPermissionsForContact), name: notificationName, object: nil)
        
        let notificationName1 = Notification.Name("_GetPermissionsForContactCancel")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsTableViewController.GetPermissionsForContactcancel), name: notificationName1, object: nil)
        
        let notificationName3 = Notification.Name("_isUserOnlineContacts")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsTableViewController.isUserOnline), name: notificationName3, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        storySearchBar?.delegate = self
        //storyTableView?.sectionIndexMinimumDisplayRowCount = 28
       // storySearchBar?.layer.masksToBounds = true;
        //storySearchBar?.layer.borderWidth = 1.0
        //storySearchBar?.layer.borderColor = self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
       // storySearchBar?.layer.cornerRadius = 10.0
        
        //if(refreshTable.isRefreshing == false)
        //{
            //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
            //self.activityIndicator?.startAnimating()
        //}

        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(ContactsTableViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        
        /*if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            storyTableView?.addSubview(refreshTable) // not required when using UITableViewContr
        }*/
        storyTableView?.addSubview(refreshTable)
        
        //Set Contacts synced notification
        let notificationName2 = Notification.Name("FetchedContactsDetails")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsTableViewController.FetchedContactsDetails), name: notificationName2, object: nil)
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let notified: String? = UserDefaults.standard.string(forKey: "notifiedcontact")
        if notified == nil
        {
            //Show notify before get permissions
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
            popController.notifyType = "contact"
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }        
        else{
            let strNonSplitContactsLocal: String? = UserDefaults.standard.string(forKey: "allNonSplitContacts")
            if strNonSplitContactsLocal == nil
            {
                notelable?.isHidden = false
                butcontacts?.isHidden = false
                storyTableView?.isHidden = true
                let bullet1 = "Sorry! Your Contacts are not synced yet."
                let bullet2 = "Please sync your Contacts first by tapping on Sync Contacts."
                //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
                // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
                
                strings = [bullet1, bullet2]
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
            else
            {
                //Alert
                notelable?.isHidden = true
                butcontacts?.isHidden = true
                storyTableView?.isHidden = false
                
            }
            finishSyncContacts()
            
        }
        }
        else{
            let but: String? = UserDefaults.standard.string(forKey: "contactloginmbut")
            loginbut?.setTitle(but, for: .normal)
            let message: String? = UserDefaults.standard.string(forKey: "contactloginmsg")
            loginmsg?.text = message
            
            let mediaurl: String? = UserDefaults.standard.string(forKey: "contactloginmurl")
            let mediatype: String? = UserDefaults.standard.string(forKey: "contactloginmtype")
            if(mediatype == "gif"){
                // messageimg.imageURL = mediaurl
                let arrReadselVideoPath = mediaurl!.components(separatedBy: "/")
                let imageId = arrReadselVideoPath.last
                let arrReadimageId = imageId?.components(separatedBy: ".")
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".gif")
                //try fileManager.removeItem(atPath: imageId)
                // Check if file exists
                if fileManager.fileExists(atPath: paths) {
                    //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "contacts", withExtension: "gif")!)
                    // let advTimeGif = UIImage.gifImageWithName("contacts")
                    // messageimg.image = advTimeGif
                    let fileName = arrReadimageId![0] + ".gif"
                    let fileURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(fileName)
                    if let imageData = NSData(contentsOf: fileURL!) {
                        _ = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                        loginimageview?.image = UIImage.gifImageWithData(imageData as Data)
                    }
                    
                    /* do {
                     if let imageData = NSData(contentsOfURL: paths) {
                     let image = UIImage(data: imageData) // Here you can attach image to UIImageView
                     }
                     let imageData = try Data(contentsOf: URL(string: paths)!)
                     messageimg.image = UIImage.gifImageWithData(imageData)
                     } catch {
                     print("Not able to load image")
                     }*/
                    
                }
                else{
                    loginimageview?.image = UIImage.gifImageWithURL(mediaurl!)
                }
                //
            }
            else{
                loginimageview?.imageURL = mediaurl
            }
            loginview?.isHidden = false
            storyTableView?.isHidden = true
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
     @IBAction  func AfterloginContactsync() {
       /* if ClassReachability.isConnectedToNetwork() {
            if isLoadingContacts == false
            {
                isLoadingContacts = true
                funGetSetContactsPermission()
            }
        }
        else
        {
            //Alert
            let message = "Please check your Internet connection."
            alertWithTitle(title: nil, message: message, ViewController: self)
        }*/
      /*  if ClassReachability.isConnectedToNetwork() {
           // if isLoadingContacts == false
            //{
            LoadingIndicatorView.show(self.view, loadingText: "Syncing your contacts. \nPlease be patient as this may take a few minutes.")
            

            appDelegate().allPhoneContacts = NSMutableArray()
            appDelegate().allAppContacts = NSMutableArray()
            //appDelegate().allContacts = NSMutableArray()
            appDelegate().phoneNotSplitContacts = NSMutableArray()
            
            //self.getPhoneContacts()
            DispatchQueue.background(background: {
                self.AddContacts()
            }, completion:{
                //self.refreshTable.endRefreshing()
                //self.storyTableView?.isScrollEnabled = true
            })
            //}
            
            // Code to refresh table view
            //Clear all array if refresh in progress
        }
        else
        {
           
            //Alert
            let message = "Please check your Internet connection."
            alertWithTitle(title: nil, message: message, ViewController: self)
            
        }*/
        let notified: String? = UserDefaults.standard.string(forKey: "notifiedcontact")
        if notified == nil
        {
            //Show notify before get permissions
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
            popController.notifyType = "contact"
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }
        else{
        funGetSetContactsPermission()
        }
        
    }
    @objc func GetPermissionsForContact(notification: NSNotification)
    {
        
        if ClassReachability.isConnectedToNetwork() {
            if isLoadingContacts == false
            {
                isLoadingContacts = true
                funGetSetContactsPermission()
            }
        }
        else
        {
            //Alert
            let message = "Please check your Internet connection."
            alertWithTitle(title: nil, message: message, ViewController: self)
        }
        
        
    }
    @objc func GetPermissionsForContactcancel(notification: NSNotification)
    {
       
            self.notelable?.isHidden = false
            self.butcontacts?.isHidden = false
            self.storyTableView?.isHidden = true
            let bullet1 = "Sorry! Your Contacts are not synced yet."
            let bullet2 = "Please sync your Contacts first by tapping on Sync Contacts."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            self.strings = [bullet1, bullet2]
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
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    @objc func isUserOnline()
    {
        if(appDelegate().isOnContactsView)
        {
            if ClassReachability.isConnectedToNetwork() {
                
                if(appDelegate().isUserOnline)
                {
                    LoadingIndicatorView.hide()
                    self.parent?.title = "Contacts"
                }
                else
                {
                    self.parent?.title = "Contacts"
                    //self.parent?.title = "Connecting.."
                }
                
                
            } else {
                self.parent?.title = "Waiting for network.."
                
            }
        }
        
    }

    
    @objc func refresh(_ sender:AnyObject) {
        
        
        if ClassReachability.isConnectedToNetwork() {
            if isLoadingContacts == false
            {
                isLoadingContacts = true
                funGetSetContactsPermission()
            }
            
            // Code to refresh table view
            //Clear all array if refresh in progress
        }
        else
        {
            storyTableView?.isScrollEnabled = true
            closeRefresh()
            storyTableView?.setContentOffset(CGPoint.zero, animated: true)
            //Alert
            let message = "Please check your Internet connection."
            alertWithTitle(title: nil, message: message, ViewController: self)
            
        }
        
        
        
        
    }
    
    @objc func FetchedContactsDetails(notification: NSNotification){
        
        
        
        DispatchQueue.main.async {
            // Update UI
            
            self.notelable?.isHidden = true
            self.butcontacts?.isHidden = true
            self.storyTableView?.isHidden = false
            self.appDelegate().isContactSync = false
            self.finishSyncContacts()
        }
        
        /*DispatchQueue.background(background: {
            self.finishSyncContacts()
        }, completion:{
            /*if(self.refreshTable.isRefreshing)
            {
                self.refreshTable.endRefreshing()
            }
            else
            {
                if(self.activityIndicator?.isAnimating)!
                {
                    self.activityIndicator?.stopAnimating()
                }
                
            }
            self.isLoadingContacts = false
            self.storyTableView?.isScrollEnabled = true*/
        })*/
    }
    
    func finishSyncContacts()
    {
        //Merge app contacts and phone contacts
        //appDelegate().allContacts[0] = appDelegate().allAppContacts
        //appDelegate().allContacts[1] = phoneContacts.sorted { ($0 as! NSDictionary)localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending}
        //Sort code
        /*phoneContacts = phoneContacts.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [[String:AnyObject]] as! NSMutableArray
         
         phoneNotSplitContacts = phoneContacts //.mutableCopy() as! NSMutableArray
         
         //Store contacts to local
         do {
         if(phoneNotSplitContacts.count > 0)
         {
         let dataNonSplitContacts = try JSONSerialization.data(withJSONObject: phoneNotSplitContacts, options: .prettyPrinted)
         let strNonSplitContacts = NSString(data: dataNonSplitContacts, encoding: String.Encoding.utf8.rawValue)! as String
         UserDefaults.standard.setValue(strNonSplitContacts, forKey: "allNonSplitContacts")
         UserDefaults.standard.synchronize()
         }
         } catch {
         print(error.localizedDescription)
         }*/
        sections = ["FF","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
        //print(phoneNotSplitContacts)
        appDelegate().allContacts = NSMutableArray()
        for section in sections
        {
            /*let result = phoneContacts.filter({ (text) -> Bool in
             let tmp: NSDictionary = text as! NSDictionary
             let val = tmp.value(forKey: "name")
             let range = (val as AnyObject).range(of: section, options: NSString.CompareOptions.caseInsensitive)
             return range.location != NSNotFound
             })
             
             if(result.count>0)
             {
             appDelegate().allContacts[appDelegate().allContacts.count] = result
             }*/
            if (section) == "FF" {
                let tmpArr = appDelegate().allAppContacts.sorted { (item1, item2) -> Bool in
                    let date1 =  item1 as! [String : AnyObject]
                    let date2 =  item2 as! [String : AnyObject]
                    
                    var dt1: String = ""
                    var dt2: String = ""
                    
                    if date1["name"] != nil
                    {
                        
                        dt1 = date1["name"] as! String
                        
                    }
                    
                    if date2["name"] != nil
                    {
                        
                        dt2 = date2["name"] as! String
                        
                    }
                    
                    
                    
                    return dt1.compare(dt2) == ComparisonResult.orderedAscending
                }
                appDelegate().allAppContacts = NSMutableArray()
                 var encountered = Set<String>()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                for arr in tmpArr
                {
                    let tmpDict = arr as! [String : AnyObject]
                     let Jid = tmpDict["jid"] as! String
                    if(!Jid.isEmpty){
                    if(!(myjid?.contains(Jid))!){
                        if encountered.contains(Jid) {
                            // Do not add a duplicate element.
                        }
                        else {
                            // Add value to the set.
                            encountered.insert(Jid)
                            // ... Append the value.
                            // result.append(value)nickname
                            //appDelegate().xmppRoster.addUser(XMPPJID(string:Jid)!, withNickname: tmpDict["nickname"] as! String?)
                            //appDelegate().xmppRoster.subscribePresence(toUser: XMPPJID(string:Jid)!)
                            
                            
                            appDelegate().allAppContacts.add(tmpDict)
                        }
                    }
                }
                    
                    
                    
                }
                if(appDelegate().allAppContacts.count > 0)
                {
                   appDelegate().allContacts[0] = appDelegate().allAppContacts
                }
                else
                {
                    //sections.remove(at: index)
                    if let index = sections.firstIndex(of:section) {
                        sections.remove(at: index)
                    }
                }
                
            } else if (section) == "#" {
                let predicateFormat = NSString(format: "name MATCHES[c] '[0-9].*'")
                let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
                
                let sectionArray = appDelegate().phoneNotSplitContacts.filtered(using: predicate)
                if(sectionArray.count > 0)
                {
                    appDelegate().allContacts[appDelegate().allContacts.count] = sectionArray
                }
                else
                {
                    //sections.remove(at: index)
                    if let index = sections.firstIndex(of:section) {
                        sections.remove(at: index)
                    }
                }
            } else {
                let predicateFormat = NSString(format: "name MATCHES[c] '(%@).*'", section)
                let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
                
                let sectionArray = appDelegate().phoneNotSplitContacts.filtered(using: predicate)
                if(sectionArray.count > 0)
                {
                    appDelegate().allContacts[appDelegate().allContacts.count] = sectionArray
                }
                else
                {
                    //sections.remove(at: index)
                    if let index = sections.firstIndex(of:section) {
                        sections.remove(at: index)
                    }
                }
            }
            
        }
        
        
        //print(phoneContacts)
        //print(appDelegate().allContacts)
        //Reload contacts table
        //Store contacts to local
        do {
            if(appDelegate().allContacts.count > 0)
            {
                let dataAllContacts = try JSONSerialization.data(withJSONObject: appDelegate().allContacts, options: .prettyPrinted)
                let strAllContacts = NSString(data: dataAllContacts, encoding: String.Encoding.utf8.rawValue)! as String
                UserDefaults.standard.setValue(strAllContacts, forKey: "allContacts")
                UserDefaults.standard.synchronize()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        storyTableView?.reloadData()
        
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
           
            
        }
        isLoadingContacts = false
        storyTableView?.isScrollEnabled = true
        
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
         self.storyTableView?.reloadData()
            if !self.appDelegate().isContactSync {
                TransperentLoadingIndicatorView.hide()
            }
         }
       /* NotificationCenter.default.addObserver(
            self,
            selector: #selector(addressBookDidChange),
            name: NSNotification.Name.CNContactStoreDidChange,
            object: nil)*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appDelegate().isOnContactsView = true
        
       NotificationCenter.default.addObserver(
            self,
            selector: #selector(addressBookDidChange),
            name: NSNotification.Name.CNContactStoreDidChange,
            object: nil)
        
     self.navigationItem.title = "Contacts"
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            loginview?.isHidden = true
           // storyTableView?.isHidden = false
        if ClassReachability.isConnectedToNetwork() {
            //self.parent?.title = "Contacts"
            self.parent?.title = "Contacts"
            /*if(appDelegate().isUserOnline)
            {
                self.parent?.title = "Contacts"
            }
            else
            {
                self.parent?.title = "Connecting.."
            }*/
            
        } else {
           self.parent?.title = "Waiting for network.."
            // LoadingIndicatorView.show(self, loadingText: "Loading")
            }}
        else{
            loginview?.isHidden = false
            storyTableView?.isHidden = true
        }
        
        self.parent?.navigationItem.rightBarButtonItems = nil
        //self.parent?.navigationItem.leftBarButtonItem = nil
        self.appDelegate().isUpdatesLoaded = false
        
        let settingsImage   = UIImage(named: "settings")!
        let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.showSettings))
        self.parent?.navigationItem.leftBarButtonItem = settingsButton
        print(appDelegate().isContactSync)
        if appDelegate().isContactSync {
            TransperentLoadingIndicatorView.show(view, loadingText: "")
        }
        
        /*if(appDelegate().allAppContacts.count == 0)
        {
            appDelegate().sendRequest()
        }*/
        //Code to check if all contacts synced already
        //print(appDelegate().allContacts)
        /*if(appDelegate().allContacts.count == 0 && isLoadingContacts == false)
        {
            let strAllContactsLocal: String? = UserDefaults.standard.string(forKey: "allContacts")
            if strAllContactsLocal != nil
            {
                //Code to parse json data
                if let data = strAllContactsLocal?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    do {
                        let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                        
                        for record in jsonData {
                            appDelegate().allAppContacts[appDelegate().allAppContacts.count] = record
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                //Fetch non split contacts for filter from local
                let strNonSplitContactsLocal: String? = UserDefaults.standard.string(forKey: "allNonSplitContacts")
                if strNonSplitContactsLocal != nil
                {
                    //Code to parse json data
                    if let data = strNonSplitContactsLocal?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do {
                            let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                            
                            for record in jsonData {
                                phoneNotSplitContacts[phoneNotSplitContacts.count] = record
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
                
            }
            else
            {
                self.getPhoneContacts()
            }
        }*/
        
        /*let notified: String? = UserDefaults.standard.string(forKey: "notifiedcontact")
        if notified != nil && isLoadingContacts == false
        {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // do stuff 3 seconds later
                //self.sendOfflineMessages()
                self.isLoadingContacts = true
                self.funGetSetContactsPermission()
                
            }
            
            
        }*/
        if(  appDelegate().allPhoneContacts.count == 0){
            let userD2: UserDefaults = UserDefaults(suiteName: "group.com.tridecimal.ltd.footballfan")!
            //let login: String? = userD2.string(forKey: "arrBanterSound")
            var allPhoneContacts = NSArray()
            
            let localAllcontacts: String? = userD2.string(forKey: "allPhoneContacts")
            if localAllcontacts != nil
            {
                //Code to parse json data
                if let data = localAllcontacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    do {
                        //appDelegate().allPhoneContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                        let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                        
                        for record in jsonData {
                             appDelegate().allPhoneContacts[ appDelegate().allPhoneContacts.count] = record
                        }
                    } catch let error as NSError {
                        // print(error)
                    }
                }
                 //finishSyncContacts()
            }
           
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate().isOnContactsView = false
    }
    
    @objc func showSettings() {
        print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    
    func funGetSetContactsPermission()
    {
       // self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
       // self.activityIndicator?.startAnimating()
        
       //LoadingIndicatorView.show(self.view, loadingText: "Syncing your contacts. \nPlease be patient as this may take a few minutes")
        TransperentLoadingIndicatorView.show(view, loadingText: "")
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .denied, .restricted:
            //1
           // storyTableView?.isHidden = false
            displayCantAddContactAlert()
            
            //print("Denied")
        case .authorized:
            //2
           // print("Authorized")
            //Code to check if all contacts synced already
            
            if(refreshTable.isRefreshing)
            {
                
                /* if(self.activityIndicator?.isAnimating)!
                 {
                 self.activityIndicator?.stopAnimating()
                 }*/
                TransperentLoadingIndicatorView.hide()
                appDelegate().allPhoneContacts = NSMutableArray()
                appDelegate().allAppContacts = NSMutableArray()
                //appDelegate().allContacts = NSMutableArray()
                appDelegate().phoneNotSplitContacts = NSMutableArray()
                
                //self.getPhoneContacts()
                DispatchQueue.background(background: {
                    self.AddContacts()
                }, completion:{
                    //self.refreshTable.endRefreshing()
                    //self.storyTableView?.isScrollEnabled = true
                })
            }
            else
            {
                if(appDelegate().allContacts.count == 0)
                {
                    let strAllContactsLocal: String? = UserDefaults.standard.string(forKey: "allContacts")
                    if strAllContactsLocal != nil
                    {
                        //Code to parse json data
                        if let data = strAllContactsLocal?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                            do {
                                let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                                
                                for record in jsonData {
                                    appDelegate().allContacts[appDelegate().allContacts.count] = record
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                        
                        //Fetch non split contacts for filter from local
                        let strNonSplitContactsLocal: String? = UserDefaults.standard.string(forKey: "allNonSplitContacts")
                        if strNonSplitContactsLocal != nil
                        {
                            //Code to parse json data
                            if let data = strNonSplitContactsLocal?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                do {
                                    let jsonData: NSArray = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                                    
                                    for record in jsonData {
                                        appDelegate().phoneNotSplitContacts[appDelegate().phoneNotSplitContacts.count] = record
                                    }
                                } catch let error as NSError {
                                    print(error)
                                }
                            }
                        }
                        
                       /* if(self.activityIndicator?.isAnimating)!
                        {
                            self.activityIndicator?.stopAnimating()
                        }*/
                        TransperentLoadingIndicatorView.hide()
                        
                        
                        
                    }
                    else
                    {
                        DispatchQueue.background(background: {
                            self.AddContacts()
                        }, completion:{
                            //self.refreshTable.endRefreshing()
                            //self.storyTableView?.isScrollEnabled = true
                        })
                    }
                }
                else
                {
                    /*DispatchQueue.background(background: {
                     self.getPhoneContacts()
                     }, completion:{
                     //self.refreshTable.endRefreshing()
                     //self.storyTableView?.isScrollEnabled = true
                     })*/
                   /* if(self.activityIndicator?.isAnimating)!
                    {
                        self.activityIndicator?.stopAnimating()
                    }*/
                    TransperentLoadingIndicatorView.hide()
                    
                }
            }
        case .notDetermined:
            //3
            
            promptForAddressBookRequestAccess()
           // print("Not Determined")
        }
    }
    
    func promptForAddressBookRequestAccess() {
        //var err: Unmanaged<CFError>? = nil
        addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            DispatchQueue.main.async() {
                if !granted {
                   /* if(self.activityIndicator?.isAnimating)!
                    {
                        self.activityIndicator?.stopAnimating()
                    }*/
                    //LoadingIndicatorView.hide()
                    self.displayCantAddContactAlert()
                   // print("Just denied")
                } else {
                   // print("Just authorized")
                    self.AddContacts()
                }
            }
        }
    }
    
    @objc func addressBookDidChange(notification: NSNotification){
        //Handle event here...
         //getPhoneContacts()
       // DispatchQueue.main.async {
        //appDelegate().AddContacts()
        //}
        //alertWithTitle(title: "Alert", message: "Contact change", ViewController: self)
    }
    
    
    func AddContacts()
    {
        // LoadingIndicatorView.show(self.view, loadingText: "Syncing your contacts. Please be patient as this may take few minutes.")
        isLoadingContacts = true
        
        appDelegate().isContactSync = true
        DispatchQueue.main.async {
            self.storyTableView?.isScrollEnabled = false
        }
        appDelegate().AddContactsView()
    }
    
   /* func getPhoneContacts() {
        
        /*if(refreshTable.isRefreshing == false)
        {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
            self.activityIndicator?.startAnimating()
        }*/
        
        //Show loader
        isLoadingContacts = true
        
        storyTableView?.isScrollEnabled = false
        
        addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as Array
        //var arrMobiles = [String]()
        var arrMobiles = [[String: String]]()
        //var petContact: ABRecordRef?
        for record in allContacts {
            let currentContact: ABRecord = record
            //let currentContactName = ABRecordCopyCompositeName(currentContact).takeRetainedValue() as String
            //print(currentContactName)
            ////if let currentContactName = ABRecordCopyValue(currentContact, ABPropertyID(kABPersonCompositeNameFormatFirstNameFirst))?.takeRetainedValue() as? String {
            
            /*if let name = ABRecordCopyValue(currentContact, kABPersonFirstNameProperty).takeRetainedValue() as? String {
                print(name)//persons name
            }*/
            if let currentContactName = ABRecordCopyValue(currentContact, kABPersonFirstNameProperty)?.takeRetainedValue() as? String
            {
                var currentContactLName = ""
                if let lname = ABRecordCopyValue(currentContact, kABPersonLastNameProperty)?.takeRetainedValue() as? String {
                    currentContactLName = lname
                }
                 // extra code by nitesh
              /* var currentContactLemail = ""
               if let email = ABRecordCopyValue(currentContact, kABPersonEmailProperty)?.takeRetainedValue() as? String {
                   currentContactLemail = email
                }
                //print(currentContactLName)
                let email:ABMultiValue = ABRecordCopyValue(
                    currentContact, kABPersonEmailProperty).takeRetainedValue()
                
                if(ABMultiValueGetCount(email) > 0){
                currentContactLemail=ABMultiValueCopyValueAtIndex(email,0).takeRetainedValue() as! String
                } */
                //print("NEmail: " + currentContactLemail)
            //if let currentContactName = ABRecordCopyCompositeName(currentContact)?.takeRetainedValue() {
                let numbers:ABMultiValue = ABRecordCopyValue(
                    currentContact, kABPersonPhoneProperty).takeRetainedValue()
                if(ABMultiValueGetCount(numbers) > 0)
                {
                    for ix in 0 ..< ABMultiValueGetCount(numbers)
                    {
                        //let label = ABMultiValueCopyLabelAtIndex(numbers,ix).takeRetainedValue() as String
                        let value:String = ABMultiValueCopyValueAtIndex(numbers,ix).takeRetainedValue() as! String
                        //Contains check should be here
                        
                        //Code to get actual number
                        //# -;$&()*._/!%<>?
                        
                        //let trimmed: String = appDelegate().removeSpecialCharsFromString(str: value)
                        
                        let trimmed: String = value.components(separatedBy: CharacterSet.decimalDigits.inverted)
                            .joined()
                        
                        var strMobileNo = "";
                        if(value.hasPrefix("+"))
                        {
                            strMobileNo = "+" + trimmed
                        } else {
                            strMobileNo = trimmed
                        }
                        
                        
                        //let reversed: String = String(trimmed.characters.reversed())
                        //print(reversed)
                        //Check if number is above 10 digits
                        //if(reversed.characters.count >= 10)
                        //{
                        //let index10 = reversed.index(reversed.startIndex, offsetBy: 10)
                        //let first10: String = reversed.substring(to: index10)
                        //print(first10)
                        //let strMobileNo: String = String(first10.characters.reversed())
                        //print("Phonenumber" + strMobileNo)
                        
                        /*let result = phoneContacts.filter({ (text) -> Bool in
                         let tmp: NSDictionary = text as! NSDictionary
                         let val = tmp.value(forKey: "mobile")
                         let range = (val as AnyObject).range(of: value, options: NSString.CompareOptions.caseInsensitive)
                         return range.location != NSNotFound
                         })
                         
                         if(result.count == 0)
                         {*/
                        
                        
                        let result = appDelegate().allPhoneContacts.filter({ (text) -> Bool in
                            let tmp: NSDictionary = text as! NSDictionary
                            let val: String = tmp.value(forKey: "mobile") as! String
                            return val.contains(strMobileNo)
                        })
                        
                        if(result.count == 0)
                        {
                            var tempDict = [String: String]()
                            
                            tempDict["jid"] = ""
                            tempDict["name"] = currentContactName + " " + currentContactLName //as String
                            tempDict["nickname"] = ""
                            tempDict["mobile"] = strMobileNo
                            // tempDict["email"] = currentContactLemail
                            tempDict["avatar"] = ""
                            tempDict["status"] = value
                            tempDict["type"] = "phone"
                            tempDict["phoneimage"] = "phone"
                            var tempDict1 = [String: String]()
                            
                            
                            tempDict1["mobile"] = strMobileNo
                            //print(strMobileNo)
                            
                            var strMobilewithcc = ""
                            
                            if(strMobileNo.hasPrefix("+"))
                            {
                                strMobilewithcc = strMobileNo
                            } else if(strMobileNo.hasPrefix("00"))
                            {
                                strMobilewithcc =  "+" + String(strMobileNo.dropFirst(2))
                            } else if (strMobileNo.hasPrefix("0"))
                            {
                                strMobilewithcc = "+" + UserDefaults.standard.string(forKey: "usercountrycode")! + String(strMobileNo.dropFirst(1))
                            } else {
                                strMobilewithcc = "+" + UserDefaults.standard.string(forKey: "usercountrycode")! + strMobileNo
                            }
                            tempDict["mobilewithcc"] = strMobilewithcc
                            
                            // tempDict1["email"] = currentContactLemail
                            //dataContacts.insert(tempDict as AnyObject, at: ix)
                            //print(tempDict["name"] ?? "Name")
                            //print(tempDict["mobile"] ?? "Name")
                            appDelegate().allPhoneContacts[appDelegate().allPhoneContacts.count] = tempDict
                            //code by Ravi sir
                            //arrMobiles.insert(strMobileNo, at: arrMobiles.count)
                            
                            //code by nitesh
                            arrMobiles.append(tempDict1)
                            //print(appDelegate().allPhoneContacts.count)
                            //}
                            
                            
                            
                            /*}*/
                            
                        }
                        
                    }
                }
                /* else if(currentContactLemail != ""){
                    var tempDict = [String: String]()
                    
                    tempDict["jid"] = ""
                    tempDict["name"] = currentContactName + " " + currentContactLName //as String
                    tempDict["nickname"] = ""
                    tempDict["mobile"] = ""
                    tempDict["email"] = currentContactLemail
                    tempDict["avatar"] = ""
                    tempDict["status"] = ""
                    tempDict["type"] = "phone"
                    var tempDict1 = [String: String]()
                    tempDict1["mobile"] = ""
                    tempDict1["email"] = currentContactLemail
                    //dataContacts.insert(tempDict as AnyObject, at: ix)
                    //print(tempDict["name"] ?? "Name")
                    //print(tempDict["mobile"] ?? "Name")
                    appDelegate().allPhoneContacts[appDelegate().allPhoneContacts.count] = tempDict
                    //code by Ravi sir
                    //arrMobiles.insert(strMobileNo, at: arrMobiles.count)
                    
                    //code by nitesh
                    arrMobiles.append(tempDict1)
                } */
            }
            
            
        }
        if(appDelegate().allPhoneContacts.count > 0)
        {
            
            //code to save non split contacts
            //For Temp hide
            let tmpArr = appDelegate().allPhoneContacts.sorted { (item1, item2) -> Bool in
                let date1 =  item1 as! [String : AnyObject]
                let date2 =  item2 as! [String : AnyObject]
                
                var dt1: String = ""
                var dt2: String = ""
                
                if date1["name"] != nil
                {
                    
                    dt1 = date1["name"] as! String
                    
                }
                
                if date2["name"] != nil
                {
                    
                    dt2 = date2["name"] as! String
                    
                }
                
                
                
                return dt1.compare(dt2) == ComparisonResult.orderedAscending
            }
            appDelegate().allPhoneContacts = NSMutableArray()
            var encountered = Set<String>()
            for arr in tmpArr
            {
                let tmpDict = arr as! [String : AnyObject]
                let Jid = tmpDict["name"] as! String
                if encountered.contains(Jid) {
                    // Do not add a duplicate element.
                }
                else {
                    // Add value to the set.
                    encountered.insert(Jid)
                    // ... Append the value.
                    // result.append(value)
                    
                    appDelegate().allPhoneContacts.add(tmpDict)
                }
                
                
                
            }
            
            
                    appDelegate().phoneNotSplitContacts = appDelegate().allPhoneContacts //.mutableCopy() as! NSMutableArray
            
            //Store contacts to local
            do {
                if(appDelegate().phoneNotSplitContacts.count > 0)
                {
                    let dataNonSplitContacts = try JSONSerialization.data(withJSONObject: appDelegate().phoneNotSplitContacts, options: .prettyPrinted)
                    let strNonSplitContacts = NSString(data: dataNonSplitContacts, encoding: String.Encoding.utf8.rawValue)! as String
                    UserDefaults.standard.setValue(strNonSplitContacts, forKey: "allNonSplitContacts")
                    UserDefaults.standard.synchronize()
                }
            } catch {
                print(error.localizedDescription)
            }
            
            //let strMobiles = ""
           
            
            //appDelegate().sendRequestToGetContactsFromAPI(strContacts: "{\"cmd\":\"contactsync\",\"requestData\":{\"Mobile\":[\"9977564444\",\"8819096521\"]}}")
            
        }
    }*/
    
    func openSettings() {
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
        isLoadingContacts = false
        appDelegate().isContactSync = false
        storyTableView?.isScrollEnabled = true
        
        let url = NSURL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(url! as URL)
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
        isLoadingContacts = false
        appDelegate().isContactSync = false
        storyTableView?.isScrollEnabled = true
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
                                                    message: "You must give the app permission to add the contact first.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.notelable?.isHidden = false
            self.butcontacts?.isHidden = false
            self.storyTableView?.isHidden = true
            let bullet1 = "Sorry! Your Contacts are not synced yet."
            let bullet2 = "Please sync your Contacts first by tapping on Sync Contacts."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            self.strings = [bullet1, bullet2]
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
            self.closeRefresh()
            TransperentLoadingIndicatorView.hide()
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ContactsTableViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ContactsTableViewController.realDelegate!;
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        storySearchBar?.showsCancelButton = true
        searchStarting = true
        storyTableView?.reloadData()
        //searchActive = true
    }
    
    /*func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }*/
    
    /*func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        //let but: UIButton = searchBar.value(forKey: "_cancelButton") as! UIButton
        //but.isUserInteractionEnabled = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    
        return true;
    }*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        storySearchBar?.text = ""
        phoneFilteredContacts = appDelegate().allPhoneContacts.mutableCopy() as! NSMutableArray
        storySearchBar?.resignFirstResponder()
        storySearchBar?.showsCancelButton = false
        searchActive = false
        searchStarting = false
        noContactFound?.isHidden = true
        storyTableView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        //storySearchBar?.text = ""
        //phoneFilteredContacts = appDelegate().allPhoneContacts.mutableCopy() as! NSMutableArray
        storySearchBar?.resignFirstResponder()
        if let cancelButton = storySearchBar?.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        searchActive = true
        searchStarting = true
        //storySearchBar?.showsCancelButton = false
        //searchActive = false;
        //storyTableView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         phoneFilteredContacts = NSMutableArray()
        let result = appDelegate().allAppContacts.filter({ (text) -> Bool in
            let tmp: NSDictionary = text as! NSDictionary
            let val = tmp.value(forKey: "name")
            let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        let result1 = appDelegate().phoneNotSplitContacts.filter({ (text) -> Bool in
            let tmp: NSDictionary = text as! NSDictionary
            let val = tmp.value(forKey: "name")
            let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        for record in result {
            phoneFilteredContacts[phoneFilteredContacts.count] = record
        }
        for record1 in result1 {
            phoneFilteredContacts[phoneFilteredContacts.count] = record1
        }

       /* if(result.count>0)
        {
            phoneFilteredContacts = NSMutableArray(array: result)//result as! NSMutableArray
        }
        else
        {
            phoneFilteredContacts = NSMutableArray()
        }
        if(result1.count>0)
        {
            
            for record in result1 {
                phoneFilteredContacts[phoneFilteredContacts.count] = record
            }
           // phoneFilteredContacts = NSMutableArray(array: result1)//result as! NSMutableArray
        }
        else
        {
            if(result.count == 0)
            {
            phoneFilteredContacts = NSMutableArray()
            }
        }*/
        /*let predicateFormat = NSString(format: "name MATCHES[c] '(%@).*'", searchText)
        let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
        
        let sectionArray = phoneNotSplitContacts.filtered(using: predicate)
        if(sectionArray.count > 0)
        {
            phoneFilteredContacts[phoneFilteredContacts.count] = sectionArray
        }*/
        
        if(phoneFilteredContacts.count == 0){
            noContactFound?.isHidden = false
            showNocontactfound()
        } else {
           noContactFound?.isHidden = true
        }
        searchActive = true
        storyTableView?.reloadData()
    }
    func showNocontactfound(){
        let bullet1 = "Sorry! No contacts found for your search criteria."
        let bullet2 = "Please try a different search criteria."
        //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
        // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
        
        strings = [bullet1, bullet2]
        // let boldText  = "Quick Information \n"
        let attributesDictionary = [kCTForegroundColorAttributeName : noContactFound?.font]
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
        
        
        noContactFound?.attributedText = fullAttributedString
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(searchActive) {
            return "Search Results"
        }
        else if(self.sections[section] == "FF")
        {
            return "Football Fan Contacts"
        }
        
        return self.sections[section]
        
    }
    
    //Number of sections count in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(appDelegate().allContacts)
        //print(appDelegate().allContacts.count)
        
        if(searchActive) {
            return 1
        }
        
        return appDelegate().allContacts.count
        
    }
    
    /*func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        if(searchActive) {
            return nil
        }
        
        return sectionsIndex.map { $0 as AnyObject }
        
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        if(searchActive) {
            return 0
        }
        
        let currentCollation = UILocalizedIndexedCollation.current() as UILocalizedIndexedCollation
        return currentCollation.section(forSectionIndexTitle: index)
    }*/
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if(searchStarting) {
            return [""]
        }
        if(searchActive) {
            return [""]
        }
        
        //let currentCollation = UILocalizedIndexedCollation.current() as UILocalizedIndexedCollation
        return self.sections//(currentCollation.sectionIndexTitles as NSArray) as? [String]
    }
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.animals.count
        
        /*if(searchActive) {
            return (dataFilteredCountries!.count)
        }*/
        
        if(searchActive){
            return phoneFilteredContacts.count
        }
        
        return ((appDelegate().allContacts[section] as AnyObject).count)
        //return (appDelegate().allAppContacts.count)
    }
   

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " " + self.sections[section]
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
        if(section == 0)
        {
            if(searchActive) {
                label.text = " " + "Search Results"
                headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
            }
            else if(self.sections[section] == "FF")
            {
                label.text = " " + "Football Fan Contacts"
                headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
            }
            else{
                headerView.backgroundColor = UIColor(hex: "9A9A9A")
            }
            
        }
        else
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        }
        
        
        
        
        return headerView
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ContactsCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCell
        //print(phoneFilteredContacts)
        if(searchActive){
            cell.btnInvite?.isHidden = false
            //let arry: NSArray? = phoneFilteredContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            //cell.contactImage?.isHidden = true
            //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
            //cell.contactName?.frame.origin.x = 15.0
            //cell.contactStatus?.frame.origin.x = 15.0
            //cell.contactImage?.image = UIImage(named: "phone")
            let type = dict?.value(forKey: "type") as? String
          /*  if(type == "phone")
            {
                cell.btnInvite?.isHidden = false
            }
            else{
                  cell.btnInvite?.isHidden = true
            }
            if(dict?.value(forKey: "phoneimage") != nil)
            {
                let avatar:String = (dict?.value(forKey: "phoneimage") as? String)!
                if(!avatar.isEmpty)
                {
                    cell.contactImage?.image = UIImage(named: "phone")
                    
                }
            }*/
            if(type == "phone")
            {
                cell.btnInvite?.isHidden = false
                //cell.contactImage?.isHidden = true
                //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
                //cell.contactName?.frame.origin.x = 15.0
                //cell.contactStatus?.frame.origin.x = 15.0
                //cell.contactImage?.image = UIImage(named: "phone")
                if(dict?.value(forKey: "phoneimage") != nil)
                {
                    let avatar:String = (dict?.value(forKey: "phoneimage") as? String)!
                    if(!avatar.isEmpty)
                    {
                        cell.contactImage?.image = UIImage(named: "phone")
                        
                    }
                }
                else{
                    cell.contactImage?.image = UIImage(named: "phone")
                }
                
                
            }
            else
            {
                cell.btnInvite?.isHidden = true
                cell.contactImage?.isHidden = false
                //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
                cell.contactName?.frame.origin.x = 55.0
                cell.contactStatus?.frame.origin.x = 55.0
                if(dict?.value(forKey: "avatar") != nil)
                {
                    let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                    if(!avatar.isEmpty)
                    {
                        let arrReadselVideoPath = avatar.components(separatedBy: "/")
                        let imageId = arrReadselVideoPath.last
                        let arrReadimageId = imageId?.components(separatedBy: ".")
                        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                        let url = NSURL(string: avatar)!
                        let filenameforupdate = arrReadimageId![0] as String
                        do {
                            let fileManager = FileManager.default
                            //try fileManager.removeItem(atPath: imageId)
                            // Check if file exists
                            if fileManager.fileExists(atPath: paths) {
                                // Delete file
                                //print("File  exist")
                                
                                if(!paths.isEmpty)
                                {
                                    //let path_file = "file://" + paths
                                    let imageURL = URL(fileURLWithPath: paths)
                                    cell.contactImage?.image = UIImage(contentsOfFile: imageURL.path)
                                }
                            } else {
                                // print("File does not exist")
                                appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                                
                                let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                                    // if responseData is not null...
                                    if let data = responseData{
                                        
                                        // execute in UI thread
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            let filePath = self.saveFanImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: filenameforupdate)
                                            //print(filePath)
                                            
                                        })
                                    }
                                    else{
                                         cell.contactImage?.image = UIImage(named: "avatar")
                                    }
                                    
                                }
                                
                                // Run task
                                task.resume()
                                //End Code to fetch media from live URL
                                
                            }
                            
                        }
                        catch let error as NSError {
                            print("An error took place: \(error)")
                            // LoadingIndicatorView.hide()
                            TransperentLoadingIndicatorView.hide()
                        }
                        
                    }
                }
                else
                {
                    cell.contactImage?.image = UIImage(named: "avatar")
                }
            }
            
            
        }
        else
        {
            //print(appDelegate().allContacts)
            let arry: NSArray? = appDelegate().allContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = arry?[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            let type = dict?.value(forKey: "type") as? String
            if(type == "phone")
            {
                cell.btnInvite?.isHidden = false
                //cell.contactImage?.isHidden = true
                //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
                //cell.contactName?.frame.origin.x = 15.0
                //cell.contactStatus?.frame.origin.x = 15.0
                //cell.contactImage?.image = UIImage(named: "phone")
              /*  if(dict?.value(forKey: "phoneimage") != nil)
                {
                    let avatar:String = (dict?.value(forKey: "phoneimage") as? String)!
                    if(!avatar.isEmpty)
                    {
                        cell.contactImage?.image = UIImage(named: "phone")
                        
                    }
                }
                else{
                    cell.contactImage?.image = UIImage(named: "phone")
                }*/
                
                cell.contactImage?.image = UIImage(named: "phone")
            }
            else
            {
                cell.btnInvite?.isHidden = true
                cell.contactImage?.isHidden = false
                //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
                cell.contactName?.frame.origin.x = 55.0
                cell.contactStatus?.frame.origin.x = 55.0
                if(dict?.value(forKey: "avatar") != nil)
                {
                    let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                    if(!avatar.isEmpty)
                    {
                        let arrReadselVideoPath = avatar.components(separatedBy: "/")
                        let imageId = arrReadselVideoPath.last
                        let arrReadimageId = imageId?.components(separatedBy: ".")
                        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                        let url = NSURL(string: avatar)!
                        let filenameforupdate = arrReadimageId![0] as String
                        do {
                            let fileManager = FileManager.default
                            //try fileManager.removeItem(atPath: imageId)
                            // Check if file exists
                            if fileManager.fileExists(atPath: paths) {
                                // Delete file
                                //print("File  exist")
                                
                                if(!paths.isEmpty)
                                {
                                    //let path_file = "file://" + paths
                                    let imageURL = URL(fileURLWithPath: paths)
                                    cell.contactImage?.image = UIImage(contentsOfFile: imageURL.path)
                                }
                            } else {
                                if(type != "phone")
                                {
                                // print("File does not exist")
                               // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                                self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "avatar")
                                let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                                    // if responseData is not null...
                                    if let data = responseData{
                                        
                                        // execute in UI thread
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            _ = self.saveFanImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: filenameforupdate)
                                            //print(filePath)
                                            
                                        })
                                    }
                                    
                                }
                                
                                // Run task
                                task.resume()
                                //End Code to fetch media from live URL
                                }
                            }
                            
                        }
                        catch let error as NSError {
                            print("An error took place: \(error)")
                           // LoadingIndicatorView.hide()
                            
                        }
                        
                    }
                }
                else
                {
                    cell.contactImage?.image = UIImage(named: "avatar")
                }
            }
        }
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("You tapped cell number \(indexPath.row).")
        if(searchActive == false){
            //print(appDelegate().allContacts)
            let arry: NSArray? = appDelegate().allContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = arry?[indexPath.row] as? NSDictionary
            
            let type = dict?.value(forKey: "type") as? String
            if(type == "app")
            {
                //appDelegate().toUserJID = (dict?.value(forKey: "jid") as? String)!
               // appDelegate().toName = (dict?.value(forKey: "name") as? String)!
                if let tmpAvatar = dict?.value(forKey: "avatar")
                {
                    appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
                }
                else
                {
                    appDelegate().toAvatarURL = ""
                }
                
                showChatWindow(roomid: (dict?.value(forKey: "jid") as? String)!)
            }
        }
        else{
            //let arry: NSArray? = phoneFilteredContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
            
            let type = dict?.value(forKey: "type") as? String
            if(type == "app")
            {
                //appDelegate().toUserJID = (dict?.value(forKey: "jid") as? String)!
                //appDelegate().toName = (dict?.value(forKey: "name") as? String)!
                if let tmpAvatar = dict?.value(forKey: "avatar")
                {
                    appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
                }
                else
                {
                    appDelegate().toAvatarURL = ""
                }
                
                showChatWindow(roomid: (dict?.value(forKey: "jid") as? String)!)
            }
        }
 
        /* self.dismiss(animated: true, completion: nil)*/
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
    
    func showChatWindow(roomid:String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                       myTeamsController.RoomJid = roomid//dict.value(forKey: "jid") as! String //+ JIDPostfix
                                        show(myTeamsController, sender: self)
        /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "Chat")
        //present(registerController as! UIViewController, animated: true, completion: nil)
        self.appDelegate().curRoomType = "chat"
         appDelegate().isBanterClosed = ""
        show(registerController as! UIViewController, sender: self)*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func invite(_ sender: UIButton) {
        if MFMessageComposeViewController.canSendText() == true {
            
            var indexPath: NSIndexPath!
            
            
                if let superview = sender.superview?.superview {
                    if let cell = superview.superview as? ContactsCell {
                        indexPath = storyTableView!.indexPath(for: cell)! as NSIndexPath
                        //print(indexPath.section)
                        //print(indexPath.row)
                    }
                }
            
            //Code to get contact number
            var mobile: String = ""
            if(searchActive)
            {
                let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
                mobile = dict?.value(forKey: "status") as! String //Status has actual number fetched from phone
            }
            else
            {
                let arry: NSArray? = appDelegate().allContacts[indexPath.section] as? NSArray
                let dict: NSDictionary? = arry?[indexPath.row] as? NSDictionary
                mobile = dict?.value(forKey: "mobile") as! String
            }
            
            let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!

            //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
            let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
            let userReadUserJid = arrReadUserJid[0]
            let recipients:[String] = [mobile]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = "Check out this cool app called \"Football Fan\". I use it watch Football videos, create stories, banter, find fans, news and collect FanCoins rewards.\n\nGet it free for your iPhone or Android phone at:\nwww.ifootballfan.com/app\n\nSign Up to the app and you will instantly get \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsignup)) FanCoins rewards.\n\nUse my referral code \"\(userReadUserJid)\" during Sign Up to collect extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins."//"Check out this cool app called \"Football Fan\". I use it to earn FanCoins, participate in Football banter, post my Football stories, find fans nearby, Football news from around the world, share messages, pictures and videos.\n\nGet it free for your iPhone at:\nhttps://apple.co/2OSoN6p\nGet it free for your Android phone at:\nhttp://bit.ly/ff8g \n\nUse my referral code \"\(userReadUserJid)\" to earn extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins."
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if(searchActive)
        {
            if let cancelButton = storySearchBar?.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func modleAction(){
        let action: String? = UserDefaults.standard.string(forKey: "contactloginaction")
        if(action == "login"){
            appDelegate().LoginwithModelPopUp()
            
        }
    }
}
