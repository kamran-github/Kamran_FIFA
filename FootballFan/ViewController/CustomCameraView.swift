//
//  CustomCameraView.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 14/08/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class CustomCameraView: UIView {
    
    var label: UILabel = UILabel()
    let btnGallery: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView() {
        /*label.frame = CGRect(x: 50, y: 10, width: 200, height: 100)
        label.backgroundColor=UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "test label"
        //label.isHidden=true
        self.addSubview(label)*/
        //self.backgroundColor = UIColor.white
        
        //let btn: UIButton = UIButton()
        btnGallery.frame.size = CGSize(width: 50, height: 50) //CGRect(x: 0, y: 0, width: 50, height: 50)
        btnGallery.backgroundColor=UIColor.red
        btnGallery.setTitle("X", for: UIControl.State.normal)
        //btnGallery.addTarget(self, action: #selector(CustomCameraView.changeLabel), for: UIControlEvents.touchUpInside)
        btnGallery.isUserInteractionEnabled = true
        btnGallery.clipsToBounds = true
        self.addSubview(btnGallery)
        
        //let trailingConstraint = NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: 10.0)
        btnGallery.translatesAutoresizingMaskIntoConstraints = false
        
        /*let leadingConstraint = NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 0.0)*/
        
        let trailingConstraint = NSLayoutConstraint(item: btnGallery, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailingMargin, multiplier: 1.0, constant: 10.0)
        
        let bottomConstraint = NSLayoutConstraint(item: btnGallery, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 10.0)
        
        
        let widthConstraint = NSLayoutConstraint(item: btnGallery, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        let heightConstraint = NSLayoutConstraint(item: btnGallery, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        
        self.addConstraints([trailingConstraint, bottomConstraint, widthConstraint, heightConstraint])
        
        /*let txtField : UITextView = UITextView()
        txtField.frame = CGRect(x: 50, y: 250, width: 100, height: 50)
        txtField.backgroundColor = UIColor.gray
        self.addSubview(txtField)*/
    }
    
    /*func changeLabel()
    {
        print("Changed")
    }*/

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
