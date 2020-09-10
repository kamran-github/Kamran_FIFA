//
//  NewsCategories.swift
//  FootballFan
//
//  Created by Mayank Sharma on 20/09/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
class NewsCategories:SQLTable {
    
    var cname = ""
    var cid: Int64 = 0
    var isnews = "Yes"
    var isfixtures = "Yes"
    var isstanding = "Yes"
    var isgroup = "Yes"
    var isresult = "Yes"
    var fullname = ""
}
