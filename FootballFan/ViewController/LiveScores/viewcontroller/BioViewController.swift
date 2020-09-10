//
//  BioViewController.swift
//  FootballFan
//
//  Created by Apple on 13/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class BioViewController: UIViewController {
    var season_id: AnyObject = 0 as AnyObject
    var dic: NSDictionary = NSDictionary()
    var apd = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var playstate: UILabel?
    @IBOutlet weak var playername: UILabel?
    @IBOutlet weak var playerimg: UIImageView?
    @IBOutlet weak var number: UILabel?
    @IBOutlet weak var teamimg: UIImageView?
     @IBOutlet weak var nationality: UILabel?
     @IBOutlet weak var birthdate: UILabel?
    @IBOutlet weak var height: UILabel?
       @IBOutlet weak var weight: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // smatchdayapiCall()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func updateUI(){
        let detail = dic.value(forKey: "detail") as! NSDictionary
        playername?.text = detail.value(forKey: "fullname") as? String
        number?.text = "\(dic.value(forKey: "number") as! Int)"
        let  homelogo = detail.value(forKey: "image_path") as! String
        
        let url = URL(string:homelogo)!
        
        playerimg?.af.setImage(withURL: url)
        let position = dic.value(forKey: "position") as! String
        if(position == "A"){
            playstate?.text = "Attacker"
        }
        else if(position == "M"){
            playstate?.text = ""
        }
        else if(position == "G"){
            playstate?.text = "Goalkeeper "
        }
        else if(position == "D"){
            playstate?.text = "Defender"
        }
        else if(position == "F"){
            playstate?.text = "ForWard"
        }
        else{
            playstate?.text = position
        }
        nationality?.text = detail.value(forKey: "nationality") as? String
         nationality?.text = detail.value(forKey: "height") as? String
        nationality?.text = detail.value(forKey: "weight") as? String
        nationality?.text = detail.value(forKey: "birthdate") as? String
        
    }
}
