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
    var season_id = 0
    var fixtureOverViewData : Fixture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let localTeam = fixtureOverViewData?.localTeam {
            if let localTeamDetil = localTeam.data {
                if let name = localTeamDetil.name{
                    let  homelogo = localTeamDetil.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                    hometeam?.text = name
                    let url = URL(string:homelogo)!
                    homeId = localTeamDetil.id ?? 0
                    imghometeam?.af.setImage(withURL: url)
                }
            }}
        
        if let visitorTeam = fixtureOverViewData?.visitorTeam {
            if let visitorTeamDetil = visitorTeam.data {
                if let name = visitorTeamDetil.name{
                    let visitorlogo = visitorTeamDetil.logo_path  ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                    visitteam?.text = name
                    let url1 = URL(string:visitorlogo)!
                    imgvisitteam?.af.setImage(withURL: url1 )
                    visitorId = visitorTeamDetil.id ?? 0
                }}}
        
        lbltime?.text = "\(fixtureOverViewData?.scores?.localteam_score ?? 0) : \(fixtureOverViewData?.scores?.visitorteam_score ?? 0)"
        refereename?.text = fixtureOverViewData?.referee?.data?.fullname ?? ConstantString.notAvailable
        livescoretableview?.delegate = self
        livescoretableview?.dataSource = self
        eventtableview?.delegate = self
        eventtableview?.dataSource = self
        eventtableview?.isScrollEnabled = false
        livescoretableview?.isScrollEnabled = false
        var homescore = 0
        var visitorscore = 0
        if let scoredic = fixtureOverViewData?.scores {
            homescore = scoredic.localteam_score ?? 0
            visitorscore = scoredic.visitorteam_score ?? 0
            lbltime?.text = "\(homescore) : \(visitorscore)"
        }
        if let status = fixtureOverViewData?.time {
            let status = status.status ?? ConstantString.notAvailable
            if(status == "FT"){
                lblstatus?.text = "Final Score"
                lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
                lbltime?.text = "\(homescore) : \(visitorscore)"
            } else if(status == "LIVE"){
                lblstatus?.text = "Live"
                lbltime?.text = "\(homescore) : \(visitorscore)"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
            } else if(status == "NS"){
                lblstatus?.text = "Time"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                if let mili = fixtureOverViewData?.fixtureTime {
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
        
        if(fixtureOverViewData?.stats?.data?.count ?? 0>0){
            let localpossessiontime =  (fixtureOverViewData?.stats?.data![0].possessiontime as NSNumber?)?.floatValue
            let visitorpossessiontime = (fixtureOverViewData?.stats?.data![1].possessiontime as NSNumber?)?.floatValue
            homeGenralpossession?.text = "\(Int(localpossessiontime ?? 0))%"
            visitorGenralpossession?.text = "\(Int(visitorpossessiontime ?? 0))%"
            if(localpossessiontime != 0 &&  visitorpossessiontime != 0 ){
                let sum = (visitorpossessiontime ?? 0) + (localpossessiontime ?? 0)
                let result = (localpossessiontime ?? 0)/sum
                Genralpossession?.progress = result
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
        myTeamsController.season_id = fixtureOverViewData?.season_id ?? 0
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
                
                cell.teamName?.text = fixtureOverViewData?.localStandings?.team_name ?? ConstantString.notAvailable
                let  homelogo = fixtureOverViewData?.localStandings?.logo_path  ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                
                let url = URL(string:homelogo)!
                
                cell.imgtagright?.af.setImage(withURL: url)
                cell.Sno?.text = String(fixtureOverViewData?.localStandings?.position ?? 0)
                cell.GD?.text = "\(fixtureOverViewData?.localStandings?.total?.goal_difference ?? "0")"
                cell.Pts?.text = "\(fixtureOverViewData?.localStandings?.total?.points ?? 0)"
                cell.D?.text = "\(fixtureOverViewData?.localStandings?.overall?.draw ?? 0)"
                cell.pl?.text = "\(fixtureOverViewData?.localStandings?.overall?.games_played ?? 0)"
                cell.L?.text = "\((fixtureOverViewData?.localStandings?.overall?.draw ?? 0))"
                cell.W?.text = "\((fixtureOverViewData?.localStandings?.overall?.won ?? 0))"
                
            } else if(indexPath.row == 1) {
                cell.teamName?.text = fixtureOverViewData?.visitorStandings?.team_name ?? ConstantString.notAvailable
                let  homelogo = fixtureOverViewData?.visitorStandings?.logo_path  ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                let url = URL(string:homelogo)!
                cell.imgtagright?.af.setImage(withURL: url)
                cell.Sno?.text = String(fixtureOverViewData?.visitorStandings?.position ?? 0)
                cell.GD?.text = "\(fixtureOverViewData?.visitorStandings?.total?.goal_difference ?? "0")"
                cell.Pts?.text = "\(fixtureOverViewData?.visitorStandings?.total?.points ?? 0)"
                cell.D?.text = "\(fixtureOverViewData?.visitorStandings?.overall?.draw ?? 0)"
                cell.pl?.text = "\(fixtureOverViewData?.visitorStandings?.overall?.games_played ?? 0)"
                cell.L?.text = "\((fixtureOverViewData?.visitorStandings?.overall?.draw ?? 0))"
                cell.W?.text = "\((fixtureOverViewData?.visitorStandings?.overall?.won ?? 0))"
            }
            return cell
        }else{
            let cell:EventCell = eventtableview!.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            
            
            let id = fixtureOverViewData?.events?.data?[indexPath.row].team_id
            if(homeId == id as! Int){
                cell.homeview?.isHidden = false
                cell.visitorview?.isHidden = true
                cell.headlineleft?.text = fixtureOverViewData?.events?.data?[indexPath.row].player_name
                if let scores = fixtureOverViewData?.events?.data?[indexPath.row].related_player_name {
                    cell.Discriptionleft?.text = scores
                }
                else{
                    cell.Discriptionleft?.text = ""
                }
                cell.minuteleft?.text = "\(fixtureOverViewData?.events?.data?[indexPath.row].minute ?? 0)'"
                let type = fixtureOverViewData?.events?.data?[indexPath.row].type
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
                cell.headlineright?.text = fixtureOverViewData?.events?.data?[indexPath.row].player_name
                if let scores = fixtureOverViewData?.events?.data?[indexPath.row].related_player_name  {
                    cell.Discriptionright?.text = scores
                }
                else{
                    cell.Discriptionright?.text = ""
                }
                let type = fixtureOverViewData?.events?.data?[indexPath.row].type
                if(type == "yellowcard"){
                    cell.imgtagright?.image = UIImage(named: "yellowcard")
                }
                else if(type == "redcard"){
                    cell.imgtagright?.image = UIImage(named: "redcard")
                }
                else if(type == "substitution"){
                    cell.imgtagright?.image = UIImage(named: "substitution_visitor")
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
        
    }
    
}
