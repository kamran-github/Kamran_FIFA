//
//  TDstatsViewController.swift
//  FootballFan
//
//  Created by Apple on 04/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class TDstatsViewController: UIViewController {
    var season_id = 0
    
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    @IBOutlet weak var lblwintotal: UILabel?
    @IBOutlet weak var lblwinhome: UILabel?
    @IBOutlet weak var lblwinaway: UILabel?
    
    @IBOutlet weak var lbldrawtotal: UILabel?
    @IBOutlet weak var lbldrawhome: UILabel?
    @IBOutlet weak var lbldrawaway: UILabel?
    
    @IBOutlet weak var lbllossestotal: UILabel?
    @IBOutlet weak var lbllosseshome: UILabel?
    @IBOutlet weak var lbllossesaway: UILabel?
    
    @IBOutlet weak var lblgoalfortotal: UILabel?
    @IBOutlet weak var lblgoalforhome: UILabel?
    @IBOutlet weak var lblgoalforaway: UILabel?
    
    @IBOutlet weak var lblgoalasistotal: UILabel?
    @IBOutlet weak var lblgoalasishome: UILabel?
    @IBOutlet weak var lblgoalasisaway: UILabel?
    
    @IBOutlet weak var lblsheettotal: UILabel?
    @IBOutlet weak var lblsheethome: UILabel?
    @IBOutlet weak var lblsheetaway: UILabel?
    
    @IBOutlet weak var lblfaildtotal: UILabel?
    @IBOutlet weak var lblfaildhome: UILabel?
    @IBOutlet weak var lblfaildaway: UILabel?
    
    @IBOutlet weak var lblavg_goals_per_game_scored: UILabel?
    @IBOutlet weak var lblavg_goals_per_game_conceded: UILabel?
    @IBOutlet weak var lblavg_first_goal_scored: UILabel?
    @IBOutlet weak var lblavg_first_goal_conceded: UILabel?
    @IBOutlet weak var lblattacks: UILabel?
    @IBOutlet weak var lbldangerous_attacks: UILabel?
    @IBOutlet weak var lblavg_ball_possession_percentage: UILabel?
    @IBOutlet weak var lblfouls: UILabel?
    @IBOutlet weak var lblavg_fouls_per_game: UILabel?
    @IBOutlet weak var lbloffsides: UILabel?
    @IBOutlet weak var lblredcards: UILabel?
    @IBOutlet weak var lblyellowcards: UILabel?
    @IBOutlet weak var lblshots_blocked: UILabel?
    @IBOutlet weak var lblshots_off_target: UILabel?
    @IBOutlet weak var lblavg_shots_off_target_per_game: UILabel?
    @IBOutlet weak var lblshots_on_target: UILabel?
    @IBOutlet weak var lblavg_shots_on_target_per_game: UILabel?
    @IBOutlet weak var lblavg_corners: UILabel?
    @IBOutlet weak var lbltotal_corners: UILabel?
    @IBOutlet weak var childView: UIView?
    
    var arrstanding: [AnyObject] = []
    var dicall: NSDictionary = NSDictionary()
    var team_id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        teamapiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func teamapiCall(){
        if ClassReachability.isConnectedToNetwork() {
            //Changed Sept
//            let url = "\(baseurl)/Team/Season/\(468)/\(16030)"
            let url = "\(baseurl)/Team/Season/\(team_id)/\(season_id)"
            AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let status1: Bool = json["success"] as! Bool
                        if(status1){
                            if let jsonDic  = json["json"] as? NSDictionary {
                               self.dicall = jsonDic
                            }
                            self.UIUpdate()
                        }else{
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                    
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
    func UIUpdate()  {
        if dicall.value(forKey: "stats") != nil{
            childView?.isHidden = false
            if apd.isNsnullOrNil(object: dicall.value(forKey: "stats") as AnyObject?)
            {
                childView?.isHidden = true
                //print("object is null or nil")
            }
            else
            {
                //print("object is not  null or nil")
                let statsdic = dicall.value(forKey: "stats") as? NSDictionary
                if(statsdic?.count ?? 0>0){
  
                    let win = statsdic?.value(forKey: "win") as? NSDictionary
                    lblwintotal?.text = "\(win?.value(forKey: "total") as? Int ?? 0)"
                    lblwinhome?.text = "\(win?.value(forKey: "home") as? Int ?? 0)"
                    lblwinaway?.text = "\(win?.value(forKey: "away") as? Int ?? 0)"
    
                    let draw = statsdic?.value(forKey: "draw") as? NSDictionary
                    lbldrawtotal?.text = "\(draw?.value(forKey: "total") as? Int ?? 0)"
                    lbldrawhome?.text = "\(draw?.value(forKey: "home") as? Int ?? 0)"
                    lbldrawaway?.text = "\(draw?.value(forKey: "away") as? Int ?? 0)"
                
                    let lost = statsdic?.value(forKey: "lost") as? NSDictionary
                    lbllossestotal?.text = "\(lost?.value(forKey: "total") as? Int ?? 0)"
                    lbllosseshome?.text = "\(lost?.value(forKey: "home") as? Int ?? 0)"
                    lbllossesaway?.text = "\(lost?.value(forKey: "away") as? Int ?? 0)"
                    
                    let goals_for = statsdic?.value(forKey: "goals_for") as? NSDictionary
                    lblgoalfortotal?.text = "\(goals_for?.value(forKey: "total") as? Int ?? 0)"
                    lblgoalforhome?.text = "\(goals_for?.value(forKey: "home") as? Int ?? 0)"
                    lblgoalforaway?.text = "\(goals_for?.value(forKey: "away") as? Int ?? 0)"
                    
                    let goals_against = statsdic?.value(forKey: "goals_against") as? NSDictionary
                    lblgoalasistotal?.text = "\(goals_against?.value(forKey: "total") as? Int ?? 0)"
                    lblgoalasishome?.text = "\(goals_against?.value(forKey: "home") as? Int ?? 0)"
                    lblgoalasisaway?.text = "\(goals_against?.value(forKey: "away") as? Int ?? 0)"
                  
                    let clean_sheet = statsdic?.value(forKey: "clean_sheet") as? NSDictionary
                    lblsheettotal?.text = "\(clean_sheet?.value(forKey: "total") as? Int ?? 0)"
                    lblsheethome?.text = "\(clean_sheet?.value(forKey: "home") as? Int ?? 0)"
                    lblsheetaway?.text = "\(clean_sheet?.value(forKey: "away") as? Int ?? 0)"
                
                    let failed_to_score = statsdic?.value(forKey: "failed_to_score") as? NSDictionary
                    lblfaildtotal?.text = "\(failed_to_score?.value(forKey: "total") as? Int ?? 0)"
                    lblfaildhome?.text = "\(failed_to_score?.value(forKey: "home") as? Int ?? 0)"
                    lblfaildaway?.text = "\(failed_to_score?.value(forKey: "away") as? Int ?? 0)"
                  
                    let avg_goals_per_game_scored = statsdic?.value(forKey: "avg_goals_per_game_scored") as? NSDictionary
                    lblavg_goals_per_game_scored?.text = "\(avg_goals_per_game_scored?.value(forKey: "total") as? Int ?? 0)"
                  
                    let avg_goals_per_game_conceded = statsdic?.value(forKey: "avg_goals_per_game_conceded") as? NSDictionary
                    lblavg_goals_per_game_conceded?.text = "\(avg_goals_per_game_conceded?.value(forKey: "total") as AnyObject)"
                
                    let avg_first_goal_scored = statsdic?.value(forKey: "avg_first_goal_scored") as? NSDictionary
                    lblavg_first_goal_scored?.text = "\(avg_first_goal_scored?.value(forKey: "total") as AnyObject)"
                
                    let avg_first_goal_conceded = statsdic?.value(forKey: "avg_first_goal_conceded") as? NSDictionary
                    lblavg_first_goal_conceded?.text = "\(avg_first_goal_conceded?.value(forKey: "total") as AnyObject)"
                    lblattacks?.text = "\(statsdic?.value(forKey: "attacks") as? Int ?? 0)"
                    lbldangerous_attacks?.text = "\(statsdic?.value(forKey: "dangerous_attacks") as? Int ?? 0)"
                    lblavg_ball_possession_percentage?.text = "\(statsdic?.value(forKey: "avg_ball_possession_percentage") as AnyObject)"
                    lblfouls?.text = "\(statsdic?.value(forKey: "fouls") as? Int ?? 0)"
                    lblavg_fouls_per_game?.text = "\(statsdic?.value(forKey: "avg_fouls_per_game") as AnyObject)"
                    lbloffsides?.text = "\(statsdic?.value(forKey: "offsides") as? Int ?? 0)"
                    lblredcards?.text = "\(statsdic?.value(forKey: "redcards") as? Int ?? 0)"
                    lblyellowcards?.text = "\(statsdic?.value(forKey: "yellowcards") as? Int ?? 0)"
                    lblshots_blocked?.text = "\(statsdic?.value(forKey: "shots_blocked") as? Int ?? 0)"
                    lblshots_off_target?.text = "\(statsdic?.value(forKey: "shots_off_target") as? Int ?? 0)"
                    lblavg_shots_off_target_per_game?.text = "\(statsdic?.value(forKey: "avg_shots_off_target_per_game") as AnyObject)"
                    lblshots_on_target?.text = "\(statsdic?.value(forKey: "shots_on_target") as? Int ?? 0)"
                    lblavg_shots_on_target_per_game?.text = "\(statsdic?.value(forKey: "avg_shots_on_target_per_game") as AnyObject)"
                    lblavg_corners?.text = "\(statsdic?.value(forKey: "avg_corners") as AnyObject)"
                    lbltotal_corners?.text = "\(statsdic?.value(forKey: "total_corners") as? Int ?? 0)"
                    
                }else{
                    childView?.isHidden = true
                }
            }
            
        }else{
            childView?.isHidden = true
        }
    }
}
