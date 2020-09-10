//
//  FixtureViewController.swift
//  FootballFan
//
//  Created by Apple on 27/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class FixtureViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,CHTCollectionViewDelegateWaterfallLayout {
    //@IBOutlet weak var navItem: UINavigationItem!
   // @IBOutlet weak var webView: UIWebView!
   // @IBOutlet weak var viewNavigation: UINavigationBar!
    @IBOutlet weak var collectionViewTab: UICollectionView!
    @IBOutlet weak var storyTableView: UITableView?
    var data = [NewsCategories]()
    var selectedIndex = Int ()
     @IBOutlet weak var primelbl: UILabel?
     var strings:[String] = []
     @IBOutlet weak var noFixtureFound: UILabel?
    var refreshTable: UIRefreshControl!
      var isLoadingContacts : Bool = false
    //var categoriesID: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewTab.dataSource  = self
        self.collectionViewTab.delegate = self
        self.storyTableView?.delegate = self
        self.storyTableView?.dataSource = self
        data = NewsCategories.rows(filter:"isfixtures = 'yes'") as! [NewsCategories]
        
        let notificationName1 = Notification.Name("_FechedarrFixtures")
        NotificationCenter.default.addObserver(self, selector: #selector(FixtureViewController.UpdateStandingTrue), name: notificationName1, object: nil)
        let notificationName2 = Notification.Name("UpdateFixturesfail")
        NotificationCenter.default.addObserver(self, selector: #selector(FixtureViewController.UpdateStandingTrue), name: notificationName2, object: nil)
       collectionViewTab.reloadData()
        self.navigationItem.title = "Fixtures"
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(FixtureViewController.refresh(_:)), for: UIControl.Event.valueChanged)
      
        /*if #available(iOS 10.0, *) {
         tableView.refreshControl = refreshControl
         } else {
         storyTableView?.addSubview(refreshTable) // not required when using UITableViewContr
         }*/
        storyTableView?.addSubview(refreshTable)
        var fullname = "" //dic.fullname
        if(appDelegate().fixcategoriesID == 0){
            if(data.count>0){
            let dic = data[0]
            //let catid = Int(dic.cid)
            // print(dic.isnews)
                appDelegate().fixcategoriesID = Int(dic.cid)
            fullname = dic.fullname
            }
        }
        else{
            for i in (0 ..< data.count){
                            let dic = data[i]
                                         let  catiD = Int(dic.cid)
                            if(catiD == appDelegate().fixcategoriesID){
                                 let indexPath = IndexPath(row: i, section: 0) as NSIndexPath
                                collectionViewTab.selectItem(at:indexPath as IndexPath, animated: true, scrollPosition:.left)
                                 selectedIndex = indexPath.row
                                 self.collectionViewTab.reloadData()
                                fullname = dic.fullname
                                break
                               
                            }
                        }
        }
        
     
        // lastposition = 0
       
        let arrdUserJid = fullname.components(separatedBy: " ")
        let userUserJid = fullname.replace(target: arrdUserJid[arrdUserJid.count - 1], withString: "Fixtures")
        primelbl?.text = userUserJid//dic.selVideoPath
       // LoadingIndicatorView.show("Please wait while loading")
        getfixturesUpdate(appDelegate().fixcategoriesID)
    }
    @objc func StandingShow(sender:UIButton)  {
        appDelegate().arrStanding = [AnyObject]()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : StandingViewController! = storyBoard.instantiateViewController(withIdentifier: "Standing") as? StandingViewController
        registerController.categoriesID = appDelegate().fixcategoriesID
        show(registerController, sender: self)
    }
    @objc func refresh(_ sender:AnyObject) {
        
        
        if ClassReachability.isConnectedToNetwork() {
            if isLoadingContacts == false
            {
                isLoadingContacts = true
                //funGetSetContactsPermission()
                getfixturesUpdate(appDelegate().fixcategoriesID)
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
            alertWithTitle1(title: nil, message: message, ViewController: self)
            
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.rightBarButtonItems = nil
         self.parent?.navigationItem.leftBarButtonItems = nil
         self.parent?.title = "Fixtures"
        let button2 = UIBarButtonItem(image: UIImage(named: "standing"), style: .plain, target: self, action: #selector(FixtureViewController.StandingShow(sender:)))
        self.parent?.navigationItem.rightBarButtonItem = button2
    }
    func closeRefresh()
    {
        if(refreshTable.isRefreshing)
        {
            isLoadingContacts = false
            refreshTable.endRefreshing()
        }
            
        else
        {
            /* if(self.activityIndicator?.isAnimating)!
             {
             self.activityIndicator?.stopAnimating()
             }*/
           // LoadingIndicatorView.hide()
            
        }
        //isLoadingContacts = false
        storyTableView?.isScrollEnabled = true
    }
    @objc func UpdateStandingTrue(notification: NSNotification)
    {
        // let dict = notification.userInfo?["userInfo"]  as! NSDictionary
        //arrStanding = dict.value(forKey: "responseData") as! NSMutableArray
        storyTableView?.reloadData()
       // LoadingIndicatorView.hide()
        if( appDelegate().arrFixtures.count == 0){
            storyTableView?.isHidden = true
            noFixtureFound?.isHidden = false
            showNocontactfound()
        }else{
            storyTableView?.isHidden = false
            noFixtureFound?.isHidden = true
            //showNocontactfound()
        }
        closeRefresh()
    }
    @objc func UpdateStandingfail(notification: NSNotification)
    {
        // arrStanding = (notification.userInfo?["responseData"] ) as! NSMutableArray
        storyTableView?.reloadData()
       // LoadingIndicatorView.hide()
        storyTableView?.isHidden = true
        noFixtureFound?.isHidden = false
        showNocontactfound()
        closeRefresh()
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func getfixturesUpdate(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            
            
                let boundary = appDelegate().generateBoundaryString()
                var request = URLRequest(url: URL(string: MediaAPI)!)
                request.httpMethod = "POST"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getfixtures" as AnyObject
            reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
            reqParams["key"] = "kXfqS9wUug6gVKDB"  as! AnyObject
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
                        if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                            //print(stringData) //JSONSerialization
                            
                            
                            
                            //print(time)
                            do {
                                let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                                
                                let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                                
                                if(isSuccess)
                                {
                                    self.appDelegate().arrFixtures = jsonData?.value(forKey: "data") as! [AnyObject]
                                    // let pickedCaption:[String: Any] = ["responseData": jsonData?.value(forKey: "responseData")  as! [AnyObject]]
                                     DispatchQueue.main.async {
                                    self.storyTableView?.reloadData()
                                    // LoadingIndicatorView.hide()
                                    if( self.appDelegate().arrFixtures.count == 0){
                                        self.storyTableView?.isHidden = true
                                        self.noFixtureFound?.isHidden = false
                                        self.showNocontactfound()
                                    }else{
                                        self.storyTableView?.isHidden = false
                                        self.noFixtureFound?.isHidden = true
                                        //showNocontactfound()
                                    }
                                    self.closeRefresh()
                                    }
                                    //print(arrFanUpdatesTeams)
                                   // let notificationName = Notification.Name("_FechedarrFixtures")
                                   // NotificationCenter.default.post(name: notificationName, object: nil)
                                    
                                }
                                else
                                { DispatchQueue.main.async {
                                    self.appDelegate().arrFixtures = [AnyObject] ()
                                    self.storyTableView?.reloadData()
                                    // LoadingIndicatorView.hide()
                                    self.storyTableView?.isHidden = true
                                    self.noFixtureFound?.isHidden = false
                                    self.showNocontactfound()
                                    self.closeRefresh()
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
            dictRequest["cmd"] = "getfixtures" as AnyObject
            
            
            do {
                
                
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                
                let myjidtrim: String? = userUserJid
                //dictRequestData["teams"] = totelteams as AnyObject
                dictRequestData["catid"] = lastindex as AnyObject
                // dictRequestData["username"] = myjidtrim as AnyObject
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
            
        }else {
            //LoadingIndicatorView.hide()
             closeRefresh()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // webView.
        // webView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(appDelegate().allContacts)
        //print(appDelegate().allContacts.count)
        
     
        return appDelegate().arrFixtures.count

        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dic = appDelegate().arrFixtures[section] as! NSDictionary
        let date = dic.value(forKey: "date")
        
        return date as? String
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         let dictrow = appDelegate().arrFixtures[section] as! NSDictionary
        let arrrow = dictrow.value(forKey: "data") as! String
        var rowcount = 0
        if let dataMessage = arrrow.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        {
            do {
                let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSArray
                
               // let recMessageType: NSArray = (jsonDataMessage?.value(forKey: "type") as? NSArray)!

                
                rowcount = (jsonDataMessage?.count)!
            } catch let error as NSError {
                print(error)
            }
            
        }
    
        return rowcount
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let dic = appDelegate().arrFixtures[section] as! NSDictionary
        let arrrow = dic.value(forKey: "date") as! String
        //
        label.text = arrrow
        label.textAlignment = .center
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
       /* if(section == 0)
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
        }*/
        
        headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        
        
        return headerView
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FixtureCell = storyTableView!.dequeueReusableCell(withIdentifier: "FixtureCell") as! FixtureCell

        let dic = appDelegate().arrFixtures[indexPath.section] as! NSDictionary
        let arrrow = dic.value(forKey: "data") as! String
       // var rowcount = 0
        if let dataMessage = arrrow.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        {
            do {
                let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSArray
                
                // let recMessageType: NSArray = (jsonDataMessage?.value(forKey: "type") as? NSArray)!
                let source = dic.value(forKey: "source") as! String
                
                let dict = jsonDataMessage![indexPath.row] as! NSDictionary
                if(source == "guardian"){
                let time = dict.value(forKey: "time") as! String
                let stringDate = time.components(separatedBy: "T")
                    //"2014-07-17T09:00:00-04:00"
                    let colanvalue = stringDate[1].components(separatedBy: ":")
                /*var dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date: NSDate = dateFormatter.date(from: stringDate) as! NSDate
                dateFormatter.dateFormat = "HH:mm"
                let stringWithRequestedDateFormat: String = dateFormatter.string(from: date as Date)
                //print(stringWithRequestedDateFormat)*/
                    
                    cell.time?.text = "\(colanvalue[0]):\(colanvalue[1])"//stringWithRequestedDateFormat
                }
                else{
                    cell.time?.text = dict.value(forKey: "time") as? String
                }
                let teamhome = dict.value(forKey: "teamhome") as! String
                let replteamhome = teamhome.replace(target: "&amp;", withString: "&")
                let teamaway = dict.value(forKey: "teamaway") as! String
                let replteamaway = teamaway.replace(target: "&amp;", withString: "&")
                
                cell.teamhome?.text = replteamhome.replace(target: "&#x27;", withString: "'")//?
                 cell.teamaway?.text = replteamaway.replace(target: "&#x27;", withString: "'")
                //rowcount = (jsonDataMessage?.count)!
            } catch let error as NSError {
                print(error)
            }
            
        }
       // cell.Sno?.text = String(indexPath.row + 1)
       // cell.pl?.text = String(dic.value(forKey: "played") as! Int)
       // cell.teamName?.text = dic.value(forKey: "team") as! String
       // cell.W?.text = String(dic.value(forKey: "won") as! Int)
       // cell.D?.text = String(dic.value(forKey: "drawn") as! Int)
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let dic = data[indexPath.row]
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celltab", for: indexPath as IndexPath) as! NewsTabCell
        let dic = data[indexPath.row]
        if selectedIndex == indexPath.row
        {
            cell.backgroundColor = UIColor.init(hex: "ffd401")
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        
        
        cell.newsTitle.text = dic.cname
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        
        selectedIndex = indexPath.row
        let dic = data[indexPath.row]
        //let catid =
        appDelegate().fixcategoriesID = Int(dic.cid)
        //print(catid)
        // lastposition = 0
        let fullname = dic.fullname
        let arrdUserJid = fullname.components(separatedBy: " ")
        let userUserJid = fullname.replace(target: arrdUserJid[arrdUserJid.count - 1], withString: "Fixtures")
         primelbl?.text = userUserJid//dic.selVideoPath
        getfixturesUpdate(appDelegate().fixcategoriesID)
        self.collectionViewTab.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        /* let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
         if(dict != nil)
         {
         
         var thumbLink: String = ""
         if let thumb = dict?.value(forKey: "urls")
         {
         thumbLink = thumb as! String
         }
         
         if(!thumbLink.isEmpty)
         {
         let imageSize = thumbLink.size
         let imageS = CGSize(width: imageSize.width, height: imageSize.height+600)
         return imageS
         }
         } */
        let dic = data[indexPath.row]
        let text = dic.cname
        let width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 16.0), text: text)
        return CGSize(width: width + 20, height: 40)
        
    }
    func showNocontactfound(){
        let bullet1 = "Sorry, no fixtures found."
        let bullet2 = "Please try again later."
        //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
        // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
        
        strings = [bullet1, bullet2]
        // let boldText  = "Quick Information \n"
        let attributesDictionary = [kCTForegroundColorAttributeName : noFixtureFound?.font]
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
        
        
        noFixtureFound?.attributedText = fullAttributedString
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

    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            FixtureViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return FixtureViewController.realDelegate!;
    }
}

