//
//  EditFanUpdateViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 09/06/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import AVKit
import Alamofire
import YPImagePicker
class EditFanUpdateViewController:UIViewController, UIPopoverPresentationControllerDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var galleryClick: CustomBorderView!
    @IBOutlet weak var cameraClick: CustomBorderView!
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var childview: UIView?
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var titleCount: UILabel!
    @IBOutlet weak var contentCount: UILabel!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var close_preview: UIImageView!
    @IBOutlet weak var progressView: UIView?
    @IBOutlet weak var progressMessage: UILabel!
    @IBOutlet weak var progressPer: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    //var phAsset = PHAsset()
    
    let PLACEHOLDER_TEXT = "nitesh"
    var filePath:URL!
    var fileType:String = ""
    var dict: NSDictionary = [:]
    var fanupdateid : Int64 = 0
    var Subtype:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        teamName?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewFanUpdateViewController.selectTeam(_:))))
        teamName?.isUserInteractionEnabled = true
        
        progressView?.isHidden = true
        progressMessage?.isHidden = true
        progressSlider?.isHidden = true
        progressPer?.isHidden = true
        progressSlider?.value = 0.0
        progressSlider.isSelected = false
        progressSlider.isUserInteractionEnabled = false
        
        
        teamName?.layer.masksToBounds = true;
        teamName?.layer.borderWidth = 1.0
        teamName?.layer.borderColor = UIColor.init(hex: "E6E6E6").cgColor
        teamName?.layer.cornerRadius = 5.0
       
        cameraClick?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditFanUpdateViewController.showAction(_:))))
        cameraClick?.isUserInteractionEnabled = true
        
        close_preview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditFanUpdateViewController.closePreview(_:))))
        close_preview?.isUserInteractionEnabled = true
        
        previewImage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditFanUpdateViewController.mediaPreview(_:))))
        previewImage?.isUserInteractionEnabled = true
        
        let notificationName2 = Notification.Name("_SaveFanUpdates")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EditFanUpdateViewController.refreshFanUpdates), name: notificationName2, object: nil)
        
        
        let notificationName3 = Notification.Name("_GetPermissionsForMedia")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EditFanUpdateViewController.GetPermissionsForMedia), name: notificationName3, object: nil)
        
        let notificationName4 = Notification.Name("_GetPermissionsForCamera")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EditFanUpdateViewController.GetPermissionsForCamera), name: notificationName4, object: nil)
        contentText.delegate = self
        let notificationName5 = Notification.Name("_failSaveFanUpdates")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EditFanUpdateViewController.FailFanUpdates), name: notificationName5, object: nil)
        let notificationName6 = Notification.Name("_updateGetPermissionsForMediaProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EditFanUpdateViewController.GetPermissionsForMediaProfile), name: notificationName6, object: nil)
        
        let notificationName7 = Notification.Name("_updateGetPermissionsForCameraProfile")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(EditFanUpdateViewController.GetPermissionsForCameraProfile), name: notificationName7, object: nil)
        // applyPlaceholderStyle(aTextview: contentText!, placeholderText: PLACEHOLDER_TEXT)
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditFanUpdateViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditFanUpdateViewController.minimiseKeyboard(_:))))
        childview?.isUserInteractionEnabled = true
        
       // print(dict)
        
        fanupdateid =  dict.value(forKey: "id") as! Int64
        
        let teamId = dict.value(forKey: "relatedteam") as! Int
        let array1 = Teams_details.rows(filter:"team_Id = \(teamId)") as! [Teams_details]
        if(array1.count != 0) {
            let disnarysound = array1[0]
            teamName?.text = disnarysound.team_name
            self.appDelegate().fanUpdatesTeamName = disnarysound.team_name
        }
        
        self.appDelegate().fanUpdatesTeamId = Int64(teamId)
        
        
        let messageContent = dict.value(forKey: "message")as! String
        
        if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        {
            do {
                let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                
                let recMessageType: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                if(jsonDataMessage?.value(forKey: "subtype") != nil)
                {
                    let getsubtype: String = (jsonDataMessage?.value(forKey: "subtype") as? String)!
                    Subtype = getsubtype
                }
                else{
                    Subtype = "post"
                }
                let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
                
                if(recMessageType == "text")
                {
                    
                let decodedData = Data(base64Encoded: (jsonDataMessage?.value(forKey: "value") as? String)!)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                contentText.insertText(decodedString.trimmingCharacters(in: .whitespacesAndNewlines))
                    
                    previewImage?.isHidden = true
                    playImage?.isHidden = true
                    close_preview?.isHidden = true
                    
                }  else if(recMessageType == "image")
                {
                    
                    fileType = "image"
                    filePath = URL(string: selVideoPath)
                    previewImage?.isHidden = false
                    playImage?.isHidden = true
                    close_preview?.isHidden = false
                    var thumbLink: String = ""
                    if let thumb = jsonDataMessage?.value(forKey: "value")
                    {
                        thumbLink = thumb as! String
                    }
                    
                    appDelegate().loadImageFromUrl(url: thumbLink,view: previewImage!)
                    var caption: String = ""
                    if let capText = jsonDataMessage?.value(forKey: "caption")
                    {
                        caption = capText as! String
                    }
                    
                    if(!caption.isEmpty)
                    {
                        let decodedData = Data(base64Encoded: caption)!
                        let decodedString = String(data: decodedData, encoding: .utf8)!
                        contentText.insertText(decodedString.trimmingCharacters(in: .whitespacesAndNewlines))
                        contentText?.isHidden = false
                    } else
                    {
                        contentText?.isHidden = false
                    }
                    
                    previewImage?.contentMode = .scaleAspectFill
                    previewImage?.clipsToBounds = true
                    
                } else if(recMessageType == "video")
                    {
                        //cell.PlayImage?.isHidden = false
                        fileType = "video"
                        filePath = URL(string: selVideoPath)
                        previewImage?.isHidden = false
                        playImage?.isHidden = false
                        close_preview?.isHidden = false
                        var thumbLink: String = ""
                        if let thumb = jsonDataMessage?.value(forKey: "thumblink")
                        {
                            thumbLink = thumb as! String
                        }
                        
                        appDelegate().loadImageFromUrl(url: thumbLink,view: previewImage!)
                        var caption: String = ""
                        if let capText = jsonDataMessage?.value(forKey: "caption")
                        {
                            caption = capText as! String
                        }
                        
                        if(!caption.isEmpty)
                        {
                            let decodedData = Data(base64Encoded: caption)!
                            let decodedString = String(data: decodedData, encoding: .utf8)!
                            contentText.insertText(decodedString.trimmingCharacters(in: .whitespacesAndNewlines))
                            contentText?.isHidden = false
                        } else
                        {
                            contentText?.text = ""
                            contentText?.isHidden = false
                        }
                       
                        previewImage?.contentMode = .scaleAspectFill
                        previewImage?.clipsToBounds = true
                        
                    }
                
                let decodedData1 = Data(base64Encoded: (jsonDataMessage?.value(forKey: "title") as? String)!)!
                let decodedString1 = String(data: decodedData1, encoding: .utf8)!
                titleText?.text = decodedString1//jsonDataMessage?.value(forKey: "title") as? String
                
                titleCount?.text=String(describing: titleText?.text?.count ?? 0)+"/"+String(describing: titleText?.maxLength ?? 0)
                
            } catch let error as NSError {
                print(error)
            }
            
        }
        
        
    }
    
    @objc func refreshFanUpdates(_ sender:AnyObject)  {
        //LoadingIndicatorView.hide()
        progressView?.isHidden = true
        progressMessage?.isHidden = true
        progressSlider?.isHidden = true
        progressPer?.isHidden = true
        
        if(appDelegate().isReturnToMyFanUpdateWindow)
        {
            let notificationName2 = Notification.Name("resethomeApi")
                                  NotificationCenter.default.post(name: notificationName2, object: nil)
            let notificationName = Notification.Name("_MyFechedFanUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil)
            _ = navigationController?.popViewController(animated: true)
            appDelegate().isReturnToMyFanUpdateWindow = false
            let notificationName1 = Notification.Name("_FechedFanUpdate")
                   NotificationCenter.default.post(name: notificationName1, object: nil)
       // self.navigationController?.popViewController(animated: true)
        } else {
            appDelegate().isReturnToMyFanUpdateWindow = false
        let notificationName1 = Notification.Name("_FechedFanUpdate")
        NotificationCenter.default.post(name: notificationName1, object: nil)
         self.navigationController?.popViewController(animated: true)
            let notificationName = Notification.Name("_MyFechedFanUpdate")
            NotificationCenter.default.post(name: notificationName, object: nil)
            let notificationName2 = Notification.Name("resethomeApi")
                                  NotificationCenter.default.post(name: notificationName2, object: nil)
        }
    }
    @objc func FailFanUpdates(_ sender:AnyObject)  {
        LoadingIndicatorView.hide()
        alertWithTitle(title: "Error", message: "Football Fan service is unavailable. \nPlease try after some time. ", ViewController: self)
        progressView?.isHidden = true
        progressMessage?.isHidden = true
        progressSlider?.isHidden = true
        progressPer?.isHidden = true
        //_ = navigationController?.popToRootViewController(animated: true)
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            EditFanUpdateViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return EditFanUpdateViewController.realDelegate!;
    }
    @objc func GetPermissionsForCameraProfile(notification: NSNotification){
        //Code to show camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
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
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(sendPost))
        
        
        if(self.appDelegate().fanUpdatesTeamId > 0)
        {
            teamName?.text = "  " + self.appDelegate().fanUpdatesTeamName
        }
        else
        {
            self.appDelegate().fanUpdatesTeamId = self.appDelegate().primaryTeamId
            self.appDelegate().fanUpdatesTeamName = self.appDelegate().primaryTeamName
            teamName?.text = "  " + self.appDelegate().primaryTeamName
        }
        if(filePath == nil){
            close_preview.isHidden = true
        }
        else{
            close_preview.isHidden = false
        }
        
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            titleText?.endEditing(true)
            //userJID?.delegate = self
            contentText?.endEditing(true)
            
            
        }
        sender.cancelsTouchesInView = false
    }
    @IBAction func teamSelectButton(_ sender: UIButton) {
        let popController: CategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category") as! CategoryViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        popController.isShowForBanterRoom = true
        popController.teamType = "updates"
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    @objc func selectTeam (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        contentText.endEditing(true)
        titleText.endEditing(true)
        if sender.state == .ended {
            //isShowForBanterRoom = true
            //teamType = "my"
            let popController: CategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category") as! CategoryViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.isShowForBanterRoom = true
            popController.teamType = "updates"
            // present the popover
            self.present(popController, animated: true, completion: nil)
            // get a reference to the view controller for the popover
            /* let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
             
             // set the presentation style
             popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
             //popController.modalPresentationStyle = .popover
             popController.modalTransitionStyle = .crossDissolve
             
             // set up the popover presentation controller
             popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
             popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
             popController.popoverPresentationController?.sourceView = self.view // button
             //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
             popController.isShowForBanterRoom = true
             popController.teamType = "nearby"
             // present the popover
             self.present(popController, animated: true, completion: nil)*/
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func closePreview (_ sender: UITapGestureRecognizer) {
        //phAsset = PHAsset()
        previewImage?.image = nil
        fileType = ""
        filePath = URL(string: "")
        close_preview.isHidden = true
        playImage?.isHidden = true
    }
    
    @objc func mediaPreview (_ sender: UITapGestureRecognizer) {
           if(fileType == "image") //Image
            {
                
                appDelegate().isFromPreview = true
                var media = [AnyObject]()
                media.append(LightboxImage(
                    image:  previewImage.image!,
                    text: ""
                ))
                if(media.count>0)
                {
                    appDelegate().isFromPreview = true
                    let controller = LightboxController(images: media as! [LightboxImage], startIndex: 0)
                    
                    // Set delegates.
                    controller.pageDelegate = self as? LightboxControllerPageDelegate
                    
                    // Use dynamic background.
                    controller.dynamicBackground = true
                    // Present your controller.
                    self.present(controller, animated: true, completion: nil)
                }
            }
            else if(fileType == "video")  //Video
            {
                
                appDelegate().isFromPreview = true
                if(filePath != nil)
                {
                    DispatchQueue.main.async {
                     let playerItem = AVPlayerItem.init(url: self.filePath!)
                     let player = AVPlayer(playerItem: playerItem)
                     
                     let playerViewController = AVPlayerViewController()
                     playerViewController.player = player
                     self.present(playerViewController, animated: true) {
                     playerViewController.player!.play()
                     }
                    }
                    
                }
                
                
                
            }

       
        
        
    }
    @objc func showAction(_ sender: UITapGestureRecognizer){
      /*  let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let team1Action = UIAlertAction(title: "Camera", style: .default, imageNamed: "uncheck", handler: {
            (alert: UIAlertAction!) -> Void in
            self.showCamera()
            
        })
        let team2Action = UIAlertAction(title: "Gallery", style: .default, imageNamed: "uncheck" , handler: {
            (alert: UIAlertAction!) -> Void in
            self.showCustomGallery()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            //print("Cancelled")
        })
        optionMenu.addAction(team1Action!)
        optionMenu.addAction(team2Action!)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)*/
         showCustomGallery1()
    }
    func showCustomGallery1 () {
        contentText.endEditing(true)
        titleText.endEditing(true)
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
                
                showCustomGallery()
            }
            
        }
        /*let notifiedCam: String? = UserDefaults.standard.string(forKey: "notifiedcamera")
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
            popController.notifyType = "fanupdatemedia"
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
                    
                    showCustomGallery()
                }
                
            }
            
            
            
            
            
        }*/
        
        
    }
    
   /*  func showCamera () {
        contentText.endEditing(true)
        titleText.endEditing(true)
        let notified: String? = UserDefaults.standard.string(forKey: "notifiedcamera")
        if notified == nil
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
            popController.notifyType = "fanupdatecamera"
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
                        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                } else {
                    self.displayCameraSettingsAlert()
                }
            }
            //Code to show camera
            
            
        }
    }
    */
    
    func showMediaPreview(_ mediaType: String, mediaPath: String, isLocalMedia: Bool = false) {
        if(!mediaType.isEmpty && !mediaPath.isEmpty)
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let previewController : MediaPreviewController! = storyBoard.instantiateViewController(withIdentifier: "MediaPreview") as? MediaPreviewController
            
            if(mediaType == "image")
            {
                previewController.imagePath = mediaPath
            }
            else if(mediaType == "video")
            {
                previewController.videoPath = mediaPath
                
            }
            previewController.isLocalMedia = isLocalMedia
            previewController.mediaType = mediaType
            /*show(previewController!, sender: self)*/
            self.present(previewController, animated: true, completion: nil)
        }
    }
    
    func showCustomGallery () {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.onlySquare  = false
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
        /*config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
         YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono"),
         YPFilterDescriptor(name: "Tonal", filterName: "CIPhotoEffectTonal"),
         YPFilterDescriptor(name: "Noir", filterName: "CIPhotoEffectNoir"),
         YPFilterDescriptor(name: "Fade", filterName: "CIPhotoEffectFade"),
         YPFilterDescriptor(name: "Chrome", filterName: "CIPhotoEffectChrome"),
         YPFilterDescriptor(name: "Process", filterName: "CIPhotoEffectProcess"),
         YPFilterDescriptor(name: "Transfer", filterName: "CIPhotoEffectTransfer"),
         YPFilterDescriptor(name: "Instant", filterName: "CIPhotoEffectInstant"),
         YPFilterDescriptor(name: "Sepia", filterName: "CISepiaTone")]*/
        
        
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetMediumQuality
        
        config.albumName = "Football Fan"
        config.screens = [.library, .photo, .video]
        config.startOnScreen = .library
        config.video.recordingTimeLimit = 300
        config.video.libraryTimeLimit = 900
        config.video.trimmerMaxDuration = 900
        //config.video.fileType = .mp4
        // config.shouldSaveNewPicturesToAlbum = true
        //config.showsCrop = .rectangle(ratio: (16/9))
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
                    
                    self.playImage?.isHidden = true
                    self.previewImage?.contentMode = .scaleAspectFill
                    self.previewImage?.clipsToBounds = true
                    
                    
                    var tempImg = photo.modifiedImage
                    if(tempImg == nil){
                        tempImg = photo.originalImage
                    }
                    self.previewImage?.image = tempImg
                    //self.getImageThumbnail(asset: photo)
                    let uuid = UUID().uuidString
                    let _: Int64 = self.appDelegate().getUTCFormateDate()
                    let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    self.fileType = "image"
                    
                    
                    
                    let fileUrl = docDir.appendingPathComponent("\(uuid).png")
                    do{
                        try tempImg!.jpegData(compressionQuality: 1.0)?.write(to: fileUrl, options: .atomic)
                    }catch{
                        print("couldn't write image")
                        
                    }
                    //Prepare message to send on Server
                    
                    
                    self.filePath = fileUrl
                    
                    break
                case .video(let video):
                    //print(video)
                    self.playImage?.isHidden = false
                    
                    let tempImg = video.thumbnail//self.getImageThumbnail(asset: photo)
                    self.filePath = video.url
                    self.fileType = "video"
                    
                    self.previewImage?.image = tempImg
                    
                    self.previewImage?.contentMode = .scaleAspectFill
                    self.previewImage?.clipsToBounds = true
                    
                    break
                }
            }
            self.previewImage?.isHidden = false
            self.close_preview.isHidden = false
            
            
            picker.dismiss(animated: true, completion: nil)
            
            
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func GetPermissionsForCamera(notification: NSNotification){
        //Code to show camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                  
                     self.showCustomGallery()
                }
            } else {
                self.displayCameraSettingsAlert()
            }
        }
    }
    
    @objc func GetPermissionsForMedia(notification: NSNotification) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                        
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
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            //appDelegate().profileAvtarTemp! = pickedImage
            previewImage?.image = pickedImage
            previewImage?.isHidden = false
            playImage?.isHidden = true
            previewImage?.contentMode = .scaleAspectFill
            previewImage?.clipsToBounds = true
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
            
            let fileUrl = docDir.appendingPathComponent("\(imageUniqueName).png")
            
            do{
                if let pngImageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage)!.pngData(){
                    
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
                    //try pngImageData.write(to : fileUrl , options : .atomic)
                    filePath = fileUrl
                    fileType = "image"
                }
                
            }catch{
                print("couldn't write image")
                
            }
            
            print(filePath as Any)
            
            
        }
        
        
        if let pickedVideo = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? NSURL {
            //appDelegate().profileAvtarTemp! = pickedImage
            print(pickedVideo)
            filePath = pickedVideo as URL
            fileType = "video"
            playImage?.isHidden = false
            do {
                let asset = AVURLAsset(url: pickedVideo as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                print(filePath as Any)
                
                previewImage?.image = thumbnail
                previewImage?.isHidden = false
                previewImage?.contentMode = .scaleAspectFill
                previewImage?.clipsToBounds = true
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
            //previewImage?.image = pickedImage
        }
        
        close_preview.isHidden = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    
    
    @objc func sendPost() {
        
       // self.appDelegate().registerBackgroundTask()
        contentText.endEditing(true)
        titleText.endEditing(true)
        Clslogging.logdebug(State: "edit story sendPost start")
        let messageContent = dict.value(forKey: "message")as! String
        
        if let dataMessage = messageContent.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        {
            do {
                let jsonDataMessage = try JSONSerialization.jsonObject(with:dataMessage , options: []) as? NSDictionary
                
                let _: String = (jsonDataMessage?.value(forKey: "type") as? String)!
                
                let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
              
                let thumbLink = (jsonDataMessage?.value(forKey: "thumblink") as? String)!
                
                let uuid =  UUID().uuidString//(jsonDataMessage?.value(forKey: "messageid"))//UUID().uuidString
                
                let time: Int64 = self.appDelegate().getUTCFormateDate()
                
                if(fileType == "video" || fileType == "image")
                {
                   // print(filePath)
                    if(filePath.absoluteString == selVideoPath)
                    {
                        if let title: String = self.titleText!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        {
                            if(!title.isEmpty)
                            {
                                
                                let tMessage = self.contentText!.text
                        
                      //  print("Original: \(tMessage)")
                        
                        //1. Convert String to base64
                        //Convert string to NSData
                                let content = tMessage!.replace(target: "~", withString: "-")
                                //1. Convert String to base64
                                //Convert string to NSData
                                let myNSData = content.data(using: String.Encoding.utf8)! as NSData
                                                        //Encode to base64
                        let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                        
                        let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                        
                        let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                let titletex = title.replace(target: "~", withString: "-")
                                let myNSData1 = titletex.data(using: String.Encoding.utf8)! as NSData
                                let myBase64Data1 = myNSData1.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                     
                                let resultNSString1 = NSString(data: myBase64Data1 as Data, encoding: String.Encoding.utf8.rawValue)!
                        let arrUserJid = userJid?.components(separatedBy: "@")
                        let userJidTrim = arrUserJid?[0]
                        let caption =  resultNSString as String
                        
                                self.appDelegate().sendMessageToEditFanUpdates(userJidTrim!, messageContent: selVideoPath, messageType: fileType, messageTime: time, messageId: uuid , caption: caption, thumbLink: thumbLink, roomType: "fanupdates", messageTitle: resultNSString1 as String, fanupdateid: fanupdateid ,subtype: Subtype)
                    }  else
                        {
                            // Blank title
                            alertWithTitle(title: nil, message: "Please enter a title for your story.", ViewController: self)
                        }
                        
                    } else
                    {
                        // Blank title
                        alertWithTitle(title: nil, message: "Please enter a title for your story.", ViewController: self)
                    }
                
                        
                    } else {
                        if(fileType == "video") //Video
                        {
                            if let title: String = self.titleText!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            {
                                if(!title.isEmpty)
                                {
                                    progressView?.isHidden = false
                                    progressMessage?.isHidden = false
                                    progressSlider?.isHidden = false
                                    progressPer?.isHidden = false
                                    progressMessage.text = "Processing your story. \nOnce completed it will appear under Fan Stories"
                                    progressSlider.setThumbImage(UIImage(named: "uncheck"), for: .normal)
                                    progressSlider.layer.cornerRadius = 10
                                    
                                    //LoadingIndicatorView.show("Processing your update. \nOnce completed it will appear under Fan Stories")
                                    //let tempImg: UIImage = self.getImageThumbnail(asset: phAsset)
                                    //let uuid = UUID().uuidString
                                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    //Prepare message to send on Server
                                    
                                    //New code to save video then send to api
                                   // let uuid = UUID().uuidString
                                    
                                    
                                    //Code to send video to API Server
                                    let login: String? = UserDefaults.standard.string(forKey: "userJID")
                                  
                                    let registorusername: String? = UserDefaults.standard.string(forKey: "registerusername")
                                   
                                    var reqParams = [String: String]()
                                    reqParams["cmd"] = "video"
                                     reqParams["sourcetype"] = "story"
                                    reqParams["jid"] = registorusername
                                    reqParams["device"] = "ios"
                                    reqParams["key"] = "kXfqS9wUug6gVKDB" as String
                                    
                                    let videoData: NSData = self.previewImage.image!.jpegData(compressionQuality: 0.5)! as NSData
                                    let base64String = videoData.base64EncodedString(options: [])
                                    
                                    reqParams["thumb_byte"] = base64String
                                    AF.upload(multipartFormData: { multiPart in
                                                                         multiPart.append(self.filePath, withName: "uploaded")
                                                                                                                     for (key, val) in reqParams {
                                                                                                                         multiPart.append(val.data(using: String.Encoding.utf8)!, withName: key)
                                                                                                                     }
                                                                        }, to: MediaAPI, method: .post) .uploadProgress(queue: .main, closure: { progress in
                                                                            print("Upload Progress: \(progress.fractionCompleted)")
                                                                            self.progressSlider.value = Float(progress.fractionCompleted - 0.050)
                                                                            //print(Int(progress.fractionCompleted))
                                                                            let a = progress.fractionCompleted * 99.00
                                                                            //print(a)
                                                                            self.progressPer.text = "\(Int(a))%"
                                                                        }).responseJSON(completionHandler: { data in
                                                                            print("upload finished: \(data)")
                                                                          print("resultvalue\(data.result)")
                                                                          switch data.result {
                                                                                                                   case .success(let resut):
                                                                                                                     print("upload success result: \(String(describing: resut))")
                                                                                                                     if let JSON = resut as? [String: Any] {
                                                                                                                                                                       let isSuccess = JSON["success"] as! Bool
                                                                                                                                                                         if(isSuccess)
                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                             let tMessage = (self.contentText!.text)!
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             print("Original: \(tMessage)")
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             //1. Convert String to base64
                                                                                                                                                                                                                                             //Convert string to NSData
                                                                                                                                                                                                                                             let content = tMessage.replace(target: "~", withString: "-")
                                                                                                                                                                                                                                             //1. Convert String to base64
                                                                                                                                                                                                                                             //Convert string to NSData
                                                                                                                                                                                                                                             let myNSData = content.data(using: String.Encoding.utf8)! as NSData
                                                                                                                                                                                                                                             //Encode to base64
                                                                                                                                                                                                                                             let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let trimMessage = JSON["link"] as? String
                                                                                                                                                                                                                                             let thumbLink = JSON["thumblink"] as? String
                                                                                                                                                                                                                                             let smillink = JSON["smillink"] as? String
                                                                                                                                                                                                                                                                                                               let mp4link = JSON["mp4link"] as? String
                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                             let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let arrUserJid = userJid?.components(separatedBy: "@")
                                                                                                                                                                                                                                             let userJidTrim = arrUserJid?[0]
                                                                                                                                                                                                                                             let caption =  resultNSString as String
                                                                                                                                                                                                                                             let titletex = title.replace(target: "~", withString: "-")
                                                                                                                                                                                                                                             let myNSData1 = titletex.data(using: String.Encoding.utf8)! as NSData
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             //Encode to base64
                                                                                                                                                                                                                                             let myBase64Data1 = myNSData1.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let resultNSString1 = NSString(data: myBase64Data1 as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                                                                                                                                                                                            self.appDelegate().sendMessageToEditFanUpdates(userJidTrim!, messageContent: trimMessage!, messageType: "video", messageTime: time, messageId: uuid , caption: caption, thumbLink: thumbLink!, roomType: "fanupdates", messageTitle: resultNSString1 as String, fanupdateid: self.fanupdateid,subtype: self.Subtype,smillink: smillink!,mp4link: mp4link!)
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                         else
                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                         }
                                                                                                                                                                   }
                                                                                                                   case .failure(let err):
                                                                                                                       print("upload err: \(err)")
                                                                                                                       let errorinfo:[String: AnyObject] = ["error": err as AnyObject]
                                                                                                                                                                     Clslogging.logerror(State: "edit story sendPost", userinfo: errorinfo)}
                                                                        
                                                                              
                                                                        })
                                    // Use Alamofire to upload the image
                                 /*   AF.upload(
                                        multipartFormData: { multipartFormData in
                                            // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                                            multipartFormData.append(self.filePath, withName: "uploaded")
                                            for (key, val) in reqParams {
                                                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                                            }
                                    },
                                        to: MediaAPI,
                                        encodingCompletion: { encodingResult in
                                            switch encodingResult {
                                            case .success(let upload, _, _):
                                                upload.uploadProgress(closure: { (progress) in
                                                    
                                                   // print("uploding")
                                                    //print(progress)
                                                    self.progressSlider.value = Float(progress.fractionCompleted - 0.050)
                                                    //print(Int(progress.fractionCompleted))
                                                    let a = progress.fractionCompleted * 99.00
                                                    //print(a)
                                                    self.progressPer.text = "\(Int(a))%"
                                                })
                                                upload.responseJSON { response in
                                                    if let jsonResponse = response.result.value as? [String: Any] {
                                                        print(jsonResponse)
                                                        let data = response.data
                                                        if let data = data {
                                                            if String(data: data, encoding: String.Encoding.utf8) != nil {
                                                                
                                                                do {
                                                                    let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                                                                    
                                                                    let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                                                                    
                                                                    if(isSuccess)
                                                                    {
                                                                        let tMessage = (self.contentText!.text)!
                                                                        
                                                                        print("Original: \(tMessage)")
                                                                        
                                                                        //1. Convert String to base64
                                                                        //Convert string to NSData
                                                                        let content = tMessage.replace(target: "~", withString: "-")
                                                                        //1. Convert String to base64
                                                                        //Convert string to NSData
                                                                        let myNSData = content.data(using: String.Encoding.utf8)! as NSData
                                                                        //Encode to base64
                                                                        let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                        
                                                                        let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                        
                                                                        
                                                                        let trimMessage = (jsonData?.value(forKey: "link") as? String)!
                                                                        let thumbLink = (jsonData?.value(forKey: "thumblink") as? String)!
                                                                        let smillink = (jsonData?.value(forKey: "smillink") as? String)!
                                                                                                                                          let mp4link = (jsonData?.value(forKey: "mp4link") as? String)!
                                                                                                                                          
                                                                        let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                        
                                                                        let arrUserJid = userJid?.components(separatedBy: "@")
                                                                        let userJidTrim = arrUserJid?[0]
                                                                        let caption =  resultNSString as String
                                                                        let titletex = title.replace(target: "~", withString: "-")
                                                                        let myNSData1 = titletex.data(using: String.Encoding.utf8)! as NSData
                                                                        
                                                                        //Encode to base64
                                                                        let myBase64Data1 = myNSData1.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                        
                                                                        let resultNSString1 = NSString(data: myBase64Data1 as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                        self.appDelegate().sendMessageToEditFanUpdates(userJidTrim!, messageContent: trimMessage, messageType: "video", messageTime: time, messageId: uuid , caption: caption, thumbLink: thumbLink, roomType: "fanupdates", messageTitle: resultNSString1 as String, fanupdateid: self.fanupdateid,subtype: self.Subtype,smillink: smillink,mp4link: mp4link)
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        
                                                                    }
                                                                } catch let error as NSError {
                                                                    print(error)
                                                                    let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                    Clslogging.logerror(State: "edit story sendPost", userinfo: errorinfo)
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            case .failure(let encodingError):
                                                print(encodingError)
                                                let errorinfo:[String: AnyObject] = ["error": encodingError as AnyObject]
                                                Clslogging.logerror(State: "edit story sendPost", userinfo: errorinfo)
                                            }
                                    })*/
                                    
                                    
                                    //End
                                } else
                                {
                                    // Blank title
                                    alertWithTitle(title: nil, message: "Please enter a title for your story.", ViewController: self)
                                }
                                
                            } else
                            {
                                // Blank title
                                alertWithTitle(title: nil, message: "Please enter a title for your story.", ViewController: self)
                            }
                            
                        }
                        else if(fileType == "image") //Image
                        {
                            if let title: String = self.titleText!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            {
                                if(!title.isEmpty)
                                {
                                    progressView?.isHidden = false
                                    progressMessage?.isHidden = false
                                    progressSlider?.isHidden = false
                                    progressPer?.isHidden = false
                                    progressMessage.text = "Processing your update. \nOnce completed it will appear under Fan Stories"
                                    progressSlider.setThumbImage(UIImage(named: "uncheck"), for: .normal)
                                    progressSlider.layer.cornerRadius = 10
                                    
                                    //LoadingIndicatorView.show(self.view, loadingText: "Processing your update. \nOnce completed it will appear under Fan Stories")
                                    // let image    = UIImage(contentsOfFile: filePath)
                                    // let tempImg: UIImage = self.getImageThumbnail(asset: phAsset)
                                    let tempImg  = self.appDelegate().loadProfileImage(filePath: filePath.path)
                                    //UIImage(contentsOfFile: filePath)
                                   // let uuid = UUID().uuidString
                                    let time: Int64 = self.appDelegate().getUTCFormateDate()
                                    
                                    let login: String? = UserDefaults.standard.string(forKey: "userJID")
                                    
                                    
                                    let registorusername: String? = UserDefaults.standard.string(forKey: "registerusername")
                                    
                                    var reqParams = [String: String]()
                                    reqParams["cmd"] = "image"
                                    reqParams["jid"] = registorusername
                                    reqParams["device"] = "ios"
                                    reqParams["key"] = "kXfqS9wUug6gVKDB" as String
                                    
                                    AF.upload(multipartFormData: { multiPart in
                                                                           multiPart.append(self.filePath, withName: "uploaded")
                                                                                                                    for (key, val) in reqParams {
                                                                                                                        multiPart.append(val.data(using: String.Encoding.utf8)!, withName: key)
                                                                                                                    }
                                                                        }, to: MediaAPI, method: .post) .uploadProgress(queue: .main, closure: { progress in
                                                                            print("Upload Progress: \(progress.fractionCompleted)")
                                                                            self.progressSlider.value = Float(progress.fractionCompleted - 0.050)
                                                                                                                               //print(Int(progress.fractionCompleted))
                                                                                                                               let a = progress.fractionCompleted * 99.00
                                                                                                                               //print(a)
                                                                                                                               self.progressPer.text = "\(Int(a))%"
                                                                            
                                                                        }).responseJSON(completionHandler: { data in
                                                                            print("upload finished: \(data)")
                                                                          print("resultvalue\(data.result)")
                                                                          switch data.result {
                                                                                                                   case .success(let resut):
                                                                                                                     print("upload success result: \(String(describing: resut))")
                                                                                                                     if let JSON = resut as? [String: Any] {
                                                                                                                                                                       let isSuccess = JSON["success"] as! Bool
                                                                                                                                                                         if(isSuccess)
                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                             let tMessage = (self.contentText!.text)!
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             print("Original: \(tMessage)")
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             //1. Convert String to base64
                                                                                                                                                                                                                                             //Convert string to NSData
                                                                                                                                                                                                                                             let myNSData = tMessage.data(using: String.Encoding.utf8)! as NSData
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             //Encode to base64
                                                                                                                                                                                                                                             let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             //Convert NSString to String
                                                                                                                                                                                                                                             //let trimMessage = resultNSString as String
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let trimMessage = JSON["link"] as? String
                                                                                                                                                                                                                                             let thumbLink = JSON["thumblink"] as? String
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let arrUserJid = userJid?.components(separatedBy: "@")
                                                                                                                                                                                                                                             let userJidTrim = arrUserJid?[0]
                                                                                                                                                                                                                                             let caption = resultNSString as String
                                                                                                                                                                                                                                             let myNSData1 = title.data(using: String.Encoding.utf8)! as NSData
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             //Encode to base64
                                                                                                                                                                                                                                             let myBase64Data1 = myNSData1.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             let resultNSString1 = NSString(data: myBase64Data1 as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                            self.appDelegate().sendMessageToEditFanUpdates(userJidTrim!, messageContent: trimMessage!, messageType: "image", messageTime: time, messageId: uuid , caption: caption, thumbLink: thumbLink!, roomType: "fanupdates", messageTitle: resultNSString1 as String, fanupdateid: self.fanupdateid,subtype: self.Subtype)
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                         }
                                                                                                                                                                                                                                         else
                                                                                                                                                                                                                                         {
                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                         }
                                                                                                                                                                   }
                                                                                                                   case .failure(let err):
                                                                                                                       print("upload err: \(err)")
                                                                                                                  let errorinfo:[String: AnyObject] = ["error": err as AnyObject]
                                                                                                                           Clslogging.logerror(State: "edit story sendPost", userinfo: errorinfo)
                                                                                                                   }
                                                                        
                                                                              
                                                                        })
                                    // Use Alamofire to upload the image
                                   /* AF.upload(
                                        multipartFormData: { multipartFormData in
                                            // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                                            multipartFormData.append(self.filePath, withName: "uploaded")
                                            for (key, val) in reqParams {
                                                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                                            }
                                    },
                                        to: MediaAPI,
                                        encodingCompletion: { encodingResult in
                                            switch encodingResult {
                                            case .success(let upload, _, _):
                                                upload.uploadProgress(closure: { (progress) in
                                                    
                                                   // print("uploding")
                                                   // print(progress)
                                                    self.progressSlider.value = Float(progress.fractionCompleted - 0.050)
                                                    //print(Int(progress.fractionCompleted))
                                                    let a = progress.fractionCompleted * 99.00
                                                    //print(a)
                                                    self.progressPer.text = "\(Int(a))%"
                                                })
                                                upload.responseJSON { response in
                                                    if let jsonResponse = response.result.value as? [String: Any] {
                                                        print(jsonResponse)
                                                        let data = response.data
                                                        if let data = data {
                                                            if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                                                                do {
                                                                    let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                                                                    
                                                                    let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                                                                    
                                                                    if(isSuccess)
                                                                    {
                                                                        let tMessage = (self.contentText!.text)!
                                                                        
                                                                        print("Original: \(tMessage)")
                                                                        
                                                                        //1. Convert String to base64
                                                                        //Convert string to NSData
                                                                        let myNSData = tMessage.data(using: String.Encoding.utf8)! as NSData
                                                                        
                                                                        //Encode to base64
                                                                        let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                        
                                                                        let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                        
                                                                        //Convert NSString to String
                                                                        //let trimMessage = resultNSString as String
                                                                        
                                                                        let trimMessage = (jsonData?.value(forKey: "link") as? String)!
                                                                        let thumbLink = (jsonData?.value(forKey: "thumblink") as? String)!
                                                                        
                                                                        let userJid: String? = UserDefaults.standard.string(forKey: "userJID")
                                                                        
                                                                        let arrUserJid = userJid?.components(separatedBy: "@")
                                                                        let userJidTrim = arrUserJid?[0]
                                                                        let caption = resultNSString as String
                                                                        let myNSData1 = title.data(using: String.Encoding.utf8)! as NSData
                                                                        
                                                                        //Encode to base64
                                                                        let myBase64Data1 = myNSData1.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
                                                                        
                                                                        let resultNSString1 = NSString(data: myBase64Data1 as Data, encoding: String.Encoding.utf8.rawValue)!
                                                                        
                                                                        self.appDelegate().sendMessageToEditFanUpdates(userJidTrim!, messageContent: trimMessage, messageType: "image", messageTime: time, messageId: uuid , caption: caption, thumbLink: thumbLink, roomType: "fanupdates", messageTitle: resultNSString1 as String, fanupdateid: self.fanupdateid,subtype: self.Subtype)
                                                                        
                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        
                                                                    }
                                                                } catch let error as NSError {
                                                                    print(error)
                                                                    let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                                                                    Clslogging.logerror(State: "edit story sendPost", userinfo: errorinfo)
                                                                    
                                                                }
                                                                
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                            case .failure(let encodingError):
                                                print(encodingError)
                                                let errorinfo:[String: AnyObject] = ["error": encodingError as AnyObject]
                                                Clslogging.logerror(State: "edit story sendPost", userinfo: errorinfo)
                                            }
                                    })*/
                                    
                                } else
                                {
                                    // Blank title
                                    alertWithTitle(title: nil, message: "Please enter a title for your story.", ViewController: self)
                                }
                            } else
                            {
                                // Blank title
                                alertWithTitle(title: nil, message: "Please enter a title for your story.", ViewController: self)
                            }
                        } else
                        {
                             alertWithTitle(title: nil, message: "Please select a picture or video for your story.", ViewController: self)
                        }
                    }
                } else {
                    alertWithTitle(title: nil, message: "Please add a picture or a video to your story.", ViewController: self)
                    
                }
                
                
            } catch let error as NSError {
                print(error)
            }
        }
         Clslogging.logdebug(State: "edit story sendPost End")
        
    }
    
    @IBAction func titletxtchange(){
        titleCount?.text=String(describing: titleText?.text?.count ?? 0)+"/"+String(describing: titleText?.maxLength ?? 0)
        
    }
    
    @IBAction func contenttxtchange(){
        //contentCount?.text=String(describing: contentText?.text?.characters.count ?? 0)+"/"+String(describing: contentText?.maxLength ?? 0)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        // print("Start Editing")
        if((contentText?.text?.count)!>400){
            
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 400
        
    }
    func textViewDidChange(_ textView: UITextView)
    {
        //  print(textView.text);
        contentCount?.text=String(describing: contentText?.text?.count ?? 0)+"/"+String(describing: 400)
        
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        
        let exporter = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality)
        exporter?.outputURL = outputURL
        exporter?.outputFileType = AVFileType.mp4
        exporter?.exportAsynchronously(completionHandler: {
            handler(exporter)
            
        })
    }
    
    func getMediaURL(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        
        if mPhasset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL)
            })
        } else if mPhasset.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func getImageThumbnail(asset: PHAsset) -> UIImage {
        
        let width: Int = asset.pixelWidth/3
        let height: Int = asset.pixelHeight/3
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail: UIImage! //()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: width, height: height), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func createRequestBodyWith(parameters:[String:String], filePathKey:String, boundary:String, image: UIImage) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "temp.jpg"
        
        let imageData = image.jpegData(compressionQuality: 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func createRequestBodyWithVideo(parameters:[String:String], filePathKey:String, boundary:String, videoURL: URL) -> NSData{
        
        let body = NSMutableData()
        
        //let imageData = UIImageJPEGRepresentation(image, 1)
        do
        {
            for (key, value) in parameters {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
            
            body.appendString(string: "--\(boundary)\r\n")
            
            let mimetype = "video/mp4"
            
            let defFileName = "temp.mp4"
            let videoData = try Data(contentsOf: videoURL)
            
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(videoData)
            body.appendString(string: "\r\n")
            
            body.appendString(string: "--\(boundary)--\r\n")
            
        } catch let error as NSError {
            print(error)
        }
        
        return body
    }
    
    
    func getVideoThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = CGSize(width: 320, height: 180) //.maximumSize = CGSize
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            let img: UIImage = UIImage(cgImage: thumbnailImage)
            return img
        } catch let error {
            print(error)
            let img: UIImage = UIImage(named: "splash_bg")!
            return img
        }
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
