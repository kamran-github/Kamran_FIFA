//
//  CropViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 22/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class CropViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var cropAreaView: CropAreaView!
    
    var cropArea:CGRect{
        get{
            let factor = imageView.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = imageView.imageFrame()
            let x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor
            let width = cropAreaView.frame.size.width * scale * factor
            let height = cropAreaView.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage{
     
     if (backgroundImage == nil) {
     return frontImage!
     }
     
     let size = backgroundImage?.size
     UIGraphicsBeginImageContextWithOptions(size!, true, 0.0)
     
     backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: (size?.width)!, height: (size?.height)!), blendMode: .lighten, alpha: 0.4)
     frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: (size?.width)!, height: (size?.height)!).insetBy(dx: (size?.width)! * 0.2, dy: (size?.height)! * 0.2))
     
     
     
     let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
     UIGraphicsEndImageContext()
     
     return newImage
     }*/
    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage{
        
        if (backgroundImage == nil) {
            return frontImage!
        }
        
        let size = frontImage?.size
        
        var size2 = frontImage?.size
        
        let width = frontImage?.size.width
        let height = frontImage?.size.height
        
        let ratio = width! / height!
        if width! > height! {
            let newHeight = width! * ratio
            size2 = CGSize(width: width!, height: newHeight)
        }
        else{
            //let newWidth = height! / ratio
            size2 = CGSize(width: width!, height: height!)
        }
        
        UIGraphicsBeginImageContextWithOptions(size2!, true, 0.0)
        
        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: (size2?.width)!, height: (size2?.height)!), blendMode: .luminosity, alpha: 0.3)
        
        let corY = (((size2?.height)! - (size?.height)!)/2)
        
        frontImage?.draw(in: CGRect.init(x: 0, y: corY, width: (size?.width)!, height: (size?.height)!).insetBy(dx: (size?.width)! * 0.1, dy: (size?.height)! * 0.1))
        
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        /*
         let size2 = imageView.frame.size
         UIGraphicsBeginImageContextWithOptions(size2, true, 0.0)
         
         
         UIGraphicsBeginImageContext(size2);
         let img: UIImage = newImage
         
         img.draw(in: CGRect.init(x: imageView.center.x-size2.width/2, y: imageView.center.y-size2.height/2, width: size2.width, height: size2.height))
         
         let img2: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
         
         UIGraphicsEndImageContext();
         */
        
        let img2: UIImage = setProfileImage(imageToResize: newImage, onImageView: imageView)
        
        return img2 //newImage.resized(withPercentage: 0.8)!
    }
    
    func setProfileImage(imageToResize: UIImage, onImageView: UIImageView) -> UIImage
    {
        /*let width = imageToResize.size.width - 10
        let height = imageToResize.size.height
        
        let rec: CGRect = CGRect(x: 10, y: 0, width: width , height: height )
        let croppedCGImage = imageToResize.cgImage?.cropping(to: rec)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        return croppedImage;*/
        let croppedCGImage = imageToResize.cgImage
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        return croppedImage;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*cropAreaView?.layer.masksToBounds = true;
         cropAreaView?.clipsToBounds=true;
         cropAreaView?.layer.borderWidth = 1.0
         cropAreaView?.layer.borderColor = UIColor.cyan.cgColor
         cropAreaView?.contentMode =  UIViewContentMode.scaleAspectFit*/
        cropAreaView?.layer.cornerRadius = 125.0
        //cropAreaView?.frame.origin.y =
        //cropAreaView?.frame.size.width = 180.0
        //cropAreaView?.frame.size.height = 180.0
        scrollView.zoomScale = 2
        
        //Make large and merge given image
        imageView.image = appDelegate().profileAvtarTemp! //UIImage(named:"img")
        
        let smallImage = imageView.image?.resized(withPercentage: 0.5) //0.3 //0.5....
        
        imageView.image = self.mergedImageWith(frontImage: smallImage, backgroundImage: imageView.image)
        
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    @IBAction func crop(_ sender: UIButton) {
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        let croppedImage200 = croppedImage.resized(toWidth: 320.0) //200
        imageView.image = croppedImage200
        appDelegate().profileAvtarTemp! = croppedImage200!
        scrollView.zoomScale = 1
        appDelegate().isAvtarChanged = true
        appDelegate().isvCardUpdated = true
        //dismiss(animated: true, completion: nil)
        //appDelegate().showProfile()
        
        
        if(appDelegate().isFromSettings)
        {
            appDelegate().showProfile()
        }
        else
        {
            appDelegate().showMyTeams()
            
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        appDelegate().isAvtarChanged = false
        //appDelegate().showProfile()
        
        appDelegate().showMyTeams()
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

class CropAreaView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
