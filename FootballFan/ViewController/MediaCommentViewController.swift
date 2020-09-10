//
//  CommentViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 15/05/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
import Alamofire
class MediaCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
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
 var isFanPageCommentRefresh: Bool = false
 @IBOutlet weak var navItem: UINavigationItem!
     var likecount = 0 as Int64
     var viewcount = 0 as Int64
     var commentcount = 0 as Int64
    var isApicall:Bool = false
    @IBAction func sendClick(_ sender: UIButton) {
         if ClassReachability.isConnectedToNetwork() {
        if let comment_text: String = self.messageBox!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            if(!comment_text.isEmpty)
            {
        messageBox?.text = ""
       /* var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "savecomment" as AnyObject
        
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
            dictRequestData["fanupdateid"] = fanupdateid as AnyObject
            dictRequestData["comment"] = trimMessage as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
            
            let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
            self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
        } catch {
            print(error.localizedDescription)
        }*/
                var dictRequest = [String: AnyObject]()
                       dictRequest["cmd"] = "savevideocomment" as AnyObject
                       dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                              dictRequest["device"] = "ios" as AnyObject
                       do {
                           //Creating Request Data
                           var dictRequestData = [String: AnyObject]()
                           let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                          let arrdUserJid = myjid?.components(separatedBy: "@")
                                          let userUserJid = arrdUserJid?[0]
                                          
                                         // let myNSData = comment_text.data(using: String.Encoding.utf8)! as NSData
                                          let content = comment_text.replace(target: "~", withString: "-")
                                          //1. Convert String to base64
                                          //Convert string to NSData
                                          let myNSData = content.data(using: String.Encoding.utf8)! as NSData
                                          //Encode to base64
                                          let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                          
                                          let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                                          
                                          let trimMessage = resultNSString as String
                                          
                           
                           let time: Int64 = appDelegate().getUTCFormateDate()
                           dictRequestData["fanupdateid"] = fanupdateid as AnyObject
                           dictRequestData["time"] = time as AnyObject
                        dictRequestData["comment"] = trimMessage as AnyObject
                           dictRequestData["username"] = userUserJid as AnyObject
                           dictRequest["requestData"] = dictRequestData as AnyObject
                           
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
                                                                                                                             let status1: Bool = json["success"] as! Bool
                                                                                                                             if(status1){
                                                                                                                                 DispatchQueue.main.async {
                                                                                                                                 self.messageBox.insertText("")
                                                                                                                                 self.messageBox?.text = ""
                                                                                                                                 if(self.appDelegate().arrMediaComments.count>2){
                                                                                                                                     let indexPath = IndexPath(row: 0, section: 0)
                                                                                                                                self.storyTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                                                                                                                 }
                                                                                                                                 
                                                                                                                                 self.lastposition = 0
                                                                                                                                   let lastindex = 0
                                                                                                                                   
                                                                                                                                 self.isFanPageCommentRefresh = true
                                                                                                                                 self.FanUpdateGetComments(self.lastposition)
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
            }
        }
    }
        else{
                  self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
             }
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
        messageBox.maxHeight = 80
        messageBox.maxLength = 400
        messageBox.trimWhiteSpaceWhenEndEditing = true
        self.appDelegate().arrMediaComments = [AnyObject]()
        
        //messageBox.pasteDelegate=self as! UITextPasteDelegate
        storyTableView?.backgroundView = UIImageView(image: UIImage(named: "background"))
        storyTableView?.backgroundView?.contentMode = .scaleAspectFill
        
        storyTableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CommentViewController.minimiseKeyboard(_:))))
        
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshFanUpdateComments(_:)), for: UIControl.Event.valueChanged)
        
        
        storyTableView?.addSubview(refreshTable)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        storyTableView?.isUserInteractionEnabled = true
        let notificationName1 = Notification.Name("_MediaGetComments")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateGetComments), name: notificationName1, object: nil)
         
        
        let notificationName2 = Notification.Name("_SaveCommentFanUpdate")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateComments), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_FanUpdateDeleteComments")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFanUpdateComments), name: notificationName3, object: nil)
       
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .large, color: .gray,  placeInTheCenterOf: self.view)
        
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
       // let lastindex = 0
        
      isFanPageCommentRefresh = true
        FanUpdateGetComments(lastposition)
    }
    
    @objc func FanUpdateGetComments(_ lastindex : Int)
    {
        if(!isApicall){
            isApicall = true
        if(lastindex == 0)
        {
            //LoadingIndicatorView.show(self.view, loadingText: "Getting latest comments for you")
            // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
           isFanPageCommentRefresh = true
        } else
        {
            isFanPageCommentRefresh = false
        }
          if ClassReachability.isConnectedToNetwork() {
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "getvideocomments" as AnyObject
        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
               dictRequest["device"] = "ios" as AnyObject
        do {
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            
            
            dictRequestData["fanupdateid"] = fanupdateid as AnyObject
            dictRequestData["lastindex"] = lastindex as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
            
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
                                                                                  // print(response)
                                                                                 self.likecount = json["likecount"] as! Int64
                                                                                  self.commentcount = json["commentcount"] as! Int64
                                                                                 self.viewcount = json["viewcount"] as! Int64
                                                                                         self.appDelegate().mediacviewOnArrays(fanuid: self.fanupdateid,likecount: self.likecount,commentcount: self.commentcount, viewcount: self.viewcount)
                                                                                 if(self.isFanPageCommentRefresh)
                                                                                                                                {
                                                                                                                                 self.appDelegate().arrMediaComments = response  as [AnyObject]
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                 self.appDelegate().arrMediaComments += response  as [AnyObject]
                                                                                                                                }
                                                                                                                                
                                                                                                                                //arrMediaComments = response
                                                                                                                                
                                                                                 
                                                                                 self.updatecommentOnArrays()
                                                                                 
                                                                                                                                let notificationName = Notification.Name("_MediaGetComments")
                                                                                                                                NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                 
                                                                                 //let notificationName2 = Notification.Name("resetMedia")
                                                                                 //NotificationCenter.default.post(name: notificationName2, object: nil)
                                                                                 
                                                                                 
                                                                                 self.isApicall = false
                                                                                  }
                                                                                  
                                                                              }
                                                                              else{
                                                                                  DispatchQueue.main.async
                                                                                      {
                                                                                         if(self.isFanPageCommentRefresh)
                                                                                                                                             {
                                                                                                                                                 self.appDelegate().arrMediaComments = [AnyObject]()
                                                                                                                                                 
                                                                                                                                                 self.updatecommentOnArrays()
                                                                                                                                                 
                                                                                                                                                 let notificationName = Notification.Name("_MediaGetComments")
                                                                                                                                                 NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                       //let notificationName2 = Notification.Name("resetMedia")
                                                                                                                                                 //NotificationCenter.default.post(name: notificationName2, object: nil)
                                                                                                                                                 
                                                                                                                                                 
                                                                                                                                             }
                                                                                         self.isApicall = false
                                                                                  }
                                                                                  //Show Error
                                                                              }
                                                                           }
                                                                       case .failure(let error):
                                                                         debugPrint(error)
                                                                          self.isApicall = false
                                                                break
                                                                           // error handling
                                                            
                                                                       }
                                                           
                                                     }
        } catch {
             isApicall = false
            print(error.localizedDescription)
             DispatchQueue.main.async
                       {
                       // TransperentLoadingIndicatorView.hide()
                       }
                                                                                                                                       
        }
    }
          else{
             isApicall = false
            DispatchQueue.main.async
            {
             //TransperentLoadingIndicatorView.hide()
            }
             self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
        }
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
            //TransperentLoadingIndicatorView.hide()
            
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
        //TransperentLoadingIndicatorView.hide()
        closeRefresh()
        if(self.appDelegate().arrMediaComments.count == 0){
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
        isFanPageCommentRefresh = true
        FanUpdateGetComments(lastposition)
        print(fanupdateid)
    }
    
    
    @objc func DeleteClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("Delete Click")
        let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
        if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
            DeletePost(indx: indexPath)
           /* let dict: NSDictionary? = appDelegate().arrMediaComments[indexPath.row] as? NSDictionary
          
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "deletecomment" as AnyObject
            
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
                dictRequestData["fanupdateid"] = fanupdateid as AnyObject
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
            }
            */
            
        }
        
    }
    func DeletePost(indx:IndexPath)  {
         if ClassReachability.isConnectedToNetwork() {
        let dict: NSDictionary? = appDelegate().arrMediaComments[indx.row] as? NSDictionary
        
        var dictRequest = [String: AnyObject]()
               dictRequest["cmd"] = "deletecomment" as AnyObject
               dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                      dictRequest["device"] = "ios" as AnyObject
               do {
                   //Creating Request Data
                   var dictRequestData = [String: AnyObject]()
                   let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                  let arrdUserJid = myjid?.components(separatedBy: "@")
                                  let userUserJid = arrdUserJid?[0]
                                  
                                  
                   
                   
                   dictRequestData["fanupdateid"] = fanupdateid as AnyObject
                   dictRequestData["commentid"] = dict?.value(forKey: "id") as AnyObject
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
                                                                                                                                                                  let status1: Bool = json["success"] as! Bool
                                                                                       if(status1){DispatchQueue.main.async {
                                                                                           self.appDelegate().arrMediaComments.remove(at: indx.row)
                                                                                           self.storyTableView.reloadData()
                                                                                           if(self.commentcount>0){
                                                                                               self.commentcount = self.commentcount - 1
                                                                                               self.appDelegate().mediacviewOnArrays(fanuid: self.fanupdateid,likecount: self.likecount,commentcount: self.commentcount, viewcount: self.viewcount)
                                                                                               
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
    }
    else{
              self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
         }
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
              let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
              
              let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
                  if(self.refreshTable.isRefreshing)
                  {
                   self.refreshTable.endRefreshing()
                  }
              });
              
              alert.addAction(action1)
              self.present(alert, animated: true, completion:nil)
          }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            CommentViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return CommentViewController.realDelegate!;
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        print(appDelegate().arrMediaComments.count)
        return self.appDelegate().arrMediaComments.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //if(appDelegate().arrMediaComments.count > 19)//
       // {
        
        let lastElement = appDelegate().arrMediaComments.count - 1
        if(commentcount != 0){
        if(commentcount != appDelegate().arrMediaComments.count){
        if indexPath.row == lastElement {
            // handle your logic here to get more items, add it to dataSource and reload tableview
            lastposition = appDelegate().arrMediaComments.count //lastposition + 1
            FanUpdateGetComments(lastposition)
        }
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
        
        let dic: NSDictionary? = self.appDelegate().arrMediaComments[indexPath.row] as? NSDictionary
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
        print("Start Editing")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Start Editing")
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
    
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
     return true
     }
     
     //print("Returned")
     //print("Text did changed")
     let trimMessage: String = messageBox.text!//messageBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
     //let trimMessage = messageBox.text!
     //messageBox.text = trimMessage
     if(!trimMessage.isEmpty)
     {
     isSendMessage = true
     let imgMsg: UIImage = UIImage(named: "send")!
     btnCamera?.setImage(imgMsg, for: UIControlState.normal)
     
     //New code to send composing event
     self.appDelegate().sendComposingChatToUser(messageTo: self.appDelegate().toUserJID)
     //End
     let layoutManager:NSLayoutManager = textView.layoutManager
     let numberOfGlyphs = layoutManager.numberOfGlyphs
     var numberOfLines = 0
     var index = 0
     var lineRange:NSRange = NSRange()
     
     while (index < numberOfGlyphs) {
     layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
     index = NSMaxRange(lineRange);
     numberOfLines = numberOfLines + 1
     }
     
     if(numberOfLines>=1 && numberOfLines<8){
     let changeConstant = numberOfLines * 15
     self.massageBoXHightConstraint.constant = CGFloat(changeConstant+30)
     self.coustumBorderHightConstraint.constant = CGFloat(changeConstant+40)
     messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
     }
     else if(numberOfLines>=8){
     let changeConstant = 8 * 15
     self.massageBoXHightConstraint.constant = CGFloat(changeConstant+30)
     self.coustumBorderHightConstraint.constant = CGFloat(changeConstant+40)
     messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
     
     }
     
     DispatchQueue.main.asyncAfter(deadline: .now()) {
     
     let range = NSMakeRange(trimMessage.lengthOfBytes(using: String.Encoding.utf8), 0)
     textView.scrollRangeToVisible(range)
     }
     
     
     }
     else
     {
     self.massageBoXHightConstraint.constant = CGFloat(30.0)
     self.coustumBorderHightConstraint.constant = CGFloat(40.0)
     isSendMessage = false
     let imgMsg: UIImage = UIImage(named: "camera")!
     btnCamera?.setImage(imgMsg, for: UIControlState.normal)
     textView.isScrollEnabled = false
     }
     
     /*if(trimMessage == UIPasteboard.general.string)
     {
     self.messageBox?.text = trimMessage + " "
     
     DispatchQueue.main.asyncAfter(deadline: .now()) {
     
     let range = NSMakeRange(trimMessage.lengthOfBytes(using: String.Encoding.utf8), 0)
     textView.scrollRangeToVisible(range)
     }
     
     
     }*/
     
     
     
     
     //textView.scrollRectToVisible(messageBox.frame, animated: true)
     
     messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
     
     return true
     }*/
    
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
    /*func updatecommentOnArrays(){
        let tabIndex:[String: Any] = ["commentcount": commentcount, "likecount": likecount, "viewcount":viewcount]
        let notificationName = Notification.Name("_fanupdatecount")
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
        if(self.appDelegate().arrFanUpdatesTeams.count>0){
                                              for i in 0...self.appDelegate().arrFanUpdatesTeams.count-1 {
                                                  let dict: NSDictionary? = self.appDelegate().arrFanUpdatesTeams[i] as? NSDictionary
                                                         if(dict != nil)
                                                         {
                                                          let GroupID = dict?.value(forKey: "id") as! Int64
                                                          if(fanupdateid == GroupID){
                                                              var dict1: [String: AnyObject] = self.appDelegate().arrFanUpdatesTeams[i] as! [String: AnyObject]
                                                            dict1["likecount"] = likecount as AnyObject
                                                                    dict1["commentcount"] = commentcount as AnyObject
                                                            dict1["viewcount"] = viewcount as AnyObject //print("comment\(fanupdateid)\(appDelegate().arrMediaComments.count)")
                                                            self.appDelegate().arrFanUpdatesTeams[i] = dict1 as AnyObject
                                                              let notificationName = Notification.Name("resetStory")
                                                                                                                                                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                                              
                                                              break
                                                                         
                                                          }
                                                  }
                                              }
                                          }
        if(self.appDelegate().arrMyFanUpdatesTeams.count>0) {
            for i in 0...self.appDelegate().arrMyFanUpdatesTeams.count-1 {
                let dict: NSDictionary? = self.appDelegate().arrMyFanUpdatesTeams[i] as? NSDictionary
                       if(dict != nil)
                       {
                        let GroupID = dict?.value(forKey: "id") as! Int64
                        if(fanupdateid == GroupID){
                            var dict1: [String: AnyObject] = self.appDelegate().arrMyFanUpdatesTeams[i] as! [String: AnyObject]
                             dict1["likecount"] = likecount as AnyObject
                            dict1["commentcount"] = commentcount as AnyObject
                            dict1["viewcount"] = viewcount as AnyObject
                            self.appDelegate().arrMyFanUpdatesTeams[i] = dict1 as AnyObject
                            let notificationName = Notification.Name("resetmyStory")
                                                                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                            
                            break
                                       
                        }
                }
            }
        }
        if(self.appDelegate().arrhomefanupdate.count>0) {
                   for i in 0...self.appDelegate().arrhomefanupdate.count-1 {
                       let dict: NSDictionary? = self.appDelegate().arrhomefanupdate[i] as? NSDictionary
                              if(dict != nil)
                              {
                               let GroupID = dict?.value(forKey: "id") as! Int64
                               if(fanupdateid == GroupID){
                                   var dict1: [String: AnyObject] = self.appDelegate().arrhomefanupdate[i] as! [String: AnyObject]
                                dict1["likecount"] = likecount as AnyObject
                                dict1["commentcount"] = commentcount as AnyObject
                                dict1["viewcount"] = viewcount as AnyObject
                                              
                                   self.appDelegate().arrhomefanupdate[i] = dict1 as AnyObject
                                   let notificationName = Notification.Name("resetStoryslider")
                                                                                                                                         NotificationCenter.default.post(name: notificationName, object: nil)
                                   
                                   break
                                              
                               }
                       }
                   }
               }
    }*/
    
    func updatecommentOnArrays(){
        let tabIndex:[String: Any] = ["commentcount": commentcount, "likecount": likecount, "viewcount":viewcount]
        let notificationName = Notification.Name("_fanupdatecount")
        NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
        if(self.appDelegate().arrMedia.count>0){
                                              for i in 0...self.appDelegate().arrMedia.count-1 {
                                                  let dict: NSDictionary? = self.appDelegate().arrMedia[i] as? NSDictionary
                                                         if(dict != nil)
                                                         {
                                                          let GroupID = dict?.value(forKey: "id") as! Int64
                                                          if(fanupdateid == GroupID){
                                                              var dict1: [String: AnyObject] = self.appDelegate().arrMedia[i] as! [String: AnyObject]
                                                            dict1["likecount"] = likecount as AnyObject
                                                                    dict1["commentcount"] = commentcount as AnyObject
                                                            dict1["viewcount"] = viewcount as AnyObject //print("comment\(fanupdateid)\(appDelegate().arrFanUpdateComments.count)")
                                                            self.appDelegate().arrMedia[i] = dict1 as AnyObject
                                                              let notificationName = Notification.Name("resetMedia")
                                                                                                                                                                    NotificationCenter.default.post(name: notificationName, object: nil)
                                                              
                                                              break
                                                                         
                                                          }
                                                  }
                                              }
                                          }
        if(self.appDelegate().arrMedia.count>0) {
            for i in 0...self.appDelegate().arrMedia.count-1 {
                let dict: NSDictionary? = self.appDelegate().arrMedia[i] as? NSDictionary
                       if(dict != nil)
                       {
                        let GroupID = dict?.value(forKey: "id") as! Int64
                        if(fanupdateid == GroupID){
                            var dict1: [String: AnyObject] = self.appDelegate().arrMedia[i] as! [String: AnyObject]
                             dict1["likecount"] = likecount as AnyObject
                            dict1["commentcount"] = commentcount as AnyObject
                            dict1["viewcount"] = viewcount as AnyObject
                            self.appDelegate().arrMedia[i] = dict1 as AnyObject
                            let notificationName = Notification.Name("resetmyStory")
                                                                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                            
                            break
                                       
                        }
                }
            }
        }
        if(self.appDelegate().arrhomemedia.count>0) {
                   for i in 0...self.appDelegate().arrhomemedia.count-1 {
                       let dict: NSDictionary? = self.appDelegate().arrhomemedia[i] as? NSDictionary
                              if(dict != nil)
                              {
                               let GroupID = dict?.value(forKey: "id") as! Int64
                               if(fanupdateid == GroupID){
                                   var dict1: [String: AnyObject] = self.appDelegate().arrhomemedia[i] as! [String: AnyObject]
                                dict1["likecount"] = likecount as AnyObject
                                dict1["commentcount"] = commentcount as AnyObject
                                dict1["viewcount"] = viewcount as AnyObject
                                              
                                   self.appDelegate().arrhomemedia[i] = dict1 as AnyObject
                                   let notificationName = Notification.Name("resetStoryslider")
                                                                                                                                         NotificationCenter.default.post(name: notificationName, object: nil)
                                   
                                   break
                                              
                               }
                       }
                   }
               }
    }
}

extension MediaCommentViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


