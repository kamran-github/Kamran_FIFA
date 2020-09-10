//
//  VideoPlayerController.swift
//  AutoPlayVideo
//
//  Created by Ashish Singh on 12/3/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Protocol that needs to be adopted by subclass of any UIView
 that wants to play video.
 */
protocol ASAutoPlayVideoLayerContainer {
    var videoURL: String? { get set }
    var videoLayer: AVPlayerLayer { get set }
    func visibleVideoHeight() -> CGFloat
}

class ASVideoPlayerController: NSObject, NSCacheDelegate {
    var minimumLayerHeightToPlay: CGFloat = 60
    // Mute unmute video
    var mute = true
    var preferredPeakBitRate: Double = 1000000
    static private var playerViewControllerKVOContext = 0
    static let sharedVideoPlayer = ASVideoPlayerController()
    //video url for currently playing video
    private var videoURL: String?
    /**
     Stores video url as key and true as value when player item associated to the url
     is being observed for its status change.
     Helps in removing observers for player items that are not being played.
     */
    private var observingURLs = Dictionary<String, Bool>()
    // Cache of player and player item
    private var videoCache = NSCache<NSString, ASVideoContainer>()
    private var videoLayers = VideoLayers()
    // Current AVPlapyerLayer that is playing video
    private var currentLayer: AVPlayerLayer?
    
    override init() {
        super.init()
        videoCache.delegate = self
    }
    
    /**
     Download of an asset of url if corresponding videocontainer
     is not present.
     Uses the asset to create new playeritem.
     */
    func setupVideoFor(url: String) {
        if self.videoCache.object(forKey: url as NSString) != nil {
            return
        }
        guard let URL = URL(string: url) else {
            return
        }
        let asset = AVURLAsset(url: URL)
        let requestedKeys = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKeys) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            /**
             Need to check whether asset loaded successfully, if not successful then don't create
             AVPlayer and AVPlayerItem and return without caching the videocontainer,
             so that, the assets can be tried to be downloaded again when need be.
             */
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
                case .loaded:
                    break
                
                case .failed, .cancelled:
                    print("Failed to load asset successfully")
                   // print(error)
                    return
                default:
                    print("Unkown state of asset")
                    return
            }
            let player = AVPlayer()
            let item = AVPlayerItem(asset: asset)
            DispatchQueue.main.async {
                let videoContainer = ASVideoContainer(player: player, item: item, url: url)
                strongSelf.videoCache.setObject(videoContainer, forKey: url as NSString)
                videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
               
                /**
                 Try to play video again in case when playvideo method was called and
                 asset was not obtained, so, earlier video must have not run
                 */
                if strongSelf.videoURL == url, let layer = strongSelf.currentLayer {
                    strongSelf.playVideo(withLayer: layer, url: url)
                }
            }
        }
    }
    // Play video with the AVPlayerLayer provided
    func playVideo(withLayer layer: AVPlayerLayer, url: String) {
        videoURL = url
        currentLayer = layer
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            layer.player = videoContainer.player
            videoContainer.playOn = true
            addObservers(url: url, videoContainer: videoContainer)
        }
        // Give chance for current video player to be ready to play
        DispatchQueue.main.async {
            if let videoContainer = self.videoCache.object(forKey: url as NSString),
                videoContainer.player.currentItem?.status == .readyToPlay  {
                videoContainer.playOn = true
               // videoContainer.player.isMuted = false
               // layer.backgroundColor = UIColor.black.cgColor
                
            }
          //  layer.backgroundColor = UIColor.black.cgColor
        }
    }
    
    private func pauseVideo(forLayer layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            //videoContainer.play = false
            removeObserverFor(url: url)
            //layer.backgroundColor = UIColor.clear.cgColor
        }
        //layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func removeLayerFor(cell: ASAutoPlayVideoLayerContainer) {
        if let url = cell.videoURL {
            removeFromSuperLayer(layer: cell.videoLayer, url: url)
        }
    }
    
    private func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
        layer.player = nil
    }
    
    private func pauseRemoveLayer(layer: AVPlayerLayer,url: String, layerHeight: CGFloat) {
        pauseVideo(forLayer: layer, url: url)
    }
    
    // Play video again in case the current player has finished playing
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
            let currentPlayer = currentVideoContainer()?.player else {
                return
        }
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
            currentPlayer.seek(to: CMTime.zero)
            currentPlayer.play()
        }
    }
    
     func currentVideoContainer() -> ASVideoContainer? {
        if let currentVideoUrl = videoURL {
            if let videoContainer = videoCache.object(forKey: currentVideoUrl as NSString) {
                return videoContainer
            }
        }
        return nil
    }
    
    private func addObservers(url: String, videoContainer: ASVideoContainer) {
        if self.observingURLs[url] == false || self.observingURLs[url] == nil {
            videoContainer.player.currentItem?.addObserver(self,
                                                           forKeyPath: "status",
                                                           options: [.new, .initial],
                                                           context: &ASVideoPlayerController.playerViewControllerKVOContext)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: videoContainer.player.currentItem)
           /* videoContainer.player.currentItem?.addObserver(self,
                                                           forKeyPath: "rate",
                                                           options: NSKeyValueObservingOptions.new,
                                                           context: nil)*/

            
            self.observingURLs[url] = true
        }
    }
   
    private func removeObserverFor(url: String) {
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            if let currentItem = videoContainer.player.currentItem, observingURLs[url] == true {
                currentItem.removeObserver(self,
                                           forKeyPath: "status",
                                           context: &ASVideoPlayerController.playerViewControllerKVOContext)
                NotificationCenter.default.removeObserver(self,
                                                          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                          object: currentItem)
                observingURLs[url] = false
            }
        }
    }
    
    /**
     Play UITableViewCell's videoplayer that has max visible video layer height
     when the scroll stops.
     */
    func pausePlayeVideosFor(tableView: UITableView, appEnteredFromBackground: Bool = false) {
        let visisbleCells = tableView.visibleCells
        var videoCellContainer: ASAutoPlayVideoLayerContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in visisbleCells {
            guard let containerCell = cellView as? ASAutoPlayVideoLayerContainer,
                let videoCellURL = containerCell.videoURL else {
                    continue
            }
            let height = containerCell.visibleVideoHeight()
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = containerCell
            }
           // containerCell.videoLayer.backgroundColor = UIColor.clear.cgColor
            pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
        }
        guard let videoCell = videoCellContainer,
            let videoCellURL = videoCell.videoURL else {
            return
        }
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5
       // videoCell.videoLayer.backgroundColor = UIColor.black.cgColor
        /**
         Visible video layer height should be at least more than max of predefined minimum height and
         cell's videolayer's 50% height to play video.
         */
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
             videoCell.videoLayer.backgroundColor = UIColor.black.cgColor
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        }
    }
   /* func pausePlayeVideosForpreview(tableView: UIImageView, appEnteredFromBackground: Bool = false) {
        let visisbleCells = tableView.visibleCells
        var videoCellContainer: ASAutoPlayVideoLayerContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in visisbleCells {
            guard let containerCell = cellView as? ASAutoPlayVideoLayerContainer,
                let videoCellURL = containerCell.videoURL else {
                    continue
            }
            let height = containerCell.visibleVideoHeight()
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = containerCell
            }
            pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
        }
        guard let videoCell = videoCellContainer,
            let videoCellURL = videoCell.videoURL else {
                return
        }
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5
        /**
         Visible video layer height should be at least more than max of predefined minimum height and
         cell's videolayer's 50% height to play video.
         */
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        }
    }*/
    
    // Set observing urls false when objects are removed from cache
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? ASVideoContainer {
            observingURLs[videoObject.url] = false
        }
    }
    
    // Play video only when current videourl's player is ready to play
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &ASVideoPlayerController.playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == "status" {
            /**
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            //print("status")
           /* let activityIndicatorView = UIActivityIndicatorView()
            activityIndicatorView.center = CGPoint(x:50 , y: 50)
            let loadingTextLabel = UILabel()
            
            loadingTextLabel.textColor = UIColor.white
            loadingTextLabel.text = "Downloading video..."
            //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
            loadingTextLabel.sizeToFit()
            loadingTextLabel.frame = (currentLayer?.bounds)!//CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
           // viewForActivityIndicator.addSubview(loadingTextLabel)
            self.currentLayer?.addSublayer(loadingTextLabel.layer)
            
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.activityIndicatorViewStyle = .white
           // viewForActivityIndicator.addSubview(activityIndicatorView)
            currentLayer?.addSublayer(activityIndicatorView.layer)
            
            //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
            activityIndicatorView.startAnimating()*/
            let newStatus: AVPlayerItem.Status
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
                if newStatus == .readyToPlay {
                    guard let item = object as? AVPlayerItem,
                        let currentItem = currentVideoContainer()?.player.currentItem else {
                           // print("ravi ready to play")
                            
                            return
                    }
                    if item == currentItem && currentVideoContainer()?.playOn == true {
                        currentVideoContainer()?.playOn = true
                        // print("ravi 2 ready to play")
                        let notifyallow = currentLayer?.accessibilityValue as! String
                        if(notifyallow == "preview"){
                      
                            let notificationName = Notification.Name("previewplay")
                            NotificationCenter.default.post(name: notificationName, object: nil)
                        }
                        else  if(notifyallow == "previewport"){
                            
                            let notificationName = Notification.Name("previewplayport")
                            NotificationCenter.default.post(name: notificationName, object: nil)
                        }
                        else if(notifyallow == "Detail"){
                            let notificationName = Notification.Name("Detailplay")
                            NotificationCenter.default.post(name: notificationName, object: nil)
                        }
                        else{
                            let pickedCaption:[String: Any] = ["subcriptiontype": currentLayer?.accessibilityValue as Any]
                            let notificationName = Notification.Name("videoplayAtindex")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: pickedCaption)
                        }
                    }
                }
            }
            else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                
            }
        }
        else if keyPath == "rate" {
            
            print("rate")
            
        }
        
    }
    
    deinit {
        
    }
}
