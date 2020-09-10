//
//  NewsCommentViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 14/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

class NewsCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var fanupdateid = 0 as Int64
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var messageBox: GrowingTextView!
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var note: UILabel!
    var lastposition = 0
    // var activityIndicator: UIActivityIndicatorView?
    var refreshTable: UIRefreshControl!
    var SelectedTitel = ""
    @IBOutlet weak var countComment: UILabel!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBAction func sendClick(_ sender: UIButton) {
        if ClassReachability.isConnectedToNetwork() {
            
        if let comment_text: String = self.messageBox!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            if(!comment_text.isEmpty)
            {
                messageBox?.text = ""
                  let time: Int64 = appDelegate().getUTCFormateDate()
                let content = comment_text.replace(target: "~", withString: "-")
                //1. Convert String to base64
                //Convert string to NSData
                let myNSData = content.data(using: String.Encoding.utf8)! as NSData
                //Encode to base64
                let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                
                let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                
                let trimMessage = resultNSString as String
                
                let boundary = appDelegate().generateBoundaryString()
                var request = URLRequest(url: URL(string: MediaAPI)!)
                request.httpMethod = "POST"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                var reqParams = [String: AnyObject]()
                reqParams["cmd"] = "savenewscomment" as AnyObject
                reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
                //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
                reqParams["time"] = time as AnyObject
                reqParams["newsid"] = fanupdateid as AnyObject
                reqParams["comment"] = trimMessage as AnyObject
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
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    if(self.appDelegate().arrNewsComments.count>3){
                                    self.storyTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                    }
                                    //let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                    //let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                    let notificationName = Notification.Name("_SaveCommentNews")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                    //let dict = response[0] as! NSDictionary
                                   
                                    let newsid = jsonData?.value(forKey: "newsid") as! Int
                                    if(self.appDelegate().ActivityPermissionCheck(massegeId: newsid, Type: ThisIsNewsComment)){
                                        self.appDelegate().ActivityCountManage()
                                    }
                                    }
                                }
                                else
                                { DispatchQueue.main.async {
                                    }
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
                
                
                /*var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "savenewscomment" as AnyObject
                
                do {
                    let time: Int64 = appDelegate().getUTCFormateDate()
                    let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                    let arrdUserJid = userJid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    let myNSData = comment_text.data(using: String.Encoding.utf8)! as NSData
                    
                    //Encode to base64
                    let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                    
                    let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                    
                    let trimMessage = resultNSString as String
                    
                    //Creating Request Data
                    var dictRequestData = [String: AnyObject]()
                    
                    dictRequestData["username"] = userUserJid as AnyObject
                    dictRequestData["time"] = time as AnyObject
                    dictRequestData["newsid"] = fanupdateid as AnyObject
                    dictRequestData["comment"] = trimMessage as AnyObject
                    dictRequest["requestData"] = dictRequestData as AnyObject
                    
                    let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                    let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                    self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
                } catch {
                    print(error.localizedDescription)
                }*/
            }
        }
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        
    }
    
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
        //print("fanupdateid")
        //print(fanupdateid)
        messageBox?.layer.masksToBounds = true;
        messageBox?.layer.borderWidth = 1.0
        messageBox?.layer.borderColor = UIColor.lightGray.cgColor
        messageBox?.layer.cornerRadius = 15.0
        messageBox?.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 5)
        messageBox.delegate = self
        messageBox.maxHeight = 60
        messageBox.maxLength = 400
        messageBox.trimWhiteSpaceWhenEndEditing = true
        
        
        //messageBox.pasteDelegate=self as! UITextPasteDelegate
        storyTableView?.backgroundView = UIImageView(image: UIImage(named: "background"))
        storyTableView?.backgroundView?.contentMode = .scaleAspectFill
        
        storyTableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewsCommentViewController.minimiseKeyboard(_:))))
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdateComments(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        storyTableView?.isUserInteractionEnabled = true
        let notificationName1 = Notification.Name("_NewsGetComments")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateGetComments), name: notificationName1, object: nil)
        
        
        let notificationName2 = Notification.Name("_SaveCommentNews")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateComments), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_NewsDeleteComments")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateComments), name: notificationName3, object: nil)
        
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        // print("Start Editing")
        if((messageBox?.text?.count)! >= 400){
            
        }
    }
    /*
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
     return newText.count <= 400
     
     } */
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            bottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            messageBox?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    @objc func refreshFanUpdateComments(_ sender:AnyObject)  {
        lastposition = 0
        let lastindex = 0
        if ClassReachability.isConnectedToNetwork() {
        appDelegate().isNewsPageCommentRefresh = true
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnewscomments" as AnyObject
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
                    if let stringData = String(data: data, encoding: String.Encoding.utf8)
                    {
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
                                let response: NSArray = jsonData?.value(forKey: "data") as! NSArray
                                self.appDelegate().selectednewscommentcount = response.count
                                if(self.appDelegate().isNewsPageCommentRefresh)
                                {
                                    self.appDelegate().arrNewsComments = response  as [AnyObject]
                                }
                                else
                                {
                                    self.appDelegate().arrNewsComments += response  as [AnyObject]
                                }
                                
                                //arrFanUpdateComments = response
                                
                               // let notificationName = Notification.Name("_NewsGetComments")
                               // NotificationCenter.default.post(name: notificationName, object: nil)
                                if(self.activityIndicator?.isAnimating)!
                                {
                                    self.activityIndicator?.stopAnimating()
                                }
                                self.storyTableView?.reloadData()
                                TransperentLoadingIndicatorView.hide()
                                self.closeRefresh()
                                if(self.appDelegate().arrNewsComments.count == 0){
                                    self.storyTableView.isHidden = true
                                    self.note.isHidden = false
                                    self.note.text = "No comments yet."
                                }
                                else{
                                    self.storyTableView.isHidden = false
                                    self.note.isHidden = true
                                }
                                
                                }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageCommentRefresh)
                                {
                                    self.appDelegate().arrNewsComments = [AnyObject]()
                                    if(self.activityIndicator?.isAnimating)!
                                    {
                                        self.activityIndicator?.stopAnimating()
                                    }
                                    self.storyTableView?.reloadData()
                                    TransperentLoadingIndicatorView.hide()
                                    self.closeRefresh()
                                    if(self.appDelegate().arrNewsComments.count == 0){
                                        self.storyTableView.isHidden = true
                                        self.note.isHidden = false
                                        self.note.text = "No comments yet."
                                    }
                                    else{
                                        self.storyTableView.isHidden = false
                                        self.note.isHidden = true
                                    }
                                    //let notificationName = Notification.Name("_NewsGetComments")
                                    //NotificationCenter.default.post(name: notificationName, object: nil)
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
        dictRequest["cmd"] = "getnewscomments" as AnyObject
        
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
    
    @objc func FanUpdateGetComments(_ lastindex : Int)
    {
        if ClassReachability.isConnectedToNetwork() {
        if(lastindex == 0)
        {
            //LoadingIndicatorView.show(self.view, loadingText: "Getting latest comments for you. ")
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            appDelegate().isNewsPageCommentRefresh = true
        } else
        {
            appDelegate().isNewsPageCommentRefresh = false
        }
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getnewscomments" as AnyObject
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
                                let response: NSArray = jsonData?.value(forKey: "data") as! NSArray
                                
                                if(self.appDelegate().isNewsPageCommentRefresh)
                                {
                                    self.appDelegate().arrNewsComments = response  as [AnyObject]
                                }
                                else
                                {
                                    self.appDelegate().arrNewsComments += response  as [AnyObject]
                                }
                                
                                //arrFanUpdateComments = response
                                
                                // let notificationName = Notification.Name("_NewsGetComments")
                                // NotificationCenter.default.post(name: notificationName, object: nil)
                                if(self.activityIndicator?.isAnimating)!
                                {
                                    self.activityIndicator?.stopAnimating()
                                }
                                self.storyTableView?.reloadData()
                                TransperentLoadingIndicatorView.hide()
                                self.closeRefresh()
                                if(self.appDelegate().arrNewsComments.count == 0){
                                    self.storyTableView.isHidden = true
                                    self.note.isHidden = false
                                    self.note.text = "No comments yet."
                                }
                                else{
                                    self.storyTableView.isHidden = false
                                    self.note.isHidden = true
                                }
                                
                                }
                            }
                            else
                            { DispatchQueue.main.async {
                                if(self.appDelegate().isNewsPageCommentRefresh)
                                {
                                    self.appDelegate().arrNewsComments = [AnyObject]()
                                    if(self.activityIndicator?.isAnimating)!
                                    {
                                        self.activityIndicator?.stopAnimating()
                                    }
                                    self.storyTableView?.reloadData()
                                    TransperentLoadingIndicatorView.hide()
                                    self.closeRefresh()
                                    if(self.appDelegate().arrNewsComments.count == 0){
                                        self.storyTableView.isHidden = true
                                        self.note.isHidden = false
                                        self.note.text = "No comments yet."
                                    }
                                    else{
                                        self.storyTableView.isHidden = false
                                        self.note.isHidden = true
                                    }
                                    //let notificationName = Notification.Name("_NewsGetComments")
                                    //NotificationCenter.default.post(name: notificationName, object: nil)
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
            
            
        /*var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "getnewscomments" as AnyObject
        
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
    
    @objc func refreshFanUpdateGetComments()
    {
        
        if(self.activityIndicator?.isAnimating)!
        {
            self.activityIndicator?.stopAnimating()
        }
        storyTableView?.reloadData()
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(self.appDelegate().arrNewsComments.count == 0){
            storyTableView.isHidden = true
            note.isHidden = false
            note.text = "No comments yet."
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
        //self.parent?.title = "SelectedTitel"//SelectedTitel
        //navItem.title = SelectedTitel
        self.navigationItem.title = SelectedTitel
        
        lastposition = 0
        appDelegate().isNewsPageCommentRefresh = true
        FanUpdateGetComments(lastposition)
        
    }
    
    
    @objc func DeleteClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Delete Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
            let dict: NSDictionary? = appDelegate().arrNewsComments[indexPath.row] as? NSDictionary
                let boundary = appDelegate().generateBoundaryString()
                var request = URLRequest(url: URL(string: MediaAPI)!)
                request.httpMethod = "POST"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                var reqParams = [String: AnyObject]()
                reqParams["cmd"] = "deletenewscomment" as AnyObject
                reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
                //reqParams["catid"] =   lastindex as AnyObject//String(describing:  lastindex)
                reqParams["newsid"] = fanupdateid as AnyObject
                reqParams["commentid"] = dict?.value(forKey: "id") as AnyObject
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
                                    //let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                    //let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                    let notificationName = Notification.Name("_SaveCommentNews")
                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                    //let dict = response[0] as! NSDictionary
                                    
                                    let newsid = jsonData?.value(forKey: "newsid") as! Int
                                    if(self.appDelegate().ActivityPermissionCheck(massegeId: newsid, Type: ThisIsNewsComment)){
                                        self.appDelegate().ActivityCountManage()
                                    }
                                    }
                                }
                                else
                                { DispatchQueue.main.async {
                                    }
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
            dictRequest["cmd"] = "deletenewscomment" as AnyObject
            
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
                
                
                //let myjidtrim: String? = userUserJid
                dictRequestData["newsid"] = fanupdateid as AnyObject
                dictRequestData["commentid"] = dict?.value(forKey: "id") as AnyObject
                dictRequestData["username"] = userUserJid as AnyObject
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
        
    }
    
    
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            NewsCommentViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewsCommentViewController.realDelegate!;
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        //print(appDelegate().arrNewsComments.count)
        return self.appDelegate().arrNewsComments.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(appDelegate().arrNewsComments.count > 19)
        {
            let lastElement = appDelegate().arrNewsComments.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                lastposition = lastposition + 1
                FanUpdateGetComments(lastposition)
            }
        }
    }
    
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! CommentCell
        
        let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        
        let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
        
        
        let longPressGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeleteClick(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture2.delegate = self as? UIGestureRecognizerDelegate
        
        
        cell.deleteComment?.addGestureRecognizer(longPressGesture)
        cell.deleteComment?.isUserInteractionEnabled = true
        
        cell.deleteImage?.addGestureRecognizer(longPressGesture1)
        cell.deleteImage?.isUserInteractionEnabled = true
        
        cell.deleteText?.addGestureRecognizer(longPressGesture2)
        cell.deleteText?.isUserInteractionEnabled = true
        
        let dic: NSDictionary? = self.appDelegate().arrNewsComments[indexPath.row] as? NSDictionary
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
        
        
        if(dic?.value(forKey: "username") as? String == userUserJid)
        {
            cell.deleteComment?.isHidden = false
        } else {
            cell.deleteComment?.isHidden = true
        }
        
        let decodedData = Data(base64Encoded: (dic?.value(forKey: "comment") as? String)!)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        
        var msgtime = ""
        if let mili1 = dic?.value(forKey: "time")
        {
            
            let mili: Double = Double(mili1  as! String)!
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
                //dateFormatter.dateFormat = "HH:mm"
                // msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
            }
            cell.commentTime?.text = msgtime
        }
        
        cell.contactComment?.text = decodedString
        if(dic?.value(forKey: "avatar") != nil)
        {
            let avatar:String = (dic!.value(forKey: "avatar") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                //appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
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
        let screenSize = UIScreen.main.bounds
        let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: screenSize.width-40, height: CGFloat.greatestFiniteMagnitude))
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.text = cell.contactComment!.text
        label.textAlignment = .left
        //label.textColor = self.strokeColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        if((label.frame.height) > 17)
        {
            let height = (label.frame.height) + 150.0
            // cell.mainViewConstraint.constant = CGFloat(height)
            //print("Height \(height).")
            storyTableView?.rowHeight = CGFloat(height)
        }
        else
        {
            let height = 160.0
            // cell.mainViewConstraint.constant = CGFloat(height)
            //print("Height \(height).")
            storyTableView?.rowHeight = CGFloat(height)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print("Start Editing")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("Start Editing")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 400
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        //print("End Editing")
        let _: String = messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView)
    {
        
        
        //print("Text did changed")
        let trimMessage: String = messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let trimMessage = messageBox.text!
        //messageBox.text = trimMessage
        if(!trimMessage.isEmpty)
        {
            messageBox?.isScrollEnabled = true
            
            
            
        }
        else
        {
        }
        
        if(trimMessage == UIPasteboard.general.string)
        {
            //self.messageBox?.text = trimMessage + " "
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                let range = NSMakeRange(trimMessage.lengthOfBytes(using: String.Encoding.utf8), 0)
                textView.scrollRangeToVisible(range)
            }
        }
        //print(messageBox?.text.characters.count)
        if((messageBox?.text.count)! <= 400)
        {
            countComment?.text=String(describing: messageBox?.text?.count ?? 0)+"/"+String(describing: 400)
        }
        //messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
        //textView.scrollRectToVisible(messageBox.frame, animated: true)
        
    }
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        /*var userInfo = notification.userInfo!
         var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
         keyboardFrame = self.view.convert(keyboardFrame, from: nil)
         
         var contentInset:UIEdgeInsets = self.storyToolbar?. //.contentInset
         contentInset.bottom = keyboardFrame.size.height
         self.storyToolbar.contentInset = contentInset*/
        //adjustingHeight(show: true, notification: notification)
        //Working Very good
        //animateViewMoving(up: true, moveValue: 200)
        
        isKeyboardHiding = false
        self.storyTableView?.allowsSelection = false
        //scrollToBottom()
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        /*let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         self.storyToolbar.contentInset = contentInset*/
        isKeyboardHiding = true
        adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        
        
    }
    @objc func UIKeyboardDidHide(notification:NSNotification){
        self.storyTableView?.allowsSelection = true
    }
    
    
    
    @objc func keyboardDidChangeFrame(notification:NSNotification){
        if(isKeyboardHiding == false)
        {
            adjustingHeight(show: true, notification: notification)
        }
        //isKeyboardHiding = false
        //self.scrollToBottom()
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        //print(userInfo)
        self.keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        if(isKeyboardHiding == true)
        {
            let changeInHeight = 0.0
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = CGFloat(changeInHeight)
                
            })
        }
        else
        {
            let changeInHeight = (self.keyboardFrame.height) //* (show ? 1 : -1)
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = changeInHeight
                
            })
        }
        
        
        
    }
    
}

extension NewsCommentViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
