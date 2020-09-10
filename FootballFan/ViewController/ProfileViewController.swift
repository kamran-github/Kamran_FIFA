//
//  ProfileViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 19/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import XMPPFramework
import CoreTelephony
import Photos
import YPImagePicker
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var userIBName: UITextField?
    @IBOutlet weak var userIBAvtar: UIImageView?
    //@IBOutlet weak var PreStatus: UIButton?
    @IBOutlet weak var Childview: UIView?
    @IBOutlet weak var parentview: UIScrollView?
    // var activityIndicator: UIActivityIndicatorView?
    var isFromSettings: Bool = false
    @IBOutlet weak var useremail: UITextField?
    @IBOutlet weak var userdob: UITextField?
    @IBOutlet weak var name: UITextField?
    @IBOutlet weak var usernamelabel: UILabel?
   // @IBOutlet weak var username: UILabel?
    @IBOutlet weak var usermobile: UITextField?
    @IBOutlet weak var countryCode: UILabel?
    @IBOutlet weak var btnCountryName: UIButton?
    @IBOutlet weak var namecount: UILabel?
    @IBOutlet weak var mobilecount: UILabel?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewNavigation: UINavigationBar!
    @IBOutlet weak var Referralcode: UILabel?
    @IBOutlet weak var Referallnote: UILabel?
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    var Tagtextfield = 1
    var maximumY: CGFloat=0.0
    //New code by Ravi on 24-02-2020
    let MobileACCEPTABLE_CHARACTERS = "0123456789"
    let extraACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@."
      let reportACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@.!#$%^&*()+=<>?:;{}[],' \n`|"
    var datePicker = UIDatePicker()
    var age: Int64 = 0
    @IBOutlet weak var btnCancelTeam: UIButton?
    @IBOutlet weak var ChildHeightConstaint: NSLayoutConstraint!
    var removeimage: Bool = false
    //var vcardfetched: Bool = false
    var Avtarurl: String = ""
    @IBOutlet weak var followerviewwidth: NSLayoutConstraint!
     @IBOutlet weak var postviewwidth: NSLayoutConstraint!
     @IBOutlet weak var followingviewwidth: NSLayoutConstraint!
     @IBOutlet weak var avtareviewheight: NSLayoutConstraint!
     @IBOutlet weak var btnfollowerCount: UIButton?
    @IBOutlet weak var btnfollowingCount: UIButton?
    @IBOutlet weak var btnPostCount: UIButton?
     @IBOutlet weak var biocount: UILabel?
    @IBOutlet weak var emailcount: UILabel?
     @IBOutlet weak var biotTextview: UITextView!
     
        @IBOutlet weak var butfollower: UIButton?
        @IBOutlet weak var butfollowing: UIButton?
            @IBOutlet weak var butpost: UIButton?
    @IBOutlet weak var imgsisverify: UIImageView?
    @IBOutlet weak var imglavel: UIImageView?
     @IBOutlet weak var topview: UIView?
    
    @IBOutlet weak var loginview: UIView?
       @IBOutlet weak var loginimageview: UIImageView?
       @IBOutlet weak var loginmsg: UILabel?
       @IBOutlet weak var loginbut: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        let recReadUserJid: String? = UserDefaults.standard.string(forKey: "userJID")
                 if(recReadUserJid != nil){
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        userIBName?.delegate = self
        useremail?.delegate = self
        usermobile?.delegate = self
        name?.delegate = self
        userdob?.delegate = self
        biotTextview.delegate = self
        let bounds: CGRect = UIScreen.main.bounds
               //var width:CGFloat = bounds.size.width
               let width:CGFloat = bounds.size.width
        avtareviewheight.constant = width
        followerviewwidth.constant = width / 3
        followingviewwidth.constant = width / 3
        postviewwidth.constant = width / 3
        ChildHeightConstaint.constant = width + 700
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
        let notificationName2 = Notification.Name("_settingGetPermissionsForMediaProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.GetPermissionsForMediaProfile), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_settingGetPermissionsForCameraProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.GetPermissionsForCameraProfile), name: notificationName3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.GetPermissionsForMediaProfile), name: notificationName2, object: nil)
        
        let notificationName4 = Notification.Name("succefullprofile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.succfullResponce), name: notificationName4, object: nil)
        let notificationName5 = Notification.Name("failprofile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.failResponce), name: notificationName5, object: nil)
        let notificationName6 = Notification.Name("setVCard")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.SetVCard), name: notificationName6, object: nil)
        Referallnote?.text = "Share your Referral Code with others to Sign Up and collect additional  \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins rewards. Learn more."
        let text = (Referallnote?.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Learn more.")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: range1)
        
        Referallnote?.attributedText = underlineAttriString
        
        
        Referallnote?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapLabel(_:))))
        Referallnote?.isUserInteractionEnabled = true
        let notificationName7 = Notification.Name("modifyStatus")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.SetStatus), name: notificationName7, object: nil)
        if(appDelegate().StatusTemp != "" && appDelegate().isvCardUpdated == true)
        {
            let userStatus: String? = appDelegate().StatusTemp
            // userIBName?.text =
            if((userStatus) != nil || userStatus != "")
            {
                userIBName?.text = userStatus
            }else{
                appDelegate().StatusTemp = "Hello! I am a Football Fan"
                userIBName?.text = "Hello! I am a Football Fan"
            }
        }
        else
        {
            let userStatus: String? = UserDefaults.standard.string(forKey: "userStatus")
            
            if((userStatus) != nil || userStatus != "")
            {
                userIBName?.text = userStatus
            }else{
                userIBName?.text = "Hello! I am a Football Fan"
            }
        }
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if(!self.vcardfetched){
                self.appDelegate().xmppvCardStorage = XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                
                if(self.appDelegate().xmppvCardStorage != nil)
                {
                    self.appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: self.appDelegate().xmppvCardStorage!)
                    self.appDelegate().xmppvCardTempModule?.activate(self.appDelegate().xmppStream!)
                    self.appDelegate().xmppvCardTempModule?.addDelegate(self, delegateQueue: DispatchQueue.main)
                    
                    self.appDelegate().xmppvCardTempModule?.fetchvCardTemp(for: self.appDelegate().xmppStream!.myJID!, ignoreStorage: true)
                }
                else
                {
                    self.appDelegate().xmppvCardStorage2 = XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                    
                    if(self.appDelegate().xmppvCardStorage2 != nil)
                    {
                        self.appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: self.appDelegate().xmppvCardStorage2!)
                        self.appDelegate().xmppvCardTempModule?.activate(self.appDelegate().xmppStream!)
                        self.appDelegate().xmppvCardTempModule?.addDelegate(self, delegateQueue: DispatchQueue.main)
                        
                        self.appDelegate().xmppvCardTempModule?.fetchvCardTemp(for: self.appDelegate().xmppStream!.myJID!, ignoreStorage: true)
                    }
                }
            }
        }*/
        //new code by nitesh for country code
             
            #if arch(i386) || arch(x86_64)
             
             
             if(appDelegate().countrySelected.isEmpty)
             {
                 //Code to get Country details from Dictionary
                 
                 // self.userIBName?.becomeFirstResponder()
                 usermobile?.text = UserDefaults.standard.string(forKey: "registerMobile")
                 name?.text = UserDefaults.standard.string(forKey: "userName")
                 useremail?.text = UserDefaults.standard.string(forKey: "useremail")
                 let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
                 //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                 namecount?.text=String(describing: name?.text?.count ?? 0)+"/"+String(describing: name?.maxLength ?? 0)
                 mobilecount?.text=String(describing: usermobile?.text?.count ?? 0)+"/"+String(describing: usermobile?.maxLength ?? 0)
                 let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                 let userReadUserJid = arrReadUserJid[0]
                 //username?.text=userReadUserJid
                 Referralcode?.text = userReadUserJid
                 let mili: Double=UserDefaults.standard.double(forKey: "userdob")
                 let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                 appDelegate().DobTemp=Int64(mili)
                 //let myMilliseconds: String = UserDefaults.standard.string(forKey: "userdob")!
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "dd MMM yyyy"
                 //dateFormatter.dateStyle = .short
                 userdob?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                 let now = Date()
                 let birthday: Date = myMilliseconds.dateFull as Date
                 let calendar = Calendar.current
                 
                 let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                 age = Int64(ageComponents.year!)
                 if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                     
                     do {
                         let code:String = "in"
                         let json = try JSONSerialization.jsonObject(with: data, options: [])
                         let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: code) as? NSDictionary)!
                         
                         countryCode!.text = dictCountry.value(forKey: "code") as? String
                         //btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                         
                         btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                         
                         //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                         //countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                         
                         
                     } catch let error as NSError {
                         print(error)
                     }
                 }
                 
             }
             else
             {
                 //self.usermobile?.becomeFirstResponder()
                 countryCode!.text = appDelegate().countryCodeSelected
                 //countryName!.titleLabel = "United Kingdom"
                 btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
                 // btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                 //countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
             }
             
             //DefaultCountry = [DefaultCountry uppercaseString];
             
             //Temp code
             //countryCode!.text = "+91"
             //self.userJID?.becomeFirstResponder()
             
             #else
             
             let device = UIDevice.current.model
             if(device == "iPad"){
                 if(appDelegate().countrySelected.isEmpty)
                        {
                            //Code to get Country details from Dictionary
                            
                            // self.userIBName?.becomeFirstResponder()
                            usermobile?.text = UserDefaults.standard.string(forKey: "registerMobile")
                            name?.text = UserDefaults.standard.string(forKey: "userName")
                            useremail?.text = UserDefaults.standard.string(forKey: "useremail")
                            let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
                            //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                            namecount?.text=String(describing: name?.text?.count ?? 0)+"/"+String(describing: name?.maxLength ?? 0)
                            mobilecount?.text=String(describing: usermobile?.text?.count ?? 0)+"/"+String(describing: usermobile?.maxLength ?? 0)
                            let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                            let userReadUserJid = arrReadUserJid[0]
                           // username?.text=userReadUserJid
                            Referralcode?.text = userReadUserJid
                            let mili: Double=UserDefaults.standard.double(forKey: "userdob")
                            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                            appDelegate().DobTemp=Int64(mili)
                            //let myMilliseconds: String = UserDefaults.standard.string(forKey: "userdob")!
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MMM yyyy"
                            //dateFormatter.dateStyle = .short
                            userdob?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                            let now = Date()
                            let birthday: Date = myMilliseconds.dateFull as Date
                            let calendar = Calendar.current
                            
                            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                            age = Int64(ageComponents.year!)
                            if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                
                                do {
                                 var countrycode: String? = "us"
                                 if let shortcode = UserDefaults.standard.string(forKey: "usercountryshortcode")
                                 {
                                     //countrycode = countrycode?.replace(target: "++", withString: "+")
                                     
                                     if( shortcode == ""){
                                         countrycode = "us"
                                     }
                                     else{
                                         countrycode = shortcode
                                     }
                                 }
                                    //let code:String = "us"
                                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                                    let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                                    
                                    
                                    countryCode!.text = dictCountry.value(forKey: "code") as? String
                                    //btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                                    
                                    btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                                    
                                    //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                                    //countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                                    
                                    
                                } catch let error as NSError {
                                    //print(error)
                                }
                            }
                            
                        }
                        else
                        {
                            //self.usermobile?.becomeFirstResponder()
                            countryCode!.text = appDelegate().countryCodeSelected
                            //countryName!.titleLabel = "United Kingdom"
                            btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
                            // btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                            //countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
                        }
             }
             else{
             if(appDelegate().hasCellularCoverage())!
             {
                 //CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc],; init;]
                 
                 let netinfo = CTTelephonyNetworkInfo()
                 
                 let carrier: CTCarrier = netinfo.subscriberCellularProvider!
                 
                 if(appDelegate().countrySelected.isEmpty)
                 {
                     //self.userIBName?.becomeFirstResponder()
                     usermobile?.text = UserDefaults.standard.string(forKey: "registerMobile")
                     name?.text = UserDefaults.standard.string(forKey: "userName")
                     useremail?.text = UserDefaults.standard.string(forKey: "useremail")
                     let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
                     //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                     namecount?.text=String(describing: name?.text?.count ?? 0)+"/"+String(describing: name?.maxLength ?? 0)
                     let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                     let userReadUserJid = arrReadUserJid[0]
                    // username?.text=userReadUserJid
                     Referralcode?.text = userReadUserJid
                     mobilecount?.text=String(describing: usermobile?.text?.count ?? 0)+"/"+String(describing: usermobile?.maxLength ?? 0)
                     let mili: Double=UserDefaults.standard.double(forKey: "userdob")
                     if(mili != 0){
                         let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                         appDelegate().DobTemp=Int64(mili)
                         //let myMilliseconds: String = UserDefaults.standard.string(forKey: "userdob")!
                         let dateFormatter = DateFormatter()
                         dateFormatter.dateFormat = "dd MMM yyyy"
                         //dateFormatter.dateStyle = .short
                         userdob?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                         //Code to get Country details from Dictionary
                         let now = Date()
                         let birthday: Date = myMilliseconds.dateFull as Date
                         let calendar = Calendar.current
                         
                         let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                         age = Int64(ageComponents.year!)
                     }
                     if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                         
                         do {
                             var countrycode: String? = "gb"
                             if let shortcode = UserDefaults.standard.string(forKey: "usercountryshortcode")
                             {
                                 //countrycode = countrycode?.replace(target: "++", withString: "+")
                                 
                                 if( shortcode == ""){
                                     countrycode = "gb"
                                 }
                                 else{
                                     countrycode = shortcode
                                 }
                             }
                             appDelegate().CountryShotcutTemp = countrycode!
                             if(countrycode != nil || countrycode != ""){
                                 
                                 
                                 let json = try JSONSerialization.jsonObject(with: data, options: [])
                                 let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                                 
                                 countryCode!.text = dictCountry.value(forKey: "code") as? String
                                 //btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                                 
                                 btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                                 
                                 
                                 
                             }
                             else{
                                 let code:String = (carrier.isoCountryCode?.lowercased())!
                                 let json = try JSONSerialization.jsonObject(with: data, options: [])
                                 let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: code) as? NSDictionary)!
                                 
                                 countryCode!.text = dictCountry.value(forKey: "code") as? String
                                 // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                                 btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                                 
                             }
                             
                             //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                             // countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                             
                             
                         } catch let error as NSError {
                             print(error)
                         }
                     }
                     
                 }
                 else
                 {
                     self.usermobile?.becomeFirstResponder()
                     countryCode!.text = appDelegate().countryCodeSelected
                     //countryName!.titleLabel = "United Kingdom"
                     btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
                     //btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                     //countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
                 }
                 
                 //DefaultCountry = [DefaultCountry uppercaseString];
                 
                 //Temp code
                 //countryCode!.text = "+91"
                 // self.userJID?.becomeFirstResponder()
             }
             else
             {
                // appDelegate().showSimAlert()
                 if(appDelegate().countrySelected.isEmpty)
                 {
                     //Code to get Country details from Dictionary
                     
                     // self.userIBName?.becomeFirstResponder()
                     usermobile?.text = UserDefaults.standard.string(forKey: "registerMobile")
                     name?.text = UserDefaults.standard.string(forKey: "userName")
                     useremail?.text = UserDefaults.standard.string(forKey: "useremail")
                     let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
                     //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                     namecount?.text=String(describing: name?.text?.count ?? 0)+"/"+String(describing: name?.maxLength ?? 0)
                     mobilecount?.text=String(describing: usermobile?.text?.count ?? 0)+"/"+String(describing: usermobile?.maxLength ?? 0)
                     let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                     let userReadUserJid = arrReadUserJid[0]
                    // username?.text=userReadUserJid
                     Referralcode?.text = userReadUserJid
                     let mili: Double=UserDefaults.standard.double(forKey: "userdob")
                     let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                     appDelegate().DobTemp=Int64(mili)
                     //let myMilliseconds: String = UserDefaults.standard.string(forKey: "userdob")!
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "dd MMM yyyy"
                     //dateFormatter.dateStyle = .short
                     userdob?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                     let now = Date()
                     let birthday: Date = myMilliseconds.dateFull as Date
                     let calendar = Calendar.current
                     
                     let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                     age = Int64(ageComponents.year!)
                     if let data = countrystring.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                         
                         do {
                            var countrycode: String? = "gb"
                             if let shortcode = UserDefaults.standard.string(forKey: "usercountryshortcode")
                             {
                                 //countrycode = countrycode?.replace(target: "++", withString: "+")
                                 
                                 if( shortcode == ""){
                                     countrycode = "gb"
                                 }
                                 else{
                                     countrycode = shortcode
                                 }
                             }
                                //let code:String = "us"
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                                
                             countryCode!.text = dictCountry.value(forKey: "code") as? String
                             //btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                             
                             btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                             
                             //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                             //countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                             
                             
                         } catch let error as NSError {
                             //print(error)
                         }
                     }
                     
                 }
                 else
                 {
                     self.usermobile?.becomeFirstResponder()
                     countryCode!.text = appDelegate().countryCodeSelected
                     //countryName!.titleLabel = "United Kingdom"
                     btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
                     //btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                     //countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
                 }
             }
             }
             #endif
        let bio:String = UserDefaults.standard.string(forKey: "userbio")!
        if(bio != ""){
        biotTextview.insertText(bio)
        }
        else{
            biotTextview.text = ""
        }
            let CurentLevel = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fccurrentlevel) as! String
            
        if(CurentLevel == "Bronze")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbronzeimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                   }
               } else if(CurentLevel  == "Silver")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsilverimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                   }
               } else if(CurentLevel == "Gold")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcgoldimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                   }
               } else if(CurentLevel == "Platinum")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcplatinumimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                   }
               } else if(CurentLevel == "Diamond")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcdiamondimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.imglavel?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.imglavel!)
                   }
               }
        else{
            imglavel?.isHidden = true
        }
       let isverify = UserDefaults.standard.bool(forKey: "isverfyprofile")
        if (isverify) {
            imgsisverify?.image = UIImage(named: "like")
             imgsisverify?.isHidden = false
        }
        else{
            imgsisverify?.isHidden = true
        }
    }
    }
    @IBAction func modleAction(){
           let action: String? = UserDefaults.standard.string(forKey: "chatloginaction")
           if(action == "login"){
               appDelegate().LoginwithModelPopUp()
               
           }
       }
    func updateControllsjidnotavilables() {
        topview?.isHidden = true
        parentview?.isHidden = true
        loginview?.isHidden = false
        self.navigationItem.title = "Profile"
        
        let but: String? = UserDefaults.standard.string(forKey: "profileloginmbut")
                   loginbut?.setTitle(but, for: .normal)
                   let message: String? = UserDefaults.standard.string(forKey: "profileloginmsg")
                   loginmsg?.text = message
                   
                   let mediaurl: String? = UserDefaults.standard.string(forKey: "profileloginmurl")
                   let mediatype: String? = UserDefaults.standard.string(forKey: "profileloginmtype")
                   if(mediatype == "gif"){
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
                               //let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                               loginimageview?.image = UIImage.gifImageWithData(imageData as Data)
                           }
                        
                       }
                       else{
                           loginimageview?.image = UIImage.gifImageWithURL(mediaurl!)
                       }
                       //
                   }
                   else{
                       loginimageview?.imageURL = mediaurl
                   }
    }
    @objc func GetPermissionsForCameraProfile(notification: NSNotification){
        //Code to show camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let text = (Referallnote!.text)!
        let termsRange = (text as NSString).range(of: "Learn more.")
        
        
        if gesture.didTapAttributedTextInLabel(label: Referallnote!, inRange: termsRange) {
            // print("Tapped terms")
            UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
            UserDefaults.standard.synchronize()
            // hide()
            //let notificationName2 = Notification.Name("learnMore")
            //NotificationCenter.default.post(name: notificationName2, object: nil)
            
            showWEBVIEWScreen()
            
        }
    }
    func showWEBVIEWScreen()
    {
        
        
        /*  let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webview")
         
         // set the presentation style
         popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         //popController.modalPresentationStyle = .popover
         popController.modalTransitionStyle = .crossDissolve
         
         // set up the popover presentation controller
         popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
         popController.popoverPresentationController?.delegate = self as UIPopoverPresentationControllerDelegate
         popController.popoverPresentationController?.sourceView = self.view // button
         //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
         
         // present the popover
         self.present(popController, animated: true, completion: nil)*/
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewcontroller = storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewcontroller
        
        show(myTeamsController, sender: self)
    }
    @objc func succfullResponce(notification: NSNotification){
        //Code to show camera
        DispatchQueue.main.async {
            //TransperentLoadingIndicatorView.hide()
            //self.dismiss(animated: true, completion: nil)
            if(self.isFromSettings){
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @objc func failResponce(notification: NSNotification){
        //Code to show camera
        DispatchQueue.main.async {
            //TransperentLoadingIndicatorView.hide()
            if let fetchedCaption = notification.userInfo?["profileerror"]
                   {
                    self.alertWithTitle(title: nil, message: fetchedCaption as! String, ViewController: self, toFocus: self.useremail!)
            }
        }}
    @objc func SetStatus(notification: NSNotification){
        if(appDelegate().StatusTemp != "" && appDelegate().isvCardUpdated == true)
        {
            let userStatus: String? = appDelegate().StatusTemp
            // userIBName?.text =
            if((userStatus) != nil || userStatus != "")
            {
                userIBName?.text = userStatus
            }else{
                appDelegate().StatusTemp = "Hello! I am a Football Fan"
                userIBName?.text = "Hello! I am a Football Fan"
            }
        }
    }
    @objc func SetVCard(notification: NSNotification){
        //Code to show camera
        if appDelegate().isAvtarChanged == false
        {
          //  vcardfetched = true
            //Prepare Avtar View
           /* userIBAvtar?.layer.masksToBounds = true;
            userIBAvtar?.clipsToBounds=true;
            userIBAvtar?.layer.borderWidth = 1.0
            userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor //UIColor.cyan.cgColor
            userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            userIBAvtar?.layer.cornerRadius = 55.0*/
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                //let userName: String? = UserDefaults.standard.string(forKey: "userStatus")
                let userAvatar: String? = UserDefaults.standard.string(forKey: "userAvatar")
                
                //if((userName) != nil)
                //{
                //userIBName?.text = userName
                //}
                if((userAvatar) != nil)
                {
                    self.userIBAvtar?.image = self.appDelegate().loadProfileImage(filePath: userAvatar!)
                    //self.userIBAvtar?.setImage(self.appDelegate().loadProfileImage(filePath: userAvatar!), for: UIControl.State.normal)
                }
            }
            let userAvatarurl: String? = UserDefaults.standard.string(forKey: "userAvatarURL")
            Avtarurl = userAvatarurl!
            
            if(userAvatarurl == userAvtar){
                removeimage = true
            }
            //}
            DispatchQueue.main.async {
                let userStatus: String? = UserDefaults.standard.string(forKey: "userStatus")
                
                if((userStatus) != nil || userStatus != "")
                {
                    self.userIBName?.text = userStatus
                }else{
                    self.userIBName?.text = "Hello! I am a Football Fan"
                }
                self.name?.text = UserDefaults.standard.string(forKey: "userName")
            }
        }
        let followerscount:Int64 = Int64(UserDefaults.standard.integer(forKey: "followerscount"))//subtypevalue.value(forKey: "followerscount") as! Int64
        let followingcount:Int64 = Int64(UserDefaults.standard.integer(forKey: "followingcount"))//subtypevalue.value(forKey: "followingcount") as! Int64
        let fanstorycount:Int64 = Int64(UserDefaults.standard.integer(forKey: "fanstorycount"))//subtypevalue.value(forKey: "fanstorycount") as! Int64
        if(fanstorycount>1){
            butpost?.setTitle("Posts" , for: UIControl.State.normal)
        }
        else{
            butpost?.setTitle("Post" , for: UIControl.State.normal)
        }
        if(followingcount>1){
            butfollowing?.setTitle("Following" , for: UIControl.State.normal)
        }
        else{
            butfollowing?.setTitle("Following", for: UIControl.State.normal)
        }
        if(followerscount>1){
            butfollower?.setTitle("Followers" , for: UIControl.State.normal)
        }
        else{
            butfollower?.setTitle("Follower" , for: UIControl.State.normal)
        }
        btnfollowerCount?.setTitle( self.appDelegate().formatNumber(Int(followerscount )) , for: UIControl.State.normal)
        btnfollowingCount?.setTitle(self.appDelegate().formatNumber(Int(followingcount )) , for: UIControl.State.normal)
        btnPostCount?.setTitle(self.appDelegate().formatNumber(Int(fanstorycount )) , for: UIControl.State.normal)
    }
    @objc func GetPermissionsForMediaProfile(notification: NSNotification){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            //Show loader
            //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
            // self.activityIndicator?.startAnimating()
            // LoadingIndicatorView.show(self.view, loadingText: "Showing your photo album.")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //appDelegate().toUserJID = ""
        self.appDelegate().isOnprofileviewView =  false
        appDelegate().isAvtarChanged = false
        appDelegate().StatusTemp = ""
        appDelegate().isvCardUpdated = false
        /*if(self.appDelegate().isShowChatWindow)
         {
         appDelegate().toUserJID = ""
         appDelegate().toName = ""
         appDelegate().toAvatarURL = ""
         }*/
        //self.appDelegate().isShowChatWindow = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setupDatePicker()
        //se
        self.appDelegate().isOnprofileviewView = true
       // if(isFromSettings){
        
        let recReadUserJid: String? = UserDefaults.standard.string(forKey: "userJID")
          if(recReadUserJid != nil){
            let arrReadUserJid = recReadUserJid!.components(separatedBy: "@")
        let userReadUserJid = arrReadUserJid[0]
       
      
            self.navigationItem.title = userReadUserJid//"Profile"
            
           // let infoButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.profileDone(sender:)))//UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
            //UIBarButtonItem(barButtonSystemItem: UIImage(named: "remove"), target: self, action: #selector(BantersViewController.Banterdelete))
            // 3
           // self.navigationItem.rightBarButtonItem = infoButton
           // self.parentviewTopConstaint.constant = CGFloat(5.0)
        //}
       // else{
           // self.parentviewTopConstaint.constant = CGFloat(40.0)
        //}
        
        let usermobileno = UserDefaults.standard.string(forKey: "isprofileNotSelected")
        if( usermobileno != nil)
        {
            btnCancelTeam?.isHidden = true
            usermobile?.becomeFirstResponder()
        }
        else{
            btnCancelTeam?.isHidden = false
        }
        if appDelegate().isAvtarChanged == false
        {
            //Prepare Avtar View
            /*userIBAvtar?.layer.masksToBounds = true;
            userIBAvtar?.clipsToBounds=true;
            userIBAvtar?.layer.borderWidth = 1.0
            userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor //UIColor.cyan.cgColor
            userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            userIBAvtar?.layer.cornerRadius = 55.0*/
            
            
            //let userName: String? = UserDefaults.standard.string(forKey: "userStatus")
            let userAvatar: String? = UserDefaults.standard.string(forKey: "userAvatar")
            
            //if((userName) != nil)
            //{
            //userIBName?.text = userName
            //}
            if((userAvatar) != nil)
            {
                userIBAvtar?.image = appDelegate().loadProfileImage(filePath: userAvatar!)
                //userIBAvtar?.setImage(appDelegate().loadProfileImage(filePath: userAvatar!), for: UIControl.State.normal)
            }
            let userAvatarurl: String? = UserDefaults.standard.string(forKey: "userAvatarURL")
            Avtarurl = userAvatarurl!
            
            if(userAvatarurl == userAvtar){
                removeimage = true
                 self.appDelegate().profileAvtarTemp = UIImage(named:"avatar")
               /* userIBAvtar?.layer.masksToBounds = true;
                           userIBAvtar?.clipsToBounds=true;
                           userIBAvtar?.layer.borderWidth = 1.0
                           userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor //UIColor.cyan.cgColor
                           userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
                           userIBAvtar?.layer.cornerRadius = 55.0*/
                            //self.userIBAvtar?.setImage(self.appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
                userIBAvtar?.image = self.appDelegate().profileAvtarTemp!
            }
            //}
              appDelegate().GetmyTeam()
        }
        else
        {
           /* userIBAvtar?.layer.masksToBounds = true;
            userIBAvtar?.clipsToBounds=true;
            userIBAvtar?.layer.borderWidth = 1.0
            userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor
            userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            userIBAvtar?.layer.cornerRadius = 55.0*/
            userIBAvtar?.image = appDelegate().profileAvtarTemp!
            //userIBAvtar?.setImage(appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
            
            /* let userName: String? = UserDefaults.standard.string(forKey: "userStatus")
             
             if((userName) != nil)
             {
             userIBName?.text = userName
             }*/
            
        }
        #if arch(i386) || arch(x86_64)
                   
       if(!appDelegate().countrySelected.isEmpty)
                   {
                    countryCode!.text = appDelegate().countryCodeSelected
                                        //countryName!.titleLabel = "United Kingdom"
                                        btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
        }
    
                 
                 //DefaultCountry = [DefaultCountry uppercaseString];
                 
                 //Temp code
                 //countryCode!.text = "+91"
                 //self.userJID?.becomeFirstResponder()
                 
                 #else
                 
                 let device = UIDevice.current.model
                 if(device == "iPad"){
                    if(!appDelegate().countrySelected.isEmpty)
                    {
                    countryCode!.text = appDelegate().countryCodeSelected
                                              //countryName!.titleLabel = "United Kingdom"
                                              btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
                    }
                 } else{
                    if(appDelegate().hasCellularCoverage())!
                    {
                        if(!appDelegate().countrySelected.isEmpty)
                        {
                        self.usermobile?.becomeFirstResponder()
                                           countryCode!.text = appDelegate().countryCodeSelected
                                           //countryName!.titleLabel = "United Kingdom"
                                           btnCountryName?.setImage(UIImage(named:(appDelegate().countryFlagSelected)), for: UIControl.State.normal)
                        }
                        }}
          #endif
        let followerscount:Int64 = Int64(UserDefaults.standard.integer(forKey: "followerscount"))//subtypevalue.value(forKey: "followerscount") as! Int64
        let followingcount:Int64 = Int64(UserDefaults.standard.integer(forKey: "followingcount"))//subtypevalue.value(forKey: "followingcount") as! Int64
        let fanstorycount:Int64 = Int64(UserDefaults.standard.integer(forKey: "fanstorycount"))//subtypevalue.value(forKey: "fanstorycount") as! Int64
        if(fanstorycount>1){
            butpost?.setTitle("Posts" , for: UIControl.State.normal)
        }
        else{
            butpost?.setTitle("Post" , for: UIControl.State.normal)
        }
        if(followingcount>1){
            butfollowing?.setTitle("Following" , for: UIControl.State.normal)
        }
        else{
            butfollowing?.setTitle("Following", for: UIControl.State.normal)
        }
        if(followerscount>1){
            butfollower?.setTitle("Followers" , for: UIControl.State.normal)
        }
        else{
            butfollower?.setTitle("Follower" , for: UIControl.State.normal)
        }
        btnfollowerCount?.setTitle( self.appDelegate().formatNumber(Int(followerscount )) , for: UIControl.State.normal)
        btnfollowingCount?.setTitle(self.appDelegate().formatNumber(Int(followingcount )) , for: UIControl.State.normal)
        btnPostCount?.setTitle(self.appDelegate().formatNumber(Int(fanstorycount )) , for: UIControl.State.normal)
        countryCode?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.showCountryList)))
        countryCode?.isUserInteractionEnabled = true
        appDelegate().NameTemp = (name?.text)!
        appDelegate().EmailTemp = (useremail?.text)!
        appDelegate().MobileTemp = (usermobile?.text)!
        appDelegate().CountrycodeTemp = (countryCode?.text)!
        appDelegate().bioTemp = biotTextview.text
        //setupDatePicker();
            topview?.isHidden = false
                   parentview?.isHidden = false
                   loginview?.isHidden = true
        }
          else{
            updateControllsjidnotavilables()
        }
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuoption))
    }
    @objc func menuoption () {
     let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
              
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
        //messageBox?.resignFirstResponder()
       let LeaderBoardAction = UIAlertAction(title: "Leader Board", style: .default, imageNamed: "uncheck", handler: {
                     (alert: UIAlertAction!) -> Void in
                 
        self.Showbord()
                 })
             let ContactsAction = UIAlertAction(title: "Contacts", style: .default, imageNamed: "uncheck", handler: {
                                    (alert: UIAlertAction!) -> Void in
                self.showWContact()
                                    
                                })
             let NotificationAction = UIAlertAction(title: "Notification Settings", style: .default, imageNamed: "uncheck", handler: {
                                                   (alert: UIAlertAction!) -> Void in
                self.showWNotificationScreen()
                                                   
                                               })
             let changepassword = UIAlertAction(title: "Change Password", style: .default, imageNamed: "uncheck" , handler: {
                           (alert: UIAlertAction!) -> Void in
                          
                        self.showChangePassword()
                       })
        let BlockAction = UIAlertAction(title: "Blocked Fans", style: .default, imageNamed: "uncheck", handler: {
            (alert: UIAlertAction!) -> Void in
         self.ShowBlockedfan()
            
        })
       let inviteFriendAction = UIAlertAction(title: "Invite a Friend", style: .default, imageNamed: "uncheck", handler: {
                                                            (alert: UIAlertAction!) -> Void in
        self.share()
                                                            
                                                        })
             let TCAction = UIAlertAction(title: "Terms & Conditions", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                                                              UserDefaults.standard.setValue("Terms & Conditions", forKey: "terms")
                                                                         UserDefaults.standard.synchronize()
                self.showWEBVIEWScreen()
                                                                  
                                                              })
             let PrivacyPolicyAction = UIAlertAction(title: "Privacy Policy", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                                                              UserDefaults.standard.setValue("Privacy Policy", forKey: "terms")
                                                                         UserDefaults.standard.synchronize()
                self.showWEBVIEWScreen()
                                                                  
                                                              })
             let AppInfoAction = UIAlertAction(title: "App Info", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                self.showAppInfo()
                                                                  
                                                              })
             let SignOutAction = UIAlertAction(title: "Sign Out", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                                                              
                self.alertWithTitle(title: "", message: "Do you really want to Sign Out?", ViewController: self)
                                                              })
             
       optionMenu.addAction(LeaderBoardAction!)
       optionMenu.addAction(ContactsAction!)
       optionMenu.addAction(NotificationAction!)
       optionMenu.addAction(inviteFriendAction!)
       optionMenu.addAction(BlockAction!)
        optionMenu.addAction(changepassword!)
                          
                       optionMenu.addAction(TCAction!)
                       optionMenu.addAction(PrivacyPolicyAction!)
             optionMenu.addAction(AppInfoAction!)
                            optionMenu.addAction(SignOutAction!)
                      
     }
            else{
             let LeaderBoardAction = UIAlertAction(title: "Leader Board", style: .default, imageNamed: "uncheck", handler: {
                                    (alert: UIAlertAction!) -> Void in
                self.Showbord()
                                    
                                })
             let inviteFriendAction = UIAlertAction(title: "Invite a Friend", style: .default, imageNamed: "uncheck", handler: {
                                                            (alert: UIAlertAction!) -> Void in
                self.share()
                                                            
                                                        })
             let TCAction = UIAlertAction(title: "Terms & Conditions", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                                                              UserDefaults.standard.setValue("Terms & Conditions", forKey: "terms")
                                                                         UserDefaults.standard.synchronize()
                self.showWEBVIEWScreen()
                                                                  
                                                              })
             let PrivacyPolicyAction = UIAlertAction(title: "Privacy Policy", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                                                              UserDefaults.standard.setValue("Privacy Policy", forKey: "terms")
                                                                         UserDefaults.standard.synchronize()
                self.showWEBVIEWScreen()
                                                                  
                                                              })
             let AppInfoAction = UIAlertAction(title: "App Info", style: .default, imageNamed: "uncheck", handler: {
                                                                  (alert: UIAlertAction!) -> Void in
                self.showAppInfo()
                                                                  
                                                              })
              optionMenu.addAction(LeaderBoardAction!)
               optionMenu.addAction(inviteFriendAction!)
             optionMenu.addAction(TCAction!)
                                      optionMenu.addAction(PrivacyPolicyAction!)
                            optionMenu.addAction(AppInfoAction!)
     }
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                   (alert: UIAlertAction!) -> Void in
                   
                   //print("Cancelled")
               })
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let action = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel,handler: {_ in
              //toFocus.becomeFirstResponder()
             
          });
          let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
              if ClassReachability.isConnectedToNetwork() {
                
                  self.appDelegate().HomeSetSlider = true
                 self.appDelegate().SignOut()
                  DispatchQueue.main.async {
                    self.updateControllsjidnotavilables()
                  }
              } else {
                  self.alertWithTitle(title: "Error", message: "Please check your Internet connection.", ViewController: self)
                  
              }
              
              
          });
          alert.addAction(action)
          alert.addAction(action1)
          self.present(alert, animated: false, completion:nil)
      }
    func Showbord() {
          
               let storyBoard = UIStoryboard(name: "Main", bundle: nil)
               let myTeamsController : LeaderBoardViewController = storyBoard.instantiateViewController(withIdentifier: "leaderboard") as! LeaderBoardViewController
            
               show(myTeamsController, sender: self)
                      }
       
    func showWContact()
    {
        
        
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : ContactsTableViewController = storyBoard.instantiateViewController(withIdentifier: "Contacts") as! ContactsTableViewController
        
        show(myTeamsController, sender: self)
    }
    func showWNotificationScreen()
       {
           
           
          
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let myTeamsController : NotificationViewController = storyBoard.instantiateViewController(withIdentifier: "Notification") as! NotificationViewController
           
           show(myTeamsController, sender: self)
       }
    func showAppInfo()
       {
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let myTeamsController : AppInfoViewController = storyBoard.instantiateViewController(withIdentifier: "appinfo") as! AppInfoViewController
         //  appDelegate().isFromSettings = true
           show(myTeamsController, sender: self)
           //self.present(myTeamsController, animated: true, completion: nil)
       }
    func showChangePassword()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : ChangePasswordFromSettingViewController = storyBoard.instantiateViewController(withIdentifier: "cpassword") as! ChangePasswordFromSettingViewController
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
    }
   
    func ShowBlockedfan()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : PrivacySettingViewController = storyBoard.instantiateViewController(withIdentifier: "privacysetting") as! PrivacySettingViewController
        //  appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
       // self.present(myTeamsController, animated: true, completion: nil)
    }
    func share() {
          // let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
           //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
          // let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
          // let userReadUserJid = arrReadUserJid[0]
        var textToShare = "Check out this cool app called \"Football Fan\". I use it watch Football videos, create stories, banter, find fans, news and collect FanCoins rewards.\n\nGet it free for your iPhone or Android phone at:\nwww.ifootballfan.com/app\n\nSign Up to the app and you will instantly get \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsignup)) FanCoins rewards."//"Check out this cool app called \"Football Fan\". I use it to earn FanCoins, participate in Football banter, post my Football stories, find fans nearby, Football news from around the world, share messages, pictures and videos.\n\nGet it free for your iPhone at:\nhttps://apple.co/2OSoN6p\n\nGet it free for your Android phone at:\nhttp://bit.ly/ff8g \n\nUse my referral code \"\(userReadUserJid)\" to earn extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins."
           let recReadUserJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                           if(recReadUserJid != nil){
                                                                                               let arrReadUserJid = recReadUserJid?.components(separatedBy: "@")
                                                                                               let userReadUserJid = arrReadUserJid?[0]
                                                                                            textToShare = textToShare + "\n\nUse my referral code \"\(userReadUserJid!)\" during Sign Up to collect extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins."
                                                                                           }
                                                                                             
           //if let myWebsite = NSURL(string: "https://www.tridecimal.com") {
               let objectsToShare = [textToShare] as [Any]
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
               
               //New Excluded Activities Code
               activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
               //
               
               activityVC.popoverPresentationController?.sourceView = self.view
               self.present(activityVC, animated: true, completion: nil)
           //}
       }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    func setupDatePicker() {
        // Sets up the "button"
        //userdob?.text = "Pick a due date"
        userdob?.textAlignment = .center
        
        // Removes the indicator of the UITextField
        userdob?.tintColor = UIColor.clear
        
        // Specifies intput type
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let date = dateFormatter.date(from: (userdob?.text)!) {
            datePicker.date = date
        }
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfileViewController.doneClick))
        doneButton.tintColor = UIColor.init(hex: "000000")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ProfileViewController.cancelClick))
        cancelButton.tintColor = UIColor.init(hex: "000000")
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Adds the toolbar to the view
        userdob?.inputView = datePicker
        userdob?.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        //dateFormatter.dateStyle = .short
        userdob?.text = dateFormatter.string(from: datePicker.date)
        userdob?.resignFirstResponder()
        appDelegate().DobTemp = currentTimeInMiliseconds()
        
        let now = Date()
        let birthday: Date = datePicker.date
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        age = Int64(ageComponents.year!)
        // print(age)
        
    }
    @IBAction func showInviteUser(sender:UIButton)
       {
          
           inviteFan()
       }
       func inviteFan()
       {
           do {
               let roomjid =  UserDefaults.standard.string(forKey: "userJID")!
               let arrdUserJid = roomjid.components(separatedBy: "@")
               let userUserJid = arrdUserJid[0]
               let myjidtrim: String = userUserJid
               
               var dictRequest = [String: AnyObject]()
               dictRequest["id"] = myjidtrim as AnyObject
               dictRequest["type"] = "profileinvite" as AnyObject
               let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
              // print(appDelegate().toName)
              // let title = appDelegate().toName
               
               let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
               
               let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
               
               let param = resultNSString as String?
               
               let inviteurl = InviteHost + "?q=" + param!
              
              
                let text =  "Connect with \(String(describing: myjidtrim)) and others on Football Fan app.\n\nWatch Football videos, create stories, banter, find fans, news and collect FanCoins rewards.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."//title + "\n\nBanter Invite shared via Football Fan App.\n\nPlease follow the link:\n"
              
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
    @objc func cancelClick() {
        userdob?.text = ""
        
        userdob?.resignFirstResponder()
        appDelegate().DobTemp = 0
    }
    func currentTimeInMiliseconds() -> Int64! {
        let currentDate = datePicker.date
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = dateFormatter.string(from: datePicker.date)
        // dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = currentDate.timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nametxtchange(){
        
        appDelegate().isvCardUpdated = true
        
        namecount?.text=String(describing: name?.text?.count ?? 0)+"/"+String(describing: name?.maxLength ?? 0)
        
    }
    @IBAction func userMobiletxtchange(){
        
        
        mobilecount?.text=String(describing: usermobile?.text?.count ?? 0)+"/"+String(describing: usermobile?.maxLength ?? 0)
        
    }
    @IBAction func userEmailtxtchange(){
          
          
          emailcount?.text=String(describing: useremail?.text?.count ?? 0)+"/"+String(describing: useremail?.maxLength ?? 0)
          
      }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ProfileViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ProfileViewController.realDelegate!;
    }
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    func notvalidatemobile(candidate: String) -> Bool {
        //New code by Ravi on 24-02-2020
        let cs = NSCharacterSet(charactersIn: MobileACCEPTABLE_CHARACTERS).inverted
        let filtered = candidate.components(separatedBy: cs).joined(separator: "")
        //usernamecount?.text =
        return candidate != filtered
    }
    @IBAction func showImagePicker () {
        
        
        /* if(!(userIBName?.text?.isEmpty)!)
         {
         UserDefaults.standard.setValue(userIBName?.text, forKey: "userStatus")
         UserDefaults.standard.synchronize()
         }*/
        
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let RemoveAction = UIAlertAction(title: "Delete Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
            self.appDelegate().profileAvtarTemp = UIImage(named:"avatar")
            self.appDelegate().isvCardUpdated = true
            self.appDelegate().isAvtarChanged = false
            self.Avtarurl = userAvtar
            //UserDefaults.standard.setValue(userAvtar, forKey: "userAvatarURL")
            //UserDefaults.standard.synchronize()
           /* self.userIBAvtar?.layer.masksToBounds = true;
            self.userIBAvtar?.clipsToBounds=true;
            self.userIBAvtar?.layer.borderWidth = 1.0
            self.userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor
            self.userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
            self.userIBAvtar?.layer.cornerRadius = 55.0*/
            self.userIBAvtar?.image = self.appDelegate().profileAvtarTemp!
            self.appDelegate().isFromSettings = true
            //self.userIBAvtar?.setImage(self.appDelegate().profileAvtarTemp!, for: UIControl.State.normal)
            self.removeimage = true
        })
        RemoveAction.setValue(UIColor.red, forKey: "titleTextColor")
        /* let deleteAction = UIAlertAction(title: "Take Image", style: .default, handler: {
         (alert: UIAlertAction!) -> Void in
         //print("Take Photo")
         //Code to show camera
         let notified: String? = UserDefaults.standard.string(forKey: "notifiedcamera")
         if notified == nil
         {
         //Show notify before get permissions
         let popController: NotifyPermissionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Notify") as! NotifyPermissionController
         
         // set the presentation style
         popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
         //popController.modalPresentationStyle = .popover
         popController.modalTransitionStyle = .crossDissolve
         self.appDelegate().isFromSettings = true
         // set up the popover presentation controller
         popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
         popController.popoverPresentationController?.delegate = self //as? UIPopoverPresentationControllerDelegate
         popController.popoverPresentationController?.sourceView = self.view // button
         //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
         popController.notifyType = "profilecamera"
         // present the popover
         self.present(popController, animated: true, completion: nil)
         }
         else
         {
         AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
         if response {
         //access granted
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
         imagePicker.sourceType = UIImagePickerController.SourceType.camera;
         imagePicker.allowsEditing = true
         self.present(imagePicker, animated: true, completion: nil)
         }
         } else {
         self.displayCameraSettingsAlert()
         }
         }
         //Code to show camera
         
         
         }
         
         
         })*/
        let saveAction = UIAlertAction(title: "Choose Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Choose Photo")
            //Code to show gallery
            self.showCustomGallery()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
        })
        if(!removeimage){
            optionMenu.addAction(RemoveAction)
        }
        // optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    func showCustomGallery() {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = true
        
        //let maskViewP = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        
        //let maskView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        
        //maskView.layer.cornerRadius = 160
        // redView.mask = maskView
        
        //maskView.backgroundColor = .white
        //maskView.alpha = 0.5
        //config.overlayView.
        //config.overlayView?.mask = maskView
        
        
      /*  let cgRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
        let myView = UIImageView()
        myView.image = UIImage(named: "cameraoverlay")
        myView.frame = cgRect
        myView.backgroundColor = UIColor.clear
        myView.isOpaque = true
        //myView.layer.cornerRadius = self.view.bounds.width/2
        //myView.layer.borderColor =  UIColor.lightGray.cgColor
        //myView.layer.borderWidth = 1
        //myView.layer.masksToBounds = true
        
        config.overlayView = myView*/
        
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        config.filters = [YPFilter(name: "Normal", coreImageFilterName: ""),
                          YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
                          YPFilter(name: "Tonal", coreImageFilterName: "CIPhotoEffectTonal"),
                          YPFilter(name: "Noir", coreImageFilterName: "CIPhotoEffectNoir"),
                          YPFilter(name: "Fade", coreImageFilterName: "CIPhotoEffectFade"),
                          YPFilter(name: "Chrome", coreImageFilterName: "CIPhotoEffectChrome"),
                          YPFilter(name: "Process", coreImageFilterName: "CIPhotoEffectProcess"),
                          YPFilter(name: "Transfer", coreImageFilterName: "CIPhotoEffectTransfer"),
                          YPFilter(name: "Instant", coreImageFilterName: "CIPhotoEffectInstant"),
                          YPFilter(name: "Sepia", coreImageFilterName: "CISepiaTone")]
        
        config.shouldSaveNewPicturesToAlbum = false
        // config.video.compression = AVAssetExportPresetHighestQuality
        config.video.compression = AVAssetExportPresetMediumQuality
        // config.showsCrop = .rectangle(ratio: 1.0)
        config.albumName = "Football Fan"
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.video.recordingTimeLimit = 300
        config.video.libraryTimeLimit = 900
        config.video.trimmerMaxDuration = 900
        // config.video.fileType = .mp4
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = true
        //config.overlayView = myOverlayView
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        config.isScrollToChangeModesEnabled = true
        config.hidesStatusBar = false
        config.wordings.cameraTitle = "Camera"
        config.wordings.videoTitle = "Video"
        config.wordings.cancel = "Cancel"
        config.wordings.albumsTitle = "Albums"
        config.wordings.trim = "Trim"
        config.wordings.cover = "Cover"
        config.wordings.crop = "Crop"
        config.wordings.done = "Done"
        config.wordings.filter = "Filter"
        config.wordings.next = "Done"
        config.colors.progressBarTrackColor = UIColor.init(hex: "E6E6E6")
        config.colors.progressBarCompletedColor = UIColor.init(hex: "FFD401")
        config.colors.trimmerHandleColor = UIColor.init(hex: "FFD401")
        config.colors.multipleItemsSelectedCircleColor = UIColor.init(hex: "FFD401")
        config.wordings.warningMaxItemsLimit = "The limit is 3 Images or Videos."
        config.icons.playImage = UIImage(named: "gallery_play")!
        config.wordings.videoDurationPopup.tooLongMessage = "Pick a video less than 15 minutes long"
                   config.wordings.videoDurationPopup.title = "Video Duration"
                   config.wordings.videoDurationPopup.tooShortMessage = "The video must be at least 3 seconds"
        //UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        UINavigationBar.appearance().barTintColor = UIColor.init(hex: "FFD401")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black ] // Title color
        UINavigationBar.appearance().tintColor = .black // Left. bar buttons
        config.colors.tintColor = .black
        //config.showsCrop = YPCropType.none
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            
            for item in items {
                switch item {
                case .photo(let photo):
                    self.removeimage = false
                    //print(photo)
                    self.appDelegate().isAvtarChanged = true
                    self.appDelegate().isvCardUpdated = true
                    var tempImg = photo.modifiedImage
                    if(tempImg == nil){
                        tempImg = photo.originalImage
                    }
                    self.appDelegate().profileAvtarTemp = tempImg
                    //self.appDelegate().profileAvtarTemp! = tempImg!
                   /* self.userIBAvtar?.layer.masksToBounds = true;
                    self.userIBAvtar?.clipsToBounds=true;
                    self.userIBAvtar?.layer.borderWidth = 1.0
                    self.userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor//UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0).cgColor
                    self.userIBAvtar?.contentMode =  UIView.ContentMode.scaleAspectFit
                    self.userIBAvtar?.layer.cornerRadius = 55.0*/
                    self.userIBAvtar?.image = tempImg
                    //self.userIBAvtar?.setImage(tempImg, for: UIControl.State.normal)
                    // UserDefaults.standard.setValue(tempImg, forKey: "tempavtar")
                    // UserDefaults.standard.synchronize()
                    break
                case .video( _):
                    //print(video)
                    
                    break
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
            
            
        }
        present(picker, animated: true, completion: nil)
        
    }
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
     
     //let newImageData = UIImageJPEGRepresentation(image, 1)
     //userIBAvtar!.image = UIImage(data: newImageData!)
     //userIBAvtar!.image = image
     appDelegate().isAvtarChanged = true
     appDelegate().profileAvtarTemp! = image!
     //userIBAvtar!.image = appDelegate().profileAvtarTemp!
     //userIBAvtar!.setImage(appDelegate().profileAvtarTemp!, for: UIControlState.normal)
     self.dismiss(animated: true, completion: nil)
     
     appDelegate().showCropAvtar()
     
     
     }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     // Local variable inserted by Swift 4.2 migrator.
     let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
     
     picker.dismiss(animated: true, completion: nil)
     if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
     appDelegate().isAvtarChanged = true
     appDelegate().profileAvtarTemp! = pickedImage
     //dismiss(animated: true, completion: nil)
     // dismiss(animated: true)
     // dismiss(animated: true, completion: nil)
     appDelegate().isvCardUpdated = true
     appDelegate().isAvtarChanged = true
     // appDelegate().showCropAvtar()
     
     }
     
     
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     picker.dismiss(animated: true, completion: nil)
     }*/
    @IBAction func cancel () {
        appDelegate().isAvtarChanged = false
        userIBName?.endEditing(true)
        //appDelegate().showMainTab()
        useremail?.endEditing(true)
        usermobile?.endEditing(true)
        name?.endEditing(true)
        userdob?.endEditing(true)
        appDelegate().StatusTemp = ""
        
        
        self.dismiss(animated: true, completion: nil)
        // self.dismiss(animated: true, completion: nil)
        //appDelegate().showMainTab()
    }
    @IBAction func prestatus () {
        // userIBName?.endEditing(true)
        //appDelegate().showMainTab()
        //self.dismiss(animated: true, completion: nil)
        self.showMystatus()
    }
    @IBAction func myteam () {
           // userIBName?.endEditing(true)
           //appDelegate().showMainTab()
           //self.dismiss(animated: true, completion: nil)
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                  let myTeamsController : MyTeamsViewController = storyBoard.instantiateViewController(withIdentifier: "MyTeams") as! MyTeamsViewController
                  appDelegate().isFromSettings = true
                  //show(myTeamsController, sender: self)
                  //show(myTeamsController, sender: self)
                 // self.present(myTeamsController, animated: true, completion: nil)
                   show(myTeamsController, sender: self)
       }
    @IBAction func showCountryList () {
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Countries")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
        
        
    }
    func checkForErrors() -> Bool
    { //let age_=calcAge(birthday: (userdob?.text)!)
        var errors = false
        // let title = "Error"
        var message = ""
        
        var nameTemp = ""
        
        if (!(name?.text!.isEmpty)!) {
            nameTemp = name!.text!
        }
        
        if (name?.text?.isEmpty)!
        {
            errors = true
            message += "Name cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.name!)
            return errors
        }
        
        if (!nameTemp.isEmpty) {
            
            let cs = NSCharacterSet(charactersIn: extraACCEPTABLE_CHARACTERS).inverted
            let filtered = nameTemp.components(separatedBy: cs).joined(separator: "")
            //usernamecount?.text =
            if(nameTemp != filtered)
            {
                errors = true
                message += "Invalid name"
                alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.name!)
                
                return errors
            }
                
        }
            
        if (useremail?.text?.isEmpty)!
        {
            errors = true
            message += "Email address cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.useremail!)
            return errors
        }
        
        if validateEmail(candidate: (useremail?.text)!) {
            // Success
            // performSegueWithIdentifier("SEGUE-ID", sender: self)
        } else {
            // Failure - Alert
            errors = true
            message += "Invalid email address"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.useremail!)
            
            return errors
        }
        
        if (usermobile?.text?.isEmpty)!
        {
            errors = true
            message += "Mobile number cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.usermobile!)
            return errors
        }
        
            if (notvalidatemobile(candidate: (usermobile?.text)!))
            {
                errors = true
                message += "Invalid mobile number"
                alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.usermobile!)
                
                return errors
            }
            
                
            
        
        
        return errors
    }
     @IBAction func FollowerAction () {
        let followerscount:Int64 = Int64(UserDefaults.standard.integer(forKey: "followerscount"))//subtypevalue.value(forKey: "followerscount") as! Int64
             
               if(followerscount>0){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myController : FollowerViewController = storyBoard.instantiateViewController(withIdentifier: "follower") as! FollowerViewController
        myController.followusername = UserDefaults.standard.string(forKey: "userJID")!
                         show(myController, sender: self)
        }
    }
    @IBAction func FollowingAction () {
        let followingcount:Int64 = Int64(UserDefaults.standard.integer(forKey: "followingcount"))//subtypevalue.value(forKey: "followingcount") as! Int64
                    // let fanstorycount:Int64 = Int64(UserDefaults.standard.integer(forKey: "fanstorycount"))//subtypevalue.value(forKey: "fanstorycount") as! Int64
          if(followingcount>0){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                               let myTeamsController : FollowingViewController = storyBoard.instantiateViewController(withIdentifier: "following") as! FollowingViewController
                               myTeamsController.followusername = UserDefaults.standard.string(forKey: "userJID")!

                                show(myTeamsController, sender: self)
        }
       }
    @IBAction func PostAction () {
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
             let registerController : MyFanUpdateViewController! = storyBoard.instantiateViewController(withIdentifier: "MyFanUpdate") as? MyFanUpdateViewController
             //present(registerController as! UIViewController, animated: true, completion: nil)
             // self.appDelegate().curRoomType = "chat"
             show(registerController, sender: self)
    }
    @IBAction func profileDone () {
        //New code to save profile image
        self.userIBName?.endEditing(true)
        self.useremail?.endEditing(true)
        self.usermobile?.endEditing(true)
        
        if ClassReachability.isConnectedToNetwork() {
            let thereWereErrors = checkForErrors()
            if !thereWereErrors
            {
                
                //self.userIBName?.endEditing(true)
                Clslogging.logdebug(State: "profileDone start")
                
                appDelegate().NameTemp = (name?.text)!
                appDelegate().EmailTemp = (useremail?.text?.lowercased())!
                var registermo =  usermobile!.text!
                if(registermo.hasPrefix("0")){
                    //registermo = registermo.replacingOccurrences(of: "0", with: "")
                    registermo = "" + String(registermo.dropFirst())
                }
                appDelegate().MobileTemp = registermo//(usermobile?.text)!
                
                appDelegate().CountrycodeTemp = (countryCode?.text)!.replace(target: "+", withString: "")
                // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                appDelegate().bioTemp = biotTextview.text
                var trimMessage: String = appDelegate().NameTemp.trimmingCharacters(in: .whitespacesAndNewlines)
                //print(trimMessage)
                trimMessage = trimMessage.condenseWhitespace()
                UserDefaults.standard.setValue(trimMessage, forKey: "userName")
                UserDefaults.standard.synchronize()
                if(appDelegate().isvCardUpdated == true)
                {
                    Clslogging.logdebug(State: "profileDone isvCardUpdated = true")
                    
                    var trimMessage: String = userIBName!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    trimMessage = trimMessage.condenseWhitespace()
                    
                    if(!(trimMessage.isEmpty))
                    {
                        UserDefaults.standard.setValue(trimMessage, forKey: "userStatus")
                        UserDefaults.standard.synchronize()
                    }
                    else
                    {
                        UserDefaults.standard.setValue("Hello! I am a Football Fan", forKey: "userStatus")
                        UserDefaults.standard.synchronize()
                    }
                    
                    
                    if appDelegate().isAvtarChanged == true
                    {
                        //This code will move to response of PHPAPI
                        sendAvatarImageToPHPAPI()
                        Clslogging.logdebug(State: "profileDone isAvtarChanged = true")
                    }
                    else{
                        
                        if (appDelegate().isUserOnline)
                        {
                            Clslogging.logdebug(State: "profileDone isAvtarChanged = false")
                           /* appDelegate().xmppvCardStorage = XMPPvCardCoreDataStorage.init()
                            //XMPPvCardCoreDataStorage.init()//init(inMemoryStore:)()
                            if(appDelegate().xmppvCardStorage != nil){
                                Clslogging.logdebug(State: "profileDone xmppvCardStorage != nil")
                                appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage!)
                                
                                appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                                
                                let vCardXML = XMLElement(name: "vCard", xmlns:"vcard-temp")
                                
                                let newvCardTemp: XMPPvCardTemp  = XMPPvCardTemp.vCardTemp(from: vCardXML)
                                //newvCardTemp.addAttribute(withName: "id", stringValue: "profileUpdated")
                                // print(UserDefaults.standard.string(forKey: "userAvatarURL") ?? 0)
                                
                                if UserDefaults.standard.string(forKey: "userAvatarURL") != nil
                                {
                                    let avatarField: XMLElement = XMLElement.element(withName: "avatar") as! XMLElement
                                    avatarField.stringValue = Avtarurl//UserDefaults.standard.string(forKey: "userAvatarURL")
                                    newvCardTemp.addChild(avatarField)
                                    
                                }
                                //New code for custom field
                                UserDefaults.standard.setValue(Avtarurl, forKey: "userAvatarURL")
                                UserDefaults.standard.synchronize()
                                let statusField: XMLElement = XMLElement.element(withName: "status") as! XMLElement
                                statusField.stringValue = UserDefaults.standard.string(forKey: "userStatus")
                                newvCardTemp.addChild(statusField)
                                //End
                                
                                //newvCardTemp.photo = imageData
                                //newvCardTemp.nickname = appDelegate().NameTemp
                                let nameField: XMLElement = XMLElement.element(withName: "name") as! XMLElement
                                nameField.stringValue = appDelegate().NameTemp
                                newvCardTemp.addChild(nameField)
                                let MobilesettingField: XMLElement = XMLElement.element(withName: "profilemobile") as! XMLElement
                                MobilesettingField.stringValue = UserDefaults.standard.string(forKey: "Mobilesetting")
                                newvCardTemp.addChild(MobilesettingField)
                                
                                let EmailsettingField: XMLElement = XMLElement.element(withName: "profileemail") as! XMLElement
                                EmailsettingField.stringValue = UserDefaults.standard.string(forKey: "Emailsetting")
                                newvCardTemp.addChild(EmailsettingField)
                                //newvCardTemp.status = "Hey there! I am using Football Fan"
                                appDelegate().xmppvCardTempModule?.updateMyvCardTemp(newvCardTemp)
                                
                            }
                            else{
                                Clslogging.logdebug(State: "profileDone xmppvCardStorage init")
                                appDelegate().xmppvCardStorage2 = XMPPvCardCoreDataStorage.init()
                                if(appDelegate().xmppvCardStorage2 != nil){
                                    appDelegate().xmppvCardTempModule = XMPPvCardTempModule.init(vCardStorage: appDelegate().xmppvCardStorage2!)
                                    
                                    appDelegate().xmppvCardTempModule?.activate(appDelegate().xmppStream!)
                                    
                                    let vCardXML = XMLElement(name: "vCard", xmlns:"vcard-temp")
                                    
                                    let newvCardTemp: XMPPvCardTemp  = XMPPvCardTemp.vCardTemp(from: vCardXML)
                                    //newvCardTemp.addAttribute(withName: "id", stringValue: "profileUpdated")
                                    // print(UserDefaults.standard.string(forKey: "userAvatarURL") ?? 0)
                                    if UserDefaults.standard.string(forKey: "userAvatarURL") != nil
                                    {
                                        let avatarField: XMLElement = XMLElement.element(withName: "avatar") as! XMLElement
                                        avatarField.stringValue = Avtarurl//UserDefaults.standard.string(forKey: "userAvatarURL")
                                        newvCardTemp.addChild(avatarField)
                                        
                                    }
                                    //New code for custom field
                                    UserDefaults.standard.setValue(Avtarurl, forKey: "userAvatarURL")
                                    UserDefaults.standard.synchronize()
                                    let statusField: XMLElement = XMLElement.element(withName: "status") as! XMLElement
                                    statusField.stringValue = UserDefaults.standard.string(forKey: "userStatus")
                                    newvCardTemp.addChild(statusField)
                                    //End
                                    
                                    //newvCardTemp.photo = imageData
                                    //newvCardTemp.nickname = appDelegate().NameTemp
                                    let nameField: XMLElement = XMLElement.element(withName: "name") as! XMLElement
                                    nameField.stringValue = appDelegate().NameTemp
                                    newvCardTemp.addChild(nameField)
                                    let MobilesettingField: XMLElement = XMLElement.element(withName: "profilemobile") as! XMLElement
                                    MobilesettingField.stringValue = UserDefaults.standard.string(forKey: "Mobilesetting")
                                    newvCardTemp.addChild(MobilesettingField)
                                    
                                    let EmailsettingField: XMLElement = XMLElement.element(withName: "profileemail") as! XMLElement
                                    EmailsettingField.stringValue = UserDefaults.standard.string(forKey: "Emailsetting")
                                    newvCardTemp.addChild(EmailsettingField)
                                    //newvCardTemp.status = "Hey there! I am using Football Fan"
                                    appDelegate().xmppvCardTempModule?.updateMyvCardTemp(newvCardTemp)
                                    
                                }
                            }*/
                            let urlAvtar: String =  UserDefaults.standard.string(forKey: "userAvatarURL")!
                            appDelegate().loadImageFromUrl(url: urlAvtar, fileName: "userAvatar")
                           // let deviceToken: String? = UserDefaults.standard.string(forKey: "DeviceToken")
                            Clslogging.logdebug(State: "profileDone editprofile Start")
                          
                        }
                        else{
                            //alertWithTitle(title: nil, message: "Connecting...", ViewController: self, toFocus:self.name!)
                            UserDefaults.standard.setValue(false, forKey: "isvcardupdated")
                            UserDefaults.standard.synchronize()
                            Clslogging.logdebug(State: "profileDone isUserOnline = false")
                        }
                        appDelegate().Calleditprofile()
                    }
                    //appDelegate().saveProfileImage(appDelegate().profileAvtarTemp!)
                }
                else
                {
                    Clslogging.logdebug(State: "profileDone isvCardUpdated = false")
                    appDelegate().isAvtarChanged = false
                    appDelegate().isvCardUpdated = false
                    Clslogging.logdebug(State: "profileDone editprofile Start isvCardUpdated = false")
                    appDelegate().Calleditprofile()
                    //self.dismiss(animated: true, completion: nil)
                    //self.dismiss(animated: true, completion: nil)
                }
                Clslogging.logdebug(State: "profileDone End")
            }
            
            
        } else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self, toFocus:self.name!)
            
        }
    }
    func getFilePath(url : String) -> String
      {
          let arrReadselVideoPath = url.components(separatedBy: "/")
          let imageId = arrReadselVideoPath.last
          let arrReadimageId = imageId?.components(separatedBy: ".")
          //let fileManager = FileManager.default
          let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".png")
          return paths
      }
      
    func sendAvatarImageToPHPAPI()
    {
        let login: String? = UserDefaults.standard.string(forKey: "registerusername")
        
        let boundary = appDelegate().generateBoundaryString()
        var request = URLRequest(url: URL(string: MediaAPI)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var reqParams = [String: String]()
        reqParams["cmd"] = "avatar"
        reqParams["jid"] = login
        reqParams["key"] = "kXfqS9wUug6gVKDB"
        // self.dismiss(animated: false, completion: nil)
        // self.dismiss(animated: true, completion: nil)
        request.httpBody = appDelegate().createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                if String(data: data, encoding: String.Encoding.utf8) != nil {
                    //print(stringData) //JSONSerialization
                    
                    
                    
                    //print(time)
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                        
                        let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                        
                        if(isSuccess)
                        {
                            let avatarLink = (jsonData?.value(forKey: "link") as? String)!
                            self.appDelegate().saveProfileImageURL(self.appDelegate().profileAvtarTemp!, strAvatarURL: avatarLink)
                            
                        }
                        else
                        {
                            //Show Error
                            print("Profile Image Fail.")
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
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            userIBName?.endEditing(true)
            
            
            useremail?.endEditing(true)
            usermobile?.endEditing(true)
            name?.endEditing(true)
            userdob?.endEditing(true)
            biotTextview.endEditing(true)
            //userpassword?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    func showMystatus()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : PreDefindStatusViewController = storyBoard.instantiateViewController(withIdentifier: "PreStatus") as! PreDefindStatusViewController
        appDelegate().isFromSettings = true
        //show(myTeamsController, sender: self)
        self.present(myTeamsController, animated: true, completion: nil)
    }
    @IBAction func userstatustxtchange(){
        
        if userIBName?.text != UserDefaults.standard.string(forKey: "userStatus")
        {
            // appDelegate().StatusTemp = (UserStaus?.text)!
            appDelegate().isvCardUpdated = true
            
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
        //self.storyTableView?.allowsSelection = false
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
        //self.storyTableView?.allowsSelection = true
    }
    
    
    
    @objc func keyboardDidChangeFrame(notification:NSNotification){
        if(Tagtextfield > 1){
            if(isKeyboardHiding == false)
            {
                adjustingHeight(show: true, notification: notification)
            }
            
        }
        
        //isKeyboardHiding = false
        //self.scrollToBottom()
    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        let userInfo = notification.userInfo!
        //print(userInfo)
        self.keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        if(isKeyboardHiding == true)
        {
            let changeInHeight = 10.0
            
            
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = CGFloat(changeInHeight)
                
            })
        }
        else
        {
            //let changeInHeight = (maximumY - self.keyboardFrame.height) + 110 //* (show ? 1 : -1)
            var changeInHeight: CGFloat = 10.0
            /*if(Tagtextfield <= 5)
             {
             changeInHeight = (maximumY - self.keyboardFrame.height) + 70
             }
             else
             {
             changeInHeight = (maximumY - self.keyboardFrame.height) + 50
             }*/
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            
            if(screenHeight <= 480)
            {
                if(Tagtextfield == 5)
                {
                    changeInHeight = (maximumY - self.keyboardFrame.height) + 130
                }
                else
                {
                    changeInHeight = (maximumY - self.keyboardFrame.height) + 90
                }
                
            }
            else
            {
                if(Tagtextfield == 6)
                               {
                                   changeInHeight = (maximumY - self.keyboardFrame.height) + 50
                               }
                               else
                               {
                                   changeInHeight = (maximumY - self.keyboardFrame.height) + 30
                               }
                print(maximumY)
            }
            //changeInHeight = (maximumY - self.keyboardFrame.height) + 110
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = -changeInHeight
                
            })
        }
        
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("TextField did begin editing method called")
        Tagtextfield=textField.tag
        //print(textField.superview?.frame.origin.y ?? "")
        maximumY = (textField.superview?.frame.origin.y)!
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        /* switch (textField.tag) {
         case 1:
         if((textField.text!).characters.count>=6){
         self.appDelegate().callPHPFFAPI("checkusername", username:(userJID?.text)!)
         }
         break
         case 2:
         
         break
         default: break
         
         }*/
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // print("TextField should begin editing method called")
        if(textField.tag == 1){
            
        }
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // print("TextField should clear method called")
        return true;
    }
    private func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        //print("TextField should snd editing method called")
        
        return true;
    }
    func displayPhotoSettingsAlert() {
        let cantAddContactAlert = UIAlertController(title: "",
                                                    message: "Please allow access for Football Fan to your media library.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        
                                                        let url = NSURL(string: UIApplication.openSettingsURLString)
                                                        UIApplication.shared.openURL(url! as URL)
                                                        
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    func displayCameraSettingsAlert() {
        let cantAddContactAlert = UIAlertController(title: "",
                                                    message: "Please allow access for Football Fan to your camera and media library.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        
                                                        let url = NSURL(string: UIApplication.openSettingsURLString)
                                                        UIApplication.shared.openURL(url! as URL)
                                                        
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(Tagtextfield==2){
            let cs = NSCharacterSet(charactersIn: extraACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            //usernamecount?.text =
            return (string == filtered)
        }
        else if(Tagtextfield == 3){
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
            
        else{
            let cs = NSCharacterSet(charactersIn: extraACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        //print("While entering the characters this method gets called")
      //  return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
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
        biocount?.text=String(describing: biotTextview?.text?.count ?? 0)+"/"+String(describing: 1000)
        
    }
    func textViewShouldReturn(_ textField: UITextView) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    func textViewShouldBeginEditing(_ textField: UITextView) -> Bool {
           // print("TextField should begin editing method called")
           if(textField.tag == 1){
               
           }
           return true;
       }
    func textViewDidBeginEditing(_ textView: UITextView) {
      
           //print("TextField did begin editing method called")
           Tagtextfield=textView.tag
           //print(textField.superview?.frame.origin.y ?? "")
        maximumY = (biocount?.superview?.frame.origin.y)! + 30//(textView.superview?.frame.origin.y)!
       }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
