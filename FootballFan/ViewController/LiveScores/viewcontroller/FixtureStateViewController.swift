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
   var season_id: AnyObject = 0 as AnyObject
       
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
        let dicstats = dic.value(forKey: "stats") as! NSDictionary
        let data = dicstats.value(forKey: "data") as! NSArray
        localdic = data[0] as! NSDictionary
        visitordic = data[1] as! NSDictionary
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
        
        if let localTeam = dic.value(forKey: "localTeam") {
               if let localTeamDetil = (localTeam as AnyObject).value(forKey: "data") {
            
                   if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                    let  homename = name as! String
                     let  homelogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                         hometeam?.text = homename
                          let url = URL(string:homelogo)!
                         homeId = (localTeamDetil as AnyObject).value(forKey: "id") as! Int
                          imghometeam?.af.setImage(withURL: url)
                }
            }}
        if let visitorTeam = dic.value(forKey: "visitorTeam") {
          if let localTeamDetil = (visitorTeam as AnyObject).value(forKey: "data") {
        
              if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                 let visitorname = name as! String
                                                let visitorlogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                                   visitteam?.text = visitorname
                                                   let url1 = URL(string:visitorlogo)!
                                                                 imgvisitteam?.af.setImage(withURL: url1 )
                 visitorId = (localTeamDetil as AnyObject).value(forKey: "id") as! Int
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
                 if let scoredic = dic.value(forKey: "scores") {
                                 homescore = (scoredic as AnyObject).value(forKey: "localteam_score") as! Int
                                 visitorscore = (scoredic as AnyObject).value(forKey: "visitorteam_score") as! Int
                                lbltime?.text = "\(homescore) : \(visitorscore)"
                            }
                 if let status = dic.value(forKey: "time") {
                     let status = (status as AnyObject).value(forKey: "status") as! String
                     if(status == "FT"){
                                   lblstatus?.text = "Final Score"
                                   lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
                      lbltime?.text = "\(homescore) : \(visitorscore)"
                                  // lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
                               }
                                   else if(status == "LIVE"){
                                  lblstatus?.text = "Live"
                      lbltime?.text = "\(homescore) : \(visitorscore)"
                                          //lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
                                   lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                               }
                               else if(status == "NS"){
                                    lblstatus?.text = "Time"
                                    lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                               if let mili = dic.value(forKey: "fixtureTime")
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
        let localshots = localdic.value(forKey: "shots") as! NSDictionary
        let visitorshots = visitordic.value(forKey: "shots") as! NSDictionary
        let localshotstotel = (localshots.value(forKey: "total") as! NSNumber).floatValue
        let visitorshotstotelV = (visitorshots.value(forKey: "total") as! NSNumber).floatValue
        homeShotstotal?.text = "\(Int(localshotstotel))"
         visitorShotstotal?.text = "\(Int(visitorshotstotelV))"
        if(localshotstotel != 0 &&  visitorshotstotelV != 0 ){
                                      Shotstotal?.progress = Float(localshotstotel/(visitorshotstotelV + localshotstotel))
                                          
                                         
                                                               }
                                                               else{
                                                                   Shotstotal?.progress = Float(0/100)
                                                               }
        
        let localshotsongoal = (localshots.value(forKey: "ongoal") as! NSNumber).floatValue
        let visitorshotsongoalV = (visitorshots.value(forKey: "ongoal") as! NSNumber).floatValue
        homeShotsongoal?.text = "\(Int(localshotsongoal))"
        visitorShotsongoal?.text = "\(Int(visitorshotsongoalV))"
        if(localshotsongoal != 0 &&  visitorshotsongoalV != 0 ){
                              Shotsongoal?.progress = Float(localshotsongoal/(visitorshotsongoalV + localshotsongoal))
                                   
                                  
                                                        }
                                                        else{
                                                            Shotsongoal?.progress = Float(0/100)
                                                        }
       
        let localshotsblocked = (localshots.value(forKey: "blocked") as! NSNumber).floatValue
        let visitorshotsblockedV = (visitorshots.value(forKey: "blocked") as! NSNumber).floatValue
        homeShotsblocked?.text = "\(Int(localshotsblocked))"
        visitorShotsblocked?.text = "\(Int(visitorshotsongoalV))"
        if(localshotsblocked != 0 &&  visitorshotsblockedV != 0 ){
                       Shotsblocked?.progress = Float(localshotsblocked/(visitorshotsblockedV + localshotsblocked))
                            
                           
                                                 }
                                                 else{
                                                     Shotsblocked?.progress = Float(0/100)
                                                 }
       
        let localshotsoffgoal = (localshots.value(forKey: "offgoal") as! NSNumber).floatValue
        let visitorshotsoffgoalV = (visitorshots.value(forKey: "offgoal") as! NSNumber).floatValue
        homeShotsoffgoal?.text = "\(Int(localshotsoffgoal))"
        visitorShotsoffgoal?.text = "\(Int(visitorshotsoffgoalV))"
        if(localshotsoffgoal != 0 &&  visitorshotsoffgoalV != 0 ){
               Shotsoffgoal?.progress = Float(localshotsoffgoal/(visitorshotsoffgoalV + localshotsoffgoal))
                     
                    
                                          }
                                          else{
                                              Shotsoffgoal?.progress = Float(0/100)
                                          }
       
        let localshotsinsidebox = (localshots.value(forKey: "insidebox") as! NSNumber).floatValue
        let visitorshotsinsideboxV = (visitorshots.value(forKey: "insidebox") as! NSNumber).floatValue
        homeShotsinsidebox?.text = "\(Int(localshotsinsidebox))"
        visitorShotsinsidebox?.text = "\(Int(visitorshotsinsideboxV))"
        if(localshotsinsidebox != 0 &&  visitorshotsinsideboxV != 0 ){
       Shotsinsidbox?.progress = Float(localshotsinsidebox/(visitorshotsinsideboxV + localshotsinsidebox))
             
                                   }
                                   else{
                                       Shotsinsidbox?.progress = Float(0/100)
                                   }
        
        let localshotsoutsidebox = (localshots.value(forKey: "outsidebox") as! NSNumber).floatValue
        let visitorshotsoutsideboxV = (visitorshots.value(forKey: "outsidebox") as! NSNumber).floatValue
        homeShotsoutsidebox?.text = "\(Int(localshotsoutsidebox))"
        visitorShotsoutsidebox?.text = "\(Int(visitorshotsoutsideboxV))"
        if(localshotsoutsidebox != 0 &&  visitorshotsoutsideboxV != 0 ){
                Shotsoutsidebox?.progress = Float(localshotsoutsidebox/(visitorshotsoutsideboxV + localshotsoutsidebox))
                     
                                           }
                                           else{
                                               Shotsoutsidebox?.progress = Float(0/100)
                                           }
      
        
        let localpasses = localdic.value(forKey: "passes") as! NSDictionary
        let visitorpasses = visitordic.value(forKey: "passes") as! NSDictionary
        
        let localpassestotel = (localpasses.value(forKey: "total") as! NSNumber).floatValue
        let visitorpassestotelV = (visitorpasses.value(forKey: "total") as! NSNumber).floatValue
        homePassestotal?.text = "\(Int(localpassestotel))"
        visitorPassestotal?.text = "\(Int(visitorpassestotelV))"
        if(localpassestotel != 0 &&  visitorpassestotelV != 0 ){
       Passestotal?.progress = Float(localpassestotel/(visitorpassestotelV + localpassestotel))
        
              
                                    }
                                    else{
                                        Passestotal?.progress = Float(0/100)
                                    }
        
        let localpassesaccurate = (localpasses.value(forKey: "accurate") as! NSNumber).floatValue
        let visitorpassesaccurateV = (visitorpasses.value(forKey: "accurate") as! NSNumber).floatValue
        homePassesaccuracy?.text = "\(Int(localpassesaccurate))"
        visitorPassesaccuracy?.text = "\(Int(visitorpassesaccurateV))"
        if(localpassesaccurate != 0 &&  visitorpassesaccurateV != 0 ){
                Passesaccuracy?.progress = Float(localpassesaccurate/(visitorpassesaccurateV + localpassesaccurate))
                      
                      
                                            }
                                            else{
                                                Passesaccuracy?.progress = Float(0/100)
                                            }
        
       
        let localpassespercentage = (localpasses.value(forKey: "percentage") as! NSNumber).floatValue
        let visitorpassespercentageV = (visitorpasses.value(forKey: "percentage") as! NSNumber).floatValue
               homePassespercentage?.text = "\(localpassespercentage)%"
               visitorPassespercentage?.text = "\(visitorpassespercentageV)%"
        if(localpassespercentage != 0 &&  visitorpassespercentageV != 0 ){
              Passespercentage?.progress = Float(localpassespercentage/(visitorpassespercentageV + localpassespercentage))
                     
                                           }
                                           else{
                                               Passespercentage?.progress = Float(0/100)
                                           }
       
        
        let localattacks = localdic.value(forKey: "attacks") as! NSDictionary
               let visitorattacks = visitordic.value(forKey: "attacks") as! NSDictionary
        let localattacksv = (localattacks.value(forKey: "attacks") as! NSNumber).floatValue
        let visitorattacksV = (visitorattacks.value(forKey: "attacks") as! NSNumber).floatValue
               homeAttackstotal?.text = "\(Int(localattacksv))"
                visitorAttackstotal?.text = "\(Int(visitorattacksV))"
        if(localattacksv != 0 &&  visitorattacksV != 0 ){
       Attackstotal?.progress = Float(localattacksv/(visitorattacksV + localattacksv))
                
                                    }
                                    else{
                                        Attackstotal?.progress = Float(0/100)
                                    }
               
        
        let localdangerous_attacks = (localattacks.value(forKey: "dangerous_attacks") as! NSNumber).floatValue
        let visitordangerous_attacks = (visitorattacks.value(forKey: "dangerous_attacks") as! NSNumber).floatValue
        homeAttacksdengerous?.text = "\(Int(localdangerous_attacks))"
         visitorAttacksdengerous?.text = "\(Int(visitordangerous_attacks))"
        if(localdangerous_attacks != 0 &&  visitordangerous_attacks != 0 ){
              Attacksdengerous?.progress = Float(localdangerous_attacks/(visitordangerous_attacks + localdangerous_attacks))
                      
                                          }
                                          else{
                                              Attacksdengerous?.progress = Float(0/100)
                                          }
              
        
        
        let localfouls = (localdic.value(forKey: "fouls") as! NSNumber).floatValue
        let visitorfouls = (visitordic.value(forKey: "fouls") as! NSNumber).floatValue
        homeGenralfouls?.text = "\(Int(localfouls))"
         visitorGenralfouls?.text = "\(Int(visitorfouls))"
        if(localfouls != 0 &&  visitorfouls != 0 ){
        Genralfouls?.progress = Float(localfouls/(visitorfouls + localfouls))
               
                                   }
                                   else{
                                       Genralfouls?.progress = Float(0/100)
                                   }
       
        let localcorners = (localdic.value(forKey: "corners") as! NSNumber).floatValue
        let visitorcorners = (visitordic.value(forKey: "corners") as! NSNumber).floatValue
        homeGenralcorners?.text = "\(Int(localcorners))"
         visitorGenralcorners?.text = "\(Int(visitorcorners))"
        if(localcorners != 0 &&  visitorcorners != 0 ){
              Genralcorners?.progress = Float(localcorners/(visitorcorners + localcorners))
               
                                         }
                                         else{
                                             Genralcorners?.progress = Float(0/100)
                                         }
                      
        
        let localoffsides = (localdic.value(forKey: "offsides") as! NSNumber).floatValue
        let visitoroffsides = (visitordic.value(forKey: "offsides") as! NSNumber).floatValue
               homeGenraloffside?.text = "\(Int(localoffsides))"
                visitorGenraloffside?.text = "\(Int(visitoroffsides))"
        if(localoffsides != 0 &&  visitoroffsides != 0 ){
        Genraloffside?.progress = Float(localoffsides/(visitoroffsides + localoffsides))
              
                                  }
                                  else{
                                      Genraloffside?.progress = Float(0/100)
                                  }
               
        
        let localpossessiontime = (localdic.value(forKey: "possessiontime") as! NSNumber).floatValue
        let visitorpossessiontime = (visitordic.value(forKey: "possessiontime") as! NSNumber).floatValue
        homeGenralpossession?.text = "\(localpossessiontime)%"
         visitorGenralpossession?.text = "\(visitorpossessiontime)%"
        if(localpossessiontime != 0 &&  visitorpossessiontime != 0 ){
                                     Genralpossession?.progress = Float(localpossessiontime/(visitorpossessiontime + localpossessiontime))
                                           
                                           
                                                               }
                                                               else{
                                                                   Genralpossession?.progress = Float(0/100)
                                                               }
              
       
        let localyellowcards = (localdic.value(forKey: "yellowcards") as! NSNumber).floatValue
        let visitoryellowcards = (visitordic.value(forKey: "yellowcards") as! NSNumber).floatValue
        homeGenralyellowscards?.text = "\(Int(localyellowcards))"
         visitorGenralyellowscards?.text = "\(Int(visitoryellowcards))"
        
        if(localyellowcards != 0 &&  visitoryellowcards != 0 ){
                             Genralyellowscards?.progress = Float(localyellowcards/(visitoryellowcards + localyellowcards))
                                    
                                                        }
                                                        else{
                                                            Genralyellowscards?.progress = Float(0/100)
                                                        }
       
        let localredcards = (localdic.value(forKey: "redcards") as! NSNumber).floatValue
        let visitorredcards = (visitordic.value(forKey: "redcards") as! NSNumber).floatValue
        homeGenralredcards?.text = "\(Int(localredcards))"
         visitorGenralredcards?.text = "\(Int(visitorredcards))"
        if(localredcards != 0 &&  visitorredcards != 0 ){
            Genralredcards?.progress = Float(localredcards/(visitorredcards + localredcards))
        }
        else{
            Genralredcards?.progress = Float(0/100)
        }
        
        
        let localsaves = (localdic.value(forKey: "saves") as! NSNumber).floatValue
        let visitorsaves = (visitordic.value(forKey: "saves") as! NSNumber).floatValue
               homeGenralsaves?.text = "\(Int(localsaves))"
                visitorGenralsaves?.text = "\(Int(visitorsaves))"
        if(localsaves != 0 &&  visitorsaves != 0 ){
                       Genralsaves?.progress = Float(localsaves/(visitorsaves + localsaves))
                            
                                                  }
                                                  else{
                                                      Genralsaves?.progress = Float(0/100)
                                                  }
              
        
        let localsubstitutions = (localdic.value(forKey: "substitutions") as! NSNumber).floatValue
        let visitorsubstitutions = (visitordic.value(forKey: "substitutions") as! NSNumber).floatValue
        homeGenralsubstitues?.text = "\(Int(localsubstitutions))"
         visitorGenralsubstitues?.text = "\(Int(visitorsubstitutions))"
        
        if(localsubstitutions != 0 &&  visitorsubstitutions != 0 ){
               Genralsubstitutes?.progress = Float(localsubstitutions/(visitorsubstitutions + localsubstitutions))
                     
                                           }
                                           else{
                                               Genralsubstitutes?.progress = Float(0/100)
                                           }
       
        let localgoal_kick = (localdic.value(forKey: "goal_kick") as! NSNumber).floatValue
        let visitorgoal_kick = (visitordic.value(forKey: "goal_kick") as! NSNumber).floatValue
        homeGenralgoalkick?.text = "\(Int(localgoal_kick))"
         visitorGenralgoalkick?.text = "\(Int(visitorgoal_kick))"
        if(localgoal_kick != 0 &&  visitorgoal_kick != 0 ){
                   Genralgoalkick?.progress = Float(localgoal_kick/(visitorgoal_kick + localgoal_kick))
               }
               else{
                   Genralgoalkick?.progress = Float(0/100)
               }
        
        
        let localgoal_attempts = (localdic.value(forKey: "goal_attempts") as! NSNumber).floatValue
        let visitorgoal_attempts = (visitordic.value(forKey: "goal_attempts") as! NSNumber).floatValue
        homeGenralgoalattempts?.text = "\(Int(localgoal_attempts))"
         visitorGenralgoalattempts?.text = "\(Int(visitorgoal_attempts))"
        
        if(localgoal_attempts != 0 &&  visitorgoal_attempts != 0 ){
       Genralgoalattempts?.progress = Float(localgoal_attempts/(visitorgoal_attempts + localgoal_attempts))
                                    }
                                    else{
                                        Genralgoalattempts?.progress = Float(0/100)
                                    }
             
        
        
        let localfree_kick = (localdic.value(forKey: "free_kick") as! NSNumber).floatValue
        let visitorfree_kick = (visitordic.value(forKey: "free_kick") as! NSNumber).floatValue
               homeGenralfreekicks?.text = "\(Int(localfree_kick))"
                visitorGenralfreekicks?.text = "\(Int(visitorfree_kick))"
        if(localfree_kick != 0 &&  visitorfree_kick != 0 ){
         Genralfreekicks?.progress = Float(localfree_kick/(visitorfree_kick + localfree_kick))
                                     }
                                     else{
                                         Genralfreekicks?.progress = Float(0/100)
                                     }
              
        
        let localthrow_in = (localdic.value(forKey: "throw_in") as! NSNumber).floatValue
        let visitorthrow_in = (visitordic.value(forKey: "throw_in") as! NSNumber).floatValue
        homeGenralthrowin?.text = "\(Int(localthrow_in))"
         visitorGenralthrowin?.text = "\(Int(visitorthrow_in))"
        if(localthrow_in != 0 &&  visitorthrow_in != 0 ){
Genralthrowsin?.progress = Float(localthrow_in/(visitorthrow_in + localthrow_in))

                             }
                             else{
                                 Genralthrowsin?.progress = Float(0/100)
                             }
        
        
        let localball_safe = (localdic.value(forKey: "ball_safe") as! NSNumber).floatValue
        let visitorball_safe = (visitordic.value(forKey: "ball_safe") as! NSNumber).floatValue
        homeGenralballsafe?.text = "\(Int(localball_safe))"
         visitorGenralballsafe?.text = "\(Int(visitorball_safe))"
        if(localball_safe != 0 &&  visitorball_safe != 0 ){
                                  Genralballsafe?.progress = Float(localball_safe/(visitorball_safe + localball_safe))
                          

                      }
                      else{
                          Genralballsafe?.progress = Float(0/100)
                      }
       
        
        
    }
   
}
