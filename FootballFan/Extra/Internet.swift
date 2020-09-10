//
//  Internet.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 02/09/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import Foundation
import SystemConfiguration

var internetAvailable: Bool = true
var networkName: String = ""

let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

func isInternetAvailable() {
    let hostToConnect = "google.com"
    var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
    let isAvailable = SCNetworkReachabilityCreateWithName(nil, hostToConnect)!
    
    SCNetworkReachabilitySetCallback(isAvailable, { (_, flags, _) in
        var reachabilityFlags = SCNetworkReachabilityFlags()
        reachabilityFlags = flags
        
        if (reachabilityFlags.contains(.reachable)) && !(reachabilityFlags.contains(.connectionRequired)) {
            if reachabilityFlags.contains(.isWWAN) {
                internetAvailable = true
                networkName = "cellular"
               // print("Online Cellular")
            } else {
                internetAvailable = true
                networkName = "wifi"
                //print("Online WiFi")
            }
        } else {
            internetAvailable = false
            networkName = "offline"
           // print("Offline")
        }
        let internetStatus:[String: String] = ["internet": networkName]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil, userInfo: internetStatus)
        
    }, &context)
    SCNetworkReachabilityScheduleWithRunLoop(isAvailable, CFRunLoopGetMain(), RunLoop.Mode.common as CFString)
    
}
