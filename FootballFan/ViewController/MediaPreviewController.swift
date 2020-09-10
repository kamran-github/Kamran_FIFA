//
//  MediaPreviewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 06/10/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import AVKit
import Photos
//import AVFoundation
//import AssetsLibrary

class MediaPreviewController: UIViewController, UIScrollViewDelegate, AVPlayerViewControllerDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var btnClose: UIButton?
     @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidthConstraint: NSLayoutConstraint!
    
    let doubleTapGestureRecognizer :UITapGestureRecognizer = UITapGestureRecognizer()
    let singleTapGestureRecognizer :UITapGestureRecognizer = UITapGestureRecognizer()
    
    var imagePath: String = ""
    var videoPath: String = ""
    var mediaType: String = ""
    var isLocalMedia: Bool = false
 let playerViewController = AVPlayerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doubleTapGestureRecognizer.addTarget(self, action: #selector(self.didDoubleTap(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        scrollView.delegate = self
        // Do any additional setup after loading the view.
      //  scrollView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        
        
        navigationController?.isNavigationBarHidden = true
        
    }
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: scrollView)
        //let percentage = abs(translation.y) / UIScreen.main.bounds.height / 1.5
        //let velocity = gesture.velocity(in: scrollView)
        
        switch gesture.state {
        case .began:
             self.dismiss(animated: false, completion: nil)
            break
        case .possible:
            break
        case .changed:
            break
        case .ended:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            fatalError()
        }}
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func roteedinpoterate(notification: NSNotification) {
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
            if(mediaType == "video")
            {
                
                
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
                  }
                
                scrollView.isHidden = true
                //print(videoPath)
                
                /*let url = URL(string:videoPath)!
                //print(url.absoluteString)
                let player = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                
                playerController.player = player
                self.addChild(playerController)
                self.view.addSubview(playerController.view)
                playerController.view.frame = self.view.frame
                
                player.play()*/
                /*let playerViewController = AVPlayerViewController()
                 playerViewController.player = player
                 self.present(playerViewController, animated: true) {
                 playerViewController.player!.play()
                 }*/
                
                let videoURL = URL(string: videoPath)
                let player = AVPlayer(url: videoURL!)
               
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player!.play()
                }
                
            }
        else
            {
                //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                //self.navigationController?.popViewController(animated: true)
                
                
                //self.navigationController?.popViewController(animated: true)
                //self.dismiss(animated: true, completion: nil)
                
                
                
                /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     self.navigationController?.popViewController(animated: true)
                    //self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    }*/
        }
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        
        if(mediaType == "video")
        {
            
        }
        else
        {
            //self.navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                          
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                self.navigationController?.isNavigationBarHidden = false
                
                self.navigationController?.popViewController(animated: false)
                //self.dismiss(animated: true, completion: nil)
                
                
                /*if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                      print("landscape")
                  }*/
           
                
                
                
            }
            
           
            
            
        }
        
        mediaType = ""
    }
    
    
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePreview
    }
    
    // MARK: - Zoom
    
    @objc func didDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale < scrollView.maximumZoomScale {
            let center = sender.location(in: imagePreview)
            scrollView.zoom(to: zoomRect(center), animated: true)
        } else {
            let defaultScale: CGFloat = 1
            scrollView.setZoomScale(defaultScale, animated: true)
        }
    }
    
    func zoomRect(_ center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = scrollView.frame.size.height / scrollView.maximumZoomScale
        zoomRect.size.width = scrollView.frame.size.width / scrollView.maximumZoomScale
        
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }

    
     @IBAction func didCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MediaPreviewController.realDelegate = UIApplication.shared.delegate as? AppDelegate
            dg.leave();
        }
        dg.wait();
        return MediaPreviewController.realDelegate!;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    func convertbackImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: option, resultHandler: {(result, info)->Void in
            image = result!
            let inputImage = CIImage(cgImage: (image.cgImage)!)
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(inputImage, forKey: "inputImage")
            filter?.setValue(10, forKey: "inputRadius")
            let blurred = filter?.outputImage
            
            var newImageSize: CGRect = (blurred?.extent)!
            newImageSize.origin.x += (newImageSize.size.width - (self.imageBackground.image?.size.width)!) / 2
            newImageSize.origin.y += (newImageSize.size.height - (self.imageBackground.image?.size.height)!) / 2
            newImageSize.size = (self.imageBackground.image?.size)!
            
            let resultImage: CIImage = filter?.value(forKey: "outputImage") as! CIImage
            let context: CIContext = CIContext.init(options: nil)
            let cgimg: CGImage = context.createCGImage(resultImage, from: newImageSize)!
            let blurredImage: UIImage = UIImage.init(cgImage: cgimg)
           // self.imageBackground.image = blurredImage
            image = blurredImage
        })
        return image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

