//
//  StandingViewController.swift
//  FootballFan
//
//  Created by Apple on 27/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class StandingViewController: UIViewController,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource ,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout{
    //@IBOutlet weak var navItem: UINavigationItem!
    // @IBOutlet weak var webView: UIWebView!
    // @IBOutlet weak var viewNavigation: UINavigationBar!
     @IBOutlet weak var collectionViewTab: UICollectionView!
     @IBOutlet weak var storyTableView: UITableView?
     @IBOutlet weak var primelbl: UILabel?
     var data = [NewsCategories]()
      var selectedIndex = Int ()
      var isgrouped = "no"
     var strings:[String] = []
     @IBOutlet weak var noStandingsFound: UILabel?
    var refreshTable: UIRefreshControl!
    var isLoadingContacts : Bool = false
    var categoriesID: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewTab.dataSource  = self
        self.collectionViewTab.delegate = self
        self.storyTableView?.delegate = self
        self.storyTableView?.dataSource = self
        
       // print(data.)
        let notificationName1 = Notification.Name("_Fechedstandings")
        NotificationCenter.default.addObserver(self, selector: #selector(StandingViewController.UpdateStandingTrue), name: notificationName1, object: nil)
        let notificationName2 = Notification.Name("UpdateStandingfail")
        NotificationCenter.default.addObserver(self, selector: #selector(StandingViewController.UpdateStandingTrue), name: notificationName2, object: nil)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //depending upon direction of collection view
        
       // self.collectionViewTab?.setCollectionViewLayout(layout, animated: true)
       // self.collectionViewTab.reloadData()
 self.navigationItem.title = "Standings"
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(StandingViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        
        /*if #available(iOS 10.0, *) {
         tableView.refreshControl = refreshControl
         } else {
         storyTableView?.addSubview(refreshTable) // not required when using UITableViewContr
         }*/
        storyTableView?.addSubview(refreshTable)
    }
    @objc func refresh(_ sender:AnyObject) {
        
        
        if ClassReachability.isConnectedToNetwork() {
            if isLoadingContacts == false
            {
                isLoadingContacts = true
                //funGetSetContactsPermission()
                getStandingUpdate(categoriesID)
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
           // TransperentLoadingIndicatorView.hide()
            
        }
        //isLoadingContacts = false
        storyTableView?.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = NewsCategories.rows(filter:"cid = \(categoriesID)") as! [NewsCategories]
        if(data.count > 0){
            let dic = data[0]
            // let catid = Int(dic.cid)
            //print(dic.isnews)
            //categoriesID = Int(dic.cid)
            isgrouped = dic.isgroup
            primelbl?.text = dic.fullname
            //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                       
            //TransperentLoadingIndicatorView.show("Please wait while loading")
            getStandingUpdate(categoriesID)
        }
      
    }
    @objc func UpdateStandingTrue(notification: NSNotification)
    {
       // let dict = notification.userInfo?["userInfo"]  as! NSDictionary
        //arrStanding = dict.value(forKey: "responseData") as! NSMutableArray
         closeRefresh()
        storyTableView?.reloadData()
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // do stuff 3 seconds later
           // LoadingIndicatorView.hide()
        //}
        if( appDelegate().arrStanding.count == 0){
            storyTableView?.isHidden = true
            noStandingsFound?.isHidden = false
            showNocontactfound()
        }else{
            storyTableView?.isHidden = false
            noStandingsFound?.isHidden = true
            //showNocontactfound()
        }
       
    }
    @objc func UpdateStandingfail(notification: NSNotification)
    {
       // arrStanding = (notification.userInfo?["responseData"] ) as! NSMutableArray
         //LoadingIndicatorView.hide()
        storyTableView?.reloadData()
        storyTableView?.isHidden = true
        noStandingsFound?.isHidden = false
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
    func getStandingUpdate(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getstandings" as AnyObject
            reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
            reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
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
                            {
                                  self.appDelegate().arrStanding = jsonData?.value(forKey: "data") as! [AnyObject]
                                DispatchQueue.main.async {
                                self.closeRefresh()
                                self.storyTableView?.reloadData()
                                //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                // do stuff 3 seconds later
                                // LoadingIndicatorView.hide()
                                //}
                                if( self.appDelegate().arrStanding.count == 0){
                                    self.storyTableView?.isHidden = true
                                    self.noStandingsFound?.isHidden = false
                                    self.showNocontactfound()
                                }else{
                                    self.storyTableView?.isHidden = false
                                    self.noStandingsFound?.isHidden = true
                                    //showNocontactfound()
                                }
                            }
                            }
                            else
                            { DispatchQueue.main.async {
                                self.appDelegate().arrStanding = [AnyObject] ()
                                self.storyTableView?.reloadData()
                                // LoadingIndicatorView.hide()
                                self.storyTableView?.isHidden = true
                                self.noStandingsFound?.isHidden = false
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
            
         
        }else {
            //TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // appDelegate().arrStanding = [AnyObject]()
        // webView.
        // webView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
       // isgrouped = "no"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(appDelegate().allContacts)
        //print(appDelegate().allContacts.count)
        
        if(isgrouped == "no"){
            return 1
            
        }
        else{
            return appDelegate().arrStanding.count
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(isgrouped == "no"){
            return 45.0
        }
        else{
            return 75.0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         if(isgrouped == "no"){
        }
         else{
            
        }
        let dic = appDelegate().arrStanding[section] as! NSDictionary
        let date = dic.value(forKey: "date")
        
        return date as? String
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let headerView:StandingHeader = storyTableView!.dequeueReusableCell(withIdentifier: "StandingHeader") as! StandingHeader
         if(isgrouped == "no"){
             headerView.headerlabelHightConstraint2.constant = CGFloat(0.0)
            headerView.headername?.text = ""
        }
         else{
            let dic = appDelegate().arrStanding[section] as! NSDictionary
            let arrrow = dic.value(forKey: "groupname") as! String
             headerView.headerlabelHightConstraint2.constant = CGFloat(35.0)
             headerView.headername?.text = arrrow
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
         if(isgrouped == "no"){
        return appDelegate().arrStanding.count
        }
         else{
            let dictrow = appDelegate().arrStanding[section] as! NSDictionary
            let arrrow = dictrow.value(forKey: "groupdata") as! NSArray
            return arrrow.count
        }
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StandingCell = storyTableView!.dequeueReusableCell(withIdentifier: "StandingCell") as! StandingCell
         if(isgrouped == "no"){
        let dic = appDelegate().arrStanding[indexPath.row] as! NSDictionary
        cell.Sno?.text = String(indexPath.row + 1)
        
        cell.teamName?.text = dic.value(forKey: "team") as? String
        cell.W?.text = dic.value(forKey: "won") as? String
            cell.D?.text = dic.value(forKey: "drawn") as? String
            cell.L?.text = dic.value(forKey: "lost") as? String
            cell.F?.text = dic.value(forKey: "for") as? String
            cell.A?.text = dic.value(forKey: "against") as? String
            cell.GD?.text = dic.value(forKey: "gd") as? String
            cell.Pts?.text = dic.value(forKey: "points") as? String
            cell.pl?.text = dic.value(forKey: "played") as? String
        }
         else{
             let secdic = appDelegate().arrStanding[indexPath.section] as! NSDictionary
            let arrrow = secdic.value(forKey: "groupdata") as! NSArray
            let dic = arrrow[indexPath.row] as! NSDictionary
            cell.Sno?.text = String(indexPath.row + 1)
            cell.pl?.text = dic.value(forKey: "played") as? String
            cell.teamName?.text = dic.value(forKey: "team") as? String
            cell.W?.text = dic.value(forKey: "won") as? String
            cell.D?.text = dic.value(forKey: "drawn") as? String
            cell.L?.text = dic.value(forKey: "lost") as? String
            cell.F?.text = dic.value(forKey: "for") as? String
            cell.A?.text = dic.value(forKey: "against") as? String
            cell.GD?.text = dic.value(forKey: "gd") as? String
            cell.Pts?.text = dic.value(forKey: "points") as? String
        }
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
       //let catid = Int(dic.cid)
       // print(dic.isnews)
         categoriesID = Int(dic.cid)
        isgrouped = dic.isgroup
       // lastposition = 0
         primelbl?.text = dic.fullname
        getStandingUpdate(categoriesID)
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
        let bullet1 = "Sorry, no standings found."
        let bullet2 = "Please try again later."
        //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
        // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
        
        strings = [bullet1, bullet2]
        // let boldText  = "Quick Information \n"
        let attributesDictionary = [kCTForegroundColorAttributeName : noStandingsFound?.font]
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
        
        
        noStandingsFound?.attributedText = fullAttributedString
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
            StandingViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return StandingViewController.realDelegate!;
    }
}
