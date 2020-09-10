//
//  MerchantDetailViewController.swift
//  FootballFan
//
//  Created by Apple on 04/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class MerchantDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var imageView: UIImageView!
     @IBOutlet weak var merchatlogo: UIImageView!
     @IBOutlet weak var read: UIButton!
    @IBOutlet weak var mainView: UIView!
     @IBOutlet weak var merchantby: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var projectTitle: UILabel!
     @IBOutlet weak var Description: UILabel!
      @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
     @IBOutlet weak var DescriptionHeight: NSLayoutConstraint!
     @IBOutlet weak var parentheight: NSLayoutConstraint!
    var maintitel: String = "Products"
     @IBOutlet weak var rrpprice: UILabel!
     @IBOutlet weak var priceWidth: NSLayoutConstraint!
    var dic: NSDictionary = [:]
     lazy var lazyImage:LazyImage = LazyImage()
    @IBInspectable var cornerRadius: CGFloat = 6
    
    @IBInspectable var shadowOffsetWidth: Int = 1
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    var readmore: Bool = false
    @IBOutlet weak var CompareTableview: UITableView!
    let cellReuseIdentifier = "compare"
     var arrcompare = NSArray()
    // @IBOutlet weak var moredetaillabel: UILabel!
     @IBOutlet weak var shareView: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = maintitel
        self.CompareTableview.dataSource  = self
        self.CompareTableview.delegate = self
        imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MerchantDetailViewController.mediaPreview(_:))))
        imageView?.isUserInteractionEnabled = true
        shareView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MerchantDetailViewController.shareAction(_:))))
        shareView?.isUserInteractionEnabled = true
    }
    @objc func mediaPreview (_ sender: UITapGestureRecognizer) {
       
            
            appDelegate().isFromPreview = true
            var media = [AnyObject]()
            media.append(LightboxImage(
                image:  imageView.image!,
                text: ""
            ))
            if(media.count>0)
            {
                appDelegate().isFromPreview = true
                let controller = LightboxController(images: media as! [LightboxImage], startIndex: 0)
                
                // Set delegates.
                controller.pageDelegate = self as? LightboxControllerPageDelegate
                
                // Use dynamic background.
                controller.dynamicBackground = true
                // Present your controller.
                self.present(controller, animated: true, completion: nil)
            }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // self.parent?.title = "News"
        price.text = dic.value(forKey: "displayPrice") as? String
        projectTitle.text = dic.value(forKey: "productName") as? String
        merchantby.text = dic.value(forKey: "MerchantName") as? String
        if(dic.value(forKey: "productImageURL") != nil)
        {
            let avatar:String = (dic.value(forKey: "productImageURL") as? String)!
            if(!avatar.isEmpty)
            {
                self.lazyImage.show(imageView:imageView!, url:avatar, defaultImage: "img_thumb")
                
            }
        }
        else{
           imageView?.image = UIImage(named: "img_thumb")
        }
        
        
        if(dic.value(forKey: "MerchantImage") != nil)
        {
            let avatar:String = (dic.value(forKey: "MerchantImage") as? String)!
            if(!avatar.isEmpty)
            {
                //self.lazyImage.show(imageView:imageView!, url:avatar, defaultImage: "img_thumb")
                merchatlogo.imageURL = dic.value(forKey: "MerchantImage") as? String
            }
        }
        else{
            merchatlogo?.image = UIImage(named: "img_thumb")
        }
        if(dic.value(forKey: "productMRP") != nil)
        {
            let avatar:String = (dic.value(forKey: "productMRP") as? String)!
            if(!avatar.isEmpty && avatar != "£0.00")
            {
                //self.lazyImage.show(imageView:imageView!, url:avatar, defaultImage: "img_thumb")
                rrpprice.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (dic.value(forKey: "productMRP") as? String)!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                rrpprice.attributedText = attributeString
                //merchatlogo.imageURL = dic.value(forKey: "MerchantImage") as! String
            }
            else{
                rrpprice.isHidden = true
            }
        }
        else{
            //merchatlogo?.image = UIImage(named: "img_thumb")
            rrpprice.isHidden = true
        }
        Description.text = dic.value(forKey: "productDescription") as? String
        layoutAdjust()
        mainView?.layer.borderWidth = 0.5
        mainView?.layer.borderColor = UIColor.darkGray.cgColor
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = cornerRadius
       // let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        mainView.layer.masksToBounds = true
        mainView.layer.shadowColor = shadowColor?.cgColor
        mainView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        mainView.layer.shadowOpacity = shadowOpacity
       // mainView.layer.shadowPath = shadowPath.cgPath
        arrcompare = dic.value(forKey: "compare") as! NSArray
        if(arrcompare.count>0){
            CompareTableview.reloadData()
             CompareTableview.isHidden = false
        }
        else{
            CompareTableview.isHidden = true
        }
}
      @IBAction func readAction(){
         if(readmore){
            readmore = false
            read.setTitle("More", for: .normal)
         }else{
            readmore = true
             read.setTitle("Less", for: .normal)
        }
        layoutAdjust()
    }
    @IBAction func buyAction(){
         let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
        if(myjid != nil){
            let arrdUserJid = myjid?.components(separatedBy: "@")
            let userUserJid = arrdUserJid?[0]
            let deeplink = dic.value(forKey: "productLink") as! String + "&clickRef=" + userUserJid!
          //  print(deeplink)
            UIApplication.shared.openURL(NSURL(string : deeplink )! as URL)
        }
        else{
            appDelegate().pageafterlogin = "product"
            appDelegate().idafterlogin = dic.value(forKey: "ProductID") as! Int64
            appDelegate().LoginwithModelPopUp()
        }
        
    
    }
    @objc func shareAction (_ sender: UITapGestureRecognizer) {
       
        do {
            let fanupdateid = dic.value(forKey: "ProductID") as! Int64
            var dictRequest = [String: AnyObject]()
            dictRequest["id"] = fanupdateid as AnyObject
            dictRequest["type"] = "product" as AnyObject
            let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            
           // let decodedData = Data(base64Encoded: (dic.value(forKey: "productName") as! String))
           // let decodedString = String(data: decodedData, encoding: .utf8)!
            
            
            let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            
            let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
            
            let param = resultNSString as String?
            
            let inviteurl = InviteHost + "?q=" + param!
            //let recReadUserJid: String = UserDefaults.standard.string(forKey: "userJID")!
            //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
           // let arrReadUserJid = recReadUserJid.components(separatedBy: "@")
           // let userReadUserJid = arrReadUserJid[0]
            let productName:String = (dic.value(forKey: "productName") as? String)!
            let   text = "Compare prices and buy \"\(String(describing:productName ))\" on Football Fan App.\n\nPlease follow the link:\n\(inviteurl)\n\nBy Fans for Fans where Fans have their voice heard."
            
                                                                     let objectsToShare = [text] as [Any]
                                                                                                           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                                                                                           
                                                                                                           //New Excluded Activities Code
                                                                                                           activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                                                                                                           //
                                                                                                           
                                                                                                   activityVC.popoverPresentationController?.sourceView = self.view
                                                                                                           self.present(activityVC, animated: true, completion: nil)
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    func layoutAdjust()  {
        let label1 = UILabel(frame: CGRect(x: 20.0, y: 0, width:CGFloat.greatestFiniteMagnitude , height:price.frame.height ))
        label1.font = UIFont.systemFont(ofSize: 17.0)
        label1.text = dic.value(forKey: "displayPrice") as? String
       // label1.textAlignment = .left
        //label.textColor = self.strokeColor
        //label1.lineBreakMode = .byWordWrapping
        label1.numberOfLines = 1
        label1.sizeToFit()
        print(label1.frame.width)
        priceWidth.constant = label1.frame.width + 10
        /*if((label1.frame.width) > 53)
        {
            priceWidth.constant = label1.frame.width + 15.0
        }
        else{
            priceWidth.constant = label1.frame.width + 5.0
        }*/
        
        if(readmore){
        Description.numberOfLines = 0
        let label = UILabel(frame: CGRect(x: 20.0, y: 0, width: Description.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.font = UIFont.systemFont(ofSize: 15.0)
            label.text = dic.value(forKey: "productDescription") as? String
        label.textAlignment = .left
        //label.textColor = self.strokeColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        if((label.frame.height) > 17)
        {
            let height = (label.frame.height) + 390.0
            // cell.mainViewConstraint.constant = CGFloat(height)
            //print("Height \(height).")
            DescriptionHeight.constant = label.frame.height
           mainViewHeight.constant = height
             parentheight.constant = label.frame.height + 600
        }
        else
        {
            let height = 410.0
            // cell.mainViewConstraint.constant = CGFloat(height)
            //print("Height \(height).")
            mainViewHeight.constant = CGFloat(height)
             parentheight.constant =   600
        }
    }
        else{
            Description.numberOfLines = 1
            let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: Description.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 15.0)
            label.text = dic.value(forKey: "productDescription") as? String
            label.textAlignment = .left
            //label.textColor = self.strokeColor
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 1
            label.sizeToFit()
            if((label.frame.height) > 17)
            {
                let height = (label.frame.height) + 390.0
                // cell.mainViewConstraint.constant = CGFloat(height)
                //print("Height \(height).")
                DescriptionHeight.constant = label.frame.height
                mainViewHeight.constant = height
                 parentheight.constant = label.frame.height + 600
            }
            else
            {
                let height = 410.0
                // cell.mainViewConstraint.constant = CGFloat(height)
                //print("Height \(height).")
                mainViewHeight.constant = CGFloat(height)
                parentheight.constant =   600

            }
        }
    }
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if(section == 0)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        }
        else if(section == 1)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        }
        else if(section == 2)
        {
            headerView.backgroundColor = UIColor.clear// #FD7A5C
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " More deals for this product"
        if(section == 2){
            label.textColor=UIColor(hex: "9A9A9A")
            label.textAlignment = .center
            label.numberOfLines=2
            let  screenHeight = self.view.frame.height
            
            if(screenHeight <= 568)
            {
                label.font = UIFont.systemFont(ofSize: 11)
            }
            else{
                label.font = UIFont.systemFont(ofSize: 13)
            }
        }
        else{
            
            label.textColor=UIColor(hex: "FFFFFF")
        }
        
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            // label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 2){
            return 60.0
        }
        else{
            return 30.0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return  arrcompare.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:comparecell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! comparecell
        //print(phoneFilteredContacts)
        
        //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
        let dic = arrcompare[indexPath.row] as AnyObject
       // cell.productTitle.text = dic.value(forKey: "productName") as! String
        //cell.price.text = dic.value(forKey: "displayPrice") as! String
        cell.count?.text = "£\(dic.value(forKey: "productPrice") as! String)"
        if(dic.value(forKey: "MerchantCompareImage") != nil)
        {
            let avatar:String = (dic.value(forKey: "MerchantCompareImage") as? String)!
            if(!avatar.isEmpty)
            {
                /* let MerchantName:String = (dic.value(forKey: "MerchantName") as? String)!
               // self.lazyImage.show(imageView:cell.imageView!, url:avatar, defaultImage: "img_thumb")
                if(MerchantName == "Sports Direct"){
                    cell.imageView?.image = UIImage(named: "sd")
                }
                else{
                   cell.imageView?.image = UIImage(named: "jd")
                }*/
                cell.optionImage?.imageURL = avatar
            }
        }
        else{
            cell.imageView?.image = UIImage(named: "img_thumb")
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath) as! SettingsCell
        
        /*if(indexPath.row == 2) //My Teams
         {
         self.showRedeem()
         }*/
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
         let dic = arrcompare[indexPath.row] as AnyObject
        getproduct(dic.value(forKey: "ProductID") as! Int)
         //UIApplication.shared.openURL(NSURL(string : dic.value(forKey: "productLink") as! String)! as URL)
    }
    func getproduct(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            
                //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading")
         //  TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getproductbyid" as AnyObject
            reqParams["id"] =   lastindex as AnyObject//String(describing:  lastindex)
           reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
            if(myjid != nil){
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                reqParams["username"] = userUserJid as AnyObject?
            }
            else{
                reqParams["username"] = "" as AnyObject
            }
            
            
            // request.httpBody = createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
            request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if String(data: data, encoding: String.Encoding.utf8) != nil {
                        //print(stringData) //JSONSerialization
                        
                        
                        
                        //print(time)
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                            
                            let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                            // print(jsonData)
                            if(isSuccess)
                            {DispatchQueue.main.async {
                                //TransperentLoadingIndicatorView.hide()
                                self.readmore = false
                                self.read.setTitle("More", for: .normal)
                                let arr = jsonData?.value(forKey: "data") as! NSArray
                                self.dic = arr[0] as! NSDictionary
                                self.price.text = self.dic.value(forKey: "displayPrice") as? String
                                self.projectTitle.text = self.dic.value(forKey: "productName") as? String
                                 self.navigationItem.title = self.dic.value(forKey: "productName") as? String
                                self.merchantby.text = self.dic.value(forKey: "MerchantName") as? String
                                if(self.dic.value(forKey: "productImageURL") != nil)
                                {
                                    let avatar:String = (self.dic.value(forKey: "productImageURL") as? String)!
                                    if(!avatar.isEmpty)
                                    {
                                        self.lazyImage.show(imageView:self.imageView!, url:avatar, defaultImage: "img_thumb")
                                        
                                    }
                                }
                                else{
                                    self.imageView?.image = UIImage(named: "img_thumb")
                                }
                                if(self.dic.value(forKey: "productMRP") != nil)
                                {
                                    let avatar:String = (self.dic.value(forKey: "productMRP") as? String)!
                                    if(!avatar.isEmpty && avatar != "£0.00")
                                    {
                                        //self.lazyImage.show(imageView:imageView!, url:avatar, defaultImage: "img_thumb")
                                        self.rrpprice.isHidden = false
                                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (self.dic.value(forKey: "productMRP") as? String)!)
                                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                                        self.rrpprice.attributedText = attributeString
                                        //self.rrpprice.text = self.dic.value(forKey: "productMRP") as? String
                                        //merchatlogo.imageURL = dic.value(forKey: "MerchantImage") as! String
                                    }
                                    else{
                                        self.rrpprice.isHidden = true
                                    }
                                }
                                else{
                                    //merchatlogo?.image = UIImage(named: "img_thumb")
                                    self.rrpprice.isHidden = true
                                }
                                if(self.dic.value(forKey: "MerchantImage") != nil)
                                {
                                    let avatar:String = (self.dic.value(forKey: "MerchantImage") as? String)!
                                    if(!avatar.isEmpty)
                                    {
                                        //self.lazyImage.show(imageView:imageView!, url:avatar, defaultImage: "img_thumb")
                                        self.merchatlogo.imageURL = self.dic.value(forKey: "MerchantImage") as? String
                                    }
                                }
                                else{
                                    self.merchatlogo?.image = UIImage(named: "img_thumb")
                                }
                                self.Description.text = self.dic.value(forKey: "productDescription") as? String
                                self.layoutAdjust()
                                self.mainView?.layer.borderWidth = 0.5
                                self.mainView?.layer.borderColor = UIColor.darkGray.cgColor
                                self.mainView.clipsToBounds = true
                                self.mainView.layer.cornerRadius = self.cornerRadius
                                // let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
                                
                                self.mainView.layer.masksToBounds = true
                                self.mainView.layer.shadowColor = self.shadowColor?.cgColor
                                self.mainView.layer.shadowOffset = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight);
                                self.mainView.layer.shadowOpacity = self.shadowOpacity
                                // mainView.layer.shadowPath = shadowPath.cgPath
                                self.arrcompare = self.dic.value(forKey: "compare") as! NSArray
                                if(self.arrcompare.count>0){
                                    self.CompareTableview.reloadData()
                                    self.CompareTableview.isHidden = false
                                }
                                else{
                                    self.CompareTableview.isHidden = true
                                }
                                }
                                
                            }
                            else
                            { DispatchQueue.main.async
                                {
                                    //TransperentLoadingIndicatorView.hide()
                                    self.alertWithTitle1(title: nil, message: "Something went wrong.Please try again later", ViewController: self)
                                }
                                //Show Error
                            }
                        } catch let error as NSError {
                            print(error)
                            //Show Error
                        }
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            //TransperentLoadingIndicatorView.hide()
                            self.alertWithTitle1(title: nil, message: "Something went wrong.Please try again later", ViewController: self)
                    }
                    
                }
            })
            task.resume()
            
            
            /*var dictRequest = [String: AnyObject]()
             dictRequest["cmd"] = "getnews" as AnyObject
             
             if(lastindex == 0)
             {
             LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you")
             appDelegate().isNewsPageRefresh = true
             } else
             {
             appDelegate().isNewsPageRefresh = false
             }
             do {
             //Creating Request Data
             var dictRequestData = [String: AnyObject]()
             let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
             let arrdUserJid = myjid?.components(separatedBy: "@")
             let userUserJid = arrdUserJid?[0]
             
             let myjidtrim: String? = userUserJid
             dictRequestData["version"] = 1 as AnyObject
             dictRequestData["lastindex"] = lastindex as AnyObject
             dictRequestData["username"] = myjidtrim as AnyObject
             dictRequestData["catid"] = catid as AnyObject
             dictRequest["requestData"] = dictRequestData as AnyObject
             //dictRequest.setValue(dictMobiles, forKey: "requestData")
             //print(dictRequest)
             
             let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
             let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
             //print(strFanUpdates)
             self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
             } catch {
             print(error.localizedDescription)
             }*/
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
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
            MerchantDetailViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MerchantDetailViewController.realDelegate!;
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
}
