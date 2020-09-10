//
//  CustomSlider.swift
//  FootballFan
//
//  Created by Mayank Sharma on 06/03/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: trackWidth))
        super.trackRect(forBounds: customBounds)
        
       
        self.layer.cornerRadius = customBounds.height / 2
        self.clipsToBounds = true
        
        return customBounds
    }
    
}
