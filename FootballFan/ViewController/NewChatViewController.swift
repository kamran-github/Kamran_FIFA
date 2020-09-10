//
//  NewChatViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 13/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var storyTableView: UITableView?
    var phoneFilteredContacts = NSMutableArray()
    var newChatAppContacts = NSMutableArray()
    let cellReuseIdentifier = "newchat"
    var searchActive : Bool = false
     var strings:[String] = []
    var searchStarting : Bool = false
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var butcontacts: UIButton?
       @IBOutlet weak var storySearchBar: UISearchBar?
    lazy var lazyImage:LazyImage = LazyImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
         storySearchBar?.delegate = self
        //self.storyTableView?.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "New Chat"
        let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
        if strAllContacts != nil
        {
            //Code to parse json data
            if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    //appDelegate().allContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray as! NSMutableArray
                    let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                    
                    appDelegate().allContacts = NSMutableArray()
                    for record in tmpAllContacts {
                        appDelegate().allContacts[appDelegate().allContacts.count] = record
                    }
                    
                    //appDelegate().allContacts = tmpAllAppContacts as! NSMutableArray
                    //newChatAppContacts = appDelegate().allContacts[0] as! NSMutableArray
                    
                    let tmpAllAppContacts = appDelegate().allContacts[0] as! NSArray
                    
                    //newChatAppContacts = NSMutableArray()
                    
                    var tempDict = [String: String]()
                    
                    tempDict["jid"] = ""
                    tempDict["name"] = "New Group"
                    tempDict["nickname"] = ""
                    tempDict["mobile"] = ""
                    tempDict["avatar"] = ""
                    tempDict["status"] = ""
                    tempDict["type"] = "button"
                    
                    newChatAppContacts[newChatAppContacts.count] = tempDict
                    
                    for record in tmpAllAppContacts {
                        newChatAppContacts[newChatAppContacts.count] = record
                    }
                    
                    //print(newChatAppContacts)
                    
                    /*var size = 0
                     repeat {
                     let colour = "clear"
                     tmpSelected.add(colour)
                     // Increment.
                     size += 1
                     
                     } while size < newChatAppContacts.count*/
                    let tmpArryContact = NSMutableArray()
                    if(newChatAppContacts.count > 0)
                    {
                        for rec in newChatAppContacts
                        {
                            var dict: [String : String] = rec as! [String : String]
                            dict["image"] = "uncheck"
                            tmpArryContact[tmpArryContact.count] = dict
                        }
                    }
                    
                    if(tmpArryContact.count > 0)
                    {
                        newChatAppContacts = tmpArryContact
                    }
                    
                    
                    //print(tmpSelected.count)
                    //print(newChatAppContacts.count)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            notelable?.isHidden = true
            butcontacts?.isHidden = true
            storyTableView?.isHidden = false
            storyTableView?.reloadData()
        }
        else{
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction  func showContactWindow() {
       // appDelegate().showMainTab()
        //showMainTab
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let notificationName = Notification.Name("tabindexchange")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }*/
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       
            let registerController : ContactsTableViewController! = storyBoard.instantiateViewController(withIdentifier: "Contacts") as? ContactsTableViewController
            show(registerController, sender: self)
    }
    
    // MARK: - Table view data source
    
   /* func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(searchActive) {
            return "Search Results"
        }
        
        return nil //"Football Fan Contacts"
        
    }*/
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
           
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive){
            return phoneFilteredContacts.count
        }
        
        return ((newChatAppContacts as AnyObject).count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewChatCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! NewChatCell
        //print(phoneFilteredContacts)
        if(searchActive){
            //let arry: NSArray? = phoneFilteredContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
           // cell.contactImage?.isHidden = true
            //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
            //cell.contactName?.frame.origin.x = 15.0
            //cell.contactStatus?.frame.origin.x = 15.0
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
             cell.bottomConstraint3.constant = CGFloat(10.0)
            let name = dict?.value(forKey: "name") as? String
            if(name == "New Group"){
                 cell.bottomConstraint3.constant = CGFloat(17.0)
            }
            if(dict?.value(forKey: "avatar") != nil)
            {
                let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                if(!avatar.isEmpty)
                {
                    //appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                    let arrReadselVideoPath = avatar.components(separatedBy: "/")
                    let imageId = arrReadselVideoPath.last
                    let arrReadimageId = imageId?.components(separatedBy: ".")
                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                    //let url = NSURL(string: avatar)!
                    //let filenameforupdate = arrReadimageId![0] as String
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
                            // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                            self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "avatar")
                        }
                    }catch let error as NSError {
                        print("An error took place: \(error)")
                        // LoadingIndicatorView.hide()
                        
                    }
                    //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                }
                else
                {
                    if(indexPath.row == 0)
                    {
                        cell.contactImage?.image = UIImage(named: "new_group")
                    }
                    else
                    {
                        cell.contactImage?.image = UIImage(named: "user")
                    }
                    
                }
            }
            else
            {
                //cell.contactImage?.image = UIImage(named: "user")
                if(indexPath.row == 0)
                {
                    cell.contactImage?.image = UIImage(named: "new_group")
                }
                else
                {
                    cell.contactImage?.image = UIImage(named: "user")
                }
            }
            
        }
        else
        {
            
            //let arry: NSArray? = newChatAppContacts[indexPath.row] as? NSArray
            let dict: NSDictionary? = newChatAppContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            cell.bottomConstraint3.constant = CGFloat(10.0)
            let name = dict?.value(forKey: "name") as? String
            if(name == "New Group"){
                cell.bottomConstraint3.constant = CGFloat(17.0)
            }
            if(dict?.value(forKey: "avatar") != nil)
            {
                let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                if(!avatar.isEmpty)
                {
                   // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                    let arrReadselVideoPath = avatar.components(separatedBy: "/")
                    let imageId = arrReadselVideoPath.last
                    let arrReadimageId = imageId?.components(separatedBy: ".")
                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                   // _ = NSURL(string: avatar)!
                   // _ = arrReadimageId![0] as String
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
                            // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                            self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "avatar")
                        }
                    }catch let error as NSError {
                        print("An error took place: \(error)")
                        // LoadingIndicatorView.hide()
                        
                    }
                    //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                }
                else
                {
                    if(indexPath.row == 0)
                    {
                        cell.contactImage?.image = UIImage(named: "new_group")
                    }
                    else
                    {
                        cell.contactImage?.image = UIImage(named: "avatar")
                    }
                    
                }
            }
            else
            {
                //cell.contactImage?.image = UIImage(named: "user")
                if(indexPath.row == 0)
                {
                    cell.contactImage?.image = UIImage(named: "new_group")
                }
                else
                {
                    cell.contactImage?.image = UIImage(named: "avatar")
                }
            }
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath) as! ForwardCell
        
        //Check if row == 0 then show Create new group window else show chat window for selected contact
        storySearchBar?.resignFirstResponder()
        self.dismiss(animated: false, completion: nil)
        
        if(searchActive){
            let dict: NSDictionary = phoneFilteredContacts[indexPath.row] as! NSDictionary
            let name = dict.value(forKey: "name") as? String
            if(name == "New Group"){
                //showCreateNewGroup()
               /* let showType:[String: String] = ["type": "group"]
                let notificationName = Notification.Name("ShowGroupOrChatWindow")
                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)*/
                showCreateNewGroup()
            }
            else{
            let userJid = (dict.value(forKey: "jid") as? String)!
           // appDelegate().toName = (dict.value(forKey: "name") as? String)!
               // appDelegate().toUserJID = userJid
            if let tmpAvatar = dict.value(forKey: "avatar")
            {
                appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
            }
            else
            {
                appDelegate().toAvatarURL = ""
            }
            
            //let showType:[String: String] = ["type": "chat", "jid": userJid]
           // let notificationName = Notification.Name("ShowGroupOrChatWindow")
            //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)
                showChatWindow(roomid: userJid)
               // LoadingIndicatorView.show((appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while loading Messages")
                
// self.appDelegate().toUserJID =
                 appDelegate().isFromNewChat = true
                /*let showType:[String: String] = ["type": "chat", "jid": userJid]
                let notificationName = Notification.Name("ShowGroupOrChatWindow")
                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)*/
            }
        }
        else{
         let dict: NSDictionary = newChatAppContacts[indexPath.row] as! NSDictionary
        
       
        let name = dict.value(forKey: "name") as? String
        if(name == "New Group"){
            //showCreateNewGroup()
            /*let showType:[String: String] = ["type": "group"]
            let notificationName = Notification.Name("ShowGroupOrChatWindow")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)*/
            showCreateNewGroup()
        }
        else{
            let dict: NSDictionary = newChatAppContacts[indexPath.row] as! NSDictionary
            let userJid = (dict.value(forKey: "jid") as? String)!
            //appDelegate().toName = (dict.value(forKey: "name") as? String)!
             //appDelegate().toUserJID = userJid
            print( appDelegate().toUserJID)
            if let tmpAvatar = dict.value(forKey: "avatar")
            {
                appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
            }
            else
            {
                appDelegate().toAvatarURL = ""
            }
            //LoadingIndicatorView.show((appDelegate().window?.rootViewController?.view)!, loadingText: "Please wait while loading Messages")
            

            appDelegate().isFromNewChat = true
           /* let showType:[String: String] = ["type": "chat", "jid": userJid]
            let notificationName = Notification.Name("ShowGroupOrChatWindow")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)*/
            showChatWindow(roomid: userJid)
        }
        }
      /*   if(searchActive){
            let dict: NSDictionary = phoneFilteredContacts[indexPath.row] as! NSDictionary
            let userJid = (dict.value(forKey: "jid") as? String)!
            appDelegate().toName = (dict.value(forKey: "name") as? String)!
            if let tmpAvatar = dict.value(forKey: "avatar")
            {
                appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
            }
            else
            {
                appDelegate().toAvatarURL = ""
            }
            
            let showType:[String: String] = ["type": "chat", "jid": userJid]
            let notificationName = Notification.Name("ShowGroupOrChatWindow")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)
            
        }
         else{
            if(indexPath.row == 0)
            {
         
                
            }
            else
            {
                let dict: NSDictionary = newChatAppContacts[indexPath.row] as! NSDictionary
                let userJid = (dict.value(forKey: "jid") as? String)!
                appDelegate().toName = (dict.value(forKey: "name") as? String)!
                if let tmpAvatar = dict.value(forKey: "avatar")
                {
                    appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
                }
                else
                {
                    appDelegate().toAvatarURL = ""
                }
                
                let showType:[String: String] = ["type": "chat", "jid": userJid]
                let notificationName = Notification.Name("ShowGroupOrChatWindow")
                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)
                
                //showChatWindow()
                
            }
        }
        */
        
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
        phoneFilteredContacts = newChatAppContacts.mutableCopy() as! NSMutableArray
        storySearchBar?.resignFirstResponder()
        storySearchBar?.showsCancelButton = false
        searchActive = false
        searchStarting = false
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
        if(searchText.count>0)
        {
            
        let result = newChatAppContacts.filter({ (text) -> Bool in
            let tmp: NSDictionary = text as! NSDictionary
            let val = tmp.value(forKey: "name")
            let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(result.count>0)
        {
            phoneFilteredContacts = NSMutableArray(array: result)//result as! NSMutableArray
        }
        else
        {
            phoneFilteredContacts = NSMutableArray()
        }
        /*let predicateFormat = NSString(format: "name MATCHES[c] '(%@).*'", searchText)
         let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
         
         let sectionArray = phoneNotSplitContacts.filtered(using: predicate)
         if(sectionArray.count > 0)
         {
         phoneFilteredContacts[phoneFilteredContacts.count] = sectionArray
         }*/
        
        /*if(phoneFilteredContacts.count == 0){
         searchActive = false;
         } else {
         searchActive = true;
             }*/
            
        }
        else{
             phoneFilteredContacts = newChatAppContacts
        }
        searchActive = true
        storyTableView?.reloadData()
    }
    func showChatWindow(roomid: String) {
        /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "Chat")
        //present(registerController as! UIViewController, animated: true, completion: nil)
         self.appDelegate().curRoomType = "chat"
        show(registerController as! UIViewController, sender: self)*/
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                    let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                                   myTeamsController.RoomJid = roomid//dict.value(forKey: "jid") as! String //+ JIDPostfix
                                                    show(myTeamsController, sender: self)
    }
    func showCreateNewGroup()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newGroupController : NewGroupViewController = storyBoard.instantiateViewController(withIdentifier: "NewGroup") as! NewGroupViewController
       
        self.present(newGroupController, animated: true, completion: nil)
    }
    
    @IBAction func cancelChat () {
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
            NewChatViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewChatViewController.realDelegate!;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
