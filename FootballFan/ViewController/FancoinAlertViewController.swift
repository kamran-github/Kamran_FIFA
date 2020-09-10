//
//  FancoinAlertViewController.swift
//  FootballFan
//
//  Created by Apple on 25/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
class FancoinAlertViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageimg: UIImageView!
    @IBOutlet weak var actionBut: UIButton!
    @IBOutlet weak var buyfc: UIView!
    var titleString: String?
    var triviaTypeString: String?
    var onpageview: String = ""
   
     @IBOutlet weak var viewTremsConstraint2: NSLayoutConstraint!
    static func instantiate() -> FancoinAlertViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FancoinAlertViewController") as? FancoinAlertViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
            titleLabel.text = "Sorry! \nYou don't have enough FanCoins."
            let text = "You can either buy FanCoins or learn\nhow to collect FanCoins?"
            let underlineAttriString = NSMutableAttributedString(string: text)
                   let range1 = (text as NSString).range(of: "how to collect FanCoins?")
                   underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: range1)
                  
                   messageLabel?.attributedText = underlineAttriString
     messageLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapLabel(_:))))
            messageLabel?.isUserInteractionEnabled = true
            let mediaurl = "http://api.footballfan.mobi/ffapi/gif/banter.gif"
                 let arrReadselVideoPath = mediaurl.components(separatedBy: "/")
                                let imageId = arrReadselVideoPath.last
                                let arrReadimageId = imageId?.components(separatedBy: ".")
                 let fileManager = FileManager.default
                            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".gif")
                            //try fileManager.removeItem(atPath: imageId)
                            // Check if file exists
                            if fileManager.fileExists(atPath: paths) {
                                //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "contacts", withExtension: "gif")!)
                                // let advTimeGif = UIImage.gifImageWithName("contacts")
                                // messageimg.image = advTimeGif
                                let fileName = arrReadimageId![0] + ".gif"
                                let fileURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(fileName)
                                if let imageData = NSData(contentsOf: fileURL!) {
                                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                                    messageimg.image = UIImage.gifImageWithData(imageData as Data)
                                }
                 }
        
       // titleLabel.text = titleString
        //messageLabel.text = messageString
     /*   if(mediatype == "gif"){
            // messageimg.imageURL = mediaurl
            let arrReadselVideoPath = mediaurl!.components(separatedBy: "/")
            let imageId = arrReadselVideoPath.last
            let arrReadimageId = imageId?.components(separatedBy: ".")
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".gif")
            //try fileManager.removeItem(atPath: imageId)
            // Check if file exists
            if fileManager.fileExists(atPath: paths) {
                //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "contacts", withExtension: "gif")!)
                // let advTimeGif = UIImage.gifImageWithName("contacts")
                // messageimg.image = advTimeGif
                let fileName = arrReadimageId![0] + ".gif"
                let fileURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(fileName)
                if let imageData = NSData(contentsOf: fileURL!) {
                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                    messageimg.image = UIImage.gifImageWithData(imageData as Data)
                }
                
                /* do {
                 if let imageData = NSData(contentsOfURL: paths) {
                 let image = UIImage(data: imageData) // Here you can attach image to UIImageView
                 }
                 let imageData = try Data(contentsOf: URL(string: paths)!)
                 messageimg.image = UIImage.gifImageWithData(imageData)
                 } catch {
                 print("Not able to load image")
                 }*/
                
            }
            else{
                messageimg.image = UIImage.gifImageWithURL(mediaurl!)
            }
            //
        }
        else{
            messageimg.imageURL = mediaurl
        }*/
        //  actionBut.setTitle(ActionTitle, for: .normal)
        //let advTimeGif = UIImage.gifImageWithData(imageData!)!
    }
    
    // MARK: Actions
   @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
         let text = (messageLabel!.text)!
         let termsRange = (text as NSString).range(of: "how to collect FanCoins?")
         //let privacyRange = (text as NSString).range(of: "Privacy Policy")
         //let LicensedUser = (text as NSString).range(of: "EULA")
         
         if gesture.didTapAttributedTextInLabel(label: messageLabel!, inRange: termsRange) {
            // print("Tapped terms")
            
             EarnCoinsClick()
             
         }
     }
     func EarnCoinsClick() {
        print("EarnCoinsClick")
        
        UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
        UserDefaults.standard.synchronize()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewPopup = storyBoard.instantiateViewController(withIdentifier: "WebViewPopup") as! WebViewPopup
        show(myTeamsController, sender: self)
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
       /* if(onpageview == "upcomming"){
            let notificationName = Notification.Name("upcomingtriviapurchse")
                      NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(onpageview == "home"){
            
            let notificationName = Notification.Name("hometriviapurchse")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }*/
          dismiss(animated: true, completion: nil)
       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                     let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                                    // self.returnToOtherView = true
        self.appDelegate().window?.rootViewController?.show(registerController, sender: self)
        
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
       
        /* if(actioncommand == "contacts"){
         appDelegate().showcontactswindows()
         }
         else if(actioncommand == "share"){
         appDelegate().share()
         }
         else if(actioncommand == "banter"){
         appDelegate().showMainTab()
         }
         else if(actioncommand == "newstory"){
         appDelegate().showNewPostWindow()
         }
         else if(actioncommand == "browser"){
         appDelegate().showexternalbrowser(url: actionlink!)
         }
         else if(actioncommand == "inappbrowser"){
         appDelegate().inappwindows(url: actionlink!, titel: LinkTitle!)
         }*/
    }
     @objc func Openinapp(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                               let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                              // self.returnToOtherView = true
                                               self.show(registerController, sender: self)
                                               
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            InfoAlertViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return InfoAlertViewController.realDelegate!;
    }
    
}
