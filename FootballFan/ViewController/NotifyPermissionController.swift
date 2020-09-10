//
//  NotifyPermissionController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 04/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import UserNotifications

class NotifyPermissionController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var notifyHeading: UILabel!
    @IBOutlet weak var notifyText: UILabel?
    @IBOutlet weak var notifyImage: UIImageView?
    @IBOutlet weak var MainNotificationView: UIView!
     @IBOutlet weak var buttonView: UIView!
    //@IBOutlet weak var notifyAccept: UIButton?
    @IBOutlet weak var buttonUnderstand: UIButton!
    @IBOutlet weak var viewNavigation: UINavigationBar!
    @IBOutlet weak var SliderView: UIView!
    var notifyType: String = ""
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        print(view.frame.width,view.frame.height)//375.0 812.0
               print(scrollViewWidth,scrollViewHeight)//375.0 812.0
        //2
       // textView.textAlignment = .center
        //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
        //textView.textColor = UIColor.black
        //self.startButton.layer.cornerRadius = 10.0
        //3
        let imghome = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imghome.image = UIImage(named: "sliderhome")
        imghome.contentMode = .scaleAspectFill
        let imgOne = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "slide1")
        imgOne.contentMode = .scaleAspectFill
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "slide3")
        imgTwo.contentMode = .scaleAspectFill

        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "slide10")
        imgThree.contentMode = .scaleAspectFill

        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "slide7")
        imgFour.contentMode = .scaleAspectFill

        /* let imgFive = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgFive.image = UIImage(named: "slide5")*/
        let imgSix = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgSix.image = UIImage(named: "slide18")
        imgSix.contentMode = .scaleAspectFill

        let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*6, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgseven.image = UIImage(named: "slide13")
        imgseven.contentMode = .scaleAspectFill

        /* let imgEight = UIImageView(frame: CGRect(x:scrollViewWidth*7, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgEight.image = UIImage(named: "slide8")
         let imgNine = UIImageView(frame: CGRect(x:scrollViewWidth*6, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgNine.image = UIImage(named: "slide9")
         let imgEnd = UIImageView(frame: CGRect(x:scrollViewWidth*7, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgEnd.image = UIImage(named: "slide10")
         /* let imgEleven = UIImageView(frame: CGRect(x:scrollViewWidth*10, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgEleven.image = UIImage(named: "slide11")*/
         let imgTwelve = UIImageView(frame: CGRect(x:scrollViewWidth*8, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgTwelve.image = UIImage(named: "slide12")
         let img13 = UIImageView(frame: CGRect(x:scrollViewWidth*9, y:0,width:scrollViewWidth, height:scrollViewHeight))
         img13.image = UIImage(named: "slide13")
         let img16 = UIImageView(frame: CGRect(x:scrollViewWidth*10, y:0,width:scrollViewWidth, height:scrollViewHeight))
         img16.image = UIImage(named: "slide16")
         let img17 = UIImageView(frame: CGRect(x:scrollViewWidth*11, y:0,width:scrollViewWidth, height:scrollViewHeight))
         img17.image = UIImage(named: "slide17")
         let img14 = UIImageView(frame: CGRect(x:scrollViewWidth*12, y:0,width:scrollViewWidth, height:scrollViewHeight))
         img14.image = UIImage(named: "slide14")
         let img15 = UIImageView(frame: CGRect(x:scrollViewWidth*13, y:0,width:scrollViewWidth, height:scrollViewHeight))
         img15.image = UIImage(named: "slide15")*/
        self.scrollView.addSubview(imghome)
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        //self.scrollView.addSubview(imgFive)
        self.scrollView.addSubview(imgSix)
        self.scrollView.addSubview(imgseven)
        //self.scrollView.addSubview(imgEight)
        /* self.scrollView.addSubview(imgNine)
         self.scrollView.addSubview(imgEnd)
         //self.scrollView.addSubview(imgEleven)
         self.scrollView.addSubview(imgTwelve)
         self.scrollView.addSubview(img13)
         self.scrollView.addSubview(img16)
         self.scrollView.addSubview(img17)
         self.scrollView.addSubview(img14)*/
        // self.scrollView.addSubview(img15)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 7, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(notifyType == "notification")
        {
            notifyImage?.image = UIImage(named: "per_notification")
            notifyHeading.text = "Football Fan is fun when notifications are enabled."
            notifyText?.text = "Please allow access for Football Fan to receive notification.\n This can always be changed by going to your phone Settings."
            let notified: String? = UserDefaults.standard.string(forKey: "openslider")
            if notified == nil
            {
                
            MainNotificationView.isHidden = true
            SliderView.isHidden = false
            topView.isHidden = false
            viewNavigation.isHidden = false
            buttonUnderstand.isHidden = true
            }
            else{
                MainNotificationView.isHidden = false
                SliderView.isHidden = true
                topView.isHidden = true
                viewNavigation.isHidden = true
                buttonUnderstand.isHidden = false
                buttonView.isHidden = false
            }
           // buttonView.isHidden=
        }
        else if(notifyType == "contact")
        {
            notifyImage?.image = UIImage(named: "per_contacts")
            notifyHeading.text = "Please allow access for Football Fan to your Contacts in order to sync them, find friends, send invitations and initiate conversations."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "media")
        {
            notifyImage?.image = UIImage(named: "per_gallery")
            notifyHeading.text = "Please allow access for Football Fan to your phone gallery/camera to capture images and videos that you can either use for your profile picture or share with other fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "camera")
        {
            notifyImage?.image = UIImage(named: "per_camera")
            notifyHeading.text = "Please allow access for Football Fan to your camera to capture images and videos that you can use as your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "profilemedia")
        {
            notifyImage?.image = UIImage(named: "per_gallery")
            notifyHeading.text = "Please allow access for Football Fan to your media library to use your images for your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "profilecamera")
        {
            notifyImage?.image = UIImage(named: "per_camera")
            notifyHeading.text = "Please allow access for Football Fan to your camera to capture images and videos that you can use as your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "groupmedia")
        {
            notifyImage?.image = UIImage(named: "per_gallery")
            notifyHeading.text = "Please allow access for Football Fan to your media library to use your images for your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
            buttonView.isHidden = false
        }
        else if(notifyType == "groupcamera")
        {
            notifyImage?.image = UIImage(named: "per_camera")
            notifyHeading.text = "Please allow access for Football Fan to your camera to capture images and videos that you can use as your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
            buttonView.isHidden = false
        }
        else if(notifyType == "editgroupmedia")
        {
            notifyImage?.image = UIImage(named: "per_gallery")
            notifyHeading.text = "Please allow access for Football Fan to your media library to use your images for your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
            buttonView.isHidden = false
        }
        else if(notifyType == "editgroupcamera")
        {
            notifyImage?.image = UIImage(named: "per_camera")
            notifyHeading.text = "Please allow access for Football Fan to your camera to capture images and videos that you can use as your profile picture or share images and videos with other Fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
            buttonView.isHidden = false
        }
        else if(notifyType == "location" || notifyType == "registerlocation")
        {
            notifyImage?.image = UIImage(named: "per_location")
            notifyHeading.text = "Please allow access for Football Fan to your current location so that you can search Fans nearby."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "fanupdatecamera")
        {
            notifyImage?.image = UIImage(named: "per_camera")
            notifyHeading.text = "Please allow access for Football Fan to your phone gallery/camera to capture images and videos that you can either use for your profile picture or share with other fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "fanupdatemedia")
        {
            notifyImage?.image = UIImage(named: "per_gallery")
            notifyHeading.text = "Please allow access for Football Fan to your phone gallery/camera to capture images and videos that you can either use for your profile picture or share with other fans."
            notifyText?.text = "This can always be changed by going to your phone Settings."
             buttonView.isHidden = false
        }
        else if(notifyType == "upcomingtrivia" || notifyType == "upcomingtriviadetail" || notifyType == "homelocation")
        {
            notifyImage?.image = UIImage(named: "per_location")
            notifyHeading.text = "Please allow access for Football Fan to your current location so that you can search Fans nearby."
            notifyText?.text = "This can always be changed by going to your phone Settings."
            buttonView.isHidden = false
        }
        
    }
    @IBAction func SkipHelp(_ sender: Any) {
        UserDefaults.standard.setValue("YES", forKey: "openslider")
        UserDefaults.standard.synchronize()
        appDelegate().showMainTab()
        //UserDefaults.standard.setValue(false, forKey: "istriviauser")
       // UserDefaults.standard.synchronize()
      //  appDelegate().ShowNotificationPermission()
        /*MainNotificationView.isHidden = false
        SliderView.isHidden = true
        topView.isHidden = true
        viewNavigation.isHidden = true
        buttonUnderstand.isHidden = false
        buttonView.isHidden = false*/
    }
    @IBAction func notifycancel () {
        
        if(notifyType == "notification")
        {
           // UserDefaults.standard.setValue("YES", forKey: "notification")
           // UserDefaults.standard.synchronize()
            
            //DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
           /* let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let isShowTeams: String? = UserDefaults.standard.string(forKey: "isShowTeams")
            
            let isShowProfile: String? = UserDefaults.standard.string(forKey: "isShowProfile")
            let isLoggedin: String? = UserDefaults.standard.string(forKey: "isLoggedin")
            if isShowTeams != nil
            {
                self.appDelegate().showMyTeams()
            }
            //Check if user is already logged in
            if isLoggedin == nil || isLoggedin == "NO"
            {
                if isShowTeams != nil
                {
                    self.appDelegate().showMyTeams()
                }
                else
                {
                    if isShowProfile == nil {
                        if (login != nil) {
                            if self.appDelegate().connect() {
                                //show buddy list
                                
                            } else {
                                self.appDelegate().showLogin()
                            }
                        }
                        else
                        {
                            self.appDelegate().showLogin()
                        }
                    }
                    else
                    {
                        //Authenticate and fetch profile data
                        if self.appDelegate().connect() {
                            self.appDelegate().showProfile()
                        }
                        
                    }
                }
                
            }
            else
            {
                if(self.appDelegate().connect())
                {
                    //Get from local user defaults temp
                    let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                    if localArrAllChats != nil
                    {
                        //Code to parse json data
                        if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                            do {
                                self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                    appDelegate().showMainTab()
                    //End
                }
            }
            
            self.appDelegate().profileAvtarTemp = UIImage(named:"avatar")
            */
          
        }
        else if(notifyType == "fanupdatecamera")
        {//UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
           // UserDefaults.standard.synchronize()
            
            self.dismiss(animated: true, completion: nil)
            //let notificationName = Notification.Name("_updateGetPermissionsForCameraProfile")
            //NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "fanupdatemedia")
        {//UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
           // UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            //let notificationName = Notification.Name("_updateGetPermissionsForMediaProfile")
            //NotificationCenter.default.post(name: notificationName, object: nil)
            
        }
        else if(notifyType == "contact")
        {
           // UserDefaults.standard.setValue("YES", forKey: "notifiedcontact")
            //UserDefaults.standard.synchronize()
            
            self.dismiss(animated: true, completion: nil)
            let notificationName = Notification.Name("_GetPermissionsForContactCancel")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "media")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            //UserDefaults.standard.synchronize()
            
            //let notificationName = Notification.Name("_GetPermissionsForMedia")
           /// NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "camera")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            //UserDefaults.standard.synchronize()
            
           // let notificationName = Notification.Name("_GetPermissionsForCamera")
            //NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "profilemedia")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            //UserDefaults.standard.synchronize()
           /* if(appDelegate().isFromSettings == true){
                let notificationName = Notification.Name("_settingGetPermissionsForMediaProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
            else{
                let notificationName = Notification.Name("_GetPermissionsForMediaProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }*/
            
        }
        else if(notifyType == "profilecamera")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            //UserDefaults.standard.synchronize()
           /* if(appDelegate().isFromSettings == true){
                let notificationName = Notification.Name("_settingGetPermissionsForCameraProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
            else{
                let notificationName = Notification.Name("_GetPermissionsForCameraProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }*/
            
        }
        else if(notifyType == "groupmedia")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            //UserDefaults.standard.synchronize()
            /* if(appDelegate().isFromSettings == true){
             let notificationName = Notification.Name("_settingGetPermissionsForMediaProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }
             else{
             let notificationName = Notification.Name("_GetPermissionsForMediaProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }*/
            
        }
        else if(notifyType == "groupcamera")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            //UserDefaults.standard.synchronize()
            /* if(appDelegate().isFromSettings == true){
             let notificationName = Notification.Name("_settingGetPermissionsForCameraProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }
             else{
             let notificationName = Notification.Name("_GetPermissionsForCameraProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }*/
            
        }
        else if(notifyType == "editgroupmedia")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            //UserDefaults.standard.synchronize()
            /* if(appDelegate().isFromSettings == true){
             let notificationName = Notification.Name("_settingGetPermissionsForMediaProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }
             else{
             let notificationName = Notification.Name("_GetPermissionsForMediaProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }*/
            
        }
        else if(notifyType == "editgroupcamera")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            //UserDefaults.standard.synchronize()
            /* if(appDelegate().isFromSettings == true){
             let notificationName = Notification.Name("_settingGetPermissionsForCameraProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }
             else{
             let notificationName = Notification.Name("_GetPermissionsForCameraProfile")
             NotificationCenter.default.post(name: notificationName, object: nil)
             }*/
            
        }
        else if(notifyType == "location")
        {
            self.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            //UserDefaults.standard.synchronize()
            
           // let notificationName = Notification.Name("_GetPermissionsForLocation")
           // NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "registerlocation")
        {
            self.dismiss(animated: true, completion: nil)
           // UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            //UserDefaults.standard.synchronize()
            
            //let notificationName = Notification.Name("_GetPermissionsForLocationOnRegister")
            //NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "upcomingtrivia" || notifyType == "upcomingtriviadetail" || notifyType == "homelocation")
        {
            self.dismiss(animated: true, completion: nil)
        }
       
        
    }
    @IBAction func notifyAccepted () {
        
        if(notifyType == "notification")
        {
           
            let notify: String? = UserDefaults.standard.string(forKey: "notification")
            if(notify != nil){
                UserDefaults.standard.setValue("YES", forKey: "notification")
                UserDefaults.standard.synchronize()
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self as? UNUserNotificationCenterDelegate
                    center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                        if error == nil {
                            if grant {
                                DispatchQueue.main.async {
                                    // application.registerForRemoteNotifications()
                                    //DispatchQueue.main.async {
                                        UIApplication.shared.registerForRemoteNotifications()
                                    //}
                                }
                            } else {
                                //User didn't grant permission
                                let notificationName = Notification.Name("gotosettingForPush")
                                NotificationCenter.default.post(name: notificationName, object: nil)
                            }
                        } else {
                            print("error: ",error ?? "")
                        }
                    })
                }
            }
            else{
                UserDefaults.standard.setValue("YES", forKey: "notification")
                UserDefaults.standard.synchronize()
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self as? UNUserNotificationCenterDelegate
                    center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                        if error == nil {
                            if grant {
                                DispatchQueue.main.async {
                                    UIApplication.shared.registerForRemoteNotifications()
                                }
                            } else {
                                //User didn't grant permission
                            }
                        } else {
                            print("error: ",error ?? "")
                        }
                    })
                } else {
                    // Fallback on earlier versions
                    let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }
            }
            //DispatchQueue.main.async {
                 self.dismiss(animated: true, completion: nil)
                
            
                
                
            //}
            //End code to register for push notification
            
            // Override point for customization after application launch.
          /*  let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let isShowTeams: String? = UserDefaults.standard.string(forKey: "isShowTeams")
            
            let isShowProfile: String? = UserDefaults.standard.string(forKey: "isShowProfile")
            let isLoggedin: String? = UserDefaults.standard.string(forKey: "isLoggedin")
            if isShowTeams != nil
            {
                self.appDelegate().showMyTeams()
            }
            //Check if user is already logged in
            if isLoggedin == nil || isLoggedin == "NO"
            {
                if isShowTeams != nil
                {
                    self.appDelegate().showMyTeams()
                }
                else
                {
                    if isShowProfile == nil {
                        if (login != nil) {
                            if self.appDelegate().connect() {
                                //show buddy list
                                
                            } else {
                                self.appDelegate().showLogin()
                            }
                        }
                        else
                        {
                            self.appDelegate().showLogin()
                        }
                    }
                    else
                    {
                        //Authenticate and fetch profile data
                        if self.appDelegate().connect() {
                            self.appDelegate().showProfile()
                        }
                        
                    }
                }
                
            }
            else
            {
                if(self.appDelegate().connect())
                {
                    //Get from local user defaults temp
                    let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
                    if localArrAllChats != nil
                    {
                        //Code to parse json data
                        if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                            do {
                                self.appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                                
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                    appDelegate().showMainTab()
                    //End
                }
            }
            
            self.appDelegate().profileAvtarTemp = UIImage(named:"avatar")*/
            
        }
        else if(notifyType == "fanupdatecamera")
        {UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            UserDefaults.standard.synchronize()
            
            self.dismiss(animated: true, completion: nil)
            let notificationName = Notification.Name("_updateGetPermissionsForCameraProfile")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "fanupdatemedia")
        {UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            let notificationName = Notification.Name("_updateGetPermissionsForMediaProfile")
            NotificationCenter.default.post(name: notificationName, object: nil)
           
        }
        else if(notifyType == "contact")
        {
            UserDefaults.standard.setValue("YES", forKey: "notifiedcontact")
            UserDefaults.standard.synchronize()
            
            self.dismiss(animated: true, completion: nil)
            let notificationName = Notification.Name("_GetPermissionsForContact")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "media")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            UserDefaults.standard.synchronize()
            
            let notificationName = Notification.Name("_GetPermissionsForMedia")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "camera")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            UserDefaults.standard.synchronize()
            
            let notificationName = Notification.Name("_GetPermissionsForCamera")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "profilemedia")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            UserDefaults.standard.synchronize()
            if(appDelegate().isFromSettings == true){
                let notificationName = Notification.Name("_settingGetPermissionsForMediaProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
            else{
                let notificationName = Notification.Name("_GetPermissionsForMediaProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
           
        }
        else if(notifyType == "profilecamera")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            UserDefaults.standard.synchronize()
            if(appDelegate().isFromSettings == true){
                let notificationName = Notification.Name("_settingGetPermissionsForCameraProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
            else{
                let notificationName = Notification.Name("_GetPermissionsForCameraProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
           
        }
        else if(notifyType == "groupmedia")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            UserDefaults.standard.synchronize()
           // if(appDelegate().isFromSettings == true){
                let notificationName = Notification.Name("_GroupGetPermissionsForMediaProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
          
            
        }
        else if(notifyType == "groupcamera")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            UserDefaults.standard.synchronize()
           
                let notificationName = Notification.Name("_GroupGetPermissionsForCameraProfile")
                NotificationCenter.default.post(name: notificationName, object: nil)
            
            
        }
        else if(notifyType == "editgroupmedia")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedmedia")
            UserDefaults.standard.synchronize()
            // if(appDelegate().isFromSettings == true){
            let notificationName = Notification.Name("_GroupGetPermissionsForMediaProfileedit")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
            
        }
        else if(notifyType == "editgroupcamera")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedcamera")
            UserDefaults.standard.synchronize()
            
            let notificationName = Notification.Name("_GroupGetPermissionsForCameraProfileedit")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
            
        }
        else if(notifyType == "location")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            UserDefaults.standard.synchronize()
            
            let notificationName = Notification.Name("_GetPermissionsForLocation")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "registerlocation")
        {
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            UserDefaults.standard.synchronize()
            
            let notificationName = Notification.Name("_GetPermissionsForLocationOnRegister")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else if(notifyType == "upcomingtrivia")
        {
            let notificationName = Notification.Name("_GetPermissionsForupcoming")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            UserDefaults.standard.synchronize()
            
            
        }
        else if(notifyType == "upcomingtriviadetail")
        {
            let notificationName = Notification.Name("_GetPermissionsForupcomingdetail")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            UserDefaults.standard.synchronize()
            
            
        }
        else if(notifyType == "homelocation"){
            let notificationName = Notification.Name("_GetlocationPermissionsForhome")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue("YES", forKey: "notifiedlocation")
            UserDefaults.standard.synchronize()
        }

        
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
            NotifyPermissionController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NotifyPermissionController.realDelegate!;
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
/*
 private typealias ScrollView = ViewController
 extension ScrollView
 {
 func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
 // Test the offset and calculate the current page after scrolling ends
 let pageWidth:CGFloat = scrollView.frame.width
 let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
 // Change the indicator
 self.pageControl.currentPage = Int(currentPage);
 // Change the text accordingly
 if Int(currentPage) == 0{
 textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
 }else if Int(currentPage) == 1{
 textView.text = "I write mobile tutorials mainly targeting iOS"
 }else if Int(currentPage) == 2{
 textView.text = "And sometimes I write games tutorials about Unity"
 }else{
 textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
 // Show the "Let's Start" button in the last slide (with a fade in animation)
 UIView.animate(withDuration: 1.0, animations: { () -> Void in
 self.startButton.alpha = 1.0
 })
 }
 }
 }

 */
