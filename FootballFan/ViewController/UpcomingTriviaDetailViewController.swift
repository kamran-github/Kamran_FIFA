//
//  UpcomingTriviaDetailViewController.swift
//  FootballFan
//
//  Created by Apple on 12/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire
class UpcomingTriviaDetailViewController: UIViewController,CLLocationManagerDelegate {
    var upcomingtriviadetail: NSDictionary = [:]
    @IBOutlet weak var triviastatus: UILabel?
    @IBOutlet weak var Titel: UILabel?
    @IBOutlet weak var ticketprize: UILabel?
    @IBOutlet weak var Description: UILabel?
    @IBOutlet weak var ContentImage: UIImageView!
    @IBOutlet weak var PlayImage: UIImageView?
    @IBOutlet weak var viewTrivia: UIView!
    @IBOutlet weak var share: UIView!
    @IBOutlet weak var widthConstraint2: NSLayoutConstraint!
    @IBOutlet weak var Mainview: UIView!
    @IBOutlet weak var likecount: UILabel?
    @IBOutlet weak var viewcount: UILabel?
    var timeEnd : Date?
    var couponTimer : Timer?
    var startTime : NSDate!
    // var currentIndex : Int = 1
    @IBOutlet weak var descriptionConstraint2: NSLayoutConstraint!
     var locationManager: CLLocationManager!
     var currentLocation: CLLocation!
      var returnToOtherView:Bool = false
    @IBOutlet weak var avilableticket: UILabel?
    @IBOutlet weak var ticketprizeView : UIView?
     var infoAlertVC = MessageAlertViewController.instantiate()
     var TermsAlert = FancoinAlertViewController.instantiate()
     var ConfermationAlert = TriviaPurchaseAlert.instantiate()
     var freetriviaAlert = FreeTriviaPurchaseAlert.instantiate()
    @IBOutlet weak var triviastart: UILabel?
     @IBOutlet weak var triviastartview: UIView?
    @IBOutlet weak var triviastartwidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  let notificationName6 = Notification.Name("_GetPermissionsForupcomingdetail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetPermissionsForLocation), name: notificationName6, object: nil)*/
        let notificatonUpcommingPurchse = Notification.Name("detailtriviapurchse")
                        // Register to receive notification
                        NotificationCenter.default.addObserver(self, selector: #selector(self.Buynow), name: notificatonUpcommingPurchse, object: nil)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         updateview()
    }
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        couponTimer?.invalidate()
    }
   func updateview(){
    let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OpenTriviaAction(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    longPressGesture.delegate = self as? UIGestureRecognizerDelegate
    
    
    
    let longPressGesture_share:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareClick(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    longPressGesture_share.delegate = self as? UIGestureRecognizerDelegate
    
    
    share?.addGestureRecognizer(longPressGesture_share)
    share?.isUserInteractionEnabled = true
    
    
    
    /*  let PressGesture_sound:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(soundClick(_:)))
     //longPressGesture.minimumPressDuration = 1.0 // 1 second press
     PressGesture_sound.delegate = self as? UIGestureRecognizerDelegate
     cell.soundImg?.addGestureRecognizer(PressGesture_sound)
     cell.soundImg?.isUserInteractionEnabled = true*/
    
    // let longPressGesture_showpreview:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    //longPressGesture_showpreview.delegate = self as? UIGestureRecognizerDelegate
    
    //let longPressGesture_showpreview1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowPreviewClick(_:)))
    //longPressGesture.minimumPressDuration = 1.0 // 1 second press
    //longPressGesture_showpreview1.delegate = self as? UIGestureRecognizerDelegate
    
    //cell.PlayImage?.addGestureRecognizer(longPressGesture_showpreview)
    //cell.PlayImage?.isUserInteractionEnabled = true
    
    
    //cell.ContentImage?.addGestureRecognizer(longPressGesture_showpreview1)
    //cell.ContentImage?.isUserInteractionEnabled = true
    
    
    
    
    
    // Configure the cell...
    
    if(upcomingtriviadetail != nil)
    {
        
        var thumbLink: String = ""
        if let thumb = upcomingtriviadetail.value(forKey: "TriviaImage")
        {
            thumbLink = thumb as! String
        }
        //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
        ContentImage.imageURL = thumbLink
        
        //cell.soundImg?.isHidden = true
        ContentImage?.isHidden = false
        var caption: String = ""
        if let capText = upcomingtriviadetail.value(forKey: "Description")
        {
            caption = capText as! String
        }
        Description?.text = caption
      /*  let label1 = UILabel(frame: CGRect(x: 0.0, y: 0, width: (Description?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
        label1.font = UIFont.systemFont(ofSize: 10.0)
        label1.text = Description?.text
        label1.textAlignment = .left
        //label.textColor = self.strokeColor
        label1.lineBreakMode = .byWordWrapping
        label1.numberOfLines = 2
        label1.sizeToFit()
        
        
        if((label1.frame.height) > 13)
        {
           // descriptionConstraint2.constant = label1.frame.height
            //let height = (label.frame.height) + 410.0
            //print("Height \((label.frame.height)).")
            //storyTableView?.rowHeight = CGFloat(height)
        }
        else
        {
            //descriptionConstraint2.constant = label1.frame.height
            //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
            //print("Height \((label.frame.height)).")
            // storyTableView?.rowHeight = CGFloat(height)
        }*/
        Titel?.text = upcomingtriviadetail.value(forKey: "Title") as? String
        
        //cell.ContentImage?.contentMode = .scaleAspectFill
        //cell.ContentImage?.clipsToBounds = true
        
        //cell.configureCell(imageUrl: thumbLink, description: "Image", videoUrl: nil, layertag: String(indexPath.row))
        let status = upcomingtriviadetail.value(forKey: "Status") as! String
        let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
        if(myjid != nil){
            
            if(status == "Finished"){
                triviastartview?.isHidden = true

                triviastatus?.text = "RECORDING AWAITED"
                triviastatus?.removeGestureRecognizer(longPressGesture)
            }
            else if(status == "Live"){
                triviastartview?.isHidden = true

                let Purchased = upcomingtriviadetail.value(forKey: "Purchased") as! Bool
                if(Purchased){
                    triviastatus?.text = "PLAY NOW"
                }else{
                    triviastatus?.text = "VIEW NOW"
                }
                
               
                triviastatus?.addGestureRecognizer(longPressGesture)
                triviastatus?.isUserInteractionEnabled = true
            }
                
            else if(status == "Published"){
                triviastartview?.isHidden = false

                let Purchased = upcomingtriviadetail.value(forKey: "Purchased") as! Bool
                if(Purchased){
                    //triviastatus?.text = "WAIT TO START"
                    triviastatus?.removeGestureRecognizer(longPressGesture)
                }
                else{
                    let FreeTrivia = upcomingtriviadetail.value(forKey: "FreeTrivia") as! Bool
                    let soldout = upcomingtriviadetail.value(forKey: "soldout") as! Bool
                    if(soldout){
                        triviastatus?.text = "SOLD OUT"
                    }
                    else{
                    if(FreeTrivia){
                        triviastatus?.text = "ENTER NOW"
                        triviastatus?.addGestureRecognizer(longPressGesture)
                        triviastatus?.isUserInteractionEnabled = true
                    }
                    else{
                        let ticketprize = upcomingtriviadetail.value(forKey: "TicketPrice") as! Double
                        let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                        if(avilablecoin > ticketprize){
                            triviastatus?.text = "ENTER NOW"
                        }
                        else{
                            triviastatus?.text = "ENTER NOW"
                        }
                        triviastatus?.addGestureRecognizer(longPressGesture)
                        triviastatus?.isUserInteractionEnabled = true
                    }
                    }
                }
                
            }
        }else{
            //let status = upcomingtriviadetail.value(forKey: "Status") as! String
            if(status == "Live"){
                triviastartview?.isHidden = true

                triviastatus?.text = "VIEW NOW"
            }
                else if(status == "Finished"){
                 triviastatus?.text = "RECORDING AWAITED"
            }
            else{
                triviastatus?.text = "ENTER NOW"
            }
            triviastatus?.addGestureRecognizer(longPressGesture)
            triviastatus?.isUserInteractionEnabled = true
        }
       if(myjid != nil){
        if(status == "Published"){
           
            let Purchased = upcomingtriviadetail.value(forKey: "Purchased") as! Bool
            if(Purchased){
                ticketprizeView?.isHidden = true
                avilableticket?.isHidden = true
            }
            else{
                ticketprizeView?.isHidden = false
                avilableticket?.isHidden = false
                let FreeTrivia = upcomingtriviadetail.value(forKey: "FreeTrivia") as! Bool
                let soldout = upcomingtriviadetail.value(forKey: "soldout") as! Bool
                if(soldout){
                  
                    ticketprizeView?.isHidden = true
                    avilableticket?.isHidden = false
                    avilableticket?.text = upcomingtriviadetail.value(forKey: "AvailableTickets") as! String
                }
                else{
                    if(FreeTrivia){
                        ticketprize?.text = "FREE TO PLAY"
                        avilableticket?.text = upcomingtriviadetail.value(forKey: "AvailableTickets") as? String
                    }
                    else{
                        let ticketprice = upcomingtriviadetail.value(forKey: "TicketPrice") as! Double
                        let avilablecoin = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                        if(avilablecoin > ticketprice){
                            ticketprize?.text = "\(self.appDelegate().formatNumber(Int(ticketprice))) FanCoins TO PLAY"
                            avilableticket?.text = upcomingtriviadetail.value(forKey: "AvailableTickets") as! String
                        }
                        else{
                            ticketprize?.text = "\(self.appDelegate().formatNumber(Int(ticketprice))) FanCoins TO PLAY"
                            avilableticket?.text = upcomingtriviadetail.value(forKey: "AvailableTickets") as! String
                        }
                    }
                }
            }
            
        }
        else{
            ticketprizeView?.isHidden = true
           avilableticket?.isHidden = true
        }
       }
        else{
            ticketprizeView?.isHidden = true
                      avilableticket?.isHidden = true
        }
         if(status == "Published"){
        if let mili1 = upcomingtriviadetail.value(forKey: "StartTime")
        {
            
            let number: Int64? = Int64(mili1 as! String)
            let mili: Double = Double(truncating: number! as NSNumber)
            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
            setupTimer(with: mili)
            let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "dd MMM yy HH:mm"
             dateFormatter.timeZone = TimeZone(abbreviation: "BST")
                           triviastart?.text = "STARTS @ \(dateFormatter.string(from:myMilliseconds.dateFull)) UK TIME"
        }
        }
        
       // let screenSize = UIScreen.main.bounds
      /*  let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (Titel?.frame.width)!, height: CGFloat.greatestFiniteMagnitude))
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.text = Titel?.text
        label.textAlignment = .left
        //label.textColor = self.strokeColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.sizeToFit()
        
        
        if((label.frame.height) > 12)
        {
            widthConstraint2.constant = label.frame.height
            //let height = (label.frame.height) + 410.0
            //print("Height \((label.frame.height)).")
            //storyTableView?.rowHeight = CGFloat(height)
        }
        else
        {
            widthConstraint2.constant = label.frame.height
            //let height = 410.0 //(cell.ContentText?.frame.height)! + 410.0
            //print("Height \((label.frame.height)).")
            // storyTableView?.rowHeight = CGFloat(height)
        }*/
        
        
       /*
        let lbleltime = UILabel(frame: CGRect(x: 0.0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: (triviastart?.frame.height)!))
                     lbleltime.font = UIFont.boldSystemFont(ofSize: 11.0)
                     lbleltime.text = triviastart?.text
                     lbleltime.textAlignment = .left
                     //label.textColor = self.strokeColor
                     lbleltime.lineBreakMode = .byWordWrapping
                     lbleltime.numberOfLines = 1
                     lbleltime.sizeToFit()
                     
              triviastartwidth.constant = lbleltime.frame.width + 15
              */
        
    }
    
    }
    func setupTimer(`with` mili: Double){
        // currentIndex = indexPath + 1
        
        self.startTime = NSDate()
        
        if self.couponTimer != nil {
            self.couponTimer?.invalidate()
            self.couponTimer = nil
        }
        //let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
        //dateFormatter.dateStyle = .short
        timeEnd = myMilliseconds.dateFull as Date
        //let birthday: Date = myMilliseconds.dateFull as Date
        //timeEnd = Date(timeInterval: "2019-12-01 10:00:00".toDate(format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince(Date()), since: Date())
        //timeEnd =
        couponTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true);
        
        RunLoop.current.add(couponTimer!, forMode: RunLoop.Mode.common)
        couponTimer?.fire()
    }
    func stopTimer(){
        if self.couponTimer != nil {
            self.couponTimer?.invalidate()
            self.couponTimer = nil
        }
    }
    @objc func setTimeLeft() {
        let timeNow = Date()
        
        
        if timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
            
            let interval = timeEnd?.timeIntervalSince(timeNow)
            
            let days =  (interval! / (60*60*24)).rounded(.down)
            
            let daysRemainder = interval?.truncatingRemainder(dividingBy: 60*60*24)
            
            let hours = (daysRemainder! / (60 * 60)).rounded(.down)
            
            let hoursRemainder = daysRemainder?.truncatingRemainder(dividingBy: 60 * 60).rounded(.down)
            
            let minites  = (hoursRemainder! / 60).rounded(.down)
            
            let minitesRemainder = hoursRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            
            let scondes = minitesRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            // print(days)
            // print(hours)
            // print(minites)
            //print(scondes)
            // header?.DaysProgress.setProgress(days/360, animated: false)
            // header?.hoursProgress.setProgress(hours/24, animated: false)
            //header?.minitesProgress.setProgress(minites/60, animated: false)
            // header?.secondesProgress.setProgress(scondes!/60, animated: false)
            let Purchased = upcomingtriviadetail.value(forKey: "Purchased") as! Bool
             let soldout = upcomingtriviadetail.value(forKey: "soldout") as! Bool
            if(Purchased){
                 if(days == 0){
                    let remtime = String(format: "%02d:%02d:%02d", Int(hours as Double), Int(minites as Double), Int(scondes!))
                                           triviastatus?.text = "STARTS IN \(remtime)"
                     //triviastatus?.text = "STARTS IN \(Int(hours)):\(Int(minites)):\(Int(scondes as! Double))" //"\(Int(hours)) HOURS \(Int(minites)) MIN. \(Int(scondes as! Double)) SEC. TO PLAY"
                            }
                            else{
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "dd MMM"
                     triviastatus?.text = "STARTS \(dateFormatter.string(from: timeEnd!)) \(Int(hours)):\(Int(minites))"
                            }
             }
            else if(soldout){
                if(days == 0){
                    let remtime = String(format: "%02d:%02d:%02d", Int(hours as Double), Int(minites as Double), Int(scondes!))
                                           triviastatus?.text = "STARTS IN \(remtime)"
                                   // triviastatus?.text = "STARTS IN \(Int(hours)):\(Int(minites)):\(Int(scondes as! Double))" //"\(Int(hours)) HOURS \(Int(minites)) MIN. \(Int(scondes as! Double)) SEC. TO PLAY"
                                           }
                                           else{
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd MMM"
                                    triviastatus?.text = "STARTS \(dateFormatter.string(from: timeEnd!)) \(Int(hours)):\(Int(minites))"
                                           }
            }
                        // header?.valueDay.text = formatter.string(from: NSNumber(value:days))
            // header?.valueHour.text = formatter.string(from: NSNumber(value:hours))
            // header?.valueMinites.text = formatter.string(from: NSNumber(value:minites))
            //header?.valueSeconds.text = formatter.string(from: NSNumber(value:scondes!))
            
             if(days == 0.0 && hours == 0.0 && minites == 0.0 && scondes == 0.0){
                var dict1: [String: AnyObject] = upcomingtriviadetail as! [String : AnyObject]
                dict1["Status"] = "Live" as AnyObject
                
                upcomingtriviadetail = (dict1 as AnyObject) as! NSDictionary
                updateview()
                stopTimer()
            }
            
        } else {
            // header?.fadeOut()
           // timervalue?.text = "LIVE NOW"
            var dict1: [String: AnyObject] = upcomingtriviadetail as! [String : AnyObject]
            dict1["Status"] = "Live" as AnyObject
            
            upcomingtriviadetail = (dict1 as AnyObject) as! NSDictionary
            updateview()
            stopTimer()
        }
    }
    @objc func OpenTriviaAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Click")
       
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            if(login != nil){
                if ClassReachability.isConnectedToNetwork() {
                    
                    let status = self.upcomingtriviadetail.value(forKey: "Status") as! String
                    if(status == "Finished"){
                        
                    }
                    else if(status == "Live"){
                        let mili1 = self.upcomingtriviadetail.value(forKey: "EndTime")
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        let timeNow = Date()
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        self.timeEnd  = myMilliseconds.dateFull as Date
                        if self.timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
                            
                        self.appDelegate().toUserJID = self.upcomingtriviadetail.value(forKey: "GroupID") as! String
                        self.appDelegate().toName = self.upcomingtriviadetail.value(forKey: "Title") as! String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                        myTeamsController.triviadetail = self.upcomingtriviadetail
                       
                        self.show(myTeamsController, sender: self)
                        }
                        else{
                            self.gettriviabyid()
                            self.infoAlertVC = MessageAlertViewController.instantiate()
                            guard let customAlertVC = self.infoAlertVC else { return }
                            
                            customAlertVC.titleString = "Sorry!"
                         
                            customAlertVC.mediaurl = "thumb_down"
                            customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                            //   customAlertVC.mediatype = mediatype
                            //  customAlertVC.mediaurl = mediaurl
                            customAlertVC.ActionTitle = "Ok"
                            // customAlertVC.actioncommand = action
                            //customAlertVC.actionlink = link
                            //customAlertVC.LinkTitle = linktitle
                            
                            let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                            // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                            popupVC.cornerRadius = 20
                            self.present(popupVC, animated: true, completion: nil)
                        }
                    }
                    if(status == "Finished"){
                        
                    }
                    else if(status == "Published"){
                        let Purchased = self.upcomingtriviadetail.value(forKey: "Purchased") as! Bool
                        if(Purchased){
                            //cell.triviastatus?.text = "Already Booked"
                        }
                        else{
                            let FreeTrivia = self.upcomingtriviadetail.value(forKey: "FreeTrivia") as! Bool
                            if(FreeTrivia){
                                //self.Buynow()
                                self.freetriviaAlert = FreeTriviaPurchaseAlert.instantiate()
                                                                         guard let customAlertVC = self.freetriviaAlert else { return }
                                                                         
                                                          
                                                                                      // customAlertVC.upcomingtriviadetail = dict!
                                                               customAlertVC.onpageview = "upcommingdetail"
                                                               //customAlertVC.triviaTypeString = "FreeTrivia"
                                                                                                    let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 450)
                                                                                                    // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                                    popupVC.cornerRadius = 20
                                                                                                    self.present(popupVC, animated: true, completion: nil)
                            }
                            else{
                                let ticketprize = self.upcomingtriviadetail.value(forKey: "TicketPrice") as! Double
                                let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                if(avilablecoin > ticketprize){
                                    //self.Buynow()
                                    self.ConfermationAlert = TriviaPurchaseAlert.instantiate()
                                                                         guard let customAlertVC = self.ConfermationAlert else { return }
                                                                         
                                                           // customAlertVC.upcomingtriviadetail = dict!
                                     customAlertVC.triviaprice = ticketprize
                                    customAlertVC.onpageview = "upcommingdetail"
                                   // customAlertVC.triviaTypeString = "Trivia"
                                                                         let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 467)
                                                                         // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                         popupVC.cornerRadius = 20
                                                                         self.present(popupVC, animated: true, completion: nil)
                                }else{
                                    self.returnToOtherView = true
                                    self.TermsAlert = FancoinAlertViewController.instantiate()
                                                                                                            guard let customAlertVC = self.TermsAlert else { return }
                                                                                                            
                                                                                                            //customAlertVC.upcomingtriviadetail = dict!
                                                                                                             customAlertVC.onpageview = "upcomming"
                                                                                                                                               customAlertVC.triviaTypeString = "buyfc"
                                                                                                            let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 417)
                                                                                                            // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                                            popupVC.cornerRadius = 20
                                                                                                            self.present(popupVC, animated: true, completion: nil)
                                                                        
                                  /*  let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                    self.returnToOtherView = true
                                    self.show(registerController, sender: self)*/
                                    
                                    //InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
                                }
                            }
                            
                        }
                        
                    }
                } else {
                    alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                    
                }
            }else{
                
                let status = upcomingtriviadetail.value(forKey: "Status") as! String
                if(status == "Live"){
                    if ClassReachability.isConnectedToNetwork() {
                        let mili1 = self.upcomingtriviadetail.value(forKey: "EndTime")
                        let number: Int64? = Int64(mili1 as! String)
                        let mili: Double = Double(truncating: number! as NSNumber)
                        let timeNow = Date()
                        let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                        self.timeEnd  = myMilliseconds.dateFull as Date
                        if self.timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
                            
                        self.appDelegate().toUserJID = self.upcomingtriviadetail.value(forKey: "GroupID") as! String
                        self.appDelegate().toName = self.upcomingtriviadetail.value(forKey: "Title") as! String
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                        myTeamsController.triviadetail = self.upcomingtriviadetail
                        self.returnToOtherView = true
                        self.show(myTeamsController, sender: self)
                        }
                        else{
                            self.gettriviabyid()
                            self.infoAlertVC = MessageAlertViewController.instantiate()
                            guard let customAlertVC = self.infoAlertVC else { return }
                            
                             customAlertVC.titleString = "Sorry!"
                            customAlertVC.mediaurl = "thumb_down"
                            customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                            //   customAlertVC.mediatype = mediatype
                            //  customAlertVC.mediaurl = mediaurl
                            customAlertVC.ActionTitle = "Ok"
                            // customAlertVC.actioncommand = action
                            //customAlertVC.actionlink = link
                            //customAlertVC.LinkTitle = linktitle
                            
                            let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                            // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                            popupVC.cornerRadius = 20
                            self.present(popupVC, animated: true, completion: nil)
                        }
                    } else {
                        alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                        
                    }
                    
                    
                }
                else {
                    appDelegate().LoginwithModelPopUp()
                }
            }
        
        
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    @objc func ShareClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
           //print("Share Click")
           
           
           do {
               let fanupdateid = upcomingtriviadetail.value(forKey: "ID") as! Int64
               var dictRequest = [String: AnyObject]()
               dictRequest["id"] = fanupdateid as AnyObject
               dictRequest["type"] = "trivia" as AnyObject
               let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
               
               let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
               
               let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
               
               let title = upcomingtriviadetail.value(forKey: "Title") as! String
               
               let param = resultNSString as String?
               
               let inviteurl = InviteHost + "?q=" + param!
               var text = title + "/n/nPlay live Football Trivia and win prizes with me on Football Fan App\n\n"
                              //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
                             let recReadUserJid: String? = UserDefaults.standard.string(forKey: "userJID")
                              if(recReadUserJid != nil){
                                  let arrReadUserJid = recReadUserJid?.components(separatedBy: "@")
                                  let userReadUserJid = arrReadUserJid?[0]
                                  text = text + "Use my code \"\(userReadUserJid!)\" to Sign Up!/n/n"
                              }
                                         //let recReadTime: String = (jsonDataMessage?.value(forKey: "time") as? String)!
                                         
               //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
               
               let myWebsite = NSURL(string: inviteurl)
               let shareAll = [text, myWebsite as Any] as [Any]
               
               let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view
               self.present(activityViewController, animated: true, completion: nil)
               
               
               
           } catch {
               print(error.localizedDescription)
           }
           
           
           
           
       }
 /*   @objc func GetPermissionsForLocation(notification: NSNotification)
    {
        
        LoadingIndicatorView.show(self.view, loadingText: "Retrieving your current location")
        
        locationManager = CLLocationManager()
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
   
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
        else if status == .authorizedAlways {
            //print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //currentLocation = locations.last
        // aTextField?.endEditing(true)
        if currentLocation == nil {
            currentLocation = locations.last
            manager.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            // print("locations = \(locationValue)")
            
            manager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil)
                {
                    //print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks!.count > 0)
                {
                    let containsPlacemark = placemarks![0] as CLPlacemark
                    
                    //stop updating location to save battery life
                    //print(containsPlacemark.isoCountryCode)
                    let isoCountryCode: String = (containsPlacemark.isoCountryCode != nil) ? containsPlacemark.isoCountryCode! : ""
                  
                    let AvailableCountries: String = self.upcomingtriviadetail.value(forKey: "AvailableCountries") as! String
                    LoadingIndicatorView.hide()
                    if(AvailableCountries.contains(isoCountryCode)){
                        let login: String? = UserDefaults.standard.string(forKey: "userJID")
                        if(login != nil){
                            
                            let status = self.upcomingtriviadetail.value(forKey: "Status") as! String
                            if(status == "Finished"){
                                
                            }
                            else if(status == "Live"){
                                let mili1 = self.upcomingtriviadetail.value(forKey: "EndTime")
                                let number: Int64? = Int64(mili1 as! String)
                                let mili: Double = Double(truncating: number! as NSNumber)
                                let timeNow = Date()
                                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                self.timeEnd  = myMilliseconds.dateFull as Date
                                if self.timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
                                    
                                self.appDelegate().toUserJID = self.upcomingtriviadetail.value(forKey: "GroupID") as! String
                                self.appDelegate().toName = self.upcomingtriviadetail.value(forKey: "Title") as! String
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                                myTeamsController.triviadetail = self.upcomingtriviadetail
                               
                                self.show(myTeamsController, sender: self)
                                }
                                else{
                                    self.gettriviabyid()
                                    self.infoAlertVC = MessageAlertViewController.instantiate()
                                    guard let customAlertVC = self.infoAlertVC else { return }
                                    
                                    customAlertVC.titleString = "contactsync"
                                    customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                                    //   customAlertVC.mediatype = mediatype
                                    //  customAlertVC.mediaurl = mediaurl
                                    customAlertVC.ActionTitle = "Ok"
                                    // customAlertVC.actioncommand = action
                                    //customAlertVC.actionlink = link
                                    //customAlertVC.LinkTitle = linktitle
                                    
                                    let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 265)
                                    // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                    popupVC.cornerRadius = 20
                                    self.present(popupVC, animated: true, completion: nil)
                                }
                            }
                            if(status == "Finished"){
                                
                            }
                            else if(status == "Published"){
                                let Purchased = self.upcomingtriviadetail.value(forKey: "Purchased") as! Bool
                                if(Purchased){
                                    //cell.triviastatus?.text = "Already Booked"
                                }
                                else{
                                    let FreeTrivia = self.upcomingtriviadetail.value(forKey: "FreeTrivia") as! Bool
                                    if(FreeTrivia){
                                        self.Buynow()
                                    }
                                    else{
                                        let ticketprize = self.upcomingtriviadetail.value(forKey: "TicketPrice") as! Double
                                        let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                                        if(avilablecoin > ticketprize){
                                            self.Buynow()
                                        }else{
                                            
                                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                            let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
                                            self.returnToOtherView = true
                                            self.show(registerController, sender: self)
                                            
                                            //InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                        else{
                            let mili1 = self.upcomingtriviadetail.value(forKey: "EndTime")
                            let number: Int64? = Int64(mili1 as! String)
                            let mili: Double = Double(truncating: number! as NSNumber)
                            let timeNow = Date()
                            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                            self.timeEnd  = myMilliseconds.dateFull as Date
                            if self.timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
                                
                            self.appDelegate().toUserJID = self.upcomingtriviadetail.value(forKey: "GroupID") as! String
                            self.appDelegate().toName = self.upcomingtriviadetail.value(forKey: "Title") as! String
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let myTeamsController : TriviaViewController = storyBoard.instantiateViewController(withIdentifier: "TriviaVC") as! TriviaViewController
                            myTeamsController.triviadetail = self.upcomingtriviadetail
                            self.returnToOtherView = true
                            self.show(myTeamsController, sender: self)
                            }
                            else{
                                self.gettriviabyid()
                                self.infoAlertVC = MessageAlertViewController.instantiate()
                                guard let customAlertVC = self.infoAlertVC else { return }
                                
                                customAlertVC.titleString = "contactsync"
                                customAlertVC.messageString = "This Trivia is now finished. You can view recording in a short while."
                                //   customAlertVC.mediatype = mediatype
                                //  customAlertVC.mediaurl = mediaurl
                                customAlertVC.ActionTitle = "Ok"
                                // customAlertVC.actioncommand = action
                                //customAlertVC.actionlink = link
                                //customAlertVC.LinkTitle = linktitle
                                
                                let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 265)
                                // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                popupVC.cornerRadius = 20
                                self.present(popupVC, animated: true, completion: nil)
                            }
                        }
                    }
                    else{
                        self.infoAlertVC = MessageAlertViewController.instantiate()
                        guard let customAlertVC = self.infoAlertVC else { return }
                        
                        customAlertVC.titleString = "contactsync"
                        customAlertVC.messageString = "This Trivia is only available in United Kingdom."
                        //   customAlertVC.mediatype = mediatype
                        //  customAlertVC.mediaurl = mediaurl
                        customAlertVC.ActionTitle = "Ok"
                        // customAlertVC.actioncommand = action
                        //customAlertVC.actionlink = link
                        //customAlertVC.LinkTitle = linktitle
                        
                        let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 265)
                        // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                        popupVC.cornerRadius = 20
                        self.present(popupVC, animated: true, completion: nil)
                    }
                    // let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
                    // let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
                    //let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
                    //let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
                    
                }
                else
                {
                    //print("Problem with the data received from geocoder")
                }
            })
            //Call API to save current location
            
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        displayCantAddContactAlert()
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot get location",
                                                    message: "You must give the app permission to get your current location.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        LoadingIndicatorView.hide()
                                                        self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            LoadingIndicatorView.hide()
            
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    func openSettings() {
        /*if(refreshTable.isRefreshing)
         {
         refreshTable.endRefreshing()
         }
         else
         {
         if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }
         
         }
         isLoadingContacts = false
         storyTableView?.isScrollEnabled = true*/
        
        let url = NSURL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(url! as URL)
    }*/
    @objc func Buynow()  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "buyticket" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
               
                let roomjid = upcomingtriviadetail.value(forKey: "GroupID") as! String
                 let Title = upcomingtriviadetail.value(forKey: "Title") as! String
                reqParams["redeemcoins"] = upcomingtriviadetail.value(forKey: "TicketPrice") as AnyObject
                let arrdRoomJid = roomjid.components(separatedBy: "@")
                let roomid = arrdRoomJid[0]
                reqParams["roomid"] = roomid as AnyObject
                let FreeTrivia = upcomingtriviadetail.value(forKey: "FreeTrivia") as! Bool
                if(FreeTrivia){
                    reqParams["termsaccepted"] = "Good News!\nYou can play this Trivia for free\nYou confirm that you are 18+ years old, have a UK mailing address to receive prize, and agree to our\nTrivia Terms and Conditions" as AnyObject
                }
                else{
                    let avilablecoin = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Double
                    reqParams["termsaccepted"] = "Good News!\nRedeem \(upcomingtriviadetail.value(forKey: "TicketPrice") as! Double) from \(avilablecoin) FanCoins\nto play\nYou confirm that you are 18+ years old, have a UK mailing address to receive prize, and agree to our\nTrivia Terms and Conditions" as AnyObject
                }
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                if(myjid != nil){
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    reqParams["username"] = userUserJid as AnyObject?
                }
                else{
                    reqParams["username"] = "" as AnyObject
                }
                
                dictRequest["requestData"] = reqParams as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
               /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                var reqParams1 = [String: AnyObject]()
                reqParams1["request"] = strFanUpdates as AnyObject
                let url = MediaAPIjava + "request=" + escapedString!*/
                //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
                AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                  headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                    // 2
                    .responseJSON { response in
                        switch response.result {
                                                                  case .success(let value):
                                                                      if let json = value as? [String: Any] {
                                                                          // print(" JSON:", json)
                                                                          let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                          // self.finishSyncContacts()
                                                                          //print(" status:", status1)
                                                                          if(status1){DispatchQueue.main.async {
                                                                              TransperentLoadingIndicatorView.hide()
                                                                              let response: NSArray = json["responseData"]  as! NSArray
                                                                              let myProfileDict: NSDictionary = response[0] as! NSDictionary
                                                                              let totalcoins = myProfileDict.value(forKey: "totalcoins") as! Int
                                                                              
                                                                              let availablecoins = myProfileDict.value(forKey: "availablecoins") as! Int
                                                                              //print(response)
                                                                              self.appDelegate().AddCoin(fctotalcoin: totalcoins, fcavailablecoin: availablecoins)
                                                                              var dict1: [String: AnyObject] = self.upcomingtriviadetail as! [String : AnyObject]
                                                                              dict1["Purchased"] = true as AnyObject
                                                                              
                                                                              self.upcomingtriviadetail = (dict1 as AnyObject) as! NSDictionary
                                                                              self.updateview()
                                                                              self.infoAlertVC = MessageAlertViewController.instantiate()
                                                                              guard let customAlertVC = self.infoAlertVC else { return }
                                                                              
                                                                              customAlertVC.titleString = "Congratulations!"
                                                                              if let mili1 = self.upcomingtriviadetail.value(forKey: "StartTime")
                                                                                                                          {
                                                                                                                              
                                                                                                                              let number: Int64? = Int64(mili1 as! String)
                                                                                                                              let mili: Double = Double(truncating: number! as NSNumber)
                                                                                                                              let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                                                                                                              
                                                                                                                              let dateFormatter = DateFormatter()
                                                                                                                              dateFormatter.dateFormat = "dd MMM yy HH:mm"
                                                                                                                               dateFormatter.timeZone = TimeZone(abbreviation: "BST")
                                                                                                                             
                                                                                                                             customAlertVC.messageString = "Your entry to \(Title) starting at \(dateFormatter.string(from:myMilliseconds.dateFull)) is secured"
                                                                                                                          }
                                                                              //customAlertVC.messageString = "Trivia entry secured"
                                                                              //   customAlertVC.mediatype = mediatype
                                                                                customAlertVC.mediaurl = "thumbs_up"
                                                                              customAlertVC.ActionTitle = "Ok"
                                                                              // customAlertVC.actioncommand = action
                                                                              //customAlertVC.actionlink = link
                                                                              //customAlertVC.LinkTitle = linktitle
                                                                              
                                                                              let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                                                                              // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                              popupVC.cornerRadius = 20
                                                                              self.present(popupVC, animated: true, completion: nil)
                                                                              //self.gettriviabyid()
                                                                              if(self.appDelegate().arrupcommingTrivia.count>0){
                                                                                                                                                        for i in 0...self.appDelegate().arrupcommingTrivia.count-1 {
                                                                                                                                                            let dict: NSDictionary? = self.appDelegate().arrupcommingTrivia[i] as? NSDictionary
                                                                                                                                                                   if(dict != nil)
                                                                                                                                                                   {
                                                                                                                                                                    let GroupID = dict?.value(forKey: "GroupID") as! String
                                                                                                                                                                    if(roomjid == GroupID){
                                                                                                                                                                        var dict1: [String: AnyObject] = self.appDelegate().arrupcommingTrivia[i] as! [String: AnyObject]
                                                                                                                                                                                   dict1["Purchased"] = true as AnyObject
                                                                                                                                                                                   
                                                                                                                                                                        self.appDelegate().arrupcommingTrivia[i] = dict1 as AnyObject
                                                                                                                                               let notificationName = Notification.Name("reloadtable")
                                                                                                                                                                                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                                                     
                                                                                                                                                                        
                                                                                                                                                                        break
                                                                                                                                                                                   
                                                                                                                                                                    }
                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                    }
                                                                              if(self.appDelegate().arrhometrivia.count>0){
                                                                                                                     for i in 0...self.appDelegate().arrhometrivia.count-1 {
                                                                                                                         let dict: NSDictionary? = self.appDelegate().arrhometrivia[i] as? NSDictionary
                                                                                                                                if(dict != nil)
                                                                                                                                {
                                                                                                                                 let GroupID = dict?.value(forKey: "GroupID") as! String
                                                                                                                                 if(roomjid == GroupID){
                                                                                                                                     var dict1: [String: AnyObject] = self.appDelegate().arrhometrivia[i] as! [String: AnyObject]
                                                                                                                                                dict1["Purchased"] = true as AnyObject
                                                                                                                                                
                                                                                                                                     self.appDelegate().arrhometrivia[i] = dict1 as AnyObject
                                                                                                                                     let notificationName = Notification.Name("resetslider")
                                                                                                                                                                                                                                           NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                                                     
                                                                                                                                     break
                                                                                                                                                
                                                                                                                                 }
                                                                                                                         }
                                                                                                                     }
                                                                                                                 }
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                      
                                                                                     
                                                                                      let soldout = json["soldout"] as! Bool
                                                                                      let error = json["error"]  as! String
                                                                                      if(soldout){
                                                                                          
                                                                                          var dict1: [String: AnyObject] = self.upcomingtriviadetail as! [String : AnyObject]
                                                                                          dict1["soldout"] = true as AnyObject
                                                                                          
                                                                                          self.upcomingtriviadetail = (dict1 as AnyObject) as! NSDictionary
                                                                                          self.updateview()
                                                                                      }
                                                                                      self.infoAlertVC = MessageAlertViewController.instantiate()
                                                                                      guard let customAlertVC = self.infoAlertVC else { return }
                                                                                      
                                                                                      customAlertVC.titleString = "Sorry!"
                                                                                      customAlertVC.messageString = error
                                                                                      //   customAlertVC.mediatype = mediatype
                                                                                        customAlertVC.mediaurl = "thumb_down"
                                                                                      customAlertVC.ActionTitle = "Ok"
                                                                                      // customAlertVC.actioncommand = action
                                                                                      //customAlertVC.actionlink = link
                                                                                      //customAlertVC.LinkTitle = linktitle
                                                                                      
                                                                                      let popupVC = PopupViewController(contentController: customAlertVC, position: .center(CGPoint(x: 0, y: 0)), popupWidth: 310, popupHeight: 410)
                                                                                      // let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 300, popuphi)
                                                                                      popupVC.cornerRadius = 20
                                                                                      self.present(popupVC, animated: true, completion: nil)
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                       
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func gettriviabyid(){
    
        TransperentLoadingIndicatorView.show(self.view, loadingText: "")
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "gettriviabyid" as AnyObject
        dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
        dictRequest["device"] = "ios" as AnyObject
        
        
        do {
            
            /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
             let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
             print(strInvited)*/
            //let login: String? = UserDefaults.standard.string(forKey: "userJID")
            //let arrReadUserJid = login?.components(separatedBy: "@")
            //let userReadUserJid = arrReadUserJid?[0]
            
            
            var reqParams = [String: AnyObject]()
            let id: AnyObject = upcomingtriviadetail.value(forKey: "ID") as AnyObject
            reqParams["id"] = id
            
            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
            if(myjid != nil){
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                reqParams["username"] = userUserJid as AnyObject?
            }
            else{
                reqParams["username"] = "" as AnyObject
            }
            
            dictRequest["requestData"] = reqParams as AnyObject
            //dictRequest.setValue(dictMobiles, forKey: "requestData")
            //print(dictRequest)
           /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
            let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            //  print(escapedString!)
            // print(strFanUpdates)
            var reqParams1 = [String: AnyObject]()
            reqParams1["request"] = strFanUpdates as AnyObject
            let url = MediaAPIjava + "request=" + escapedString!*/
            //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
            AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                              headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                // 2
                .responseJSON { response in
                    switch response.result {
                                                              case .success(let value):
                                                                  if let json = value as? [String: Any] {
                                                                      // print(" JSON:", json)
                                                                      let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                      // self.finishSyncContacts()
                                                                      //print(" status:", status1)
                                                                      if(status1){DispatchQueue.main.async {
                                                                          
                                                                          let arr = json["responseData"] as! NSArray
                                                                          self.upcomingtriviadetail = arr[0] as! NSDictionary
                                                                          print(response)
                                                                          self.updateview()
                                                                          TransperentLoadingIndicatorView.hide()
                                                                          
                                                                          //let notificationName = Notification.Name("tabindexchange")
                                                                          //NotificationCenter.default.post(name: notificationName, object: nil)
                                                                         
                                                                          }}
                                                                      else{
                                                                          DispatchQueue.main.async
                                                                              {
                                                                                  TransperentLoadingIndicatorView.hide()
                                                                                  
                                                                                  
                                                                                  
                                                                                  
                                                                          }
                                                                          //Show Error
                                                                      }
                                                                  }
                                                              case .failure(let error):
                                                                 debugPrint(error as Any)
                        break
                                                                  // error handling
                                                   
                                                              }
                   
            }
            
            
        } catch {
            print(error.localizedDescription)
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
            UpcomingTriviaDetailViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return UpcomingTriviaDetailViewController.realDelegate!;
    }
}
