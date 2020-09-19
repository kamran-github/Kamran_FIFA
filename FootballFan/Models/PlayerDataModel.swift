
import Foundation
import ObjectMapper

struct PlayerDataModel : Mappable {
	var message : String?
	var success : Bool?
	var json : PlayerJson?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		message <- map["message"]
		success <- map["success"]
		json <- map["json"]
	}

}

struct Avg_first_goal_conceded : Mappable {
    var total : String?
    var away : String?
    var home : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}



struct Avg_first_goal_scored : Mappable {
    var total : String?
    var away : String?
    var home : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}

struct Clean_sheet : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}

struct Draw : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}


struct Failed_to_score : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}


struct Goals_against : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}


struct Goals_conceded_minutes : Mappable {
    var period : [Period]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        period <- map["period"]
    }

}


struct Goals_for : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}


struct PlayerJson : Mappable {
    var id : Int?
    var player_id : Int?
    var team_id : Int?
    var position_id : Int?
    var country_id : Int?
    var fullname : String?
    var nationality : String?
    var birthdate : String?
    var height : String?
    var weight : String?
    var image_path : String?
    var firstname : String?
    var lastname : String?
    var birthcountry : String?
    var birthplace : String?
    var common_name : String?
    var display_name : String?
    var position : String?
    var team : Team?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        player_id <- map["player_id"]
        team_id <- map["team_id"]
        position_id <- map["position_id"]
        country_id <- map["country_id"]
        fullname <- map["fullname"]
        nationality <- map["nationality"]
        birthdate <- map["birthdate"]
        height <- map["height"]
        weight <- map["weight"]
        image_path <- map["image_path"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        birthcountry <- map["birthcountry"]
        birthplace <- map["birthplace"]
        common_name <- map["common_name"]
        display_name <- map["display_name"]
        position <- map["position"]
        team <- map["team"]
    }

}


struct Lost : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}



struct Period : Mappable {
    var percentage : Int?
    var count : Int?
    var minute : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        percentage <- map["percentage"]
        count <- map["count"]
        minute <- map["minute"]
    }

}


struct Scoring_minutes : Mappable {
    var period : [Period]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        period <- map["period"]
    }

}


struct PlayerStats : Mappable {
    var goal_line : String?
    var scoring_minutes : [Scoring_minutes]?
    var dangerous_attacks : Int?
    var avg_first_goal_scored : Avg_first_goal_scored?
    var fouls : Int?
    var avg_player_rating_per_match : Int?
    var shots_off_target : Int?
    var team_id : Int?
    var goals_conceded_minutes : [Goals_conceded_minutes]?
    var redcards : Int?
    var avg_player_rating : Int?
    var attacks : Int?
    var lost : Lost?
    var avg_corners : String?
    var avg_goals_per_game_conceded : String?
    var shots_blocked : Int?
    var yellowcards : Int?
    var win : PlayerWin?
    var avg_shots_off_target_per_game : String?
    var offsides : Int?
    var failed_to_score : Failed_to_score?
    var avg_first_goal_conceded : Avg_first_goal_conceded?
    var clean_sheet : Clean_sheet?
    var stage_id : Int?
    var season_id : Int?
    var draw : Draw?
    var avg_shots_on_target_per_game : String?
    var avg_goals_per_game_scored : String?
    var avg_fouls_per_game : String?
    var goals_against : Goals_against?
    var avg_ball_possession_percentage : String?
    var total_corners : Int?
    var shots_on_target : Int?
    var goals_for : Goals_for?
    var btts : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        goal_line <- map["goal_line"]
        scoring_minutes <- map["scoring_minutes"]
        dangerous_attacks <- map["dangerous_attacks"]
        avg_first_goal_scored <- map["avg_first_goal_scored"]
        fouls <- map["fouls"]
        avg_player_rating_per_match <- map["avg_player_rating_per_match"]
        shots_off_target <- map["shots_off_target"]
        team_id <- map["team_id"]
        goals_conceded_minutes <- map["goals_conceded_minutes"]
        redcards <- map["redcards"]
        avg_player_rating <- map["avg_player_rating"]
        attacks <- map["attacks"]
        lost <- map["lost"]
        avg_corners <- map["avg_corners"]
        avg_goals_per_game_conceded <- map["avg_goals_per_game_conceded"]
        shots_blocked <- map["shots_blocked"]
        yellowcards <- map["yellowcards"]
        win <- map["win"]
        avg_shots_off_target_per_game <- map["avg_shots_off_target_per_game"]
        offsides <- map["offsides"]
        failed_to_score <- map["failed_to_score"]
        avg_first_goal_conceded <- map["avg_first_goal_conceded"]
        clean_sheet <- map["clean_sheet"]
        stage_id <- map["stage_id"]
        season_id <- map["season_id"]
        draw <- map["draw"]
        avg_shots_on_target_per_game <- map["avg_shots_on_target_per_game"]
        avg_goals_per_game_scored <- map["avg_goals_per_game_scored"]
        avg_fouls_per_game <- map["avg_fouls_per_game"]
        goals_against <- map["goals_against"]
        avg_ball_possession_percentage <- map["avg_ball_possession_percentage"]
        total_corners <- map["total_corners"]
        shots_on_target <- map["shots_on_target"]
        goals_for <- map["goals_for"]
        btts <- map["btts"]
    }

}


struct Team : Mappable {
    var id : Int?
    var team_id : Int?
    var legacy_id : Int?
    var name : String?
    var short_code : String?
    var country_id : Int?
    var national_team : Bool?
    var founded : Int?
    var logo_path : String?
    var venue_id : Int?
    var current_season_id : Int?
    var season_id : Int?
    var stats : PlayerStats?
    var league : [String]?
    var standings : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        team_id <- map["team_id"]
        legacy_id <- map["legacy_id"]
        name <- map["name"]
        short_code <- map["short_code"]
        country_id <- map["country_id"]
        national_team <- map["national_team"]
        founded <- map["founded"]
        logo_path <- map["logo_path"]
        venue_id <- map["venue_id"]
        current_season_id <- map["current_season_id"]
        season_id <- map["season_id"]
        stats <- map["stats"]
        league <- map["league"]
        standings <- map["standings"]
    }

}


struct PlayerWin : Mappable {
    var total : Int?
    var away : Int?
    var home : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        away <- map["away"]
        home <- map["home"]
    }

}
