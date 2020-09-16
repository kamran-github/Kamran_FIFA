
import Foundation
import ObjectMapper

struct LeagueStats : Mappable {
	var message : String?
	var success : Bool?
	var leagueStatsJson : LeagueStatsJson?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		message <- map["message"]
		success <- map["success"]
		leagueStatsJson <- map["json"]
	}

}

struct LeagueStatsJson : Mappable {
    var id : Int?
    var season_id : Int?
    var league_id : Int?
    var name : String?
    var is_current_season : Bool?
    var current_round_id : Int?
    var current_stage_id : Int?
    var stats : Statistics?
    var team_With_Most_Conceded : String?
    var team_With_Most_Corner : String?
    var team_With_Most_Goals : String?
    var team_With_Most_Goals_Per_Match : String?
    var team_With_Most_Clean_Sheet : String?
    var season_TopScorer : String?
    var season_Assist_TopScorer : String?
    var goalkeeper_Most_CleanSheets : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        season_id <- map["season_id"]
        league_id <- map["league_id"]
        name <- map["name"]
        is_current_season <- map["is_current_season"]
        current_round_id <- map["current_round_id"]
        current_stage_id <- map["current_stage_id"]
        stats <- map["stats"]
        team_With_Most_Conceded <- map["team_With_Most_Conceded"]
        team_With_Most_Corner <- map["team_With_Most_Corner"]
        team_With_Most_Goals <- map["team_With_Most_Goals"]
        team_With_Most_Goals_Per_Match <- map["team_With_Most_Goals_Per_Match"]
        team_With_Most_Clean_Sheet <- map["team_With_Most_Clean_Sheet"]
        season_TopScorer <- map["season_TopScorer"]
        season_Assist_TopScorer <- map["season_Assist_TopScorer"]
        goalkeeper_Most_CleanSheets <- map["goalkeeper_Most_CleanSheets"]
    }

}

struct LeagueLeagueData : Mappable {
    var number_of_redcards : Int?
    var goal_line : Goal_line?
    var team_with_most_conceded_goals_number : String?
    var goalkeeper_most_cleansheets_id : Int?
    var defeat_percentage : Defeat_percentage?
    var number_of_matches_played : Int?
    var number_of_yellowcards : Int?
    var number_of_yellowredcards : Int?
    var season_topscorer_id : Int?
    var goals_conceded : Goals_conceded?
    var avg_homegoals_per_match : String?
    var win_percentage : Win_percentage?
    var team_with_most_goals_per_match_number : String?
    var avg_goals_per_match : Double?
    var number_of_goals : Int?
    var avg_redcards_per_match : Double?
    var team_most_corners_count : String?
    var avg_player_rating : String?
    var updated_at : Updated_at?
    var team_with_most_conceded_goals_id : Int?
    var id : Int?
    var goals_scored_minutes : Goals_scored_minutes?
    var avg_awaygoals_per_match : String?
    var goals_scored : Goals_scored?
    var team_most_corners_id : String?
    var season_topscorer_number : String?
    var season_assist_topscorer_id : Int?
    var avg_corners_per_match : String?
    var season_id : Int?
    var season_assist_topscorer_number : String?
    var team_most_cleansheets_number : Int?
    var draw_percentage : String?
    var goalkeeper_most_cleansheets_number : Int?
    var avg_yellowredcards_per_match : Double?
    var number_of_clubs : Int?
    var team_most_cleansheets_id : Int?
    var number_of_matches : Int?
    var avg_yellowcards_per_match : Double?
    var team_with_most_goals_id : Int?
    var team_with_most_goals_per_match_id : Int?
    var matches_both_teams_scored : Int?
    var team_with_most_goals_number : String?
    var league_id : Int?
    var goal_scored_every_minutes : Int?
    var btts : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        number_of_redcards <- map["number_of_redcards"]
        goal_line <- map["goal_line"]
        team_with_most_conceded_goals_number <- map["team_with_most_conceded_goals_number"]
        goalkeeper_most_cleansheets_id <- map["goalkeeper_most_cleansheets_id"]
        defeat_percentage <- map["defeat_percentage"]
        number_of_matches_played <- map["number_of_matches_played"]
        number_of_yellowcards <- map["number_of_yellowcards"]
        number_of_yellowredcards <- map["number_of_yellowredcards"]
        season_topscorer_id <- map["season_topscorer_id"]
        goals_conceded <- map["goals_conceded"]
        avg_homegoals_per_match <- map["avg_homegoals_per_match"]
        win_percentage <- map["win_percentage"]
        team_with_most_goals_per_match_number <- map["team_with_most_goals_per_match_number"]
        avg_goals_per_match <- map["avg_goals_per_match"]
        number_of_goals <- map["number_of_goals"]
        avg_redcards_per_match <- map["avg_redcards_per_match"]
        team_most_corners_count <- map["team_most_corners_count"]
        avg_player_rating <- map["avg_player_rating"]
        updated_at <- map["updated_at"]
        team_with_most_conceded_goals_id <- map["team_with_most_conceded_goals_id"]
        id <- map["id"]
        goals_scored_minutes <- map["goals_scored_minutes"]
        avg_awaygoals_per_match <- map["avg_awaygoals_per_match"]
        goals_scored <- map["goals_scored"]
        team_most_corners_id <- map["team_most_corners_id"]
        season_topscorer_number <- map["season_topscorer_number"]
        season_assist_topscorer_id <- map["season_assist_topscorer_id"]
        avg_corners_per_match <- map["avg_corners_per_match"]
        season_id <- map["season_id"]
        season_assist_topscorer_number <- map["season_assist_topscorer_number"]
        team_most_cleansheets_number <- map["team_most_cleansheets_number"]
        draw_percentage <- map["draw_percentage"]
        goalkeeper_most_cleansheets_number <- map["goalkeeper_most_cleansheets_number"]
        avg_yellowredcards_per_match <- map["avg_yellowredcards_per_match"]
        number_of_clubs <- map["number_of_clubs"]
        team_most_cleansheets_id <- map["team_most_cleansheets_id"]
        number_of_matches <- map["number_of_matches"]
        avg_yellowcards_per_match <- map["avg_yellowcards_per_match"]
        team_with_most_goals_id <- map["team_with_most_goals_id"]
        team_with_most_goals_per_match_id <- map["team_with_most_goals_per_match_id"]
        matches_both_teams_scored <- map["matches_both_teams_scored"]
        team_with_most_goals_number <- map["team_with_most_goals_number"]
        league_id <- map["league_id"]
        goal_scored_every_minutes <- map["goal_scored_every_minutes"]
        btts <- map["btts"]
    }

}

struct Goal_line : Mappable {
    var over : Over?
    var under : Under?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        over <- map["over"]
        under <- map["under"]
    }

}

struct Goals_scored_minutes : Mappable {
    var slot4 : String?
    var slot3 : String?
    var slot1 : String?
    var slot6 : String?
    var slot2 : String?
    var slot5 : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        slot4 <- map["45-60"]
        slot3 <- map["30-45"]
        slot1 <- map["0-15"]
        slot6 <- map["75-90"]
        slot2 <- map["15-30"]
        slot5 <- map["60-75"]
    }

}

struct Over : Mappable {
    var over0 : Double?
    var over1 : Double?
    var over2 : Double?
    var over3 : Int?
    var over4 : Double?
    var over5 : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        over0 <- map["0_5"]
        over1 <- map["1_5"]
        over2 <- map["2_5"]
        over3 <- map["3_5"]
        over4 <- map["4_5"]
        over5 <- map["5_5"]
    }

}

struct Statistics : Mappable {
    var data : LeagueLeagueData?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}


struct Under : Mappable {
    var under0 : Double?
    var under1 : Double?
    var under2 : Double?
    var under3 : Int?
    var under4 : Double?
    var under5 : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        under0 <- map["0_5"]
        under1 <- map["1_5"]
        under2 <- map["2_5"]
        under3 <- map["3_5"]
        under4 <- map["4_5"]
        under5 <- map["5_5"]
    }

}

struct Updated_at : Mappable {
    var date : String?
    var timezone : String?
    var timezone_type : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        date <- map["date"]
        timezone <- map["timezone"]
        timezone_type <- map["timezone_type"]
    }

}
struct Goals_scored : Mappable {
    var all : Double?
    var away : Double?
    var home : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        all <- map["all"]
        away <- map["away"]
        home <- map["home"]
    }

}

struct Goals_conceded : Mappable {
    var all : Double?
    var away : Double?
    var home : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        all <- map["all"]
        away <- map["away"]
        home <- map["home"]
    }

}

struct Win_percentage : Mappable {
    var all : Double?
    var away : Double?
    var home : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        all <- map["all"]
        away <- map["away"]
        home <- map["home"]
    }

}

struct Defeat_percentage : Mappable {
    var all : Double?
    var away : Double?
    var home : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        all <- map["all"]
        away <- map["away"]
        home <- map["home"]
    }

}
