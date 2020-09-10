//
//  MessageStatusViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 11/10/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AssetsLibrary

class MessageStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "messagestatus"
    var sections = ["","Delevered to","Read by"]
    var messageContent = [AnyObject]()
    var deleverUsers = [AnyObject]()
    var receivedUsers = [AnyObject]()
    //var message: NSDictionary!
    var messageStatus = [AnyObject]()
    var cellIndex: Int = 0
    var toUserJidLocal: String = ""
    var toRoomTypeLocal: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshStatus()
    }
    
    func refreshStatus()
    {
        var tmpAllAppContacts: NSArray!
        let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
        if strAllContacts != nil
        {
            //Code to parse json data
            if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                    
                    appDelegate().allContacts = NSMutableArray()
                    for record in tmpAllContacts {
                        appDelegate().allContacts[appDelegate().allContacts.count] = record
                    }
                    
                    tmpAllAppContacts = appDelegate().allContacts[0] as? NSArray
                    
                    appDelegate().allAppContacts = NSMutableArray()
                    for record in tmpAllAppContacts {
                        appDelegate().allAppContacts[appDelegate().allAppContacts.count] = record
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        
        
        let localArrAllChats: String? = UserDefaults.standard.string(forKey: "arrAllChats")
        if localArrAllChats != nil
        {
            //Code to parse json data
            if let data = localArrAllChats?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                do {
                    appDelegate().arrAllChats = try JSONSerialization.jsonObject(with:data , options: []) as! [String : AnyObject]
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        if(appDelegate().arrAllChats.count > 0)
        {
            if let dt = appDelegate().arrAllChats[appDelegate().toUserJID]
            {
                self.appDelegate().arrUserChat = dt["Chats"] as! [AnyObject]
                let selMessage: NSDictionary = self.appDelegate().arrUserChat[cellIndex] as! NSDictionary
                //print(selMessage)
                messageContent.append(selMessage)
                messageStatus.append(messageContent as AnyObject)
                
                //Delever
                /*deleverUsers.append(selMessage)
                 deleverUsers.append(selMessage)
                 deleverUsers.append(selMessage)
                 messageStatus.append(deleverUsers as AnyObject)*/
                let tempDelUsers = selMessage.value(forKey: "deleverUsers") as! [AnyObject]
                
                for record in tempDelUsers
                {
                    let message: NSDictionary = record as! NSDictionary
                    let uJID = message.value(forKey: "delUserJID") as? String
                    let time = message.value(forKey: "delUserTime") as? Int64
                    var strName: String = ""
                    var strLogo: String = ""
                    var strStatus: String = ""
                    var strMobile: String = ""
                    
                    _ = tmpAllAppContacts.filter({ (text) -> Bool in
                        let tmp: NSDictionary = text as! NSDictionary
                        let jid: String = tmp.value(forKey: "jid") as! String
                        if(jid == uJID)
                        {
                            strName = tmp.value(forKey: "name") as! String
                            strLogo = tmp.value(forKey: "avatar") as! String
                            strStatus = tmp.value(forKey: "status") as! String
                            strMobile = tmp.value(forKey: "mobile") as! String
                            //return true
                        }
                        
                        return false
                    })
                    
                    if(!strName.isEmpty)
                    {
                        var tempDict = [String: AnyObject]()
                        
                        tempDict["jid"] = uJID as AnyObject
                        tempDict["name"] = strName as AnyObject
                        tempDict["nickname"] = "" as AnyObject
                        tempDict["mobile"] = strMobile as AnyObject
                        if(!strLogo.isEmpty)
                        {
                            tempDict["avatar"] = strLogo as AnyObject
                        }
                        else
                        {
                            tempDict["avatar"] = "" as AnyObject
                        }
                        
                        let status: String? = strStatus
                        if status != nil
                        {
                            tempDict["status"] = status as AnyObject
                        }
                        else
                        {
                            tempDict["status"] = "Hello! I am a Football Fan" as AnyObject
                        }
                        tempDict["time"] = time as AnyObject
                        
                        deleverUsers.append(tempDict as AnyObject)
                    }
                    else
                    {
                        var tempDict = [String: AnyObject]()
                        
                        let arrMessageFrom = uJID?.components(separatedBy: "@")
                        let messageFromTrim = arrMessageFrom![0]
                        
                        tempDict["jid"] = uJID as AnyObject
                        tempDict["name"] = messageFromTrim as AnyObject
                        tempDict["nickname"] = messageFromTrim as AnyObject
                        tempDict["mobile"] = messageFromTrim as AnyObject
                        tempDict["avatar"] = "" as AnyObject
                        tempDict["status"] = "" as AnyObject
                        tempDict["time"] = time as AnyObject
                        deleverUsers.append(tempDict as AnyObject)
                    }
                    
                    
                }
                
                
                messageStatus.append(deleverUsers as AnyObject)
                //Received
                //Delever
                /*receivedUsers.append(selMessage)
                 receivedUsers.append(selMessage)
                 receivedUsers.append(selMessage)
                 messageStatus.append(receivedUsers as AnyObject)*/
                //receivedUsers = selMessage.value(forKey: "receivedUsers") as! [AnyObject]
                
                let tempRecUsers = selMessage.value(forKey: "receivedUsers") as! [AnyObject]
                
                for record in tempRecUsers
                {
                    let message: NSDictionary = record as! NSDictionary
                    let uJID = message.value(forKey: "recUserJID") as? String
                    let time = message.value(forKey: "recUserTime") as? Int64
                    var strName: String = ""
                    var strLogo: String = ""
                    var strStatus: String = ""
                    var strMobile: String = ""
                    
                    _ = tmpAllAppContacts.filter({ (text) -> Bool in
                        let tmp: NSDictionary = text as! NSDictionary
                        let jid: String = tmp.value(forKey: "jid") as! String
                        if(jid == uJID)
                        {
                            strName = tmp.value(forKey: "name") as! String
                            strLogo = tmp.value(forKey: "avatar") as! String
                            strStatus = tmp.value(forKey: "status") as! String
                            strMobile = tmp.value(forKey: "mobile") as! String
                            //return true
                        }
                        
                        return false
                    })
                    
                    if(!strName.isEmpty)
                    {
                        var tempDict = [String: AnyObject]()
                        
                        tempDict["jid"] = uJID as AnyObject
                        tempDict["name"] = strName as AnyObject
                        tempDict["nickname"] = "" as AnyObject
                        tempDict["mobile"] = strMobile as AnyObject
                        if(!strLogo.isEmpty)
                        {
                            tempDict["avatar"] = strLogo as AnyObject
                        }
                        else
                        {
                            tempDict["avatar"] = "" as AnyObject
                        }
                        
                        let status: String? = strStatus
                        if status != nil
                        {
                            tempDict["status"] = status as AnyObject
                        }
                        else
                        {
                            tempDict["status"] = "Hello! I am a Football Fan" as AnyObject
                        }
                        tempDict["time"] = time as AnyObject
                        
                        receivedUsers.append(tempDict as AnyObject)
                    }
                    else
                    {
                        var tempDict = [String: AnyObject]()
                        
                        let arrMessageFrom = uJID?.components(separatedBy: "@")
                        let messageFromTrim = arrMessageFrom![0]
                        
                        tempDict["jid"] = uJID as AnyObject
                        tempDict["name"] = messageFromTrim as AnyObject
                        tempDict["nickname"] = messageFromTrim as AnyObject
                        tempDict["mobile"] = messageFromTrim as AnyObject
                        tempDict["avatar"] = "" as AnyObject
                        tempDict["status"] = "" as AnyObject
                        tempDict["time"] = time as AnyObject
                        receivedUsers.append(tempDict as AnyObject)
                    }
                    
                    
                }
                messageStatus.append(receivedUsers as AnyObject)
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " " + self.sections[section]
        label.textColor=UIColor(hex: "FFFFFF")
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        
        
        
        
        
        return headerView
    }
    
    //Number of sections count in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(appDelegate().allContacts)
        //print(appDelegate().allContacts.count)
        
        return sections.count
        
    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.animals.count
        
        /*if(section == 1)
        {
            return receivedUsers.count
        }
        else if(section == 2)
        {
            return deleverUsers.count
        }*/
        
        
        //return messageStatus.count
        return ((messageStatus[section] as AnyObject).count)
        //return ((appDelegate().allContacts[section] as AnyObject).count)
        //return (appDelegate().allAppContacts.count)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MessageStatusCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MessageStatusCell
        
        let arry: [AnyObject] = (messageStatus[indexPath.section] as? [AnyObject])!
        let message: NSDictionary = arry[indexPath.row] as! NSDictionary
        //let message: NSDictionary = messageStatus[indexPath.row] as! NSDictionary
        
        //let userName: String = message.value(forKey: "userName") as! String
        
        
        
        
        var msgtime = ""
        
        if(indexPath.section == 0)
        {
            cell.contactStatus?.isHidden = true
            cell.contactName?.isHidden = true
            cell.contactImage?.isHidden = true
            let isIncoming: String = message.value(forKey: "isIncoming") as! String
            
            if let mili = message.value(forKey: "time")
            {
                let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                
                msgtime = String(myMilliseconds.toHour) as String
                
            }
            
            if(isIncoming == "NO")
            {
                let messageType = message.value(forKey: "messageType") as! String
                let caption = message.value(forKey: "caption") as! String
                let chatStatus = message.value(forKey: "status") as! String
                if(messageType == "image")
                {
                    //let imagePath = message.value(forKey: "filePath") as! String
                    //let imageLogo = appDelegate().loadImageFromLocalPath(filePath: "file:///var/mobile/Media/DCIM/101APPLE/IMG_1772.JPG")
                    //let path = URL(string: imagePath); //NSURL(string: imagePath)! as URL
                    //let asset = PHAssetForFileURL(url: NSURL(string: imagePath)!)
                    //let asset: PHAsset = PHAsset.fetchAssets(withALAssetURLs: [path!], options: nil).firstObject!
                    //let asset = PHAssetForFileURL(url: NSURL(string: imagePath)!)
                    let imageId = message.value(forKey: "fileLocalId") as! String
                    let thumbLink = message.value(forKey: "thumb") as! String
                    
                    if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [imageId], options: nil).firstObject
                    {
                        let imageLogo = getAssetThumbnail(asset: asset, size: 320.0)//100.0
                        //let imageLogo = getVideoThumbnailImage(forUrl: NSURL(string: imagePath)! as URL)
                        
                        let chatBubbleR: ChatBubbleOut = ChatBubbleOut(baseView: cell.chatBubble!, text: message.value(forKey: "messageContent") as! String, fontSize: 17.0, messageType: messageType, messageTime: msgtime, imageLogo: imageLogo, caption: caption, thumbLink: thumbLink, chatStatus: chatStatus, messageId: message.value(forKey: "messageId") as! String)
                        cell.chatBubble?.removeAllSubviews()
                        cell.chatBubble?.addSubview(chatBubbleR)
                        storyTableView?.rowHeight = chatBubbleR.frame.height
                        if(chatStatus == "failed")
                        {
                            chatBubbleR.forward.isHidden = false
                            chatBubbleR.forward.setImage(UIImage(named: "failed"), for: UIControl.State.normal)
                            chatBubbleR.forward.tag = indexPath.row
                            chatBubbleR.forward.addTarget(self, action: #selector(ChatViewController.resendMedia(_:)), for: UIControl.Event.touchUpInside)
                        }
                        else
                        {
                            if(!thumbLink.isEmpty){
                                //chatBubbleR.forward.isHidden = false
                                //chatBubbleR.forward.addTarget(self, action: #selector(ChatViewController.openContactsOut(_:)), for: UIControlEvents.touchUpInside)
                            }
                        }
                        
                    }
                    
                }
                else if(messageType == "video")
                {
                    let videoPath = message.value(forKey: "filePath") as! String
                    let thumbLink = message.value(forKey: "thumb") as! String
                    //let imageLogo = appDelegate().loadImageFromLocalPath(filePath: "file:///var/mobile/Media/DCIM/101APPLE/IMG_1772.JPG")
                    //let path = URL(string: imagePath); //NSURL(string: imagePath)! as URL
                    ////let asset = PHAssetForFileURL(url: NSURL(string: imagePath)!)
                    //let asset: PHAsset = PHAsset.fetchAssets(withALAssetURLs: [path!], options: nil).firstObject!
                    
                    ////let imageLogo = getAssetThumbnail(asset: asset!, size: 100.0)
                    let videoLogo = getVideoThumbnailImage(forUrl: NSURL(string: videoPath)! as URL)
                    
                    if(videoLogo?.imageAsset != nil)
                    {
                        let videoLogoSquare = videoLogo?.square()?.resized(toWidth: 100.0)
                        
                        let chatBubbleR: ChatBubbleOut = ChatBubbleOut(baseView: cell.chatBubble!, text: message.value(forKey: "messageContent") as! String, fontSize: 17.0, messageType: messageType, messageTime: msgtime, videoLogo: videoLogoSquare!, caption: caption, thumbLink: thumbLink, chatStatus: chatStatus, messageId: message.value(forKey: "messageId") as! String)
                        cell.chatBubble?.removeAllSubviews()
                        cell.chatBubble?.addSubview(chatBubbleR)
                        storyTableView?.rowHeight = chatBubbleR.frame.height
                        
                        if(chatStatus == "failed")
                        {
                            chatBubbleR.forward.isHidden = false
                            chatBubbleR.forward.setImage(UIImage(named: "failed"), for: UIControl.State.normal)
                            chatBubbleR.forward.tag = indexPath.row
                            chatBubbleR.forward.addTarget(self, action: #selector(ChatViewController.resendMedia(_:)), for: UIControl.Event.touchUpInside)
                        }
                        else
                        {
                            if(!thumbLink.isEmpty){
                                //chatBubbleR.forward.isHidden = false
                                //chatBubbleR.forward.addTarget(self, action: #selector(ChatViewController.openContactsOut(_:)), for: UIControlEvents.touchUpInside)
                            }
                        }
                    }
                    else
                    {
                        let chatBubbleR: ChatBubbleOut = ChatBubbleOut(baseView: cell.chatBubble!, text: message.value(forKey: "messageContent") as! String, fontSize: 17.0, messageType: messageType, messageTime: msgtime , messageId: message.value(forKey: "messageId") as! String)
                        cell.chatBubble?.removeAllSubviews()
                        cell.chatBubble?.addSubview(chatBubbleR)
                        storyTableView?.rowHeight = chatBubbleR.frame.height
                    }
                }
                else
                {
                    let chatBubbleR: ChatBubbleOut = ChatBubbleOut(baseView: cell.chatBubble!, text: message.value(forKey: "messageContent") as! String, fontSize: 17.0, messageType: messageType, messageTime: msgtime, chatStatus: chatStatus, messageId: message.value(forKey: "messageId") as! String)
                    cell.chatBubble?.removeAllSubviews()
                    cell.chatBubble?.addSubview(chatBubbleR)
                    storyTableView?.rowHeight = chatBubbleR.frame.height
                }
                
            }
        }
        else if(indexPath.section == 1 || indexPath.section == 2)
        {
            storyTableView?.rowHeight = 44.0
            cell.contactStatus?.isHidden = false
            cell.contactName?.isHidden = false
            cell.contactImage?.isHidden = false
            
            cell.contactName?.text = message.value(forKey: "name") as? String
            
            if let mili = message.value(forKey: "time")
            {
                let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                let date = myMilliseconds.dateFull
                
                cell.contactStatus?.text = convertDateFormater(date)
                
            }
        
            if(message.value(forKey: "avatar") != nil)
            {
                let avatar:String = (message.value(forKey: "avatar") as? String)!
                if(!avatar.isEmpty)
                {
                    //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                    appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
                }
            }
            else
            {
                cell.contactImage?.image = UIImage(named: "user")
            }
        }
        
        
        
        
        //print(phoneFilteredContacts)
            //print(appDelegate().allContacts)
            /*let arry: NSArray? = appDelegate().allContacts[indexPath.section] as? NSArray
            let dict: NSDictionary? = arry?[indexPath.row] as? NSDictionary
            cell.contactName?.text = dict?.value(forKey: "name") as? String
            cell.contactStatus?.text = dict?.value(forKey: "status") as? String
            let type = dict?.value(forKey: "type") as? String
            if(type == "phone")
            {
                cell.btnInvite?.isHidden = false
                cell.contactImage?.isHidden = true
                //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
                cell.contactName?.frame.origin.x = 15.0
                cell.contactStatus?.frame.origin.x = 15.0
            }
            else
            {
                cell.btnInvite?.isHidden = true
                cell.contactImage?.isHidden = false
                //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
                cell.contactName?.frame.origin.x = 55.0
                cell.contactStatus?.frame.origin.x = 55.0
                if(dict?.value(forKey: "avatar") != nil)
                {
                    let avatar:String = (dict?.value(forKey: "avatar") as? String)!
                    if(!avatar.isEmpty)
                    {
                        cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                    }
                }
                else
                {
                    cell.contactImage?.image = UIImage(named: "user")
                }
            }*/
        
        
        
        return cell
    }
    
    func convertDateFormater(_ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss i"
        //let date = dateFormatter.date(from: date)
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date)
        
    }
    
    /*func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: CGFloat(cropSizeLength), height: CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }*/
    
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        
        let originalWidth: CGFloat  = CGFloat(asset.pixelWidth)
        let originalHeight: CGFloat = CGFloat(asset.pixelHeight)
        
        
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = originalWidth
        var cgheight: CGFloat = originalHeight
        
        // See what size is longer and create the center off of that
        if originalWidth > originalHeight {
            posX = ((originalWidth - originalHeight) / 2)
            posY = 0
            cgwidth = originalHeight
            cgheight = originalHeight
        } else {
            posX = 0
            posY = ((originalHeight - originalWidth) / 2)
            cgwidth = originalWidth
            cgheight = originalWidth
        }
        
        
        let square = CGRect(x: posX, y: posY, width: CGFloat(cropSizeLength), height: CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        
        
        
        //let cropRect = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func getVideoThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = CGSize(width: 320, height: 180) //.maximumSize = CGSize
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            let img: UIImage = UIImage(cgImage: thumbnailImage)
            return img
        } catch let error {
            print(error)
            let img: UIImage = UIImage(named: "splash_bg")!
            return img
        }
    }

    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MessageStatusViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MessageStatusViewController.realDelegate!;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
