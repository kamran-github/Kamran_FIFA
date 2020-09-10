//
//  onlyforscreenshort.swift
//  FootballFan
//
//  Created by Mayank Sharma on 02/02/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class onlyforscreenshort: UIViewController {
    
    
    // MARK: - Table view data source
    override func viewDidLoad() {
        super.viewDidLoad()
        AnimationIndicatorView.show((self.view)!, loadingText: "You won \(100) FanCoins for signing up.\n\n900 FanCoins away from redeeming them.\n\nLearn more" ,fancoins: String(10) )
    }
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}
