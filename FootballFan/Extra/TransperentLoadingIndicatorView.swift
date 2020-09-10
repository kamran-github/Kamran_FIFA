//
//  TransperentLoadingIndicatorView.swift
//  FootballFan
//
//  Created by Apple on 18/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
class TransperentLoadingIndicatorView {
    
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
        
        // Create and animate the activity indicator
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        let bounds: CGRect = UIScreen.main.bounds
               //var width:CGFloat = bounds.size.width
               let height:CGFloat = bounds.size.height
               print(height)
              if(height > 800){
                     indicator.frame.origin.y = 100.0//overlay.center
                            }else{
                              indicator.frame.origin.y = 80.0
                     }
        indicator.frame.origin.x = overlay.center.x
        indicator.startAnimating()
        indicator.tintColor = UIColor.darkGray
        overlay.addSubview(indicator)
        
        // Create label
        if let textString = loadingText {
            let label = UILabel()
            label.text = "\(textString)"
            label.textColor = UIColor.gray
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 5
            label.textAlignment = .center
            label.frame.size.width = UIScreen.main.bounds.size.width - 40
            label.sizeToFit()
            label.center = CGPoint(x: indicator.center.x, y: (indicator.center.y + label.frame.height) + 10.0)
            overlay.addSubview(label)
        }
        
        // Animate the overlay to show
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.85
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
