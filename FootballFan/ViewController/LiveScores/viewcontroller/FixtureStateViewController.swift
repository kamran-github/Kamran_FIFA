//
//  FixtureStateViewController.swift
//  FootballFan
//
//  Created by Apple on 10/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class FixtureStateViewController: UIViewController {
    var season_id = 0
    var fixtureStateData : Fixture?
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    // @IBOutlet weak var storytableview: UITableView?
    var arrstanding: [AnyObject] = []
    var dic: NSDictionary = NSDictionary()
    @IBOutlet weak var Shotstotal: UIProgressView?
    @IBOutlet weak var homeShotstotal: UILabel?
    @IBOutlet weak var visitorShotstotal: UILabel?
    
    @IBOutlet weak var Shotsongoal: UIProgressView?
    @IBOutlet weak var homeShotsongoal: UILabel?
    @IBOutlet weak var visitorShotsongoal: UILabel?
    
    @IBOutlet weak var Shotsoffgoal: UIProgressView?
    @IBOutlet weak var homeShotsoffgoal: UILabel?
    @IBOutlet weak var visitorShotsoffgoal: UILabel?
    
    @IBOutlet weak var Shotsblocked: UIProgressView?
    @IBOutlet weak var homeShotsblocked: UILabel?
    @IBOutlet weak var visitorShotsblocked: UILabel?
    
    @IBOutlet weak var Shotsinsidbox: UIProgressView?
    @IBOutlet weak var homeShotsinsidebox: UILabel?
    @IBOutlet weak var visitorShotsinsidebox: UILabel?
    
    @IBOutlet weak var Shotsoutsidebox: UIProgressView?
    @IBOutlet weak var homeShotsoutsidebox: UILabel?
    @IBOutlet weak var visitorShotsoutsidebox: UILabel?
    
    @IBOutlet weak var Passestotal: UIProgressView?
    @IBOutlet weak var homePassestotal: UILabel?
    @IBOutlet weak var visitorPassestotal: UILabel?
    
    @IBOutlet weak var Passesaccuracy: UIProgressView?
    @IBOutlet weak var homePassesaccuracy: UILabel?
    @IBOutlet weak var visitorPassesaccuracy: UILabel?
    
    @IBOutlet weak var Passespercentage: UIProgressView?
    @IBOutlet weak var homePassespercentage: UILabel?
    @IBOutlet weak var visitorPassespercentage: UILabel?
    
    @IBOutlet weak var Attackstotal: UIProgressView?
    @IBOutlet weak var homeAttackstotal: UILabel?
    @IBOutlet weak var visitorAttackstotal: UILabel?
    
    @IBOutlet weak var Attacksdengerous: UIProgressView?
    @IBOutlet weak var homeAttacksdengerous: UILabel?
    @IBOutlet weak var visitorAttacksdengerous: UILabel?
    
    @IBOutlet weak var Genralpossession: UIProgressView?
    @IBOutlet weak var homeGenralpossession: UILabel?
    @IBOutlet weak var visitorGenralpossession: UILabel?
    
    @IBOutlet weak var Genraloffside: UIProgressView?
    @IBOutlet weak var homeGenraloffside: UILabel?
    @IBOutlet weak var visitorGenraloffside: UILabel?
    
    @IBOutlet weak var Genralcorners: UIProgressView?
    @IBOutlet weak var homeGenralcorners: UILabel?
    @IBOutlet weak var visitorGenralcorners: UILabel?
    
    @IBOutlet weak var Genralfouls: UIProgressView?
    @IBOutlet weak var homeGenralfouls: UILabel?
    @IBOutlet weak var visitorGenralfouls: UILabel?
    
    @IBOutlet weak var Genralyellowscards: UIProgressView?
    @IBOutlet weak var homeGenralyellowscards: UILabel?
    @IBOutlet weak var visitorGenralyellowscards: UILabel?
    
    @IBOutlet weak var Genralredcards: UIProgressView?
    @IBOutlet weak var homeGenralredcards: UILabel?
    @IBOutlet weak var visitorGenralredcards: UILabel?
    
    @IBOutlet weak var Genralsaves: UIProgressView?
    @IBOutlet weak var homeGenralsaves: UILabel?
    @IBOutlet weak var visitorGenralsaves: UILabel?
    
    @IBOutlet weak var Genralsubstitutes: UIProgressView?
    @IBOutlet weak var homeGenralsubstitues: UILabel?
    @IBOutlet weak var visitorGenralsubstitues: UILabel?
    
    @IBOutlet weak var Genralgoalkick: UIProgressView?
    @IBOutlet weak var homeGenralgoalkick: UILabel?
    @IBOutlet weak var visitorGenralgoalkick: UILabel?
    
    @IBOutlet weak var Genralgoalattempts: UIProgressView?
    @IBOutlet weak var homeGenralgoalattempts: UILabel?
    @IBOutlet weak var visitorGenralgoalattempts: UILabel?
    
    @IBOutlet weak var Genralfreekicks: UIProgressView?
    @IBOutlet weak var homeGenralfreekicks: UILabel?
    @IBOutlet weak var visitorGenralfreekicks: UILabel?
    
    @IBOutlet weak var Genralthrowsin: UIProgressView?
    @IBOutlet weak var homeGenralthrowin: UILabel?
    @IBOutlet weak var visitorGenralthrowin: UILabel?
    
    @IBOutlet weak var Genralballsafe: UIProgressView?
    @IBOutlet weak var homeGenralballsafe: UILabel?
    @IBOutlet weak var visitorGenralballsafe: UILabel?
    var localdic:NSDictionary = NSDictionary()
    var visitordic:NSDictionary = NSDictionary()
    
    @IBOutlet weak var hometeam: UILabel?
    @IBOutlet weak var visitteam: UILabel?
    @IBOutlet weak var imghometeam: UIImageView?
    @IBOutlet weak var imgvisitteam: UIImageView?
    @IBOutlet weak var lblstatus: UILabel?
    @IBOutlet weak var homeview:UIView?
    @IBOutlet weak var visitorview:UIView?
    var homeId:Int = 0
    var visitorId:Int = 0
    
    @IBOutlet weak var lbltime: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        uidataset()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func homeTouched(_ sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : TeamDetailViewController = storyBoard.instantiateViewController(withIdentifier: "teamdetail") as!
        TeamDetailViewController
        myTeamsController.Teamname = dic.value(forKey: "hometeamname") as? String ?? ""
        myTeamsController.season_id = season_id
        //myTeamsController.legname = dic.value(forKey: "legname") as! String
        myTeamsController.team_id = homeId as AnyObject
        show(myTeamsController, sender: self)
    }
    @objc func visitorTouched(_ sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : TeamDetailViewController = storyBoard.instantiateViewController(withIdentifier: "teamdetail") as!
        TeamDetailViewController
        myTeamsController.Teamname = dic.value(forKey: "visitorteamname") as? String ?? ""
        myTeamsController.season_id = season_id
        //myTeamsController.legname = dic.value(forKey: "legname") as! String
        myTeamsController.team_id = visitorId as AnyObject
        show(myTeamsController, sender: self)
    }
    func uidataset()  {
        
        if let localTeam = fixtureStateData?.localTeam {
                   if let localTeamDetil = localTeam.data {
                       if let name = localTeamDetil.name{
                           let  homelogo = localTeamDetil.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                           hometeam?.text = name
                           let url = URL(string:homelogo)!
                           homeId = localTeamDetil.id ?? 0
                           imghometeam?.af.setImage(withURL: url)
                       }
                   }}
               
               if let visitorTeam = fixtureStateData?.visitorTeam {
                   if let visitorTeamDetil = visitorTeam.data {
                       if let name = visitorTeamDetil.name{
                           let visitorlogo = visitorTeamDetil.logo_path  ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                           visitteam?.text = name
                           let url1 = URL(string:visitorlogo)!
                           imgvisitteam?.af.setImage(withURL: url1 )
                           visitorId = visitorTeamDetil.id ?? 0
        }}}
        
        
        let homeTapGesture = UITapGestureRecognizer()
        homeTapGesture.addTarget(self, action: #selector(homeTouched(_:)))
        homeview?.addGestureRecognizer(homeTapGesture)
        homeview?.isUserInteractionEnabled = true
        let visitorTapGesture = UITapGestureRecognizer()
        visitorTapGesture.addTarget(self, action: #selector(visitorTouched(_:)))
        visitorview?.addGestureRecognizer(visitorTapGesture)
        visitorview?.isUserInteractionEnabled = true
        var homescore = 0
        var visitorscore = 0
        if let scoredic = fixtureStateData?.scores {
            homescore = scoredic.localteam_score ?? 0
            visitorscore = scoredic.visitorteam_score ?? 0
            lbltime?.text = "\(homescore) : \(visitorscore)"
        }
        if let status = fixtureStateData?.time {
            let status = status.status
            if(status == "FT"){
                lblstatus?.text = "Final Score"
                lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
                lbltime?.text = "\(homescore) : \(visitorscore)"
            
            }
            else if(status == "LIVE"){
                lblstatus?.text = "Live"
                lbltime?.text = "\(homescore) : \(visitorscore)"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
            }
            else if(status == "NS"){
                lblstatus?.text = "Time"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                if let mili = fixtureStateData?.fixtureTime
                {
                    let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                    let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                    let dateFormatter = DateFormatter()
                    //dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
                    //dateFormatter.dateStyle = .short
                    dateFormatter.dateFormat = "HH:mm"
                    lbltime?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                }
            }
        }
        if fixtureStateData?.stats?.data?.count ?? 0>0 {
            let localshots = fixtureStateData?.stats?.data![0].shots //localdic.value(forKey: "shots") as! NSDictionary
                   let visitorshots = fixtureStateData?.stats?.data![1].shots
                   let localshotstotel = (localshots?.total as NSNumber?)?.floatValue
                   let visitorshotstotelV = (visitorshots?.total as NSNumber?)?.floatValue
                   homeShotstotal?.text = "\(Int(localshotstotel ?? 0))"
                   visitorShotstotal?.text = "\(Int(visitorshotstotelV ?? 0))"
                   if(localshotstotel != 0 &&  visitorshotstotelV != 0 ){
                       let addition = (visitorshotstotelV ?? 0) + (localshotstotel ?? 0)
                       Shotstotal?.progress = Float((localshotstotel ?? 0)/addition)
                   }
                   else{
                       Shotstotal?.progress = Float(0/100)
                   }
                   
                   let localshotsongoal = (localshots?.ongoal as NSNumber?)?.floatValue
                   let visitorshotsongoalV = (visitorshots?.ongoal as NSNumber?)?.floatValue
                   homeShotsongoal?.text = "\(Int(localshotsongoal ?? 0))"
                   visitorShotsongoal?.text = "\(Int(visitorshotsongoalV ?? 0))"
                   if(localshotsongoal != 0 &&  visitorshotsongoalV != 0 ){
                        let addition = (visitorshotsongoalV ?? 0) + (localshotsongoal ?? 0)
                       Shotsongoal?.progress = Float(localshotsongoal ?? 0/addition)
                   }
                   else{
                       Shotsongoal?.progress = Float(0/100)
                   }
                   
                   let localshotsblocked = (Int(localshots?.blocked ?? "0") as NSNumber?)?.floatValue
                   let visitorshotsblockedV = (Int(visitorshots?.blocked ?? "0") as NSNumber?)?.floatValue
                   homeShotsblocked?.text = "\(Int(localshotsblocked ?? 0))"
                   visitorShotsblocked?.text = "\(Int(visitorshotsongoalV ?? 0))"
                   if(localshotsblocked != 0 &&  visitorshotsblockedV != 0 ){
                       let addition = (visitorshotsblockedV ?? 0) + (localshotsblocked ?? 0)
                       Shotsblocked?.progress = Float(localshotsblocked ?? 0/addition)
                   } else {
                       Shotsblocked?.progress = Float(0/100)
                   }
                   
                   let localshotsoffgoal = (localshots?.offgoal as NSNumber?)?.floatValue
                   let visitorshotsoffgoalV = (visitorshots?.offgoal as NSNumber?)?.floatValue
                   homeShotsoffgoal?.text = "\(Int(localshotsoffgoal ?? 0))"
                   visitorShotsoffgoal?.text = "\(Int(visitorshotsoffgoalV ?? 0))"
                   if(localshotsoffgoal != 0 &&  visitorshotsoffgoalV != 0 ){
                       let addition = (visitorshotsoffgoalV ?? 0) + (localshotsoffgoal ?? 0)
                       Shotsoffgoal?.progress = Float(localshotsoffgoal ?? 0/addition)
                   } else {
                       Shotsoffgoal?.progress = Float(0/100)
                   }
                   
                   let localshotsinsidebox = (localshots?.insidebox as NSNumber?)?.floatValue
                   let visitorshotsinsideboxV = (visitorshots?.insidebox as NSNumber?)?.floatValue
                   homeShotsinsidebox?.text = "\(Int(localshotsinsidebox ?? 0))"
                   visitorShotsinsidebox?.text = "\(Int(visitorshotsinsideboxV ?? 0))"
                   if(localshotsinsidebox != 0 &&  visitorshotsinsideboxV != 0 ){
                       let addition = (visitorshotsoffgoalV ?? 0) + (localshotsoffgoal ?? 0)
                       Shotsinsidbox?.progress = Float(localshotsinsidebox ?? 0/addition)
                   } else {
                       Shotsinsidbox?.progress = Float(0/100)
                   }
                   
                   let localshotsoutsidebox = (localshots?.outsidebox as NSNumber?)?.floatValue
                   let visitorshotsoutsideboxV = (visitorshots?.outsidebox as NSNumber?)?.floatValue
                   homeShotsoutsidebox?.text = "\(Int(localshotsoutsidebox ?? 0))"
                   visitorShotsoutsidebox?.text = "\(Int(visitorshotsoutsideboxV ?? 0))"
                   if(localshotsoutsidebox != 0 &&  visitorshotsoutsideboxV != 0 ){
                       let addition = (visitorshotsoutsideboxV ?? 0) + (localshotsoutsidebox ?? 0)
                       Shotsoutsidebox?.progress = Float(localshotsoutsidebox ?? 0/addition)
                   } else {
                       Shotsoutsidebox?.progress = Float(0/100)
                   }
                   
                   
                   let localpasses = fixtureStateData?.stats?.data![0].passes
                   let visitorpasses = fixtureStateData?.stats?.data![1].passes
                   
                   let localpassestotel = (localpasses?.total as NSNumber?)?.floatValue
                   let visitorpassestotelV = (visitorpasses?.total as NSNumber?)?.floatValue
                   homePassestotal?.text = "\(Int(localpassestotel ?? 0))"
                   visitorPassestotal?.text = "\(Int(visitorpassestotelV ?? 0))"
                   if(localpassestotel != 0 &&  visitorpassestotelV != 0 ){
                       let addition = (visitorpassestotelV ?? 0) + (localpassestotel ?? 0)
                       Passestotal?.progress = Float(localpassestotel ?? 0/addition)
                   } else {
                       Passestotal?.progress = Float(0/100)
                   }
                   
                   let localpassesaccurate = (localpasses?.accurate as NSNumber?)?.floatValue
                   let visitorpassesaccurateV = (visitorpasses?.accurate as NSNumber?)?.floatValue
                   homePassesaccuracy?.text = "\(Int(localpassesaccurate ?? 0))"
                   visitorPassesaccuracy?.text = "\(Int(visitorpassesaccurateV ?? 0))"
                   if(localpassesaccurate != 0 &&  visitorpassesaccurateV != 0 ){
                       let addition = (visitorpassesaccurateV ?? 0) + (localpassesaccurate ?? 0)
                       Passesaccuracy?.progress = Float(localpassesaccurate ?? 0/addition)
                   } else {
                       Passesaccuracy?.progress = Float(0/100)
                   }
                   
                   
                   let localpassespercentage = (localpasses?.percentage as NSNumber?)?.floatValue
                   let visitorpassespercentageV = (visitorpasses?.percentage as NSNumber?)?.floatValue
                   homePassespercentage?.text = "\(localpassespercentage ?? 0)%"
                   visitorPassespercentage?.text = "\(visitorpassespercentageV ?? 0)%"
                   if(localpassespercentage != 0 &&  visitorpassespercentageV != 0 ){
                       let addition = (visitorpassespercentageV ?? 0) + (localpassespercentage ?? 0)
                       Passespercentage?.progress = Float(localpassespercentage ?? 0/addition)
                   } else {
                       Passespercentage?.progress = Float(0/100)
                   }
                   
                   
                   let localattacks = fixtureStateData?.stats?.data![0].attacks
                   let visitorattacks = fixtureStateData?.stats?.data![1].attacks
                   let localattacksv = (localattacks?.attacks as NSNumber?)?.floatValue
                   let visitorattacksV = (visitorattacks?.attacks as NSNumber?)?.floatValue
                   homeAttackstotal?.text = "\(Int(localattacksv ?? 0))"
                   visitorAttackstotal?.text = "\(Int(visitorattacksV ?? 0))"
                   if(localattacksv != 0 &&  visitorattacksV != 0 ){
                       let addition = (visitorattacksV ?? 0) + (localattacksv ?? 0)
                       Attackstotal?.progress = Float(localattacksv ?? 0/addition)
                   } else {
                       Attackstotal?.progress = Float(0/100)
                   }
                   
                   
                   let localdangerous_attacks = (localattacks?.dangerous_attacks as NSNumber?)?.floatValue
                   let visitordangerous_attacks = (visitorattacks?.dangerous_attacks as NSNumber?)?.floatValue
                   homeAttacksdengerous?.text = "\(Int(localdangerous_attacks ?? 0))"
                   visitorAttacksdengerous?.text = "\(Int(visitordangerous_attacks ?? 0))"
                   if(localdangerous_attacks != 0 &&  visitordangerous_attacks != 0 ){
                       let addition = (visitordangerous_attacks ?? 0) + (localdangerous_attacks ?? 0)
                       Attacksdengerous?.progress = Float(localdangerous_attacks ?? 0/addition)
                   } else {
                       Attacksdengerous?.progress = Float(0/100)
                   }
                   

                   let localfouls = (fixtureStateData?.stats?.data![0].fouls as NSNumber?)?.floatValue
                   let visitorfouls = (fixtureStateData?.stats?.data![1].fouls as NSNumber?)?.floatValue
                   homeGenralfouls?.text = "\(Int(localfouls ?? 0))"
                   visitorGenralfouls?.text = "\(Int(visitorfouls ?? 0))"
                   if(localfouls != 0 &&  visitorfouls != 0 ){
                       let addition = (visitorfouls ?? 0) + (localfouls ?? 0)
                       Genralfouls?.progress = Float((localfouls ?? 0)/addition)
                   } else {
                       Genralfouls?.progress = Float(0/100)
                   }
                   
                   
                   
                   let localcorners = (fixtureStateData?.stats?.data![0].corners as NSNumber?)?.floatValue
                   let visitorcorners = (fixtureStateData?.stats?.data![1].corners as NSNumber?)?.floatValue
                   homeGenralcorners?.text = "\(Int(localcorners ?? 0))"
                   visitorGenralcorners?.text = "\(Int(visitorcorners ?? 0))"
                   if(localcorners != 0 &&  visitorcorners != 0 ){
                       let addition = (visitorcorners ?? 0) + (localcorners ?? 0)
                       Genralcorners?.progress = Float(localcorners ?? 0/addition)
                   } else {
                       Genralcorners?.progress = Float(0/100)
                   }
                   
                   
                   let localoffsides = (fixtureStateData?.stats?.data![0].offsides as NSNumber?)?.floatValue
                   let visitoroffsides = (fixtureStateData?.stats?.data![1].offsides as NSNumber?)?.floatValue
                   homeGenraloffside?.text = "\(Int(localoffsides ?? 0))"
                   visitorGenraloffside?.text = "\(Int(visitoroffsides ?? 0))"
                   if(localoffsides != 0 &&  visitoroffsides != 0 ){
                       let addition = (visitoroffsides ?? 0) + (localoffsides ?? 0)
                       Genraloffside?.progress = Float(localoffsides ?? 0/addition)
                   } else {
                       Genraloffside?.progress = Float(0/100)
                   }
                   
                   
                   let localpossessiontime = (fixtureStateData?.stats?.data![0].possessiontime as NSNumber?)?.floatValue
                   let visitorpossessiontime = (fixtureStateData?.stats?.data![1].possessiontime as NSNumber?)?.floatValue
                   homeGenralpossession?.text = "\(localpossessiontime ?? 0)%"
                   visitorGenralpossession?.text = "\(visitorpossessiontime ?? 0)%"
                   if(localpossessiontime != 0 &&  visitorpossessiontime != 0 ){
                       let addition = (visitorpossessiontime ?? 0) + (localpossessiontime ?? 0)
                       Genralpossession?.progress = Float(localpossessiontime ?? 0/addition)
                   } else{
                       Genralpossession?.progress = Float(0/100)
                   }
                   
                   
                   let localyellowcards = (fixtureStateData?.stats?.data![0].yellowcards as NSNumber?)?.floatValue
                   let visitoryellowcards = (fixtureStateData?.stats?.data![1].yellowcards as NSNumber?)?.floatValue
                   homeGenralyellowscards?.text = "\(Int(localyellowcards ?? 0))"
                   visitorGenralyellowscards?.text = "\(Int(visitoryellowcards ?? 0))"
                   
                   if(localyellowcards != 0 &&  visitoryellowcards != 0 ){
                       let addition = (visitoryellowcards ?? 0) + (localyellowcards ?? 0)
                       Genralyellowscards?.progress = Float(localyellowcards ?? 0/addition)
                   } else {
                       Genralyellowscards?.progress = Float(0/100)
                   }
                   
                   let localredcards = (fixtureStateData?.stats?.data![0].redcards as NSNumber?)?.floatValue
                   let visitorredcards = (fixtureStateData?.stats?.data![1].redcards as NSNumber?)?.floatValue
                   homeGenralredcards?.text = "\(Int(localredcards ?? 0))"
                   visitorGenralredcards?.text = "\(Int(visitorredcards ?? 0))"
                   if(localredcards != 0 &&  visitorredcards != 0 ){
                       let addition = (visitorredcards ?? 0) + (localredcards ?? 0)
                       Genralredcards?.progress = Float(localredcards ?? 0/addition)
                   } else {
                       Genralredcards?.progress = Float(0/100)
                   }
                   
                   
                   let localsaves = (fixtureStateData?.stats?.data![0].saves as NSNumber?)?.floatValue
                   let visitorsaves = (fixtureStateData?.stats?.data![1].saves as NSNumber?)?.floatValue
                   homeGenralsaves?.text = "\(Int(localsaves ?? 0))"
                   visitorGenralsaves?.text = "\(Int(visitorsaves ?? 0))"
                   if(localsaves != 0 &&  visitorsaves != 0 ){
                       let addition = (visitorsaves ?? 0) + (localsaves ?? 0)
                       Genralsaves?.progress = Float(localsaves ?? 0/addition)
                   } else {
                       Genralsaves?.progress = Float(0/100)
                   }
                   
                   
                   let localsubstitutions = (fixtureStateData?.stats?.data![0].substitutions as NSNumber?)?.floatValue
                   let visitorsubstitutions = (fixtureStateData?.stats?.data![1].substitutions as NSNumber?)?.floatValue
                   homeGenralsubstitues?.text = "\(Int(localsubstitutions ?? 0))"
                   visitorGenralsubstitues?.text = "\(Int(visitorsubstitutions ?? 0))"
                   if(localsubstitutions != 0 &&  visitorsubstitutions != 0 ){
                        let addition = (visitorsubstitutions ?? 0) + (localsubstitutions ?? 0)
                       Genralsubstitutes?.progress = Float(localsubstitutions ?? 0/addition)
                   } else {
                       Genralsubstitutes?.progress = Float(0/100)
                   }
                   
                   
                   let localgoal_kick = (Int(fixtureStateData?.stats?.data![0].goal_kick ?? "0") as NSNumber?)?.floatValue
                   let visitorgoal_kick = (Int(fixtureStateData?.stats?.data![1].goal_kick ?? "0") as NSNumber?)?.floatValue
                   homeGenralgoalkick?.text = "\(Int(localgoal_kick ?? 0))"
                   visitorGenralgoalkick?.text = "\(Int(visitorgoal_kick ?? 0))"
                   if(localgoal_kick != 0 &&  visitorgoal_kick != 0 ){
                       let addition = (visitorgoal_kick ?? 0) + (localgoal_kick ?? 0)
                       Genralgoalkick?.progress = Float(localgoal_kick ?? 0/addition)
                   } else {
                       Genralgoalkick?.progress = Float(0/100)
                   }
                   
                   
                   let localgoal_attempts = (fixtureStateData?.stats?.data![0].goal_attempts as NSNumber?)?.floatValue
                   let visitorgoal_attempts = (fixtureStateData?.stats?.data![1].goal_attempts as NSNumber?)?.floatValue
                   homeGenralgoalattempts?.text = "\(Int(localgoal_attempts ?? 0))"
                   visitorGenralgoalattempts?.text = "\(Int(visitorgoal_attempts ?? 0))"
                   
                   if(localgoal_attempts != 0 &&  visitorgoal_attempts != 0 ){
                       let addition = (visitorgoal_attempts ?? 0) + (localgoal_attempts ?? 0)
                       Genralgoalattempts?.progress = Float(localgoal_attempts ?? 0/addition)
                   }
                   else{
                       Genralgoalattempts?.progress = Float(0/100)
                   }
                   
                   
                   let localfree_kick = (Int(fixtureStateData?.stats?.data![0].free_kick ?? "0") as NSNumber?)?.floatValue
                   let visitorfree_kick = (Int(fixtureStateData?.stats?.data![1].free_kick ?? "0") as NSNumber?)?.floatValue
                   homeGenralfreekicks?.text = "\(Int(localfree_kick ?? 0))"
                   visitorGenralfreekicks?.text = "\(Int(visitorfree_kick ?? 0))"
                   if(localfree_kick != 0 &&  visitorfree_kick != 0 ){
                       let addition = (visitorfree_kick ?? 0) + (localfree_kick ?? 0)
                       Genralfreekicks?.progress = Float(localfree_kick ?? 0/addition)
                   } else {
                       Genralfreekicks?.progress = Float(0/100)
                   }
                   
                   
                   let localthrow_in = (Int(fixtureStateData?.stats?.data![0].throw_in ?? "0") as NSNumber?)?.floatValue
                   let visitorthrow_in = (Int(fixtureStateData?.stats?.data![1].throw_in ?? "0") as NSNumber?)?.floatValue
                   homeGenralthrowin?.text = "\(Int(localthrow_in ?? 0))"
                   visitorGenralthrowin?.text = "\(Int(visitorthrow_in ?? 0))"
                   if(localthrow_in != 0 &&  visitorthrow_in != 0 ){
                       let addition = (visitorthrow_in ?? 0) + (localthrow_in ?? 0)
                       Genralthrowsin?.progress = Float(localthrow_in ?? 0/addition)
                   } else {
                       Genralthrowsin?.progress = Float(0/100)
                   }
                   
                   
                   let localball_safe = (fixtureStateData?.stats?.data![0].ball_safe as NSNumber?)?.floatValue
                   let visitorball_safe = (fixtureStateData?.stats?.data![1].ball_safe as NSNumber?)?.floatValue
                   homeGenralballsafe?.text = "\(Int(localball_safe ?? 0))"
                   visitorGenralballsafe?.text = "\(Int(visitorball_safe ?? 0))"
                   if(localball_safe != 0 &&  visitorball_safe != 0 ){
                       let addition = (visitorball_safe ?? 0) + (localball_safe ?? 0)
                       Genralballsafe?.progress = Float(localball_safe ?? 0/addition)
                   } else {
                       Genralballsafe?.progress = Float(0/100)
                   }
               }
               
        }
}
