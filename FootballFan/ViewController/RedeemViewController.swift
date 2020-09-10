//
//  RedeemViewController.swift
//  FootballFan
//
//  Created by Apple on 19/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class RedeemViewController:UIViewController,UITextViewDelegate{
    var settingOptions: [AnyObject] = []
    //let cellReuseIdentifier = "settings"
   // @IBOutlet weak var storyTableView: UITableView?
      @IBOutlet weak var Infoemail: UIImageView?
    @IBOutlet weak var InfoAcoins: UIImageView?
    @IBOutlet weak var InfoRcoins: UIImageView?
    @IBOutlet weak var InfoBcoins: UIImageView?
    @IBOutlet weak var InfoTcoins: UIImageView?
     @IBOutlet weak var precalculatefcoin: UILabel?
    @IBOutlet weak var avilablefc: UILabel?
     @IBOutlet weak var redeemfc: UILabel?
     @IBOutlet weak var balecedfc: UILabel?
     @IBOutlet weak var totalfc: UILabel?
    @IBOutlet weak var email_txt: UILabel?
     @IBOutlet weak var emailVerifymesg: UILabel?
    @IBOutlet weak var paypal: UIButton?
    @IBOutlet weak var firstcheked_but: UIButton?
     @IBOutlet weak var secoundcheked_but: UIButton?
     @IBOutlet weak var thirdcheked_but: UIButton?
     @IBOutlet weak var fourthcheked_but: UIButton?
    @IBOutlet weak var RedeemNow: UIButton?
    
    @IBOutlet weak var emailHeight: NSLayoutConstraint?
    @IBOutlet weak var emailMsgHeight: NSLayoutConstraint?
    
    @IBOutlet weak var emailViewHeight: NSLayoutConstraint?
    
    @IBOutlet weak var emailFullViewHeight: NSLayoutConstraint?
    @IBOutlet weak var uiemail: UIView?
    @IBOutlet weak var uiafc: UIView?
    @IBOutlet weak var uirfc: UIView?
    @IBOutlet weak var uibfc: UIView?
    @IBOutlet weak var uitfc: UIView?
      @IBOutlet weak var uicheck: UIView?
     @IBOutlet weak var backgroundimage: UIImageView?
    var emailmenuvisible: Bool = false
     var AFCmenuvisible: Bool = false
    var RFCmenuvisible: Bool = false
    var BFCmenuvisible: Bool = false
    var TFCmenuvisible: Bool = false
    var email:String = ""
    var firstcheked:Bool = false
     var secoundcheked:Bool = false
     var thirdcheked:Bool = false
     var fourthcheked:Bool = false
      var isRedeemHide:Bool = true
    var strings:[String] = []

      @IBOutlet weak var notelblforRedeem: UILabel?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(isRedeemHide){
             notelblforRedeem?.isHidden = false
            let bullet1 = "We are working on redeeming your FanCoins rewards for some cool things."
            let bullet2 = "Until then keep contributing to the app and keep collecting FanCoins rewards."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1, bullet2]
            // let boldText  = "Quick Information \n"
            let attributesDictionary = [kCTForegroundColorAttributeName : notelblforRedeem?.font]
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
            
            
            notelblforRedeem?.attributedText = fullAttributedString
            
        }
        else{
           notelblforRedeem?.isHidden = true
            let longPressGesture_share1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emailClick))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share1.delegate = self as? UIGestureRecognizerDelegate
            
            Infoemail?.addGestureRecognizer(longPressGesture_share1)
            Infoemail?.isUserInteractionEnabled = true
            let longPressGesture_share2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InfoAcoinsClick))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share2.delegate = self as? UIGestureRecognizerDelegate
            
            InfoAcoins?.addGestureRecognizer(longPressGesture_share2)
            InfoAcoins?.isUserInteractionEnabled = true
            let longPressGesture_share3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InfoRcoinsClick))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share3.delegate = self as? UIGestureRecognizerDelegate
            
            InfoRcoins?.addGestureRecognizer(longPressGesture_share3)
            InfoRcoins?.isUserInteractionEnabled = true
            let longPressGesture_share4:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InfoBcoinsClick))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share4.delegate = self as? UIGestureRecognizerDelegate
            
            InfoBcoins?.addGestureRecognizer(longPressGesture_share4)
            InfoBcoins?.isUserInteractionEnabled = true
            let longPressGesture_share5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InfoTcoinsClick))
            //longPressGesture.minimumPressDuration = 1.0 // 1 second press
            longPressGesture_share5.delegate = self as? UIGestureRecognizerDelegate
            
            InfoTcoins?.addGestureRecognizer(longPressGesture_share5)
            InfoTcoins?.isUserInteractionEnabled = true
            let paypalemail: String? = UserDefaults.standard.string(forKey: "paypalemail")
            if((paypalemail?.isEmpty)!){
                emailVerifymesg?.isHidden = true
                email_txt?.isHidden = true
                paypal?.setTitle("", for: .normal)
                paypal?.setBackgroundImage(UIImage(named: "paypal"), for: .normal)
                emailHeight?.constant = CGFloat(0)
                emailMsgHeight?.constant = CGFloat(0)
                emailViewHeight?.constant = CGFloat(40)
                emailFullViewHeight?.constant = CGFloat(40)
                
            }
            else{
                email_txt?.text = paypalemail
                emailVerifymesg?.isHidden = false
                email_txt?.isHidden = false
                paypal?.setBackgroundImage(nil, for: .normal)
                paypal?.setTitle("  Change PayPal Email Address  ", for: .normal)
                paypal?.backgroundColor = UIColor.init(hex: "959494")
                emailHeight?.constant = CGFloat(21)
                emailMsgHeight?.constant = CGFloat(21)
                emailViewHeight?.constant = CGFloat(90)
                emailFullViewHeight?.constant = CGFloat(90)
            }
            uiemail?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            uiemail?.isUserInteractionEnabled = true
            uiafc?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            uiafc?.isUserInteractionEnabled = true
            uirfc?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            uirfc?.isUserInteractionEnabled = true
            uibfc?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            uibfc?.isUserInteractionEnabled = true
            uitfc?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            uitfc?.isUserInteractionEnabled = true
            uicheck?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            uicheck?.isUserInteractionEnabled = true
            backgroundimage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InforesetClick(_:))))
            backgroundimage?.isUserInteractionEnabled = true
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Redeem FanCoins Rewards?"
      
        precalculatefcoin?.text = "\(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemth)) FanCoins = \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemcurrency))\(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemamt) as! Float)"
        avilablefc?.text = String(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Int)
        redeemfc?.text = String(getRedeempoint())
         balecedfc?.text = String(getbalancepoint())
        totalfc?.text = "\(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemcurrency)) \(gettotaamount() as! Float)"
        let notificationName1 = Notification.Name("paypalverifiedfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.paypalverifiedfail(notification:)), name: notificationName1, object: nil)
        
        
        let notificationName2 = Notification.Name("paypalverifiedsuccs")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.paypalverifiedsuccs(notification:)), name: notificationName2, object: nil)
        let notificationName3 = Notification.Name("updateredeemsfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.updateredeemsfail(notification:)), name: notificationName3, object: nil)
        
        
        let notificationName4 = Notification.Name("updateredeemssuccs")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.updateredeemssuccs(notification:)), name: notificationName4, object: nil)
        
        let notificationName5 = Notification.Name("callpaypalapi")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RedeemViewController.CallPayPalEmailAPI(notification:)), name: notificationName5, object: nil)
        
        let paypalemail: String? = UserDefaults.standard.string(forKey: "paypalemail")
        if((paypalemail?.isEmpty)!){
            //RedeemNow?.backgroundColor = UIColor.init(hex: "c6c6c6")
            //RedeemNow?.isEnabled = false
            paypal?.setTitle("", for: .normal)
            paypal?.setBackgroundImage(UIImage(named: "paypal"), for: .normal)
            emailHeight?.constant = CGFloat(0)
            emailMsgHeight?.constant = CGFloat(0)
            emailViewHeight?.constant = CGFloat(40)
            emailFullViewHeight?.constant = CGFloat(40)
           // paypal?.setImage(UIImage(named: "paypal"), for: .normal)
            
        }
        else{
            //RedeemNow?.isEnabled = true
            paypal?.setBackgroundImage(nil, for: .normal)
            paypal?.setTitle("  Change PayPal Email Address  ", for: .normal)
            paypal?.backgroundColor = UIColor.init(hex: "959494")
            emailHeight?.constant = CGFloat(21)
            emailMsgHeight?.constant = CGFloat(21)
            emailViewHeight?.constant = CGFloat(90)
            emailFullViewHeight?.constant = CGFloat(90)
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
    @objc func CallPayPalEmailAPI(notification: NSNotification)
    {
        
        
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "updatepaypalemail" as AnyObject
        
        do {
            
            let  verified = (notification.userInfo?["verified"] )as! String
            let  email_verified = (notification.userInfo?["email_verified"] )as! String
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
            let arrdUserJid = myjid?.components(separatedBy: "@")
            let userUserJid = arrdUserJid?[0]
            // let time: Int64 = self.appDelegate().getUTCFormateDate()
            let time: Int64 = appDelegate().getUTCFormateDate()
            
            let myjidtrim: String? = userUserJid
            dictRequestData["paypalemail"] = appDelegate().TemppaypalEmail as AnyObject
            dictRequestData["isverified"] = verified as AnyObject
            dictRequestData["isemailverified"] = email_verified as AnyObject
            dictRequestData["time"] = time as AnyObject
            dictRequestData["username"] = myjidtrim as AnyObject
            dictRequest["requestData"] = dictRequestData as AnyObject
            //dictRequest.setValue(dictMobiles, forKey: "requestData")
            //print(dictRequest)
            
            let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
            //print(strFanUpdates)
            appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    @objc func paypalverifiedfail(notification: NSNotification)
    {
       let  msg = (notification.userInfo?["msg"] )as! String
        //LoadingIndicatorView.hide()
        alertWithTitle1(title: nil, message: msg, ViewController: self)
        
    }
    @objc func paypalverifiedsuccs(notification: NSNotification)
    {
        email_txt?.isHidden = false
        emailVerifymesg?.isHidden = false
        email_txt?.text = appDelegate().TemppaypalEmail
        let paypalemail: String? = UserDefaults.standard.string(forKey: "paypalemail")
        if((paypalemail?.isEmpty)!){
            //RedeemNow?.backgroundColor = UIColor.init(hex: "c6c6c6")
            //RedeemNow?.isEnabled = false
            paypal?.setTitle("", for: .normal)
            paypal?.setBackgroundImage(UIImage(named: "paypal"), for: .normal)
            emailHeight?.constant = CGFloat(0)
            emailMsgHeight?.constant = CGFloat(0)
            emailViewHeight?.constant = CGFloat(40)
            emailFullViewHeight?.constant = CGFloat(40)
        }
        else{
            paypal?.setBackgroundImage(nil, for: .normal)
            paypal?.setTitle("  Change PayPal Email Address  ", for: .normal)
            paypal?.backgroundColor = UIColor.darkGray
            emailHeight?.constant = CGFloat(21)
            emailMsgHeight?.constant = CGFloat(21)
            emailViewHeight?.constant = CGFloat(90)
            emailFullViewHeight?.constant = CGFloat(90)
            //RedeemNow?.isEnabled = true
            //RedeemNow?.backgroundColor = UIColor.init(hex: "959494")
        }
    }
    @objc func updateredeemsfail(notification: NSNotification)
    {
        let  msg = (notification.userInfo?["msg"] )as! String
        //LoadingIndicatorView.hide()
        alertWithTitle(title: nil, message: msg, ViewController: self)
    }
    @objc func updateredeemssuccs(notification: NSNotification)
    {
       // self.navigationController?.popViewController(animated: true)
        let  msg = (notification.userInfo?["msg"] )as! String
        //LoadingIndicatorView.hide()
        alertWithTitle(title: nil, message: msg, ViewController: self)
        
    }
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
     @IBAction func Paypal_but() {
       
            showRedeem()
        
    }
    @IBAction func first_but() {
        if(firstcheked){
            firstcheked_but?.setImage(UIImage(named: "Tuncheck"), for: .normal)
            firstcheked = false
        }
        else{
            firstcheked_but?.setImage(UIImage(named: "Tchecked"), for: .normal)
            firstcheked = true
        }
       
    }

    @IBAction func secound_but() {
        if(secoundcheked){
            secoundcheked_but?.setImage(UIImage(named: "Tuncheck"), for: .normal)
            secoundcheked = false
        }
        else{
            secoundcheked_but?.setImage(UIImage(named: "Tchecked"), for: .normal)
            secoundcheked = true
        }
    }

    @IBAction func thired_but() {
        if(thirdcheked){
            thirdcheked_but?.setImage(UIImage(named: "Tuncheck"), for: .normal)
            thirdcheked = false
        }
        else{
            thirdcheked_but?.setImage(UIImage(named: "Tchecked"), for: .normal)
            thirdcheked = true
        }
    }

    @IBAction func fourth_but() {
        if(fourthcheked){
            fourthcheked_but?.setImage(UIImage(named: "Tuncheck"), for: .normal)
            fourthcheked = false
        }
        else{
            fourthcheked_but?.setImage(UIImage(named: "Tchecked"), for: .normal)
            fourthcheked = true
        }
    }
    func checkForErrors() -> Bool
    { //let age_=calcAge(birthday: (userdob?.text)!)
        var errors = false
        //let title = "Error"
        var message = ""
       
      
        let paypalemail: String? = UserDefaults.standard.string(forKey: "paypalemail")
        if((paypalemail?.isEmpty)! || (redeemfc?.text?.isEmpty)!){
            
            errors = true
            message += "Please log in with PayPal to verify your PayPal email address"
            alertWithTitle1(title: nil, message: message, ViewController: self)
            
        } else if(redeemfc?.text == "0") {
            errors = true
            message += "You have insufficient FanCoins to redeem"
            alertWithTitle1(title: nil, message: message, ViewController: self)
        } else if (!firstcheked)
        {
            errors = true
            message += "Please tick confirmation boxes"
            alertWithTitle1(title: nil, message: message, ViewController: self)
        }
        else if (!secoundcheked)
        {
            errors = true
            message += "Please tick confirmation boxes"
            alertWithTitle1(title: nil, message: message, ViewController: self)
        }
        else if (!thirdcheked)
        {
            errors = true
            message += "Please tick confirmation boxes"
            alertWithTitle1(title: nil, message: message, ViewController: self)
        }
        else if (!fourthcheked)
        {
            errors = true
            message += "Please tick confirmation boxes"
            alertWithTitle1(title: nil, message: message, ViewController: self)
        }
       
            /* else if(age<13){
             errors = true
             message += "Fans under 13 years of age are not eligible."
             alertWithTitle(title: "Sorry", message: message, ViewController: self, toFocus:self.userdob!)
             
             }*/
       
        return errors
    }
    
    func showRedeem()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : PaypalwebViewController = storyBoard.instantiateViewController(withIdentifier: "paypalwebview") as! PaypalwebViewController
        //appDelegate().isFromSettings = true
        //show(myTeamsController, sender: self)
        self.present(myTeamsController, animated: true, completion: nil)
    }
     @IBAction func Redeem_but() {
        let thereWereErrors = checkForErrors()
        if !thereWereErrors
        {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "updateredeems" as AnyObject
            
            do {
                
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                // let time: Int64 = self.appDelegate().getUTCFormateDate()
                let time: Int64 = self.appDelegate().getUTCFormateDate()
                
                
                let myjidtrim: String? = userUserJid
                dictRequestData["redeemcoins"] = getRedeempoint() as AnyObject
                dictRequestData["paypalemail"] = email_txt?.text as AnyObject
                dictRequestData["termsaccepted"] = "activities" as AnyObject
                dictRequestData["requesttime"] = time as AnyObject
                dictRequestData["amount"] = gettotaamount()
                dictRequestData["currency"] = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemcurrency) as AnyObject
                dictRequestData["username"] = myjidtrim as AnyObject
                dictRequest["requestData"] = dictRequestData as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
                
                let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
               // print("updatecoins \(strFanUpdates)")
                appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
            } catch {
                print(error.localizedDescription)
            }
        }
        else {
            LoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
              self.navigationController?.popViewController(animated: true)
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func getRedeempoint() -> Int  {
       let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Int
        let minredeem = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemth) as! Int
        if(avilablecoin >= minredeem){
            let r = avilablecoin % minredeem
            let Q = (avilablecoin - r)
            print(Q)
            return Q
        }
        return 0
    }
    func getbalancepoint() -> Int  {
        let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Int
        let minredeem = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemth) as! Int
        if(avilablecoin >= minredeem){
            let r = avilablecoin % minredeem
            //let Q = (avilablecoin - r)
            //print(Q)
            return r
        }
        return avilablecoin
    }
    func gettotaamount() -> AnyObject  {
        let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Int
        let minredeem = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemth) as! Int
        if(avilablecoin >= minredeem){
            let r = avilablecoin % minredeem
            let Q = (avilablecoin - r) / minredeem
            print(Q)
             let convertcash = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcredeemamt) as! Int
            return Q * convertcash as AnyObject
        }
        return 0 as AnyObject
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }

    @objc func emailClick( sender: UITapGestureRecognizer) {
        //print("Comment Click")
      /*  guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }*/
// let touchPoint = sender.location(in: Infoemail)
        if(!emailmenuvisible){
        let superView1 = uiemail//self.view
        superView1!.becomeFirstResponder()// Make responsiveView the window's first responder
        //senderView.becomeFirstResponder()
        let ReportMenuItem = UIMenuItem(title: "Your PayPal Email Address to redeem", action: #selector(menuTapped))
        UIMenuController.shared.menuItems = [ReportMenuItem]
        UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
        UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 15, width: 500, height: 60), in: superView1!)
        //print(self.view.frame.width)
        // Animate the menu onto view
            emailmenuvisible = true
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
        UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        else{
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
        }

    }
    @objc func InfoAcoinsClick( sender: UITapGestureRecognizer) {
        //print("Comment Click")
        if(!AFCmenuvisible){
        let superView1 = uiafc//self.view
        superView1!.becomeFirstResponder()// Make responsiveView the window's first responder
        //senderView.becomeFirstResponder()
        let ReportMenuItem = UIMenuItem(title: "Available FanCoins in your account", action: #selector(menuTapped))
        UIMenuController.shared.menuItems = [ReportMenuItem]
        UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
        UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 15, width: 500, height: 30), in: superView1!)
        AFCmenuvisible = true
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
            emailmenuvisible = false
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        else{
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
        }

    }
    @objc func InfoRcoinsClick( sender: UITapGestureRecognizer) {
        //print("Comment Click")
        if(!RFCmenuvisible){
        let superView1 = uirfc//self.view
        superView1!.becomeFirstResponder()// Make responsiveView the window's first responder
        //senderView.becomeFirstResponder()
        let ReportMenuItem = UIMenuItem(title: "Redeemable FanCoins in your account", action: #selector(menuTapped))
        UIMenuController.shared.menuItems = [ReportMenuItem]
        UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
        UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 15, width: 500, height: 30), in: superView1!)
            emailmenuvisible = false
            AFCmenuvisible = false
        RFCmenuvisible = true
            BFCmenuvisible = false
            TFCmenuvisible = false
            
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        else{
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
            
        }

    }
    @objc func InfoBcoinsClick( sender: UITapGestureRecognizer) {
        //print("Comment Click")
        if(!BFCmenuvisible){
        let superView1 = uibfc//self.view
        superView1!.becomeFirstResponder()// Make responsiveView the window's first responder
        //senderView.becomeFirstResponder()
        let ReportMenuItem = UIMenuItem(title: "Potential balance FanCoins after you redeem", action: #selector(menuTapped))
        UIMenuController.shared.menuItems = [ReportMenuItem]
        UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
        UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 15, width: 500, height: 40), in: superView1!)
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
        BFCmenuvisible = true
            TFCmenuvisible = false
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        else{
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
        }

    }
    @objc func InfoTcoinsClick( sender: UITapGestureRecognizer) {
        //print("Comment Click")
        if(!TFCmenuvisible){
        let superView1 = uitfc//self.view
        superView1!.becomeFirstResponder()// Make responsiveView the window's first responder
        //senderView.becomeFirstResponder()
        let ReportMenuItem = UIMenuItem(title: "Potential earnings for your redeemable FanCoins", action: #selector(menuTapped))
        UIMenuController.shared.menuItems = [ReportMenuItem]
        UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
        UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 15, width: 500, height: 40), in: superView1!)
        TFCmenuvisible = true
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        else{
            emailmenuvisible = false
            AFCmenuvisible = false
            RFCmenuvisible = false
            BFCmenuvisible = false
            TFCmenuvisible = false
        }
    }
     @objc func menuTapped() {
        emailmenuvisible = false
         AFCmenuvisible = false
         RFCmenuvisible = false
         BFCmenuvisible = false
         TFCmenuvisible = false
    }
     @objc func InforesetClick(_ sender: UITapGestureRecognizer) {
        emailmenuvisible = false
        AFCmenuvisible = false
        RFCmenuvisible = false
        BFCmenuvisible = false
        TFCmenuvisible = false
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            RedeemViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return RedeemViewController.realDelegate!;
    }
}
