//
//  HurrayAnimationIndicator.swift
//  FootballFan
//
//  Created by Apple on 19/01/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

//import Foundation
//
//  AnimationIndicatorView.swift
//  FootballFan
//
//  Created by Apple on 13/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class HurrayAnimationIndicator:UIView {
    
    static var currentOverlay : UIView?
    static var currentOverlayTarget : UIView?
    static var currentLoadingText: String?
    static var currentCoin: String?
    static var currentgryview : UIView?
    static var audioPlayer = AVAudioPlayer()
    static func show() {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            // print("No main window.")
            return
        }
        show(currentMainWindow)
    }
    
    static func show(_ loadingText: String) {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            // print("No main window.")
            return
        }
        show(currentMainWindow, loadingText: loadingText,fancoins: nil)
    }
    
    static func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil, fancoins: nil)
    }
    
    static func show(_ overlayTarget : UIView, loadingText: String?, fancoins: String?) {
        // Clear it first in case it was already shown
        hide()
        
        // register device orientation notification
        /*NotificationCenter.default.addObserver(
            self, selector:
            #selector(HurrayAnimationIndicator.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)*/
        overlayTarget.endEditing(true)
        // Create the overlay
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.clear
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
        
        // overlayTarget.bringSubview(toFront: overlay)
        // Create and animate the activity indicator
        // Commented by Mayank due to hang issue.
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "giphy", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView2 = UIImageView(image: advTimeGif)
        imageView2.frame = CGRect(x:0 ,y: 0, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)
        imageView2.contentMode = .scaleToFill
        //imageView2.translatesAutoresizingMaskIntoConstraints = false
        //imageView2.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        //imageView2.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
        overlay.addSubview(imageView2)
        
        
        let gryview = UIView()
        //coinview.frame.origin = CGPoint(x: overlayTarget.center.x - 75, y: overlayTarget.center.y - 50)
        gryview.frame.size.width = 300
        //gryview.frame.size.height = 200//
        
        let underlineAttriString = NSMutableAttributedString(string: loadingText ?? "")
        let range1 = (loadingText! as NSString).range(of: "Learn more")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hex: "197DF6"), range: range1)
        
        
        
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = UIColor.white//init(hex: "ffc200")
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.textAlignment = .center
        label.attributedText = underlineAttriString
        label.frame.size.width = gryview.frame.width - 10
        label.sizeToFit()
        label.center = CGPoint(x: gryview.frame.width/2, y: 160)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLearnmore)))
        label.isUserInteractionEnabled = true
        
        gryview.addSubview(label)
        if((label.frame.height) > 19)
        {
            let height = (label.frame.height) + 150.0
            // cell.mainViewConstraint.constant = CGFloat(height)
            print("Height \(height).")
            //storyTableView?.rowHeight = CGFloat(height)
            //gryview.frame.size.width = //label.frame.width + 10
            gryview.frame.size.height = height
        }
        else
        {
            let height = 100.0
            // cell.mainViewConstraint.constant = CGFloat(height)
            print("Height \(height).")
            // storyTableView?.rowHeight = CGFloat(height)
            //gryview.frame.size.width = CGFloat(height)
            gryview.frame.size.height = CGFloat(height)
        }
        
        let coinview = UIView()
        coinview.frame.size.width = 70.0
        coinview.frame.size.height = 70.0
        coinview.center = CGPoint(x: gryview.center.x , y: 20)
        // coinview.center = gryview.center
        coinview.backgroundColor = UIColor.clear
        gryview.addSubview(coinview)
        
        let forwardImg = UIImage(named: "ffcoin")
        let imageViewTeam = UIImageView(image: forwardImg)
        imageViewTeam.frame = CGRect(x: 0, y: 70, width: 60.0, height: 60.0)
        
        //imageViewTeam.frame.size.width = 50.0
        // imageViewTeam.frame.size.height = 50.0
        // imageViewTeam.center = coinview.center
        coinview.addSubview(imageViewTeam)
        gryview.center = overlayTarget.center
        gryview.alpha = 0.95
        gryview.layer.cornerRadius = 20.0
        //gryview.roundCorners(corners: <#T##UIRectCorner#>, radius: <#T##CGFloat#>)
        gryview.backgroundColor = UIColor.darkGray
        overlay.addSubview(gryview)
        /* let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
         indicator.center = overlay.center
         indicator.startAnimating()
         overlay.addSubview(indicator)*/
        let lblforward = UILabel(frame: CGRect(x: 0.0, y: 5.0, width: 300, height: 50.0))//changed
        // lblforward.font = UIFont.systemFont(ofSize: 30)
        lblforward.font = UIFont.boldSystemFont(ofSize: 25)
        lblforward.text = "Hurray!!"
        lblforward.textAlignment = .center
        lblforward.textColor = UIColor.white//init(hex: "ffc200")
        lblforward.numberOfLines = 1
        //lblforward.backgroundColor = UIColor.green
        //lblforward.sizeToFit()
        gryview.addSubview(lblforward)
        /* let lblforward = UILabel(frame: CGRect(x: 60.0, y: 10.0, width: 100, height: 50.0))//changed
         // lblforward.font = UIFont.systemFont(ofSize: 30)
         lblforward.font = UIFont.boldSystemFont(ofSize: 30)
         lblforward.text = fancoins
         lblforward.textAlignment = .left
         lblforward.textColor = UIColor.white//init(hex: "ffc200")
         lblforward.numberOfLines = 1
         lblforward.sizeToFit()
         coinview.addSubview(lblforward)*/
        // Create label
        // if let textString = loadingText {
        
        //}
        // overlayTarget.addSubview(coinview)
        
        
        
        // Animate the overlay to show
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.85
        UIView.commitAnimations()
        
        
        currentOverlay = overlay
        currentOverlayTarget = overlayTarget
        currentLoadingText = loadingText
        currentCoin = fancoins
        currentgryview = gryview
        DispatchQueue.main.asyncAfter(deadline: .now() +  5.0) {
            hide()
            
        }
        
        
        let path = Bundle.main.url(forResource: "won", withExtension: "mp3")!
        //Bundle.main.path(forResource: "football_crowd", ofType: "mp3")!
        //let url = URL(fileURLWithPath: path)
        
        do {
            
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
            try! AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: path, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer.numberOfLoops = 1
            audioPlayer.prepareToPlay()
            //if let fileURL = Bundle.main.path(forResource: "football_crowd.mp3", ofType: nil) {
            audioPlayer.play()
            //} else {
            // print("No file with specified name exists")
            //}
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        
        
        
    }
    
    static func hide() {
        if currentOverlay != nil {
            
            if(audioPlayer != nil)
            {
                audioPlayer.stop()
            }
            
            // unregister device orientation notification
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification,                                                      object: nil)
            
            
            currentOverlay?.removeAllSubviews()
            currentLoadingText = nil
            currentOverlayTarget = nil
            currentgryview?.removeAllSubviews()
            currentOverlay?.removeFromSuperview()
        }
    }
    
    @objc private static func rotated() {
        // handle device orientation change by reactivating the loading indicator
        if currentOverlay != nil {
            show(currentOverlayTarget!, loadingText: currentLoadingText, fancoins: currentCoin)
        }
    }
    @objc private static func tapLearnmore(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            if let theLabel = (gesture.view as? UILabel)?.text {
                // print(theLabel) // print the "1"
                let privacyRange = (theLabel as NSString).range(of: "Learn more")
                if gesture.didTapAttributedTextInLabel(label: (gesture.view as? UILabel)!, inRange: privacyRange) {
                    print("Tapped terms")
                    // hide()
                    UserDefaults.standard.setValue("Earn more FanCoins?", forKey: "terms")
                    UserDefaults.standard.synchronize()
                    hide()
                    let notificationName2 = Notification.Name("learnMore")
                    NotificationCenter.default.post(name: notificationName2, object: nil)
                    
                    
                }
            }
        }
        /* let text = (notlabel!.text)!
         let termsRange = (text as NSString).range(of: "Terms & Conditions")
         let privacyRange = (text as NSString).range(of: "Privacy Policy")
         let LicensedUser = (text as NSString).range(of: "EULA")
         
         if gesture.didTapAttributedTextInLabel(label: notlabel!, inRange: termsRange) {
         // print("Tapped terms")
         UserDefaults.standard.setValue("Terms & Conditions", forKey: "terms")
         UserDefaults.standard.synchronize()
         
         
         }*/
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
