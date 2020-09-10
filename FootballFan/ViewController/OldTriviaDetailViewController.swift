//
//  OldTriviaDetailViewController.swift
//  FootballFan
//
//  Created by Apple on 12/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
class OldTriviaDetailViewController: UIViewController {
     var oldtriviadetail: NSDictionary = [:]
    @IBOutlet weak var triviastatus: UILabel?
    @IBOutlet weak var timervalue: UILabel?
    @IBOutlet weak var ticketprize: UILabel?
    @IBOutlet weak var Description: UILabel?
    @IBOutlet weak var ContentImage: UIImageView!
   
    @IBOutlet weak var viewTrivia: UIView!
    @IBOutlet weak var share: UIView!
    @IBOutlet weak var widthConstraint2: NSLayoutConstraint!
    @IBOutlet weak var Mainview: UIView!
    @IBOutlet weak var likecount: UILabel?
    @IBOutlet weak var viewcount: UILabel?
   
    @IBOutlet weak var descriptionConstraint2: NSLayoutConstraint!
    @IBOutlet weak var likeviewConstraint2: NSLayoutConstraint!
    @IBOutlet weak var countviewConstraint2: NSLayoutConstraint!
    @IBOutlet weak var buttomviewConstraint2: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if(oldtriviadetail != nil)
        {
            let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
            
            
           share?.addGestureRecognizer(longPressGesture_share)
            share?.isUserInteractionEnabled = true
            
            
            
            // cell.ContentImage?.contentMode = .scaleAspectFill
            // cell.ContentImage?.clipsToBounds = true
            var thumbLink: String = ""
            if let thumb = oldtriviadetail.value(forKey: "TriviaImage")
            {
                thumbLink = thumb as! String
            }
            //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
           ContentImage.imageURL = thumbLink
            var caption: String = ""
            if let capText = oldtriviadetail.value(forKey: "Description")
            {
                caption = capText as! String
            }
            Description?.text = caption
            timervalue?.text = oldtriviadetail.value(forKey: "Title") as! String//"TRIVIA FINISHED"
            
        /*    let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (timervalue?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 11.0)
            label.text = timervalue?.text
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 2
            label.sizeToFit()
            
            
            if((label.frame.height) > 13)
            {
               widthConstraint2.constant = label.frame.height
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
                widthConstraint2.constant = label.frame.height
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }
            let label1 = UILabel(frame: CGRect(x: 0.0, y: 0, width: (Description?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
            label1.font = UIFont.systemFont(ofSize: 10.0)
            label1.text = Description?.text
            label1.textAlignment = .left
            //label.textColor = self.strokeColor
            label1.lineBreakMode = .byWordWrapping
            label1.numberOfLines = 4
            label1.sizeToFit()
            
            
            if((label1.frame.height) > 13)
            {
                descriptionConstraint2.constant = label1.frame.height
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
               descriptionConstraint2.constant = label1.frame.height
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }*/
            viewcount?.text = "\(self.appDelegate().formatNumber(Int(oldtriviadetail.value(forKey: "ViewCount") as! String ) ??  0))"
            likecount?.text = "\(self.appDelegate().formatNumber(Int(oldtriviadetail.value(forKey: "LikeCount") as! String ) ??  0))"
            let lblecount = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (viewcount?.frame.height)!))
            lblecount.font = UIFont.boldSystemFont(ofSize: 11.0)
            lblecount.text = viewcount?.text
            lblecount.textAlignment = .left
            //label.textColor = self.strokeColor
            lblecount.lineBreakMode = .byWordWrapping
            lblecount.numberOfLines = 1
            lblecount.sizeToFit()
            
            
            if((lblecount.frame.width) > 11)
            {
               countviewConstraint2.constant = lblecount.frame.width + 25
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
              countviewConstraint2.constant = lblecount.frame.width + 25
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }
            let lblelcount = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (likecount?.frame.height)!))
            lblelcount.font = UIFont.boldSystemFont(ofSize: 11.0)
            lblelcount.text = likecount?.text
            lblelcount.textAlignment = .left
            //label.textColor = self.strokeColor
            lblelcount.lineBreakMode = .byWordWrapping
            lblelcount.numberOfLines = 1
            lblelcount.sizeToFit()
            
            
            if((lblelcount.frame.width) > 11)
            {
               likeviewConstraint2.constant = lblelcount.frame.width + 25
                //let height = (label.frame.height) + 410.0
                //print("Height \((label.frame.height)).")
                //storyTableView?.rowHeight = CGFloat(height)
            }
            else
            {
                likeviewConstraint2.constant = lblelcount.frame.width + 25
                //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
                //print("Height \((label.frame.height)).")
                // storyTableView?.rowHeight = CGFloat(height)
            }
            let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenTriviaAction(_:)))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture.delegate = self as? UIGestureRecognizerDelegate
            
            
            buttomviewConstraint2.constant = lblelcount.frame.width + lblecount.frame.width + 80 + 25 + 25
            let status = oldtriviadetail.value(forKey: "Status") as! String
            if(status == "Completed"){
                triviastatus?.isHidden = false
               triviastatus?.text = "PLAY VIDEO"
               triviastatus?.addGestureRecognizer(longPressGesture)
                triviastatus?.isUserInteractionEnabled = true
            }
           else if(status == "Finished"){
                triviastatus?.text = "RECORDING AWAITED"
            }
            else{
                triviastatus?.isHidden = true
            }
        }
        
    }
    @objc func OpenTriviaAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Click")
       
            if ClassReachability.isConnectedToNetwork() {
               
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let registerController : PotratepreviewMediaViewController! = storyBoard.instantiateViewController(withIdentifier: "PotratePreviewmidia") as? PotratepreviewMediaViewController
                //self.returnToOtherView = true
                registerController.videoURL = oldtriviadetail.value(forKey: "VideoLink") as? String
                registerController.mediaType = "video"
                self.present(registerController, animated: true, completion: nil)
            }
            else{
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            }
            
      
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        //print("Share Click")
        
       
            do {
                let fanupdateid = oldtriviadetail.value(forKey: "ID") as! Int64
                var dictRequest = [String: AnyObject]()
                dictRequest["id"] = fanupdateid as AnyObject
                dictRequest["type"] = "trivia" as AnyObject
                let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                
                let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                
                let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                
                let title = oldtriviadetail.value(forKey: "Title") as! String
                
                let param = resultNSString as String?
                
                let inviteurl = InviteHost + "?q=" + param!
               var text = title + "/n/nPlay live Football Trivia and win prizes with me on Football Fan App\n\n"
                               //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                              let recReadUserJid: String? = UserDefaults.standard.string(forKey: "userJID")
                               if(recReadUserJid != nil){
                                   let arrReadUserJid = recReadUserJid?.components(separatedBy: "@")
                                   let userReadUserJid = arrReadUserJid?[0]
                                   text = text + "Use my code \"\(userReadUserJid!)\" to Sign Up!/n/n"
                               }
                                          //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                                          
                //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                
                let myWebsite = NSURL(string: inviteurl)
                let shareAll = [text, myWebsite as Any] as [Any]
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
                
                
            } catch {
                print(error.localizedDescription)
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
            OldTriviaDetailViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return OldTriviaDetailViewController.realDelegate!;
    }
}
