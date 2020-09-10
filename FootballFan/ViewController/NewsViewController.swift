//
//  NewsViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 07/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
class NewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var Slider: UIView?
       @IBOutlet weak var Buttomloader: UIView?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTab: UICollectionView!
    var selectedCell = [IndexPath]()
    var selectedIndex = Int ()
    let cellReuseIdentifier = "news"
    var dictAllTeams = NSMutableArray()
    var lastposition = 0
   // var catid = 1
    // var activityIndicator: UIActivityIndicatorView?
    var returnToOtherView:Bool = false
     var brakingnewsView:Bool = false
    var refreshTable: UIRefreshControl!
    var totelteams = ""
    var strings:[String] = []
    @IBOutlet weak var notelable: UILabel?
    @IBOutlet weak var Brakingnewslable: UILabel?
    lazy var lazyImage:LazyImage = LazyImage()
    var data = [NewsCategories]()
    //var categories: [String] = ["Most Popular", "La Liga", "Series A", "Series B", "Championship", "Premier League", "League One", "League Two", "Bundesliga"]
    
    //MARK: - View Controller Lifecycle
      @IBOutlet weak var tableviewButtomConstraint: NSLayoutConstraint!
     @IBOutlet weak var SliderTopConstraint: NSLayoutConstraint!
     @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var Connectinglabel: UILabel?
    var tempnews: [AnyObject] = []
     var tempBrakingnews: [AnyObject] = []
         @IBOutlet weak var butlatestview: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
         self.pageControl.currentPage = 0
        // Attach datasource and delegate
        self.collectionView.dataSource  = self
        self.collectionView.delegate = self
        //self.collectionView.allowsMultipleSelection = true
        
        self.collectionViewTab.dataSource  = self
        self.collectionViewTab.delegate = self
        
        data = NewsCategories.rows(filter:"isnews = 'yes'") as! [NewsCategories]
        
        self.collectionViewTab.reloadData()
        for i in (0 ..< data.count){
            let dic = data[i]
                         let  catiD = Int(dic.cid)
            if(catiD == appDelegate().selectednewscatid){
                 let indexPath = IndexPath(row: i, section: 0) as NSIndexPath
                //collectionViewTab.selectItem(at:indexPath as IndexPath, animated: true, scrollPosition:.left)
                 selectedIndex = indexPath.row
                 self.collectionViewTab.reloadData()
                break
               
            }
        }
        //Layout setup
        setupCollectionView()
        
        //Register nibs
        registerNibs()
        
        //catid = Int((appDelegate().arrNewsCategories[0] as! NSDictionary).value(forKey: "id") as! Int32)
        
        let notificationName = Notification.Name("_FetchedNews")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedNewsTeams), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("_FetchedNewsFail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedNews), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_FetchedNewsFilter")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshNews(_:)), name: notificationName3, object: nil)
        
        let notificationName1 = Notification.Name("_NewsSaveLike")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.NewsSaveLike), name: notificationName1, object: nil)
        
        let notificationName4 = Notification.Name("_RefreshNewsCategories")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshNewsCat), name: notificationName4, object: nil)
        let notificationName5 = Notification.Name("_isUserOnlineNotifyNews")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewsViewController.isUserOnline), name: notificationName5, object: nil)
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshNews(_:)), for: UIControl.Event.valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshTable
        } else {
            collectionView.addSubview(refreshTable)
        }
        
        collectionView.alwaysBounceVertical = true;
        let bulletPoint: String = "\u{2022}"
        let formattedString: String = "\(bulletPoint)HOT"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
        
      Brakingnewslable?.attributedText = attributedString
       // getNews(0)
        
    }
    @objc func StandingShow(sender:UIButton)  {
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : StandingViewController! = storyBoard.instantiateViewController(withIdentifier: "Standing") as? StandingViewController
        show(registerController, sender: self)
    }
    @objc func FixtureShow(sender:UIButton)  {
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : FixtureViewController! = storyBoard.instantiateViewController(withIdentifier: "Fixture") as? FixtureViewController
        show(registerController, sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CollectionView UI Setup
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        // Collection view attributes
        self.collectionView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView.collectionViewLayout = layout
    }
    
    // Register CollectionView Nibs
    func registerNibs(){
        
        // attach the UI nib file for the ImageUICollectionViewCell to the collectionview
        let viewNib = UINib(nibName: "ImageUICollectionViewCell", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    
    
    
    //MARK: - CollectionView Delegate Methods
    
    //** Number of Cells in the CollectionView */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionView)
        {
            return appDelegate().arrNews.count
        } else {
            return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == self.collectionView)
        {
           // print(indexPath.row)
            
            if(indexPath.row > 4) {
                //Slider?.isHidden = true
                SliderTopConstraint.constant = CGFloat(-200.0)
            } else if(indexPath.row <= 4) {
                //Slider?.isHidden = false
                 if(appDelegate().BrakingNews.count > 0){
                SliderTopConstraint.constant = CGFloat(0.0)
                }
                 else{
                     SliderTopConstraint.constant = CGFloat(-200.0)
                }
            }
        }
        if(appDelegate().arrNews.count > 19)
        {
            
            let lastElement = appDelegate().arrNews.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                 if ClassReachability.isConnectedToNetwork() {
                Buttomloader?.isHidden = false
                 tableviewButtomConstraint.constant = 35
                lastposition = lastposition + 1
                getNews(lastposition)
                }
               
            }
        }
    }
    
    
    //** Create a basic CollectionView Cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionView)
        {
            /*if(indexPath.row >= 4)
            {
                //Slider?.isHidden = true
                SliderTopConstraint.constant = CGFloat(-200.0)
            } else if(indexPath.row <= 3) {
                //Slider?.isHidden = false
                SliderTopConstraint.constant = CGFloat(0.0)
            }
            */
            // Create the cell and return the cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! NewsCollectionViewCell
            
            
            // Add image to cell
            
            let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
            
            
            
            
            cell.likeImage?.addGestureRecognizer(longPressGesture1)
            cell.likeImage?.isUserInteractionEnabled = true
            
            
            
            let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
            
            
            cell.shareImage?.addGestureRecognizer(longPressGesture_share1)
            cell.shareImage?.isUserInteractionEnabled = true
            
            
            let longPressGesture_comment1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_comment1.delegate = self as? UIGestureRecognizerDelegate
            
            cell.commentImage?.addGestureRecognizer(longPressGesture_comment1)
            cell.commentImage?.isUserInteractionEnabled = true
            
            
            
            let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
            
            
            cell.imageView?.addGestureRecognizer(longPressGesture_showpreview)
            cell.imageView?.isUserInteractionEnabled = true
            
            
            cell.newsTitle?.addGestureRecognizer(longPressGesture_showpreview1)
            cell.newsTitle?.isUserInteractionEnabled = true
            
            
            // Configure the cell...
            let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
            if(dict != nil)
            {
                
                let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
                if(isLiked){
                    cell.likeImage.image = UIImage(named: "liked")
                }
                else{
                    cell.likeImage.image = UIImage(named: "like")
                }
                let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                
                
                cell.newsTitle?.text = decodedString
                
                
                var thumbLink: String = ""
                if let thumb = dict?.value(forKey: "urls")
                {
                    thumbLink = thumb as! String
                }
                
                cell.imageView.image = nil
                cell.imageView.image = UIImage(named: "img_thumb")
                
                if(!thumbLink.isEmpty)
                {
                    // appDelegate().loadImageFromUrl(url: thumbLink,view: cell.imageView!)
                    // appDelegate().loadImageFromUrl(url: thumbLink,view: cell.image!)
                    self.lazyImage.show(imageView:cell.imageView!, url:thumbLink, defaultImage: "img_thumb")
                   // self.lazyImage.show(imageView:cell.image!, url:thumbLink)
                } else {
                    cell.image.image = UIImage(named: "img_thumb")
                    cell.imageView.image =  UIImage(named: "img_thumb")
                }
                
                
                cell.imageView?.contentMode = .scaleAspectFill
                cell.imageView?.clipsToBounds = true
                
                let lcount = dict?.value(forKey: "likecount") as? Int
                let ccount = dict?.value(forKey: "commentcount") as? Int
                let vcount = dict?.value(forKey: "viewcount") as? Int
                cell.commentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0))"
                cell.likeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0))"
                cell.viewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0))"
                
           /*     if(indexPath.row == 0){
                    cell.likeCount?.text = "800"
                    cell.viewCount?.text = "1.5K"
                }
                if(indexPath.row == 1){
                    cell.likeCount?.text = "8K"
                    cell.viewCount?.text = "11K"

                }
                if(indexPath.row == 2){
                    cell.likeCount?.text = "9K"
                    cell.viewCount?.text = "15K"
                    
                }
                if(indexPath.row == 3){
                    cell.likeCount?.text = "3K"
                    cell.viewCount?.text = "8K"
                    
                }
                if(indexPath.row == 0){
                    cell.commentCount?.text = "3K"
                }
                if(indexPath.row == 1){
                    cell.commentCount?.text = "700"
                    
                }
                if(indexPath.row == 2){
                    cell.commentCount?.text = "3K"
                    
                }
                if(indexPath.row == 3){
                    cell.commentCount?.text = "500"
                    
                }
 */
                
                //cell.likeCount?.text = "\(lcount ?? 0)"
                
                
            }
            
            /* if selectedCell.contains(indexPath) {
             cell.contentView.backgroundColor = .red
             }
             else {
             cell.contentView.backgroundColor = .white
             } */
            
            return cell
        } else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let url = model.images[indexPath.item]
        //print(indexPath.row)
        // let cell = collectionView.cellForItem(at: indexPath as IndexPath)
        selectedCell.append(indexPath)
        
        if(collectionView == self.collectionViewTab)
        {
            selectedIndex = indexPath.row
            let dic = data[indexPath.row]
                appDelegate().selectednewscatid = Int(dic.cid)
            //print(catid)
            lastposition = 0
            getNews(lastposition)
            self.collectionViewTab.reloadData()
        }
        //cell?.contentView.backgroundColor = .red
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)!
        /* if selectedCell.contains(indexPath) {
         selectedCell.remove(at: selectedCell.index(of: indexPath)!)
         cell.contentView.backgroundColor = .white
         } */
    }
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
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
        if(collectionView == self.collectionView)
        {
            return CGSize(width: 250, height: 400)
        } else {
            let dic = data[indexPath.row]
            let text = dic.cname
            let width = UILabel.textWidth(font: UIFont.systemFont(ofSize: 16.0), text: text)
            return CGSize(width: width + 20, height: 40)
            
            //return CGSize(width: 100, height: 30)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.appDelegate().isUpdatesLoaded = false
        self.parent?.title = "News"
        if(returnToOtherView){
            //getNews(lastposition)
            var dict1: [String: AnyObject] = appDelegate().arrNews[appDelegate().selectednewspossition] as! [String: AnyObject]
           
            dict1["commentcount"] = appDelegate().selectednewscommentcount as AnyObject
            appDelegate().arrNews[appDelegate().selectednewspossition] = dict1 as AnyObject
            collectionView.reloadData()
            returnToOtherView = false
        }
        else if(brakingnewsView){
            brakingnewsView = false
            appDelegate().BrakingNews[appDelegate().selectednewspossition] = appDelegate().newsdic as AnyObject
            //collectionView.reloadData()
        }
        else if(appDelegate().isrefreshnewsfromdetail){
            appDelegate().arrNews[appDelegate().selectednewspossition] = appDelegate().newsdic as AnyObject
            collectionView.reloadData()
            appDelegate().isrefreshnewsfromdetail = false
        }
        else {
            if(appDelegate().arrNews.count == 0)
            {
                lastposition = 0
                self.getNews(lastposition)
                /* if(appDelegate().isUserOnline)
                 {
                 getNews(lastposition)
                 } else {
                 LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you")
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                 // do stuff 3 seconds later
                 self.getNews(self.lastposition)
                 }
                 }*/
            }
            else{
                let notificationName = Notification.Name("_FetchedNews")
                                              NotificationCenter.default.post(name: notificationName, object: nil)
                getlatestnews()
            }
        }
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if ClassReachability.isConnectedToNetwork() {
            
            if(appDelegate().isUserOnline)
            {
                 //self.parent?.title = "News"
                 ConectingHightConstraint.constant = CGFloat(0.0)
            }
            else
            {
                 Connectinglabel?.text = "Connecting..."
                ConectingHightConstraint.constant = CGFloat(0.0)
                //self.parent?.title = "Connecting.."
            }
            
        } else {
            //self.parent?.title = "Waiting for network.."
            Connectinglabel?.text = "Waiting for network..."
            ConectingHightConstraint.constant = CGFloat(20.0)
        }
        }
        else{
           appDelegate().pageafterlogin = "news"
           appDelegate().idafterlogin = 0
            if ClassReachability.isConnectedToNetwork() {
                Connectinglabel?.text = "Connecting..."
                ConectingHightConstraint.constant = CGFloat(0.0)
            }else{
                Connectinglabel?.text = "Waiting for network..."
                ConectingHightConstraint.constant = CGFloat(20.0)
            }
             // ConectingHightConstraint.constant = CGFloat(0.0)
        }
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
        
        // lastposition = 0
        
    
      /*  let button1 = UIBarButtonItem(image: UIImage(named: "fixture"), style: .plain, target: self, action: #selector(NewsViewController.FixtureShow(sender:)))
        let rightSearchBarButtonItem:UIBarButtonItem = button1 //UIBarButtonItem(barButtonSystemItem: UIImage(named: "imagename"), target: self, action: .plain, action: Selector(Banterdelete))//UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
        // 3
        let button2 = UIBarButtonItem(image: UIImage(named: "standing"), style: .plain, target: self, action: #selector(NewsViewController.StandingShow(sender:)))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2//UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(BantersViewController.Banterrefresh))
        parent?.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1,rightSearchBarButtonItem], animated: true)*/
    }
    
    
    
    
    
    
    
    func getNews(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            /*if(appDelegate().arrNews.count == 0){
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            }*/
            if(lastindex == 0)
            {
                //LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you")
                appDelegate().isNewsPageRefresh = true
            } else
            {
                appDelegate().isNewsPageRefresh = false
            }
             do {
                self.butlatestview.isHidden = true
                            
            var dictRequest = [String: AnyObject]()
                   dictRequest["cmd"] = "getnews" as AnyObject
                     dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                     dictRequest["device"] = "ios" as AnyObject
            var reqParams = [String: AnyObject]()
                   //reqParams["cmd"] = "getfanupdates" as AnyObject
                  // reqParams["lasttime"] = appDelegate().APIgetfanupdatestime as AnyObject//1571460948000 as AnyObject//
                     reqParams["version"] = 1 as AnyObject
                             reqParams["lastindex"] = lastindex as AnyObject
                             //reqParams["username"] = myjidtrim as AnyObject
                             reqParams["catid"] = appDelegate().selectednewscatid as AnyObject
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
                   //dictRequest.setValue(dictMobiles, forKey: "requestData")
                   //print(dictRequest)
                  /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                   let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                   let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                 //  print(escapedString!)
                  // print(strFanUpdates)
                     var reqParams1 = [String: AnyObject]()
                    reqParams1["request"] = strFanUpdates as AnyObject
                   let url = MediaAPIjava + "request=" + escapedString!*/
                  //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
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
                                                                         self.butlatestview.isHidden =  true
                                                                         
                                                                         let response: NSArray = json["responseData"]  as! NSArray
                                                                                  let dic: NSDictionary = response[0] as! NSDictionary
                                                                        // let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                                                         //let dic: NSDictionary = response[0] as! NSDictionary
                                                                         //print(response)
                                                                           self.appDelegate().APIgetnewstime = self.appDelegate().getUTCFormateDate()
                                                                         self.appDelegate().BrakingNews = dic.value(forKey: "breakingnews")  as! [AnyObject]
                                                                         let news = dic.value(forKey: "news") as! NSArray
                                                                         if(news.count > 0)
                                                                         {
                                                                         if(self.appDelegate().isNewsPageRefresh)
                                                                         {
                                                                             //arrFanUpdatesTeams
                                                                             self.appDelegate().arrNews = news  as [AnyObject]
                                                                         }
                                                                         else
                                                                         {
                                                                             self.appDelegate().arrNews += news  as [AnyObject]
                                                                         }
                                                                         let notificationName = Notification.Name("_FetchedNews")
                                                                         NotificationCenter.default.post(name: notificationName, object: nil)
                                                                         } else {
                                                                             let notificationName = Notification.Name("_FetchedNewsFail")
                                                                             NotificationCenter.default.post(name: notificationName, object: nil)
                                                                         }
                                                                         }
                                                                            
                                                                        }
                                                                        else{
                                                                            DispatchQueue.main.async
                                                                                {
                                                                                 self.butlatestview.isHidden = true
                                                                                             
                                                                                if(self.appDelegate().isNewsPageRefresh)
                                                                                {
                                                                                    self.appDelegate().arrNews  = [AnyObject]()
                                                                                    let notificationName = Notification.Name("_FetchedNews")
                                                                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                } else
                                                                                {
                                                                                    let notificationName = Notification.Name("_FetchedNewsFail")
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
          /*  let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnews" as AnyObject
            //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
            reqParams["version"] = 1 as AnyObject
            reqParams["lastindex"] = lastindex as AnyObject
            //reqParams["username"] = myjidtrim as AnyObject
            reqParams["catid"] = appDelegate().selectednewscatid as AnyObject
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
                               // let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                //let dic: NSDictionary = response[0] as! NSDictionary
                                //print(response)
                                  self.appDelegate().APIgetnewstime = self.appDelegate().getUTCFormateDate()
                                self.appDelegate().BrakingNews = (jsonData?.value(forKey: "breakingnews") as! NSArray) as [AnyObject]
                                let news = jsonData?.value(forKey: "news") as! NSArray
                                if(news.count > 0)
                                {
                                if(self.appDelegate().isNewsPageRefresh)
                                {
                                    //arrFanUpdatesTeams
                                    self.appDelegate().arrNews = news  as [AnyObject]
                                }
                                else
                                {
                                    self.appDelegate().arrNews += news  as [AnyObject]
                                }
                                let notificationName = Notification.Name("_FetchedNews")
                                NotificationCenter.default.post(name: notificationName, object: nil)
                                } else {
                                    let notificationName = Notification.Name("_FetchedNewsFail")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                }
                                }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageRefresh)
                                {
                                    self.appDelegate().arrNews  = [AnyObject]()
                                    let notificationName = Notification.Name("_FetchedNews")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                } else
                                {
                                    let notificationName = Notification.Name("_FetchedNewsFail")
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
            */
            
            /*var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getnews" as AnyObject
            
            if(lastindex == 0)
            {
                LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you")
                appDelegate().isNewsPageRefresh = true
            } else
            {
                appDelegate().isNewsPageRefresh = false
            }
            do {
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                
                let myjidtrim: String? = userUserJid
                 dictRequestData["version"] = 1 as AnyObject
                dictRequestData["lastindex"] = lastindex as AnyObject
                dictRequestData["username"] = myjidtrim as AnyObject
                dictRequestData["catid"] = catid as AnyObject
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
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func getlatestnews() {
        if ClassReachability.isConnectedToNetwork() {
           
            
                appDelegate().isNewsPageRefresh = true
           
           /* let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnews" as AnyObject
            //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
            reqParams["version"] = 1 as AnyObject
            reqParams["lastindex"] = 0 as AnyObject
            reqParams["lasttime"] = appDelegate().APIgetnewstime as AnyObject//1571460948000 as AnyObject//
            //reqParams["username"] = myjidtrim as AnyObject
            reqParams["catid"] = appDelegate().selectednewscatid as AnyObject
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
                          
                                let isNewData = jsonData?.value(forKey: "isNewsData")  as! Bool
                                  if(isNewData){
                                //print(response)
                                    self.butlatestview.isHidden = false
                                                                         
                                                                               // self.setView(view: self.butlatestview)
                                                                           self.butlatestview.transform = self.butlatestview.transform.scaledBy(x: 0.01, y: 0.01)
                                                                           UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromTop, animations: {
                                                                             // 3
                                                                               self.butlatestview.transform = CGAffineTransform.identity
                                                                           }, completion: nil)

                                    self.tempBrakingnews = (jsonData?.value(forKey: "breakingnews") as! NSArray) as [AnyObject]
                                    self.tempnews = jsonData?.value(forKey: "news") as! [AnyObject]
                                                                                                                 }
                                                                                                                
                            }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageRefresh)
                                {
                                    self.appDelegate().arrNews  = [AnyObject]()
                                    let notificationName = Notification.Name("_FetchedNews")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                } else
                                {
                                    let notificationName = Notification.Name("_FetchedNewsFail")
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
            task.resume()*/
            
            do {
                      var dictRequest = [String: AnyObject]()
                             dictRequest["cmd"] = "getnews" as AnyObject
                               dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                               dictRequest["device"] = "ios" as AnyObject
                      var reqParams = [String: AnyObject]()
                             //reqParams["cmd"] = "getfanupdates" as AnyObject
                            // reqParams["lasttime"] = appDelegate().APIgetfanupdatestime as AnyObject//1571460948000 as AnyObject//
                               reqParams["version"] = 1 as AnyObject
                                       reqParams["lastindex"] = 0 as AnyObject
                                       //reqParams["username"] = myjidtrim as AnyObject
                                       reqParams["catid"] = appDelegate().selectednewscatid as AnyObject
                reqParams["lasttime"] = appDelegate().APIgetnewstime as AnyObject//1571460948000 as AnyObject//
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
                             //dictRequest.setValue(dictMobiles, forKey: "requestData")
                             //print(dictRequest)
                             /*let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                             let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                             let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                           //  print(escapedString!)
                            // print(strFanUpdates)
                               var reqParams1 = [String: AnyObject]()
                              reqParams1["request"] = strFanUpdates as AnyObject
                             let url = MediaAPIjava + "request=" + escapedString!*/
                            //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
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
                                                                                   
                                                                                          let isNewData = json["isNewData"] as! Bool //jsonData?.value(forKey: "isNewData")  as! Bool
                                                                                            if(isNewData){
                                                                                          //print(response)
                                                                                              self.butlatestview.isHidden = false
                                                                                                                                   
                                                                                                                                         // self.setView(view: self.butlatestview)
                                                                                                                                     self.butlatestview.transform = self.butlatestview.transform.scaledBy(x: 0.01, y: 0.01)
                                                                                                                                     UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromTop, animations: {
                                                                                                                                       // 3
                                                                                                                                         self.butlatestview.transform = CGAffineTransform.identity
                                                                                                                                     }, completion: nil)
                                                                                               let response: NSArray = json["responseData"]  as! NSArray
                                                                                                                                                                                       let dic: NSDictionary = response[0] as! NSDictionary
                                                                                               self.tempBrakingnews = dic.value(forKey: "breakingnews")  as! [AnyObject]
                                                                                               self.tempnews = dic.value(forKey: "news") as! [AnyObject]
                                                                                                                                                                           }
                                                                                                                                                                          
                                                                                      }
                                                                                        
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
                          } catch {
                                     print(error.localizedDescription)
                                 }
         
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        fetchedNewsTeams()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            self.closeRefresh()
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    @objc func refreshNews(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
        appDelegate().isNewsPageRefresh = true
        getNews(lastindex)
        /*if ClassReachability.isConnectedToNetwork() {
            collectionViewTab.reloadData()
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnews" as AnyObject
            //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
            reqParams["version"] = 1 as AnyObject
            reqParams["lastindex"] = lastindex as AnyObject
            //reqParams["username"] = myjidtrim as AnyObject
            reqParams["catid"] = appDelegate().selectednewscatid as AnyObject
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
                            {DispatchQueue.main.async {
                                // let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                //let dic: NSDictionary = response[0] as! NSDictionary
                                //print(response)
                                self.appDelegate().BrakingNews = (jsonData?.value(forKey: "breakingnews") as! NSArray) as [AnyObject]
                                let news = jsonData?.value(forKey: "news") as! NSArray
                                if(self.appDelegate().isNewsPageRefresh)
                                {
                                    //arrFanUpdatesTeams
                                    self.appDelegate().arrNews = news  as [AnyObject]
                                }
                                else
                                {
                                    self.appDelegate().arrNews += news  as [AnyObject]
                                }
                                let notificationName = Notification.Name("_FetchedNews")
                                NotificationCenter.default.post(name: notificationName, object: nil)
                                
                                }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageRefresh)
                                {
                                    self.appDelegate().arrNews  = [AnyObject]()
                                    let notificationName = Notification.Name("_FetchedNews")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                } else
                                {
                                    let notificationName = Notification.Name("_FetchedNewsFail")
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
            dictRequest["cmd"] = "getnews" as AnyObject
            
            do {
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                
                let myjidtrim: String? = userUserJid
                 dictRequestData["version"] = 1 as AnyObject
                dictRequestData["lastindex"] = lastindex as AnyObject
                dictRequestData["username"] = myjidtrim as AnyObject
                dictRequestData["catid"] = catid as AnyObject
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
        } else {
            //closeRefresh()
            collectionView?.isScrollEnabled = true
            closeRefresh()
            collectionView?.setContentOffset(CGPoint.zero, animated: true)
            
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }*/
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
        collectionView?.isScrollEnabled = true
    }
    
    @objc func showSettings() {
        //print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    
    func showCommentWindow(fanuid: Int64, title: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : NewsCommentViewController! = storyBoard.instantiateViewController(withIdentifier: "NewsComment") as? NewsCommentViewController
        registerController.fanupdateid = fanuid
        registerController.SelectedTitel = title
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
    }
    
    
    
    @objc func NewsSaveLike(notification: NSNotification)
    {
        let subtypevalue = (notification.userInfo?["savelike"] )as! NSDictionary
        print(subtypevalue)
    }
    
    
    @objc func RefreshNewsCat(notification: NSNotification)
    { DispatchQueue.main.async {
        self.collectionViewTab.reloadData()
        }
    }
    
    
    @objc func fetchedNewsTeams()
    {
        //storyTableView?.reloadData()
        /* if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }*/
        collectionView?.reloadData()
        TransperentLoadingIndicatorView.hide()
         Buttomloader?.isHidden = true
        closeRefresh()
        if(appDelegate().arrNews.count == 0){
            Slider?.isHidden = true
            notelable?.isHidden = false
            collectionViewTab?.isHidden = false
            collectionView?.isHidden = false
            let bullet1 = "Sorry, no News found."
            let bullet2 = "Please try again later."
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
        else{
            Slider?.isHidden = false
            tableviewButtomConstraint.constant = 5
            self.scrollView.frame = CGRect(x:0, y:0, width:self.Slider!.frame.width, height:(self.Slider?.frame.height)!)
            
            let scrollViewWidth:CGFloat = self.scrollView.frame.width
            let scrollViewHeight:CGFloat = self.scrollView.frame.height
            //2
            // textView.textAlignment = .center
            //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            //textView.textColor = UIColor.black
            //self.startButton.layer.cornerRadius = 10.0
            //3
            if(appDelegate().BrakingNews.count > 0){
                for i in 0...appDelegate().BrakingNews.count-1 {
                    let dict: NSDictionary? = appDelegate().BrakingNews[i] as? NSDictionary
                    if(dict != nil)
                    {
                        
                        
                        let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                        let decodedString = String(data: decodedData, encoding: .utf8)!
                        
                        
                        // cell.newsTitle?.text = decodedString
                        
                        
                        var thumbLink: String = ""
                        if let thumb = dict?.value(forKey: "urls")
                        {
                            thumbLink = thumb as! String
                        }
                        
                        
                        if(!thumbLink.isEmpty)
                        {
                            let imgOne = UIImageView(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))
                            imgOne.contentMode = .center//.scaleAspectFit//image show perfect if user skysports link
                            imgOne.tag = i
                            lazyImage.show(imageView: imgOne, url: thumbLink)
                            let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowbrekingPreviewClick(_:)))
                            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                            longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
                            
                            
                            imgOne.addGestureRecognizer(longPressGesture_showpreview2)
                            imgOne.isUserInteractionEnabled = true
                            
                            //imgOne.image = UIImage(named: "slide1")
                            /*let lbl = UILabel(frame: CGRect(x:scrollViewWidth * CGFloat(i), y:scrollViewHeight-90,width:scrollViewWidth, height:50))
                             lbl.backgroundColor = UIColor.white
                             lbl.alpha = 0.9
                             lbl.text = decodedString
                             //  let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
                             imgOne.addSubview(lbl)*/
                            let lblName = UILabel(frame: CGRect(x: 0.0, y:  140, width: scrollViewWidth, height: 40))//changed
                            lblName.font = UIFont.boldSystemFont(ofSize: 15)
                            lblName.text = decodedString//"You"
                            lblName.textAlignment = .center
                            lblName.backgroundColor = UIColor.white
                            //label.textColor = self.strokeColor
                            lblName.alpha = 0.7
                            lblName.numberOfLines = 2
                            //lblName.sizeToFit()
                            self.scrollView.addSubview(imgOne)
                            imgOne.addSubview(lblName)
                            
                        }
                    }
                }
                let count: CGFloat = CGFloat(appDelegate().BrakingNews.count)
                self.scrollView.contentSize = CGSize(width:scrollViewWidth * count, height:self.scrollView.frame.height)
                scrollView.contentOffset.x = 0
                self.scrollView.delegate = self
                self.pageControl.numberOfPages = appDelegate().BrakingNews.count
                self.pageControl.currentPage = 0
                 SliderTopConstraint.constant = CGFloat(0.0)
            }
            else{
                SliderTopConstraint.constant = CGFloat(-200.0)
            }
          
           
            notelable?.isHidden = true
            collectionViewTab?.isHidden = false
            collectionView?.isHidden = false
        }
    }
    @objc func isUserOnline()
    {
        DispatchQueue.main.async {
       // if(appDelegate().isOnBantersView)
        //{
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            if ClassReachability.isConnectedToNetwork() {
                
                if(self.appDelegate().isUserOnline)
                {
                    // LoadingIndicatorView.hide()
                    //self.parent?.title = "News"
                    self.ConectingHightConstraint.constant = CGFloat(0.0)
                }
                else
                {
                    self.Connectinglabel?.text = "Connecting..."
                    //LoadingIndicatorView.hide()
                    // self.parent?.title = "Banter Rooms"
                    //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading banters.")
                    //self.parent?.title = "Connecting.."
                    self.ConectingHightConstraint.constant = CGFloat(0.0)
                }
                if(self.appDelegate().arrNews.count == 0){
                    self.getNews(0)
                }
                
            } else {
                TransperentLoadingIndicatorView.hide()
                //self.parent?.title = "Waiting for network.."
                self.Connectinglabel?.text = "Waiting for network..."
                self.ConectingHightConstraint.constant = CGFloat(20.0)
            }
        }
        else{
            // ConectingHightConstraint.constant = CGFloat(0.0)
             if ClassReachability.isConnectedToNetwork() {
                self.ConectingHightConstraint.constant = CGFloat(0.0)
             }else{
                self.Connectinglabel?.text = "Waiting for network..."
                self.ConectingHightConstraint.constant = CGFloat(20.0)
            }
        }
    }
    }
    
    @objc func fetchedNews()
    {
         Buttomloader?.isHidden = true
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(appDelegate().arrNews.count == 0){
            
            notelable?.isHidden = false
            
            collectionView?.isHidden = false
            collectionViewTab?.isHidden = false
            let bullet1 = "Sorry, no News found."
            let bullet2 = "Please try again later."
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
        else{
            notelable?.isHidden = true
            collectionViewTab?.isHidden = false
            collectionView?.isHidden = false
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
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            NewsViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewsViewController.realDelegate!;
    }
    
    
    
    
    @objc func LikeClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
       // print("Like Click")
        let touchPoint = longPressGestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: touchPoint) {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
                //print(dict)likecount
                let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
                let Likedcount: Int32 = dict?.value(forKey: "likecount") as! Int32
                if(isLiked){
                    
                    var dict1: [String: AnyObject] = appDelegate().arrNews[indexPath.row] as! [String: AnyObject]
                    dict1["liked"] = 0 as AnyObject
                    dict1["likecount"] = Likedcount-1 as AnyObject
                    appDelegate().arrNews[indexPath.row] = dict1 as AnyObject
                    
                }
                else{
                    var dict1: [String: AnyObject] = appDelegate().arrNews[indexPath.row] as! [String: AnyObject]
                    dict1["liked"] = 1 as AnyObject
                    dict1["likecount"] = Likedcount + 1 as AnyObject
                    appDelegate().arrNews[indexPath.row] = dict1 as AnyObject
                }
                
                
                fetchedNewsTeams()
                //print(dict?.value(forKey: "username"))liked
                appDelegate().savenewslike(newsid: dict?.value(forKey: "id") as AnyObject)
               /* var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "savenewslike" as AnyObject
                
                do {
                    
                    //Creating Request Data
                    var dictRequestData = [String: AnyObject]()
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                    
                    
                    let myjidtrim: String? = userUserJid
                    dictRequestData["newsid"] = dict?.value(forKey: "id") as AnyObject
                    dictRequestData["time"] = time as AnyObject
                    dictRequestData["username"] = myjidtrim as AnyObject
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
                
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
            }else{
                appDelegate().LoginwithModelPopUp()
            }
        }
        
    }
    
    @objc func CommentClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
        let touchPoint = longPressGestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: touchPoint) {
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
                // print(dict)
                // print(dict?.value(forKey: "username"))
                appDelegate().selectednewspossition = indexPath.row
                returnToOtherView = true
                let fanupdateid = dict?.value(forKey: "id") as! Int64
                let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                
                showCommentWindow(fanuid: fanupdateid, title: decodedString)
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
            }else{
                appDelegate().LoginwithModelPopUp()
            }
        }
        
    }
    
    
    
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
        let touchPoint = longPressGestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: touchPoint) {
            let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
            // print(dict)
            // print(dict?.value(forKey: "username"))
            do {
                let fanupdateid = dict?.value(forKey: "id") as! Int64
                var dictRequest = [String: AnyObject]()
                dictRequest["id"] = fanupdateid as AnyObject
                dictRequest["type"] = "news" as AnyObject
                let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                
                let decodedData = Data(base64Encoded: (dict?.value(forKey: "title") as? String)!)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                
                
                let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                
                let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                
                let param = resultNSString as String?
                
                let inviteurl = InviteHost + "?q=" + param!
                
                          let text = "\(decodedString)\n\nNews shared via Football Fan App.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."
                                                                       //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                                                                     
                                                                       let objectsToShare = [text] as [Any]
                                                                                                             let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                                                                             
                                                                                                             //New Excluded Activities Code
                                                                                                             activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                                                                                             //
                                                                                                             
                                                                                                     activityVC.popoverPresentationController?.sourceView = self.view
                                                                                                             self.present(activityVC, animated: true, completion: nil)

                
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func showDetailWindow(dict: NSDictionary, position: Int, isbarkingnews: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : NewsDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "newsdetail") as? NewsDetailViewController
        registerController.newsdetail = dict
        registerController.position = position
        registerController.fromBanter = true
        registerController.isshowbyBraking = isbarkingnews
        show(registerController, sender: self)
    }
    
    @objc func ShowPreviewClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("Show Preview Click")
        let touchPoint = longPressGestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
                appDelegate().selectednewspossition = indexPath.row
                appDelegate().isrefreshnewsfromdetail = true
                let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
                appDelegate().newsdic = dict!
                showDetailWindow(dict: dict!, position: indexPath.row, isbarkingnews: false)
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            }
        }
        
        
        
    }
    @objc func ShowbrekingPreviewClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        
        //print("Show Preview Click\(longPressGestureRecognizer.view?.tag)")
        if ClassReachability.isConnectedToNetwork() {
            brakingnewsView = true
            appDelegate().selectednewspossition = longPressGestureRecognizer.view?.tag ?? 0
           
            
            let dict: NSDictionary? = appDelegate().BrakingNews[longPressGestureRecognizer.view?.tag ?? 0 ] as? NSDictionary
            appDelegate().newsdic = dict!
            showDetailWindow(dict: dict!, position:0, isbarkingnews: true)
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func saveImageToLocalWithNameReturnPath(_ image: UIImage, fileName: String) -> String{
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/news/" + fileName + ".png")
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
    
    func getVideoThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = CGSize(width: 320, height: 180) //.maximumSize = CGSize
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            let img: UIImage = UIImage(cgImage: thumbnailImage)
            return img
        } catch let error {
            print(error)
            let img: UIImage = UIImage(named: "splash_bg")!
            return img
        }
    }
    
    func showMediaPreview(_ mediaType: String, mediaPath: String, isLocalMedia: Bool = false) {
        if(!mediaType.isEmpty && !mediaPath.isEmpty)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let previewController : MediaPreviewController! = storyBoard.instantiateViewController(withIdentifier: "MediaPreview") as? MediaPreviewController
            
            if(mediaType == "image")
            {
                previewController.imagePath = mediaPath
            }
            else if(mediaType == "video")
            {
                previewController.videoPath = mediaPath
                
            }
            previewController.isLocalMedia = isLocalMedia
            previewController.mediaType = mediaType
            /*show(previewController!, sender: self)*/
            self.present(previewController, animated: true, completion: nil)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        if(scrollView == self.scrollView){
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.pageControl.currentPage = Int(currentPage);
        }
       
        
    }
    @IBAction func latestAction(){
           butlatestview.isHidden = true
       self.appDelegate().APIgetnewstime = self.appDelegate().getUTCFormateDate()
         self.appDelegate().BrakingNews = tempBrakingnews
        appDelegate().arrNews = tempnews
      let notificationName = Notification.Name("_FetchedNews")
                                  NotificationCenter.default.post(name: notificationName, object: nil)
       }

} /*: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
 @IBOutlet weak var storyTableView: UITableView?
 let cellReuseIdentifier = "news"
 var dictAllTeams = NSMutableArray()
 var lastposition = 0
 // var activityIndicator: UIActivityIndicatorView?
 var returnToOtherView:Bool = false
 var refreshTable: UIRefreshControl!
 var totelteams = ""
 var strings:[String] = []
 @IBOutlet weak var notelable: UILabel?
 override func viewDidLoad() {
 super.viewDidLoad()
 parent?.navigationItem.rightBarButtonItems = nil
 // Uncomment the following line to preserve selection between presentations
 // self.clearsSelectionOnViewWillAppear = false
 storyTableView?.delegate = self
 storyTableView?.dataSource = self
 //self.appDelegate().CreateFanUpdateFolder()
 //self.appDelegate().CreateProfileFolder()
 
 let notificationName = Notification.Name("_FetchedNews")
 // Register to receive notification
 NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedNewsTeams), name: notificationName, object: nil)
 
 let notificationName2 = Notification.Name("_FetchedNewsFail")
 // Register to receive notification
 NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedNews), name: notificationName2, object: nil)
 
 let notificationName3 = Notification.Name("_FetchedNewsFilter")
 // Register to receive notification
 NotificationCenter.default.addObserver(self, selector: #selector(self.refreshNews(_:)), name: notificationName3, object: nil)
 
 let notificationName1 = Notification.Name("_NewsSaveLike")
 // Register to receive notification
 NotificationCenter.default.addObserver(self, selector: #selector(self.NewsSaveLike), name: notificationName1, object: nil)
 
 refreshTable = UIRefreshControl()
 refreshTable.attributedTitle = NSAttributedString(string: "Getting latest News for you.")
 refreshTable.addTarget(self, action: #selector(refreshNews(_:)), for: UIControlEvents.valueChanged)
 
 
 storyTableView?.addSubview(refreshTable)
 
 //  self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
 
 
 //getNews(lastposition)
 
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 
 self.appDelegate().isUpdatesLoaded = false
 
 self.parent?.title = "News"
 let settingsImage   = UIImage(named: "settings")!
 let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.showSettings))
 self.parent?.navigationItem.leftBarButtonItem = settingsButton
 self.parent?.navigationItem.rightBarButtonItem = nil
 
 let button1 = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(FanUpdatesListViewController.ShowFilter(sender:)))
 let rightSearchBarButtonItem:UIBarButtonItem = button1
 
 parent?.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
 // lastposition = 0
 
 if(returnToOtherView){
 getNews(lastposition)
 } else {
 if(appDelegate().arrFanUpdatesTeams.count == 0)
 {
 lastposition = 0
 if(appDelegate().isUserOnline)
 {
 getNews(lastposition)
 } else {
 LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you.")
 DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
 // do stuff 3 seconds later
 self.getNews(self.lastposition)
 }
 }
 }
 }
 
 }
 
 
 
 @objc func ShowFilter(sender:UIButton) {
 print("Show Filter")
 /* let popController: CategoriesMultiTeamViewControlle = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryM") as! CategoriesMultiTeamViewControlle
 
 // set the presentation style
 popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
 //popController.modalPresentationStyle = .popover
 popController.modalTransitionStyle = .crossDissolve
 
 // set up the popover presentation controller
 popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
 popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
 popController.popoverPresentationController?.sourceView = self.view // button
 //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
 popController.isShowForBanterRoom = true
 popController.teamType = "multi"
 //  popController.variableString = totelteams
 // present the popover
 self.present(popController, animated: true, completion: nil)
 */
 
 }
 
 
 
 
 func getNews(_ lastindex : Int)  {
 var dictRequest = [String: AnyObject]()
 dictRequest["cmd"] = "getnews" as AnyObject
 
 if(lastindex == 0)
 {
 LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you.")
 appDelegate().isNewsPageRefresh = true
 } else
 {
 appDelegate().isNewsPageRefresh = false
 }
 do {
 //Creating Request Data
 var dictRequestData = [String: AnyObject]()
 let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
 let arrdUserJid = myjid?.components(separatedBy: "@")
 let userUserJid = arrdUserJid?[0]
 
 let myjidtrim: String? = userUserJid
 dictRequestData["lastindex"] = lastindex as AnyObject
 dictRequestData["username"] = myjidtrim as AnyObject
 dictRequest["requestData"] = dictRequestData as AnyObject
 //dictRequest.setValue(dictMobiles, forKey: "requestData")
 //print(dictRequest)
 
 let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
 let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
 //print(strFanUpdates)
 self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
 } catch {
 print(error.localizedDescription)
 }
 }
 
 @objc func refreshNews(_ sender:AnyObject)  {
 lastposition = 0
 let lastindex = 0
 appDelegate().isNewsPageRefresh = true
 var dictRequest = [String: AnyObject]()
 dictRequest["cmd"] = "getnews" as AnyObject
 
 do {
 var dictRequestData = [String: AnyObject]()
 let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
 let arrdUserJid = myjid?.components(separatedBy: "@")
 let userUserJid = arrdUserJid?[0]
 
 let myjidtrim: String? = userUserJid
 dictRequestData["lastindex"] = lastindex as AnyObject
 dictRequestData["username"] = myjidtrim as AnyObject
 dictRequest["requestData"] = dictRequestData as AnyObject
 //dictRequest.setValue(dictMobiles, forKey: "requestData")
 //print(dictRequest)
 
 let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
 let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
 //print(strFanUpdates)
 self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
 } catch {
 print(error.localizedDescription)
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
 LoadingIndicatorView.hide()
 
 }
 storyTableView?.isScrollEnabled = true
 }
 
 @objc func showSettings() {
 //print("Show stettings")
 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
 let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
 
 self.present(settingsController, animated: true, completion: nil)
 }
 
 func showCommentWindow(fanuid: Int64) {
 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
 let registerController : NewsCommentViewController! = storyBoard.instantiateViewController(withIdentifier: "NewsComment") as! NewsCommentViewController
 registerController.fanupdateid = fanuid
 //present(registerController as! UIViewController, animated: true, completion: nil)
 // self.appDelegate().curRoomType = "chat"
 show(registerController, sender: self)
 }
 
 
 
 @objc func NewsSaveLike(notification: NSNotification)
 {
 let subtypevalue = (notification.userInfo?["savelike"] )as! NSDictionary
 print(subtypevalue)
 }
 
 @objc func fetchedNewsTeams()
 {
 //storyTableView?.reloadData()
 /* if(self.activityIndicator?.isAnimating)!
 {
 self.activityIndicator?.stopAnimating()
 }*/
 storyTableView?.reloadData()
 LoadingIndicatorView.hide()
 closeRefresh()
 if(appDelegate().arrNews.count == 0){
 
 notelable?.isHidden = false
 
 storyTableView?.isHidden = false
 let bullet1 = "Sorry, no Fan updates found."
 let bullet2 = "Please try again later or post your own update."
 //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
 // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
 
 strings = [bullet1, bullet2]
 // let boldText  = "Quick Information \n"
 let attributesDictionary = [kCTForegroundColorAttributeName : notelable?.font]
 let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedStringKey : Any])
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
 attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedStringKey: paragraphStyle], range: NSMakeRange(0, attributedString.length))
 
 let range1 = (formattedString as NSString).range(of: "Invite")
 attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.init(hex: "197DF6"), range: range1)
 
 let range2 = (formattedString as NSString).range(of: "Settings")
 attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.init(hex: "197DF6"), range: range2)
 
 fullAttributedString.append(attributedString)
 }
 
 
 notelable?.attributedText = fullAttributedString
 
 }
 else{
 notelable?.isHidden = true
 
 storyTableView?.isHidden = false
 }
 }
 
 @objc func fetchedNews()
 {
 LoadingIndicatorView.hide()
 closeRefresh()
 if(appDelegate().arrNews.count == 0){
 
 notelable?.isHidden = false
 
 storyTableView?.isHidden = true
 let bullet1 = "Sorry, no Fan updates found."
 let bullet2 = "Please try again later or post your own update."
 //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
 // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
 
 strings = [bullet1, bullet2]
 // let boldText  = "Quick Information \n"
 let attributesDictionary = [kCTForegroundColorAttributeName : notelable?.font]
 let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedStringKey : Any])
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
 attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedStringKey: paragraphStyle], range: NSMakeRange(0, attributedString.length))
 
 let range1 = (formattedString as NSString).range(of: "Invite")
 attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.init(hex: "197DF6"), range: range1)
 
 let range2 = (formattedString as NSString).range(of: "Settings")
 attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.init(hex: "197DF6"), range: range2)
 
 fullAttributedString.append(attributedString)
 }
 
 
 notelable?.attributedText = fullAttributedString
 
 }
 else{
 notelable?.isHidden = true
 
 storyTableView?.isHidden = false
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
 func appDelegate() -> AppDelegate {
 return UIApplication.shared.delegate as! AppDelegate
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 // MARK: - Table view data source
 
 func numberOfSections(in tableView: UITableView) -> Int {
 // #warning Incomplete implementation, return the number of sections
 return 1
 }
 
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // #warning Incomplete implementation, return the number of rows
 print(appDelegate().arrNews.count)
 return appDelegate().arrNews.count
 }
 
 @objc func LikeClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
 print("Like Click")
 let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
 if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
 let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
 //print(dict)likecount
 let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
 var Likedcount: Int32 = dict?.value(forKey: "likecount") as! Int32
 if(isLiked){
 
 var dict1: [String: AnyObject] = appDelegate().arrNews[indexPath.row] as! [String: AnyObject]
 dict1["liked"] = 0 as AnyObject
 dict1["likecount"] = Likedcount-1 as AnyObject
 appDelegate().arrNews[indexPath.row] = dict1 as AnyObject
 
 }
 else{
 var dict1: [String: AnyObject] = appDelegate().arrNews[indexPath.row] as! [String: AnyObject]
 dict1["liked"] = 1 as AnyObject
 dict1["likecount"] = Likedcount + 1 as AnyObject
 appDelegate().arrNews[indexPath.row] = dict1 as AnyObject
 }
 
 
 fetchedNewsTeams()
 //print(dict?.value(forKey: "username"))liked
 
 var dictRequest = [String: AnyObject]()
 dictRequest["cmd"] = "savenewslike" as AnyObject
 
 do {
 
 //Creating Request Data
 var dictRequestData = [String: AnyObject]()
 let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
 let arrdUserJid = myjid?.components(separatedBy: "@")
 let userUserJid = arrdUserJid?[0]
 let time: Int64 = self.appDelegate().getUTCFormateDate()
 
 
 let myjidtrim: String? = userUserJid
 dictRequestData["newsid"] = dict?.value(forKey: "id") as AnyObject
 dictRequestData["time"] = time as AnyObject
 dictRequestData["username"] = myjidtrim as AnyObject
 dictRequest["requestData"] = dictRequestData as AnyObject
 //dictRequest.setValue(dictMobiles, forKey: "requestData")
 //print(dictRequest)
 
 let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
 let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
 //print(strFanUpdates)
 self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
 } catch {
 print(error.localizedDescription)
 }
 
 
 }
 
 }
 
 @objc func CommentClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
 print("Comment Click")
 let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
 if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
 let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
 // print(dict)
 // print(dict?.value(forKey: "username"))
 returnToOtherView = true
 let fanupdateid = dict?.value(forKey: "id") as! Int64
 showCommentWindow(fanuid: fanupdateid)
 }
 
 }
 
 
 
 @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
 print("Share Click")
 let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
 if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
 let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
 let decodedString = dict?.value(forKey: "title")
 let shareAll = [decodedString] as [Any]
 let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
 activityViewController.popoverPresentationController?.sourceView = self.view
 self.present(activityViewController, animated: true, completion: nil)
 }
 
 }
 
 func showDetailWindow(dict: NSDictionary, position: Int) {
 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
 let registerController : NewsDetailViewController! = storyBoard.instantiateViewController(withIdentifier: "newsdetail") as! NewsDetailViewController
 registerController.newsdetail = dict
 registerController.position = position
 show(registerController, sender: self)
 }
 
 @objc func ShowPreviewClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
 print("Show Preview Click")
 let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
 if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
 let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
 showDetailWindow(dict: dict!, position: indexPath.row)
 }
 
 
 
 }
 
 func saveImageToLocalWithNameReturnPath(_ image: UIImage, fileName: String) -> String{
 let fileManager = FileManager.default
 
 let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/news/" + fileName + ".png")
 //print(paths)
 if(fileManager.fileExists(atPath: paths))
 {
 print(paths)
 }
 else
 {
 let imageData = UIImageJPEGRepresentation(image, 1)
 
 fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
 }
 
 return "file://" + paths
 }
 
 
 
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 if(appDelegate().arrNews.count > 19)
 {
 
 let lastElement = appDelegate().arrNews.count - 1
 if indexPath.row == lastElement {
 // handle your logic here to get more items, add it to dataSource and reload tableview
 lastposition = lastposition + 1
 getNews(lastposition)
 }
 }
 }
 
 
 
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NewsCell
 
 
 let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
 
 
 let longPressGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture2.delegate = self as? UIGestureRecognizerDelegate
 
 
 cell.likeView?.addGestureRecognizer(longPressGesture)
 cell.likeView?.isUserInteractionEnabled = true
 
 cell.likeImage?.addGestureRecognizer(longPressGesture1)
 cell.likeImage?.isUserInteractionEnabled = true
 
 cell.likeButton?.addGestureRecognizer(longPressGesture2)
 cell.likeButton?.isUserInteractionEnabled = true
 
 
 let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture_share2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_share2.delegate = self as? UIGestureRecognizerDelegate
 
 cell.shareView?.addGestureRecognizer(longPressGesture_share)
 cell.shareView?.isUserInteractionEnabled = true
 
 cell.shareImage?.addGestureRecognizer(longPressGesture_share1)
 cell.shareImage?.isUserInteractionEnabled = true
 
 cell.shareButton?.addGestureRecognizer(longPressGesture_share2)
 cell.shareButton?.isUserInteractionEnabled = true
 
 
 
 let longPressGesture_comment:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_comment.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture_comment1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_comment1.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture_comment2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_comment2.delegate = self as? UIGestureRecognizerDelegate
 
 
 
 cell.commentView?.addGestureRecognizer(longPressGesture_comment)
 cell.commentView?.isUserInteractionEnabled = true
 
 cell.commentImage?.addGestureRecognizer(longPressGesture_comment1)
 cell.commentImage?.isUserInteractionEnabled = true
 
 cell.commentButton?.addGestureRecognizer(longPressGesture_comment2)
 cell.commentButton?.isUserInteractionEnabled = true
 
 
 
 
 let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
 
 let longPressGesture_showpreview2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
 //longPressGesture.minimumPressDuration = 1.0 // 1 second press
 longPressGesture_showpreview2.delegate = self as? UIGestureRecognizerDelegate
 
 
 cell.newsImage?.addGestureRecognizer(longPressGesture_showpreview)
 cell.newsImage?.isUserInteractionEnabled = true
 
 
 cell.newsTitle?.addGestureRecognizer(longPressGesture_showpreview1)
 cell.newsTitle?.isUserInteractionEnabled = true
 
 
 cell.newsDesc?.addGestureRecognizer(longPressGesture_showpreview2)
 cell.newsDesc?.isUserInteractionEnabled = true
 
 
 // Configure the cell...
 let dict: NSDictionary? = appDelegate().arrNews[indexPath.row] as? NSDictionary
 if(dict != nil)
 {
 
 let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
 if(isLiked){
 cell.likeImage.image = UIImage(named: "liked")
 cell.likeButton?.setTitle("Liked", for: .normal)
 }
 else{
 cell.likeImage.image = UIImage(named: "like")
 cell.likeButton?.setTitle("Like", for: .normal)
 }
 
 cell.newsTitle?.text = dict?.value(forKey: "title") as! String
 
 cell.newsDesc?.text = dict?.value(forKey: "description") as! String
 
 var thumbLink: String = ""
 if let thumb = dict?.value(forKey: "urls")
 {
 thumbLink = thumb as! String
 }
 
 if(!thumbLink.isEmpty)
 {
 appDelegate().loadImageFromUrl(url: thumbLink,view: cell.newsImage!)
 } else {
 cell.newsImage.image = UIImage(named: "img_thumb")
 }
 
 cell.newsImage?.contentMode = .scaleAspectFill
 cell.newsImage?.clipsToBounds = true
 
 }
 
 return cell
 }
 
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 
 }
 
 func getVideoThumbnailImage(forUrl url: URL) -> UIImage? {
 let asset: AVAsset = AVAsset(url: url)
 let imageGenerator = AVAssetImageGenerator(asset: asset)
 imageGenerator.maximumSize = CGSize(width: 320, height: 180) //.maximumSize = CGSize
 imageGenerator.appliesPreferredTrackTransform = true
 do {
 let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
 let img: UIImage = UIImage(cgImage: thumbnailImage)
 return img
 } catch let error {
 print(error)
 let img: UIImage = UIImage(named: "splash_bg")!
 return img
 }
 }
 
 func showMediaPreview(_ mediaType: String, mediaPath: String, isLocalMedia: Bool = false) {
 if(!mediaType.isEmpty && !mediaPath.isEmpty)
 {
 let storyBoard = UIStoryboard(name: "Main", bundle: nil)
 let previewController : MediaPreviewController! = storyBoard.instantiateViewController(withIdentifier: "MediaPreview") as! MediaPreviewController
 
 if(mediaType == "image")
 {
 previewController.imagePath = mediaPath
 }
 else if(mediaType == "video")
 {
 previewController.videoPath = mediaPath
 
 }
 previewController.isLocalMedia = isLocalMedia
 previewController.mediaType = mediaType
 /*show(previewController!, sender: self)*/
 self.present(previewController, animated: true, completion: nil)
 }
 }
 
 
 
 } */

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}

