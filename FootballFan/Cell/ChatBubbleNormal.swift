//
//  ChatBubbleNormal.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 16/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class ChatBubbleNormal: UIView {
    let strokeColor: UIColor = UIColor.gray
    let fillColor: UIColor = UIColor.yellow
    var triangleHeight: CGFloat!
    var radius: CGFloat!
    var borderWidth: CGFloat!
    var edgeCurve: CGFloat!
    var forward: UIButton! //= UIButton()
    var loader: UIActivityIndicatorView! //= UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        //sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(baseView: UIView, text: String, fontSize: CGFloat = 16, messageType: String = "text", messageTime: String, imageLogo: UIImage = UIImage(named: "splash_bg")!, videoLogo: UIImage = UIImage(named: "splash_bg")!, caption: String = "", thumbLink: String = "", chatStatus: String = "") {
        //var bubbleRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        //If TYPE = "text"
        let screenSize = UIScreen.main.bounds
        //let screenWidth = screenSize.width
        let bubbleWidth = screenSize.width * 0.75
        
        //let mili: Double = Double(messageTime)!
        //let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
        
        //let msgTime = String(myMilliseconds.toHour) as String
        
        if(messageType == "image")
        {
            // Calculate relative sizes
            let padding = fontSize * 0.7
            let imageViewObject = UIImageView(frame:CGRect(x: 20.0, y: 10.0,width: bubbleWidth,height: bubbleWidth));
            
            //Label for caption
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bubbleWidth, height: CGFloat.greatestFiniteMagnitude))//changed
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.text = caption
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            //End
            
            let width = imageViewObject.frame.width + padding * 3 //labelSize.width + padding //* 3 // 50% more padding on width
            let height = imageViewObject.frame.height + label.frame.height + padding * 2 //labelSize.height + triangleHeight + padding * 2
            let bubbleRect = CGRect(x: 0, y: 0, width: screenSize.width, height: height + 10.0)
            self.init(frame: bubbleRect)
            //baseView.frame = bubbleRect
            
            loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: imageViewObject)
            loader.backgroundColor = UIColor.white
            loader.frame = CGRect(origin: CGPoint(x: loader.frame.origin.x - 10 , y: loader.frame.origin.y - 10), size: CGSize(width: 45.0, height: 45.0))
            loader.layer.masksToBounds = true
            loader.clipsToBounds=true
            loader.layer.cornerRadius = 22.5
            
            imageViewObject.addSubview(loader)
            
            if(!thumbLink.isEmpty)
            {
                if(!loader.isAnimating)
                {
                    loader.startAnimating()
                }
                
                if(chatStatus == "failed")
                {
                    if(loader.isAnimating)
                    {
                        loader.stopAnimating()
                    }
                }
                //self.loadImageFromUrl(url: thumbLink, view: imageViewObject)
                
                // Create Url from string
                let url = NSURL(string: thumbLink)!
                
                // Download task:
                // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
                let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                    // if responseData is not null...
                    if let data = responseData{
                        
                        // execute in UI thread
                        DispatchQueue.main.async(execute: { () -> Void in
                            let thumbImg = UIImage(data: data)
                            imageViewObject.image = thumbImg?.square()//UIImage(data: data)
                        })
                    }
                    else
                    {
                        if(self.loader.isAnimating)
                        {
                            self.loader.stopAnimating()
                        }
                    }
                }
                
                // Run task
                task.resume()
                
            }
            else
            {
                imageViewObject.image = imageLogo//UIImage(named: imageLogo)
                if(loader.isAnimating)
                {
                    loader.stopAnimating()
                }
            }
            
            let foo = UIImage(named: "bubble_normal") // 328 x 328
            let fooWithInsets = foo?.resizableImageWithStretchingProperties(
                X: 0.48, width: 0, Y: 0.45, height: 0) ?? foo
            
            let imageView = UIImageView(image: fooWithInsets)
            
            label.frame.origin = CGPoint(x:20.0, y:imageViewObject.frame.height + 10.0)
            imageView.addSubview(label)
            
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.addSubview(imageView)
            
            //Time
            var timeY: Float = 0.0
            if(caption.isEmpty)
            {
                timeY = Float(imageViewObject.frame.size.height)// + 10.0)
            }
            else
            {
                timeY = Float((imageViewObject.frame.size.height + label.frame.size.height))// + 10.0)
            }
            
            
            let lbltime = UILabel(frame: CGRect(x: 0.0, y: Double(timeY), width: 80.0, height: 15.0))//changed
            lbltime.font = UIFont.systemFont(ofSize: 12.0)
            lbltime.text = messageTime//"2:11 PM"
            lbltime.textAlignment = .right
            let timewidth = (imageViewObject.frame.origin.x + imageViewObject.frame.size.width) - lbltime.intrinsicContentSize.width
            if(caption.isEmpty)
            {
                lbltime.textColor = UIColor.black
                lbltime.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                lbltime.shadowColor = UIColor.lightGray
                lbltime.frame.origin = CGPoint(x:timewidth, y:lbltime.frame.origin.y - 5.0)
            }
            else
            {
                lbltime.textColor = UIColor.gray
                lbltime.shadowColor = UIColor.lightGray
                lbltime.frame.origin = CGPoint(x:timewidth, y:lbltime.frame.origin.y)
            }
            lbltime.sizeToFit()
            
            
            self.addSubview(lbltime)
            
            //Forward button
            forward = UIButton(frame: CGRect(x: width, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            forward.setImage(UIImage(named: "forward_in"), for: UIControl.State.normal)
            forward.isUserInteractionEnabled = true
            forward.backgroundColor = UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
            forward.isHidden = true
            forward.layer.masksToBounds = true
            forward.clipsToBounds=true
            forward.layer.cornerRadius = 20.0
            self.addSubview(forward)
            //End
            
            imageView.addSubview(imageViewObject)
            
        }
        else if(messageType == "video")
        {
            // Calculate relative sizes
            let padding = fontSize * 0.7
            let imageViewObject = UIImageView(frame:CGRect(x: 20.0, y: 10.0,width: bubbleWidth,height: bubbleWidth));
            
            
            //Label for caption
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bubbleWidth, height: CGFloat.greatestFiniteMagnitude))//changed
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.text = caption
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            
            //End
            
            let width = imageViewObject.frame.width + padding * 3 //labelSize.width + padding //* 3 // 50% more padding on width
            let height = imageViewObject.frame.height + label.frame.height + padding * 2 //labelSize.height + triangleHeight + padding * 2
            let bubbleRect = CGRect(x: 0, y: 0, width: screenSize.width, height: height + 10.0)
            self.init(frame: bubbleRect)
            //baseView.frame = bubbleRect
            
            loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: imageViewObject)
            loader.backgroundColor = UIColor.white
            loader.frame = CGRect(origin: CGPoint(x: loader.frame.origin.x - 10 , y: loader.frame.origin.y - 10), size: CGSize(width: 45.0, height: 45.0))
            loader.layer.masksToBounds = true
            loader.clipsToBounds=true
            loader.layer.cornerRadius = 22.5
            
            imageViewObject.addSubview(loader)
            
            if(!thumbLink.isEmpty)
            {
                if(!loader.isAnimating)
                {
                    loader.startAnimating()
                }
                
                if(chatStatus == "failed")
                {
                    if(loader.isAnimating)
                    {
                        loader.stopAnimating()
                    }
                }
                //self.loadImageFromUrl(url: thumbLink, view: imageViewObject)
                
                // Create Url from string
                let url = NSURL(string: thumbLink)!
                
                // Download task:
                // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
                let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
                    // if responseData is not null...
                    if let data = responseData{
                        
                        // execute in UI thread
                        DispatchQueue.main.async(execute: { () -> Void in
                            let thumbImg = UIImage(data: data)
                            imageViewObject.image = thumbImg?.square()//UIImage(data: data)
                        })
                    }
                    else
                    {
                        if(self.loader.isAnimating)
                        {
                            self.loader.stopAnimating()
                        }
                    }
                }
                
                // Run task
                task.resume()
                
            }
            else
            {
                imageViewObject.image = videoLogo//UIImage(named: videoLogo)
                if(loader.isAnimating)
                {
                    loader.stopAnimating()
                }
            }
            
            let foo = UIImage(named: "bubble_normal") // 328 x 328
            let fooWithInsets = foo?.resizableImageWithStretchingProperties(
                X: 0.48, width: 0, Y: 0.45, height: 0) ?? foo
            
            let imageView = UIImageView(image: fooWithInsets)
            
            label.frame.origin = CGPoint(x:10.0, y:imageViewObject.frame.height + 10.0)
            imageView.addSubview(label)
            
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.addSubview(imageView)
            
            //Time
            var timeY: Float = 0.0
            if(caption.isEmpty)
            {
                timeY = Float(imageViewObject.frame.size.height)// + 10.0)
            }
            else
            {
                timeY = Float((imageViewObject.frame.size.height + label.frame.size.height))// + 10.0)
            }
            
            
            let lbltime = UILabel(frame: CGRect(x: 0.0, y: Double(timeY), width: 80.0, height: 15.0))//changed
            lbltime.font = UIFont.systemFont(ofSize: 12.0)
            lbltime.text = messageTime//"2:11 PM"
            lbltime.textAlignment = .right
            let timewidth = (imageViewObject.frame.origin.x + imageViewObject.frame.size.width) - lbltime.intrinsicContentSize.width
            if(caption.isEmpty)
            {
                lbltime.textColor = UIColor.black
                lbltime.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                lbltime.shadowColor = UIColor.lightGray
                lbltime.frame.origin = CGPoint(x:timewidth, y:lbltime.frame.origin.y - 5.0)
            }
            else
            {
                lbltime.textColor = UIColor.gray
                lbltime.shadowColor = UIColor.lightGray
                lbltime.frame.origin = CGPoint(x:timewidth, y:lbltime.frame.origin.y)
            }
            lbltime.sizeToFit()
            
            
            self.addSubview(lbltime)
            
            //Forward button
            forward = UIButton(frame: CGRect(x: width, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            forward.setImage(UIImage(named: "forward_in"), for: UIControl.State.normal)
            forward.isUserInteractionEnabled = true
            forward.backgroundColor =  UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
            forward.isHidden = true
            forward.layer.masksToBounds = true
            forward.clipsToBounds=true
            forward.layer.cornerRadius = 20.0
            self.addSubview(forward)
            //End
            
            //Play image
            let playImage = UIImageView(frame: CGRect(x: (width/2) - 20, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            playImage.image = UIImage(named: "ff_play")
            playImage.backgroundColor =  UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
            playImage.layer.masksToBounds = true
            playImage.clipsToBounds=true
            playImage.layer.cornerRadius = 20.0
            self.addSubview(playImage)
            //End
            
            imageView.addSubview(imageViewObject)
            
        }
        else
        {
            
            // Calculate relative sizes
            let padding = fontSize * 0.7
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bubbleWidth, height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.text = text
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            
            //Time
            let lbltime = UILabel(frame: CGRect(x: 0.0, y: label.frame.size.height + 10.0, width: 80.0, height: 15.0))//changed
            lbltime.font = UIFont.systemFont(ofSize: 12.0)
            lbltime.text = messageTime//"2:11 PM"
            lbltime.textColor = UIColor.gray
            lbltime.textAlignment = .right
            lbltime.sizeToFit()
            
            //let labelSize = label.intrinsicContentSize
            var width = (label.frame.width + padding * 2) + 20.0//3 //labelSize.width + padding //* 3 // 50% more padding on width
            if(width < 120.0)
            {
                width = 120.0
            }
            let height = label.frame.height + (lbltime.frame.height+5.0) + padding //* 2 //labelSize.height + triangleHeight + padding * 2
            let bubbleRect = CGRect(x: 0, y: 0, width: width, height: height + 10.0)
            self.init(frame: bubbleRect)
            //baseView.frame = bubbleRect
            
            let foo = UIImage(named: "bubble_normal") // 328 x 328
            let fooWithInsets = foo?.resizableImageWithStretchingProperties(
                X: 0.48, width: 0, Y: 0.45, height: 0) ?? foo
            
            let imageView = UIImageView(image: fooWithInsets)
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.addSubview(imageView)
            
            label.frame.origin = CGPoint(x:15.0, y:5.0)
            imageView.addSubview(label)
            
            lbltime.frame.origin = CGPoint(x:bubbleRect.size.width-70.0, y:lbltime.frame.origin.y)
            imageView.addSubview(lbltime)
        }
    }
    
    
    /*// Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     
     }*/
    
}
