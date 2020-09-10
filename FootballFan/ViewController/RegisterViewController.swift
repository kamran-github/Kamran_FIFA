//
//  ViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 19/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import CoreTelephony
import MessageUI
import MapKit
import Foundation
let UserNameACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-."
//New code by Ravi on 24-02-2020
let MobileACCEPTABLE_CHARACTERS = "0123456789"
let extraACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@."
let Password_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@.!#$%^&*()+=<>?:;{}[]"
let characterset = CharacterSet(charactersIn:
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-."
       )
class RegisterViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate,UIPopoverPresentationControllerDelegate, MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var userJID: UITextField?
    @IBOutlet weak var userpassword: UITextField?
    @IBOutlet weak var cuserpassword: UITextField?
    @IBOutlet weak var useremail: UITextField?
    @IBOutlet weak var name: UITextField?
    @IBOutlet weak var usernamelabel: UILabel?
    @IBOutlet weak var usermobile: UITextField?
    @IBOutlet weak var userdob: UITextField?
     @IBOutlet weak var userRefralCode: UITextField?
    @IBOutlet weak var countryCode: UILabel?
    @IBOutlet weak var notlabel: UILabel?
    @IBOutlet weak var btnCountryName: UIButton?
    @IBOutlet weak var countryImage: UIImageView?
     @IBOutlet weak var usernamecount: UILabel?
    @IBOutlet weak var userPasswordcount: UILabel?
    @IBOutlet weak var namecount: UILabel?
     @IBOutlet weak var mobilecount: UILabel?
    @IBOutlet weak var Refrralnote: UILabel?
     @IBOutlet weak var Signupnote: UILabel?
    //@IBOutlet weak var userEmailcount: UILabel?
   // var activityIndicator: UIActivityIndicatorView?
    var currentLocation: CLLocation!
    var datePicker = UIDatePicker()
    @IBOutlet weak var counterButton: UIButton!
    var locationManager: CLLocationManager!
    var count = 20
    var timer: Timer!
    var success: Bool!
    var emailsuccess: Bool = true
    var age: Int64 = 0
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    var Tagtextfield = 1
    var maximumY: CGFloat=0.0
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var Childview: UIView?
    @IBOutlet weak var btnShow: UIButton?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set DoRegistration notification
        //let notificationName = Notification.Name("NewUserRegistration")
        
        // Register to receive notification
        //NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.DoRegistration), name: notificationName, object: nil)
        userJID?.delegate = self
        userdob?.delegate=self
        userpassword?.delegate=self
        useremail?.delegate=self
        name?.delegate=self
        usermobile?.delegate=self
        userRefralCode?.delegate=self
        currentLocation = nil
        userJID?.autocorrectionType = .no
        // appDelegate().profileAvtarTemp = UIImage(named:"avatar")
        //Temp Hide for 1st release
        UserDefaults.standard.setValue("", forKey: "userstate")
        UserDefaults.standard.setValue("", forKey: "usercountry")
        UserDefaults.standard.setValue("", forKey: "userecity")
        UserDefaults.standard.setValue(0.0, forKey: "latitude")
        UserDefaults.standard.setValue(0.0, forKey: "longitude")
        UserDefaults.standard.synchronize()
        /*locationManager = CLLocationManager()
        
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }*/
        
        //Save SIM details
        /*UserDefaults.standard.setValue(nil, forKey: "isShowProfile")
         UserDefaults.standard.setValue(nil, forKey: "isRegistering")
         UserDefaults.standard.setValue(nil, forKey: "isLoggedin")
         UserDefaults.standard.setValue(UserDefaults.standard.string(forKey: "registerJID"), forKey: "userJID")
         UserDefaults.standard.setValue(nil, forKey: "registerJID")
         UserDefaults.standard.synchronize()*/
        
        
       // print("Screen width = \(screenWidth), screen height = \(screenHeight)")
        //if(sc@objc @objc reenHeight <= 568)
        //{
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
       // }
        let notificationName = Notification.Name("registerUserTemp")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.registerUserTemp(notification:)), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("showSMSOptions")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.showSMSOptions(notification:)), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("showVerifyOTPScreen")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.showVerifyOTPScreen(notification:)), name: notificationName3, object: nil)
        
        let notificationName4 = Notification.Name("verificationSuccess")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.verificationSuccess(notification:)), name: notificationName4, object: nil)
        
        let notificationName5 = Notification.Name("usernameSuccess")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.usernameSuccess(notification:)), name: notificationName5, object: nil)
        let notificationName6 = Notification.Name("useremailSuccess")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.useremailSuccess(notification:)), name: notificationName6, object: nil)
        
        //setupDatePicker();
        notlabel?.text = "By signing up you agree to our \n Terms & Conditions, Privacy Policy and EULA"
        let text = (notlabel?.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: range1)
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor , value: UIColor.init(hex: "197DF6"), range: range2)
        let range3 = (text as NSString).range(of: "EULA")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: range3)
        notlabel?.attributedText = underlineAttriString
        
        
        notlabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapLabel(_:))))
        notlabel?.isUserInteractionEnabled = true
        
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
        countryCode?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.showCountryList)))
        countryCode?.isUserInteractionEnabled = true
        UserDefaults.standard.setValue(0, forKey: "userdob")
        UserDefaults.standard.synchronize()
        Refrralnote?.text = "Sign Up with a referral code to collect extra \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcreferral)) FanCoins rewards. Learn more."
        let text1 = (Refrralnote?.text)!
        let AttriString = NSMutableAttributedString(string: text1)
        let range = (text1 as NSString).range(of: "Learn more.")
        AttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: range)
        
        Refrralnote?.attributedText = AttriString
        
        
        Refrralnote?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapRLabel(_:))))
        Refrralnote?.isUserInteractionEnabled = true
        Signupnote?.text = "Sign Up and collect \(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsignup)) FanCoins Rewards"
        let text2 = (Signupnote?.text)!
        let AttriString1 = NSMutableAttributedString(string: text2)
        let ranges = (text2 as NSString).range(of: "Learn more")
        AttriString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: ranges)
        
        Signupnote?.attributedText = AttriString1
        
        
        Signupnote?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tapRLabel(_:))))
        Signupnote?.isUserInteractionEnabled = true
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dict: NSString? = "{\"af\": {\"code\": \"+93\",\"name\": \"Afghanistan\",\"flag\": \"flag_afghanistan.png\"},\"al\": {\"code\": \"+355\",\"name\": \"Albania\",\"flag\": \"flag_albania.png\"},\"dz\": {\"code\": \"+213\",\"name\": \"Algeria\",\"flag\": \"flag_algeria.png\"},\"ad\": {\"code\": \"+376\",\"name\": \"Andorra\",\"flag\": \"flag_andorra.png\"},\"ao\": {\"code\": \"+244\",\"name\": \"Angola\",\"flag\": \"flag_angola.png\"},\"aq\": {\"code\": \"+672\",\"name\": \"Antarctica\",\"flag\": \"flag_antarctica.png\"},\"ar\": {\"code\": \"+54\",\"name\": \"Argentina\",\"flag\": \"flag_argentina.png\"},\"am\": {\"code\": \"+374\",\"name\": \"Armenia\",\"flag\": \"flag_armenia.png\"},\"aw\": {\"code\": \"+297\",\"name\": \"Aruba\",\"flag\": \"flag_aruba.png\"},\"au\": {\"code\": \"+61\",\"name\": \"Australia\",\"flag\": \"flag_australia.png\"},\"at\": {\"code\": \"+43\",\"name\": \"Austria\",\"flag\": \"flag_austria.png\"},\"az\": {\"code\": \"+994\",\"name\": \"Azerbaijan\",\"flag\": \"flag_azerbaijan.png\"},\"bh\": {\"code\": \"+973\",\"name\": \"Bahrain\",\"flag\": \"flag_bahrain.png\"},\"bd\": {\"code\": \"+880\",\"name\": \"Bangladesh\",\"flag\": \"flag_bangladesh.png\"},\"by\": {\"code\": \"+375\",\"name\": \"Belarus\",\"flag\": \"flag_belarus.png\"},\"be\": {\"code\": \"+32\",\"name\": \"Belgium\",\"flag\": \"flag_belgium.png\"},\"bz\": {\"code\": \"+501\",\"name\": \"Belize\",\"flag\": \"flag_belize.png\"},\"bj\": {\"code\": \"+229\",\"name\": \"Benin\",\"flag\": \"flag_benin.png\"},\"bt\": {\"code\": \"+975\",\"name\": \"Bhutan\",\"flag\": \"flag_bhutan.png\"},\"bo\": {\"code\": \"+591\",\"name\": \"Bolivia, Plurinational State Of\",\"flag\": \"flag_bolivia.png\"},\"ba\": {\"code\": \"+387\",\"name\": \"Bosnia And Herzegovina\",\"flag\": \"flag_bosnia.png\"},\"bw\": {\"code\": \"+267\",\"name\": \"Botswana\",\"flag\": \"flag_botswana.png\"},\"br\": {\"code\": \"+55\",\"name\": \"Brazil\",\"flag\": \"flag_brazil.png\"},\"bn\": {\"code\": \"+673\",\"name\": \"Brunei Darussalam\",\"flag\": \"flag_brunei.png\"},\"bg\": {\"code\": \"+359\",\"name\": \"Bulgaria\",\"flag\": \"flag_bulgaria.png\"},\"bf\": {\"code\": \"+226\",\"name\": \"Burkina Faso\",\"flag\": \"flag_burkina_faso.png\"},\"mm\": {\"code\": \"+95\",\"name\": \"Myanmar\",\"flag\": \"flag_myanmar.png\"},\"bi\": {\"code\": \"+257\",\"name\": \"Burundi\",\"flag\": \"flag_burundi.png\"},\"kh\": {\"code\": \"+855\",\"name\": \"Cambodia\",\"flag\": \"flag_cambodia.png\"},\"cm\": {\"code\": \"+237\",\"name\": \"Cameroon\",\"flag\": \"flag_cameroon.png\"},\"ca\": {\"code\": \"+1\",\"name\": \"Canada\",\"flag\": \"flag_canada.png\"},\"cv\": {\"code\": \"+238\",\"name\": \"Cape Verde\",\"flag\": \"flag_cape_verde.png\"},\"cf\": {\"code\": \"+236\",\"name\": \"Central African Republic\",\"flag\": \"flag_central_african_republic.png\"},\"td\": {\"code\": \"+235\",\"name\": \"Chad\",\"flag\": \"flag_chad.png\"},\"cl\": {\"code\": \"+56\",\"name\": \"Chile\",\"flag\": \"flag_chile.png\"},\"cn\": {\"code\": \"+86\",\"name\": \"China\",\"flag\": \"flag_china.png\"},\"cx\": {\"code\": \"+61\",\"name\": \"Christmas Island\",\"flag\": \"flag_christmas_island.png\"},\"cc\": {\"code\": \"+61\",\"name\": \"Cocos (keeling) Islands\",\"flag\": \"flag_cocos.png\"},\"co\": {\"code\": \"+57\",\"name\": \"Colombia\",\"flag\": \"flag_colombia.png\"},\"km\": {\"code\": \"+269\",\"name\": \"Comoros\",\"flag\": \"flag_comoros.png\"},\"cg\": {\"code\": \"+242\",\"name\": \"Congo\",\"flag\": \"flag_republic_of_the_congo.png\"},\"cd\": {\"code\": \"+243\",\"name\": \"Congo, The Democratic Republic Of The\",\"flag\": \"flag_democratic_republic_of_the_congo.png\"},\"ck\": {\"code\": \"+682\",\"name\": \"Cook Islands\",\"flag\": \"flag_cook_islands.png\"},\"cr\": {\"code\": \"+506\",\"name\": \"Costa Rica\",\"flag\": \"flag_costa_rica.png\"},\"hr\": {\"code\": \"+385\",\"name\": \"Croatia\",\"flag\": \"flag_croatia.png\"},\"cu\": {\"code\": \"+53\",\"name\": \"Cuba\",\"flag\": \"flag_cuba.png\"},\"cy\": {\"code\": \"+357\",\"name\": \"Cyprus\",\"flag\": \"flag_cyprus.png\"},\"cz\": {\"code\": \"+420\",\"name\": \"Czech Republic\",\"flag\": \"flag_czech_republic.png\"},\"dk\": {\"code\": \"+45\",\"name\": \"Denmark\",\"flag\": \"flag_denmark.png\"},\"dj\": {\"code\": \"+253\",\"name\": \"Djibouti\",\"flag\": \"flag_djibouti.png\"},\"tl\": {\"code\": \"+670\",\"name\": \"Timor-leste\",\"flag\": \"flag_timor_leste.png\"},\"ec\": {\"code\": \"+593\",\"name\": \"Ecuador\",\"flag\": \"flag_ecuador.png\"},\"eg\": {\"code\": \"+20\",\"name\": \"Egypt\",\"flag\": \"flag_egypt.png\"},\"sv\": {\"code\": \"+503\",\"name\": \"El Salvador\",\"flag\": \"flag_el_salvador.png\"},\"gq\": {\"code\": \"+240\",\"name\": \"Equatorial Guinea\",\"flag\": \"flag_equatorial_guinea.png\"},\"er\": {\"code\": \"+291\",\"name\": \"Eritrea\",\"flag\": \"flag_eritrea.png\"},\"ee\": {\"code\": \"+372\",\"name\": \"Estonia\",\"flag\": \"flag_estonia.png\"},\"et\": {\"code\": \"+251\",\"name\": \"Ethiopia\",\"flag\": \"flag_ethiopia.png\"},\"fk\": {\"code\": \"+500\",\"name\": \"Falkland Islands (malvinas)\",\"flag\": \"flag_falkland_islands.png\"},\"fo\": {\"code\": \"+298\",\"name\": \"Faroe Islands\",\"flag\": \"flag_faroe_islands.png\"},\"fj\": {\"code\": \"+679\",\"name\": \"Fiji\",\"flag\": \"flag_fiji.png\"},\"fi\": {\"code\": \"+358\",\"name\": \"Finland\",\"flag\": \"flag_finland.png\"},\"fr\": {\"code\": \"+33\",\"name\": \"France\",\"flag\": \"flag_france.png\"},\"pf\": {\"code\": \"+689\",\"name\": \"French Polynesia\",\"flag\": \"flag_french_polynesia.png\"},\"ga\": {\"code\": \"+241\",\"name\": \"Gabon\",\"flag\": \"flag_gabon.png\"},\"gm\": {\"code\": \"+220\",\"name\": \"Gambia\",\"flag\": \"flag_gambia.png\"},\"ge\": {\"code\": \"+995\",\"name\": \"Georgia\",\"flag\": \"flag_georgia.png\"},\"de\": {\"code\": \"+49\",\"name\": \"Germany\",\"flag\": \"flag_germany.png\"},\"gh\": {\"code\": \"+233\",\"name\": \"Ghana\",\"flag\": \"flag_ghana.png\"},\"gi\": {\"code\": \"+350\",\"name\": \"Gibraltar\",\"flag\": \"flag_gibraltar.png\"},\"gr\": {\"code\": \"+30\",\"name\": \"Greece\",\"flag\": \"flag_greece.png\"},\"gl\": {\"code\": \"+299\",\"name\": \"Greenland\",\"flag\": \"flag_greenland.png\"},\"gt\": {\"code\": \"+502\",\"name\": \"Guatemala\",\"flag\": \"flag_guatemala.png\"},\"gn\": {\"code\": \"+224\",\"name\": \"Guinea\",\"flag\": \"flag_guinea.png\"},\"gw\": {\"code\": \"+245\",\"name\": \"Guinea-bissau\",\"flag\": \"flag_guinea_bissau.png\"},\"gy\": {\"code\": \"+592\",\"name\": \"Guyana\",\"flag\": \"flag_guyana.png\"},\"ht\": {\"code\": \"+509\",\"name\": \"Haiti\",\"flag\": \"flag_haiti.png\"},\"hn\": {\"code\": \"+504\",\"name\": \"Honduras\",\"flag\": \"flag_honduras.png\"},\"hk\": {\"code\": \"+852\",\"name\": \"Hong Kong\",\"flag\": \"flag_hong_kong.png\"},\"hu\": {\"code\": \"+36\",\"name\": \"Hungary\",\"flag\": \"flag_hungary.png\"},\"in\": {\"code\": \"+91\",\"name\": \"India\",\"flag\": \"flag_india.png\"},\"id\": {\"code\": \"+62\",\"name\": \"Indonesia\",\"flag\": \"flag_indonesia.png\"},\"ir\": {\"code\": \"+98\",\"name\": \"Iran, Islamic Republic Of\",\"flag\": \"flag_iran.png\"},\"iq\": {\"code\": \"+964\",\"name\": \"Iraq\",\"flag\": \"flag_iraq.png\"},\"ie\": {\"code\": \"+353\",\"name\": \"Ireland\",\"flag\": \"flag_ireland.png\"},\"il\": {\"code\": \"+972\",\"name\": \"Israel\",\"flag\": \"flag_israel.png\"},\"it\": {\"code\": \"+39\",\"name\": \"Italy\",\"flag\": \"flag_italy.png\"},\"ci\": {\"code\": \"+225\",\"name\": \"CÙte D\'ivoire\",\"flag\": \"flag_cote_divoire.png\"},\"jp\": {\"code\": \"+81\",\"name\": \"Japan\",\"flag\": \"flag_japan.png\"},\"jo\": {\"code\": \"+962\",\"name\": \"Jordan\",\"flag\": \"flag_jordan.png\"},\"kz\": {\"code\": \"+7\",\"name\": \"Kazakhstan\",\"flag\": \"flag_kazakhstan.png\"},\"ke\": {\"code\": \"+254\",\"name\": \"Kenya\",\"flag\": \"flag_kenya.png\"},\"ki\": {\"code\": \"+686\",\"name\": \"Kiribati\",\"flag\": \"flag_kiribati.png\"},\"kw\": {\"code\": \"+965\",\"name\": \"Kuwait\",\"flag\": \"flag_kuwait.png\"},\"kg\": {\"code\": \"+996\",\"name\": \"Kyrgyzstan\",\"flag\": \"flag_kyrgyzstan.png\"},\"la\": {\"code\": \"+856\",\"name\": \"Lao People\'s Democratic Republic\",\"flag\": \"flag_laos.png\"},\"lv\": {\"code\": \"+371\",\"name\": \"Latvia\",\"flag\": \"flag_latvia.png\"},\"lb\": {\"code\": \"+961\",\"name\": \"Lebanon\",\"flag\": \"flag_lebanon.png\"},\"ls\": {\"code\": \"+266\",\"name\": \"Lesotho\",\"flag\": \"flag_lesotho.png\"},\"lr\": {\"code\": \"+231\",\"name\": \"Liberia\",\"flag\": \"flag_liberia.png\"},\"ly\": {\"code\": \"+218\",\"name\": \"Libya\",\"flag\": \"flag_libya.png\"},\"li\": {\"code\": \"+423\",\"name\": \"Liechtenstein\",\"flag\": \"flag_liechtenstein.png\"},\"lt\": {\"code\": \"+370\",\"name\": \"Lithuania\",\"flag\": \"flag_lithuania.png\"},\"lu\": {\"code\": \"+352\",\"name\": \"Luxembourg\",\"flag\": \"flag_luxembourg.png\"},\"mo\": {\"code\": \"+853\",\"name\": \"Macao\",\"flag\": \"flag_macao.png\"},\"mk\": {\"code\": \"+389\",\"name\": \"Macedonia, The Former Yugoslav Republic Of\",\"flag\": \"flag_macedonia.png\"},\"mg\": {\"code\": \"+261\",\"name\": \"Madagascar\",\"flag\": \"flag_madagascar.png\"},\"mw\": {\"code\": \"+265\",\"name\": \"Malawi\",\"flag\": \"flag_malawi.png\"},\"my\": {\"code\": \"+60\",\"name\": \"Malaysia\",\"flag\": \"flag_malaysia.png\"},\"mv\": {\"code\": \"+960\",\"name\": \"Maldives\",\"flag\": \"flag_maldives.png\"},\"ml\": {\"code\": \"+223\",\"name\": \"Mali\",\"flag\": \"flag_mali.png\"},\"mt\": {\"code\": \"+356\",\"name\": \"Malta\",\"flag\": \"flag_malta.png\"},\"mh\": {\"code\": \"+692\",\"name\": \"Marshall Islands\",\"flag\": \"flag_marshall_islands.png\"},\"mr\": {\"code\": \"+222\",\"name\": \"Mauritania\",\"flag\": \"flag_mauritania.png\"},\"mu\": {\"code\": \"+230\",\"name\": \"Mauritius\",\"flag\": \"flag_mauritius.png\"},\"yt\": {\"code\": \"+262\",\"name\": \"Mayotte\",\"flag\": \"flag_martinique.png\"},\"mx\": {\"code\": \"+52\",\"name\": \"Mexico\",\"flag\": \"flag_mexico.png\"},\"fm\": {\"code\": \"+691\",\"name\": \"Micronesia, Federated States Of\",\"flag\": \"flag_micronesia.png\"},\"md\": {\"code\": \"+373\",\"name\": \"Moldova, Republic Of\",\"flag\": \"flag_moldova.png\"},\"mc\": {\"code\": \"+377\",\"name\": \"Monaco\",\"flag\": \"flag_monaco.png\"},\"mn\": {\"code\": \"+976\",\"name\": \"Mongolia\",\"flag\": \"flag_mongolia.png\"},\"me\": {\"code\": \"+382\",\"name\": \"Montenegro\",\"flag\": \"flag_of_montenegro.png\"},\"ma\": {\"code\": \"+212\",\"name\": \"Morocco\",\"flag\": \"flag_morocco.png\"},\"mz\": {\"code\": \"+258\",\"name\": \"Mozambique\",\"flag\": \"flag_mozambique.png\"},\"na\": {\"code\": \"+264\",\"name\": \"Namibia\",\"flag\": \"flag_namibia.png\"},\"nr\": {\"code\": \"+674\",\"name\": \"Nauru\",\"flag\": \"flag_nauru.png\"},\"np\": {\"code\": \"+977\",\"name\": \"Nepal\",\"flag\": \"flag_nepal.png\"},\"nl\": {\"code\": \"+31\",\"name\": \"Netherlands\",\"flag\": \"flag_netherlands.png\"},\"nc\": {\"code\": \"+687\",\"name\": \"New Caledonia\",\"flag\": \"flag_new_caledonia.png\"},\"nz\": {\"code\": \"+64\",\"name\": \"New Zealand\",\"flag\": \"flag_new_zealand.png\"},\"ni\": {\"code\": \"+505\",\"name\": \"Nicaragua\",\"flag\": \"flag_nicaragua.png\"},\"ne\": {\"code\": \"+227\",\"name\": \"Niger\",\"flag\": \"flag_niger.png\"},\"ng\": {\"code\": \"+234\",\"name\": \"Nigeria\",\"flag\": \"flag_nigeria.png\"},\"nu\": {\"code\": \"+683\",\"name\": \"Niue\",\"flag\": \"flag_niue.png\"},\"kp\": {\"code\": \"+850\",\"name\": \"Korea, Democratic People\'s Republic Of\",\"flag\": \"flag_north_korea.png\"},\"no\": {\"code\": \"+47\",\"name\": \"Norway\",\"flag\": \"flag_norway.png\"},\"om\": {\"code\": \"+968\",\"name\": \"Oman\",\"flag\": \"flag_oman.png\"},\"pk\": {\"code\": \"+92\",\"name\": \"Pakistan\",\"flag\": \"flag_pakistan.png\"},\"pw\": {\"code\": \"+680\",\"name\": \"Palau\",\"flag\": \"flag_palau.png\"},\"pa\": {\"code\": \"+507\",\"name\": \"Panama\",\"flag\": \"flag_panama.png\"},\"pg\": {\"code\": \"+675\",\"name\": \"Papua New Guinea\",\"flag\": \"flag_papua_new_guinea.png\"},\"py\": {\"code\": \"+595\",\"name\": \"Paraguay\",\"flag\": \"flag_paraguay.png\"},\"pe\": {\"code\": \"+51\",\"name\": \"Peru\",\"flag\": \"flag_peru.png\"},\"ph\": {\"code\": \"+63\",\"name\": \"Philippines\",\"flag\": \"flag_philippines.png\"},\"pn\": {\"code\": \"+870\",\"name\": \"Pitcairn\",\"flag\": \"flag_pitcairn_islands.png\"},\"pl\": {\"code\": \"+48\",\"name\": \"Poland\",\"flag\": \"flag_poland.png\"},\"pt\": {\"code\": \"+351\",\"name\": \"Portugal\",\"flag\": \"flag_portugal.png\"},\"pr\": {\"code\": \"+1\",\"name\": \"Puerto Rico\",\"flag\": \"flag_puerto_rico.png\"},\"qa\": {\"code\": \"+974\",\"name\": \"Qatar\",\"flag\": \"flag_qatar.png\"},\"ro\": {\"code\": \"+40\",\"name\": \"Romania\",\"flag\": \"flag_romania.png\"},\"ru\": {\"code\": \"+7\",\"name\": \"Russian Federation\",\"flag\": \"flag_russian_federation.png\"},\"rw\": {\"code\": \"+250\",\"name\": \"Rwanda\",\"flag\": \"flag_rwanda.png\"},\"bl\": {\"code\": \"+590\",\"name\": \"Saint BarthÈlemy\",\"flag\": \"flag_saint_barthelemy.png\"},\"ws\": {\"code\": \"+685\",\"name\": \"Samoa\",\"flag\": \"flag_samoa.png\"},\"sm\": {\"code\": \"+378\",\"name\": \"San Marino\",\"flag\": \"flag_san_marino.png\"},\"st\": {\"code\": \"+239\",\"name\": \"Sao Tome And Principe\",\"flag\": \"flag_sao_tome_and_principe.png\"},\"sa\": {\"code\": \"+966\",\"name\": \"Saudi Arabia\",\"flag\": \"flag_saudi_arabia.png\"},\"sn\": {\"code\": \"+221\",\"name\": \"Senegal\",\"flag\": \"flag_senegal.png\"},\"rs\": {\"code\": \"+381\",\"name\": \"Serbia\",\"flag\": \"flag_serbia.png\"},\"sc\": {\"code\": \"+248\",\"name\": \"Seychelles\",\"flag\": \"flag_seychelles.png\"},\"sl\": {\"code\": \"+232\",\"name\": \"Sierra Leone\",\"flag\": \"flag_sierra_leone.png\"},\"sg\": {\"code\": \"+65\",\"name\": \"Singapore\",\"flag\": \"flag_singapore.png\"},\"sk\": {\"code\": \"+421\",\"name\": \"Slovakia\",\"flag\": \"flag_slovakia.png\"},\"si\": {\"code\": \"+386\",\"name\": \"Slovenia\",\"flag\": \"flag_slovenia.png\"},\"sb\": {\"code\": \"+677\",\"name\": \"Solomon Islands\",\"flag\": \"flag_soloman_islands.png\"},\"so\": {\"code\": \"+252\",\"name\": \"Somalia\",\"flag\": \"flag_somalia.png\"},\"za\": {\"code\": \"+27\",\"name\": \"South Africa\",\"flag\": \"flag_south_africa.png\"},\"kr\": {\"code\": \"+82\",\"name\": \"Korea, Republic Of\",\"flag\": \"flag_south_korea.png\"},\"es\": {\"code\": \"+34\",\"name\": \"Spain\",\"flag\": \"flag_spain.png\"},\"lk\": {\"code\": \"+94\",\"name\": \"Sri Lanka\",\"flag\": \"flag_sri_lanka.png\"},\"sh\": {\"code\": \"+290\",\"name\": \"Saint Helena, Ascension And Tristan Da Cunha\",\"flag\": \"flag_saint_helena.png\"},\"pm\": {\"code\": \"+508\",\"name\": \"Saint Pierre And Miquelon\",\"flag\": \"flag_saint_pierre.png\"},\"sd\": {\"code\": \"+249\",\"name\": \"Sudan\",\"flag\": \"flag_sudan.png\"},\"sr\": {\"code\": \"+597\",\"name\": \"Suriname\",\"flag\": \"flag_suriname.png\"},\"sz\": {\"code\": \"+268\",\"name\": \"Swaziland\",\"flag\": \"flag_swaziland.png\"},\"se\": {\"code\": \"+46\",\"name\": \"Sweden\",\"flag\": \"flag_sweden.png\"},\"ch\": {\"code\": \"+41\",\"name\": \"Switzerland\",\"flag\": \"flag_switzerland.png\"},\"sy\": {\"code\": \"+963\",\"name\": \"Syrian Arab Republic\",\"flag\": \"flag_syria.png\"},\"tw\": {\"code\": \"+886\",\"name\": \"Taiwan, Province Of China\",\"flag\": \"flag_taiwan.png\"},\"tj\": {\"code\": \"+992\",\"name\": \"Tajikistan\",\"flag\": \"flag_tajikistan.png\"},\"tz\": {\"code\": \"+255\",\"name\": \"Tanzania, United Republic Of\",\"flag\": \"flag_tanzania.png\"},\"th\": {\"code\": \"+66\",\"name\": \"Thailand\",\"flag\": \"flag_thailand.png\"},\"tg\": {\"code\": \"+228\",\"name\": \"Togo\",\"flag\": \"flag_togo.png\"},\"tk\": {\"code\": \"+690\",\"name\": \"Tokelau\",\"flag\": \"flag_tokelau.png\"},\"to\": {\"code\": \"+676\",\"name\": \"Tonga\",\"flag\": \"flag_tonga.png\"},\"tn\": {\"code\": \"+216\",\"name\": \"Tunisia\",\"flag\": \"flag_tunisia.png\"},\"tr\": {\"code\": \"+90\",\"name\": \"Turkey\",\"flag\": \"flag_turkey.png\"},\"tm\": {\"code\": \"+993\",\"name\": \"Turkmenistan\",\"flag\": \"flag_turkmenistan.png\"},\"tv\": {\"code\": \"+688\",\"name\": \"Tuvalu\",\"flag\": \"flag_tuvalu.png\"},\"ae\": {\"code\": \"+971\",\"name\": \"United Arab Emirates\",\"flag\": \"flag_uae.png\"},\"ug\": {\"code\": \"+256\",\"name\": \"Uganda\",\"flag\": \"flag_uganda.png\"},\"gb\": {\"code\": \"+44\",\"name\": \"United Kingdom\",\"flag\": \"flag_united_kingdom.png\"},\"ua\": {\"code\": \"+380\",\"name\": \"Ukraine\",\"flag\": \"flag_ukraine.png\"},\"uy\": {\"code\": \"+598\",\"name\": \"Uruguay\",\"flag\": \"flag_uruguay.png\"},\"us\": {\"code\": \"+1\",\"name\": \"United States\",\"flag\": \"flag_united_states_of_america.png\"},\"uz\": {\"code\": \"+998\",\"name\": \"Uzbekistan\",\"flag\": \"flag_uzbekistan.png\"},\"vu\": {\"code\": \"+678\",\"name\": \"Vanuatu\",\"flag\": \"flag_vanuatu.png\"},\"va\": {\"code\": \"+39\",\"name\": \"Holy See (vatican City State)\",\"flag\": \"flag_vatican_city.png\"},\"ve\": {\"code\": \"+58\",\"name\": \"Venezuela, Bolivarian Republic Of\",\"flag\": \"flag_venezuela.png\"},\"vn\": {\"code\": \"+84\",\"name\": \"Viet Nam\",\"flag\": \"flag_vietnam.png\"},\"wf\": {\"code\": \"+681\",\"name\": \"Wallis And Futuna\",\"flag\": \"flag_wallis_and_futuna.png\"},\"ye\": {\"code\": \"+967\",\"name\": \"Yemen\",\"flag\": \"flag_yemen.png\"},\"zm\": {\"code\": \"+260\",\"name\": \"Zambia\",\"flag\": \"flag_zambia.png\"},\"zw\": {\"code\": \"+263\",\"name\": \"Zimbabwe\",\"flag\": \"flag_zimbabwe.png\"},\"ai\": {\"code\": \"+1\",\"name\": \"Anguilla\",\"flag\": \"flag_anguilla.png\"},\"ag\": {\"code\": \"+1\",\"name\": \"Antigua & Barbuda\",\"flag\": \"flag_antigua_and_barbuda.png\"},\"bs\": {\"code\": \"+1\",\"name\": \"Bahamas\",\"flag\": \"flag_bahamas.png\"},\"bb\": {\"code\": \"+1\",\"name\": \"Barbados\",\"flag\": \"flag_barbados.png\"},\"bm\": {\"code\": \"+1\",\"name\": \"Bermuda\",\"flag\": \"flag_bermuda.png\"},\"vg\": {\"code\": \"+1\",\"name\": \"British Virgin Islands\",\"flag\": \"flag_british_virgin_islands.png\"},\"dm\": {\"code\": \"+1\",\"name\": \"Dominica\",\"flag\": \"flag_dominica.png\"},\"do\": {\"code\": \"+1\",\"name\": \"Dominican republic\",\"flag\": \"flag_dominican_republic.png\"},\"gd\": {\"code\": \"+1\",\"name\": \"Grenada\",\"flag\": \"flag_grenada.png\"},\"jm\": {\"code\": \"+1\",\"name\": \"Jamaica\",\"flag\": \"flag_jamaica.png\"},\"ms\": {\"code\": \"+1\",\"name\": \"Montserrat\",\"flag\": \"flag_montserrat.png\"},\"kn\": {\"code\": \"+1\",\"name\": \"St Kitts & Nevis\",\"flag\": \"flag_saint_kitts_and_nevis.png\"},\"lc\": {\"code\": \"+1\",\"name\": \"St Lucia\",\"flag\": \"flag_saint_lucia.png\"},\"vc\": {\"code\": \"+1\",\"name\": \"St Vincent & The Grenadines\",\"flag\": \"flag_saint_vicent_and_the_grenadines.png\"},\"tt\": {\"code\": \"+1\",\"name\": \"Trinidad & Tobago\",\"flag\": \"flag_trinidad_and_tobago.png\"},\"tc\": {\"code\": \"+1\",\"name\": \"Turks & Caicos Islands\",\"flag\": \"flag_turks_and_caicos_islands.png\"},\"vi\": {\"code\": \"+1\",\"name\": \"US Virgin Islands\",\"flag\": \"flag_us_virgin_islands.png\"}}"
        #if arch(i386) || arch(x86_64)
            
            
            if(appDelegate().countrySelected.isEmpty)
            {
                //Code to get Country details from Dictionary
               
               // self.userJID?.becomeFirstResponder()
                if let data = dict?.data(using: String.Encoding.utf8.rawValue) {
                    
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
               // btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
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
                              
                              // self.userJID?.becomeFirstResponder()
                               if let data = dict?.data(using: String.Encoding.utf8.rawValue) {
                                   
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
                                       appDelegate().CountryShotcutTemp = countrycode!
                                       if(countrycode != nil || countrycode != ""){
                                           
                                           
                                           let json = try JSONSerialization.jsonObject(with: data, options: [])
                                           let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: (countrycode?.lowercased())!) as? NSDictionary)!
                                           
                                           countryCode!.text = dictCountry.value(forKey: "code") as? String
                                           //btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                                           
                                           btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                                           
                                           
                                       }
                                       
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
                              // btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                               countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
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
                    //self.userJID?.becomeFirstResponder()
                    //Code to get Country details from Dictionary
                   
                    if let data = dict?.data(using: String.Encoding.utf8.rawValue) {
                        
                        do {
                            let code:String = (carrier.isoCountryCode?.lowercased())!
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: code) as? NSDictionary)!
                            appDelegate().CountryShotcutTemp = code
                            countryCode!.text = dictCountry.value(forKey: "code") as? String
                           // btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                            
                            //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                            countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                            
                            
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
                //appDelegate().showSimAlert()
                if(appDelegate().countrySelected.isEmpty)
                {
                    //Code to get Country details from Dictionary
                    
                    // self.userJID?.becomeFirstResponder()
                    if let data = dict?.data(using: String.Encoding.utf8.rawValue) {
                        
                        do {
                            let code:String = "gb"
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            let dictCountry:NSDictionary = ((json as AnyObject).value(forKey: code) as? NSDictionary)!
                            appDelegate().CountryShotcutTemp = code
                            countryCode!.text = dictCountry.value(forKey: "code") as? String
                            //btnCountryName?.setTitle(dictCountry.value(forKey: "name") as? String, for: UIControlState.normal)
                            
                            btnCountryName?.setImage(UIImage(named:(dictCountry.value(forKey: "flag") as? String)!), for: UIControl.State.normal)
                            
                            //UIImage(named:(dict2?.value(forKey: "flag") as? String)!)
                            countryImage?.image = UIImage(named:(dictCountry.value(forKey: "flag") as? String)!)
                            
                            
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
                    // btnCountryName?.setTitle(appDelegate().countrySelected, for: UIControlState.normal)
                    countryImage?.image = UIImage(named:(appDelegate().countryFlagSelected))
                }
            }
        }
        #endif
        // setupDatePicker();
        let screenSize: CGRect = UIScreen.main.bounds
        
        //let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //print("Screen width = \(screenWidth), screen height = \(screenHeight)")
        if(screenHeight <= 480)
        {
            self.bottomConstraint.constant = CGFloat(20.0)
            
        }
        else
        {
            self.bottomConstraint.constant = CGFloat(0.0)
        }
        
            let registerJIDTemp: String? = UserDefaults.standard.string(forKey: "registerusername")
        
             //Check if user is reactivating his account
             if registerJIDTemp != nil {
                 userJID?.text = ""
                userJID?.insertText(registerJIDTemp!)
                    }
        let registerMobile: String? = UserDefaults.standard.string(forKey: "registerMobile")
        
        //Check if user is reactivating his account
        if registerMobile != nil {
             usermobile?.text = ""
            usermobile?.insertText(registerMobile!)
        }
        let struserpassword: String? = UserDefaults.standard.string(forKey: "userpassword")
        
        //Check if user is reactivating his account
        if struserpassword != nil {
             userpassword?.text = ""
            userpassword?.insertText(struserpassword!)
        }
        let struseremail: String? = UserDefaults.standard.string(forKey: "useremail")
        
        //Check if user is reactivating his account
        if struseremail != nil {
             useremail?.text = ""
            useremail?.insertText(struseremail!)
        }
        let struserName: String? = UserDefaults.standard.string(forKey: "userName")
        
        //Check if user is reactivating his account
        if struserName != nil {
            name?.text = ""
            name?.insertText(struserName!)
        }
      appDelegate().isFromSettings = false
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
            RegisterViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return RegisterViewController.realDelegate!;
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
    @IBAction func showpassword () {
       // let passwordtag = ""
        let passwordtag = btnShow?.currentTitle
        if (passwordtag == "Show") {
            userpassword?.isSecureTextEntry = false
            //userpassword?.font = UIFont(name:sy, size: 18)
            btnShow?.setTitle("Hide", for: UIControl.State.normal)
        }
        else{
            userpassword?.isSecureTextEntry = true
            btnShow?.setTitle("Show", for: UIControl.State.normal)
        }
        /*if #available(iOS 9.0, *) {
            userpassword?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        } else {
            // Fallback on earlier versions
        }*/
    }
    @IBAction func backclick() {
       appDelegate().profileAvtarTemp = UIImage(named:"avatar")
        UserDefaults.standard.setValue(nil, forKey: "isShowTeams")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "registerJID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "usercountrycode")
        UserDefaults.standard.setValue(nil, forKey: "registerMobile")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "registerusername")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "userpassword")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "userName")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "useremail")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "usercountrycode")
        UserDefaults.standard.setValue(nil, forKey: "usercountryshortcode")
        UserDefaults.standard.setValue(nil, forKey: "primaryTeamId")
        UserDefaults.standard.setValue(nil, forKey: "primaryTeamName")
        UserDefaults.standard.setValue(nil, forKey: "primaryTeamLogo")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam1Id")
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam1Name")
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam1Logo")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam2Id")
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam2Name")
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam2Logo")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam3Id")
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam3Name")
        UserDefaults.standard.setValue(nil, forKey: "optionalTeam3Logo")
        UserDefaults.standard.synchronize()
        appDelegate().primaryTeamId = 0
         appDelegate().optionalTeam1Id  = 0
         appDelegate().optionalTeam2Id  = 0
         appDelegate().optionalTeam3Id  = 0
        appDelegate().isAvtarChanged = false
         appDelegate().primaryTeamName  = ""
         appDelegate().optionalTeam1Name  = ""
         appDelegate().optionalTeam2Name = ""
        appDelegate().optionalTeam3Name  = ""
        appDelegate().primaryTeamLogo = ""
        appDelegate().optionalTeam1Logo  = ""
        appDelegate().optionalTeam2Logo  = ""
        appDelegate().optionalTeam3Logo  = ""
         appDelegate().showLogin()
    }
    @IBAction func login() {
        userJID?.resignFirstResponder()
       
        userdob?.resignFirstResponder()
        userpassword?.resignFirstResponder()
        useremail?.resignFirstResponder()
        name?.resignFirstResponder()
        usermobile?.resignFirstResponder()
         if ClassReachability.isConnectedToNetwork()
         {
            let thereWereErrors = checkForErrors()
            if !thereWereErrors
            {
                if let userid = userJID!.text?.lowercased() {
                    if let countrycode = countryCode!.text {
                        if(success)
                        {
                            if(emailsuccess)
                            {
                                var mobileNumberTemp = countryCode!.text! + usermobile!.text!
                                mobileNumberTemp = mobileNumberTemp.replace(target: "+", withString: "")
                                
                                var countryCodeTemp = countryCode!.text!
                                countryCodeTemp = countryCodeTemp.replace(target: "+", withString: "")
                                
                                //Here we have to show loader and minimize keyboard
                                
                                //userJID?.isUserInteractionEnabled = false
                                //Code to show loader
                                //activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
                                // activityIndicator?.startAnimating()
                                //LoadingIndicatorView.show(self.view, loadingText: "Creating your Football Fan profile.")
                                
                                //New code for mobile lookup
                                //appDelegate().callPHPFFAPI("vmnlookup", mobile: Int64(mobileNumberTemp)!, countryCode: countryCodeTemp)
                                
                                // This code will shift after mobile verification process
                                let registerid = userid + JIDPostfix
                                var registermo =  usermobile!.text!
                                if(registermo.hasPrefix("0")){
                                   //registermo = registermo.replacingOccurrences(of: "0", with: "")
                                    registermo = "" + String(registermo.dropFirst())
                                }
                                var trimMessage: String = name!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                //print(trimMessage)
                                trimMessage = trimMessage.condenseWhitespace()
                                
                                UserDefaults.standard.setValue(registerid, forKey: "registerJID")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.setValue(countrycode, forKey: "usercountrycode")
                                UserDefaults.standard.setValue(registermo, forKey: "registerMobile")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.setValue(userid, forKey: "registerusername")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.setValue(userpassword?.text, forKey: "userpassword")
                                 UserDefaults.standard.setValue(userRefralCode?.text, forKey: "refralcode")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.setValue(trimMessage, forKey: "userName")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.setValue(useremail?.text?.lowercased(), forKey: "useremail")
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.setValue(countryCode?.text, forKey: "usercountrycode")
                                  UserDefaults.standard.setValue(appDelegate().CountryShotcutTemp, forKey: "usercountryshortcode")
                                UserDefaults.standard.setValue("YES", forKey:"isShowTeams")
                                UserDefaults.standard.synchronize()
                                //Trying to connect userusercountryshortcode
                                //let userdob: String? = UserDefaults.standard.string(forKey: "userdob")
                                //print("\(userdob)")refralcode
                                 if (userRefralCode?.text?.isEmpty)!
                                {
                                    //appDelegate().showMyTeams()
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let myTeamsController : MyTeamsViewController = storyBoard.instantiateViewController(withIdentifier: "MyTeams") as! MyTeamsViewController
                                    
                                    self.show(myTeamsController, sender: self)
                                }
                                else{
                                    refralusercheck()
                                }
                                /*if appDelegate().connect() {
                                    //show buddy list
                                } else {
                                    //showLogin()
                                    userJID?.isUserInteractionEnabled = true
                                    // activityIndicator?.stopAnimating()
                                    LoadingIndicatorView.hide()
                                    self.userJID?.becomeFirstResponder()
                                    
                                }*/
                            }
                            else{
                                var message = ""
                                message = "Email address already exists"
                                alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.useremail!)
                                
                            }
                        }
                        else{
                            var message = ""
                            //New code by Ravi on 24-02-2020
                            if((self.userJID?.text!.count)! > 6)
                            {
                                message = "Username already exists"
                                alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
                            }
                            else
                            {
                                message = "Username should be minimum 6 characters"
                                alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
                            }
                            
                            
                        }
                    }
                }
            }
         }
            else {
            alertWithTitle(title: nil, message: "Please check your Internet connection", ViewController: self, toFocus:self.userJID!)
            
        }
    }
    
    /*func textFieldShouldReturn(textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     if (textField == self.userJID) {
     self.userJID?.becomeFirstResponder()
     }
     else{
     let thereWereErrors = checkForErrors()
     if !thereWereErrors
     {
     //conditionally segue to next screen
     }
     }
     
     return true
     }*/
    func refralusercheck(){
    
    let boundary = appDelegate().generateBoundaryString()
    var request = URLRequest(url: URL(string: MediaAPI)!)
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    var reqParams = [String: String]()
    reqParams["cmd"] = "checkreferralusername"
        reqParams["username"] = userRefralCode?.text
    reqParams["key"] = "kXfqS9wUug6gVKDB"  
    
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
    
    if(isSuccess){
         DispatchQueue.main.async {
        //self.appDelegate().showMyTeams()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let myTeamsController : MyTeamsViewController = storyBoard.instantiateViewController(withIdentifier: "MyTeams") as! MyTeamsViewController
            
            self.show(myTeamsController, sender: self)
            
        }
    }
    else
    {
         DispatchQueue.main.async {
        self.alertWithTitle(title: nil, message: "Referral code is incorrect", ViewController: self, toFocus:self.userRefralCode!)
        }
    //Show Error
    }
    } catch let error as NSError {
    print(error)
    //Show Error
         DispatchQueue.main.async {
        self.alertWithTitle(title: nil, message: "System error!\n\nReferral Code validation has failed due to a technical issue on the server. Please try again later.", ViewController: self, toFocus:self.userRefralCode!)
        }
    }
    
    }
    }
    else
    {
        self.alertWithTitle(title: nil, message: "System error!\n\nReferral Code validation has failed due to a technical issue on the server. Please try again later.", ViewController: self, toFocus:self.userRefralCode!)
    //Show Error
    }
    })
    task.resume()
    
    
    
    }
    @IBAction func usernametxtchange(){
       
      
        if ((userJID?.text?.count)! > 5) {
            self.appDelegate().callPHPFFAPI("checkusername", username:(userJID?.text)!)
            self.usernamelabel?.text="Checking..."
            self.usernamelabel?.textColor=UIColor.green
        }
        else if((userJID?.text?.count)! == 0)
        {
            success = false
            self.usernamelabel?.text=""
        }
        else
        {
            success = false
            self.usernamelabel?.text="It should be minimum 6 characters."
            self.usernamelabel?.textColor=UIColor.red
        }
        
        usernamecount?.text=String(describing: userJID?.text?.count ?? 0)+"/"+String(describing: userJID?.maxLength ?? 0)
        
    }
    @IBAction func userpasswordtxtchange(){
       
        
        userPasswordcount?.text=String(describing: userpassword?.text?.count ?? 0)+"/"+String(describing: userpassword?.maxLength ?? 0)
        
    }
    @IBAction func userMobiletxtchange(){
        
        
        mobilecount?.text=String(describing: usermobile?.text?.count ?? 0)+"/"+String(describing: usermobile?.maxLength ?? 0)
        
    }
    @IBAction func nametxtchange(){
       
        
        namecount?.text=String(describing: name?.text?.count ?? 0)+"/"+String(describing: name?.maxLength ?? 0)
        
    }
    @IBAction func useremailtxtchange(){
        if validateEmail(candidate: (useremail?.text)!) {
            // Success
            // performSegueWithIdentifier("SEGUE-ID", sender: self)
            
            self.appDelegate().callPHPFFAPI("checkemail", useremail:(useremail?.text)!)
        } else {
            emailsuccess=false
            // Failure - Alert
            // errors = true
            //let message: String = "Please enter valid emailid."
            //alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.useremail!)
        }
    }
    //New code by Ravi on 24-02-2020
    func checkForErrors() -> Bool
    { //let age_=calcAge(birthday: (userdob?.text)!)
        var errors = false
       // let title = "Error"
        var message = ""
        let numberString = usermobile?.text
        let numberAsInt = Int(numberString!)
       // let newmobilestr: String = String(describing: numberAsInt) as String
        
        var usrNameTemp = ""
        var nameTemp = ""
        var usrNameCnt = 0
        if (!(userJID?.text!.isEmpty)!) {
            usrNameTemp = userJID!.text!
            usrNameCnt = (self.userJID?.text!.count)!
            
        }
        
        if (!(name?.text!.isEmpty)!) {
            nameTemp = name!.text!
        }
        
       
        
        if (userJID?.text?.isEmpty)! {
            errors = true
            message += "Username cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
            
            return errors
        }
        
        if (!usrNameTemp.isEmpty) {
            
            let cs = NSCharacterSet(charactersIn: UserNameACCEPTABLE_CHARACTERS).inverted
            let filtered = usrNameTemp.components(separatedBy: cs).joined(separator: "")
            //usernamecount?.text =
            if(usrNameTemp != filtered)
            {
                errors = true
                message += "Invalid username"
                self.userJID!.text = ""
                self.usernamelabel?.text = ""
                self.usernamelabel?.textColor=UIColor.red
                alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
                
                return errors
            }
                
        }
        
        if(usrNameCnt < 6)
        {
            errors = true
            message += "Username should be minimum 6 characters"
            self.usernamelabel?.textColor=UIColor.red
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
            
            return errors
        }
        
        
        if (userpassword?.text?.isEmpty)!
        {
            errors = true
            message += "Password cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userpassword!)
            return errors
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
            //New code by Ravi on 24-02-2020
            self.usermobile!.text = ""
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.usermobile!)
            return errors
        }
        
        return errors
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        if(result.rawValue == MessageComposeResult.sent.rawValue)
        {
            userJID?.resignFirstResponder()
            
            //print("Message sent successfully.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(OTPViewController.update), userInfo: nil, repeats: true)
            }
        }
        else
        {
            
            let message = "Sending message failed."
            alertWithTitle(title: "Error", message: message, ViewController: self, toFocus:self.userJID!)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func update() {
        if(count > 0) {
            count = count - 1
            //counterLabel.text = String(count)
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            counterButton.setTitle(String(count), for: UIControl.State.normal)
        }
        else
        {
           TransperentLoadingIndicatorView.hide()
            timer.invalidate()
            counterButton.setTitle("", for: UIControl.State.normal)
            
            let message = "Sorry, we are unable to verify your mobile."
            alertWithTitle(title: "Verification failed!", message: message, ViewController: self, toFocus:self.userJID!)
        }
    }
    
    @objc func registerUserTemp(notification: NSNotification) {
        
        /*if let recMobile = notification.userInfo?["recMobile"] as? String
         {
         
         }*/
         DispatchQueue.main.async {
            if let userid = self.userJID!.text {
                if let countrycode = self.countryCode!.text {
                
                
                
                
                let registerid = countrycode + userid + JIDPostfix
                let registermo = countrycode + userid
                UserDefaults.standard.setValue(registerid, forKey: "registerJIDTemp")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(registermo, forKey: "registerMobileTemp")
                UserDefaults.standard.synchronize()
                
                //Trying to connect user
                
                ///print("Trying to connect user")
                    if self.appDelegate().connect() {
                    //show buddy list
                    
                    
                } else {
                    //showLogin()
                        self.userJID?.isUserInteractionEnabled = true
                    //activityIndicator?.stopAnimating()
                    TransperentLoadingIndicatorView.hide()
                        self.userJID?.becomeFirstResponder()
                    
                }
                
                
                
            }
        }
        }
    }
    
    @objc func verificationSuccess(notification: NSNotification)
    {
        timer.invalidate()
    }
    
    @objc func showVerifyOTPScreen(notification: NSNotification)
    {
       /* if(activityIndicator?.isAnimating)!
        {
            activityIndicator?.stopAnimating()
        }*/
        TransperentLoadingIndicatorView.hide()
        Clslogging.logdebug(State: "showVerifyOTPScreen VerifyOTP")
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTP")
        
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
    
    @objc func showSMSOptions(notification: NSNotification) {
        
       /* if(activityIndicator?.isAnimating)!
        {
            activityIndicator?.stopAnimating()
        }*/
        TransperentLoadingIndicatorView.hide()
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let facebookAction = UIAlertAction(title: "Verify by Facebook", style: .default, imageNamed: "uncheck", handler: {
            (alert: UIAlertAction!) -> Void in
            
            var mobileNumberTemp = self.countryCode!.text! + self.userJID!.text!
            mobileNumberTemp = mobileNumberTemp.replace(target: "+", withString: "")
            
            
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            //Send OTP to Facebook Messanger
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            self.appDelegate().callPHPFFAPI("sendotp", mobile: Int64(mobileNumberTemp)!, gatewayId: 2, time: time)
            
        })
        let messagebirdAction = UIAlertAction(title: "Verify by SMS", style: .default, imageNamed: "uncheck", handler: {
            (alert: UIAlertAction!) -> Void in
            ///print("Verify by SMS")
            if MFMessageComposeViewController.canSendText() == true {
                
                var countryCodeTemp = self.countryCode!.text!
                countryCodeTemp = countryCodeTemp.replace(target: "+", withString: "")
                var recipients:[String] = [""]
                if(countryCodeTemp == "+1")
                {
                    recipients = ["+13615023450"]
                }
                else
                {
                    recipients = ["+447418310450"]
                }
                
                
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate  = self
                messageController.recipients = recipients
                messageController.body = "We are requesting verification. This request may cost as per your local charges. Your screen will automatically refresh after verification."
                self.present(messageController, animated: true, completion: nil)
            } else {
                //handle text messaging not available
            }
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
           // print("Cancelled")
        })
        optionMenu.addAction(facebookAction!)
        optionMenu.addAction(messagebirdAction!)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
        
    }
   /* @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (notlabel?.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: termsRange, inRange: termsRange) {
            print("Tapped terms")
        } else if gesture.didTapAttributedTextInLabel(termsRange, inRange: privacyRange) {
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
    }*/
    /*@objc func DoRegistration(notification: NSNotification){
     //New user registered and now redirect to profile
     print("Show Profile")
     //dismiss(animated: true, completion: nil)
     showProfile()
     }
     
     
     func showProfile() {
     
     UserDefaults.standard.setValue("YES", forKey: "isShowProfile")
     UserDefaults.standard.synchronize()
     
     let storyBoard = UIStoryboard(name: "Main", bundle: nil)
     let profileController : AnyObject! = storyBoard.instantiateViewController(withIdentifier: "Profile")
     present(profileController as! UIViewController, animated: true, completion: nil)
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
           // print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
        else if status == .authorizedAlways {
           // print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            manager.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            
           // print("locations = \(locationValue)")
            
            manager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil)
                {
                    //print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks!.count > 0)
                {
                    let pm = placemarks![0] as CLPlacemark
                    self.displayLocationInfo(placemark: pm)
                }
                else
                {
                    //print("Problem with the data received from geocoder")
                }
            })

            //Call API to save current location
            //if(locationValue.latitude > 0 && locationValue.longitude > 0)
            // {
            UserDefaults.standard.setValue(locationValue.latitude, forKey: "latitude")
            //UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue( locationValue.longitude, forKey: "longitude")
            UserDefaults.standard.synchronize()
            //New code to call different APIS
            
           // let ad=getAddressForLatLng(latitude: "\(locationValue.latitude)",longitude: "\( locationValue.longitude)")
           // print("locations = \(ad)")
            //btnCountryName?.setTitle(ad, for: UIControlState.normal)
            
        }
        
        
        // }
        
    }
    func displayLocationInfo(placemark: CLPlacemark?)
    {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
           // let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            UserDefaults.standard.setValue(administrativeArea, forKey: "userstate")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(country, forKey: "usercountry")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(locality, forKey: "userecity")
            UserDefaults.standard.synchronize()
            
            
        }
        
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        //displayCantAddContactAlert()
    }
    
  /*  func getAddressForLatLng(latitude: String, longitude: String) -> String {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyBT7WyWAdjhUZCssmEIbHZC-xcjME0Zcv8")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            //var number = ""
                            //var street = ""
                            var city = "NA"
                            var state = "NA"
                            var country = "NA"
                            
                           /* if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["long_name"] as! String
                            }*/
                            if(address.count > 8) {
                                city = (address.object(at: 7) as! NSDictionary)["long_name"] as! String
                            }
                            if(address.count > 9) {
                                state = (address.object(at: 8) as! NSDictionary)["long_name"] as! String
                            }
                            if(address.count > 10) {
                                country =  (address.object(at: 9) as! NSDictionary)["long_name"] as! String
                            }
                            newaddress = " \(city), \(state) \(country)"
                            print(newaddress)
                            UserDefaults.standard.setValue(state, forKey: "userstate")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.setValue(country, forKey: "usercountry")
                            UserDefaults.standard.synchronize()
                            UserDefaults.standard.setValue(city, forKey: "userecity")
                            UserDefaults.standard.synchronize()
                            
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
    }
    */
    func setupDatePicker() {
        // Sets up the "button"
        //userdob?.text = "Pick a due date"
        userdob?.textAlignment = .center
        
        // Removes the indicator of the UITextField
        userdob?.tintColor = UIColor.clear
        
        // Specifies intput type
        datePicker.datePickerMode = .date
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterViewController.doneClick))
        doneButton.tintColor = UIColor.init(hex: "000000")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(RegisterViewController.cancelClick))
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
        UserDefaults.standard.setValue(currentTimeInMiliseconds(), forKey: "userdob")
        UserDefaults.standard.synchronize()
        let now = Date()
        let birthday: Date = datePicker.date
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        age = Int64(ageComponents.year!)
        //print(age)
      //  let userdob1: String? = UserDefaults.standard.string(forKey: "userdob")
        //print("\(userdob1)")
    }
    
    @objc func cancelClick() {
         userdob?.text = ""
        userdob?.resignFirstResponder()
        UserDefaults.standard.setValue(0, forKey: "userdob")
        UserDefaults.standard.synchronize()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // print("TextField did begin editing method called")
        Tagtextfield=textField.tag
       // print(textField.superview?.frame.origin.y ?? "")
        maximumY = (textField.superview?.frame.origin.y)!
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
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
        if (textField.tag == 4) {
             textField.resignFirstResponder()
          /*  if validateEmail(candidate: (useremail?.text)!) {
                // Success
                // performSegueWithIdentifier("SEGUE-ID", sender: self)
                
                self.appDelegate().callPHPFFAPI("checkemail", useremail:(useremail?.text)!)
            } else {
                emailsuccess=false
                // Failure - Alert
                // errors = true
                //let message: String = "Please enter valid emailid."
                //alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.useremail!)
            }*/
            
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("TextField should begin editing method called")
        if(textField.tag == 1){
          
        }
        textField.spellCheckingType = .no
         textField.autocorrectionType = .no
       
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("TextField should clear method called")
        return true;
    }
    private func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        //print("TextField should snd editing method called")
       
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(Tagtextfield==1){
            let cs = NSCharacterSet(charactersIn: UserNameACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            //usernamecount?.text =
            return (string == filtered)
        }
        else if(Tagtextfield == 2){
            let cs = NSCharacterSet(charactersIn: Password_ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        else if(Tagtextfield == 3){
            let cs = NSCharacterSet(charactersIn: extraACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        } else if(Tagtextfield == 4){
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
            else if(Tagtextfield==6){
                let cs = NSCharacterSet(charactersIn: UserNameACCEPTABLE_CHARACTERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                //usernamecount?.text =
                return (string == filtered)
            }
        else{
            let cs = NSCharacterSet(charactersIn: extraACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        //print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    @objc func usernameSuccess(notification: NSNotification)
    {
        success=(notification.userInfo?["success"] as? Bool)!
        
        DispatchQueue.main.async {
            if(self.success){
                self.usernamelabel?.text="Username is available."
                self.usernamelabel?.textColor=UIColor.green
            }
            else{
                self.usernamelabel?.text="Username already exists"
                self.usernamelabel?.textColor=UIColor.red
            }
        }
        
        
    }
    @objc func useremailSuccess(notification: NSNotification)
    {
         DispatchQueue.main.async {
            self.emailsuccess = (notification.userInfo?["success"] as? Bool)!
        }
       /* var message = ""
        DispatchQueue.main.async {
            self.userJID?.resignFirstResponder()
            self.userdob?.resignFirstResponder()
            self.userpassword?.resignFirstResponder()
            self.useremail?.resignFirstResponder()
            self.name?.resignFirstResponder()
            self.usermobile?.resignFirstResponder()
        }*/
       // message = " Email alredy exist."
       // alertWithTitle(title: "Invalid Email", message: message, ViewController: self, toFocus:self.useremail!)
        
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
        if(Tagtextfield > 2){
            if(isKeyboardHiding == false)
            {
                adjustingHeight(show: true, notification: notification)
            }
            
        }
        else
        {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            if(screenHeight <= 480)
            {
                self.bottomConstraint.constant = 20.0
                
            }
            else
            {
                self.bottomConstraint.constant = 0.0
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
            var changeInHeight = 0.0
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            
            if(screenHeight <= 480)
            {
                changeInHeight = 20.0
                
            }
            else
            {
                changeInHeight = 0.0
            }
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = CGFloat(changeInHeight)
                
            })
        }
        else
        {
            //let changeInHeight = (maximumY - self.keyboardFrame.height) + 110 //* (show ? 1 : -1)
            var changeInHeight: CGFloat = 0.0
            if(Tagtextfield == 6)
            {
                changeInHeight = (maximumY - self.keyboardFrame.height) + 154
            }
            else
            {
                changeInHeight = (maximumY - self.keyboardFrame.height) + 110
            }
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = -changeInHeight
                
            })
        }
        
        
        
          }
    
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let text = (notlabel!.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        let LicensedUser = (text as NSString).range(of: "EULA")
        
        if gesture.didTapAttributedTextInLabel(label: notlabel!, inRange: termsRange) {
           // print("Tapped terms")
            UserDefaults.standard.setValue("Terms & Conditions", forKey: "terms")
            UserDefaults.standard.synchronize()
            showWEBVIEWScreen()
            
        } else if gesture.didTapAttributedTextInLabel(label: notlabel!, inRange: privacyRange) {
           // print("Tapped privacy")
            UserDefaults.standard.setValue("Privacy Policy", forKey: "terms")
            UserDefaults.standard.synchronize()
            showWEBVIEWScreen()
        }
        else if gesture.didTapAttributedTextInLabel(label: notlabel!, inRange: LicensedUser) {
           // print("Licensed User")
            UserDefaults.standard.setValue("End User License ﻿﻿Agreement﻿﻿", forKey: "terms")
            UserDefaults.standard.synchronize()
            showWEBVIEWScreen()
        }else {
            
             }
    }
    @objc func tapRLabel(_ gesture: UITapGestureRecognizer) {
        let text = (Refrralnote!.text)!
        let termsRange = (text as NSString).range(of: "Learn more.")
        
        if gesture.didTapAttributedTextInLabel(label: Refrralnote!, inRange: termsRange) {
            // print("Tapped terms")
            UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
            UserDefaults.standard.synchronize()
            showWEBVIEWScreen()
            
        }
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            userJID?.endEditing(true)
            //userJID?.delegate = self
            userdob?.endEditing(true)
            userpassword?.endEditing(true)
            useremail?.endEditing(true)
            name?.endEditing(true)
            usermobile?.endEditing(true)
           userRefralCode?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    func showWEBVIEWScreen()
    {
        
        
        /*let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webview")
        
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
}

