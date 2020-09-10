//
//  VideoObject.swift
//  AutoPlayVideo
//
//  Created by Ashish Singh on 12/4/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import UIKit
import AVFoundation
class ASVideoContainer {
    var url: String
    
    var playOn: Bool {
        didSet {
            player.isMuted = appDelegate().fanUpdateMute//ASVideoPlayerController.sharedVideoPlayer.mute
        
            playerItem.preferredPeakBitRate = ASVideoPlayerController.sharedVideoPlayer.preferredPeakBitRate
            if playOn && playerItem.status == .readyToPlay {
                player.play()
                //player.volume = 1.0
                
            }
            else{
                player.pause()
            }
        }
    }
    
    let player: AVPlayer
    let playerItem: AVPlayerItem
    
    init(player: AVPlayer, item: AVPlayerItem, url: String) {
        self.player = player
        self.playerItem = item
        self.url = url
        playOn = false
        
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ASVideoContainer.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ASVideoContainer.realDelegate!;
    }
}
