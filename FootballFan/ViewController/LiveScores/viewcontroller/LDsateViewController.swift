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
import ObjectMapper
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
    
    @IBOutlet weak var playerimage1: UIImageView!
    @IBOutlet weak var playerlbl1: UILabel!
    @IBOutlet weak var plyaernumLbl1: UILabel!
    @IBOutlet weak var playerCountryLbl1: UILabel!
    
    @IBOutlet weak var playerimage2: UIImageView!
    @IBOutlet weak var playerlbl2: UILabel!
    @IBOutlet weak var plyaernumLbl2: UILabel!
    @IBOutlet weak var playerCountryLbl2: UILabel!
    
    @IBOutlet weak var playerimage3: UIImageView!
    @IBOutlet weak var playerlbl3: UILabel!
    @IBOutlet weak var plyaernumLbl3: UILabel!
    @IBOutlet weak var playerCountryLbl3: UILabel!
    
    @IBOutlet weak var teamimage1: UIImageView!
    @IBOutlet weak var teamlbl1: UILabel!
    @IBOutlet weak var teamnumLbl1: UILabel!
    @IBOutlet weak var teamCountryLbl1: UILabel!
    
    @IBOutlet weak var teamimage2: UIImageView!
    @IBOutlet weak var teamlbl2: UILabel!
    @IBOutlet weak var teamnumLbl2: UILabel!
    @IBOutlet weak var teamCountryLbl2: UILabel!
    
    @IBOutlet weak var teamimage3: UIImageView!
    @IBOutlet weak var teamlbl3: UILabel!
    @IBOutlet weak var teamnumLbl3: UILabel!
    @IBOutlet weak var teamCountryLbl3: UILabel!
    
    @IBOutlet weak var teamimage4: UIImageView!
    @IBOutlet weak var teamlbl4: UILabel!
    @IBOutlet weak var teamnumLbl4: UILabel!
    @IBOutlet weak var teamCountryLbl4: UILabel!
    
    @IBOutlet weak var teamimage5: UIImageView!
    @IBOutlet weak var teamlbl5: UILabel!
    @IBOutlet weak var teamnumLbl5: UILabel!
    @IBOutlet weak var teamCountryLbl5: UILabel!
    
    
    var season_id = 0
    var dic: NSDictionary = NSDictionary()
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    var arrstanding: [AnyObject] = []
    var leagueJson : LeagueStatsJson?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUidate()
        print(dic)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func setUidate()  {
        if(leagueJson != nil){
            number_of_clubs?.text = String(leagueJson?.stats?.data?.number_of_clubs ?? 0) //"\(data.value(forKey: "number_of_clubs") as AnyObject)"
            number_of_matches?.text = String(leagueJson?.stats?.data?.number_of_matches ?? 0) //"\(data.value(forKey: "number_of_matches") as AnyObject)"
            matches_both_teams_scored?.text = String(leagueJson?.stats?.data?.matches_both_teams_scored ?? 0) //"\(data.value(forKey: "matches_both_teams_scored") as AnyObject)"
            number_of_matches_played?.text = String(leagueJson?.stats?.data?.number_of_matches_played ?? 0) //"\(data.value(forKey: "number_of_matches_played") as AnyObject)"
            draw_percentage?.text = String(leagueJson?.stats?.data?.draw_percentage ?? "0")+"%" //"\(data.value(forKey: "draw_percentage") as AnyObject) %"
            goal_scored_every_minutes?.text = String(leagueJson?.stats?.data?.goal_scored_every_minutes ?? 0) //"\(data.value(forKey: "goal_scored_every_minutes") as AnyObject)"
            avg_goals_per_match?.text = String(leagueJson?.stats?.data?.avg_goals_per_match ?? 0) //"\(data.value(forKey: "avg_goals_per_match") as AnyObject)"
            avg_corners_per_match?.text = String(leagueJson?.stats?.data?.avg_corners_per_match ?? "0") //"\(data.value(forKey: "avg_corners_per_match") as AnyObject)"
            avg_player_rating?.text = String(leagueJson?.stats?.data?.avg_player_rating ?? "0") //"\(data.value(forKey: "avg_player_rating") as AnyObject)"
            number_of_goals?.text = String(leagueJson?.stats?.data?.number_of_goals ?? 0) //"\(data.value(forKey: "number_of_goals") as AnyObject)"
         
            goals_scoredAll?.text = String(leagueJson?.stats?.data?.goals_scored?.all ?? 0.0) //"\(goals_scored.value(forKey: "all") as AnyObject)"
            goals_scoredAway?.text = String(leagueJson?.stats?.data?.goals_scored?.away ?? 0.0) //"\(goals_scored.value(forKey: "away") as AnyObject)"
            goals_scoredHome?.text = String(leagueJson?.stats?.data?.goals_scored?.home ?? 0.0) //"\(goals_scored.value(forKey: "home") as AnyObject)"
        
            goals_concededAll?.text = String(leagueJson?.stats?.data?.goals_conceded?.all ?? 0.0)
            goals_concededAway?.text = String(leagueJson?.stats?.data?.goals_conceded?.away ?? 0.0)
            goals_concededHome?.text = String(leagueJson?.stats?.data?.goals_conceded?.home ?? 0.0)
            
            winpercentageAll?.text = String(leagueJson?.stats?.data?.win_percentage?.all ?? 0.0)+"%"
            winpercentageAway?.text = String(leagueJson?.stats?.data?.win_percentage?.away ?? 0.0)+"%"
            winpercentageHome?.text = String(leagueJson?.stats?.data?.win_percentage?.home ?? 0.0)+"%"
            
            defeatpercentageAll?.text = String(leagueJson?.stats?.data?.defeat_percentage?.all ?? 0.0)+"%"
            defeatpercentageAway?.text = String(leagueJson?.stats?.data?.defeat_percentage?.away ?? 0.0)+"%"
            defeatpercentageHome?.text = String(leagueJson?.stats?.data?.defeat_percentage?.home ?? 0.0)+"%"
            
            number_of_yellowcards?.text = String(leagueJson?.stats?.data?.number_of_yellowcards ?? 0) //"\(data.value(forKey: "number_of_yellowcards") as AnyObject)"
            number_of_yellowredcards?.text = String(leagueJson?.stats?.data?.number_of_yellowredcards ?? 0) //"\(data.value(forKey: "number_of_yellowredcards") as AnyObject)"
            number_of_redcards?.text = String(leagueJson?.stats?.data?.number_of_redcards ?? 0) //"\(data.value(forKey: "number_of_redcards") as AnyObject)"
            avg_yellowredcards_per_match?.text = String(leagueJson?.stats?.data?.avg_yellowredcards_per_match ?? 0) //"\(data.value(forKey: "avg_yellowredcards_per_match") as AnyObject)"
            avg_redcards_per_match?.text = String(leagueJson?.stats?.data?.avg_redcards_per_match ?? 0) //"\(data.value(forKey: "avg_redcards_per_match") as AnyObject)"
            avg_yellowcards_per_match?.text = String(leagueJson?.stats?.data?.avg_yellowcards_per_match ?? 0) //"\(data.value(forKey: "avg_yellowcards_per_match") as AnyObject)"
            
            progress0_15value?.text = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot1 ?? "0") //"\(goals_scored_minutes.value(forKey: "0-15") as AnyObject)"
            progress15_30value?.text = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot2 ?? "0") //"\(goals_scored_minutes.value(forKey: "15-30") as AnyObject)"
            progress30_45value?.text = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot3 ?? "0") //"\(goals_scored_minutes.value(forKey: "30-45") as AnyObject)"
            progress45_60value?.text = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot4 ?? "0") //"\(goals_scored_minutes.value(forKey: "45-60") as AnyObject)"
            progress60_75value?.text = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot5 ?? "0") //"\(goals_scored_minutes.value(forKey: "60-75") as AnyObject)"
            progress75_90value?.text = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot6 ?? "0") //"\(goals_scored_minutes.value(forKey: "75-90") as AnyObject)"
            let _15_value = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot1 ?? "0").replace(target: "%", withString: "")
            let _15_valuereplace = Float(_15_value )
            if(_15_valuereplace != 0){
                progress0_15?.progress = _15_valuereplace!/100
            }else{
                progress0_15?.progress = 0
            }
            let _30_value = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot2 ?? "0").replace(target: "%", withString: "")
            let _30_valuereplace = Float(_30_value )
            if(_30_valuereplace != 0){
                progress15_30?.progress = _30_valuereplace!/100
            }else{
                progress15_30?.progress = 0
            }
            
            let _45_value = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot3 ?? "0").replace(target: "%", withString: "")
            let _45_valuereplace = Float(_45_value )
            if(_45_valuereplace != 0){
                progress30_45?.progress = _45_valuereplace!/100
            }else{
                progress30_45?.progress = 0
            }
            let _60_value = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot4 ?? "0").replace(target: "%", withString: "")
            let _60_valuereplace = Float(_60_value )
            if(_60_valuereplace != 0){
                progress45_60?.progress = _60_valuereplace!/100
            }else{
                progress45_60?.progress = 0
            }
            let _75_value = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot5 ?? "0").replace(target: "%", withString: "")
            let _75_valuereplace = Float(_75_value )
            if(_75_valuereplace != 0){
                progress60_75?.progress = _75_valuereplace!/100
            }else{
                progress60_75?.progress = 0
            }
            let _90_value = String(leagueJson?.stats?.data?.goals_scored_minutes?.slot6 ?? "0").replace(target: "%", withString: "")
            let _90_valuereplace = Float(_90_value )
            if(_90_valuereplace != 0){
                progress75_90?.progress = _90_valuereplace!/100
            }else{
                progress75_90?.progress = 0
            }
            
            //Top player details
            let playerURL1 = URL(string:String(leagueJson?.season_TopScorer?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl1 = playerURL1 {
                playerimage1.af.setImage(withURL: logourl1)
            }
            playerimage1?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            playerimage1?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            playerimage1?.layer.borderWidth = 1
            playerimage1?.clipsToBounds = true
            playerlbl1.text = leagueJson?.season_TopScorer?.fullname ?? ConstantString.notAvailable
            plyaernumLbl1.text = "\(leagueJson?.stats?.data?.season_topscorer_number ?? 0)"
            playerCountryLbl1.text = leagueJson?.season_TopScorer?.nationality ?? ConstantString.notAvailable
            
           let playerURL2 = URL(string:String(leagueJson?.season_Assist_TopScorer?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl2 = playerURL2 {
                playerimage2.af.setImage(withURL: logourl2)
            }
            playerimage2?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            playerimage2?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            playerimage2?.layer.borderWidth = 1
            playerimage2?.clipsToBounds = true
            playerlbl2.text = leagueJson?.season_Assist_TopScorer?.fullname ?? ConstantString.notAvailable
            plyaernumLbl2.text = "\(leagueJson?.stats?.data?.season_assist_topscorer_number ?? 0)"
            playerCountryLbl2.text = leagueJson?.season_Assist_TopScorer?.nationality ?? ConstantString.notAvailable
            
            let playerURL3 = URL(string:String(leagueJson?.goalkeeper_Most_CleanSheets?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl3 = playerURL3 {
                playerimage3.af.setImage(withURL: logourl3)
            }
            playerimage3?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            playerimage3?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            playerimage3?.layer.borderWidth = 1
            playerimage3?.clipsToBounds = true
            playerlbl3.text = leagueJson?.goalkeeper_Most_CleanSheets?.fullname ?? "ConstantString.notAvailable"
            plyaernumLbl3.text = "\(leagueJson?.stats?.data?.goalkeeper_most_cleansheets_number ?? 0)"
            playerCountryLbl3.text = leagueJson?.goalkeeper_Most_CleanSheets?.nationality ?? ConstantString.notAvailable
            
            
            let imageURL1 = URL(string:String(leagueJson?.team_With_Most_Clean_Sheet?.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl1 = imageURL1 {
                teamimage1.af.setImage(withURL: logourl1)
            }
            teamimage1?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            teamimage1?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            teamimage1?.layer.borderWidth = 1
            teamimage1?.clipsToBounds = true
            teamlbl1.text = leagueJson?.team_With_Most_Clean_Sheet?.name ?? ConstantString.notAvailable
            teamnumLbl1.text = "\(leagueJson?.stats?.data?.team_most_cleansheets_number ?? 0)"
            teamCountryLbl1.text = ""
            
            let imageURL2 = URL(string:String(leagueJson?.team_With_Most_Corner?.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl2 = imageURL2 {
                teamimage1.af.setImage(withURL: logourl2)
            }
            teamimage2?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            teamimage2?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            teamimage2?.layer.borderWidth = 1
            teamimage2?.clipsToBounds = true
            teamlbl2.text = leagueJson?.team_With_Most_Corner?.name ?? ConstantString.notAvailable
            teamnumLbl2.text = "\(leagueJson?.stats?.data?.team_most_corners_count ?? 0)"
            teamCountryLbl2.text = ""
            
            let imageURL3 = URL(string:String(leagueJson?.team_With_Most_Goals?.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl3 = imageURL3 {
                teamimage3.af.setImage(withURL: logourl3)
            }
            teamimage3?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            teamimage3?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            teamimage3?.layer.borderWidth = 1
            teamimage3?.clipsToBounds = true
            teamlbl3.text = leagueJson?.team_With_Most_Goals?.name ?? ConstantString.notAvailable
            teamnumLbl3.text = "\(leagueJson?.stats?.data?.team_with_most_goals_number ?? 0)"
            teamCountryLbl3.text = ""
            
            let imageURL4 = URL(string:String(leagueJson?.team_With_Most_Conceded?.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl4 = imageURL4 {
                teamimage1.af.setImage(withURL: logourl4)
            }
            teamimage4?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            teamimage4?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            teamimage4?.layer.borderWidth = 1
            teamimage4?.clipsToBounds = true
            teamlbl4.text = leagueJson?.team_With_Most_Conceded?.name ?? ConstantString.notAvailable
            teamnumLbl4.text = "\(leagueJson?.stats?.data?.team_with_most_conceded_goals_number ?? 0)"
            teamCountryLbl4.text = ""
            
            let imageURL5 = URL(string:String(leagueJson?.team_With_Most_Goals_Per_Match?.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"))
            if let logourl5 = imageURL5 {
                teamimage5.af.setImage(withURL: logourl5)
            }
            teamimage5?.layer.cornerRadius = (playerimage1?.frame.height)! / 2
            teamimage5?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
            teamimage5?.layer.borderWidth = 1
            teamimage5?.clipsToBounds = true
            teamlbl5.text = leagueJson?.team_With_Most_Goals_Per_Match?.name ?? ConstantString.notAvailable
            teamnumLbl5.text = "\(leagueJson?.stats?.data?.team_with_most_goals_per_match_number ?? 0)"
            teamCountryLbl5.text = ""
        }
        else{
            childview?.isHidden = true
        }
        
    }
    
}
