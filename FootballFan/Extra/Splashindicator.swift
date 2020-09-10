//
//  Splashindicator.swift
//  FootballFan
//
//  Created by Apple on 24/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//
import Foundation
import UIKit
class Splashindicator {
    
    static var currentOverlay : UIView?
    static var currentOverlayTarget : UIView?
    static var currentLoadingText: String?
    
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
        show(currentMainWindow, loadingText: loadingText)
    }
    
    static func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil)
    }
    
    static func show(_ overlayTarget : UIView, loadingText: String?) {
        // Clear it first in case it was already shown
        hide()
        
        // register device orientation notification
       /* NotificationCenter.default.addObserver(
            self, selector:
            #selector(LoadingIndicatorView.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)*/
        
        // Create the overlay
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.clear
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
         let imageView2 = UIImageView(image: UIImage(named: "LaunchImage"))
        imageView2.frame = CGRect(x:0 ,y: 0, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)
               imageView2.contentMode = .scaleToFill
               //imageView2.translatesAutoresizingMaskIntoConstraints = false
               //imageView2.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
               //imageView2.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
               overlay.addSubview(imageView2)
        
      
        // Animate the overlay to show
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 1 ? 0 : 1//0.85
        UIView.commitAnimations()
        
        currentOverlay = overlay
        currentOverlayTarget = overlayTarget
        currentLoadingText = loadingText
    }
    
    static func hide() {
        if currentOverlay != nil {
            
            // unregister device orientation notification
           /* NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange,                                                      object: nil)*/
           // DispatchQueue.main.async {
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
            currentLoadingText = nil
            currentOverlayTarget = nil
        }
    }
    
    @objc private static func rotated() {
        // handle device orientation change by reactivating the loading indicator
        if currentOverlay != nil {
            show(currentOverlayTarget!, loadingText: currentLoadingText)
        }
    }
}
