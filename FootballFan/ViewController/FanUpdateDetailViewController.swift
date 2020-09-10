//
//  FanUpdateDetailViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 22/08/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//


import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import AVKit
import Alamofire
class FanUpdateDetailViewController:UIViewController,ASAutoPlayVideoLayerContainer {
    var videoURL: String?
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.view?.superview?.convert(updateImage.frame, from: updateImage)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = view?.frame else {
                return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
     @IBOutlet weak var progress: UIImageView!
    
    @IBOutlet weak var updateImage: UIImageView!
    @IBOutlet weak var updateTitle: UILabel!
    @IBOutlet weak var updateContent: UILabel!
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamTitle: UILabel!
    
    @IBOutlet weak var fanImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var lbl_subtype: UILabel!
    
    @IBOutlet weak var updateContentTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var LikeCount: UILabel?
    @IBOutlet weak var CommentCount: UILabel?
    @IBOutlet weak var ViewCount: UILabel?
    
    @IBOutlet weak var like: UIView!
    @IBOutlet weak var share: UIView!
    @IBOutlet weak var comment: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeText: UIButton!
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentText: UIButton!
    
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareText: UIButton!
    
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var contentView : UIView!
    @IBOutlet weak var playImage: UIImageView!
    
    @IBOutlet weak var deleteUpdate: UILabel!
    @IBOutlet weak var editUpdate: UILabel!
    @IBOutlet weak var editImage: UIImageView?
    @IBOutlet weak var deleteImage: UIImageView?
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteView: UIView!
      var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var fanupdatedetail: [AnyObject] = []
    var newsdetail: NSDictionary = [:]
    var fromBanter = false
    var fanupdateid: Int64 = 0
    @IBOutlet weak var imgmenu: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationName = Notification.Name("Detailplay")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(FanUpdateDetailViewController.PlayAtIndex), name: notificationName, object: nil)
        let notificationName_ffdeeplink = Notification.Name("_FetchedFanUpdateByID")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(FanUpdateDetailViewController.refreshView), name: notificationName_ffdeeplink, object: nil)
        let notificationName_updatecount = Notification.Name("_fanupdatecount")
               // Register to receive notification
               NotificationCenter.default.addObserver(self, selector: #selector(FanUpdateDetailViewController.updatecount), name: notificationName_updatecount, object: nil)
        let notificationName_updatedelete = Notification.Name("_fanupdatedelete")
                      // Register to receive notification
                      NotificationCenter.default.addObserver(self, selector: #selector(FanUpdateDetailViewController.updatedelete), name: notificationName_updatedelete, object: nil)
        let DetailstoryUserblockFail = Notification.Name("DetailstoryUserblockFail")
                                
                                NotificationCenter.default.addObserver(self, selector: #selector(self.blockuserfail), name: DetailstoryUserblockFail, object: nil)
    }
    @objc func blockuserfail(notification: NSNotification)
        {
            //let subtypevalue = (notification.userInfo?["savelike"] )as! NSDictionary
           // print(subtypevalue)
            //storyTableView?.reloadData()
            /* if(self.activityIndicator?.isAnimating)!
             {
             self.activityIndicator?.stopAnimating()
             }*/
            //storyTableView?.reloadData()
            DispatchQueue.main.async {
                self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self)
           }
        }

    @objc func PlayAtIndex(notification: NSNotification)
    {
        
        progress.isHidden = true
    }
    @objc func updatecount(notification: NSNotification)
    {
        let commentcount = notification.userInfo!["commentcount"] as! Int64
        let viewcount = notification.userInfo?["viewcount"] as! Int64
        let likecount = notification.userInfo!["likecount"] as! Int64
         var dict1: [String: AnyObject] = fanupdatedetail[0] as! [String: AnyObject]
        dict1["likecount"] = likecount as AnyObject
        dict1["commentcount"] = commentcount as AnyObject
        dict1["viewcount"] = viewcount as AnyObject
                                                                         
            fanupdatedetail[0] = dict1 as AnyObject
updateView()
    }
   
    @objc func updatedelete(notification: NSNotification)
        {
             self.navigationController?.popViewController(animated: true)
        }
    @objc func refreshView(notification: NSNotification)
    {
        let Status = (notification.userInfo?["index"] )as! String
        
        if(Status == "fanupdate")
        {
            fanupdatedetail = notification.userInfo?["response"] as! [AnyObject]
            fromBanter = false
            updateView()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //fanupdateOnForgroundView = false
        appDelegate().isOnFanDetail = false
        ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.playOn = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate().openffdeepurl = ""
        appDelegate().isFromBanterDeepLink = false
        appDelegate().isOnFanDetail = true
          navigationController?.isNavigationBarHidden = false
        if(fromBanter)
        {
            updateView()
            //fromBanter = false
        } else
        {
            
            let id: Int64 = fanupdateid
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "getfanupdatebyid" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
               
                reqParams["id"] = id as AnyObject
                
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
                do {
                   /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                    let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    //  print(escapedString!)
                    // print(strFanUpdates)
                    var reqParams1 = [String: AnyObject]()
                    reqParams1["request"] = strFanUpdates as AnyObject
                    let url = MediaAPIjava + "request=" + escapedString!
                   */ //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
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
                                                                            if(status1){DispatchQueue.main.async {
                                                                                let response: NSArray = json["responseData"]  as! NSArray
                                                                                
                                                                                // print(response)
                                                                                //let notificationName = Notification.Name("tabindexchange")
                                                                                //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                let tabIndex:[String: Any] = ["index": "fanupdate", "response": response as [AnyObject]]
                                                                                if(self.appDelegate().isFromBanterDeepLink)
                                                                                {
                                                                                    self.appDelegate().isFromBanterDeepLink = false
                                                                                    let notificationName = Notification.Name("tabindexffdeeplink")
                                                                                    NotificationCenter.default.post(name: notificationName, object: nil,
                                                                                                                    userInfo: tabIndex)
                                                                                } else {
                                                                                    let notificationName1 = Notification.Name("_FetchedFanUpdateByID")
                                                                                    NotificationCenter.default.post(name: notificationName1, object: nil,
                                                                                                                    userInfo: tabIndex)
                                                                                }
                                                                                }
                                                                                
                                                                            }
                                                                            else{
                                                                                DispatchQueue.main.async
                                                                                    {
                                                                                        
                                                                                        
                                                                                        
                                                                                        
                                                                                        
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
            /*let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
            let arrdUserJid = myjid?.components(separatedBy: "@")
            let userUserJid = arrdUserJid?[0]
            let myjidtrim: String? = userUserJid
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getfanupdatebyid" as AnyObject
            var dictRequestData = [String: AnyObject]()
            dictRequestData["id"] = id as AnyObject
            dictRequestData["username"] = myjidtrim as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
            
            let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
            
            appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
            } catch let error as NSError {
                print(error)
            }*/
        }
        
    }
    
    @objc func updateView()
    {
        newsdetail = fanupdatedetail[0] as! NSDictionary
        if(newsdetail != nil)
        {
            fanupdateid = (newsdetail.value(forKey: "id") as? Int64)!
            let fanname = appDelegate().ExistingContact(username: (newsdetail.value(forKey: "username") as? String)!)
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login == nil){
            appDelegate().pageafterlogin = "fanupdate"
                appDelegate().idafterlogin = fanupdateid
            }
            if(fanname == "You")
            {
                editView.isHidden = false
                deleteView.isHidden = false
                imgmenu?.isHidden = true
            } else
            {
                editView.isHidden = true
                deleteView.isHidden = true
                imgmenu?.isHidden = false
            }
            
            username?.text = fanname
            /*let lcount = newsdetail.value(forKey: "likecount") as? Int
            LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Likes"
            let ccount = newsdetail.value(forKey: "commentcount") as? Int
            CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comments"
            
            let vcount = newsdetail.value(forKey: "viewcount") as? Int
            ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"
            */
            let lcount = newsdetail.value(forKey: "likecount") as? Int
            if(lcount ?? 0 < 2)
            {
                LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Like"
                
            }
            else{
                LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Likes"
                
            }
            //"\(appDelegate().formatPoints(num: 10666660.00 ?? 0) ) Likes"
            let ccount = newsdetail.value(forKey: "commentcount") as? Int
            
            if(ccount ?? 0 < 2)
            {
                CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comment"
            }
            else{
                CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comments"
                
            }
            let vcount = newsdetail.value(forKey: "viewcount") as? Int
            if(vcount ?? 0 < 2)
            {
                ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) View"
                
            }
            else{
                ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"
                
            }
 
            let teamId = newsdetail.value(forKey: "relatedteam") as! Int
            let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
            let array1 = Teams_details.rows(filter:"team_Id = \(teamId)") as! [Teams_details]
            if(array1.count != 0) {
                let disnarysound = array1[0]
                teamTitle?.text = disnarysound.team_name
            }
            let teamImg: String? = UserDefaults.standard.string(forKey: teamImageName)
            if((teamImg) != nil)
            {
                teamImage?.image = appDelegate().loadProfileImage(filePath: teamImg!)
                
            }
            else
            {
                teamImage?.image = UIImage(named: "team")
            }
            
            
            let isLiked: Bool = newsdetail.value(forKey: "liked") as! Bool
            if(isLiked){
                likeImage.image = UIImage(named: "liked")
                likeText.setTitle("Liked", for: .normal)
            }
            else{
                likeImage.image = UIImage(named: "like")
                likeText.setTitle("Like", for: .normal)
            }
            
            
            fanImage?.image = UIImage(named: "user")
            if(newsdetail.value(forKey: "avatar") != nil)
            {
                let avatar:String = (newsdetail.value(forKey: "avatar") as? String)!
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
                                fanImage?.image = UIImage(contentsOfFile: imageURL.path)
                            }
                        } else {
                            // print("File does not exist")
                            appDelegate().loadImageFromUrl(url: avatar, view: fanImage!)
                            
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
                    catch let error as NSError {
                        print("An error took place: \(error)")
                        LoadingIndicatorView.hide()
                        
                    }
                    
                }
                else
                {
                    fanImage?.image = UIImage(named: "user")
                }
            }
            else
            {
                //cell.contactImage?.image = UIImage(named: "user")
                
                fanImage?.image = UIImage(named: "user")
            }
            
            fanImage?.layer.masksToBounds = true;
            fanImage?.layer.borderWidth = 1.0
            fanImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
            //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
            fanImage?.layer.cornerRadius = 35.0
            
            let messageContent = newsdetail.value(forKey: "message")as! String
            
            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                do {
                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                    
                    let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                    
                    if(jsonDataMessage?.value(forKey: "subtype") != nil)
                    {
                        let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                        if(subtype.contains("post")){
                            teamImage?.isHidden = false
                            teamTitle.isHidden = false
                           // time?.isHidden = false
                            let longPressGesture_showchat:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                            longPressGesture_showchat.delegate = self as? UIGestureRecognizerDelegate
                            let longPressGesture_showchat1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                                           //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                                           longPressGesture_showchat1.delegate = self as? UIGestureRecognizerDelegate
                                                
                            username?.addGestureRecognizer(longPressGesture_showchat1)
                            username?.isUserInteractionEnabled = true
                            fanImage?.addGestureRecognizer(longPressGesture_showchat)
                            fanImage?.isUserInteractionEnabled = true
                            lbl_subtype?.isHidden = true
                         
                        }
                        else{
                            username?.text = newsdetail.value(forKey: "nickname") as? String
                            teamImage?.isHidden = true
                            teamTitle?.isHidden = true
                            //time?.isHidden = true
                            lbl_subtype?.isHidden = false
                            lbl_subtype.text = subtype.capitalizingFirstLetter()
                        }
                    }
                    else{
                        teamImage?.isHidden = false
                        teamTitle?.isHidden = false
                       // time?.isHidden = false
                        lbl_subtype?.isHidden = true
                        let longPressGesture_showchat:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                        longPressGesture_showchat.delegate = self as? UIGestureRecognizerDelegate

                        let longPressGesture_showchat1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showchat(_:)))
                                       //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                                       longPressGesture_showchat1.delegate = self as? UIGestureRecognizerDelegate
                        username.addGestureRecognizer(longPressGesture_showchat1)
                        username.isUserInteractionEnabled = true
                        fanImage?.addGestureRecognizer(longPressGesture_showchat)
                        fanImage?.isUserInteractionEnabled = true
                    }
                   /* if(recMessageType == "image" || recMessageType == "video")
                    {
                        if((newsdetail.value(forKey: "status") as? String) != "downloading")
                        {
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            let arrReadselVideoPath = selVideoPath.components(separatedBy: "/")
                            let imageId = arrReadselVideoPath.last
                            let arrReadimageId = imageId?.components(separatedBy: ".")
                            var documentsPath: String = ""
                            if(recMessageType == "image")
                            {
                                documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".png")
                            }
                            else if (recMessageType == "video")
                            {
                                documentsPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".mp4")
                            }
                            
                            
                            
                            let fileManager = FileManager.default
                            //try fileManager.removeItem(atPath: imageId)
                            // Check if file exists
                            if fileManager.fileExists(atPath: documentsPath) {
                                
                                // var dict1: [String: AnyObject] = fanupdatedetail
                                //dict1["status"] = "exist" as AnyObject
                                //fanupdatedetail = dict1 as AnyObject
                                if(recMessageType == "video") {
                                    playImage?.image = UIImage(named: "play")
                                    let videoLogo = self.getVideoThumbnailImage(forUrl: NSURL(string: "file://" + documentsPath)! as URL)!
                                    
                                    if(videoLogo.imageAsset != nil)
                                    {
                                        updateImage?.image = videoLogo
                                    }
                                    
                                }
                                else{
                                    
                                    let imageURL = URL(fileURLWithPath:  documentsPath)
                                    updateImage?.image = UIImage(contentsOfFile: imageURL.path)
                                    
                                    //cell.PlayImage?.image = UIImage(named: "uncheck")
                                }
                            } else
                            {
                                
                                var thumbLink: String = ""
                                if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                {
                                    thumbLink = thumb as! String
                                }
                                
                                appDelegate().loadImageFromUrl(url: thumbLink,view: updateImage!)
                                
                                //var dict1: [String: AnyObject] = self.appDelegate().arrFanUpdatesTeams[indexPath.row] as! [String: AnyObject]
                                // dict1["status"] = "notexists" as AnyObject
                                //self.appDelegate().arrFanUpdatesTeams[indexPath.row] = dict1 as AnyObject
                                if(recMessageType == "video") {
                                    playImage?.image = UIImage(named: "Dowload")
                                }
                                else{
                                    playImage?.image = UIImage(named: "Dowload")
                                }
                            }
                        } else
                        {
                            if(recMessageType == "video") {
                                //cell.PlayImage?.image = UIImage(named: "grey_play")
                            }
                            else {
                                // cell.PlayImage?.image = UIImage(named: "uncheck")
                            }
                        }
                    } else {
                        //cell.PlayImage?.image = UIImage(named: "uncheck")
                    }*/
                    
                    var msgtime = ""
                    if let mili1 = newsdetail.value(forKey: "time")
                    {
                        let posttime: Int64? = Int64(newsdetail.value(forKey: "time") as! String)
                        let mili: Double = Double(truncating: posttime  as! NSNumber)
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yy HH:mm"
                        //dateFormatter.dateStyle = .short
                        
                        let now = Date()
                        let birthday: Date = myMilliseconds.dateFull as Date
                        let calendar = Calendar.current
                        
                        let ageComponents = calendar.dateComponents([.hour], from: birthday, to: now)
                        let timebefore = Int64(ageComponents.hour!)
                        if(timebefore > 24){
                            msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                        }
                        else{
                            msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                            // dateFormatter.dateFormat = "HH:mm"
                            //msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                        }
                        if(jsonDataMessage?.value(forKey: "subtype") != nil)
                        {
                            let subtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                            if(subtype.contains("post")){
                                 time?.text = msgtime
                            }
                            else{
                                let mili: Double = Double(truncating: mili1  as! NSNumber)
                                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd MMM yy"
                                //dateFormatter.dateStyle = .short
                                
                                let now = Date()
                                let birthday: Date = myMilliseconds.dateFull as Date
                                let calendar = Calendar.current
                                
                                let ageComponents = calendar.dateComponents([.hour], from: birthday, to: now)
                                let timebefore = Int64(ageComponents.hour!)
                                if(timebefore > 24){
                                    msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                }
                                else{
                                    msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                    // dateFormatter.dateFormat = "HH:mm"
                                    //msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                }
                                time?.text = "End Date: " + msgtime
                            }
                        }
                        else{
                            time?.text = msgtime
                        }
                        
                       
                    }
                    //  let banterNick = jsonDataMessage?.value(forKey: "banternickname") as! String
                    
                    if(recMessageType == "text")
                    {
                        let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
                        let decodedString = String(data: decodedData, encoding: .utf8)!
                        updateContent?.text = decodedString
                        
                        updateContent?.isHidden = false
                        
                        //cell.PlayImage?.image = UIImage(named: "uncheck")
                        updateImage?.isHidden = true
                        
                    }
                    else if(recMessageType == "image")
                    {
                        playImage.isHidden = true
                        updateImage?.isHidden = false
                        var caption: String = ""
                        if let capText = jsonDataMessage?.value(forKey: "caption")
                        {
                            caption = capText as! String
                        }
                        
                        if(!caption.isEmpty)
                        {
                            let decodedData = Data(base64Encoded: caption)!
                            let decodedString = String(data: decodedData, encoding: .utf8)!
                            updateContent?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            updateContent?.isHidden = false
                        } else
                        {
                            updateContent?.isHidden = true
                        }
                        
                        updateImage?.contentMode = .scaleAspectFill
                        updateImage?.clipsToBounds = true
                        
                       /* if((newsdetail.value(forKey: "status") as? String) == "downloading")
                        {
                            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: updateImage!.frame.size.width, height: updateImage!.frame.size.height))
                            //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                            updateImage?.addSubview(overlay)
                            LoadingIndicatorView.show(updateImage, loadingText: "Downloading Image")
                            
                        } else
                        {
                            LoadingIndicatorView.hide()
                            updateImage?.removeAllSubviews()
                        }*/
                         var thumbLink: String = ""
                        if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                        {
                            thumbLink = thumb as! String
                        }
                        updateImage.imageURL = thumbLink
                        LoadingIndicatorView.hide()
                        //cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)! + (cell.ContentImage?.frame.height)!)
                    }
                    else if(recMessageType == "video")
                    {
                        playImage.isHidden = false
                        var videoURL: String = ""
                       /* if(appDelegate().GetvalueFromInsentiveConfigTable(Key: isstream)).boolValue{
                        if let smillink = jsonDataMessage?.value(forKey: "smillink")
                        {
                            
                            var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                            if(selVideoPath.isEmpty){
                                selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                videoURL = selVideoPath
                            }
                            else{
                                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                                videoURL = selVideoPath
                            }
                            
                        }
                        else{
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                            videoURL = selVideoPath
                        }
                        }
                        else{
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: selVideoPath)
                            videoURL = selVideoPath
                        }*/
                        //cell.PlayImage?.isHidden = false
                        var thumbLink: String = ""
                                               if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                                               {
                                                   thumbLink = thumb as! String
                                               }
                                               updateImage.imageURL = thumbLink
                        updateImage?.isHidden = false
                        var caption: String = ""
                        if let capText = jsonDataMessage?.value(forKey: "caption")
                        {
                            caption = capText as! String
                        }
                        
                        if(!caption.isEmpty)
                        {
                            let decodedData = Data(base64Encoded: caption)!
                            let decodedString = String(data: decodedData, encoding: .utf8)!
                            updateContent?.text = decodedString.trimmingCharacters(in: .whitespacesAndNewlines)
                            updateContent?.isHidden = false
                        } else
                        {
                            updateContent?.text = ""
                            updateContent?.isHidden = true
                        }
                        
                        progress.isHidden = true
                        //updateImage.imageURL = thumbLink
                        //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "progress", withExtension: "gif")!)
                        // let advTimeGif = UIImage.gifImageWithData(imageData!)
                      // progress.image = UIImage.gifImageWithData(imageData!)
                        updateImage?.contentMode = .scaleAspectFill
                        updateImage?.clipsToBounds = true
                        playImage.isHidden = false
                       /* videoLayer.frame = updateImage.bounds//CGRect(x: 0, y: 0, width: shotImageView.frame.width, height: shotImageView.frame.width)
                        videoLayer.accessibilityValue = "Detail"
                         videoLayer.backgroundColor = UIColor.gray.cgColor
                        updateImage.layer.addSublayer(videoLayer as CALayer)
                       */
                        LoadingIndicatorView.hide()
                      /*  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: self.videoLayer, url: videoURL)
                        }*/
                        //print(videoLayer.player?.status)
 /* if((newsdetail.value(forKey: "status") as? String) == "downloading")
                        {
                            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: updateImage!.frame.size.width, height: updateImage!.frame.size.height))
                            //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                            updateImage?.addSubview(overlay)
                            LoadingIndicatorView.show(updateImage, loadingText: "\nDownloading Video")
                            
                        } else
                        {
                            LoadingIndicatorView.hide()
                            updateImage?.removeAllSubviews()
                        }*/
                        //cell.containViewConstraint.constant = CGFloat((cell.ContentText?.frame.height)! + (cell.ContentImage?.frame.height)!)
                    }
                    
                    let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                    let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                    
                    updateTitle?.text = decodedString1//jsonDataMessage?.value(forKey: "title") as? String
                    //navItem.title = decodedString1
                    self.navigationItem.title = decodedString1
                    
                    let screenSize = UIScreen.main.bounds
                    let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width-40, height: CGFloat.greatestFiniteMagnitude))
                    label.font = UIFont.systemFont(ofSize: 17.0)
                    label.text = updateContent.text
                    label.textAlignment = .left
                    //label.textColor = self.strokeColor]
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 0
                    label.sizeToFit()
                    
                    
                    if(recMessageType == "text")
                    {
                        updateImage?.isHidden = true
                        updateContentTop.constant = CGFloat(-250)
                        if((label.frame.height) > 17)
                        {
                            let height = (label.frame.height) - 250.0
                            scrollViewHeight.constant = CGFloat(height)
                            //print("Height \(height).")
                            // scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: height)
                        }
                        else
                        {
                            let height = 350.0
                            // cell.mainViewConstraint.constant = CGFloat(height)
                            //print("Height \(height).")
                            scrollViewHeight.constant = CGFloat(height)
                            //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 542.0)
                        }
                        
                        
                    }
                    else
                    {
                        /*let height = 470.0
                         // cell.mainViewConstraint.constant = CGFloat(height)
                         print("Height \(height).")
                         storyTableView?.rowHeight = CGFloat(height)*/
                        //print(cell.ContentText?.text)
                        if((label.frame.height) > 17)
                        {
                            let height = (label.frame.height) + 150.0
                            //print("Height \((label.frame.height)).")
                            scrollViewHeight.constant = CGFloat(height)
                            
                            // scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(height))
                        }
                        else
                        {
                            let height = 270.0 //(cell.ContentText?.frame.height)! + 410.0
                            //print("Height \((label.frame.height)).")
                            scrollViewHeight.constant = CGFloat(height)
                        }
                        
                        
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
                
            }
            
            //updateTitle?.text = newsdetail.value(forKey: "title") as! String
            
            //updateContent?.text = newsdetail.value(forKey: "description") as! String
            
            
            /*
             var thumbLink: String = ""
             if let thumb = newsdetail.value(forKey: "urls")
             {
             thumbLink = thumb as! String
             }
             
             if(!thumbLink.isEmpty)
             {
             appDelegate().loadImageFromUrl(url: thumbLink,view: updateImage!)
             } else {
             updateImage.image = UIImage(named: "img_thumb")
             }
             
             updateImage?.contentMode = .scaleAspectFill
             updateImage?.clipsToBounds = true
             */
            
            
            
            
            //scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 2000)
            
            let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
            
            playImage?.addGestureRecognizer(longPressGesture_showpreview)
            playImage?.isUserInteractionEnabled = true
            
            
            updateImage?.addGestureRecognizer(longPressGesture_showpreview1)
            updateImage?.isUserInteractionEnabled = true
            
            let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
            
            
            let longPressGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture2.delegate = self as? UIGestureRecognizerDelegate
            
            
            like?.addGestureRecognizer(longPressGesture)
            like?.isUserInteractionEnabled = true
            
            likeImage?.addGestureRecognizer(longPressGesture1)
            likeImage?.isUserInteractionEnabled = true
            
            likeText?.addGestureRecognizer(longPressGesture2)
            likeText?.isUserInteractionEnabled = true
            
            
            let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_share2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share2.delegate = self as? UIGestureRecognizerDelegate
            
            share?.addGestureRecognizer(longPressGesture_share)
            share?.isUserInteractionEnabled = true
            
            shareImage?.addGestureRecognizer(longPressGesture_share1)
            shareImage?.isUserInteractionEnabled = true
            
            shareText?.addGestureRecognizer(longPressGesture_share2)
            shareText?.isUserInteractionEnabled = true
            
            let longPressGesture_comment:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_comment.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_comment1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_comment1.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_comment2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_comment2.delegate = self as? UIGestureRecognizerDelegate
            
            
            let longPressGesture_comment3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_comment3.delegate = self as? UIGestureRecognizerDelegate
            
            
            comment?.addGestureRecognizer(longPressGesture_comment)
            comment?.isUserInteractionEnabled = true
            
            commentImage?.addGestureRecognizer(longPressGesture_comment1)
            commentImage?.isUserInteractionEnabled = true
            
            commentText?.addGestureRecognizer(longPressGesture_comment2)
            commentText?.isUserInteractionEnabled = true
            
            
            CommentCount?.addGestureRecognizer(longPressGesture_comment3)
            CommentCount?.isUserInteractionEnabled = true
            
            let longPressGesture_like_count:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LikeCountClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_like_count.delegate = self as? UIGestureRecognizerDelegate
            
            
            LikeCount?.addGestureRecognizer(longPressGesture_like_count)
            LikeCount?.isUserInteractionEnabled = true
            
            
            
            
            let longPressGesture_editUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
            longPressGesture_editUpdate.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_editUpdate1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
            longPressGesture_editUpdate1.delegate = self as? UIGestureRecognizerDelegate
            
            let longPressGesture_editUpdate2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditClick(_:)))
            longPressGesture_editUpdate2.delegate = self as? UIGestureRecognizerDelegate
            
            editUpdate?.addGestureRecognizer(longPressGesture_editUpdate)
            editUpdate?.isUserInteractionEnabled = true
            
            editImage?.addGestureRecognizer(longPressGesture_editUpdate1)
            editImage?.isUserInteractionEnabled = true
            
            editView?.addGestureRecognizer(longPressGesture_editUpdate2)
            editView?.isUserInteractionEnabled = true
            
            
            let longPressGesture_deleteUpdate:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
            longPressGesture_deleteUpdate.delegate = self as? UIGestureRecognizerDelegate
            
            
            let longPressGesture_deleteUpdate1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
            longPressGesture_deleteUpdate1.delegate = self as? UIGestureRecognizerDelegate
            
            
            let longPressGesture_deleteUpdate2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
            longPressGesture_deleteUpdate2.delegate = self as? UIGestureRecognizerDelegate
            
            deleteUpdate?.addGestureRecognizer(longPressGesture_deleteUpdate)
            deleteUpdate?.isUserInteractionEnabled = true
            
            deleteImage?.addGestureRecognizer(longPressGesture_deleteUpdate1)
            deleteImage?.isUserInteractionEnabled = true
            
            deleteView?.addGestureRecognizer(longPressGesture_deleteUpdate2)
            deleteView?.isUserInteractionEnabled = true
            
            let longPressGesture_block:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuClick(_:)))
                       longPressGesture_block.delegate = self as? UIGestureRecognizerDelegate
                       
                       imgmenu?.addGestureRecognizer(longPressGesture_block)
                       imgmenu?.isUserInteractionEnabled = true
        }
    }
    
    
    @objc func ShowPreviewClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
            let dict: NSDictionary? = fanupdatedetail[0] as? NSDictionary
            // print(dict)
            // print(dict?.value(forKey: "username"))
            // Configure the cell...
        var dict1: [String: AnyObject] = fanupdatedetail[0] as! [String: AnyObject]
                  var vcount = dict?.value(forKey: "viewcount") as? Int
                  
                  dict1["viewcount"] = vcount!+1 as AnyObject
                  fanupdatedetail[0] = dict1 as AnyObject
                  vcount = vcount! + 1
                 
                  if(vcount ?? 0 < 2)
                  {
                      ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) View"
                      
                  }
                  else{
                      ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"
                      
                  }
        
                 
            let messageContent = dict?.value(forKey: "message")as! String
            
            if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                do {
                    let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                    
                    let selMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                   // let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                   // let arrReadselVideoPath = selVideoPath.components(separatedBy: "/")
                   // let imageId = arrReadselVideoPath.last
                   // let arrReadimageId = imageId?.components(separatedBy: ".")
                    //print(userReadselVideoPath)
                    //let selMessageType = dict?.value(forKey: "type") as! String
                    // let selVideoPath = dict?.value(forKey: "value") as! String
                    //var imageId = message.value(forKey: "filePath") as! String
                    
                    //let fileManager = FileManager.default
                    //imageId = imageId.replace(target: "file://", withString: "")
                   // let url = NSURL(string: selVideoPath)!
                    
                    
                    if(selMessageType == "image")
                    {
                        
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                             let previewController : Previewmidia! = storyBoard.instantiateViewController(withIdentifier: "Previewmidia") as! Previewmidia
                             previewController.videoURL = selVideoPath//videos[indexPath.row]
                             previewController.mediaType = "image"
                             //show(previewController!, sender: self)
                             self.present(previewController, animated: true, completion: nil)*/
                            var media = [AnyObject]()
                            media.append(LightboxImage(
                                imageURL: NSURL(string: selVideoPath)! as URL,
                                text: ""
                            ))
                            if(media.count>0)
                            {
                                //appDelegate().isFromPreview = true
                                let controller = LightboxController(images: media as! [LightboxImage], startIndex: 0)
                                
                                // Set delegates.
                                controller.pageDelegate = self as? LightboxControllerPageDelegate
                                //controller.dismissalDelegate = self
                                
                                // Use dynamic background.
                                controller.dynamicBackground = true
                                //controller.currentPage = 2
                                // Present your controller.
                                self.present(controller, animated: true, completion: nil)
                            }
                        
                        /*//let mediaURL = message.value(forKey: "filePath") as! String
                        //let asset: PHAsset = PHAssetForFileURL(url: NSURL(string: mediaURL)!)!
                        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".png")
                        
                        do {
                            let fileManager = FileManager.default
                            //try fileManager.removeItem(atPath: imageId)
                            // Check if file exists
                            if fileManager.fileExists(atPath: paths) {
                                // Delete file
                                //print("File  exist")
                                appDelegate().isFromPreview = true
                                
                                if(!paths.isEmpty)
                                {
                                    let path_file = "file://" + paths
                                    showMediaPreview(selMessageType, mediaPath: path_file, isLocalMedia: false)
                                    
                                }
                            } else {
                                // print("File does not exist")
                                
                                
                                let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: updateImage!.frame.size.width, height: updateImage!.frame.size.height))
                                //overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
                                self.updateImage?.addSubview(overlay)
                                LoadingIndicatorView.show(overlay, loadingText: "Downloading Image")
                                
                                self.playImage?.image = UIImage(named: "uncheck")
                                var dict1: [String: AnyObject] = fanupdatedetail[0] as! [String: AnyObject]
                                dict1["status"] = "downloading" as AnyObject
                                fanupdatedetail[0] = dict1 as AnyObject
                                
                                let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                                    // if responseData is not null...
                                    if let data = responseData{
                                        
                                        // execute in UI thread
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            //let tmpImg = UIImage(data: data)
                                            //Store image to local path
                                            //self.saveImageToLocalWithName(UIImage(data: data)!,fileName: "")
                                            //let uuid = UUID().uuidString
                                            let filePath = self.saveImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: arrReadimageId![0])
                                            self.playImage?.image = UIImage(named: "uncheck")
                                            //print(filePath)
                                            var dict1: [String: AnyObject] = self.fanupdatedetail[0] as! [String: AnyObject]
                                            dict1["status"] = "exist" as AnyObject
                                            self.fanupdatedetail[0] = dict1 as AnyObject
                                            LoadingIndicatorView.hide()
                                            
                                            let documentsPath: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + arrReadimageId![0] + ".png")
                                            let imageURL = URL(fileURLWithPath:  documentsPath)
                                            self.updateImage?.image = UIImage(contentsOfFile: imageURL.path)
                                            self.updateImage?.removeAllSubviews()
                                            self.appDelegate().updateViewCount("fanupdate", id: dict?.value(forKey: "id") as! Int64)
                                            
                                        })
                                    }
                                    else{
                                        var dict1: [String: AnyObject] = self.fanupdatedetail[0] as! [String: AnyObject]
                                        dict1["status"] = "notexists" as AnyObject
                                        self.fanupdatedetail[0] = dict1 as AnyObject
                                        // self.playImage?.image = UIImage(named: "play")
                                        self.updateView()
                                        
                                    }
                                }
                                
                                // Run task
                                task.resume()
                                //End Code to fetch media from live URL
                                
                            }
                            
                        }
                        catch let error as NSError {
                            print("An error took place: \(error)")
                            LoadingIndicatorView.hide()
                            updateView()
                        }
                        */
                        
                    }
                    else if(selMessageType == "video")
                    {
                        /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                                                            let previewController : MediaPreviewController! = storyBoard.instantiateViewController(withIdentifier: "MediaPreview") as? MediaPreviewController*/
                         var videoPath = ""
                                                                                            
                          if(appDelegate().GetvalueFromInsentiveConfigTable(Key: isstream)).boolValue{
                            if (jsonDataMessage?.value(forKey: "smillink")) != nil
                        {
                            
                            var selVideoPath: String = (jsonDataMessage?.value(forKey: "smillink") as? String)!
                            if(selVideoPath.isEmpty){
                                selVideoPath = (jsonDataMessage?.value(forKey: "value") as? String)!
                                // cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                                videoPath = selVideoPath
                            }
                            else{
                                //cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                                videoPath = selVideoPath
                            }
                            
                        }
                        else{
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            // cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                            videoPath = selVideoPath
                        }
                        }
                          else{
                            let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                            // cell.configureCell(imageUrl: thumbLink, description: "Videos", videoUrl: selVideoPath)
                            videoPath = selVideoPath
                        }
                        
                        let urlvalue = URL(string:videoPath)
                                                                                                                   let yourplayer = AVPlayer(url: urlvalue!)

                                                                                                                   //Create player controller and set it’s player
                                                                                                                   //let playerController = LandscapePlayer()
                                                                                                                   let playerController = AVPlayerViewController()
                                                                                                                   playerController.player = yourplayer
                                                                                                                  
                                                                                                                   //Final step To present controller  with player in your view controller
                                                                                                                   present(playerController, animated: true, completion: {
                                                                                                                      playerController.player!.play()
                                                                                                                   })
                        //previewController.videoURL = selVideoPath//videos[indexPath.row]
                        /*previewController.isLocalMedia = false
                                                                                                          
                        previewController.mediaType = "video"
                        show(previewController!, sender: self)*/
                         //self.present(previewController, animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                     updateView()
                }
            }
        self.appDelegate().updateViewCount("fanupdate", id: dict?.value(forKey: "id") as! Int64)
                 
        
    }
    
    
    @IBAction func pressBack () {
        self.dismiss(animated: true, completion: nil)
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
    
    
    func saveImageToLocalWithNameReturnPath(_ image: UIImage, fileName: String) -> String{
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdates/" + fileName + ".png")
        //print(paths)
        if(fileManager.fileExists(atPath: paths))
        {
           // print(paths)
        }
        else
        {
            let imageData = image.jpegData(compressionQuality: 1)
            
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        }
        
        return "file://" + paths
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
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            FanUpdateDetailViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return FanUpdateDetailViewController.realDelegate!;
    }
    @objc func MenuClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
          
           if(fanupdatedetail.count > 0){
                let dict: NSDictionary? = fanupdatedetail[0] as? NSDictionary
               let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
              
              
               let NobodyAction = UIAlertAction(title: "Report & Block Content", style: .default, handler: {
                   (alert: UIAlertAction!) -> Void in
                   //print("Choose Photo")
                   //Code to show gallery
                   let login: String? = UserDefaults.standard.string(forKey: "userJID")
                          if(login != nil){
                  let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                 let myTeamsController : ReportViewController = storyBoard.instantiateViewController(withIdentifier: "report") as! ReportViewController
                   myTeamsController.contentid =  dict?.value(forKey: "id") as! Int64
                           let myjid =   dict?.value(forKey: "username") as! String
                           let arrdUserJid = myjid.components(separatedBy: "@")
                           let userUserJid = arrdUserJid[0]
                           myTeamsController.contentid =  dict?.value(forKey: "id") as! Int64
                           myTeamsController.s_owner =  userUserJid
                           
                           //New code by Ravi to pass Title as well 08-02-2020
                           let messageContent = dict?.value(forKey: "message")as! String
                           
                           if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                           {
                               do {
                                   let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                                   
                                   let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                                   let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                                   myTeamsController.contenttitle = decodedString1
                                   
                                   
                               } catch let error as NSError {
                                   print(error)
                               }
                               
                           }
                           
                           //End
                           
                                 //show(myTeamsController, sender: self)
                                 self.show(myTeamsController, sender: self)
                  }
                         else{
                           self.appDelegate().LoginwithModelPopUp()
                         }
                   
               })
               let blockAction = UIAlertAction(title: "Block Fan", style: .default, handler: {
                                                    (alert: UIAlertAction!) -> Void in
                                                    //print("Choose Photo")
                                                    //Code to show gallery
                                                    let login: String? = UserDefaults.standard.string(forKey: "userJID")
                                                           if(login != nil){
                                                              let name:String = self.appDelegate().ExistingContact(username: (dict?.value(forKey: "username") as? String)!)!
                                                               let alert = UIAlertController(title: nil, message: "Blocking \"\(name)\" will block all their content.\n\nDo you really want to block this fan?", preferredStyle: .alert)
                                                               let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
                                                                   
                                                               });
                                                               let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                                                              let login: String? = dict?.value(forKey: "username") as? String
                                                                                            let arrReadUserJid = login?.components(separatedBy: "@")
                                                                                            let userReadUserJid = arrReadUserJid?[0]
                                                                                            
                                                                                            let myMobile: String? = userReadUserJid
                                                                                              self.appDelegate().fanstoryUserBlock(blockuser: myMobile!)
                                                                   });
                                                                                                                                              alert.addAction(action)
                                                                                                                                              alert.addAction(action1)
                                                                                                                                              self.present(alert, animated: true, completion:nil)
                                                  
                                                   }
                                                          else{
                                                            self.appDelegate().LoginwithModelPopUp()
                                                          }
                                                    
                                                })
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                   (alert: UIAlertAction!) -> Void in
                   //print("Cancelled")
                   
                    //self.storyTableView?.reloadData()
               })
               
               optionMenu.addAction(NobodyAction)
               optionMenu.addAction(blockAction)
               optionMenu.addAction(cancelAction)
               
               self.present(optionMenu, animated: true, completion: nil)
           }
          
       }
    @objc func LikeClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Like Click")
        if ClassReachability.isConnectedToNetwork() {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let dict: NSDictionary? = fanupdatedetail[0] as? NSDictionary
        let isLiked: Bool = dict?.value(forKey: "liked") as! Bool
            let Likedcount: Int32 = dict?.value(forKey: "likecount") as! Int32
        if(isLiked){
            
            var dict1: [String: AnyObject] = fanupdatedetail[0] as! [String: AnyObject]
            dict1["liked"] = 0 as AnyObject
            dict1["likecount"] = Likedcount-1 as AnyObject
            fanupdatedetail[0] = dict1 as AnyObject
            likeImage.image = UIImage(named: "like")
            likeText.setTitle("Like", for: .normal)
            
            
            let dict2: NSDictionary? = fanupdatedetail[0] as? NSDictionary
            let lcount = dict2?.value(forKey: "likecount") as? Int32
            LikeCount?.text = "\(lcount ?? 0) Likes"
            let ccount = dict2?.value(forKey: "commentcount") as? Int32
            CommentCount?.text = "\(ccount ?? 0) Comments"
            
            
        }
        else{
            var dict1: [String: AnyObject] = fanupdatedetail[0] as! [String: AnyObject]
            dict1["liked"] = 1 as AnyObject
            dict1["likecount"] = Likedcount + 1 as AnyObject
            fanupdatedetail[0] = dict1 as AnyObject
            likeImage.image = UIImage(named: "liked")
            likeText.setTitle("Liked", for: .normal)
            
            let dict2: NSDictionary? = fanupdatedetail[0] as? NSDictionary
            let lcount = dict2?.value(forKey: "likecount") as? Int32
            LikeCount?.text = "\(lcount ?? 0) Likes"
            let ccount = dict2?.value(forKey: "commentcount") as? Int32
            CommentCount?.text = "\(ccount ?? 0) Comments"
            
        }
        
         var dictRequest = [String: AnyObject]()
                      dictRequest["cmd"] = "savelike" as AnyObject
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
                          let time: Int64 = self.appDelegate().getUTCFormateDate()
                          
                          
                          let myjidtrim: String? = userUserJid
                          dictRequestData["fanupdateid"] = dict?.value(forKey: "id") as AnyObject
                          dictRequestData["time"] = time as AnyObject
                          dictRequestData["username"] = myjidtrim as AnyObject
                          dictRequest["requestData"] = dictRequestData as AnyObject
                          //dictRequest.setValue(dictMobiles, forKey: "requestData")
                          //print(dictRequest)
                          /*let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                                            if(status1){DispatchQueue.main.async {
                                                                                                                                                let response: NSArray = json["responseData"] as! NSArray
                                                                                                                                                
                                                                                                                                                let dic = response[0] as! NSDictionary
                                                                                                                                                self.appDelegate().updateLikecount(fanuid: dict?.value(forKey: "id") as! Int64, likecount: json["likecount"] as! Int64, commentcount: json["commentcount"] as! Int64, viewcount: json["viewcount"] as! Int64, islike: dic.value(forKey: "liked") as! Bool)
                                                                                                                                                }
                                                                                                                                                   
                                                                                                                                               }
                                                                                                                                               else{
                                                                                                                                                   DispatchQueue.main.async
                                                                                                                                                       {
                                                                                                                                                           
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
                         /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                          let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                          //print(strFanUpdates)
                          self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)*/
                      } catch {
                          print(error.localizedDescription)
                      }
        }else{
            appDelegate().LoginwithModelPopUp()
        }
        }
                          else {
                              alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                              
                          }
     }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
               
           });
           
           alert.addAction(action1)
           self.present(alert, animated: true, completion:nil)
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
    
    
    @objc func CommentClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
       // print("Comment Click")
        //let fanupdateid = newsdetail.value(forKey: "id") as! Int64
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        showCommentWindow(fanuid: fanupdateid)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    @objc func LikeCountClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        ///print("Like Count Click")
        //let fanupdateid = newsdetail.value(forKey: "id") as! Int64
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        showLikeWindow(fanuid: fanupdateid)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
        
    }
    
    
   
    func showCommentWindow(fanuid: Int64) {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : CommentViewController! = storyBoard.instantiateViewController(withIdentifier: "Comment") as? CommentViewController
        registerController.fanupdateid = fanuid
        //registerController.SelectedTitel = SelectedTitel
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    func showEditWindow(dict: NSDictionary) {
        if ClassReachability.isConnectedToNetwork() {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : EditFanUpdateViewController! = storyBoard.instantiateViewController(withIdentifier: "EditFanUpdate") as? EditFanUpdateViewController
        registerController.dict = dict
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
            }
                   else {
                       alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                       
                   }
    }
    
    
    func showLikeWindow(fanuid: Int64) {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : LikeViewController! = storyBoard.instantiateViewController(withIdentifier: "likes") as? LikeViewController
        registerController.fanupdateid = fanuid
        //registerController.SelectedTitel = SelectedTitel
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    
    
    
    
    
    
    @objc func EditClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Edit Click")
        if ClassReachability.isConnectedToNetwork() {
        let dict: NSDictionary? = fanupdatedetail[0] as? NSDictionary
            showEditWindow(dict: dict!)
        fromBanter = false
        self.appDelegate().isFromBanterDeepLink = false
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    
    @objc func DeleteClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Delete Click")
       // let dict: NSDictionary? = fanupdatedetail[0] as? NSDictionary
        if ClassReachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
                // print(dict)
                // print(dict?.value(forKey: "username"))
                //let fanupdateid = dict?.value(forKey: "id") as! Int64
                
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "deletefanupdate" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                do {
                    
                    
                    //Creating Request Data
                    var dictRequestData = [String: AnyObject]()
                    let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    //let time: Int64 = self.appDelegate().getUTCFormateDate()
                    
                    
                    let myjidtrim: String? = userUserJid
                    dictRequestData["fanupdateid"] = self.fanupdateid as AnyObject
                    dictRequestData["username"] = myjidtrim as AnyObject
                    dictRequest["requestData"] = dictRequestData as AnyObject
                    //dictRequest.setValue(dictMobiles, forKey: "requestData")
                    //print(dictRequest)
                    
                   /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                    //print(strFanUpdates)
                    self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)*/
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
                                                                                                                                                                                                                                                                                                                             Clslogging.loginfo(State: "savefanupdates", userinfo: json as [String : AnyObject])
                                                                                                                                                                                                                                                                                                                              if(status1){
                                                                                                                                                                                                                                                                                                                                  if(self.appDelegate().isOnMyFanStories){
                                                                                                                                                                                                                                                                                                                                                                                     let notificationName = Notification.Name("_MyFechedFanUpdate")
                                                                                                                                                                                                                                                                                                                                                                                     NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                                                                                                  else if(self.appDelegate().isOnFanDetail){
                                                                                                                                                                                                                                                                                                                                                                                     let notificationName = Notification.Name("_fanupdatedelete")
                                                                                                                                                                                                                                                                                                                                                                                     NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                                                                                                                                                 else{
                                                                                                                                                                                                                                                                                                                                                                                     let notificationName = Notification.Name("_FechedFanUpdate")
                                                                                                                                                                                                                                                                                                                                                                                     NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                                                                              else{
                                                                                                                                                                                                                                                                                                                                  if(self.appDelegate().isOnMyFanStories){
                                                                                                                                                                                                                                                                                                                                                                                         let notificationName = Notification.Name("_MyFechedFanUpdate")
                                                                                                                                                                                                                                                                                                                                                                                         NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                                                                                                                                     else{
                                                                                                                                                                                                                                                                                                                                                                                         let notificationName = Notification.Name("_FechedFanUpdate")
                                                                                                                                                                                                                                                                                                                                                                                         NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                                                                                     }
                                                                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                          
                                                                                                                                                                                                                      }
                                                                                                                                                                                                                  case .failure(let error):
                                                                                                                                                                                                                                                                             debugPrint(error as Any)
                                                                                                                                                                                                                                                                             if(self.appDelegate().isOnMyFanStories){
                                                                                                                                                                                                                                                                                                                                   let notificationName = Notification.Name("_MyFechedFanUpdate")
                                                                                                                                                                                                                                                                                                                                   NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                               }
                                                                                                                                                                                                                                                                                                                               else{
                                                                                                                                                                                                                                                                                                                                   let notificationName = Notification.Name("_FechedFanUpdate")
                                                                                                                                                                                                                                                                                                                                   NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                                                                                                                                                                               }
                                                                                                                                                                            
                                                                                                                                                                            break
                                                                                                                                                                                                                      // error handling
                                                                                                                                                                                                       
                                                                                                                                                                                                                  }
                                                                                                                                                                  }
                   // self.dismiss(animated: true, completion: nil)
                } catch {
                    print(error.localizedDescription)
                }
                
                
            });
            let action1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default,handler: {_ in
            });
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion:nil)
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    
    
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
            do {
                //let fanupdateid = newsdetail.value(forKey: "id") as! Int64
                var dictRequest = [String: AnyObject]()
                dictRequest["id"] = fanupdateid as AnyObject
                dictRequest["type"] = "fanupdate" as AnyObject
                let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                
                let messageContent = newsdetail.value(forKey: "message")as! String
                
                if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                {
                    do {
                        let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                        
                        let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                        let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                        
                        let title = decodedString1
                
                let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                
                let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                
                let param = resultNSString as String?
                
                let inviteurl = InviteHost + "?q=" + param!
                
                let text = "\(title)\n\nFan Story shared via Football Fan App.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."
                                      //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                                    
                                      let objectsToShare = [text] as [Any]
                                                                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                                            
                                                                            //New Excluded Activities Code
                                                                            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                                                            //
                                                                            
                                                                    activityVC.popoverPresentationController?.sourceView = self.view
                                                                            self.present(activityVC, animated: true, completion: nil)
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        
        
    }
    @objc func Showchat(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
           // Configure the cell...
        
            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
       
        if(myjid != nil){
            let arrdUserJid = myjid?.components(separatedBy: "@")
            let userUserJid = arrdUserJid?[0]
           // if(userUserJid != newsdetail.value(forKey: "username") as? String)
            //{
               // appDelegate().toUserJID = (newsdetail.value(forKey: "username") as? String)! + JIDPostfix//(dict?.value(forKey: "jid") as? String)!
                //appDelegate().toName = appDelegate().ExistingContact(username: (newsdetail.value(forKey: "username") as? String)!)!//(dict?.value(forKey: "username") as? String)!
                if let tmpAvatar = newsdetail.value(forKey: "avatar")
                {
                    appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
                }
                else
                {
                    appDelegate().toAvatarURL = ""
                }
                showChatWindow(roomid: (newsdetail.value(forKey: "username") as? String)! + JIDPostfix)
           // }
        }else{
            appDelegate().LoginwithModelPopUp()
        }
        }
    
    func showChatWindow(roomid: String) {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                              let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                             myTeamsController.RoomJid = roomid//dict.value(forKey: "jid") as! String //+ JIDPostfix
                                              show(myTeamsController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
   
    
}
