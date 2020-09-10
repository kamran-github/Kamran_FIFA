//
//  NewsDetailViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 13/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import AVKit
import WebKit

class NewsDetailViewController:UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var newsCredit: UILabel!
    
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
    @IBOutlet weak var webView: WKWebView!
    
    
    var fanupdatedetail: [AnyObject] = []
    var newsdetail: NSDictionary = [:]
    var position: Int = 0
    var fromBanter = false
    var newsid: Int64 = 0
    var isshowbyBraking = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        let notificationName_ffdeeplink = Notification.Name("_FetchedNewsByID")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewsDetailViewController.refreshView), name: notificationName_ffdeeplink, object: nil)
    }
    
    @objc func refreshView(notification: NSNotification)
    {
        let Status = (notification.userInfo?["index"] )as! String
        
        if(Status == "news")
        {  LoadingIndicatorView.hide()
            newsdetail = notification.userInfo?["response"] as! NSDictionary
            fromBanter = false
            updateView()
            
        }
    }
    
   /* func webViewDidStartLoad(_ webView: UIWebView) {
        // show indicator
       // LoadingIndicatorView.show(self.view, loadingText: "Getting News detail for you.")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // hide indicator
       // LoadingIndicatorView.hide()
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        // hide indicator
      //  LoadingIndicatorView.hide()
    }*/
    
    @objc func updateView()
    {
        LoadingIndicatorView.hide()
        if(newsdetail.count < 1)
        {
            newsdetail = fanupdatedetail[0] as! NSDictionary
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login == nil){
                appDelegate().pageafterlogin = "news"
                appDelegate().idafterlogin = newsdetail.value(forKey: "id") as! Int64
            }
            
           
            self.appDelegate().updateViewCount("news", id: newsdetail.value(forKey: "id") as! Int64)
           
        }
        if(newsdetail.count > 0)
        {
            let viewcount: Int32 = newsdetail.value(forKey: "viewcount") as! Int32
            var dict1: [String: AnyObject] = newsdetail as! [String: AnyObject]
            
            dict1["viewcount"] = viewcount + 1 as AnyObject
            appDelegate().newsdic = dict1 as NSDictionary
            newsdetail = dict1 as NSDictionary
            fanupdatedetail.insert(dict1 as AnyObject, at: 0)
            newsid = (newsdetail.value(forKey: "id") as? Int64)!
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login == nil){
                appDelegate().pageafterlogin = "news"
                appDelegate().idafterlogin = newsid
            }
            self.appDelegate().updateViewCount("news", id: newsid)
            
            
            let stringurl = NewsDeepLinkURL + "\(newsid)"
            if let url = URL(string: stringurl) {
                let request = URLRequest(url: url)
                webView.load(request)
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
            
            if(newsdetail.value(forKey: "title") as? String != nil)
            {
                //newsTitle?.text = newsdetail.value(forKey: "title") as? String
                let decodedData = Data(base64Encoded: (newsdetail.value(forKey: "title") as? String)!)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                
                self.navigationItem.title = decodedString
            }
            
            /*
             if(newsdetail.value(forKey: "description") as? String != nil)
             {
             newsContent?.text = newsdetail.value(forKey: "description") as? String
             }
             
             if(newsdetail.value(forKey: "credit") as? String != nil)
             {
             newsCredit?.text = newsdetail.value(forKey: "credit") as? String
             } */
            
            /*let lcount = newsdetail.value(forKey: "likecount") as? Int
            LikeCount?.text = "\(self.appDelegate().formatNumber(lcount ?? 0)) Likes"
            let ccount = newsdetail.value(forKey: "commentcount") as? Int
            CommentCount?.text = "\(self.appDelegate().formatNumber(ccount ?? 0)) Comments"
            
            let vcount = newsdetail.value(forKey: "viewcount") as? Int
            ViewCount?.text = "\(self.appDelegate().formatNumber(vcount ?? 0)) Views"*/
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
            
            //scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 2000)
            
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
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         appDelegate().isOnNewsDetailView = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appDelegate().openffdeepurl = ""
        appDelegate().isFromBanterDeepLink = false
        appDelegate().isOnNewsDetailView = true
        if(fromBanter)
        {
            updateView()
            //TransperentLoadingIndicatorView.hide()
            fromBanter = false
        } else
        {
            if ClassReachability.isConnectedToNetwork() {
                do {
                    let id: Int64 = newsid
                    
                    
                   // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                    let boundary = appDelegate().generateBoundaryString()
                    var request = URLRequest(url: URL(string: MediaAPI)!)
                    request.httpMethod = "POST"
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    var reqParams = [String: AnyObject]()
                    reqParams["cmd"] = "getnewsbyid" as AnyObject
                    //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
                    reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
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
                                        DispatchQueue.main.async {
                                            self.newsdetail = jsonData?.value(forKey: "data") as! NSDictionary
                                            self.appDelegate().newsdic = self.newsdetail
                                       // TransperentLoadingIndicatorView.hide()
                                       // print(response)
                                        //newsdetail = notification.userInfo?["response"] as! NSDictionary
                                            self.fromBanter = false
                                            self.updateView()
                                        }
                                        //let notificationName = Notification.Name("tabindexchange")
                                        //NotificationCenter.default.post(name: notificationName, object: nil)
                                       /* let tabIndex:[String: Any] = ["index": "news", "response": response ]
                                        if(self.appDelegate().isFromBanterDeepLink)
                                        {
                                            self.appDelegate().isFromBanterDeepLink = false
                                            let notificationName = Notification.Name("tabindexffdeeplink")
                                            NotificationCenter.default.post(name: notificationName, object: nil,
                                                                            userInfo: tabIndex)
                                        } else {
                                            if(self.appDelegate().isOnNewsDetailView){
                                                let notificationName1 = Notification.Name("_FetchedNewsByID")
                                                NotificationCenter.default.post(name: notificationName1, object: nil,
                                                                                userInfo: tabIndex)
                                            }
                                        }*/
                                    }
                                    else
                                    {
                                       // TransperentLoadingIndicatorView.hide() //Show Error
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
                    dictRequest["cmd"] = "getnewsbyid" as AnyObject
                    var dictRequestData = [String: AnyObject]()
                    dictRequestData["id"] = id as AnyObject
                    dictRequestData["username"] = myjidtrim as AnyObject
                    dictRequest["requestData"] = dictRequestData as AnyObject
                    
                    let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                    
                    appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)*/
                } catch let error as NSError {
                    print(error)
                }
            } else {
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
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
            NewsDetailViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewsDetailViewController.realDelegate!;
    }
    
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    @objc func LikeClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Like Click")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if ClassReachability.isConnectedToNetwork() {
            
            newsdetail = fanupdatedetail[0] as! NSDictionary
            let isLiked: Bool = newsdetail.value(forKey: "liked") as! Bool
            let Likedcount: Int32 = newsdetail.value(forKey: "likecount") as! Int32
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
                appDelegate().newsdic = dict2!
                if(isshowbyBraking){
                    var dict1: [String: AnyObject] = appDelegate().BrakingNews[0] as! [String: AnyObject]
                    dict1["liked"] = 0 as AnyObject
                    dict1["likecount"] = Likedcount-1 as AnyObject
                    appDelegate().BrakingNews[position] = dict1 as AnyObject
                }
                
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
                appDelegate().newsdic = dict2!
                if(isshowbyBraking){
                    var dict1: [String: AnyObject] = appDelegate().BrakingNews[0] as! [String: AnyObject]
                    dict1["liked"] = 1 as AnyObject
                    dict1["likecount"] = Likedcount+1 as AnyObject
                    appDelegate().BrakingNews[position] = dict1 as AnyObject
                }
            }
            
            appDelegate().savenewslike(newsid: newsdetail.value(forKey: "id") as AnyObject)
         /*   var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "savenewslike" as AnyObject
            
            do {
                
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                let time: Int64 = self.appDelegate().getUTCFormateDate()
                
                
                let myjidtrim: String? = userUserJid
                dictRequestData["newsid"] = newsdetail.value(forKey: "id") as AnyObject
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
    
    @objc func CommentClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Comment Click")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if ClassReachability.isConnectedToNetwork() {
            newsdetail = fanupdatedetail[0] as! NSDictionary
            let fanupdateid = newsdetail.value(forKey: "id") as! Int64
            showCommentWindow(fanuid: fanupdateid)
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    @objc func LikeCountClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Like Count Click")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if ClassReachability.isConnectedToNetwork() {
            newsdetail = fanupdatedetail[0] as! NSDictionary
            let fanupdateid = newsdetail.value(forKey: "id") as! Int64
            showLikeWindow(fanuid: fanupdateid)
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        }else{
            appDelegate().LoginwithModelPopUp()
        }
        
    }
    
    
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
        //let decodedString = newsdetail.value(forKey: "title")
        do {
            newsdetail = fanupdatedetail[0] as! NSDictionary
            let fanupdateid = newsdetail.value(forKey: "id") as! Int64
            var dictRequest = [String: AnyObject]()
            dictRequest["id"] = fanupdateid as AnyObject
            dictRequest["type"] = "news" as AnyObject
            let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            
            let decodedData = Data(base64Encoded: (newsdetail.value(forKey: "title") as? String)!)!
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
    
    func showCommentWindow(fanuid: Int64) {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let decodedData = Data(base64Encoded: (newsdetail.value(forKey: "title") as? String)!)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : NewsCommentViewController! = storyBoard.instantiateViewController(withIdentifier: "NewsComment") as? NewsCommentViewController
        registerController.fanupdateid = fanuid
        registerController.SelectedTitel = decodedString
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        newsdetail = [:]
        show(registerController, sender: self)
        }
        else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    
    func showLikeWindow(fanuid: Int64) {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let decodedData = Data(base64Encoded: (newsdetail.value(forKey: "title") as? String)!)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let registerController : NewsLikeViewController! = storyBoard.instantiateViewController(withIdentifier: "newslikes") as? NewsLikeViewController
        registerController.fanupdateid = fanuid
        registerController.SelectedTitel = decodedString
        //present(registerController as! UIViewController, animated: true, completion: nil)
        // self.appDelegate().curRoomType = "chat"
        newsdetail = [:]
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
}
