//
//  FanUpdatesswift
//  FootballFan
//
//  Created by Ravikant Nagar on 07/10/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import AVFoundation
//import GTProgressBar

class MediaCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    @IBOutlet weak var fanName: UILabel?
    @IBOutlet weak var teamImage: UIImageView?
    @IBOutlet weak var fanImage: UIImageView?
    @IBOutlet weak var soundImg: UIImageView!
     @IBOutlet weak var TitelName: UILabel?
     @IBOutlet weak var TeamName: UILabel?
    @IBOutlet weak var Time: UILabel?
    @IBOutlet weak var LikeCount: UILabel?
    @IBOutlet weak var CommentCount: UILabel?
    @IBOutlet weak var ViewCount: UILabel?
      @IBOutlet weak var ContentText: UILabel?
    @IBOutlet weak var ContentImage: UIImageView!
    @IBOutlet weak var PlayImage: UIImageView?
     @IBOutlet weak var subType: UILabel!
    @IBOutlet weak var deleteUpdate: UILabel!
    @IBOutlet weak var editUpdate: UILabel!
    @IBOutlet weak var editImage: UIImageView?
    @IBOutlet weak var deleteImage: UIImageView?
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var progress: UIImageView!
    @IBOutlet weak var like: UIView!
    @IBOutlet weak var share: UIView!
    @IBOutlet weak var comment: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeText: UIButton!
     @IBOutlet weak var TypeImage: UIImageView!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentText: UIButton!
    
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareText: UIButton!
    @IBOutlet weak var imgmenu: UIImageView?
 @IBOutlet weak var coontentview: UIView!
     @IBOutlet weak var Headerview: UIView!
     @IBOutlet weak var LCSview: UIView!
     @IBOutlet weak var LCcounttview: UIView!
    @IBOutlet weak var Mainview: UIView!
    
    //Ravi Media
    @IBOutlet weak var lblSource: UILabel?
    @IBOutlet weak var btnSource: UIButton!
    @IBOutlet weak var imgTopConstant: NSLayoutConstraint!
    @IBOutlet weak var lblSourceTop: NSLayoutConstraint!
    //Ravi Media
    
    
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
     @IBOutlet weak var platformLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fanImage?.layer.masksToBounds = true;
        fanImage?.layer.borderWidth = 1.0
        fanImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor //self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        fanImage?.layer.cornerRadius = 17.5
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.frame = ContentImage.bounds
       // videoLayer.videoGravity = .resizeAspect
        //videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        // videoLayer.frame = ContentImage.frame//CGRect(x: 0, y: 0, width: width, height: height)
        ContentImage.layer.addSublayer(videoLayer)
        let notificationName = Notification.Name("videoplayAtindex")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MediaCell.PlayAtIndex), name: notificationName, object: nil)
        
    }
    @objc func PlayAtIndex(notification: NSNotification)
    {
       /* let inmycontacts = (notification.userInfo?["subcriptiontype"] )as! String
        if let curentlayer: String = videoLayer.accessibilityValue {
        if(appDelegate().isOnMyFanStories){
            if(curentlayer == inmycontacts){
                print(curentlayer)
                progress?.isHidden = true
                print(inmycontacts)
                var dict1: [String: AnyObject] = appDelegate().arrMyFanUpdatesTeams[Int(inmycontacts)!] as! [String: AnyObject]
                dict1["isloader"] = false as AnyObject
                
                appDelegate().arrMyFanUpdatesTeams[Int(inmycontacts) ?? 0] = dict1 as AnyObject
            }
        }
        else{
            if(curentlayer == inmycontacts){
               // print(curentlayer)
                progress?.isHidden = true
                print(inmycontacts)
                var dict1: [String: AnyObject] = appDelegate().arrMedia[Int(inmycontacts)!] as! [String: AnyObject]
                dict1["isloader"] = false as AnyObject
                
                appDelegate().arrMedia[Int(inmycontacts) ?? 0] = dict1 as AnyObject
            }
        }
        }
        */
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MediaCell.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MediaCell.realDelegate!;
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.7).rounded(.up)
       // videoLayer.frame = ContentImage.frame//CGRect(x: 0, y: 0, width: width, height: height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?,layertag:String) {
        //self.descriptionLabel.text = description
        //if(videoUrl == nil){
        self.ContentImage.imageURL = imageUrl
        // }
        self.videoURL = videoUrl
           videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.accessibilityValue = layertag
        // let image = shotImageView.image
        //if(image != nil){
        //  self.feedImageHeightConstraint.constant = getAspectRatioAccordingToiPhones(cellImageFrame: bounds.size, downloadedImage: image!)
        // }
        
    }
    override func prepareForReuse() {
        ContentImage.imageURL = nil
        super.prepareForReuse()
    }
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(ContentImage.frame, from: ContentImage)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
                return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        //print(visibleVideoFrame.size.height)
        return visibleVideoFrame.size.height
    }
}

