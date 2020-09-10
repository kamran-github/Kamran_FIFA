//
//  VideoPermissionScreen.swift
//  FootballFan
//
//  Created by Apple on 19/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//
import UIKit
import AVFoundation
//import SwiftSVG
class VideoPermissionScreen: UIViewController {
     var notifyType: String = ""
     @IBOutlet weak var playerview: UIView!
    var asset: AVAsset!
    var player: AVPlayer = AVPlayer()
    var playerItem: AVPlayerItem!
    let requiredAssetKeys = [
           "playable",
           "hasProtectedContent"
       ]
     @IBOutlet weak var permissionname: UILabel!
     @IBOutlet weak var switchbut: UIButton!
    var ispermissionAllow:Bool = false
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    override func viewDidLoad() {
    super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener), name: AVAudioSession.routeChangeNotification, object: nil)
        
     /*   if(notifyType == "contact"){
            permissionname.text = "Contacts"
            let url = Bundle.main.url(forResource: "contact", withExtension: "mp4")!
                  asset = AVAsset(url: url)
                  
        }
        else if(notifyType == "location" ){
            permissionname.text = "Location"
            let url = Bundle.main.url(forResource: "contact", withExtension: "mp4")!
                  asset = AVAsset(url: url)
                  
        }
       else if(notifyType == "notification" ){
           permissionname.text = "Notification"
           let url = Bundle.main.url(forResource: "notification", withExtension: "mp4")!
                 asset = AVAsset(url: url)
                 
       }
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: requiredAssetKeys)
        
        // Register as an observer of the player item's status property
       /* playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        */
        
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
        
        
        
        
         playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill//AVLayerVideoGravity.resizeAspect
        playerview.layer.addSublayer(playerLayer)
        player.play()
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(self.playerDidFinishPlaying(note:)),
                                                      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                      object: playerLayer.player?.currentItem)*/
       /* let sockPuppet = "M49.976,36.57l27.343,1.078c7.437,0,13.486-6.05,13.486-13.487s-6.049-13.487-13.485-13.487H58  c-0.429-3.546-2.45-6.235-4.881-6.235s-4.45,2.689-4.877,6.235h-4.368c-0.259,0-0.511,0.01-0.768,0.014  c-0.423-3.553-2.445-6.25-4.88-6.25c-2.719,0-4.924,3.36-4.961,7.523c-5.139,1.369-9.419,3.825-12.781,7.357  c-8.476,8.907-7.963,21.297-7.939,21.737v37.496h4.016V93.5h33.775V78.551h4.471v-1.682c0-8.529,4.16-9.612,4.639-9.708  c0.794-0.026,5.409-0.225,10.103-1.41c9.184-2.323,11.111-6.586,11.111-9.753c0-7.207-5.377-9.775-10.409-9.775  c-0.399,0-0.689,0.018-0.829,0.028H51.104l-0.237,0.017c-0.004,0.001-0.422,0.058-1.042,0.058c-5.218,0-5.218-3.253-5.218-4.322  C44.607,36.887,49.143,36.58,49.976,36.57z M87.441,24.161c0,5.583-4.542,10.124-10.057,10.125l-7.973-0.314  c-4.428-6.087-6.037-11.196-4.771-15.199c0.722-2.282,2.289-3.793,3.675-4.734h9.002C82.899,14.038,87.441,18.579,87.441,24.161z   M69.492,49.615l0.16-0.008c0.035-0.003,0.254-0.021,0.598-0.021c2.632,0,7.046,0.833,7.046,6.412c0,4.667-8.069,6.723-13.864,7.461  c-1.008-0.493-1.786-1.215-2.318-2.167c-1.917-3.429-0.405-8.997,0.517-11.677H69.492z M49.825,49.689  c0.655,0,1.153-0.047,1.384-0.074h9.357c-0.98,2.923-2.377,8.495-0.327,12.164c0.412,0.737,0.946,1.354,1.591,1.858  c-1.001,0.095-1.887,0.147-2.579,0.164l-0.153,0.012c-0.297,0.034-6.954,0.932-7.604,11.374H45.15v-7.053h-3.364v7.053H35.06v-7.053  h-3.363v7.053h-7.147v-7.053h-3.364v7.053h-5.277l-0.002-34.212c-0.005-0.115-0.447-11.52,7.037-19.36  c2.829-2.964,6.458-5.042,10.805-6.269c0.799,2.571,2.501,4.353,4.479,4.353c2.291,0,4.215-2.388,4.788-5.63  c0.291-0.005,0.565-0.031,0.86-0.031h22.781c-1.188,1.029-2.341,2.46-2.964,4.421c-1.327,4.175,0.18,9.371,4.46,15.462  l-18.109-0.714c-3.043,0-8.798,1.838-8.798,8.797C41.244,46.816,44.452,49.689,49.825,49.689z"
        let sockPuppetSVG = CAShapeLayer(layer: sockPuppet)
        let returnView = UIView()
        playerview.layer.addSublayer(sockPuppetSVG)
        let tea = "M507.5,84.4H6.9c-2.5,0-4.6-2.1-4.6-4.6l20-71.4c0-2.5,2.1-4.6,4.6-4.6h500.6c2.5,0,4.6,2.1,4.6,4.6l-20,71.4C512.1,82.3,510.1,84.4,507.5,84.4z"
        let teaPath = UIBezierPath(pathString: tea)
        //let returnView = UIView()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = teaPath.cgPath
        playerview.layer.addSublayer(shapeLayer)
        let svgURL = Bundle.main.url(forResource: "strip", withExtension: "svg")!
        let pizza = CALayer(SVGURL: svgURL) { (svgLayer) in
            // Set the fill color
            //svgLayer.fillColor = UIColor(red:0.94, green:0.37, blue:0.00, alpha:1.00).cgColor
            // Aspect fit the layer to self.view
            svgLayer.resizeToFit(self.view.bounds)
            // Add the layer to self.view's sublayers
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.white.cgColor]
            svgLayer.insertSublayer(gradientLayer, at: 1)
            self.playerview.layer.addSublayer(svgLayer)
        }*/
       
        //switchbut.setTitle("OFF", for: .normal)
    }
    @objc func willEnterForeground() {
          print("will enter foreground")
        player.play()
      }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
       // timer.invalidate()
       appDelegate().ismodalshow = false
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
         appDelegate().ismodalshow = true
        if(notifyType == "contact"){
                  permissionname.text = "Contacts"
                  let url = Bundle.main.url(forResource: "contact", withExtension: "mp4")!
                        asset = AVAsset(url: url)
                        
              }
              else if(notifyType == "location" ){
                  permissionname.text = "Location"
                  let url = Bundle.main.url(forResource: "location", withExtension: "mp4")!
                        asset = AVAsset(url: url)
                        
              }
             else if(notifyType == "notification" ){
                 permissionname.text = "Notification"
                 let url = Bundle.main.url(forResource: "notification", withExtension: "mp4")!
                       asset = AVAsset(url: url)
                       
             }
              // Create a new AVPlayerItem with the asset and an
              // array of asset keys to be automatically loaded
              playerItem = AVPlayerItem(asset: asset,
                                        automaticallyLoadedAssetKeys: requiredAssetKeys)
              
              // Register as an observer of the player item's status property
             /* playerItem.addObserver(self,
                                     forKeyPath: #keyPath(AVPlayerItem.status),
                                     options: [.old, .new],
                                     context: &playerItemContext)
              */
              
              
              // Associate the player item with the player
              player = AVPlayer(playerItem: playerItem)
              
              
              
              
               playerLayer = AVPlayerLayer(player: player)
              playerLayer.frame = view.bounds
              
              playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill//AVLayerVideoGravity.resizeAspect
              playerview.layer.addSublayer(playerLayer)
              player.play()
              NotificationCenter.default.addObserver(self,
                                                            selector: #selector(self.playerDidFinishPlaying(note:)),
                                                            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                            object: playerLayer.player?.currentItem)
         if(notifyType == "contact"){
         switchbut.setImage(UIImage(named: "cont_off"), for: .normal)
        }
         else if(notifyType == "location" ){
             switchbut.setImage(UIImage(named: "loc_off"), for: .normal)
        }
          else if(notifyType == "notification" ){
             switchbut.setImage(UIImage(named: "notificationoff"), for: .normal)
        }
    }
     @IBAction func switchAction(){
        if(ispermissionAllow){
            ispermissionAllow = false
            //switchbut.setTitle("OFF", for: .normal)
              if(notifyType == "contact"){
                     switchbut.setImage(UIImage(named: "cont_off"), for: .normal)
                    }
                     else if(notifyType == "location" ){
                         switchbut.setImage(UIImage(named: "loc_off"), for: .normal)
                    }
                      else if(notifyType == "notification" ){
                         switchbut.setImage(UIImage(named: "notificationoff"), for: .normal)
                    }
        }
        else{
            ispermissionAllow = true
             //switchbut.setImage(UIImage(named: "notificationon"), for: .normal)
            //switchbut.setTitle("ON", for: .normal)
            if(notifyType == "contact"){
                    switchbut.setImage(UIImage(named: "cont"), for: .normal)
                   }
                    else if(notifyType == "location" ){
                        switchbut.setImage(UIImage(named: "loc"), for: .normal)
                   }
                     else if(notifyType == "notification" ){
                        switchbut.setImage(UIImage(named: "notificationon"), for: .normal)
                   }
        }
    }
    @IBAction func nextAction(){
           if(ispermissionAllow){
              if(notifyType == "contact"){
               UserDefaults.standard.setValue("YES", forKey: "notifiedcontact")
               UserDefaults.standard.synchronize()
               
               self.dismiss(animated: true, completion: nil)
               let notificationName = Notification.Name("_GetPermissionsForContact")
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
            else if(notifyType == "notification")
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
           }
           else{
              self.dismiss(animated: true, completion: nil)
           }
       }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
                   let currentPlayer = playerLayer.player else {
                       return
               }
               if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
                   currentPlayer.seek(to: CMTime.zero)
                   currentPlayer.play()
        }
          // print(playerItem.currentTime())
      }
    @objc func audioRouteChangeListener(notification: NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
     
        switch audioRouteChangeReason {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            
            //if !playerLayer.player!.isPlaying
            //{
                playerLayer.player?.play()
            //}
            
            /*guard let playerItem = notification.object as? AVPlayerItem,
                       let currentPlayer = playerLayer.player else {
                           return
                   }
                   if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
                       
                    if !currentPlayer.isPlaying {
                        currentPlayer.play()
                    }
                    else
                    {
                    
                    }
                       
            }*/
            
            break
            
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            
            /*guard let playerItem = notification.object as? AVPlayerItem,
                       let currentPlayer = playerLayer.player else {
                           return
                   }
                   if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
                       
                    if !currentPlayer.isPlaying {
                        currentPlayer.play()
                    }
                    else
                    {
                    
                    }
                       
            }*/
            
            //if !playerLayer.player!.isPlaying
            //{
                playerLayer.player?.play()
            //}
            
            break
            
        default:
            break
        }
    }
    static var realDelegate: AppDelegate?;
          
          func appDelegate() -> AppDelegate {
              if Thread.isMainThread{
                  return UIApplication.shared.delegate as! AppDelegate;
              }
              let dg = DispatchGroup();
              dg.enter()
              DispatchQueue.main.async{
                  VideoPermissionScreen.realDelegate = UIApplication.shared.delegate as? AppDelegate;
                  dg.leave();
              }
              dg.wait();
              return VideoPermissionScreen.realDelegate!;
          }
}
