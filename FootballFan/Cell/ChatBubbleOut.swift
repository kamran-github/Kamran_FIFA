//
//  ChatBubbleOut.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 25/07/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import MessageUI
class ResponsiveViewOut: UIView {
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
class ChatBubbleOut: UIView {
    let strokeColor: UIColor = UIColor.gray
    let fillColor: UIColor = UIColor.yellow
    var triangleHeight: CGFloat!
    var radius: CGFloat!
    var borderWidth: CGFloat!
    var edgeCurve: CGFloat!
    var forward: UIButton! //UIButton()
    var loader: UIActivityIndicatorView!  //= UIActivityIndicatorView()
    var responsiveView: ResponsiveViewOut!
    var progressPer: Double = 0.0
    var progressTextLabel: UILabel!
    var progressMessage: UILabel!
    var progressSlider: CustomSlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        //sizeToFit()
        let notificationName = Notification.Name("videoprogress")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(copyProgress(notification:)), name: notificationName, object: nil)
       
    }
    
    @objc func copyProgress(notification: NSNotification)
    {
        let inmycontacts = (notification.userInfo?["subcriptiontype"] )as! Double
        let texttag = (notification.userInfo?["texttag"] )as! String
        //print("\(inmycontacts)")
        progressPer = inmycontacts
        let a = progressPer * 100.00
        if(progressTextLabel != nil)
        {
            //print("\(progressTextLabel.accessibilityValue)")
            if(progressTextLabel.accessibilityValue == texttag)
            {
                progressTextLabel.text = "\(Int(a))%"
                self.progressSlider.value = Float(progressPer)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(baseView: UIView, text: String, fontSize: CGFloat = 16, messageType: String = "text", messageTime: String, imageLogo: UIImage = UIImage(named: "splash_bg")!, videoLogo: UIImage = UIImage(named: "splash_bg")!, caption: String = "", thumbLink: String = "", chatStatus: String = "", mySupportTeam: Int = 0,  chatType: String = "", mytagcell: Int = 0, isTableMutable: Bool = false, isSeletForward: Bool = false, messageSubType: String = "", messageId: String) {
        //var bubbleRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let screenSize = UIScreen.main.bounds
        var screenWidth = screenSize.width
        let bubbleWidth = screenSize.width * 0.65 //0.75
        if(isTableMutable){
            screenWidth = screenWidth - 35.0
        }
        //let mili: Double = Double(messageTime)!
        //let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
        
        //let msgTime = String(myMilliseconds.toHour) as String
        var controlsY: CGFloat = 0.0
        
        var chatPlaneMsgHeight: CGFloat = 10.0
        
        if(chatType == "group" ||  chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
        {
            controlsY = 20.0
            chatPlaneMsgHeight = 30.0
        }
        //controlsY = 20.0
        if(messageSubType == "Forwarded"){
            controlsY = controlsY + 20
            
            if(chatType == "group" ||  chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
            {
               // controlsY = 20.0
                chatPlaneMsgHeight = 50.0
            }
            else{
                chatPlaneMsgHeight = 30.0
            }
        }
        
        //If TYPE = "text"
        if(messageType == "image")
        {
            // Calculate relative sizes
            let padding = fontSize * 0.7
            let imageViewObject = UIImageView(frame:CGRect(x: 15.0, y: (10.0 + controlsY),width: bubbleWidth,height: bubbleWidth));//changed
            imageViewObject.image = imageLogo//UIImage(named: imageLogo)
            
            
            
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
            let height = imageViewObject.frame.height + label.frame.height + controlsY + padding * 2 //labelSize.height + triangleHeight + padding * 2
            let bubbleRect = CGRect(x: 0, y: 0, width: width, height: height + 10.0)
            self.init(frame: bubbleRect)
            //baseView.frame = bubbleRect
            
            
            /*loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: imageViewObject)
            loader.backgroundColor = UIColor.white
            loader.frame = CGRect(origin: CGPoint(x: loader.frame.origin.x - 10 , y: loader.frame.origin.y - 10), size: CGSize(width: 45.0, height: 45.0))
            loader.layer.masksToBounds = true
            loader.clipsToBounds=true
            loader.layer.cornerRadius = 22.5
            
            imageViewObject.addSubview(loader)*/
            /*if(thumbLink.isEmpty)
            {
                if(!loader.isAnimating)
                {
                    loader.startAnimating()
                }
            }
            else
            {
                if(loader.isAnimating)
                {
                    loader.stopAnimating()
                }
            }
            
            if(chatStatus == "failed")
            {
                if(loader.isAnimating)
                {
                    loader.stopAnimating()
                }
            }*/
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: imageViewObject.frame.width, height: imageViewObject.frame.height))
            //overlay.backgroundColor = UIColor.red
            imageViewObject.addSubview(overlay)
            
            let foo = UIImage(named: "bubble_out") // 328 x 328 //changed
            let fooWithInsets = foo?.resizableImageWithStretchingProperties(
                X: 0.48, width: 0, Y: 0.45, height: 0) ?? foo
            
            let imageView = UIImageView(image: fooWithInsets)
            
            label.frame.origin = CGPoint(x:15.0, y:imageViewObject.frame.height + 15.0 + controlsY)
            imageView.addSubview(label)
            
            imageView.frame = CGRect(x: screenWidth - width - 10.0, y: 0, width: width, height: height)//changed
            self.addSubview(imageView)
            
            
            
            //New code only for Banter
            //if(chatType == "banter")
            //{
            if(chatType == "group" ||  chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
            {
                if( chatType == "banter" || chatType == "teambr")
                {
                let teamImageName = "Team" + mySupportTeam.description
                let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                if((teamImage) != nil)
                {
                    let teamImg = appDelegate().loadProfileImage(filePath: teamImage!)
                    
                    
                    let imageViewTeam = UIImageView(image: teamImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 20.0, height: 20.0)
                    imageView.addSubview(imageViewTeam)
                    
                }
                else
                {
                    let teamImg = UIImage(named: "team")
                    let imageViewTeam = UIImageView(image: teamImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 20.0, height: 20.0)
                    imageView.addSubview(imageViewTeam)
                }
                    let lblName = UILabel(frame: CGRect(x: 40.0, y: 5.0, width: bubbleWidth, height: 20.0))//changed
                    lblName.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblName.text = "You"
                    lblName.textAlignment = .left
                    //label.textColor = self.strokeColor
                    lblName.numberOfLines = 1
                    lblName.sizeToFit()
                    imageView.addSubview(lblName)
                }
                else{
                    let lblName = UILabel(frame: CGRect(x: 15.0, y: 5.0, width: bubbleWidth, height: 20.0))//changed
                    lblName.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblName.text = "You"
                    lblName.textAlignment = .left
                    //label.textColor = self.strokeColor
                    lblName.numberOfLines = 1
                    lblName.sizeToFit()
                    imageView.addSubview(lblName)
                }
            //}
            
            
            //End
            //Name of user
          
            //End
            }
            
            
            //Time
            var timeY: Float = 0.0
            if(caption.isEmpty)
            {
                timeY = Float(imageViewObject.frame.size.height + controlsY)// + 10.0)
            }
            else
            {
                timeY = Float((imageViewObject.frame.size.height + label.frame.size.height + controlsY))// + 10.0)
            }
            
            
            let lbltime = UILabel(frame: CGRect(x: 0.0, y: Double(timeY), width: 90.0, height: 15.0))//changed
            lbltime.font = UIFont.systemFont(ofSize: 12.0)
            lbltime.text = messageTime//"2:11 PM"
            lbltime.textAlignment = .right
            lbltime.roundCorners(corners: [.topLeft], radius: 5)
            //let timewidth = ((imageViewObject.frame.origin.x + imageViewObject.frame.size.width) - lbltime.intrinsicContentSize.width) + screenWidth - width - 25.0 // It was - 10
            let timewidth = ((imageViewObject.frame.origin.x + imageViewObject.frame.size.width) - lbltime.intrinsicContentSize.width) + screenWidth - width - 10.0 // It was - 10
            if(caption.isEmpty)
            {
                lbltime.textColor = UIColor.black
                lbltime.backgroundColor = UIColor.white.withAlphaComponent(0.7)
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
            
            //lbltime.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            self.addSubview(lbltime)
            
            /* Hide for banter now
            let imageTick = UIImageView(frame:CGRect(x: timewidth + lbltime.intrinsicContentSize.width, y: lbltime.frame.origin.y,width: 15.0,height: 15.0));//changed
            imageTick.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            imageTick.contentMode = .scaleAspectFit
            if(chatStatus == "failed" || chatStatus == "sending")
            {
                imageTick.image = UIImage(named: "failtick")
            }
            else if(chatStatus == "sent")
            {
                imageTick.image = UIImage(named: "senttick")
            }
            else if(chatStatus == "delivered")
            {
                imageTick.image = UIImage(named: "deltick")
            }
            else if(chatStatus == "received")
            {
                imageTick.image = UIImage(named: "rectick")
            }
            self.addSubview(imageTick)
            */
            //Forward button
            if(messageSubType == "Forwarded"){
                if(chatType == "group" || chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
                {
                    let forwardImg = UIImage(named: "forward_in")
                    let imageViewTeam = UIImageView(image: forwardImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 25.0, width: 15.0, height: 15.0)
                    imageView.addSubview(imageViewTeam)
                    let lblforward = UILabel(frame: CGRect(x: 35.0, y: 25.0, width: bubbleWidth, height: 10.0))//changed
                    lblforward.font = UIFont.systemFont(ofSize: 13)
                    //lblforward.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblforward.text = "Forwarded"
                    lblforward.textAlignment = .left
                    lblforward.textColor = UIColor.init(hex: "939393")
                    lblforward.numberOfLines = 1
                    lblforward.sizeToFit()
                    imageView.addSubview(lblforward)
                }
                else{
                    let forwardImg = UIImage(named: "forward_in")
                    let imageViewTeam = UIImageView(image: forwardImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 15.0, height: 15.0)
                    imageView.addSubview(imageViewTeam)
                    let lblforward = UILabel(frame: CGRect(x: 35.0, y: 5.0, width: bubbleWidth, height: 10.0))//changed
                    lblforward.font = UIFont.systemFont(ofSize: 13)
                    //lblforward.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblforward.text = "Forwarded"
                    lblforward.textAlignment = .left
                    lblforward.textColor = UIColor.init(hex: "939393")
                    lblforward.numberOfLines = 1
                    lblforward.sizeToFit()
                    imageView.addSubview(lblforward)
                }
                
            }
            //End
            
           if(!isTableMutable && !isSeletForward){
                responsiveView = ResponsiveViewOut()
                
                // Add our responsive view to a super view
                responsiveView.frame = CGRect(x: screenWidth - width - 10.0, y: 0.0,width: width,height: height) //CGRect(x: 0, y: 0, width: 300, height: 100)
                //responsiveView.center = self.center
                responsiveView.backgroundColor = UIColor.clear //UIColor(red: 124.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                //responsiveView.layer.cornerRadius = 4;
                //responsiveView.layer.masksToBounds = true
                responsiveView.tag = mytagcell
                 responsiveView.accessibilityValue = chatStatus
                self.addSubview(responsiveView)
                
                // Add a long press gesture recognizer to our responsive view
                responsiveView.isUserInteractionEnabled = true
                let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandlerout))
                longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
                responsiveView.addGestureRecognizer(longPressGR)
                
            }
            if(messageSubType == "Forwarded"){
               forward = UIButton(frame: CGRect(x: (width/2) + 60, y: 20.0 + imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            }
            else{
              forward = UIButton(frame: CGRect(x: (width/2) + 60, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            }
            
            forward.setImage(UIImage(named: "forward_out"), for: UIControl.State.normal)
            forward.isUserInteractionEnabled = true
            forward.backgroundColor =  UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
            forward.isHidden = true
            forward.layer.masksToBounds = true
            forward.clipsToBounds=true
            forward.layer.cornerRadius = 20.0
             forward.alpha = CGFloat(0.9)
            self.addSubview(forward)
            if(chatStatus == "sending")
            {
                let viewForActivityIndicator = UIView()
                
                viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: imageViewObject.frame.size.width, height: imageViewObject.frame.size.height)
                viewForActivityIndicator.alpha = 0.7
                viewForActivityIndicator.backgroundColor = UIColor.darkGray
                imageViewObject.addSubview(viewForActivityIndicator)
                
                
             //   let activityIndicatorView = UIActivityIndicatorView()
            //    activityIndicatorView.center = CGPoint(x:imageViewObject.frame.size.width/2 , y: imageViewObject.frame.size.width/2)
                let loadingTextLabel = UILabel()
                
                loadingTextLabel.textColor = UIColor.white
                loadingTextLabel.text = "Uploading Image..."
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                loadingTextLabel.sizeToFit()
                loadingTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 75)
                viewForActivityIndicator.addSubview(loadingTextLabel)
                
                lbltime.isHidden = true
                progressSlider = CustomSlider(frame: CGRect(x: 5.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width-10, height: 70))//changed
                progressSlider.tag = mytagcell
                //progressSlider.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 113)
                progressSlider.setThumbImage(UIImage(named: "uncheck"), for: .normal)
                // progressSlider.layer.cornerRadius = 0
                progressSlider.isSelected = false
                progressSlider.isUserInteractionEnabled = false
                progressSlider.minimumTrackTintColor = UIColor.init(hex: "FFD401")
                progressSlider.trackWidth = 20
                progressSlider.bounds = progressSlider.trackRect(forBounds: progressSlider.bounds)
                viewForActivityIndicator.addSubview(progressSlider)
                
                progressTextLabel = UILabel(frame: CGRect(x: 0.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width, height: 70))
                //changed
                progressTextLabel.font = UIFont.systemFont(ofSize: fontSize)
                //progressTextLabel.text = ""
                progressTextLabel.accessibilityValue = messageId
                progressTextLabel.textColor = UIColor.white
                //progressTextLabel.backgroundColor = UIColor.red
                progressTextLabel.textAlignment = .center
                //label.textColor = self.strokeColor
                progressTextLabel.lineBreakMode = .byWordWrapping
                progressTextLabel.numberOfLines = 0
                //progressTextLabel.sizeToFit()
                //self.addSubview(progressTextLabel)
                // loadingTextLabel.text = "Downloading video...\(Int(a))"
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                //loadingTextLabel.sizeToFit()
                // progressTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: imageViewObject.frame.size.height-45)
                viewForActivityIndicator.addSubview(progressTextLabel)
                
                
                
               // activityIndicatorView.hidesWhenStopped = true
              //  activityIndicatorView.activityIndicatorViewStyle = .white
              //  viewForActivityIndicator.addSubview(activityIndicatorView)
                
                //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
            //    activityIndicatorView.startAnimating()
                //LoadingIndicatorView.show(overlay, loadingText: "Uploading Image...")
                
            }
            else if(chatStatus == "downloading")
            {
                let viewForActivityIndicator = UIView()
                
                viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: imageViewObject.frame.size.width, height: imageViewObject.frame.size.height)
                viewForActivityIndicator.alpha = 0.7
                viewForActivityIndicator.backgroundColor = UIColor.darkGray
                imageViewObject.addSubview(viewForActivityIndicator)
                
                
               // let activityIndicatorView = UIActivityIndicatorView()
              //  activityIndicatorView.center = CGPoint(x:imageViewObject.frame.size.width/2 , y: imageViewObject.frame.size.width/2)
                let loadingTextLabel = UILabel()
                
                loadingTextLabel.textColor = UIColor.white
                loadingTextLabel.text = "Downloading Image..."
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                loadingTextLabel.sizeToFit()
                loadingTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 75)
                viewForActivityIndicator.addSubview(loadingTextLabel)
                lbltime.isHidden = true
                
                progressSlider = CustomSlider(frame: CGRect(x: 5.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width-10, height: 70))//changed
                progressSlider.tag = mytagcell
                //progressSlider.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 113)
                progressSlider.setThumbImage(UIImage(named: "uncheck"), for: .normal)
                // progressSlider.layer.cornerRadius = 0
                progressSlider.isSelected = false
                progressSlider.isUserInteractionEnabled = false
                progressSlider.minimumTrackTintColor = UIColor.init(hex: "FFD401")
                progressSlider.trackWidth = 20
                progressSlider.bounds = progressSlider.trackRect(forBounds: progressSlider.bounds)
                viewForActivityIndicator.addSubview(progressSlider)
                
                progressTextLabel = UILabel(frame: CGRect(x: 0.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width, height: 70))
                //changed
                progressTextLabel.font = UIFont.systemFont(ofSize: fontSize)
                //progressTextLabel.text = ""
                progressTextLabel.accessibilityValue = messageId
                progressTextLabel.textColor = UIColor.white
                //progressTextLabel.backgroundColor = UIColor.red
                progressTextLabel.textAlignment = .center
                //label.textColor = self.strokeColor
                progressTextLabel.lineBreakMode = .byWordWrapping
                progressTextLabel.numberOfLines = 0
                //progressTextLabel.sizeToFit()
                //self.addSubview(progressTextLabel)
                // loadingTextLabel.text = "Downloading video...\(Int(a))"
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                //loadingTextLabel.sizeToFit()
                // progressTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: imageViewObject.frame.size.height-45)
                viewForActivityIndicator.addSubview(progressTextLabel)
                
                
                
                
               // activityIndicatorView.hidesWhenStopped = true
               // activityIndicatorView.activityIndicatorViewStyle = .white
               // viewForActivityIndicator.addSubview(activityIndicatorView)
                
                //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
              //  activityIndicatorView.startAnimating()
                //LoadingIndicatorView.show(overlay, loadingText: "Uploading Image...")
                
            }
            if(!thumbLink.isEmpty)
            {
                // LoadingIndicatorView.show(overlay, loadingText: "Downloading Image...")
                
                if(chatStatus == "failed")
                {
                    LoadingIndicatorView.hide()
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
                            let arrReadselVideoPath = thumbLink.components(separatedBy: "/")
                            let imageId = arrReadselVideoPath.last
                            let arrReadimageId = imageId?.components(separatedBy: ".")
                            
                            _ = self.appDelegate().saveImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: arrReadimageId![0] as String)
                            imageViewObject.image = thumbImg?.square()//UIImage(data: data)
                        })
                    }
                }
                
                // Run task
                task.resume()
                
            }
            if(chatStatus == "failed" && chatStatus == "sent" && chatStatus == "download" )
            {
                LoadingIndicatorView.hide()
            }
            imageView.addSubview(imageViewObject)
            
        }
        else if(messageType == "video")
        {
            // Calculate relative sizes
            let padding = fontSize * 0.7
            let imageViewObject = UIImageView(frame:CGRect(x: 15.0, y: (10.0 + controlsY),width: bubbleWidth,height: bubbleWidth));//changed
            imageViewObject.image = videoLogo
            
            
            
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
            let height = imageViewObject.frame.height + label.frame.height + controlsY + padding * 2 //labelSize.height + triangleHeight + padding * 2
            let bubbleRect = CGRect(x: 0, y: 0, width: width, height: height + 10.0)
            self.init(frame: bubbleRect)
            //baseView.frame = bubbleRect
            
            
            /*loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: imageViewObject)
            loader.backgroundColor = UIColor.white
            loader.frame = CGRect(origin: CGPoint(x: loader.frame.origin.x - 10 , y: loader.frame.origin.y - 10), size: CGSize(width: 45.0, height: 45.0))
            loader.layer.masksToBounds = true
            loader.clipsToBounds=true
            loader.layer.cornerRadius = 22.5
            
            imageViewObject.addSubview(loader)*/
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: imageViewObject.frame.width, height: imageViewObject.frame.height))
            
            imageViewObject.addSubview(overlay)
            
            
            let foo = UIImage(named: "bubble_out") // 328 x 328 //changed
            let fooWithInsets = foo?.resizableImageWithStretchingProperties(
                X: 0.48, width: 0, Y: 0.45, height: 0) ?? foo
            
            let imageView = UIImageView(image: fooWithInsets)
            
            label.frame.origin = CGPoint(x:15.0, y:imageViewObject.frame.height + 15.0 + controlsY)
            imageView.addSubview(label)
            
            imageView.frame = CGRect(x: screenWidth - width - 10.0, y: 0, width: width, height: height)//changed
            self.addSubview(imageView)
            
            
            //New code only for Banter
            //if(chatType == "banter")
            //{
            if( chatType == "group" || chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
            {
                if( chatType == "banter" || chatType == "teambr")
                {
                    let teamImageName = "Team" + mySupportTeam.description
                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                    if((teamImage) != nil)
                    {
                        let teamImg = appDelegate().loadProfileImage(filePath: teamImage!)
                        
                        
                        let imageViewTeam = UIImageView(image: teamImg)
                        imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 20.0, height: 20.0)
                        imageView.addSubview(imageViewTeam)
                        
                    }
                    else
                    {
                        let teamImg = UIImage(named: "team")
                        let imageViewTeam = UIImageView(image: teamImg)
                        imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 20.0, height: 20.0)
                        imageView.addSubview(imageViewTeam)
                    }
                    let lblName = UILabel(frame: CGRect(x: 40.0, y: 5.0, width: bubbleWidth, height: 20.0))//changed
                    lblName.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblName.text = "You"
                    lblName.textAlignment = .left
                    //label.textColor = self.strokeColor
                    lblName.numberOfLines = 1
                    lblName.sizeToFit()
                    imageView.addSubview(lblName)
                }
                else{
                    let lblName = UILabel(frame: CGRect(x: 15.0, y: 5.0, width: bubbleWidth, height: 20.0))//changed
                    lblName.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblName.text = "You"
                    lblName.textAlignment = .left
                    //label.textColor = self.strokeColor
                    lblName.numberOfLines = 1
                    lblName.sizeToFit()
                    imageView.addSubview(lblName)
                }
            
            //}
            
            //End
            //Name of user
           
            //End
            }
            
            //Time
            var timeY: Float = 0.0
            if(caption.isEmpty)
            {
                timeY = Float(imageViewObject.frame.size.height + controlsY)// + 10.0)
            }
            else
            {
                timeY = Float((imageViewObject.frame.size.height + label.frame.size.height + controlsY))// + 10.0)
            }
            
            
            let lbltime = UILabel(frame: CGRect(x: 0.0, y: Double(timeY), width: 90.0, height: 15.0))//changed
            lbltime.font = UIFont.systemFont(ofSize: 12.0)
            lbltime.text = messageTime//"2:11 PM"
            lbltime.textAlignment = .right
            
            
            
            /*lbltime.layer.masksToBounds = true;
            lbltime.clipsToBounds=true;
            lbltime.layer.cornerRadius = 5.0
            lbltime.layer.m*/
            lbltime.roundCorners(corners: [.topLeft], radius: 5)
            
            //let timewidth = ((imageViewObject.frame.origin.x + imageViewObject.frame.size.width) - lbltime.intrinsicContentSize.width) + screenWidth - width - 25.0 // It was -10.0
            let timewidth = ((imageViewObject.frame.origin.x + imageViewObject.frame.size.width) - lbltime.intrinsicContentSize.width) + screenWidth - width - 10.0 // It was -10.0
            if(caption.isEmpty)
            {
                lbltime.textColor = UIColor.black
                lbltime.backgroundColor = UIColor.white.withAlphaComponent(0.7)
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
            
            //Hide for banter for now
            /*let imageTick = UIImageView(frame:CGRect(x: timewidth + lbltime.intrinsicContentSize.width, y: lbltime.frame.origin.y,width: 15.0,height: 15.0));//changed
            imageTick.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            imageTick.contentMode = .scaleAspectFit
            if(chatStatus == "failed" || chatStatus == "sending")
            {
                imageTick.image = UIImage(named: "failtick")
            }
            else if(chatStatus == "sent")
            {
                imageTick.image = UIImage(named: "senttick")
            }
            else if(chatStatus == "delivered")
            {
                imageTick.image = UIImage(named: "deltick")
            }
            else if(chatStatus == "received")
            {
                imageTick.image = UIImage(named: "rectick")
            }
            self.addSubview(imageTick)*/
            
            //Forward button
            if(messageSubType == "Forwarded"){
                if(chatType == "group" || chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
                {
                    let forwardImg = UIImage(named: "forward_in")
                    let imageViewTeam = UIImageView(image: forwardImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 25.0, width: 15.0, height: 15.0)
                    imageView.addSubview(imageViewTeam)
                    let lblforward = UILabel(frame: CGRect(x: 35.0, y: 25.0, width: bubbleWidth, height: 10.0))//changed
                    //lblforward.font = UIFont.boldSystemFont(ofSize: fontSize)
                      lblforward.font = UIFont.systemFont(ofSize: 13)
                    lblforward.text = "Forwarded"
                    lblforward.textAlignment = .left
                    lblforward.textColor = UIColor.init(hex: "939393")
                    lblforward.numberOfLines = 1
                    lblforward.sizeToFit()
                    imageView.addSubview(lblforward)
                }
                else{
                    let forwardImg = UIImage(named: "forward_in")
                    let imageViewTeam = UIImageView(image: forwardImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 15.0, height: 15.0)
                    imageView.addSubview(imageViewTeam)
                    let lblforward = UILabel(frame: CGRect(x: 35.0, y: 5.0, width: bubbleWidth, height: 10.0))//changed
                    lblforward.font = UIFont.systemFont(ofSize: 13)
                    //lblforward.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblforward.text = "Forwarded"
                    lblforward.textAlignment = .left
                    lblforward.textColor = UIColor.init(hex: "939393")
                    lblforward.numberOfLines = 1
                    lblforward.sizeToFit()
                    imageView.addSubview(lblforward)
                }
                
            }
            //End
           if(!isTableMutable && !isSeletForward){
            responsiveView = ResponsiveViewOut()
            
            // Add our responsive view to a super view
            responsiveView.frame = CGRect(x: screenWidth - width - 10.0, y: 0.0,width: width,height: height) //CGRect(x: 0, y: 0, width: 300, height: 100)
            //responsiveView.center = self.center
            responsiveView.backgroundColor = UIColor.clear //UIColor(red: 124.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            //responsiveView.layer.cornerRadius = 4;
            //responsiveView.layer.masksToBounds = true
            responsiveView.tag = mytagcell
            responsiveView.accessibilityValue = chatStatus
            self.addSubview(responsiveView)
            
            // Add a long press gesture recognizer to our responsive view
            responsiveView.isUserInteractionEnabled = true
            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandlerout))
            longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
            responsiveView.addGestureRecognizer(longPressGR)
            //Play image
            }
            //End
            if(messageSubType == "Forwarded"){
                forward = UIButton(frame: CGRect(x: (width/2) + 60, y: 20.0 + imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            }
            else{
                forward = UIButton(frame: CGRect(x: (width/2) + 60, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            }
            
            //forward = UIButton(frame: CGRect(x: (width/2) + 60, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
            forward.setImage(UIImage(named: "forward_out"), for: UIControl.State.normal)
            forward.isUserInteractionEnabled = true
            forward.backgroundColor =  UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
            forward.isHidden = true
            forward.layer.masksToBounds = true
            forward.clipsToBounds=true
            forward.layer.cornerRadius = 20.0
             forward.alpha = CGFloat(0.9)
            self.addSubview(forward)
           
            if(chatStatus == "sending")
            {
                let viewForActivityIndicator = UIView()
                
                viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: imageViewObject.frame.size.width, height: imageViewObject.frame.size.height)
                viewForActivityIndicator.alpha = 0.7
                viewForActivityIndicator.backgroundColor = UIColor.darkGray
                imageViewObject.addSubview(viewForActivityIndicator)
                
                
             //   let activityIndicatorView = UIActivityIndicatorView()
             //   activityIndicatorView.center = CGPoint(x:imageViewObject.frame.size.width/2 , y: imageViewObject.frame.size.width/2)
                let loadingTextLabel = UILabel()
                
                loadingTextLabel.textColor = UIColor.white
                loadingTextLabel.text = "Uploading Video..."
              //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                loadingTextLabel.sizeToFit()
                loadingTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 75)
                viewForActivityIndicator.addSubview(loadingTextLabel)
                lbltime.isHidden = true
               
                progressSlider = CustomSlider(frame: CGRect(x: 5.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width-10, height: 70))//changed
                progressSlider.tag = mytagcell
                //progressSlider.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 113)
                progressSlider.setThumbImage(UIImage(named: "uncheck"), for: .normal)
               // progressSlider.layer.cornerRadius = 0
                progressSlider.isSelected = false
                progressSlider.isUserInteractionEnabled = false
                progressSlider.minimumTrackTintColor = UIColor.init(hex: "FFD401")
                progressSlider.trackWidth = 20
                progressSlider.bounds = progressSlider.trackRect(forBounds: progressSlider.bounds)
                viewForActivityIndicator.addSubview(progressSlider)
                
                progressTextLabel = UILabel(frame: CGRect(x: 0.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width, height: 70))
                //changed
                progressTextLabel.font = UIFont.systemFont(ofSize: fontSize)
                //progressTextLabel.text = ""
                progressTextLabel.accessibilityValue = messageId
                progressTextLabel.textColor = UIColor.white
                //progressTextLabel.backgroundColor = UIColor.red
                progressTextLabel.textAlignment = .center
                //label.textColor = self.strokeColor
                progressTextLabel.lineBreakMode = .byWordWrapping
                progressTextLabel.numberOfLines = 0
                //progressTextLabel.sizeToFit()
                //self.addSubview(progressTextLabel)
                // loadingTextLabel.text = "Downloading video...\(Int(a))"
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                //loadingTextLabel.sizeToFit()
               // progressTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: imageViewObject.frame.size.height-45)
                viewForActivityIndicator.addSubview(progressTextLabel)
                
                
                
               // activityIndicatorView.hidesWhenStopped = true
               // activityIndicatorView.activityIndicatorViewStyle = .white
              //  viewForActivityIndicator.addSubview(activityIndicatorView)

                //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
              //   activityIndicatorView.startAnimating()
            }
             else if(chatStatus == "downloading")
            {
                let viewForActivityIndicator = UIView()
                
                viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: imageViewObject.frame.size.width, height: imageViewObject.frame.size.height)
                viewForActivityIndicator.alpha = 0.7
                viewForActivityIndicator.backgroundColor = UIColor.darkGray
                imageViewObject.addSubview(viewForActivityIndicator)
                
                
             //   let activityIndicatorView = UIActivityIndicatorView()
             //   activityIndicatorView.center = CGPoint(x:imageViewObject.frame.size.width/2 , y: imageViewObject.frame.size.width/2)
                let loadingTextLabel = UILabel()
                
                loadingTextLabel.textColor = UIColor.white
                loadingTextLabel.text = "Downloading video..."
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                loadingTextLabel.sizeToFit()
                loadingTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 75)
                viewForActivityIndicator.addSubview(loadingTextLabel)
                
                
               lbltime.isHidden = true
                progressSlider = CustomSlider(frame: CGRect(x: 5.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width-10, height: 70))//changed
                progressSlider.tag = mytagcell
                //progressSlider.center = CGPoint(x: viewForActivityIndicator.center.x, y: viewForActivityIndicator.center.y + 113)
                progressSlider.setThumbImage(UIImage(named: "uncheck"), for: .normal)
                // progressSlider.layer.cornerRadius = 0
                progressSlider.isSelected = false
                progressSlider.isUserInteractionEnabled = false
                progressSlider.minimumTrackTintColor = UIColor.init(hex: "FFD401")
                progressSlider.trackWidth = 20
                progressSlider.bounds = progressSlider.trackRect(forBounds: progressSlider.bounds)
                viewForActivityIndicator.addSubview(progressSlider)
                
                progressTextLabel = UILabel(frame: CGRect(x: 0.0, y: imageViewObject.frame.size.height-50, width: imageViewObject.frame.size.width, height: 70))
                //changed
                progressTextLabel.font = UIFont.systemFont(ofSize: fontSize)
                //progressTextLabel.text = ""
                progressTextLabel.accessibilityValue = messageId
                progressTextLabel.textColor = UIColor.white
                //progressTextLabel.backgroundColor = UIColor.red
                progressTextLabel.textAlignment = .center
                //label.textColor = self.strokeColor
                progressTextLabel.lineBreakMode = .byWordWrapping
                progressTextLabel.numberOfLines = 0
                //progressTextLabel.sizeToFit()
                //self.addSubview(progressTextLabel)
                // loadingTextLabel.text = "Downloading video...\(Int(a))"
                //  loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
                //loadingTextLabel.sizeToFit()
                // progressTextLabel.center = CGPoint(x: viewForActivityIndicator.center.x, y: imageViewObject.frame.size.height-45)
                viewForActivityIndicator.addSubview(progressTextLabel)
                
                
                
                //activityIndicatorView.hidesWhenStopped = true
               // activityIndicatorView.activityIndicatorViewStyle = .white
               // viewForActivityIndicator.addSubview(activityIndicatorView)
                
                //LoadingIndicatorView.show(overlay, loadingText: "Uploading Video...")
               // activityIndicatorView.startAnimating()
                //LoadingIndicatorView.show(overlay, loadingText: "Downloading Video...")
                
            }
            if(!thumbLink.isEmpty)
            {
                //LoadingIndicatorView.show(overlay, loadingText: "Downloading video...")
                
                if(chatStatus == "failed")
                {
                    LoadingIndicatorView.hide()
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
                            let arrReadselVideoPath = thumbLink.components(separatedBy: "/")
                            let imageId = arrReadselVideoPath.last
                            let arrReadimageId = imageId?.components(separatedBy: ".")
                            
                           // _ = self.appDelegate().saveImageToLocalWithNameReturnPath(UIImage(data: data)!,fileName: arrReadimageId![0] as String)
                             self.appDelegate().saveImageToLocalWithName(UIImage(data: data)!,fileName: arrReadimageId![0] as String)
                            imageViewObject.image = thumbImg?.square()//UIImage(data: data)
                        })
                    }
                }
                
                // Run task
                task.resume()
                
            }
                
             else
             {
               
                if(chatStatus == "failed" && chatStatus == "sent")
                {
                    LoadingIndicatorView.hide()
                }
                //LoadingIndicatorView.hide()
             }
          
            
            if( chatStatus == "sent")
            {
                if(messageSubType == "Forwarded"){
                    let playImage = UIImageView(frame: CGRect(x: (width/2) + 60, y: 20.0 + imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
                    playImage.image = UIImage(named: "ff_play")
                    playImage.backgroundColor =  UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
                    playImage.layer.masksToBounds = true
                    playImage.clipsToBounds=true
                    playImage.layer.cornerRadius = 20.0
                    playImage.alpha = CGFloat(0.9)
                    self.addSubview(playImage)
                }
                else{
                    let playImage = UIImageView(frame: CGRect(x: (width/2) + 60, y: imageViewObject.frame.height / 2, width: 40.0, height: 40.0))
                    playImage.image = UIImage(named: "ff_play")
                    playImage.backgroundColor =  UIColor(red: 0xee/0xff, green: 0xee/0xff, blue: 0xee/0xff, alpha: 1)
                    playImage.layer.masksToBounds = true
                    playImage.clipsToBounds=true
                    playImage.layer.cornerRadius = 20.0
                    playImage.alpha = CGFloat(0.9)
                    self.addSubview(playImage)
                }
                
                
            }
            imageView.addSubview(imageViewObject)
            
            
            
        }
        else
        {
            
            // Calculate relative sizes
            let padding = fontSize * 0.7
            let label = UILabel(frame: CGRect(x: 0.0, y: controlsY, width: bubbleWidth, height: CGFloat.greatestFiniteMagnitude))//changed
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.text = text
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            //label.dataDetectorTypes = .all
            //label.isEditable = false
            label.sizeToFit()
            
            //Time
            let lbltime = UILabel(frame: CGRect(x: 0.0, y: label.frame.size.height + 10.0 + controlsY, width: 80.0, height: 15.0))//changed
            lbltime.font = UIFont.systemFont(ofSize: 12.0)
            lbltime.text = messageTime//"2:11 PM"
            lbltime.textColor = UIColor.gray
            lbltime.textAlignment = .right
            lbltime.shadowColor = UIColor.lightGray
            lbltime.sizeToFit()
            
            //let labelSize = label.intrinsicContentSize
            var width = bubbleWidth + padding * 3//(label.frame.width + padding * 2) + 5.0 //labelSize.width + padding //* 3 // 50% more padding on width
            if(width < 120.0)
            {
                width = 120.0
            }
            
            let height = label.frame.height + (lbltime.frame.height+chatPlaneMsgHeight) + padding //* 2 //labelSize.height + triangleHeight + padding * 2
            //let height = label.frame.height + (lbltime.frame.height+30.0) + padding //* 2 //labelSize.height + triangleHeight + padding * 2
            let bubbleRect = CGRect(x: 0, y: 0, width: width, height: height + 10.0)
            self.init(frame: bubbleRect)
            //baseView.frame = bubbleRect
            
            let foo = UIImage(named: "bubble_out") // 328 x 328 //changed
            let fooWithInsets = foo?.resizableImageWithStretchingProperties(
                X: 0.48, width: 0, Y: 0.45, height: 0) ?? foo
            
            let imageView = UIImageView(image: fooWithInsets)
            imageView.frame = CGRect(x: screenWidth - width - 10.0, y: 0, width: width, height: height)//changed
            self.addSubview(imageView)
            
            label.frame.origin = CGPoint(x:15.0, y:10.0 + controlsY)
            imageView.addSubview(label)
            
            //It was previously below
            //lbltime.frame.origin = CGPoint(x:bubbleRect.size.width - 70.0, y:lbltime.frame.origin.y)
            lbltime.frame.origin = CGPoint(x:bubbleRect.size.width - 15.0 - lbltime.frame.width, y:lbltime.frame.origin.y)
            
            imageView.addSubview(lbltime)
            
            //End
            
            //New code only for Banter
            //if(chatType == "banter")
            //{
            if(chatType == "group" || chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
            {
                if( chatType == "banter" || chatType == "teambr")
                {
                    let teamImageName = "Team" + mySupportTeam.description
                    let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
                    if((teamImage) != nil)
                    {
                        let teamImg = appDelegate().loadProfileImage(filePath: teamImage!)
                        
                        
                        let imageViewTeam = UIImageView(image: teamImg)
                        imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 20.0, height: 20.0)
                        imageView.addSubview(imageViewTeam)
                        
                    }
                    else
                    {
                        let teamImg = UIImage(named: "team")
                        let imageViewTeam = UIImageView(image: teamImg)
                        imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 20.0, height: 20.0)
                        imageView.addSubview(imageViewTeam)
                    }
                    let lblName = UILabel(frame: CGRect(x: 40.0, y: 5.0, width: bubbleWidth, height: 20.0))//changed
                    lblName.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblName.text = "You"
                    lblName.textAlignment = .left
                    //label.textColor = self.strokeColor
                    lblName.numberOfLines = 1
                    lblName.sizeToFit()
                    imageView.addSubview(lblName)
                }
                else{
                    let lblName = UILabel(frame: CGRect(x: 15.0, y: 5.0, width: bubbleWidth, height: 20.0))//changed
                    lblName.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblName.text = "You"
                    lblName.textAlignment = .left
                    //label.textColor = self.strokeColor
                    lblName.numberOfLines = 1
                    lblName.sizeToFit()
                    imageView.addSubview(lblName)
                }
 
            
            //}
            
            //Name of user
           
            }
            if(messageSubType == "Forwarded"){
                if(chatType == "group" || chatType == "banter" || chatType == "fanupdates" || chatType == "teambr")
                {
                    let forwardImg = UIImage(named: "forward_in")
                    let imageViewTeam = UIImageView(image: forwardImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 25.0, width: 15.0, height: 15.0)
                    imageView.addSubview(imageViewTeam)
                    let lblforward = UILabel(frame: CGRect(x: 35.0, y: 25.0, width: bubbleWidth, height: 10.0))//changed
                    lblforward.font = UIFont.systemFont(ofSize: 13)
                    //lblforward.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblforward.text = "Forwarded"
                    lblforward.textAlignment = .left
                    lblforward.textColor = UIColor.init(hex: "939393")
                    lblforward.numberOfLines = 1
                    lblforward.sizeToFit()
                    imageView.addSubview(lblforward)
                }
                else{
                    let forwardImg = UIImage(named: "forward_in")
                    let imageViewTeam = UIImageView(image: forwardImg)
                    imageViewTeam.frame = CGRect(x: 15.0, y: 5.0, width: 15.0, height: 15.0)
                    imageView.addSubview(imageViewTeam)
                    let lblforward = UILabel(frame: CGRect(x: 35.0, y: 5.0, width: bubbleWidth, height: 10.0))//changed
                    lblforward.font = UIFont.systemFont(ofSize: 13)
                    //lblforward.font = UIFont.boldSystemFont(ofSize: fontSize)
                    lblforward.text = "Forwarded"
                    lblforward.textAlignment = .left
                    lblforward.textColor = UIColor.init(hex: "939393")
                    lblforward.numberOfLines = 1
                    lblforward.sizeToFit()
                    imageView.addSubview(lblforward)
                }
                
            }
            //End
            if(!isTableMutable && !isSeletForward){
            responsiveView = ResponsiveViewOut()
            
            // Add our responsive view to a super view
            responsiveView.frame = CGRect(x: 0.0, y: 0.0,width: screenSize.width,height: bubbleWidth) //CGRect(x: 0, y: 0, width: 300, height: 100)
            responsiveView.center = self.center
            responsiveView.backgroundColor = UIColor.clear //UIColor(red: 124.0/255.0, green: 112.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            //responsiveView.layer.cornerRadius = 4;
            //responsiveView.layer.masksToBounds = true
            responsiveView.tag = mytagcell
                 responsiveView.accessibilityValue = messageType
            self.addSubview(responsiveView)
            
            // Add a long press gesture recognizer to our responsive view
            responsiveView.isUserInteractionEnabled = true
            let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandlerout))
            longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
            responsiveView.addGestureRecognizer(longPressGR)
                label.isUserInteractionEnabled = true
               // let longPressGR1 = UITapGestureRecognizer(target: self, action: #selector(longPressHandlerout1))
                //longPressGR.minimumPressDuration = 0.3 // how long before menu pops up
               // label.addGestureRecognizer(longPressGR1)
            }
            /* Hide for banter for now
            let imageTick = UIImageView(frame:CGRect(x: lbltime.frame.origin.x + lbltime.intrinsicContentSize.width , y: lbltime.frame.origin.y,width: 15.0,height: 15.0));//changed
            //imageTick.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            imageTick.contentMode = .scaleAspectFit
            if(chatStatus == "failed" || chatStatus == "sending")
            {
                imageTick.image = UIImage(named: "failtick")
            }
            else if(chatStatus == "sent")
            {
                imageTick.image = UIImage(named: "senttick")
            }
            else if(chatStatus == "delivered")
            {
                imageTick.image = UIImage(named: "deltick")
            }
            else if(chatStatus == "received")
            {
                imageTick.image = UIImage(named: "rectick")
            }
            imageView.addSubview(imageTick)
            */
            
           
            
        }
    }
    
    @objc func longPressHandlerout1(sender: UITapGestureRecognizer) {
       print(sender)
    }
    
    @objc func longPressHandlerout(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }
        
        // Make responsiveView the window's first responder
        senderView.becomeFirstResponder()
        //print(sender.view?.tag as Any)
        UserDefaults.standard.setValue(sender.view?.tag as Any, forKey: "atIndex")
        UserDefaults.standard.synchronize()// Set up the shared UIMenuController
        //let saveMenuItem = UIMenuItem(title: "Report", action: #selector(reportTapped))
        let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(deleteTapped))
        let copyMenuItem = UIMenuItem(title: "Copy", action: #selector(copyTapped))
        // let replyMenuItem = UIMenuItem(title: "Reply", action: #selector(reportTapped))
        let forwardMenuItem = UIMenuItem(title: "Forward", action: #selector(forwardTapped))
        let textType = sender.view?.accessibilityValue as! String
        // print(sender.view?.accessibilityValue)
        if(textType == "text"){
            UIMenuController.shared.menuItems = [deleteMenuItem, copyMenuItem, forwardMenuItem]
            UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
        }
        else{
           // UIMenuController.shared.menuItems = [deleteMenuItem, forwardMenuItem]
            //UIMenuController.shared.arrowDirection = UIMenuControllerArrowDirection.down
            if(textType == "sent"){
                UIMenuController.shared.menuItems = [ deleteMenuItem, forwardMenuItem]
                UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
            }
            else{
                UIMenuController.shared.menuItems = [ deleteMenuItem]
                UIMenuController.shared.arrowDirection = UIMenuController.ArrowDirection.down
                
            }
        }
        
        // Tell the menu controller the first responder's frame and its super view
        // UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
        UIMenuController.shared.setTargetRect(CGRect(x: 0, y: 0, width: 300, height: 30), in: superView)
        
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    @objc func deleteTapped() {
       // print("delete tapped")
        let atindex = UserDefaults.standard.integer(forKey: "atIndex")
        
        let actionUserinfo:[String: AnyObject] = ["menuaction": "Delete" as AnyObject, "atindex": atindex as AnyObject]
        let notificationName = Notification.Name("menuActionCell")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: actionUserinfo)
        // ...
        responsiveView.resignFirstResponder()
    }
    @objc func copyTapped() {
        //print("delete tapped")
        let atindex = UserDefaults.standard.integer(forKey: "atIndex")
        
        let actionUserinfo:[String: AnyObject] = ["menuaction": "Copy" as AnyObject, "atindex": atindex as AnyObject]
        let notificationName = Notification.Name("menuActionCell")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: actionUserinfo)
        // ...
        responsiveView.resignFirstResponder()
    }
    @objc func forwardTapped() {
        //  print("save tapped")
        let atindex = UserDefaults.standard.integer(forKey: "atIndex")
        
        let actionUserinfo:[String: AnyObject] = ["menuaction": "Forward" as AnyObject, "atindex": atindex as AnyObject]
        let notificationName = Notification.Name("menuActionCell")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: actionUserinfo)
        // ...
        // This would be a good place to optionally resign
        // responsiveView's first responder status if you need to
        
        responsiveView.resignFirstResponder()
    }
    /*// Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     
     }*/
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ChatBubbleOut.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ChatBubbleOut.realDelegate!;
    }
    
    
}
