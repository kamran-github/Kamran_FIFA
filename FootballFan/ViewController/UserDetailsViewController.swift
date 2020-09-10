//
//  UserDetailsViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 26/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import YPImagePicker
class UserDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
 @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "UserCell"
     @IBOutlet weak var groupimage: UIImageView!
     @IBOutlet weak var edit_groupimage: UIImageView!
    @IBOutlet weak var ibSupportedTeam: UIImageView!
    @IBOutlet weak var ibOpponentTeam: UIImageView!
    @IBOutlet weak var ibBanterSound: UISwitch!
    @IBOutlet weak var ibsoundStatus: UILabel?
     @IBOutlet weak var linkIcon: UIImageView!
    //@IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var SupportedTeamName: UILabel!
    @IBOutlet weak var OpponentTeamName: UILabel!
     @IBOutlet weak var ismute: UIImageView!
    var detSupportedTeam: Int64 = 0
    var detOpponentTeam: Int64 = 0
    var RoomJid: String = ""
     lazy var lazyImage:LazyImage = LazyImage()
    // By Mayank for Group Detail 24 Apr 2018
    @IBOutlet weak var banterImageView: UIView!
    @IBOutlet weak var muteConstraint: NSLayoutConstraint!
    @IBOutlet weak var addUser: UIButton!
    @IBOutlet weak var tableConstraint: NSLayoutConstraint!
    // By Mayank for Group 24 Apr 2018
    @IBOutlet weak var progressView: UIView?
    @IBOutlet weak var progressMessage: UILabel!
    @IBOutlet weak var progressPer: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
      var filePath:URL!
    @IBOutlet weak var teambrImageView: UIView!
    @IBOutlet weak var teambrsupportteam: UIImageView!
    @IBOutlet weak var teambrSupportedTeamName: UILabel!
    var toUserJIDForRoom: String = ""
    var curRoomTypeForRoom: String = "banter"
    var toNameForRoom: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        storyTableView?.reloadData()
        let notificationName = Notification.Name("UserdetailRefresh")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailsViewController.UserdetailRefresh), name: notificationName, object: nil)
         self.navigationItem.rightBarButtonItem = nil
        // Do any additional setup after loading the view.
       // self.groupimage?.contentMode = .scaleAspectFill
        //self.groupimage?.clipsToBounds = true
        
        if(appDelegate().curRoomType == "group")
        {
            self.lazyImage.show(imageView:groupimage!, url:appDelegate().toAvatarURL, defaultImage: "avatar")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate().isOnUserDetailView = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = toNameForRoom
        appDelegate().toName = toNameForRoom
        appDelegate().toUserJID = toUserJIDForRoom
        appDelegate().curRoomType = curRoomTypeForRoom
        appDelegate().isOnUserDetailView = true
        let teamImageName1 = "Team" + detSupportedTeam.description
        let teamImage1: String? = UserDefaults.standard.string(forKey: teamImageName1)
        if((teamImage1) != nil)
        {
            ibSupportedTeam.image = appDelegate().loadProfileImage(filePath: teamImage1!)
        }
        else
        {
            ibSupportedTeam.image = UIImage(named: "team")
        }
        
        let teamImageName2 = "Team" + detOpponentTeam.description
        let teamImage2: String? = UserDefaults.standard.string(forKey: teamImageName2)
        if((teamImage2) != nil)
        {
            ibOpponentTeam.image = appDelegate().loadProfileImage(filePath: teamImage2!)
        }
        else
        {
            ibOpponentTeam.image = UIImage(named: "team")
        }
        let notificationName2 = Notification.Name("_GroupGetPermissionsForMediaProfileedit")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailsViewController.GetPermissionsForMediaProfile), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_GroupGetPermissionsForCameraProfileedit")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailsViewController.GetPermissionsForCameraProfile), name: notificationName3, object: nil)
        edit_groupimage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserDetailsViewController.showImagePicker(_:))))
        edit_groupimage?.isUserInteractionEnabled = true
        
         //print(appDelegate().arrBanterUsers)
        storyTableView?.reloadData()
        if(appDelegate().arrBanterUsers.count > 0){
            let dict1: NSDictionary = appDelegate().arrBanterUsers[0] as! NSDictionary
            RoomJid = dict1.value(forKey: "roomid") as! String
            let array = Bantersound.rows(filter:"toUserJID = '\(RoomJid)'") as! [Bantersound]
           
            if(array.count != 0){
             let disnarysound = array[0]
            let soundValue = disnarysound.value(forKey: "soundValue") as! Int
            if (soundValue == 1) {
                ibBanterSound.setOn(true, animated: false)
                ibsoundStatus?.text = "Sound On"
                ismute.image = UIImage(named:"sound_on")
            } else {
                ibBanterSound.setOn(false, animated: false)
                ibsoundStatus?.text = "Sound Off"
                ismute.image = UIImage(named:"sound_off")
            }
            }
            else{
                ibBanterSound.setOn(true, animated: false)
                ibsoundStatus?.text = "Sound On"
                ismute.image = UIImage(named:"sound_on")
            }
        }
        
        // By Mayank for Group 24 Apr 2018
        if(appDelegate().curRoomType == "group")
        {
          //  self.lazyImage.show(imageView:groupimage!, url:appDelegate().toAvatarURL, defaultImage: "avatar")
             groupimage.isHidden = false
             edit_groupimage.isHidden = false
            addUser.setTitle("Invite to this Group via Link", for: .normal)
            linkIcon.isHidden = false
            banterImageView.isHidden = true
            teambrImageView.isHidden = true
            if(appDelegate().isAdmin == "yes"){
                
               
               // muteConstraint.constant = -110
              // tableConstraint.constant = -20
                //addUser.isHidden = true
                let infoimage   = UIImage(named: "add_block")!
                let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showBlockedUser(sender:)))
                self.navigationItem.rightBarButtonItem = infoButton
            }
            else{
                
               // muteConstraint.constant = -110
                // tableConstraint.constant = -20
               // addUser.isHidden = true
               /* let infoimage   = UIImage(named: "shearbar")!
                let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showInviteUser(sender:)))
                self.navigationItem.rightBarButtonItem = infoButton*/

            }
           
            
        }
            else if(appDelegate().curRoomType == "teambr"){
                banterImageView.isHidden = true
                 groupimage.isHidden = true
                edit_groupimage.isHidden = true
                //addUser.isHidden = true
               // tableConstraint.constant = -20
                teambrImageView.isHidden = false
                linkIcon.isHidden = false
                addUser.setTitle("Invite to this Banter Room via Link", for: .normal)
                /*let infoimage   = UIImage(named: "shearbar")!
                let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showInviteUser(sender:)))
                self.navigationItem.rightBarButtonItem = infoButton*/
            let teamImageName1 = "Team" + detSupportedTeam.description
                   let teamImage1: String? = UserDefaults.standard.string(forKey: teamImageName1)
                   if((teamImage1) != nil)
                   {
                       teambrsupportteam.image = appDelegate().loadProfileImage(filePath: teamImage1!)
                   }
                   else
                   {
                       teambrsupportteam.image = UIImage(named: "team")
                   }
                let array1 = Teams_details.rows(filter:"team_Id = \(detSupportedTeam.description)") as! [Teams_details]
                if(array1.count != 0){
                    let disnarysound = array1[0]
                    
                    _ = disnarysound.team_Id
                    
                    
                    teambrSupportedTeamName!.text = disnarysound.team_name
                }
               
            }
        else {
            banterImageView.isHidden = false
             groupimage.isHidden = true
            edit_groupimage.isHidden = true
            //addUser.isHidden = true
           // tableConstraint.constant = -20
            teambrImageView.isHidden = true
            linkIcon.isHidden = false
            addUser.setTitle("Invite to this Banter Room via Link", for: .normal)
            /*let infoimage   = UIImage(named: "shearbar")!
            let infoButton = UIBarButtonItem(image: infoimage,  style: .plain, target: self, action: #selector(self.showInviteUser(sender:)))
            self.navigationItem.rightBarButtonItem = infoButton*/

            let array1 = Teams_details.rows(filter:"team_Id = \(detSupportedTeam.description)") as! [Teams_details]
            if(array1.count != 0){
                let disnarysound = array1[0]
                
                _ = disnarysound.team_Id
                
                
                SupportedTeamName!.text = disnarysound.team_name
            }
            let array = Teams_details.rows(filter:"team_Id = \(detOpponentTeam.description)") as! [Teams_details]
            if(array.count != 0){
                let disnarysound = array[0]
                
                _ = disnarysound.team_Id
                
                
                OpponentTeamName!.text = disnarysound.team_name
            }
        }
        // By Mayank for Group 24 Apr 2018
        
    }
    @objc func showImagePicker (_ sender: UITapGestureRecognizer) {
        
        
        /* if(!(userIBName?.text?.isEmpty)!)
         {
         UserDefaults.standard.setValue(userIBName?.text, forKey: "userStatus")
         UserDefaults.standard.synchronize()
         }*/
        
        
        let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
        let RemoveAction = UIAlertAction(title: "Delete picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
           
            self.lazyImage.show(imageView:self.groupimage!, url:groupAvtar, defaultImage: "avatar")
            let uuid = UUID().uuidString
            let time: Int64 = self.appDelegate().getUTCFormateDate()
            
            let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
            
            //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
            let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
            let userReadUserJid = arrReadUserJid[0]
            //let myjidtrim: String = userUserJid!
            self.appDelegate().sendMessageToServer(self.appDelegate().toUserJID as AnyObject as! String, messageContent: userReadUserJid + " has changed the group picture.", messageType: "header", messageTime: time, messageId: uuid, roomType: "group", messageSubType: "roomavatarchange", mySupportTeam: 0, JoindUserName: recReadUserJid,roomavatar:groupAvtar)
            self.updategroupavatar(avtarurl: groupAvtar)
        })
        RemoveAction.setValue(UIColor.red, forKey: "titleTextColor")
     
        let saveAction = UIAlertAction(title: "Choose picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Choose Photo")
            //Code to show gallery
         
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized{
                            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                                
                                //Show loader
                                //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
                                // self.activityIndicator?.startAnimating()
                                //LoadingIndicatorView.show(self.view, loadingText: "Showing your photo album.")
                                
                                self.showCustomGallery()
                            }
                        } else {}
                    })
                }
                else if photos == .denied {
                    self.displayPhotoSettingsAlert()
                }
                else if photos == .authorized {
                    
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                        
                       
                        self.showCustomGallery()
                    }
                    
                }
                
                
                
                
                
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
        })
        optionMenu.addAction(RemoveAction)
       // optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    @objc func GetPermissionsForCameraProfile(notification: NSNotification){
        //Code to show camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
           showCustomGallery()
        }
        
    }
    @objc func GetPermissionsForMediaProfile(notification: NSNotification){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            //Show loader
            //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
            // self.activityIndicator?.startAnimating()
            // LoadingIndicatorView.show(self.view, loadingText: "Showing your photo album.")
            
         showCustomGallery()
        }
    }
    func showCustomGallery() {
        DispatchQueue.main.async {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = true
        config.onlySquareImagesFromCamera = false
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
                    //print(photo)
                    
                   
                    self.groupimage?.contentMode = .center
                    self.groupimage?.clipsToBounds = true
                    
                    
                    var tempImg = photo.modifiedImage
                    if(tempImg == nil){
                        tempImg = photo.originalImage
                    }
                    self.groupimage?.image = tempImg
                    //self.getImageThumbnail(asset: photo)
                   
                    
                    break
                case .video( _):
                    //print(video)
                   
                    break
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
            self.sendAvatarImageToPHPAPI()
            
            
        }
        self.present(picker, animated: true, completion: nil)
    }
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            //appDelegate().profileAvtarTemp! = pickedImage
            groupimage?.image = pickedImage
           
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
            
            let fileUrl = docDir.appendingPathComponent("\(imageUniqueName).png")
            
            do{
                if let pngImageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage)!.pngData(){
                    
                    //try pngImageData.write(to : fileUrl , options : .atomic)
                    let myPicture = UIImage(data: pngImageData)!
                    
                    let widthInPixels = myPicture.size.width * myPicture.scale
                    let heightInPixels = myPicture.size.height * myPicture.scale
                    if(widthInPixels > 800 || heightInPixels > 800) {
                        let myThumb1 = myPicture.resized(withPercentage: 0.5)
                        try myThumb1!.jpegData(compressionQuality: 1.0)?.write(to: fileUrl, options: .atomic)
                    } else
                    {
                        try pngImageData.write(to : fileUrl , options : .atomic)
                    }
                    filePath = fileUrl
                    //uploadGroupIcon()
                    
                }
                
            }catch{
                print("couldn't write image")
                
            }
            
            print(filePath as Any)
            
            
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
   @IBAction func soundIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            var msgDict3 = [String: AnyObject]()
            msgDict3["toUserJID"] = RoomJid as AnyObject
            msgDict3["soundValue"] = 1 as AnyObject
            ibsoundStatus?.text = "Sound On"
            ismute.image = UIImage(named:"sound_on")
            _ = appDelegate().db.execute(sql:" UPDATE bantersound SET soundValue = 1 WHERE toUserJID = '\(RoomJid)'")
            
            
        } else {
            var msgDict3 = [String: AnyObject]()
            msgDict3["toUserJID"] = RoomJid as AnyObject
            msgDict3["soundValue"] = 0 as AnyObject
            ibsoundStatus?.text = "Sound Off"
            ismute.image = UIImage(named:"sound_off")
            _ = appDelegate().db.execute(sql:" UPDATE bantersound SET soundValue = 0 WHERE toUserJID = '\(RoomJid)'")
        }
      appDelegate().BantersoundUpdateForNotification()
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
            UserDetailsViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return UserDetailsViewController.realDelegate!;
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(appDelegate().arrBanterUsers.count)
        return appDelegate().arrBanterUsers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = " Fans in this Banter Room"
        // By Mayank for group chat
        if(appDelegate().curRoomType == "banter" || appDelegate().curRoomType == "teambr")
        {
            label.text = " Fans in this Banter Room"
        }
        else if(appDelegate().curRoomType == "group")
        {
            label.text = " Fans in this Group"
        }
        label.textColor=UIColor(hex: "FFFFFF")
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UserCell
        //print(phoneFilteredContacts)
        
        //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
        let dict: NSDictionary = appDelegate().arrBanterUsers[indexPath.row] as! NSDictionary
        let recReadUserJid: String = (dict.value(forKey: "username") as? String)!
        //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
        
        let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
        let userReadUserJid = arrReadUserJid[0]
        cell.optionName?.text = userReadUserJid
        cell.optionStatus?.text = dict.value(forKey: "status") as? String
        let isadmin: Int = dict.value(forKey: "isAdmin") as! Int
        let isblocked: String = dict.value(forKey: "userstatus") as! String
        cell.optionIsAdmin?.isHidden = false
         let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if (isadmin == 1) {
            cell.optionIsAdmin?.text = "Manager"
            cell.optionIsAdmin?.textColor = UIColor.red
            
           /* if(login == recReadUserJid){
                 cell.optionName?.text = "You"
            }*/
        }
        else if(isblocked == "blocked"){
            cell.optionIsAdmin?.text = "Blocked"
            cell.optionIsAdmin?.textColor = UIColor.red
        }
        else{
            cell.optionIsAdmin?.isHidden = true
        }
        if(login == recReadUserJid){
             cell.optionName?.text = "You"
            cell.btnFollowed.isHidden = true

        }
        else{
            let isfollowed = dict.value(forKey: "followed") as! Bool
                       if(isfollowed){
                                                 cell.btnFollowed?.setTitle("Unfollow" , for: UIControl.State.normal)
                                                 cell.btnFollowed.backgroundColor = UIColor.init(hex: "AAAAAA")
                                                    }
                                                    else{
                                                        cell.btnFollowed?.setTitle("Follow" , for: UIControl.State.normal)
                                                  cell.btnFollowed.backgroundColor = UIColor.init(hex: "2185F7")
                                                    }
                       cell.btnFollowed.isHidden = false
            let longPressGesture_follow:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followClick(_:)))
                       //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                       longPressGesture_follow.delegate = self as? UIGestureRecognizerDelegate
                       
                       
                       cell.btnFollowed?.addGestureRecognizer(longPressGesture_follow)
                       cell.btnFollowed?.isUserInteractionEnabled = true
                       
        }
        if ((dict.value(forKey: "supportteam") != nil))
        {
            // By Mayank for group chat
            if(appDelegate().curRoomType == "banter")
            {
                //print(dict2?.value(forKey: "supportedTeam") ?? "")
                let teamId = dict.value(forKey: "supportteam") as! Int
                
                let teamImageName = "Team" + teamId.description //String(describing: dict2?.value(forKey: "supportedTeam"))
                //print("Team Image Name: " + teamImageName)
                
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    cell.optionImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    /*if(cell.chatImage?.image == nil)
                     {
                     appDelegate().loadImageFromUrl(url: appDelegate().primaryTeamLogo,view: (cell.chatImage)!, fileName: teamImageName as String)
                     }*/
                }
                else
                {
                    cell.optionImage?.image = UIImage(named: "team")
                }
            } else
            {
                if(dict.value(forKey: "avatar") != nil)
                {
                    let avatar:String = (dict.value(forKey: "avatar") as? String)!
                    if(!avatar.isEmpty)
                    {
                        //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                        appDelegate().loadImageFromUrl(url: avatar, view: cell.optionImage!)
                        
                    }
                }
                else
                {
                    cell.optionImage?.image = UIImage(named: "user")
                }
                cell.optionImage?.layer.masksToBounds = true;
                //optionImage?.layer.borderWidth = 1.0
                // optionImage?.layer.borderColor = self.contentView.tintColor.cgColor
                //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
                cell.optionImage?.layer.cornerRadius = 30.0
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let dict: NSDictionary = appDelegate().arrBanterUsers[indexPath.row] as! NSDictionary
        let jid = (dict.value(forKey: "jid") as? String)!
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(appDelegate().isAdmin == "yes"){
            if (jid != login) {
                
                leaveBanterRoom(dict: dict)
                
            }
        }
        else{
            if (jid != login) {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                 let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                myTeamsController.RoomJid = dict.value(forKey: "jid") as! String //+ JIDPostfix
                                 show(myTeamsController, sender: self)
                                
                /* self.appDelegate().isJoined = "yes"
                self.appDelegate().curRoomType = "chat"
                appDelegate().isBanterClosed = ""
            appDelegate().toUserJID = (dict.value(forKey: "jid") as? String)!
                let recReadUserJid = (dict.value(forKey: "username") as? String)!
                
                let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                let userReadUserJid = arrReadUserJid[0]
                
            appDelegate().toName = userReadUserJid//(dict.value(forKey: "username") as? String)!
            if let tmpAvatar = dict.value(forKey: "avatar")
            {
                appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
            }
            else
            {
                appDelegate().toAvatarURL = ""
            }
               
            showChatWindow()*/
            }
        }
       
        
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    @IBAction func showBlockedUser(sender:UIButton)
    {
       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : FanContactListViewController = storyBoard.instantiateViewController(withIdentifier: "FanContactList") as! FanContactListViewController
        //  appDelegate().isFromSettings = true
        //show(myTeamsController, sender: self)
        myTeamsController.AddType = "AddNew"
        show(myTeamsController, sender: self)
       // self.present(myTeamsController, animated: true, completion: nil)
        //inviteFan()
    }
    @objc func followClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
         //print("Comment Click")
         
         let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
         if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
             
             let dict: NSDictionary? =  appDelegate().arrBanterUsers[indexPath.row] as? NSDictionary
             // print(dict)
             if ClassReachability.isConnectedToNetwork()
             {
                 let isfollowed: Bool = dict?.value(forKey: "followed") as! Bool
                 if(isfollowed){
                     
                     var dict1: [String: AnyObject] =  appDelegate().arrBanterUsers[indexPath.row] as! [String: AnyObject]
                     dict1["followed"] = false as AnyObject
                     
                      appDelegate().arrBanterUsers[indexPath.row] = dict1 as AnyObject
                 }
                 else{
                     
                     var dict1: [String: AnyObject] =  appDelegate().arrBanterUsers[indexPath.row] as! [String: AnyObject]
                     dict1["followed"] = true as AnyObject
                     
                      appDelegate().arrBanterUsers[indexPath.row] = dict1 as AnyObject
                     
                 }
                     
                 SaveFollow(followusername: dict?.value(forKey: "jid") as! String)
                storyTableView?.reloadData()
                 }
                 else {
                     self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                     
                 }
             }
         }
    func SaveFollow(followusername : String)  {
              if ClassReachability.isConnectedToNetwork()
              {
                  var dictRequest = [String: AnyObject]()
                  dictRequest["cmd"] = "savefollowers" as AnyObject
                  dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                  dictRequest["device"] = "ios" as AnyObject
                  
                  let time: Int64 = self.appDelegate().getUTCFormateDate()
                  //Creating Request Data
                  var dictRequestData = [String: AnyObject]()
                  
                  let login: String? = UserDefaults.standard.string(forKey: "userJID")
                  let arrReadUserJid = login?.components(separatedBy: "@")
                  let myMobile: String? = arrReadUserJid?[0]
                  let followusernameUserJid = followusername.components(separatedBy: "@")
                   let    followusername1: String? = followusernameUserJid[0]
                  
                  dictRequestData["username"] = myMobile as AnyObject
                  dictRequestData["followusername"] = followusername1 as AnyObject
                  dictRequestData["type"] = "fan" as AnyObject
                  dictRequestData["time"] = time as AnyObject
                  
                  dictRequest["requestData"] = dictRequestData as AnyObject
                  AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                    headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                      // 2
                      .responseJSON { response in
                        switch response.result {
                                                                  case .success(let value):
                                                                      if let json = value as? [String: Any] {
                                                                          // print(" JSON:", json)
                                                                          let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                          // self.finishSyncContacts()
                                                                          //print(" status:", status1)
                                                                          if(status1){
                                                                              // self.isfollowed = json["followed"]
                                                                              
                                                                          }
                                                                          else{
                                                                              
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                            debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                         
                  }
                  
              }
              else {
                  alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                  
              }
          }
    @IBAction func showInviteUser(sender:UIButton)
    {
        /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let myTeamsController : FanContactListViewController = storyBoard.instantiateViewController(withIdentifier: "FanContactList") as! FanContactListViewController
         //  appDelegate().isFromSettings = true
         //show(myTeamsController, sender: self)
         myTeamsController.AddType = "AddNew"
         show(myTeamsController, sender: self)
         // self.present(myTeamsController, animated: true, completion: nil)*/
        inviteFan()
    }
    func inviteFan()
    {
        do {
            let roomjid = appDelegate().toUserJID
            let arrdUserJid = roomjid.components(separatedBy: "@")
            let userUserJid = arrdUserJid[0]
            let myjidtrim: String? = userUserJid
            
            var dictRequest = [String: AnyObject]()
            dictRequest["id"] = myjidtrim as AnyObject
            dictRequest["type"] = "roominvite" as AnyObject
            let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            print(appDelegate().toName)
            let title = appDelegate().toName
            
            let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            
            let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
            
            let param = resultNSString as String?
            
            let inviteurl = InviteHost + "?q=" + param!
            var text = ""
            if(appDelegate().curRoomType == "group")
            {
                text = "Open following link to join my Group on Football Fan app:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."
            } else if (appDelegate().curRoomType == "banter")
            {
               
                let team1:String = SupportedTeamName.text!
                let team2:String = OpponentTeamName.text!
                text = "Join this cool Banter Room \"\(title)\" between Fans of \"\( String(describing: team1))\" and \"\(String(describing: team2))\" on Football Fan app.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."//title + "\n\nBanter Invite shared via Football Fan App.\n\nPlease follow the link:\n"
            }
            else if (appDelegate().curRoomType == "teambr")
            {
                text = "Join this cool \"\(title)\" Room on Football Fan app.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."

            }
            
             //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                                                                               
                                                                                 let objectsToShare = [text] as [Any]
                                                                                                                       let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                                                                                       
                                                                                                                       //New Excluded Activities Code
                                                                                                                       activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                                                                                                       //
                                                                                                                       
                                                                                                               activityVC.popoverPresentationController?.sourceView = self.view
                                                                                                                       self.present(activityVC, animated: true, completion: nil)
            //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
 
    @objc func UserdetailRefresh()
    {
        //print(appDelegate().arrAllChats)
        //print(appDelegate().toUserJID)
        if(appDelegate().arrBanterUsers.count > 0){
            let dict1: NSDictionary = appDelegate().arrBanterUsers[0] as! NSDictionary
            RoomJid = dict1.value(forKey: "roomid") as! String
            let array = Bantersound.rows(filter:"toUserJID = '\(RoomJid)'") as! [Bantersound]
            let disnarysound = array[0]
            
            let soundValue = disnarysound.value(forKey: "soundValue") as! Int
            if (soundValue == 1) {
                ibBanterSound.setOn(true, animated: false)
                ibsoundStatus?.text = "Sound On"
                ismute.image = UIImage(named:"sound_on")
            } else {
                ibBanterSound.setOn(false, animated: false)
                ibsoundStatus?.text = "Sound Off"
                ismute.image = UIImage(named:"sound_off")
            }
        }
        else{
           // alertWithTitle(title: "Error", message: "Some", ViewController: self)
            
        }
        
       
            self.storyTableView?.reloadData()
       
        print("banter room refersh")
        //storyTableView?.layoutIfNeeded()
        //self.scrollToBottom()
       // isAutoScroll = true
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    @IBAction func cancelForward () {
        self.dismiss(animated: true, completion: nil)
    }
    func sendAvatarImageToPHPAPI()
    {
        //let login: String? = UserDefaults.standard.string(forKey: "registerusername")
        TransperentLoadingIndicatorView.show(self.view, loadingText: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            TransperentLoadingIndicatorView.hide()
        }
        let boundary = appDelegate().generateBoundaryString()
        var request = URLRequest(url: URL(string: MediaAPI)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var reqParams = [String: String]()
        reqParams["cmd"] = "groupavatar"
        //reqParams["jid"] = login
        reqParams["key"] = "kXfqS9wUug6gVKDB"  
        // self.dismiss(animated: false, completion: nil)
        // self.dismiss(animated: true, completion: nil)
        request.httpBody = appDelegate().createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: (groupimage?.image)!) as Data
        
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
                            // self.appDelegate().saveProfileImageURL(self.appDelegate().profileAvtarTemp!, strAvatarURL: avatarLink)
                            self.appDelegate().toAvatarURL = avatarLink
                            let uuid = UUID().uuidString
                            let time: Int64 = self.appDelegate().getUTCFormateDate()
                            
                            let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
                            
                            //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                            let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
                            let userReadUserJid = arrReadUserJid[0]
                            //let myjidtrim: String = userUserJid!
                            self.appDelegate().sendMessageToServer(self.appDelegate().toUserJID as AnyObject as! String, messageContent: userReadUserJid + " has changed the group picture.", messageType: "header", messageTime: time, messageId: uuid, roomType: "group", messageSubType: "roomavatarchange", mySupportTeam: 0, JoindUserName: recReadUserJid,roomavatar:avatarLink)
                             // LoadingIndicatorView.hide()
                            self.updategroupavatar(avtarurl: avatarLink)
                        }
                        else
                        {
                            TransperentLoadingIndicatorView.hide()
                            //Show Error
                            print("Profile Image Fail.")
                        }
                    } catch let error as NSError {
                        print(error)
                        //Show Error
                        TransperentLoadingIndicatorView.hide()
                    }
                    
                }
            }
            else
            {
                TransperentLoadingIndicatorView.hide()
                //Show Error
            }
        })
        task.resume()
    }
    
    func leaveBanterRoom (dict: NSDictionary) {
        let recReadUserJid: String = (dict.value(forKey: "username") as? String)!
        //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
        
        let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
        let userReadUserJid = arrReadUserJid[0]
        var title = "Block"
        var messages = "Do you really want to block "+userReadUserJid+"?"
        let UserStaus = (dict.value(forKey: "userstatus") as? String)!
        if(UserStaus == "active")
        {
            title = "Block"
            messages = "Do you really want to block "+userReadUserJid+"?"
        }
        else
        {
            title = "Unblock"
            messages = "Do you really want to unblock "+userReadUserJid+"?"
        }
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let team1Action = UIAlertAction(title: title, style: .default, imageNamed: "uncheck", handler: {
            (alert: UIAlertAction!) -> Void in
            let alert = UIAlertController(title: "", message: messages, preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel,handler: {_ in
                
                  if ClassReachability.isConnectedToNetwork()
                    {
                       // self.adminDeleteBanterRoom ()
                        let jid = (dict.value(forKey: "jid") as? String)!
                        if(UserStaus == "active"){
                            self.appDelegate().RoomuserBlock(roomid: self.appDelegate().toUserJID, roomtype: self.appDelegate().curRoomType, blockuser: jid)
                            //Calling this room users
                            /*var dictRequest = [String: AnyObject]()
                            dictRequest["cmd"] = "blockuserinroom" as AnyObject
                            
                            //Creating Request Datap
                            var dictRequestData = [String: AnyObject]()
                            //let messagecontent = bestAttemptContent.body
                            let arrReadUserJid = jid.components(separatedBy: "@")
                            let username: String = arrReadUserJid[0]
                            dictRequestData["roomid"] = self.appDelegate().toUserJID as AnyObject
                            dictRequestData["roomtype"] = self.appDelegate().curRoomType as AnyObject
                            dictRequestData["username"] = username as AnyObject //appDelegate().toUserJID as AnyObject
                            dictRequest["requestData"] = dictRequestData as AnyObject
                            //dictRequest.setValue(dictMobiles, forKey: "requestData")
                            //print(dictRequest)
                            do {
                                let dataMyTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                let strMyTeams = NSString(data: dataMyTeams, encoding: String.Encoding.utf8.rawValue)! as String
                                //print(strMyTeams)
                                self.appDelegate().sendRequestToAPI(strRequestDict: strMyTeams)
                            } catch {
                               // print(error.localizedDescription)
                            }*/
                            
                        }
                        else{
                            self.appDelegate().RoomuserUnBlock(roomid:self.appDelegate().toUserJID, roomtype: self.appDelegate().curRoomType, blockuser: jid)
                            /*var dictRequest = [String: AnyObject]()
                            dictRequest["cmd"] = "unblockuserinroom" as AnyObject
                            
                            //Creating Request Datap
                            var dictRequestData = [String: AnyObject]()
                            //let messagecontent = bestAttemptContent.body
                            let arrReadUserJid = jid.components(separatedBy: "@")
                            let username: String = arrReadUserJid[0]
                            dictRequestData["roomid"] = self.appDelegate().toUserJID as AnyObject
                            dictRequestData["roomtype"] = self.appDelegate().curRoomType as AnyObject
                            dictRequestData["username"] = username as AnyObject //appDelegate().toUserJID as AnyObject
                            dictRequest["requestData"] = dictRequestData as AnyObject
                            //dictRequest.setValue(dictMobiles, forKey: "requestData")
                            //print(dictRequest)
                            do {
                                let dataMyTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                let strMyTeams = NSString(data: dataMyTeams, encoding: String.Encoding.utf8.rawValue)! as String
                                //print(strMyTeams)
                                self.appDelegate().sendRequestToAPI(strRequestDict: strMyTeams)
                            } catch {
                                //print(error.localizedDescription)
                            }*/
                        }
                    }
                    else {
                       // self.alertWithTitle(title: "Error", message: "Please check your Internet connection to close this Banter Room.", ViewController: self)
                        
                    }
               
                
            });
            let action1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default,handler: {_ in
                
            });
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion:nil)
            
            
        })
        let team2Action = UIAlertAction(title: "Message", style: .default, imageNamed: "uncheck" , handler: {
            (alert: UIAlertAction!) -> Void in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                            let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                           myTeamsController.RoomJid = dict.value(forKey: "jid") as! String //+ JIDPostfix
                            self.show(myTeamsController, sender: self)
             /*self.appDelegate().isJoined = "yes"
            self.appDelegate().curRoomType = "chat"
            self.appDelegate().isBanterClosed = ""
            self.appDelegate().toUserJID = (dict.value(forKey: "jid") as? String)!
            let recReadUserJid = (dict.value(forKey: "username") as? String)!
            
            let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
            let userReadUserJid = arrReadUserJid[0]
            
            self.appDelegate().toName = userReadUserJid//(dict.value(forKey: "username") as? String)!
            if let tmpAvatar = dict.value(forKey: "avatar")
            {
                self.appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
            }
            else
            {
                self.appDelegate().toAvatarURL = ""
            }
            self.showChatWindow()*/
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            //print("Cancelled")
        })
        optionMenu.addAction(team1Action!)
        optionMenu.addAction(team2Action!)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
        
        
        
        
        
        
    }
    func updategroupavatar(avtarurl:String)
    {
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "updategroupavatar" as AnyObject
        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
        dictRequest["device"] = "ios" as AnyObject
        do {
             
            var dictRequestData = [String: AnyObject]()
            
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let arrReadUserJid = login?.components(separatedBy: "@")
            let myMobile: String? = arrReadUserJid?[0]
            let arrReadChatJid = appDelegate().toUserJID.components(separatedBy: "@")
            let to: String? = arrReadChatJid[0]
            //appDelegate().mySupportedTeam = joinTeamId
            dictRequestData["roomid"] = to as AnyObject//appDelegate().toUserJID as AnyObject
           
            dictRequestData["username"] = myMobile as AnyObject
            
            dictRequestData["avatar"] = avtarurl as AnyObject//appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbanterth)
            dictRequest["requestData"] = dictRequestData as AnyObject
           
      /*  let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                                                                                          // print(" JSON:", json)
                                                                                                                                                          let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                                                                                                          // self.finishSyncContacts()
                                                                                                                                                          //print(" status:", status1)
                                                                                                                                                       if(status1){
                                                                                                                                                              
                                                                                                                                                          }
                                                                                                                                                          else{
                                                                                                                                                                                                            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
