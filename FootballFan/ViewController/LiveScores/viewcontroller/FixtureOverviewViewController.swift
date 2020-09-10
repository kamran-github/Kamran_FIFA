//
//  FixtureOverviewViewController.swift
//  FootballFan
//
//  Created by Apple on 25/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class FixtureOverviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var hometeam: UILabel?
    @IBOutlet weak var visitteam: UILabel?
    @IBOutlet weak var imghometeam: UIImageView?
    @IBOutlet weak var imgvisitteam: UIImageView?
    @IBOutlet weak var lblstatus: UILabel?
    @IBOutlet weak var refereename: UILabel?
    @IBOutlet weak var livescoretableview: UITableView?
    @IBOutlet weak var eventtableview: UITableView?
    @IBOutlet weak var lbltime: UILabel?
    @IBOutlet weak var homeview:UIView?
    @IBOutlet weak var visitorview:UIView?
    @IBOutlet weak var Genralpossession: UIProgressView?
    @IBOutlet weak var homeGenralpossession: UILabel?
    @IBOutlet weak var visitorGenralpossession: UILabel?
    @IBOutlet weak var childviewHeight: NSLayoutConstraint!
    
    
    var dic: NSDictionary = NSDictionary()
    var arrevent: [AnyObject] = []
    var homeId:Int = 0
    var visitorId:Int = 0
    var season_id: AnyObject  = 0 as AnyObject
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
        refereename?.text = "VIPIN" //refereedata.value(forKey: "fullname") as? String
        livescoretableview?.delegate = self
        livescoretableview?.dataSource = self
        eventtableview?.delegate = self
        eventtableview?.dataSource = self
        eventtableview?.isScrollEnabled = false
        livescoretableview?.isScrollEnabled = false
        let events = dic.value(forKey: "events") as! NSDictionary
        arrevent = events.value(forKey: "data") as! [AnyObject]
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
            } else if(status == "LIVE"){
                lblstatus?.text = "Live"
                lbltime?.text = "\(homescore) : \(visitorscore)"
                //lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
            } else if(status == "NS"){
                lblstatus?.text = "Time"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                if let mili = dic.value(forKey: "fixtureTime") {
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
        
        let dicstats = dic.value(forKey: "stats") as! NSDictionary
        let data = dicstats.value(forKey: "data") as! NSArray
        if(data.count>0){
            let localdic = data[0] as! NSDictionary
            let visitordic = data[1] as! NSDictionary
            let localpossessiontime = (localdic.value(forKey: "possessiontime") as! NSNumber).floatValue
            let visitorpossessiontime = (visitordic.value(forKey: "possessiontime") as! NSNumber).floatValue
            homeGenralpossession?.text = "\(Int(localpossessiontime))%"
            visitorGenralpossession?.text = "\(Int(visitorpossessiontime))%"
            if(localpossessiontime != 0 &&  visitorpossessiontime != 0 ){
                Genralpossession?.progress = Float(localpossessiontime/(visitorpossessiontime + localpossessiontime))
            }else{
                Genralpossession?.progress = Float(0/100)
            }
        }else{
            homeGenralpossession?.text = "0"
            visitorGenralpossession?.text = "0"
            Genralpossession?.progress = Float(0/100)
        }
        let eventheader = 30
        let totelheight = 450 + (arrevent.count * 72) + eventheader
        childviewHeight.constant = CGFloat(totelheight)
        let homeTapGesture = UITapGestureRecognizer()
        homeTapGesture.addTarget(self, action: #selector(homeTouched(_:)))
        homeview?.addGestureRecognizer(homeTapGesture)
        homeview?.isUserInteractionEnabled = true
        let visitorTapGesture = UITapGestureRecognizer()
        visitorTapGesture.addTarget(self, action: #selector(visitorTouched(_:)))
        visitorview?.addGestureRecognizer(visitorTapGesture)
        visitorview?.isUserInteractionEnabled = true
    }
    @IBAction func seefdstate () {
        //self.setindex()
        let RefreshSubTabBadgeCount = Notification.Name("selecttab3")
        NotificationCenter.default.post(name: RefreshSubTabBadgeCount, object: nil)
    }
    @IBAction func seeldstanding () {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = dic.value(forKey: "season_id") as AnyObject
        // myTeamsController.legname = dic.value(forKey: "legname") as! String
        //myTeamsController.dic = dic.value(forKey: "seasonStat") as! NSDictionary
        myTeamsController.tabatindex = 2
        show(myTeamsController, sender: self)
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
 
}


extension FixtureOverviewViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 30.0
     }
     
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         
         //let dic = appDelegate().arrStanding[section] as! NSDictionary
         //let date = dic.value(forKey: "date")
         if( tableView == livescoretableview){
             return "date" as? String
         }else{
             return "Match Events"
         }
     }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         if( tableView == livescoretableview){
             let headerView:StandingHeader = livescoretableview!.dequeueReusableCell(withIdentifier: "StandingHeader") as! StandingHeader
             headerView.headername?.text = "Live Score"
             headerView.headerlabelHightConstraint2.constant = 0.0
             
             return headerView
         }
         else{
             let headerView:EventHeader = eventtableview!.dequeueReusableCell(withIdentifier: "EventHeader") as! EventHeader
             headerView.headername?.text = "Match Events"
             // headerView.headerlabelHightConstraint2.constant = 0.0
             
             return headerView
         }
         
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         // let arrrow = resultArry[section] as! NSArray
         if( tableView == livescoretableview){
             
             return 2
         }else{
             return arrevent.count
         }
         
         
     }
     /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 30.0
      }*/
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if( tableView == livescoretableview){
             let cell:StandingCell = livescoretableview!.dequeueReusableCell(withIdentifier: "StandingCell") as! StandingCell
             if(indexPath.row == 0){
                 let localStandings = dic.value(forKey: "localStandings") as! NSDictionary
                 cell.teamName?.text = localStandings.value(forKey: "team_name") as? String
                 let  homelogo = localStandings.value(forKey: "logo_path") as! String
                 
                 let url = URL(string:homelogo)!
                 
                 cell.imgtagright?.af.setImage(withURL: url)
                 cell.Sno?.text = "\(localStandings.value(forKey: "position") as! Int)"
                 let total = localStandings.value(forKey: "total") as! NSDictionary
                 cell.GD?.text = "\(total.value(forKey: "goal_difference") as AnyObject)"
                 cell.Pts?.text = "\(total.value(forKey: "points") as! Int)"
                 let overall = localStandings.value(forKey: "overall") as! NSDictionary
                 cell.D?.text = "\(overall.value(forKey: "draw") as! Int)"
                 cell.pl?.text = "\(overall.value(forKey: "games_played") as! Int)"
                 cell.L?.text = "\(overall.value(forKey: "lost") as! Int)"
                 cell.W?.text = "\(overall.value(forKey: "won") as! Int)"
                 
             }
             else if(indexPath.row == 1){
                 let visitorStandings = dic.value(forKey: "visitorStandings") as! NSDictionary
                 cell.teamName?.text = visitorStandings.value(forKey: "team_name") as? String
                 let  homelogo = visitorStandings.value(forKey: "logo_path") as! String
                 
                 let url = URL(string:homelogo)!
                 
                 cell.imgtagright?.af.setImage(withURL: url)
                 cell.Sno?.text = "\(visitorStandings.value(forKey: "position") as! Int)"
                 let total = visitorStandings.value(forKey: "total") as! NSDictionary
                 //Int64(jidsDict.value(forKey: "lastactivitytime") as! String)
                 cell.GD?.text = "\(total.value(forKey: "goal_difference") as AnyObject)"
                 cell.Pts?.text = "\(total.value(forKey: "points") as! Int)"
                 let overall = visitorStandings.value(forKey: "overall") as! NSDictionary
                 cell.D?.text = "\(overall.value(forKey: "draw") as! Int)"
                 cell.pl?.text = "\(overall.value(forKey: "games_played") as! Int)"
                 cell.L?.text = "\(overall.value(forKey: "lost") as! Int)"
                 cell.W?.text = "\(overall.value(forKey: "won") as! Int)"
             }
             
             return cell
         }else{
             let cell:EventCell = eventtableview!.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
             let dic = arrevent [indexPath.row] as! NSDictionary
             
             let id = Int(dic.value(forKey: "team_id") as! String)
             if(homeId == id as! Int){
                 cell.homeview?.isHidden = false
                 cell.visitorview?.isHidden = true
                 cell.headlineleft?.text = dic.value(forKey: "player_name") as? String
                 if let scores = dic.value(forKey: "related_player_name") {
                     cell.Discriptionleft?.text = scores as? String ?? ""
                 }
                 else{
                     cell.Discriptionleft?.text = ""
                 }
                 cell.minuteleft?.text = "\(dic.value(forKey: "minute") as! Int)'"
                 let type = dic.value(forKey: "type") as! String
                 if(type == "yellowcard"){
                     cell.imgtagleft?.image = UIImage(named: "yellowcard")
                 }
                 else if(type == "redcard"){
                     cell.imgtagleft?.image = UIImage(named: "redcard")
                 }
                 else if(type == "substitution"){
                     cell.imgtagleft?.image = UIImage(named: "substitution_home")
                     
                 }
                 else if(type == "goal"){
                     cell.imgtagleft?.image = UIImage(named: "goal")
                 }
             }else{
                 cell.homeview?.isHidden = true
                 cell.visitorview?.isHidden = false
                 cell.headlineright?.text = dic.value(forKey: "player_name") as? String
                 if let scores = dic.value(forKey: "related_player_name") {
                     cell.Discriptionright?.text = scores as? String ?? ""
                 }
                 else{
                     cell.Discriptionright?.text = ""
                 }
                 let type = dic.value(forKey: "type") as! String
                 if(type == "yellowcard"){
                     cell.imgtagright?.image = UIImage(named: "yellowcard")
                 }
                 else if(type == "redcard"){
                     cell.imgtagright?.image = UIImage(named: "redcard")
                 }
                 else if(type == "substitution"){
                     cell.imgtagright?.image = UIImage(named: "substitution_visitor")
                     // UIView.animate(withDuration: 0.2, animations: {
                     //  cell.imgtagright?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                     // })
                 }
                 else if(type == "goal"){
                     cell.imgtagright?.image = UIImage(named: "goal")
                 }
                 cell.minuteright?.text = "\(dic.value(forKey: "minute") as! Int)'"
             }
             
             return cell
         }
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // let dic = data[indexPath.row]
  
     }
     
}
