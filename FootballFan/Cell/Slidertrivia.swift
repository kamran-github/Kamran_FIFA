//
//  Slidertrivia.swift
//  FootballFan
//
//  Created by Apple on 28/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
class Slidertrivia: UIView {

    @IBOutlet weak var triviastatus: UILabel?
       @IBOutlet weak var title: UILabel?
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
        var currentIndex : Int = 0
         var ispurchase : Bool = false
        var issoldout : Bool = false
         @IBOutlet weak var descriptionConstraint2: NSLayoutConstraint!
         @IBOutlet weak var likeviewConstraint2: NSLayoutConstraint!
         @IBOutlet weak var countviewConstraint2: NSLayoutConstraint!
         @IBOutlet weak var buttomviewConstraint2: NSLayoutConstraint!
         @IBOutlet weak var avialableticket: UILabel?
        @IBOutlet weak var ticketprizeView: UIView?
        @IBOutlet weak var triviastart: UILabel?
          @IBOutlet weak var triviastartview: UIView?
         @IBOutlet weak var triviastartwidth: NSLayoutConstraint!
     @IBOutlet weak var sold: UILabel?
     @IBOutlet weak var purchase: UILabel?
        func setupTimer(`with` mili: Double, indexPath: Int){
           currentIndex = indexPath
            
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
            
          //  print("\(ispurchase)\(currentIndex)")
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
                if(ispurchase){
                    if(days == 0){
                       // triviastatus?.text = "STARTS IN \(Int(hours)):\(Int(minites)):\(Int(scondes as! Double))"
                        let remtime = String(format: "%02d:%02d:%02d", Int(hours as Double), Int(minites as Double), Int(scondes!))
                        triviastatus?.text = "STARTS IN \(remtime)"
                               }
                               else{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM"
                        triviastatus?.text = "STARTS \(dateFormatter.string(from: timeEnd!)) \(Int(hours)):\(Int(minites))"
                               }
                }
                else  if(issoldout){
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
               
                
                
                // header?.valueDay.text = formatter.string(from: NSNumber(value:days))
                // header?.valueHour.text = formatter.string(from: NSNumber(value:hours))
                // header?.valueMinites.text = formatter.string(from: NSNumber(value:minites))
                //header?.valueSeconds.text = formatter.string(from: NSNumber(value:scondes!))
                if(days == 0.0 && hours == 0.0 && minites == 0.0 && scondes == 0.0){
                let tabIndex:[String: Any] = ["index": currentIndex]
                let notificationName = Notification.Name("trivialiveonhome")
                NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
                    stopTimer()
                }
            } else {
                // header?.fadeOut()
              //  triviastatus?.text = "LIVE NOW"
                let tabIndex:[String: Any] = ["index": currentIndex]
                let notificationName = Notification.Name("trivialiveonhome")
                NotificationCenter.default.post(name: notificationName, object: nil,userInfo: tabIndex)
                    stopTimer()
            }
        }
        
    }
    extension String{
        func toDateformate(format : String) -> Date{
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = format
            return dateFormatter.date(from: self)!
        }
    }

   
