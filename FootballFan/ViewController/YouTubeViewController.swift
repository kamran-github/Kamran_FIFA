//
//  YouTubeViewController.swift
//  FootballFan
//
//  Created by Apple on 23/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import youtube_ios_player_helper
//import WebKit
class YouTubeViewController: UIViewController {
   // var webView : WKWebView!
    var didLoadVideo = false

    @IBOutlet weak var ytPlayerView: YTPlayerView!
    var videoID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       /* if #available(iOS 10.0, *) {
            webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        } else {
            // Fallback on earlier versions
            
        }*/
        loadVideo()
       // loadframe()
       // NotificationCenter.default.addObserver(self, selector: #selector(roteedinlandscape), name: UIWindow.didBecomeVisibleNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(roteedinpoterate), name: UIWindow.didBecomeHiddenNotification, object: nil)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
          swipeRight.direction = UISwipeGestureRecognizer.Direction.up
        //  self.view.addGestureRecognizer(swipeRight)
             
          let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
          swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        
        self.view.addGestureRecognizer(swipeDown)
              self.view.addGestureRecognizer(swipeRight)
            
    }
    
  
 

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
           if let swipeGesture = gesture as? UISwipeGestureRecognizer {
               switch swipeGesture.direction {
               case UISwipeGestureRecognizer.Direction.right:
                   print("Swiped right")
               case UISwipeGestureRecognizer.Direction.down:
                   // print("Swiped down")
                   
                  // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
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
                   //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.navigationController?.popViewController(animated: true)
                   }
                   //self.dismiss(animated: true) {}
               default:
                   break
               }
           }
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
    override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = false
    }
       @objc func roteedinlandscape(notification: NSNotification) {
        
    }
    @objc func roteedinpoterate(notification: NSNotification) {
       // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.navigationController?.popViewController(animated: true)
              }
      }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // ytPlayerView.backgroundColor = UIColor.black
    }
    @IBAction func closeClick() {
           
           //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
           }
           //self.dismiss(animated: true) {}
       }
  /*  func loadframe()  {
        
         // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        
            
    // DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    let myBlog = "http://apidev.ifootballfan.com/youtube.php?videoid=\(videoID)"
               let url = NSURL(string: myBlog)
               let request = NSURLRequest(url: url! as URL)

               // init and load request in webview.
        self.webView = WKWebView(frame: self.view.frame)
        //self.webView.navigationDelegate = self
        self.webView.load(request as URLRequest)
        self.webView.backgroundColor = UIColor.black
        self.view.addSubview(self.webView)
        self.view.sendSubviewToBack(self.webView)
 //   }
    }
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
           print(error.localizedDescription)
       }
       func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
           print("Strat to load")
       }
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           print("finish to load")
       }*/
    private func loadVideo(){
        // AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        let playerVars:[String: Any] = [
            "controls" : "0",
            "autoplay": "1",
            "rel": "0",
            "modestbranding": "0",
            "iv_load_policy" : "2",
            "fs": "1",
            "loop": "1",
            "playlist": videoID,
            "playsinline" : "0"
        ]
        
        ytPlayerView.delegate = self as? YTPlayerViewDelegate
        _ = ytPlayerView.load(withVideoId: videoID, playerVars: playerVars) //.load(withVideoId: "ohSK9ciol6k/9_u72pE4BMo")
        ytPlayerView.isUserInteractionEnabled = true
        //ytPlayerView.playVideo().
       
        
    }


}

extension YouTubeViewController: YTPlayerViewDelegate {
    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
        
    }
    
    public func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality :: ", quality)
    }
    
    //    func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView? {
    //        let loader = UIView(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
    //        loader.backgroundColor = UIColor.brown
    //        return loader
    //    }
}
