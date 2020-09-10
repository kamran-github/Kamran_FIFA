//
//  TriviaPurchaseAlert.swift
//  FootballFan
//
//  Created by Apple on 01/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
class TriviaPurchaseAlert: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageimg: UIImageView!
    @IBOutlet weak var actionBut: UIButton!
    @IBOutlet weak var buyfc: UIView!
    var titleString: String?
   // var triviaTypeString: String?
    var onpageview: String = ""
    var triviaprice: Double = 0
     @IBOutlet weak var viewTremsConstraint2: NSLayoutConstraint!
    static func instantiate() -> TriviaPurchaseAlert? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TriviaPurchaseAlert") as? TriviaPurchaseAlert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
             let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
             titleLabel.text = "Good News!\nRedeem \(Int(triviaprice)) FanCoins from \(Int(avilablecoin)) FanCoins\nto play"
       
       
           
            let text = "You confirm that you are 18+ years old, have a UK mailing address to receive prize, and agree to our\nTrivia Terms & Conditions"
            let underlineAttriString = NSMutableAttributedString(string: text)
                   let range1 = (text as NSString).range(of: "Trivia Terms & Conditions")
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
                           //let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                           messageimg.image = UIImage.gifImageWithData(imageData as Data)
                       }
        }
     
    }
    
    // MARK: Actions
   @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
         let text = (messageLabel!.text)!
         let termsRange = (text as NSString).range(of: "Trivia Terms & Conditions")
         //let privacyRange = (text as NSString).range(of: "Privacy Policy")
         //let LicensedUser = (text as NSString).range(of: "EULA")
         
         if gesture.didTapAttributedTextInLabel(label: messageLabel!, inRange: termsRange) {
            // print("Tapped terms")
            
             EarnCoinsClick()
             
         }
     }
     func EarnCoinsClick() {
        print("EarnCoinsClick")
         UserDefaults.standard.setValue("Terms & Conditions", forKey: "terms")
                   UserDefaults.standard.synchronize()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewPopup = storyBoard.instantiateViewController(withIdentifier: "WebViewPopup") as! WebViewPopup
        show(myTeamsController, sender: self)
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if(onpageview == "upcomming"){
            let notificationName = Notification.Name("upcomingtriviapurchse")
                      NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(onpageview == "home"){
            
            let notificationName = Notification.Name("hometriviapurchse")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(onpageview == "upcommingdetail"){
            let notificationName = Notification.Name("detailtriviapurchse")
                                 NotificationCenter.default.post(name: notificationName, object: nil)
        }
          dismiss(animated: true, completion: nil)
      
        
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
