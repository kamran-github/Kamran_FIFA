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
import ObjectMapper
class BioViewController: UIViewController {
    var season_id = 0
    var playerData : Lineup?
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
        
        playername?.text = playerData?.detail?.fullname
        number?.text = "\(playerData?.number ?? 0)"
        let  homelogo = playerData?.detail?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
        let url = URL(string:homelogo)!
        playerimg?.af.setImage(withURL: url)
        
        let position = playerData?.position
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
        nationality?.text = playerData?.detail?.nationality
         nationality?.text = playerData?.detail?.height
        nationality?.text = playerData?.detail?.weight
        nationality?.text = playerData?.detail?.birthdate
        
    }
}
