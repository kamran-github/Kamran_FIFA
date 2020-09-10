//
//  Merchant_categories.swift
//  FootballFan
//
//  Created by Apple on 01/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
class Merchant_categories:SQLTable {
    
    var CategoryName = ""
    var CategoryID: Int64 = 0
    var ParentID: Int64 = 0
    var Description = ""
    var CategoryImage = ""
    
}
