
import Foundation
import ObjectMapper

struct SquadModel : Mappable {
	var message : String?
	var success : Bool?
	var json : SquadJson?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		message <- map["message"]
		success <- map["success"]
		json <- map["json"]
	}

}

struct Cards : Mappable {
    var redcards : Int?
    var yellowcards : Int?
    var yellowredcards : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        redcards <- map["redcards"]
        yellowcards <- map["yellowcards"]
        yellowredcards <- map["yellowredcards"]
    }

}


struct Crosses : Mappable {
    var total : String?
    var accurate : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        accurate <- map["accurate"]
    }

}


struct SquadJsonData : Mappable {
    var to_team_id : Int?
    var date : String?
    var amount : String?
    var player_id : Int?
    var transfer : String?
    var from_team_id : Int?
    var season_id : Int?
    var type : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        to_team_id <- map["to_team_id"]
        date <- map["date"]
        amount <- map["amount"]
        player_id <- map["player_id"]
        transfer <- map["transfer"]
        from_team_id <- map["from_team_id"]
        season_id <- map["season_id"]
        type <- map["type"]
    }

}


struct Detail : Mappable {
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
    var stats : SquadStats?
    var transfers : Transfers?
    var firstname : String?
    var lastname : String?
    var birthcountry : String?
    var birthplace : String?
    var common_name : String?
    var display_name : String?
    var position : String?
    var team : String?

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
        stats <- map["stats"]
        transfers <- map["transfers"]
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


struct Dribbles : Mappable {
    var success : String?
    var dribbled_past : String?
    var attempts : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        success <- map["success"]
        dribbled_past <- map["dribbled_past"]
        attempts <- map["attempts"]
    }

}


struct Duels : Mappable {
    var total : String?
    var won : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        won <- map["won"]
    }

}

struct Fixturesquad : Mappable {
    var id : Int?
    var position_id : Int?
    var position_name : String?
    var position : String?
    var squad : [String]?
    var lineup : [Lineup]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        position_id <- map["position_id"]
        position_name <- map["position_name"]
        position <- map["position"]
        squad <- map["squad"]
        lineup <- map["lineup"]
    }

}


struct Fouls : Mappable {
    var committed : String?
    var drawn : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committed <- map["committed"]
        drawn <- map["drawn"]
    }

}

struct Goals : Mappable {
    var conceded : Int?
    var assists : Int?
    var scored : Int?
    var owngoals : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        conceded <- map["conceded"]
        assists <- map["assists"]
        scored <- map["scored"]
        owngoals <- map["owngoals"]
    }

}

struct SquadJson : Mappable {
    var seasonsquad : [Seasonsquad]?
    var teamsquad : [Teamsquad]?
    var fixturesquad : [Fixturesquad]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        seasonsquad <- map["seasonsquad"]
        teamsquad <- map["teamsquad"]
        fixturesquad <- map["fixturesquad"]
    }

}

struct Lineup : Mappable {
    var id : Int?
    var fixture_id : Int?
    var team_id : Int?
    var player_id : Int?
    var number : Int?
    var position : String?
    var captain : Bool?
    var stats : SquadStats?
    var detail : Detail?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        fixture_id <- map["fixture_id"]
        team_id <- map["team_id"]
        player_id <- map["player_id"]
        number <- map["number"]
        position <- map["position"]
        captain <- map["captain"]
        stats <- map["stats"]
        detail <- map["detail"]
    }

}

struct Other : Mappable {
    var inside_box_saves : String?
    var blocks : String?
    var hit_woodwork : String?
    var interceptions : String?
    var pen_scored : Int?
    var pen_missed : Int?
    var dispossesed : String?
    var pen_saved : String?
    var saves : String?
    var minutes_played : Int?
    var pen_committed : String?
    var tackles : String?
    var clearances : String?
    var pen_won : String?
    var offsides : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        inside_box_saves <- map["inside_box_saves"]
        blocks <- map["blocks"]
        hit_woodwork <- map["hit_woodwork"]
        interceptions <- map["interceptions"]
        pen_scored <- map["pen_scored"]
        pen_missed <- map["pen_missed"]
        dispossesed <- map["dispossesed"]
        pen_saved <- map["pen_saved"]
        saves <- map["saves"]
        minutes_played <- map["minutes_played"]
        pen_committed <- map["pen_committed"]
        tackles <- map["tackles"]
        clearances <- map["clearances"]
        pen_won <- map["pen_won"]
        offsides <- map["offsides"]
    }

}

struct SquadPasses : Mappable {
    var total : String?
    var keypasses : String?
    var accuracy : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total <- map["total"]
        keypasses <- map["key_passes"]
        accuracy <- map["accuracy"]
    }

}


struct Passing : Mappable {
    var passes : String?
    var keypasses : String?
    var passes_accuracy : String?
    var crosses_accuracy : String?
    var accurate_passes : String?
    var total_crosses : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        passes <- map["passes"]
        keypasses <- map["key_passes"]
        passes_accuracy <- map["passes_accuracy"]
        crosses_accuracy <- map["crosses_accuracy"]
        accurate_passes <- map["accurate_passes"]
        total_crosses <- map["total_crosses"]
    }

}

struct Penalties : Mappable {
    var committed : String?
    var saves : String?
    var scores : String?
    var missed : String?
    var won : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committed <- map["committed"]
        saves <- map["saves"]
        scores <- map["scores"]
        missed <- map["missed"]
        won <- map["won"]
    }

}

struct Seasonsquad : Mappable {
    var id : Int?
    var position_id : Int?
    var position_name : String?
    var position : String?
    var squad : [String]?
    var lineup : [Lineup]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        position_id <- map["position_id"]
        position_name <- map["position_name"]
        position <- map["position"]
        squad <- map["squad"]
        lineup <- map["lineup"]
    }

}


struct SquadShots : Mappable {
    var shots_on_goal : String?
    var shots_total : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        shots_on_goal <- map["shots_on_goal"]
        shots_total <- map["shots_total"]
    }

}


struct SquadStats : Mappable {
    var data : [SquadJson]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}


struct Teamsquad : Mappable {
    var id : Int?
    var position_id : Int?
    var position_name : String?
    var position : String?
    var squad : [String]?
    var lineup : [Lineup]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        position_id <- map["position_id"]
        position_name <- map["position_name"]
        position <- map["position"]
        squad <- map["squad"]
        lineup <- map["lineup"]
    }

}

struct Transfers : Mappable {
    var data : [SquadJson]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}
