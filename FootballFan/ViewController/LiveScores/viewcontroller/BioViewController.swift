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
    var playedID = 0
    var playerData : PlayerDataModel?
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
    @IBOutlet weak var birthCountry: UILabel!
    @IBOutlet weak var birthPlace: UILabel!
    @IBOutlet weak var teamName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlayerDeatilsAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func updateUI(){
        
        playername?.text = playerData?.json?.fullname
        // number?.text = "\(playerData?.json.num ?? 0)"
        let  homelogo = playerData?.json?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
        let url = URL(string:homelogo)!
        playerimg?.af.setImage(withURL: url)
        playerimg?.layer.cornerRadius = (playerimg?.frame.height)! / 2
        playerimg?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        playerimg?.layer.borderWidth = 1
        playerimg?.clipsToBounds = true
        let position = playerData?.json?.position
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
        let  teamlogo = playerData?.json?.team?.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
        let teamUrl = URL(string:teamlogo)!
        teamimg?.af.setImage(withURL: teamUrl )
        teamName.text = playerData?.json?.team?.name
        
        nationality?.text = playerData?.json?.nationality
        height?.text = playerData?.json?.height
        weight?.text = playerData?.json?.weight
        birthdate?.text = playerData?.json?.birthdate
        birthCountry?.text = playerData?.json?.birthcountry
        birthPlace?.text = playerData?.json?.birthplace
    }
    
    func getPlayerDeatilsAPI(){
        if ClassReachability.isConnectedToNetwork() {
            //let url = "http://ffapitest.ifootballfan.com:7001/Player/198364"
            let url = "\(baseurl)/\("Player")/\(playedID)"
            AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let status1: Bool = json["success"] as! Bool
                        if(status1){
                            self.playerData = Mapper<PlayerDataModel>().map(JSONObject: json)
                            self.updateUI()
                        }else{
                            self.alertWithTitle(title: nil, message: ConstantString.apiFailMsg, ViewController: self)
                        }
                    }
                case .failure(let error):
                    self.alertWithTitle(title: nil, message: ConstantString.apiFailMsg, ViewController: self)
                    print(error)
                    break
                }
            }
        } else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
        });
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
}

