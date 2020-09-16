

import Foundation
import ObjectMapper

struct RoundSeasonModel : Mappable {
    var message : String?
    var success : Bool?
    var seasonJson : [RoundSeasonJson]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
        seasonJson <- map["json"]
    }
    
}


struct RoundSeasonJson : Mappable {
    var id : Int?
    var round_id : Int?
    var season_id : Int?
    var league_id : Int?
    var name : Int?
    var stage_id : Int?
    var start : Int?
    var end : Int?
    var fixture : [SeasonFixture]?
    var current : Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        round_id <- map["round_id"]
        season_id <- map["season_id"]
        league_id <- map["league_id"]
        name <- map["name"]
        stage_id <- map["stage_id"]
        start <- map["start"]
        end <- map["end"]
        fixture <- map["fixture"]
        current <- map["current"]
    }
    
}

struct SeasonSeasonCurrentRound : Mappable {
    var round_id : Int?
    var name : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        round_id <- map["round_id"]
        name <- map["name"]
    }
    
}


struct RoundSeasonRoundSeasonData : Mappable {
    var firstname : String?
    var id : Int?
    var fullname : String?
    var common_name : String?
    var lastname : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        firstname <- map["firstname"]
        id <- map["id"]
        fullname <- map["fullname"]
        common_name <- map["common_name"]
        lastname <- map["lastname"]
    }
    
}
struct SeasonEvents : Mappable {
    var data : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        data <- map["data"]
    }
    
}

struct SeasonFixture : Mappable {
    var date : Int?
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
    }
    
}


struct SeasonFormations : Mappable {
    var visitorteam_formation : String?
    var localteam_formation : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        visitorteam_formation <- map["visitorteam_formation"]
        localteam_formation <- map["localteam_formation"]
    }
    
}


struct SeasonLocalTeam : Mappable {
    var data : RoundSeasonRoundSeasonData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    
}


struct Referee : Mappable {
    var data : RoundSeasonRoundSeasonData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    
}


struct SeasonScores : Mappable {
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

struct SeasonStanding : Mappable {
    var visitorteam_position : Int?
    var localteam_position : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        visitorteam_position <- map["visitorteam_position"]
        localteam_position <- map["localteam_position"]
    }
    
}


struct SeasonStarting_at : Mappable {
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



struct RoundSeasonStats : Mappable {
    var data : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    
}


struct SeasonTime : Mappable {
    var added_time : String?
    var starting_at : SeasonStarting_at?
    var injury_time : String?
    var extra_minute : String?
    var status : String?
    var minute : Int?
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



struct SeasonVisitorTeam : Mappable {
    var data : RoundSeasonRoundSeasonData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    
}
