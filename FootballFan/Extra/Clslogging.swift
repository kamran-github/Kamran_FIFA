//
//  Clslogging.swift
//  FootballFan
//
//  Created by Apple on 02/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
//import JustLog
public class Clslogging {
   
   public static func setupLogger()  {
    let sessionID = UUID().uuidString

       /* let logger = Logger.shared
               
               // custom keys
               logger.logTypeKey = "file"
               logger.appVersionKey = "1"
               logger.iosVersionKey = "1"
               logger.deviceTypeKey = "1"
               
               // file destination
               logger.logFilename = "iosff.log"
    logger.enableLogstashLogging = false
    logger.enableFileLogging = true
               
               // logstash destination
               //logger.logstashHost = "apitest.ifootballfan.com"//"listener.logz.io"
               //logger.logstashPort = 80//5052
               //logger.logstashTimeout = 10
               //logger.logLogstashSocketActivity = true

               // logz.io support
               //logger.logzioToken = <logzioToken>
               // untrusted (self-signed) logstash server support
               //logger.allowUntrustedServer = <Bool>
               
               // default info
               logger.defaultUserInfo = ["application": "FootballFan",
                                         "environment": "development",
                                         "session": sessionID]
               logger.setup()*/
    }
  /* public static  func forceSendLogs(_ application: UIApplication) {
           
           var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
           
           identifier = application.beginBackgroundTask(expirationHandler: {
               application.endBackgroundTask(identifier)
               identifier = UIBackgroundTaskIdentifier.invalid
           })
           
           Logger.shared.forceSend { completionHandler in
               application.endBackgroundTask(identifier)
               identifier = UIBackgroundTaskIdentifier.invalid
           }
       }*/
    public static func logverbose(State :String,userinfo:[String: AnyObject])  {
       /* if(appDelegate().isOnloggin){
        
         Logger.shared.verbose(State, userInfo: userinfo)
        }*/
    }
   public static func logdebug(State :String)  {
   /* if(appDelegate().isOnloggin){
           
           Logger.shared.debug(State)
    }*/
       }
   public static func loginfo(State :String,userinfo:[String: AnyObject])  {
  /*  if(appDelegate().isOnloggin){
           
              Logger.shared.info(State, userInfo: userinfo)
    }*/
          }
   public static func logwarning(State :String,userinfo:[String: AnyObject])  {
   /* if(appDelegate().isOnloggin){
           
        Logger.shared.warning(State, userInfo: userinfo)
    }*/
    }
  public static func logerror(State :String,userinfo:[String: AnyObject])  {
    /*if(appDelegate().isOnloggin){
           
        Logger.shared.error(State, userInfo: userinfo)
    }*/
    }
    /*static var realDelegate: AppDelegate?;
       
     private static  func appDelegate() -> AppDelegate {
           if Thread.isMainThread{
               return UIApplication.shared.delegate as! AppDelegate;
           }
           let dg = DispatchGroup();
           dg.enter()
           DispatchQueue.main.async{
               Clslogging.realDelegate = UIApplication.shared.delegate as? AppDelegate;
               dg.leave();
           }
           dg.wait();
           return Clslogging.realDelegate!;
       }*/
}
