//
//  TDOverviewViewController.swift
//  FootballFan
//
//  Created by Apple on 29/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class TDOverviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var Dropdownlabel: UILabel?
    @IBOutlet weak var Dropdownbut: UIButton?
    @IBOutlet weak var Dropdownimg: UIImageView?
    @IBOutlet weak var passac: UIProgressView?
    @IBOutlet weak var possession: UIProgressView?
    @IBOutlet weak var goalpro: UIProgressView?
    @IBOutlet weak var goalcon: UIProgressView?
    @IBOutlet weak var Drawlabel: UILabel?
    @IBOutlet weak var Winlabel: UILabel?
    @IBOutlet weak var Looseslabel: UILabel?
    @IBOutlet weak var popupView: UIView?
    @IBOutlet weak var poptable: UITableView?
    @IBOutlet weak var storytableview: UITableView?
    @IBOutlet weak var childView: UIView?
    @IBOutlet weak var lblmatchday: UILabel?
    @IBOutlet weak var hometeam: UILabel?
    @IBOutlet weak var visitteam: UILabel?
    @IBOutlet weak var imghometeam: UIImageView?
    @IBOutlet weak var imgvisitteam: UIImageView?
    @IBOutlet weak var lblstatus: UILabel?
    @IBOutlet weak var lbltime: UILabel?
    @IBOutlet weak var lblgoalvalue: UILabel?
    @IBOutlet weak var lblgoalconvalue: UILabel?
    @IBOutlet weak var lblpossessionvalue: UILabel?
    @IBOutlet weak var lblpassvalue: UILabel?
    var season_id  = 0
    var team_id  = 0
    var dicall: NSDictionary = NSDictionary()
    var Arrlige: [AnyObject] = []
    var Arrstanding: [AnyObject] = []
    var selecteddropdownindex: Int = 0
    var apd = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamapiCall()
        let longPressGesture_Showpopup:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showpopup(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture_Showpopup.delegate = self as? UIGestureRecognizerDelegate
        
        Dropdownlabel?.addGestureRecognizer(longPressGesture_Showpopup)
        Dropdownlabel?.isUserInteractionEnabled = true
        Drawlabel?.layer.masksToBounds = true;
        Drawlabel?.layer.borderWidth = 1.0
        Drawlabel?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        Drawlabel?.layer.cornerRadius = 17.0
        
        Winlabel?.layer.masksToBounds = true;
        Winlabel?.layer.borderWidth = 1.0
        Winlabel?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        Winlabel?.layer.cornerRadius = 17.0
        
        Looseslabel?.layer.masksToBounds = true;
        Looseslabel?.layer.borderWidth = 1.0
        Looseslabel?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor 
        Looseslabel?.layer.cornerRadius = 17.0
        poptable?.delegate = self
        poptable?.dataSource = self
        storytableview?.delegate = self
        storytableview?.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        //self.title = legname
        
    }
    @objc func Showpopup(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        popupView?.isHidden  = false
        poptable?.reloadData()
    }
    @IBAction func showpopup(){
        popupView?.isHidden  = false
        poptable?.reloadData()
    }
    func teamapiCall(){
        if ClassReachability.isConnectedToNetwork() {
//            let url = "http://ffapitest.ifootballfan.com:7001/Team/Season/Standing/468/16030"
            let url = "\(baseurl)/Team/Season/Standing/\(team_id)/\(season_id)"
            AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let status1: Bool = json["success"] as? Bool ?? false
                        if(status1){
                            if let dict = json["json"] as? NSDictionary {
                                self.dicall = dict
                                self.Arrlige = self.dicall.value(forKey: "league") as? [AnyObject] ?? []
                                self.Arrstanding = self.dicall.value(forKey: "standings") as? [AnyObject] ?? []
                                self.storytableview?.reloadData()
                                if(self.Arrlige.count > 0){
                                    let dict1 = self.Arrlige[0] as? NSDictionary
                                    self.Dropdownlabel?.text = dict1?.value(forKey: "name") as? String
                                    let  homelogo = dict1?.value(forKey: "logo_path") as? String
                                    let url = URL(string:homelogo ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg")!
                                    self.Dropdownimg?.af.setImage(withURL: url)
                                    self.UIUpdate()
                                }
                            }
                        }else{
                            self.childView?.isHidden = true
                        }
                    }
                case .failure(let error):
                    self.childView?.isHidden = true
                    break
                    // error handling
                }
            }
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( tableView == storytableview){
            return 30.0
        }else{
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if( tableView == storytableview){
            return "date" 
        }else{
            return "Match Events"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if( tableView == storytableview){
            let headerView:StandingHeader = storytableview!.dequeueReusableCell(withIdentifier: "StandingHeader") as! StandingHeader
            headerView.headername?.text = "Live Score"
            headerView.headerlabelHightConstraint2.constant = 0.0
            
            return headerView
        }
        else{
            //let headerView:EventHeader = eventtableview!.dequeueReusableCell(withIdentifier: "EventHeader") as! EventHeader
            // headerView.headername?.text = "Match Events"
            // headerView.headerlabelHightConstraint2.constant = 0.0
            
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        if( tableView == storytableview){
            
            return Arrstanding.count
        }else{
            return Arrlige.count
        }
        
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if( tableView == storytableview){
            let cell:StandingCell = storytableview!.dequeueReusableCell(withIdentifier: "StandingCell") as! StandingCell
            let dic = Arrstanding[indexPath.row] as! NSDictionary
            cell.teamName?.text = dic.value(forKey: "team_name") as? String
            let  homelogo = dic.value(forKey: "logo_path") as! String
            let url = URL(string:homelogo)!
            cell.imgtagright?.af.setImage(withURL: url)
            cell.Sno?.text = "\(dic.value(forKey: "position") as! Int)"
            let total = dic.value(forKey: "total") as! NSDictionary
            cell.GD?.text = "\(total.value(forKey: "goal_difference") as AnyObject)"
            cell.Pts?.text = "\(total.value(forKey: "points") as! Int)"
            let overall = dic.value(forKey: "overall") as! NSDictionary
            cell.D?.text = "\(overall.value(forKey: "draw") as! Int)"
            cell.pl?.text = "\(overall.value(forKey: "games_played") as! Int)"
            cell.L?.text = "\(overall.value(forKey: "lost") as! Int)"
            cell.W?.text = "\(overall.value(forKey: "won") as! Int)"
            //cell.dot?.layer.masksToBounds = true;
            //  cell.dot?.layer.borderWidth = 1.0
            //  cell.dot?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            // cell.dot?.layer.cornerRadius = 2.5
            
            
            return cell
        }else{
            let cell:teamlegeCell = poptable!.dequeueReusableCell(withIdentifier: "teamlegeCell") as! teamlegeCell
            let dic = Arrlige [indexPath.row] as! NSDictionary
            cell.headername?.text = dic.value(forKey: "name") as? String
            let  homelogo = dic.value(forKey: "logo_path") as! String
            
            let url = URL(string:homelogo)!
            
            cell.legimg?.af.setImage(withURL: url)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let dic = data[indexPath.row]
        
        
        if( tableView == poptable){
            popupView?.isHidden = true
            let dic = Arrlige[indexPath.row] as! NSDictionary
            selecteddropdownindex = indexPath.row
            Dropdownlabel?.text = dic.value(forKey: "name") as? String
            let  homelogo = dic.value(forKey: "logo_path") as! String
            
            let url = URL(string:homelogo)!
            season_id = dic.value(forKey: "season_id") as! Int
            Dropdownimg?.af.setImage(withURL: url)
            teamapiCall()
            
        }
        
    }
    @IBAction func seeldstanding () {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = dicall.value(forKey: "season_id") as AnyObject as! Int
        // myTeamsController.legname = dic.value(forKey: "legname") as! String
        //myTeamsController.dic = dic.value(forKey: "seasonStat") as! NSDictionary
        myTeamsController.tabatindex = 2
        show(myTeamsController, sender: self)
    }
    @IBAction func seematchday () {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = dicall.value(forKey: "season_id") as AnyObject as! Int
        // myTeamsController.legname = dic.value(forKey: "legname") as! String
        //myTeamsController.dic = dic.value(forKey: "seasonStat") as! NSDictionary
        myTeamsController.tabatindex = 0
        show(myTeamsController, sender: self)
    }
    func UIUpdate()  {
        if dicall.value(forKey: "stats") != nil{
            childView?.isHidden = false
            var statsdic: NSDictionary = NSDictionary()
            if apd.isNsnullOrNil(object: dicall.value(forKey: "stats") as AnyObject?)
            {
                childView?.isHidden = true
                // print("object is null or nil")
            }
            else
            {
                if let dicStats = dicall.value(forKey: "stats") as? NSDictionary {
                    statsdic = dicStats
                    if(statsdic.count>0){
                        let win = statsdic.value(forKey: "win") as? NSDictionary
                        Winlabel?.text = "\(win?.value(forKey: "total") as? Int ?? 0)"
                        let draw = statsdic.value(forKey: "draw") as? NSDictionary
                        Drawlabel?.text = "\(draw?.value(forKey: "total") as? Int ?? 0)"
                        let lost = statsdic.value(forKey: "lost") as! NSDictionary
                        Looseslabel?.text = "\(lost.value(forKey: "total") as? Int ?? 0)"
                        if let dic2 = Arrlige[selecteddropdownindex] as? NSDictionary {
                            let dict2 = dic2
                            if let fixtureArray = dict2.value(forKey: "fixture") as? NSArray {
                                let fixture = fixtureArray
                                if(fixture.count>0){
                                    if let dict = fixture[0] as? NSDictionary {
                                        let dict = dict
                                        if let currentRound = dict.value(forKey: "currentRound") as? NSDictionary {
                                            let currentRound = currentRound
                                            lblmatchday?.text = "MatchDay \(currentRound.value(forKey: "name") as? Int ?? 0)"
                                            if let localTeam = dict.value(forKey: "localTeam") {
                                                if let localTeamDetil = (localTeam as AnyObject).value(forKey: "data") {
                                                        let  homename = (localTeamDetil as AnyObject).value(forKey: "name") as? String
                                                        let  homelogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as? String ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                                                        hometeam?.text = homename
                                                        let url = URL(string:homelogo)!
                                                        imghometeam?.af.setImage(withURL: url)
                                                    
                                                }}
                                            if let visitorTeam = dict.value(forKey: "visitorTeam") {
                                                if let localTeamDetil = (visitorTeam as AnyObject).value(forKey: "data") {
                                                    if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                                        let visitorname = name as? String
                                                        let visitorlogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as? String ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                                                        visitteam?.text = visitorname
                                                        let url1 = URL(string:visitorlogo)!
                                                        imgvisitteam?.af.setImage(withURL: url1 )
                                                    }}}
                                            let calendar = Calendar(identifier: .gregorian)
                                            let fixturetime:Int64 = dict.value(forKey: "fixtureTime") as? Int64 ?? 0
                                            let startOfDate = calendar.startOfDay(for: Date())
                                            let timeinterval1 = startOfDate.timeIntervalSince1970 * 1000
                                            let time = Int64(timeinterval1.rounded())
                                            if(fixturetime == time){
                                                lblstatus?.isHidden = false
                                                lblstatus?.text = "Today"
                                            }else{
                                                lblstatus?.isHidden = true
                                            }
                                            if let scoredic = dict.value(forKey: "scores") {
                                                let homescore = (scoredic as AnyObject).value(forKey: "localteam_score") as? Int
                                                let visitorscore = (scoredic as AnyObject).value(forKey: "visitorteam_score") as? Int
                                                lbltime?.text = "\(homescore ?? 0) : \(visitorscore ?? 0)"
                                            }
                                            if let avggoal = statsdic.value(forKey: "avg_goals_per_game_scored") as? NSDictionary {
                                                let goalprogress = avggoal.value(forKey: "total") as? Float
                                                goalpro?.progress = (goalprogress ?? 0.0)/100
                                                lblgoalvalue?.text = "\(goalprogress ?? 0.0)"
                                            } else {
                                                goalpro?.progress = 0.0
                                                lblgoalvalue?.text = "\("0.0")"
                                            }
                                            
                                            if let avggoalcon = statsdic.value(forKey: "avg_goals_per_game_conceded") as? NSDictionary {
                                                let goalconprogress = (avggoalcon.value(forKey: "total") as? NSNumber)?.floatValue
                                                lblgoalconvalue?.text = "\(goalconprogress ?? 0.0)"
                                                goalcon?.progress = (goalconprogress ?? 0.0)/100
                                            } else {
                                                lblgoalconvalue?.text = "\("0.0")"
                                                goalcon?.progress = 0.0
                                            }
                                        
                                            let possessionvalue = Float(statsdic.value(forKey: "avg_ball_possession_percentage") as? String ?? "0.0")
                                            lblpossessionvalue?.text = "\(String(describing: possessionvalue!))"
                                            possession?.progress = possessionvalue!/100
                                        }
                                    }
                                } else {
                                    lblmatchday?.text = "A"
                                    hometeam?.text = ConstantString.notAvailable
                                    let url = URL(string:"https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg")!
                                    imghometeam?.af.setImage(withURL: url)
                                    visitteam?.text = ConstantString.notAvailable
                                    imgvisitteam?.af.setImage(withURL: url )
                                    lbltime?.text = "\(0) : \(0)"
                                }
                            } else {
                                
                            }
                        }
                    }else{
                        childView?.isHidden = true
                    }
                }
                
            }
            
        }else{
            childView?.isHidden = true
        }
    }
    
    @IBAction func seeAllMatchesAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = season_id
        myTeamsController.tabatindex = 0
        show(myTeamsController, sender: self)
    }
    
    
    @IBAction func seeAllFixtureStats(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = season_id
        myTeamsController.tabatindex = 2
        show(myTeamsController, sender: self)
    }
    
    @IBAction func seeAllTeamStatsAction(_ sender: Any) {
    }
}
