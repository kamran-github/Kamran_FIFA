//
//  InsentiveConfig.swift
//  FootballFan
//
//  Created by Apple on 13/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
class InsentiveConfig:SQLTable {
     var ID : Int = 0
    var isfcsignup : Bool = true
    var fcsignup : Int = 0
    var isfcjoinbanter : Bool = true
    var fcjoinbanter : Int = 0
    var fcbanterth : Int = 0
    var isfcactivity : Bool = true
    var fcactivity : Int = 0
    var fcactivityth : Int = 0
    var isgroupchat : Bool = true
    var isbanterchat : Bool = true
    var isnewfu : Bool = true
    var isfulike : Bool = true
    var isfucomment : Bool = true
    var isnewslike : Bool = true
    var isnewscomment : Bool = true
    var fcbronzeth : Int = 0
    var  fcsilverth : Int = 0
    var fcgoldth : Int = 0
    var fcplatinumth : Int = 0
    var fcdiamondth: Int = 0
    var fcbonusthb : Int = 0
    var fcbonusths : Int = 0
    var fcbonusthg : Int = 0
    var fcbonusthp : Int = 0
    var fcbonusthd : Int = 0
    var fcbronzeimage : String = ""
    var fcsilverimage : String = ""
    var fcgoldimage: String = ""
    var fcplatinumimage : String = ""
    var fcdiamondimage : String = ""
    var fcbronzeimageh : String = ""
    var fcsilverimageh : String = ""
    var fcgoldimageh: String = ""
    var fcplatinumimageh : String = ""
    var fcdiamondimageh : String = ""
    var fcredeemth : Int = 0
    var fcredeemamt : Int = 0
    var fcredeemcurrency : String = ""
    var fctotalcoin : Int = 0
    var fcavailablecoin : Int = 0
    var fccurrentlevel : String = "No Level"
    var fcactivitycount : Int = 0
    var isfcreferral : Bool = true
    var fcreferral : Int = 0
   var isstream : Bool = true
    var isfcfanstory: Bool = true
    var fcfanstory: Int = 0
    var fcfanstoryth: Int = 0
     var islogging: String = "active"
     var isteambrchat : Bool = true
    
}
