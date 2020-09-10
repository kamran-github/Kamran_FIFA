//
//  LiveScoreModel.swift
//  FootballFan
//
//  Created by Kamran TNK on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import ObjectMapper

struct LiveScoreModel : Mappable {
    var keyObject : Int = 0
    var valueObject = [TimeJson]()

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        keyObject <- map["keyObject"]
        valueObject <- map["valueObject"]
    }

}

struct ResponseDataModel : Mappable {
    var message : String?
    var success : Bool?
    var json: [String: [TimeJson]]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
        json <- map["json"]
    }

}


class DocumentListObject {

     var id:Int?
     var user_id:Int?
     var document:String?
     var name:String?
     var order:Int?
     var is_edit:Bool?
     var edit_json:String?
     var date:String?
     var url:String?
}


struct Away : Mappable {
    var goals_scored : Int?
    var goals_against : Int?
    var lost : Int?
    var won : Int?
    var games_played : Int?
    var draw : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        goals_scored <- map["goals_scored"]
        goals_against <- map["goals_against"]
        lost <- map["lost"]
        won <- map["won"]
        games_played <- map["games_played"]
        draw <- map["draw"]
    }

}


struct CurrentRound : Mappable {
    var round_id : Int?
    var name : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        round_id <- map["round_id"]
        name <- map["name"]
    }

}

struct TeamData : Mappable {
    var twitter : String?
    var logo_path : String?
    var name : String?
    var founded : Int?
    var legacy_id : Int?
    var national_team : Bool?
    var id : Int?
    var current_season_id : Int?
    var country_id : Int?
    var venue_id : Int?
    var short_code : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        twitter <- map["twitter"]
        logo_path <- map["logo_path"]
        name <- map["name"]
        founded <- map["founded"]
        legacy_id <- map["legacy_id"]
        national_team <- map["national_team"]
        id <- map["id"]
        current_season_id <- map["current_season_id"]
        country_id <- map["country_id"]
        venue_id <- map["venue_id"]
        short_code <- map["short_code"]
    }

}
struct Events : Mappable {
    var data : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}

struct Fixture : Mappable {
    var id : Int?
    var fixture_id : Int?
    var league_id : Int?
    var season_id : Int?
    var stage_id : Int?
    var round_id : Int?
    var group_id : Int?
    var aggregate_id : Int?
    var venue_id : Int?
    var referee_id : Int?
    var localteam_id : Int?
    var visitorteam_id : Int?
    var winner_team_id : Int?
    var formations : Formations?
    var scores : Scores?
    var localTeam : LocalTeam?
    var visitorTeam : VisitorTeam?
    var standing : Standing?
    var commentaries : Bool?
    var weather_report : String?
    var venue : String?
    var referee : String?
    var events : Events?
    var stats : Stats?
    var time : Time?
    var colors : String?
    var status : String?
    var coaches : String?
    var assistants : String?
    var deleted : Bool?
    var leg : String?
    var fixtureDate : Int?
    var currentRound : CurrentRound?
    var localStandings : LocalStandings?
    var visitorStandings : VisitorStandings?
    var fixtureTime : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        fixture_id <- map["fixture_id"]
        league_id <- map["league_id"]
        season_id <- map["season_id"]
        stage_id <- map["stage_id"]
        round_id <- map["round_id"]
        group_id <- map["group_id"]
        aggregate_id <- map["aggregate_id"]
        venue_id <- map["venue_id"]
        referee_id <- map["referee_id"]
        localteam_id <- map["localteam_id"]
        visitorteam_id <- map["visitorteam_id"]
        winner_team_id <- map["winner_team_id"]
        formations <- map["formations"]
        scores <- map["scores"]
        localTeam <- map["localTeam"]
        visitorTeam <- map["visitorTeam"]
        standing <- map["standing"]
        commentaries <- map["commentaries"]
        weather_report <- map["weather_report"]
        venue <- map["venue"]
        referee <- map["referee"]
        events <- map["events"]
        stats <- map["stats"]
        time <- map["time"]
        colors <- map["colors"]
        status <- map["status"]
        coaches <- map["coaches"]
        assistants <- map["assistants"]
        deleted <- map["deleted"]
        leg <- map["leg"]
        fixtureDate <- map["fixtureDate"]
        currentRound <- map["currentRound"]
        localStandings <- map["localStandings"]
        visitorStandings <- map["visitorStandings"]
        fixtureTime <- map["fixtureTime"]
    }

}

struct Formations : Mappable {
    var visitorteam_formation : String?
    var localteam_formation : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        visitorteam_formation <- map["visitorteam_formation"]
        localteam_formation <- map["localteam_formation"]
    }

}

struct Home : Mappable {
    var goals_scored : Int?
    var goals_against : Int?
    var lost : Int?
    var won : Int?
    var games_played : Int?
    var draw : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        goals_scored <- map["goals_scored"]
        goals_against <- map["goals_against"]
        lost <- map["lost"]
        won <- map["won"]
        games_played <- map["games_played"]
        draw <- map["draw"]
    }

}

struct TimeJson : Mappable {
    var id : String?
    var league_id : Int?
    var legacy_id : Int?
    var country_id : Int?
    var logo_path : String?
    var name : String?
    var live_standings : Bool?
    var active : Bool?
    var is_cup : Bool?
    var current_season_id : Int?
    var current_round_id : Int?
    var current_stage_id : Int?
    var coverage : String?
    var season_id : Int?
    var fixture : [Fixture]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        league_id <- map["league_id"]
        legacy_id <- map["legacy_id"]
        country_id <- map["country_id"]
        logo_path <- map["logo_path"]
        name <- map["name"]
        live_standings <- map["live_standings"]
        active <- map["active"]
        is_cup <- map["is_cup"]
        current_season_id <- map["current_season_id"]
        current_round_id <- map["current_round_id"]
        current_stage_id <- map["current_stage_id"]
        coverage <- map["coverage"]
        season_id <- map["season_id"]
        fixture <- map["fixture"]
    }

}

struct LocalStandings : Mappable {
    var id : Int?
    var position : Int?
    var team_id : Int?
    var team_name : String?
    var round_id : Int?
    var round_name : Int?
    var group_id : Int?
    var group_name : String?
    var overall : Overall?
    var home : Home?
    var away : Away?
    var total : Total?
    var result : String?
    var points : Int?
    var recent_form : String?
    var status : String?
    var season_id : Int?
    var logo_path : String?
    var positionChange : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        position <- map["position"]
        team_id <- map["team_id"]
        team_name <- map["team_name"]
        round_id <- map["round_id"]
        round_name <- map["round_name"]
        group_id <- map["group_id"]
        group_name <- map["group_name"]
        overall <- map["overall"]
        home <- map["home"]
        away <- map["away"]
        total <- map["total"]
        result <- map["result"]
        points <- map["points"]
        recent_form <- map["recent_form"]
        status <- map["status"]
        season_id <- map["season_id"]
        logo_path <- map["logo_path"]
        positionChange <- map["positionChange"]
    }

}

struct LocalTeam : Mappable {
    var data : TeamData?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}

struct Overall : Mappable {
    var goals_scored : Int?
    var goals_against : Int?
    var lost : Int?
    var won : Int?
    var games_played : Int?
    var draw : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        goals_scored <- map["goals_scored"]
        goals_against <- map["goals_against"]
        lost <- map["lost"]
        won <- map["won"]
        games_played <- map["games_played"]
        draw <- map["draw"]
    }

}

struct Scores : Mappable {
    var ht_score : String?
    var ps_score : String?
    var localteam_score : Int?
    var localteam_pen_score : String?
    var visitorteam_score : Int?
    var ft_score : String?
    var et_score : String?
    var visitorteam_pen_score : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        ht_score <- map["ht_score"]
        ps_score <- map["ps_score"]
        localteam_score <- map["localteam_score"]
        localteam_pen_score <- map["localteam_pen_score"]
        visitorteam_score <- map["visitorteam_score"]
        ft_score <- map["ft_score"]
        et_score <- map["et_score"]
        visitorteam_pen_score <- map["visitorteam_pen_score"]
    }

}


struct VisitorTeam : Mappable {
    var data : TeamData?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}
struct Standing : Mappable {
    var visitorteam_position : Int?
    var localteam_position : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        visitorteam_position <- map["visitorteam_position"]
        localteam_position <- map["localteam_position"]
    }

}
struct Starting_at : Mappable {
    var date : String?
    var date_time : String?
    var timezone : String?
    var time : String?
    var timestamp : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        date <- map["date"]
        date_time <- map["date_time"]
        timezone <- map["timezone"]
        time <- map["time"]
        timestamp <- map["timestamp"]
    }

}


struct Stats : Mappable {
    var data : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        data <- map["data"]
    }

}


struct Time : Mappable {
    var added_time : String?
    var starting_at : Starting_at?
    var injury_time : String?
    var extra_minute : String?
    var status : String?
    var minute : String?
    var second : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        added_time <- map["added_time"]
        starting_at <- map["starting_at"]
        injury_time <- map["injury_time"]
        extra_minute <- map["extra_minute"]
        status <- map["status"]
        minute <- map["minute"]
        second <- map["second"]
    }

}


struct Total : Mappable {
    var goal_difference : String?
    var points : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        goal_difference <- map["goal_difference"]
        points <- map["points"]
    }

}


struct VisitorStandings : Mappable {
    var id : Int?
    var position : Int?
    var team_id : Int?
    var team_name : String?
    var round_id : Int?
    var round_name : Int?
    var group_id : Int?
    var group_name : String?
    var overall : Overall?
    var home : Home?
    var away : Away?
    var total : Total?
    var result : String?
    var points : Int?
    var recent_form : String?
    var status : String?
    var season_id : Int?
    var logo_path : String?
    var positionChange : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        position <- map["position"]
        team_id <- map["team_id"]
        team_name <- map["team_name"]
        round_id <- map["round_id"]
        round_name <- map["round_name"]
        group_id <- map["group_id"]
        group_name <- map["group_name"]
        overall <- map["overall"]
        home <- map["home"]
        away <- map["away"]
        total <- map["total"]
        result <- map["result"]
        points <- map["points"]
        recent_form <- map["recent_form"]
        status <- map["status"]
        season_id <- map["season_id"]
        logo_path <- map["logo_path"]
        positionChange <- map["positionChange"]
    }

}
