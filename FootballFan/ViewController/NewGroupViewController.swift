//
//  NewGroupViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 13/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import Photos
import YPImagePicker
class NewGroupViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var storyTableView: UITableView?
    @IBOutlet weak var groupSubject: UITextField?
    var phoneFilteredContacts = NSMutableArray()
    let cellReuseIdentifier = "newgroup"
    var searchActive : Bool = false
    var searchStarting : Bool = false
     @IBOutlet weak var groupnamecountlabel: UILabel?
    @IBOutlet weak var viewSubject: UIView?
    lazy var lazyImage:LazyImage = LazyImage()
     @IBOutlet weak var Imggroup: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        groupSubject?.delegate = self
        //self.storyTableView?.allowsMultipleSelection = true
        self.lazyImage.show(imageView:Imggroup!, url:groupAvtar, defaultImage: "avatar")
        Imggroup?.layer.masksToBounds = true;
        Imggroup?.layer.borderWidth = 1.0
        Imggroup?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        Imggroup?.layer.cornerRadius = 25.0
        Imggroup?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewGroupViewController.showImagePicker(_:))))
        Imggroup?.isUserInteractionEnabled = true
        
        let notificationName2 = Notification.Name("_GroupGetPermissionsForMediaProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewGroupViewController.GetPermissionsForMediaProfile), name: notificationName2, object: nil)
        
        let notificationName3 = Notification.Name("_GroupGetPermissionsForCameraProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewGroupViewController.GetPermissionsForCameraProfile), name: notificationName3, object: nil)
      
        storyTableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewGroupViewController.minimiseKeyboard(_:))))
        viewSubject?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewGroupViewController.minimiseKeyboard(_:))))
        // Do any additional setup after loading the view.
        let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
        if strAllContacts != nil
        {
            //Code to parse json data
            if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    //appDelegate().allContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray as! NSMutableArray
                    let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                    
                    appDelegate().allContacts = NSMutableArray()
                    for record in tmpAllContacts {
                        appDelegate().allContacts[appDelegate().allContacts.count] = record
                    }
                    
                    //appDelegate().allContacts = tmpAllAppContacts as! NSMutableArray
                    //appDelegate().allAppContacts = appDelegate().allContacts[0] as! NSMutableArray
                    
                    let tmpAllAppContacts = appDelegate().allContacts[0] as! NSArray
                    
                    appDelegate().allAppContacts = NSMutableArray()
                    for record in tmpAllAppContacts {
                        appDelegate().allAppContacts[appDelegate().allAppContacts.count] = record
                    }
                    
                    //print(appDelegate().allAppContacts)
                    
                    /*var size = 0
                     repeat {
                     let colour = "clear"
                     tmpSelected.add(colour)
                     // Increment.
                     size += 1
                     
                     } while size < appDelegate().allAppContacts.count*/
                    let tmpArryContact = NSMutableArray()
                    if(appDelegate().allAppContacts.count > 0)
                    {
                        for rec in appDelegate().allAppContacts
                        {
                            var dict: [String : String] = rec as! [String : String]
                            dict["image"] = "uncheck"
                            tmpArryContact[tmpArryContact.count] = dict
                        }
                    }
                    
                    if(tmpArryContact.count > 0)
                    {
                        appDelegate().allAppContacts = tmpArryContact
                    }
                    
                    
                    //print(tmpSelected.count)
                    //print(appDelegate().allAppContacts.count)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        let notificationName = Notification.Name("_GroupChatCreated")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(NewGroupViewController.groupChatCreated), name: notificationName, object: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //let newImageData = UIImageJPEGRepresentation(image, 1)
        //userIBAvtar!.image = UIImage(data: newImageData!)
        //userIBAvtar!.image = image
        //appDelegate().isAvtarChanged = true
       // appDelegate().profileAvtarTemp! = image!
        //userIBAvtar!.image = appDelegate().profileAvtarTemp!
        //userIBAvtar!.setImage(appDelegate().profileAvtarTemp!, for: UIControlState.normal)
        self.dismiss(animated: true, completion: nil)
        
       // appDelegate().showCropAvtar()
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
          
            //dismiss(animated: true, completion: nil)
            // dismiss(animated: true)
            // dismiss(animated: true, completion: nil)
           Imggroup?.image = pickedImage
            // appDelegate().showCropAvtar()
            
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    @objc func showImagePicker (_ sender: UITapGestureRecognizer) {
        
        
        /* if(!(userIBName?.text?.isEmpty)!)
         {
         UserDefaults.standard.setValue(userIBName?.text, forKey: "userStatus")
         UserDefaults.standard.synchronize()
         }*/
        
        
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
       /* let RemoveAction = UIAlertAction(title: "Delete Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
           
            /*self.userIBAvtar?.layer.masksToBounds = true;
            self.userIBAvtar?.clipsToBounds=true;
            self.userIBAvtar?.layer.borderWidth = 1.0
            self.userIBAvtar?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor//UIColor(red:255.0, green: 212.0, blue: 1.0, alpha: 1.0).cgColor
            self.userIBAvtar?.contentMode =  UIViewContentMode.scaleAspectFit
            self.userIBAvtar?.layer.cornerRadius = 55.0
            //userIBAvtar?.image = appDelegate().profileAvtarTemp!
            */
            self.lazyImage.show(imageView:self.Imggroup!, url:groupAvtar, defaultImage: "avatar")
        })
        RemoveAction.setValue(UIColor.red, forKey: "titleTextColor")*/
        
        let saveAction = UIAlertAction(title: "Choose Image", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Choose Photo")
            //Code to show gallery
             self.showCustomGallery()
           /* let notifiedCam: String? = UserDefaults.standard.string(forKey: "notifiedcamera")
            let notified: String? = UserDefaults.standard.string(forKey: "notifiedmedia")
            if notified == nil && notifiedCam == nil
            {
                //Show notify before get permissions
                let popController: NotifyPermissionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Notify") as! NotifyPermissionController
                
                // set the presentation style
                popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                //popController.modalPresentationStyle = .popover
                popController.modalTransitionStyle = .crossDissolve
                
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                popController.popoverPresentationController?.delegate = self //as? UIPopoverPresentationControllerDelegate
                popController.popoverPresentationController?.sourceView = self.view // button
                //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
                popController.notifyType = "groupmedia"
                self.appDelegate().isFromSettings = true
                // present the popover
                self.present(popController, animated: true, completion: nil)
            }
            else
            {
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
                        
                        //Show loader
                        //self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: self.view)
                        // self.activityIndicator?.startAnimating()
                        // LoadingIndicatorView.show(self.view, loadingText: "Showing your photo album.")
                        
                        self.showCustomGallery()
                    }
                    
                }
                
                
                
                
                
            }*/
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
        })
        //optionMenu.addAction(RemoveAction)
       // optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
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
    func showCustomGallery() {
        
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
                    
                    
                   // self.groupimage?.contentMode = .scaleAspectFill
                   // self.groupimage?.clipsToBounds = true
                    
                    
                    var tempImg = photo.modifiedImage
                    if(tempImg == nil){
                        tempImg = photo.originalImage
                    }
                    self.Imggroup?.image = tempImg
                    //self.getImageThumbnail(asset: photo)
                   // self.sendAvatarImageToPHPAPI()
                    
                    
                    break
                case .video(let video):
                    //print(video)
                    
                    break
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
            
            
        }
        present(picker, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func groupChatCreated()
    {
        self.appDelegate().groupJIDs = [String]()
        self.appDelegate().strGroupJIDs = [AnyObject]()
        //self.activityIndicator?.stopAnimating()
        self.appDelegate().isJoiningBanterRoom = false
        self.dismiss(animated: true, completion: nil)
    }

    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            groupSubject?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(searchActive) {
            return "Search Results"
        }
        
        return "Football Fan Contacts"
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive){
            return phoneFilteredContacts.count
        }
        
        return appDelegate().allAppContacts.count//((appDelegate().allAppContacts as AnyObject).count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewGroupCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! NewGroupCell
        //print(phoneFilteredContacts)
        if(searchActive){
            //let arry: NSArray? = phoneFilteredContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            cell.contactImage?.isHidden = true
            //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
            cell.contactName?.frame.origin.x = 15.0
            cell.contactStatus?.frame.origin.x = 15.0
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
            if(cell.isSelected)
            {
                //cell.pickContact?.backgroundColor = cell.contentView.tintColor
            }
            else
            {
               // cell.pickContact?.backgroundColor = UIColor.clear
            }
            
        }
        else
        {
            //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
            let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            
            if(dict?.value(forKey: "avatar") != nil)
            {
                let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                if(!avatar.isEmpty)
                {
                    //appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                    let arrReadselVideoPath = avatar.components(separatedBy: "/")
                    let imageId = arrReadselVideoPath.last
                    let arrReadimageId = imageId?.components(separatedBy: ".")
                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/fanupdateprofile/" + arrReadimageId![0] + ".png")
                   // let url = NSURL(string: avatar)!
                   // let filenameforupdate = arrReadimageId![0] as String
                    do {
                        let fileManager = FileManager.default
                        //try fileManager.removeItem(atPath: imageId)
                        // Check if file exists
                        if fileManager.fileExists(atPath: paths) {
                            // Delete file
                            //print("File  exist")
                            
                            if(!paths.isEmpty)
                            {
                                //let path_file = "file://" + paths
                                let imageURL = URL(fileURLWithPath: paths)
                                cell.contactImage?.image = UIImage(contentsOfFile: imageURL.path)
                            }
                        } else {
                            // print("File does not exist")
                            // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                            self.lazyImage.show(imageView:cell.contactImage!, url:avatar, defaultImage: "avatar")
                        }
                    }catch let error as NSError {
                            print("An error took place: \(error)")
                            // LoadingIndicatorView.hide()
                            
                        }
                    //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                }
                else
                {
                    cell.contactImage?.image = UIImage(named: "avatar")
                }
            }
            else
            {
                cell.contactImage?.image = UIImage(named: "avatar")
            }
            
            /*if( dict?.value(forKey: "colour") as? String == "blue")
             {
             //cell.pickContact?.backgroundColor = UIColor.blue
             
             }
             else
             {
             cell.pickContact?.backgroundColor = UIColor.clear
             }*/
            cell.pickContact?.image = UIImage(named: (dict?.value(forKey: "image") as? String)!)
            
            
            //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! NewGroupCell
        
        //tmpSelected.add(indexPath)
        cell.isForward = true
        //cell.pickContact?.backgroundColor = cell.contentView.tintColor
        //print(tmpSelected)
        //let colour = cell.contentView.tintColor
        
        //let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
        //dict?.setValue("blue", forKey: "colour")
        cell.pickContact?.image = UIImage(named: "check")
        
        var dict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        dict["image"] = "check"
        appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict)
        
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewGroupCell
        //cell.isForward = false
        //cell.pickContact?.backgroundColor = UIColor.clear
        cell.pickContact?.image = UIImage(named: "uncheck")
        //var tmpDict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        //tmpDict["colour"] = "clear"
        //appDelegate().allAppContacts[indexPath.row] = tmpDict
        
        var dict: [String : String] = appDelegate().allAppContacts[indexPath.row] as! [String : String]
        dict["image"] = "uncheck"
        appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict)
        //appDelegate().allAppContacts[indexPath.row] = dict
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
        
    }
    
    
    
    
    /*func pickContact(_ sender: UIButton!)
     {
     
     //var indexPath: NSIndexPath!
     
     
     if let superview = sender.superview {
     if let cell = superview.superview as? NewGroupCell {
     if(cell.isSelected)
     {
     cell.isSelected = false
     cell.pickContact?.setTitle("C", for: UIControlState.normal)
     }
     else
     {
     cell.isSelected = true
     cell.pickContact?.setTitle("S", for: UIControlState.normal)
     }
     
     }
     }
     }*/
    
    @IBAction func cancelGroup () {
        
        groupSubject?.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createGroup () {
          groupSubject?.endEditing(true)
        DispatchQueue.main.async {
            if ClassReachability.isConnectedToNetwork() {
                    
            let thereWereErrors = self.checkForErrors()
            if !thereWereErrors
            {
                let allSelected = self.storyTableView?.indexPathsForSelectedRows
                //print(allSelected ?? " Failed")
                if(self.appDelegate().isUserOnline){
                if((allSelected?.count)! > 0)
                {
                    self.sendAvatarImageToPHPAPI()

                     let login: String? = UserDefaults.standard.string(forKey: "userJID")
                    let varMobile = login?.split{$0 == "@"}.map(String.init)
                    var tempDict1 = [String: String]()
                    tempDict1["username"] = varMobile?[0]
                    self.appDelegate().strGroupJIDs.append( tempDict1 as AnyObject)
                    for sel in allSelected!
                    {
                        let indexP: NSIndexPath = sel as NSIndexPath
                        if let tmpDict: [String : String] = self.appDelegate().allAppContacts[indexP.row] as? [String : String]
                        {
                            
                            let jid: String = tmpDict["jid"]!
                            self.appDelegate().groupJIDs.append(jid)
                            
                            let varMobile = jid.split{$0 == "@"}.map(String.init)
                            var tempDict1 = [String: String]()
                            tempDict1["username"] = varMobile[0]
                            self.appDelegate().strGroupJIDs.append( tempDict1 as AnyObject)
                           
                            
                        }
                    }
                }
                self.appDelegate().curRoomType = "group"
                //self.appDelegate().groupName = (self.groupSubject?.text!)!
                self.appDelegate().banterRoomName = (self.groupSubject?.text!)!
                
                //Create new group
                let code = self.appDelegate().shortCodeGenerator(length: 5)
                let ticks = String(Date().ticks)
                self.appDelegate().groupId = code + ticks + "@conference." + HostName
                }
                 else{
                    self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self, toFocus:self.groupSubject!)
                }
               
                //print(result)
                
            }
            } else {
                self.alertWithTitle(title: nil, message: "Please check your Internet connection to create this Banter Room.", ViewController: self, toFocus:self.groupSubject!)
                       
                   }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func groupSubjecttxtchange(){
        
        
        groupnamecountlabel?.text=String(describing: groupSubject?.text?.count ?? 0)+"/"+String(describing: groupSubject?.maxLength ?? 0)
        
    }
    func sendAvatarImageToPHPAPI()
    {
        //let login: String? = UserDefaults.standard.string(forKey: "registerusername")
       LoadingIndicatorView.show(self.view, loadingText: "Please wait while creating Group")
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
        request.httpBody = appDelegate().createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: (Imggroup?.image)!) as Data
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    //print(stringData) //JSONSerialization
                    
                    
                    
                    //print(time)
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                        
                        let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                        
                        if(isSuccess)
                        {
                            let avatarLink = (jsonData?.value(forKey: "link") as? String)!
                           // self.appDelegate().saveProfileImageURL(self.appDelegate().profileAvtarTemp!, strAvatarURL: avatarLink)
                             LoadingIndicatorView.hide()
                            self.appDelegate().Groupimagelink = avatarLink
                             _ = self.appDelegate().joinRoom(with: self.appDelegate().groupId, delegate: self.appDelegate())
                           
                        }
                        else
                        {
                             LoadingIndicatorView.hide()
                            //Show Error
                            print("Profile Image Fail.")
                        }
                    } catch let error as NSError {
                        print(error)
                        //Show Error
                         LoadingIndicatorView.hide()
                    }
                    
                }
            }
            else
            {
                 LoadingIndicatorView.hide()
                //Show Error
            }
        })
        task.resume()
    }
    func checkForErrors() -> Bool
    {
        var errors = false
       // let title = "Error"
        var message = ""
        
        let allSelected = self.storyTableView?.indexPathsForSelectedRows
        
        if (groupSubject?.text?.isEmpty)! {
            errors = true
            message += "Please enter name of group"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.groupSubject!)
            
        }
        else if( allSelected == nil)
        {
            errors = true
            message += "Please select atlease 1 fan"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.groupSubject!)
        }
        
        return errors
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField, isFocus: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            if(isFocus)
            {
                toFocus.becomeFirstResponder()
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }

    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            NewGroupViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return NewGroupViewController.realDelegate!;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
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
