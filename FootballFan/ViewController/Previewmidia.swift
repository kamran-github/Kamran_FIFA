//
//  Previewmidia.swift
//  videoplayer
//
//  Created by Apple on 09/02/19.
//  Copyright © 2019 ashish. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation
import VersaPlayer
class Previewmidia: UIViewController{
    var videoURL: String?
     static private var playerViewControllerKVOContext = 0
  var timer = Timer()
    var timer1 = Timer()
     @IBOutlet var PlayIcon: UIButton!
    @IBOutlet var ForwardIcon: UIButton!
    @IBOutlet var RewardIcon: UIButton!
    @IBOutlet var muteIcon: UIButton!
    //@IBOutlet var currentTime: UILabel!
    @IBOutlet var totalTime: UILabel!
    // @IBOutlet var progressview: UIProgressView!
    @IBOutlet var sliderView: UISlider!
    @IBOutlet var shotImageView: UIImageView!
    var playerController: ASVideoPlayerController?
     var videoCellContainer: ASAutoPlayVideoLayerContainer?
    //var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var isplay : Bool = true
      var mediaType : String = ""
    @IBOutlet weak var progress: UIImageView!
    @IBOutlet weak var playerView: VersaPlayerView!
       @IBOutlet weak var controls: VersaPlayerControls!

   /* @IBAction func sliderValueChanged(sender: UISlider) {
        timer.invalidate()
        videoLayer.player?.pause()
        let currentValue = Float64(sender.value)
        //print("Slider changing to \(currentValue) ?")
        let duration : CMTime = videoLayer.player!.currentItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        //print("Slider seconds to \(seconds) ?")
        let seconds1 = seconds * currentValue
        
        hmsFrom(seconds: Int(round(seconds - seconds1))) { hours, minutes, seconds in
            
            let hours = self.getStringFrom(seconds: hours)
            let minutes = self.getStringFrom(seconds: minutes)
            let seconds = self.getStringFrom(seconds: seconds)
            
            self.totalTime.text = "\(hours):\(minutes):\(seconds)"
        }
        //currentTime.text = "\(round(seconds1))"
        //totalTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(round(seconds - seconds1))))"
        
        //print("Slider seconds1 to \(seconds1) ?")
        let fractionalProgress =  seconds1 / seconds
        sliderView.value = Float(fractionalProgress)
        let seek : CMTime = CMTimeMakeWithSeconds(seconds1,preferredTimescale: (videoLayer.player?.currentTime().timescale)!)
        //let seconds1 : Float64 = CMTimeGetSeconds(seek)
        videoLayer.player?.seek(to: seek)
        isplay = true
        PlayIcon.setBackgroundImage(UIImage(named:"pause"), for: .normal)
        videoLayer.player?.play()
        timer1.invalidate()
        runTimer1()
        runTimer()
        
        
    }
    
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return "\(seconds / 3600)" + ":" + "\((seconds % 3600) / 60)" + ":" + "\((seconds % 3600) % 60))"
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
*/
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        appDelegate().fanUpdateMute = true
        timer.invalidate()
//ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.player.isMuted = true
         Clslogging.logdebug(State: "Previewmidia End")
         appDelegate().ismodalshow = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if()
        /*
        if(videoLayer.player?.status == .readyToPlay){
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: videoLayer.player!.currentItem)
            runTimer()
        } */
       navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
         appDelegate().ismodalshow = true
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        }
      // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
   /* @objc func willEnterForeground() {
            print("will enter foreground")
        DispatchQueue.main.async {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.videoLayer.player!.currentItem)
            if(self.isplay == true){
                     //isplay = false
                     //PlayIcon.setBackgroundImage(UIImage(named:"lightbox_play"), for: .normal)
            self.videoLayer.player?.play()
                 }
           else{
                self.videoLayer.player?.pause()
        }
        }}*/
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener), name: AVAudioSession.routeChangeNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        //let notificationName = Notification.Name("previewplay")
        // Register to receive notification
       // NotificationCenter.default.addObserver(self, selector: #selector(Previewmidia.PlayAtIndex), name: notificationName, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

       /* NotificationCenter.default.addObserver(
            self, selector:
            #selector(Previewmidia.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)*/
        Clslogging.logdebug(State: "Previewmidia start")
        if(mediaType == "image")
        {
            shotImageView.imageURL = videoURL
            //progressview.isHidden = true
            sliderView.isHidden = true
            PlayIcon.isHidden = true
            ForwardIcon.isHidden = true
            RewardIcon.isHidden = true
            totalTime.isHidden = true
            shotImageView.contentMode = .scaleAspectFit
        }
        else{
            playerView.layer.backgroundColor = UIColor.black.cgColor
                  playerView.use(controls: controls)
                  
                  
                  
              
              
            if let url = URL.init(string: videoURL!) {
                      let item = VersaPlayerItem(url: url)
                      playerView.set(item: item)
                      
                      playerView.controls?.skipSize = 10
              NotificationCenter.default.addObserver(
              self,
              selector: #selector(self.playerDidFinishPlaying(note:)),
              name: NSNotification.Name(rawValue: "VERSA_PLAYER_END_PLAYING"),
              object: nil)
               let errorinfo:[String: AnyObject] = ["video": videoURL as AnyObject]
                Clslogging.loginfo(State: "Previewmidia", userinfo: errorinfo)
                  }
                  
                 // playerView.controls?.fullscreenButton?.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside);
                  
           /* if(appDelegate().fanUpdateMute){
               // cell.soundImg.image = UIImage(named: "sound_off")
                muteIcon.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
            }
            else{
                //cell.soundImg.image = UIImage(named: "sound_on")
               // muteIcon.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
                muteIcon.setBackgroundImage(UIImage(named: "mute"), for: .normal)
            }
        videoLayer.frame = self.shotImageView.bounds//CGRect(x: 0, y: 0, width: shotImageView.frame.height, height: shotImageView.frame.width)
            
        videoLayer.accessibilityValue = "preview"
        shotImageView.layer.addSublayer(videoLayer as CALayer)
        //ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL!)
             ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: self.videoLayer, url: self.videoURL!)
            }
        //ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: "http://apidev.ifootballfan.com/ffapi/media/Vid_andcon_10880076.mp4")
          // print(videoURL)
        //progressview.setProgress(Float(0.0), animated: false)
            sliderView.value = Float(0.0)
            sliderView.setThumbImage(UIImage(named: "uncheck"), for: .normal)
            sliderView.layer.cornerRadius = 10
            
           
           // sliderView.maximumValue = Float((videoLayer.player?.currentTime().seconds)!)
            
           // print(sliderView.maximumValue)
            
            
        shotImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Previewmidia.pushvideo(_:))))
        shotImageView.isUserInteractionEnabled = true*/
            /*videoLayer.player?.currentItem?.addObserver(self,
                                                           forKeyPath: "status",
                                                           options: [.new, .initial],
                                                           context: &Previewmidia.playerViewControllerKVOContext)
     // AVPlayerLayer.setNeedsDisplay(di)     //}*/
        
        }
        
        timer1.invalidate()
   // runTimer1()
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
    swipeRight.direction = UISwipeGestureRecognizer.Direction.up
  //  self.view.addGestureRecognizer(swipeRight)
        let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showcontrolls))
                   //longPressGesture.minimumPressDuration = 1.0 // 1 second press
                   longPressGesture.delegate = self as? UIGestureRecognizerDelegate
                   
                   
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
    swipeDown.direction = UISwipeGestureRecognizer.Direction.down
   // self.view.addGestureRecognizer(swipeDown)
        let uview = UIView()
            
            let rect = CGRect(x: 0, y: 0, width: playerView.frame.size.height, height: playerView.frame.size.width/2)
        
            uview.frame = rect
        playerView.addSubview(uview)
               controls.bringSubviewToFront(uview)
               uview.addGestureRecognizer(swipeDown)
        uview.addGestureRecognizer(swipeRight)
        uview.addGestureRecognizer(longPressGesture)
      /*  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of
            self.videoLayer.frame = self.shotImageView.bounds
            //animateProg(progressBar: cell.progress)
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "progress", withExtension: "gif")!)
            // let advTimeGif = UIImage.gifImageWithData(imageData!)
            self.progress.image = UIImage.gifImageWithData(imageData!)
            if (self.videoLayer.player?.status == .readyToPlay){
                self.progress.isHidden = true
                self.runTimer()
                 self.sliderView.isHidden = false
                 self.totalTime.isHidden = false
            }
        }*/
       // playerView.addGestureRecognizer(swipeRight)
        // playerView.addGestureRecognizer(swipeDown)
        playerView.isUserInteractionEnabled = true
}
    @objc func willEnterForeground() {
             print("will enter foreground")
            playerView.play()
         }

    
   /* @objc func PlayAtIndex(notification: NSNotification)
    {
        DispatchQueue.main.async {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.videoLayer.player!.currentItem)
        self.runTimer()
            self.progress.isHidden = true
            self.sliderView.isHidden = false
            self.totalTime.isHidden = false
        }
    }
    */
    
    @IBAction func soundClick() {
        if(appDelegate().fanUpdateMute){
            appDelegate().fanUpdateMute = false
            muteIcon.setBackgroundImage(UIImage(named: "mute"), for: .normal)
            ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.player.isMuted = false
            
        }
        else{
            appDelegate().fanUpdateMute = true
            muteIcon.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
            ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.player.isMuted = true
            // storyTableView?.reloadInputViews()
        }
    }
    @IBAction func closeClick() {
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
         self.navigationController?.popViewController(animated: true)
        }
        //self.dismiss(animated: true) {}
    }
     @objc func showcontrolls(gesture: UITapGestureRecognizer) {
        playerView.controls?.behaviour.show()
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                // print("Swiped down")
                
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
                }
                //self.dismiss(animated: true) {}
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                //print("Swiped up")
                // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                //self.navigationController?.popViewController(animated: true)
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
                }
                //self.dismiss(animated: true) {}
            default:
                break
            }
        }
    }
    
  /*  @IBAction func forwardClick() {
     //print(videoLayer.player?.currentTime().seconds)
        videoLayer.player?.seek(to: CMTimeMakeWithSeconds((videoLayer.player?.currentTime().seconds)! + 10, preferredTimescale: (videoLayer.player?.currentTime().timescale)!))
        isplay = true
        PlayIcon.setBackgroundImage(UIImage(named:"pause"), for: .normal)
        timer1.invalidate()
        runTimer1()
    }
    
    @IBAction func rewardClick() {
    // print(videoLayer.player?.currentTime().seconds)
        videoLayer.player?.seek(to: CMTimeMakeWithSeconds((videoLayer.player?.currentTime().seconds)! - 10, preferredTimescale: (videoLayer.player?.currentTime().timescale)!))
        isplay = true
        PlayIcon.setBackgroundImage(UIImage(named:"pause"), for: .normal)
        timer1.invalidate()
        runTimer1()
    }
    
    @IBAction func playClick() {
        if(isplay == true){
            isplay = false
            PlayIcon.setBackgroundImage(UIImage(named:"lightbox_play"), for: .normal)
            videoLayer.player?.pause()
        }
        else{
            isplay = true
            PlayIcon.setBackgroundImage(UIImage(named:"pause"), for: .normal)
            videoLayer.player?.play()
            timer1.invalidate()
            runTimer1()
            runTimer()
        }
    }*/
    
    /*
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            print("Swiped right")
        case UISwipeGestureRecognizerDirection.down:
           // print("Swiped down")
           /* let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            if(screenHeight < screenWidth){
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }*/
            self.navigationController?.popViewController(animated: false)
            
        case UISwipeGestureRecognizerDirection.left:
            print("Swiped left")
        case UISwipeGestureRecognizerDirection.up:
            //print("Swiped up")
              AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            self.navigationController?.popViewController(animated: false)
            
        default:
            break
        }
    }
} */
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            Previewmidia.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return Previewmidia.realDelegate!;
    }
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.view?.superview?.convert(shotImageView.frame, from: shotImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = view?.frame else {
                return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    //
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
      if let url = URL.init(string: videoURL!) {
              let item = VersaPlayerItem(url: url)
              playerView.set(item: item)
              
              playerView.controls?.skipSize = 30
      
      
              
          }
    }
    /*func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer(_:)) , userInfo: nil, repeats: true)
    }*/
    
  /*  func runTimer1() {
        if(isplay)
           {
            timer1 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(showhideControl(_:)) , userInfo: nil, repeats: true)
            
        } else {
            timer1.invalidate()
        }
        
     }*/
    
   /* @objc func showhideControl(_ notification: NSNotification) {
      DispatchQueue.main.async {
        if(self.isplay)
        {
            self.PlayIcon.isHidden = true
            self.ForwardIcon.isHidden = true
            self.RewardIcon.isHidden = true
            self.sliderView.isHidden = true
            self.muteIcon.isHidden = true
            self.totalTime.isHidden = true
            self.timer1.invalidate()
        } else {
            self.PlayIcon.isHidden = false
            self.ForwardIcon.isHidden = false
            self.RewardIcon.isHidden = false
            self.sliderView.isHidden = false
            self.muteIcon.isHidden = false
            self.totalTime.isHidden = false
            self.timer1.invalidate()
        }
        }
    }*/
    
 /*
    @objc func updateTimer(_ notification: NSNotification) {
        let duration : CMTime = videoLayer.player!.currentItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        let seek : CMTime = videoLayer.player!.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(seek)
        let fractionalProgress =  seconds1 / seconds
        //currentTime.text = "\(round(seconds1))"
        
        hmsFrom(seconds: Int(round(seconds - seconds1))) { hours, minutes, seconds in
            
            let hours = self.getStringFrom(seconds: hours)
            let minutes = self.getStringFrom(seconds: minutes)
            let seconds = self.getStringFrom(seconds: seconds)
            
            self.totalTime.text = "\(hours):\(minutes):\(seconds)"
        }
        
        //totalTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(round(seconds - seconds1))))"
       // lblOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
         //print("currentTime\( self.stringFromTimeInterval(interval: seconds1))")
         // print("durationTime\( self.stringFromTimeInterval(interval: seconds))")
       // progressview.setProgress(Float(fractionalProgress), animated: true)
        sliderView.value = Float(fractionalProgress)
    }
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
            let currentPlayer = videoLayer.player else {
                return
        }
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
            currentPlayer.seek(to: CMTime.zero)
            currentPlayer.play()
            //progressview.setProgress(Float(0.0), animated: false)
            sliderView.value = Float(0.0)
            if(appDelegate().fanUpdateMute){
                //appDelegate().fanUpdateMute = false
                // muteIcon.setBackgroundImage(UIImage(named: "mute"), for: .normal)
                ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.player.isMuted = true
                
            }
            else{
                //appDelegate().fanUpdateMute = true
                // muteIcon.setBackgroundImage(UIImage(named: "unmute"), for: .normal)
                ASVideoPlayerController.sharedVideoPlayer.currentVideoContainer()?.player.isMuted = false
                // storyTableView?.reloadInputViews()
            }
        }
       // print(playerItem.currentTime())
    }
    @objc func rotated(){
         // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
         videoLayer.frame = shotImageView.bounds
    }
 @objc func pushvideo(_ gesture: UITapGestureRecognizer) {
   // print("tap")
    if(PlayIcon.isHidden)
    {
    PlayIcon.isHidden = false
    ForwardIcon.isHidden = false
    RewardIcon.isHidden = false
        sliderView.isHidden = false
        muteIcon.isHidden = false
        totalTime.isHidden = false
        
    } else {
        if(isplay == true){
        PlayIcon.isHidden = true
        ForwardIcon.isHidden = true
        RewardIcon.isHidden = true
            sliderView.isHidden = true
            muteIcon.isHidden = true
            totalTime.isHidden = true
        } else {
            PlayIcon.isHidden = false
            ForwardIcon.isHidden = false
            RewardIcon.isHidden = false
            sliderView.isHidden = false
            muteIcon.isHidden = false
            totalTime.isHidden = false
        }
    }
    timer1.invalidate()
    runTimer1()
    /*
    if(isplay == true){
        isplay = false
        PlayIcon.image = UIImage(named:"play")
        ForwardIcon.image = UIImage(named:"forward_out")
        RewardIcon.image = UIImage(named:"forward_in")
        videoLayer.player?.pause()
    }
    else{
        isplay = true
         PlayIcon.image = UIImage(named:"uncheck")
        videoLayer.player?.play()
    } */
    }*/
    @objc func audioRouteChangeListener(notification: NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
     
        switch audioRouteChangeReason {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            
            //if !playerLayer.player!.isPlaying
            //{
                //playerView.player?.play()
            //}
                
                playerView.play()
            
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
                playerView.play()
            //}
            
            break
            
        default:
            break
        }
    }
}
