//
//  LDsateViewController.swift
//  FootballFan
//
//  Created by Apple on 11/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class LDsateViewController: UIViewController {
    
    // @IBOutlet weak var storytableview: UITableView?
    @IBOutlet weak var number_of_clubs: UILabel?
    @IBOutlet weak var number_of_matches: UILabel?
    @IBOutlet weak var number_of_matches_played: UILabel?
    @IBOutlet weak var matches_both_teams_scored: UILabel?
    @IBOutlet weak var draw_percentage: UILabel?
    @IBOutlet weak var goal_scored_every_minutes: UILabel?
    @IBOutlet weak var avg_goals_per_match: UILabel?
    @IBOutlet weak var avg_corners_per_match: UILabel?
    @IBOutlet weak var avg_player_rating: UILabel?
    @IBOutlet weak var number_of_goals: UILabel?
    
    @IBOutlet weak var goals_scoredAll: UILabel?
    @IBOutlet weak var goals_scoredAway: UILabel?
    @IBOutlet weak var goals_scoredHome: UILabel?
    
    @IBOutlet weak var goals_concededAll: UILabel?
    @IBOutlet weak var goals_concededAway: UILabel?
    @IBOutlet weak var goals_concededHome: UILabel?
    
    
    @IBOutlet weak var winpercentageAll: UILabel?
    @IBOutlet weak var winpercentageAway: UILabel?
    @IBOutlet weak var winpercentageHome: UILabel?
    
    @IBOutlet weak var defeatpercentageAll: UILabel?
    @IBOutlet weak var defeatpercentageAway: UILabel?
    @IBOutlet weak var defeatpercentageHome: UILabel?
    
    @IBOutlet weak var progress0_15: UIProgressView?
    @IBOutlet weak var progress15_30: UIProgressView?
    @IBOutlet weak var progress30_45: UIProgressView?
    @IBOutlet weak var progress45_60: UIProgressView?
    @IBOutlet weak var progress60_75: UIProgressView?
    @IBOutlet weak var progress75_90: UIProgressView?
    @IBOutlet weak var progress0_15value: UILabel?
    @IBOutlet weak var progress15_30value: UILabel?
    @IBOutlet weak var progress30_45value: UILabel?
    @IBOutlet weak var progress45_60value: UILabel?
    @IBOutlet weak var progress60_75value: UILabel?
    @IBOutlet weak var progress75_90value: UILabel?
    
    @IBOutlet weak var number_of_yellowcards: UILabel?
    @IBOutlet weak var number_of_yellowredcards: UILabel?
    @IBOutlet weak var number_of_redcards: UILabel?
    @IBOutlet weak var avg_yellowredcards_per_match: UILabel?
    @IBOutlet weak var avg_redcards_per_match: UILabel?
    @IBOutlet weak var avg_yellowcards_per_match: UILabel?
    @IBOutlet weak var childview: UIView?
    
    var season_id: AnyObject = 0 as AnyObject
    var dic: NSDictionary = NSDictionary()
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    var arrstanding: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUidate()
        print(dic)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func setUidate()  {
        if(dic.count>0){
            let data = dic.value(forKey: "data") as! NSDictionary
            number_of_clubs?.text = "\(data.value(forKey: "number_of_clubs") as AnyObject)"
            number_of_matches?.text = "\(data.value(forKey: "number_of_matches") as AnyObject)"
            matches_both_teams_scored?.text = "\(data.value(forKey: "matches_both_teams_scored") as AnyObject)"
            number_of_matches_played?.text = "\(data.value(forKey: "number_of_matches_played") as AnyObject)"
            draw_percentage?.text = "\(data.value(forKey: "draw_percentage") as AnyObject) %"
            goal_scored_every_minutes?.text = "\(data.value(forKey: "goal_scored_every_minutes") as AnyObject)"
            avg_goals_per_match?.text = "\(data.value(forKey: "avg_goals_per_match") as AnyObject)"
            avg_corners_per_match?.text = "\(data.value(forKey: "avg_corners_per_match") as AnyObject)"
            avg_player_rating?.text = "\(data.value(forKey: "avg_player_rating") as AnyObject)"
            number_of_goals?.text = "\(data.value(forKey: "number_of_goals") as AnyObject)"
            let goals_scored = data.value(forKey: "goals_scored") as! NSDictionary
            goals_scoredAll?.text = "\(goals_scored.value(forKey: "all") as AnyObject)"
            goals_scoredAway?.text = "\(goals_scored.value(forKey: "away") as AnyObject)"
            goals_scoredHome?.text = "\(goals_scored.value(forKey: "home") as AnyObject)"
            
            let goals_conceded = data.value(forKey: "goals_conceded") as! NSDictionary
            goals_concededAll?.text = "\(goals_conceded.value(forKey: "all") as AnyObject)"
            goals_concededAway?.text = "\(goals_conceded.value(forKey: "away") as AnyObject)"
            goals_concededHome?.text = "\(goals_conceded.value(forKey: "home") as AnyObject)"
            
            let win_percentage = data.value(forKey: "win_percentage") as! NSDictionary
            winpercentageAll?.text = "\(win_percentage.value(forKey: "all") as AnyObject)%"
            winpercentageAway?.text = "\(win_percentage.value(forKey: "away") as AnyObject)%"
            winpercentageHome?.text = "\(win_percentage.value(forKey: "home") as AnyObject)%"
            
            let defeat_percentage = data.value(forKey: "defeat_percentage") as! NSDictionary
            defeatpercentageAll?.text = "\(defeat_percentage.value(forKey: "all") as AnyObject)%"
            defeatpercentageAway?.text = "\(defeat_percentage.value(forKey: "away") as AnyObject)%"
            defeatpercentageHome?.text = "\(defeat_percentage.value(forKey: "home") as AnyObject)%"
            
            number_of_yellowcards?.text = "\(data.value(forKey: "number_of_yellowcards") as AnyObject)"
            number_of_yellowredcards?.text = "\(data.value(forKey: "number_of_yellowredcards") as AnyObject)"
            number_of_redcards?.text = "\(data.value(forKey: "number_of_redcards") as AnyObject)"
            avg_yellowredcards_per_match?.text = "\(data.value(forKey: "avg_yellowredcards_per_match") as AnyObject)"
            avg_redcards_per_match?.text = "\(data.value(forKey: "avg_redcards_per_match") as AnyObject)"
            avg_yellowcards_per_match?.text = "\(data.value(forKey: "avg_yellowcards_per_match") as AnyObject)"
            
            let goals_scored_minutes = data.value(forKey: "goals_scored_minutes") as! NSDictionary
            progress0_15value?.text = "\(goals_scored_minutes.value(forKey: "0-15") as AnyObject)"
            progress15_30value?.text = "\(goals_scored_minutes.value(forKey: "15-30") as AnyObject)"
            progress30_45value?.text = "\(goals_scored_minutes.value(forKey: "30-45") as AnyObject)"
            progress45_60value?.text = "\(goals_scored_minutes.value(forKey: "45-60") as AnyObject)"
            progress60_75value?.text = "\(goals_scored_minutes.value(forKey: "60-75") as AnyObject)"
            progress75_90value?.text = "\(goals_scored_minutes.value(forKey: "75-90") as AnyObject)"
            let _15_value = (goals_scored_minutes.value(forKey: "0-15") as! String).replace(target: "%", withString: "")
            let _15_valuereplace = Float(_15_value )
            if(_15_valuereplace != 0){
                progress0_15?.progress = _15_valuereplace!/100
            }else{
                progress0_15?.progress = 0
            }
            let _30_value = (goals_scored_minutes.value(forKey: "15-30") as! String).replace(target: "%", withString: "")
            let _30_valuereplace = Float(_30_value )
            if(_30_valuereplace != 0){
                progress15_30?.progress = _30_valuereplace!/100
            }else{
                progress15_30?.progress = 0
            }
            
            let _45_value = (goals_scored_minutes.value(forKey: "30-45") as! String).replace(target: "%", withString: "")
            let _45_valuereplace = Float(_45_value )
            if(_45_valuereplace != 0){
                progress30_45?.progress = _45_valuereplace!/100
            }else{
                progress30_45?.progress = 0
            }
            let _60_value = (goals_scored_minutes.value(forKey: "45-60") as! String).replace(target: "%", withString: "")
            let _60_valuereplace = Float(_60_value )
            if(_60_valuereplace != 0){
                progress45_60?.progress = _60_valuereplace!/100
            }else{
                progress45_60?.progress = 0
            }
            let _75_value = (goals_scored_minutes.value(forKey: "60-75") as! String).replace(target: "%", withString: "")
            let _75_valuereplace = Float(_75_value )
            if(_75_valuereplace != 0){
                progress60_75?.progress = _75_valuereplace!/100
            }else{
                progress60_75?.progress = 0
            }
            let _90_value = (goals_scored_minutes.value(forKey: "75-90") as! String).replace(target: "%", withString: "")
            let _90_valuereplace = Float(_90_value )
            if(_90_valuereplace != 0){
                progress75_90?.progress = _90_valuereplace!/100
            }else{
                progress75_90?.progress = 0
            }
        }
        else{
            childview?.isHidden = true
        }
        
    }
    
}
