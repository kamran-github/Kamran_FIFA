//
//  LiveStrimingViewController.swift
//  FootballFan
//
//  Created by Apple on 16/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import AVKit
class LiveStrimingViewController: UIViewController{
    var url: URL!
    var videoURL: String?
       var asset: AVAsset!
       var player: AVPlayer = AVPlayer()
       var playerItem: AVPlayerItem!
       var timeObserverToken: Any?
    private var playerItemContext = 0
        var triviadetail: NSDictionary = [:]
       var gameTimer: Timer?
       
       let requiredAssetKeys = [
           "playable",
           "hasProtectedContent"
       ]
       var justStalled = 0
     @IBOutlet weak var playerview: UIView!
     //@IBOutlet var sliderView: UISlider!
    // var timer = Timer()
     //@IBOutlet var totalTime: UILabel!
    override func viewDidLoad() {
           super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
           swipeRight.direction = UISwipeGestureRecognizer.Direction.up
           self.view.addGestureRecognizer(swipeRight)
           
           let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
           swipeDown.direction = UISwipeGestureRecognizer.Direction.down
           self.view.addGestureRecognizer(swipeDown)
           NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener), name: AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
       
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
         appDelegate().ismodalshow = false
         navigationController?.isNavigationBarHidden = true
      }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
       // timer.invalidate()
       
    }
    func closeView(){
        navigationController?.isNavigationBarHidden = false
        //player.removeObserver(self, forKeyPath: "status")
          // player.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
               self.player = AVPlayer()
               self.stopTimerTest()
        self.player.pause()
                 Clslogging.logdebug(State: "LiveStrimingViewController End")
        //appDelegate().HomeSetSlider = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
         self.navigationController?.popViewController(animated: true)
        }
    }
override func viewWillAppear(_ animated: Bool) {
     appDelegate().ismodalshow = true
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
  AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
  // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
   // navigationController?.isNavigationBarHidden = true
    url = URL(string: videoURL!)
     DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.prepareToPlay()
          //gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(createPlayerObserver), userInfo: nil, repeats: true)
        //self.runTimer()
          if #available(iOS 10.0, *) {
            self.startTimerShort()
          } else {
              // Fallback on earlier versions
            let errorinfo:[String: AnyObject] = ["versions": "Fallback on earlier versions" as AnyObject]
                                    Clslogging.loginfo(State: "LiveStrimingViewController", userinfo: errorinfo)
          }
    }
      Clslogging.logdebug(State: "LiveStrimingViewController start")
   // sliderView.value = Float(0.0)
    //sliderView.setThumbImage(UIImage(named: "uncheck"), for: .normal)
    //sliderView.layer.cornerRadius = 10
    
}
   /* func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer(_:)) , userInfo: nil, repeats: true)
    }*/
   /* @objc func updateTimer(_ notification: NSNotification) {
          let duration : CMTime = player.currentItem!.asset.duration
          let seconds : Float64 = CMTimeGetSeconds(duration)
          let seek : CMTime = player.currentTime()
          let seconds1 : Float64 = CMTimeGetSeconds(seek)
          let fractionalProgress =  seconds1 / seconds
          //currentTime.text = "\(round(seconds1))"
          
        hmsFrom(seconds: Int(seconds1)) { hours, minutes, seconds in
              
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
      }*/
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
           
           completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
           
       }
       func getStringFrom(seconds: Int) -> String {
             
             return seconds < 10 ? "0\(seconds)" : "\(seconds)"
         }

    @IBAction func closeClick() {
           
           AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        closeView()
        //self.navigationController?.popViewController(animated: true)
          // self.dismiss(animated: true) {}
       }
    func prepareToPlay() {
          // Create the asset to play
          asset = AVAsset(url: url)
          let errorinfo:[String: AnyObject] = ["video": url as AnyObject]
                         Clslogging.loginfo(State: "LiveStrimingViewController prepareToPlay", userinfo: errorinfo)
          // Create a new AVPlayerItem with the asset and an
          // array of asset keys to be automatically loaded
          playerItem = AVPlayerItem(asset: asset,
                                    automaticallyLoadedAssetKeys: requiredAssetKeys)
          
          // Register as an observer of the player item's status property
          playerItem.addObserver(self,
                                 forKeyPath: #keyPath(AVPlayerItem.status),
                                 options: [.old, .new],
                                 context: &playerItemContext)
          
          
          
          // Associate the player item with the player
          player = AVPlayer(playerItem: playerItem)
          
          
          
          
          let playerLayer = AVPlayerLayer(player: player)
          playerLayer.frame = view.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
          playerview.layer.addSublayer(playerLayer)
          player.play()
          //player.automaticallyWaitsToMinimizeStalling = true
          //player.playImmediately(atRate: 0.1)
          //player.preventsDisplaySleepDuringVideoPlayback = true
          
          
          // Add observer for AVPlayer status and AVPlayerItem status
          /*playerLayer.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
           playerLayer.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)*/
          
          
          
          
          /* NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlay(_:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
           
           
           
           playerItem?.observe(\AVPlayerItem.status, changeHandler: { observedPlayerItem, change in
           if (observedPlayerItem.status == AVPlayerItem.Status.readyToPlay) {
           print("Current stream duration \(observedPlayerItem.duration.seconds)")
           }
           })*///
          
          //let timeScale = CMTimeScale(NSEC_PER_SEC)
          //let time = CMTime(seconds: 3.0, preferredTimescale: timeScale)
          
          
      }
    static var realDelegate: AppDelegate?;
       
       func appDelegate() -> AppDelegate {
           if Thread.isMainThread{
               return UIApplication.shared.delegate as! AppDelegate;
           }
           let dg = DispatchGroup();
           dg.enter()
           DispatchQueue.main.async{
               LiveStrimingViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
               dg.leave();
           }
           dg.wait();
           return LiveStrimingViewController.realDelegate!;
       }
       func addPeriodicTimeObserver() {
           // Notify every half second
           let timeScale = CMTimeScale(NSEC_PER_SEC)
           let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
           
           timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                              queue: .main) {
                                                               [weak self] time in
                                                               // update player transport UI
           }
       }
    @available(iOS 10.0, *)
      func startTimerShort () {
          guard gameTimer == nil else { return }
          
          gameTimer =  Timer.scheduledTimer(
              timeInterval: TimeInterval(5),
              target      : self,
              selector    : #selector(createPlayerObserver),
              userInfo    : nil,
              repeats     : true)
      }
      
      func stopTimerTest() {
          gameTimer?.invalidate()
          gameTimer = nil
      }
    @objc func createPlayerObserver()
      {
         
            DispatchQueue.main.async {
              if #available(iOS 10.0, *) {
                  print(self.player.timeControlStatus.rawValue)
              } else {
                  // Fallback on earlier versions
              }
              
              
              //print(player.isPlaying)
              if #available(iOS 10.0, *) {
                  if(self.player.timeControlStatus.rawValue == 0)
                  {
                      self.justStalled = 0
                      print(self.player.timeControlStatus.rawValue)
                      self.prepareToPlay()
                  }
                  else if(self.player.timeControlStatus.rawValue == 1)
                  {
                      if(self.justStalled == 1)
                      {
                          self.stopTimerTest()
                          self.startTimer()
                          self.prepareToPlay()
                          //stopTimerTest()
                          //startTimer()
                      }
                      else
                      {
                          self.stopTimerTest()
                          self.startTimer()
                          self.justStalled = 1
                      }
                  }
                  else if(self.player.timeControlStatus.rawValue == 2)
                  {
                      self.justStalled = 0
                  }
              } else {
                  // Fallback on earlier versions
              }
          }
          
          /*playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
           
           playerItem.addObserver(self,
           forKeyPath: #keyPath(AVPlayerItem.status),
           options: [.new],
           context: &playerItemContext)*/
      }
    func startTimer () {
          guard gameTimer == nil else { return }
          
          gameTimer =  Timer.scheduledTimer(
              timeInterval: TimeInterval(5),
              target      : self,
              selector    : #selector(createPlayerObserver),
              userInfo    : nil,
              repeats     : true)
      }
      override func observeValue(forKeyPath keyPath: String?,
                                   of object: Any?,
                                   change: [NSKeyValueChangeKey : Any]?,
                                   context: UnsafeMutableRawPointer?) {
            
            // Only handle observations for the playerItemContext
            guard context == &playerItemContext else {
                super.observeValue(forKeyPath: keyPath,
                                   of: object,
                                   change: change,
                                   context: context)
                return
            }
            
            if keyPath == #keyPath(AVPlayerItem.status) {
                let status: AVPlayerItem.Status
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                // Switch over status value
                switch status {
                case .readyToPlay:
                    
                    //addPeriodicTimeObserver()
                    stopTimerTest()
                    startTimer()
                    /*timeObserverToken = player.addBoundaryTimeObserver(
                     forTimes: [0.5 as NSValue],
                     queue: DispatchQueue.main) { [weak self] in
                     print("The audio is in fact beginning about now...")
                     }*/
                    
                    
                    break
                // Player item is ready to play.
                case .failed:
                    justStalled = 0
                    stopTimerTest()
                    if #available(iOS 10.0, *) {
                        startTimerShort()
                    } else {
                        // Fallback on earlier versions
                    }
                    let errorinfo:[String: AnyObject] = ["observeValue": "status Failed" as AnyObject]
                                                                   Clslogging.logerror(State: "LiveStrimingViewController", userinfo: errorinfo)
                    print("Failed...")
                    break
                    // Player item failed. See error.
                    
                case .unknown:
                    print("Unknown...")
                    break
                    // Player item is not yet ready.
                    
                @unknown default:
                    print("Fatal...")
                    fatalError()
                    let errorinfo:[String: AnyObject] = ["observeValue": fatalError as AnyObject]
                    Clslogging.logerror(State: "LiveStrimingViewController", userinfo: errorinfo)
                }
            }
        }
        @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
               if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                   switch swipeGesture.direction {
                   case UISwipeGestureRecognizer.Direction.right:
                       print("Swiped right")
                   case UISwipeGestureRecognizer.Direction.down:
                       // print("Swiped down")
                       
                       AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                    closeView()
                    //self.navigationController?.popViewController(animated: true)
                      // self.dismiss(animated: true) {}
                   case UISwipeGestureRecognizer.Direction.left:
                       print("Swiped left")
                   case UISwipeGestureRecognizer.Direction.up:
                       //print("Swiped up")
                       // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                       //self.navigationController?.popViewController(animated: true)
                       AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                    closeView()
                       //self.navigationController?.popViewController(animated: true)
                      // self.dismiss(animated: true) {}
                   default:
                       break
                   }
               }
           }
           @objc func audioRouteChangeListener(notification: NSNotification) {
               let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
            
               switch audioRouteChangeReason {
               case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
                   
                   //if !playerLayer.player!.isPlaying
                   //{
                       player.play()
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
                       player.play()
                   //}
                   
                   break
                   
               default:
                   break
               }
           }
    @objc func willEnterForeground() {
            print("will enter foreground")
          player.play()
        }
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
