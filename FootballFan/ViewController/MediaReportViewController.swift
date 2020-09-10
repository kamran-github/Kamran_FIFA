//
//  MediaReportViewController.swift
//  FootballFan
//
//  Created by Apple on 25/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
class MediaReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var storyTableView: UITableView!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var contentCount: UILabel!
    @IBOutlet weak var ReportBtn: UIButton?
     @IBOutlet weak var lblnote: UILabel!
    let reportACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@.!#$%^&*()+=<>?:;{}[],' \n`|"
    var items: [String] = ["I'm not interested in this content","Nudity or sexual activity","Violence", "Dangerous organisations and individuals", "Violent and graphic content", "Religious", "Bullying or harassment", "Suicide or self-injury", "False news or information", "Suspicious", "Spam, malware or phishing", "Sale of illegal or regulated goods", "Hate speech or symbols", "Terrorism", "Abusive or harmful", "Scam or fraud", "Animal cruelty", "Minor safety", "Impersonation", "Child endangerment", "Private and confidential information", "Intellectual property violation", "Something else"]
    //var position: Int = 0
    var contentid: Int64 = 0
    var type: String = "videos"
    //New by Ravi 08-02-2020
    var contenttitle: String = ""
    //New by Ravi 08-02-2020
     var isKeyboardHiding = false
     var keyboardFrame: CGRect!
     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var abuse: String = ""
     @IBOutlet weak var contentTitel: UILabel!
    // var S_title: String? = ""
    var s_owner: String = ""
    // MARK: - Table view data source
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storyTableView.dataSource = self
        
        self.storyTableView.delegate = self
        contentText.delegate = self
        
        if(!contenttitle.isEmpty)
        {
            lblnote.text  = "Help us understand the issue with\n\"" + contenttitle + "\" content?"
        }
        else
        {
            lblnote.text  = "Help us understand the issue with this \ncontent?"
        }
        
        storyTableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReportViewController.minimiseKeyboard(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
              
                   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
                   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
                   NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
                   
                   NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
                 view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReportViewController.minimiseKeyboard(_:))))
    }
    
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            contentText?.endEditing(true)
        }
       // scrollToBottom()
        sender.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "Report & Block Content"
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.parent?.navigationItem.leftBarButtonItem = nil
        
        storyTableView.reloadData()
        
       
        
    }
    
    func checkForErrors() -> Bool
      { //let age_=calcAge(birthday: (userdob?.text)!)
          var errors = false
         // let title = "Error"
          var message = ""
          let trimMessage: String = contentText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         // let newmobilestr: String = String(describing: numberAsInt) as String
          if (abuse == "") {
              errors = true
              message += "Please select a reason to report this content."
              alertWithTitle1(title: nil, message: message, ViewController: self)
              
          }
        /* else if (abuse == "Something else")
          {
            if(trimMessage == ""){
                errors = true
                self.contentText.text = ""
                             message += "Describe your issue here"
                             alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.contentText)
            }
             
          }*/
         
          
          return errors
      }
    @IBAction func reportAction(){
        //let abuse = items[position]
         contentText?.endEditing(true)
        let thereWereErrors = checkForErrors()
                  if !thereWereErrors
                  {
        savereport(contentid: contentid, type: type, abuse: abuse, comment: contentText.text)
        }
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextView) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
              toFocus.becomeFirstResponder()
          });
          alert.addAction(action)
          self.present(alert, animated: true, completion:nil)
      }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
             let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
             let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
                 //toFocus.becomeFirstResponder()
             });
             alert.addAction(action)
             self.present(alert, animated: true, completion:nil)
         }
       func alertWithTitleSucess(title: String!, message: String, ViewController: UIViewController) {
                   let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                   let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
                       //toFocus.becomeFirstResponder()
                    self.navigationController?.popViewController(animated: true)
                   });
                   alert.addAction(action)
                   self.present(alert, animated: true, completion:nil)
               }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        // print("Start Editing")
        if((contentText?.text?.count)!>250){
            
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        //return newText.count <= 250
        if(newText.count <= 1000){
            let cs = NSCharacterSet(charactersIn: reportACCEPTABLE_CHARACTERS).inverted
            let filtered = text.components(separatedBy: cs).joined(separator: "")
             return (text == filtered)
        }
        return false
    }
    func textViewDidChange(_ textView: UITextView)
    {
        //  print(textView.text);
        contentCount?.text=String(describing: contentText?.text?.count ?? 0)+"/"+String(describing: 1000)
        
    }
    
    @objc func refreshChats()
    {
        storyTableView.reloadData()
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
   /* func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        position = 0
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //position = indexPath.row
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        abuse = items[indexPath.row]
        /*if (abuse == "Something else"){
            contentTitel.text = "Issue details that will help us"
        }
        else{
            contentTitel.text = "Issue details that will help us (optional)"
        }*/
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReportCell = storyTableView!.dequeueReusableCell(withIdentifier: "reportcell") as! ReportCell
        
        cell.itemName?.text = items[indexPath.row]
        return cell
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MoreViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MoreViewController.realDelegate!;
    }
    func savereport(contentid: Int64, type: String, abuse: String, comment: String)
     {
          if ClassReachability.isConnectedToNetwork() {
           
         let trimMessage: String = comment.trimmingCharacters(in: .whitespacesAndNewlines)
             appDelegate().sendsreportemail(blockedusername: s_owner, contentid: contentid, descriptionvalue: trimMessage, reason: abuse)
                 var dictRequest = [String: AnyObject]()
                        dictRequest["cmd"] = "savereport" as AnyObject
                        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                        dictRequest["device"] = "ios" as AnyObject
                        do {
                            //Creating Request Data
                            var dictRequestData = [String: AnyObject]()
                            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                                           let arrdUserJid = myjid?.components(separatedBy: "@")
                                           let userUserJid = arrdUserJid?[0]
                                 dictRequestData["username"] = userUserJid as AnyObject
                                 dictRequestData["contentid"] = contentid as AnyObject
                                 dictRequestData["type"] = type as AnyObject
                                 dictRequestData["abuse"] = abuse as AnyObject
                                 dictRequestData["comment"] = trimMessage as AnyObject
                            
                            dictRequest["username"] = userUserJid as AnyObject
                            dictRequest["requestData"] = dictRequestData as AnyObject
                            
                           /* let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                        let strByPlace = NSString(data: dataByPlace, encoding: String.Encoding.utf8.rawValue)! as String
                                        let escapedString = strByPlace.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                                        
                                        let url = MediaAPIjava + "request=" + escapedString!*/
                                       AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                            switch response.result {
                                                                                    case .success(let value):
                                                                                        if let json = value as? [String: Any] {
                                                                                                                                let status1: Bool = json["success"] as! Bool
                                                                                            if(status1){
                                                                                               self.appDelegate().MediaBlock(story_id: contentid)
                                                                                               self.navigationController?.popViewController(animated: true)
                                                                                               //self.alertWithTitleSucess(title: nil, message: "Thanks for reporting the content.\n\nYour feedback is important in keeping the Football Fan community safe.\n\nWe will get back to you within 48 hours.", ViewController: self)
                                                                                            }
                                                                                            else{
                                                                                               self.alertWithTitle1(title: nil, message: "Please try again later.", ViewController: self)
                                                                                            }
                                                                                        }
                                                                                    case .failure(let error): break
                                                                                        // error handling
                                                                         
                                                                                    }
                        
                           }
                        } catch {
                            print(error.localizedDescription)
                        }
             }
      
         else{
                   self.alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
              }
     }
    
  /*  func textViewDidChange(_ textView: UITextView)
      {
          
          
          //print("Text did changed")
          let trimMessage: String = contentText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
          //let trimMessage = messageBox.text!
          //messageBox.text = trimMessage
          if(!trimMessage.isEmpty)
          {
              contentText?.isScrollEnabled = true
             
              
              
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
          if((contentText?.text.count)! <= 400)
          {
              contentCount?.text=String(describing: contentText?.text?.count ?? 0)+"/"+String(describing: 400)
          }
          //messageBox?.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5)
          //textView.scrollRectToVisible(messageBox.frame, animated: true)
          
      }*/
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
               let changeInHeight = 15.0
               UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                   //print(self.messageBox.keyboardType.rawValue)
                   self.bottomConstraint.constant = CGFloat(changeInHeight)
                   
               })
           }
           else
           {
            let changeInHeight = (self.keyboardFrame.height) + 10.0 //* (show ? 1 : -1)
               UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                   //print(self.messageBox.keyboardType.rawValue)
                   self.bottomConstraint.constant = changeInHeight
                   
               })
           }
           
           
           
       }
}
