//
//  NewBanterNotifierViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 04/01/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//



import UIKit
import UserNotifications

class NewBanterNotifierViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var notifyHeading: UILabel!
    @IBOutlet weak var notifyText: UILabel?
    @IBOutlet weak var notifyImage: UIImageView?
    @IBOutlet weak var notifyAccept: UIButton?
     @IBOutlet weak var ParentView: UIView?
    var notifyType: String = ""
    @IBOutlet weak var notifyText1: UILabel?
    @IBOutlet weak var notifyTextView: UITextView!
    @IBOutlet weak var notifyText2: UILabel?
     @IBOutlet weak var infolabel: UILabel?
    var strings:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let notificationName = Notification.Name("closeNotifyWindow")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewBanterNotifierViewController.closeNotifyWindow), name: notificationName, object: nil)
        // Comment by Mayank 18 Jun 2018
        /*
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "teamsync" as AnyObject
        var dictRequestData = [String: AnyObject]()
        
        dictRequestData["version"] = appDelegate().Realeseversion as AnyObject
        dictRequest["requestData"] = dictRequestData as AnyObject
        do {
            let dataTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strTeams = NSString(data: dataTeams, encoding: String.Encoding.utf8.rawValue)! as String
            // print(strTeams)
            appDelegate().sendRequestToAPI(strRequestDict: strTeams)
        } catch {
            print(error.localizedDescription)
        } */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading. Please wait while loading. Please wait while loading. Please wait while loading.")
        
        /*notifyImage?.image = UIImage(named: "per_notification")
        notifyHeading.text = "Create a Banter Room and we will invite all the fans of teams involved."
        
        //notifyText?.text = "Invite your friends to download Football Fan app and instantly start a banter with them. \n - Banters are meant to be fun between fans of 2 football teams, please keep it funny for everyone to enjoy. \n - To make your banter room interesting, we send an instant invitation to all the fans of the football teams involved in your banter room, provided fans have enabled notification settings on the phone. \n - To maintain security and identity protection, we never reveal anyone's identity in a banter room expect username. \n - Participants in a banter room can send funniest messages or pictures or videos. \n - You may change your team by going to Settings. Most importantly have fun in good spirit and keep your banter room funny. You may change your team by going to Settings. \n Most importantly have fun in good spirit and keep your banter room funny."
        //notifyText2?.text = "You may change your team by going to Settings."
        
        notifyText?.frame.size.width = UIScreen.main.bounds.size.width - 50
        let text = (notifyText?.text)!
        notifyText?.sizeToFit()
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Invite")
        underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hex: "197DF6"), range: range1)
       
        notifyText?.attributedText = underlineAttriString
        notifyText?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewBanterNotifierViewController.tapLabel(_:))))
        notifyText?.isUserInteractionEnabled = true
        
         /*notifyText1?.text = "- Banters are meant to be fun between fans of 2 football teams, please keep it funny for everyone to enjoy. \n - To make your banter room interesting, we send an instant invitation to all the fans of the football teams involved in your banter room, provided fans have enabled notification settings on the phone. \n - To maintain security and identity protection, we never reveal anyone's identity in a banter room expect username. \n - Participants in a banter room can send funniest messages or pictures or videos. \n - You may change your team by going to Settings. Most importantly have fun in good spirit and keep your banter room funny. \n Most importantly have fun in good spirit and keep your banter room funny."
        notifyText2?.text = "You may change your team by going to Settings."
        let text2 = (notifyText2?.text)!
        notifyText2?.sizeToFit()
        let underlineAttriString2 = NSMutableAttributedString(string: text2)
        let range2 = (text2 as NSString).range(of: "Settings")
        underlineAttriString2.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hex: "197DF6"), range: range2)
        
        notifyText2?.attributedText = underlineAttriString2
        notifyText2?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewBanterNotifierViewController.tapLabel2(_:))))
        notifyText2?.isUserInteractionEnabled = true*/
 */
       /* notifyTextView.text = "Invite your friends to download Football Fan app and instantly start a banter with them. \n \n• Banters are meant to be fun between fans of 2 football teams, please keep it funny for everyone to enjoy. \n \n• To make your Banter Room interesting, we send an instant invitation to all the fans of the football teams involved in your Banter Room, provided fans have enabled notification Settings on the phone. \n \n• To maintain security and identity protection, we never reveal anyone's identity in a Banter Room expect username. \n \n• Participants in a Banter Room can send funniest messages or pictures or videos. \n \n• You may change your team by going to Settings. Most importantly have fun in good spirit and keep your Banter Room funny.\n \n Most importantly have fun in good spirit and keep your Banter Room funny."
        
        notifyTextView.textAlignment = .justified
        notifyTextView.font = UIFont.systemFont(ofSize: 22.0)
        let text = (notifyTextView?.text)!
        
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Invite")
        underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hex: "197DF6"), range: range1)
        
        let range2 = (text as NSString).range(of: "Settings")
        underlineAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(hex: "197DF6"), range: range2)
        
        //let attribute:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: ["Tag" : "settings"])
        notifyTextView.attributedText = underlineAttriString*/
        //12-2-18 new changes
        /*let bullet1 = "Invite your friends to download Football Fan app and instantly start a banter with them."
        let bullet2 = "Banters are meant to be fun between fans of 2 football teams, please keep it funny for everyone to enjoy."
        let bullet3 = "To make your Banter Room interesting, we send an instant invitation to all the fans of the football teams involved in your Banter Room, provided fans have enabled notification Settings on the phone."
         let bullet4 = "To maintain security and identity protection, we never reveal anyone's identity in a Banter Room expect username. "
         let bullet5 = "Participants in a Banter Room can send funniest messages or pictures or videos."
        let bullet6 = "You may change your team by going to Settings. Most importantly have fun in good spirit and keep your Banter Room funny."
         let bullet7 = "Most importantly have fun in good spirit and keep your Banter Room funny."*/
        let bullet2 = "Create a Banter Room between one of your favourite teams and an opposition team."
        let bullet3 = "We then send an instant invitation globally to interested fans of teams involved to join your Banter Room."
        let bullet4 = "We never reveal the identity of fans in a Banter Room unless they are already in your phone address book."
        let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
        let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
        
        strings = [bullet2, bullet3, bullet4, bullet5, bullet6]
       // let boldText  = "Quick Information \n"

        let attributesDictionary = [kCTForegroundColorAttributeName : notifyTextView.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as [NSAttributedString.Key : Any])
      //  let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        //let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
        //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: boldString)
        
        //fullAttributedString.append(boldString)
        for string: String in strings
        {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
           
            let range1 = (formattedString as NSString).range(of: "Invite")
            attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
            
            let range2 = (formattedString as NSString).range(of: "Settings")
            attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
            
            fullAttributedString.append(attributedString)
        }
        
        notifyTextView.attributedText = fullAttributedString
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewBanterNotifierViewController.textTapped(_:)))
        tap.delegate = self
        notifyTextView.isUserInteractionEnabled = true
        notifyTextView.addGestureRecognizer(tap)
        //print(notifyTextView.text)
        
        notifyTextView.textAlignment = .justified
        notifyTextView.font = UIFont.systemFont(ofSize: 16.0)
        
        
        let pTeamId: Int64? = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
        let pTeamName: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? " "
        
        if((pTeamId) != 0)
        {
            appDelegate().myTeamId = pTeamId!
            appDelegate().myTeamName = pTeamName!
        }
        
        appDelegate().aponentTeamId = 0
        appDelegate().aponentTeamName = ""
        
        
    }
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
      //  paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [String : AnyObject])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        
        return paragraphStyle
    }
    @objc func textTapped(_ recognizer:UITapGestureRecognizer) {
        let textView:UITextView = recognizer.view as! UITextView
       // print(textView.text)
        // Location of the tap in text-container coordinates
        let layoutManager = textView.layoutManager
        var location:CGPoint = recognizer.location(in: textView)
        
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        var distance:CGFloat? = 0.0
        // Find the character that's been tapped on
        let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: &distance!)
        if characterIndex < textView.textStorage.length{
            //var range:NSRange?
           // var range = (textView.text as NSString).range(of: "to Settings")
            /*var range = (textView.text as NSString).range(of: "Settings")
            
            let value = textView.attributedText.attribute("Tag", at: characterIndex, effectiveRange: &range)
            if (value != nil) {
                // add your code here
                print("Show Settings")
            }*/
            if(characterIndex >= 0 && characterIndex <= 6)
            {
                self.share()
            }
            else if(characterIndex >= 377 && characterIndex <= 384)
            {
                showSettings()
            }
            else if(characterIndex >= 638 && characterIndex <= 645)
            {
                showSettings()
            }
        }
    }
    
    @IBAction func notifyAccepted () {
        
        //self.dismiss(animated: true, completion: nil)
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // do stuff 3 seconds later
            ParentView?.isHidden = true
        notifyAccept?.isHidden = true
            self.showCreateBanterRoom()
            
        //}
        
        //let notificationName = Notification.Name("showNewBanterOption")
        //NotificationCenter.default.post(name: notificationName, object: nil)
      
    }
    
     @objc func closeNotifyWindow()
    {
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            NewBanterNotifierViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewBanterNotifierViewController.realDelegate!;
    }
  /*  func tapLabel(_ gesture: UITapGestureRecognizer) {
        let text = (notifyText!.text)!
        let termsRange = (text as NSString).range(of: "Invite")
//let privacyRange = (text as NSString).range(of: "Settings.")
        
        if gesture.didTapAttributedTextInLabel(label: notifyText!, inRange: termsRange) {
            //print("Tapped terms")
            //banterRoomName?.endEditing(true)
            self.share()
            
            //self.showSettings()
            
        }
     
        else {
            
        }
        
       // banterRoomName?.endEditing(true)
    }*/
    func showSettings() {
        //print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    func share() {
        let textToShare = "Join biggest community of football fans for FREE on \"Football Fan\" app today.\n\nJoin the most funniest banter going around football world or find another Football Fan nearby to chat or create a group of friends to send messages, pictures, videos and many more.\n\nTap link below to download \"Football Fan\" app from https://itunes.apple.com/footballfan/dp/ or https://play.google.com/store/apps/footballfan"
        
        if let myWebsite = NSURL(string: "https://www.tridecimal.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func showCreateBanterRoom() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "NewBanter")
        //present(registerController as! UIViewController, animated: true, completion: nil)
        self.present(registerController as! UIViewController, animated: true)
    }
  /*  func tapLabel2(_ gesture: UITapGestureRecognizer) {
        let text = (notifyText2!.text)!
        let termsRange1 = (text as NSString).range(of: "Settings")
        
        if gesture.didTapAttributedTextInLabel(label: notifyText2!, inRange: termsRange1) {
            print("Tapped settings")
            //banterRoomName?.endEditing(true)
           self.showSettings()
        }
       
        else {
            
        }
        
        if(termsRange1.location == 37)
        {
            self.showSettings()
        }
        
        // banterRoomName?.endEditing(true)
    }*/
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

