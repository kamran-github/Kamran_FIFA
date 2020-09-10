//
//  BaseTabBarController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 19/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//
import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        selectedIndex = defaultIndex
        
        
    }
    
 
}
