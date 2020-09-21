//
//  TDSquadViewController.swift
//  FootballFan
//
//  Created by Apple on 01/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class TDSquadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var season_id = 0
    var teamId = 0
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    var squadData : SquadModel?
    
    @IBOutlet weak var storytableview: UITableView?
    @IBOutlet weak var segments: UISegmentedControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        getSquadDeatilsAPI()
        storytableview?.delegate = self
        storytableview?.dataSource = self
        self.segments?.layer.cornerRadius = 15.0
        // self.segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
        // self.segmentedControl.layer.borderWidth = 1.0f;
        self.segments?.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedsegmentindex = 0
            storytableview?.reloadData()
        case 1:
            selectedsegmentindex = 1
            storytableview?.reloadData()
        case 2:
            selectedsegmentindex = 2
            storytableview?.reloadData()
        default:
            break;
        }
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
        });
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    func getSquadDeatilsAPI(){
        if ClassReachability.isConnectedToNetwork() {
            //let url = "http://ffapitest.ifootballfan.com:7001/Squad/Team/Season/468/16030"
            let url = "\(baseurl)/\("Squad/Team/Season")/\(teamId)/\(season_id)"
            AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let status1: Bool = json["success"] as! Bool
                        if(status1){
                            self.squadData = Mapper<SquadModel>().map(JSONObject: json)
                            self.storytableview?.reloadData()
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
}

extension TDSquadViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let squadData = self.squadData {
            if selectedsegmentindex == 0 {
                return squadData.json?.teamsquad?.count ?? 0
            } else if selectedsegmentindex == 1 {
                return squadData.json?.seasonsquad?.count ?? 0
            } else if selectedsegmentindex == 2 {
                return squadData.json?.fixturesquad?.count ?? 0
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedsegmentindex == 0 {
            return self.squadData?.json?.teamsquad?[section].lineup?.count ?? 0
        } else if selectedsegmentindex == 1 {
            return squadData?.json?.seasonsquad?[section].lineup?.count ?? 0
        } else if selectedsegmentindex == 2 {
            return squadData?.json?.fixturesquad?[section].lineup?.count ?? 0
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.init(hex: "EFEFEF")
        header.textLabel?.textColor = UIColor.black
        if selectedsegmentindex == 0 {
            header.textLabel?.text = self.squadData?.json?.teamsquad?[section].position_name
        } else if selectedsegmentindex == 1 {
            header.textLabel?.text = self.squadData?.json?.seasonsquad?[section].position_name
        } else if selectedsegmentindex == 2 {
            header.textLabel?.text = self.squadData?.json?.fixturesquad?[section].position_name
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PlayerCell = storytableview?.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        if selectedsegmentindex == 0 {
            cell.headername?.text = self.squadData?.json?.teamsquad?[indexPath.section].lineup![indexPath.row].detail?.fullname ?? ConstantString.notAvailable
            cell.playstate?.text = self.squadData?.json?.teamsquad?[indexPath.section].lineup![indexPath.row].detail?.nationality ?? ConstantString.notAvailable
            cell.number?.text = "\(self.squadData?.json?.teamsquad?[indexPath.section].lineup![indexPath.row].number ?? 0)"
            let url = URL(string:self.squadData?.json?.teamsquad?[indexPath.section].lineup![indexPath.row].detail?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg")
            cell.playerimg?.af.setImage(withURL: url!)
        } else if selectedsegmentindex == 1 {
            cell.headername?.text = self.squadData?.json?.seasonsquad?[indexPath.section].lineup![indexPath.row].detail?.fullname ?? ConstantString.notAvailable
            cell.playstate?.text = self.squadData?.json?.seasonsquad?[indexPath.section].lineup![indexPath.row].detail?.nationality ?? ConstantString.notAvailable
            cell.number?.text = "\(self.squadData?.json?.seasonsquad?[indexPath.section].lineup![indexPath.row].number ?? 0)"
            let url = URL(string:self.squadData?.json?.seasonsquad?[indexPath.section].lineup![indexPath.row].detail?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg")
            cell.playerimg?.af.setImage(withURL: url!)
        } else if selectedsegmentindex == 2 {
            cell.headername?.text = self.squadData?.json?.fixturesquad?[indexPath.section].lineup![indexPath.row].detail?.fullname ?? ConstantString.notAvailable
            cell.playstate?.text = self.squadData?.json?.fixturesquad?[indexPath.section].lineup![indexPath.row].detail?.nationality ?? ConstantString.notAvailable
            cell.number?.text = "\(self.squadData?.json?.fixturesquad?[indexPath.section].lineup![indexPath.row].number ?? 0)"
            let url = URL(string:self.squadData?.json?.fixturesquad?[indexPath.section].lineup![indexPath.row].detail?.image_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg")
            cell.playerimg?.af.setImage(withURL: url!)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let playerViewController : PlayerViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerD") as!
        PlayerViewController
        if selectedsegmentindex == 0 {
            playerViewController.playedID = self.squadData?.json?.teamsquad?[indexPath.section].lineup![indexPath.row].player_id ?? 0
        } else if selectedsegmentindex == 1 {
            playerViewController.playedID = self.squadData?.json?.seasonsquad?[indexPath.section].lineup![indexPath.row].player_id ?? 0
        } else if selectedsegmentindex == 2 {
            playerViewController.playedID = self.squadData?.json?.fixturesquad?[indexPath.section].lineup![indexPath.row].player_id ?? 0
        }
        show(playerViewController, sender: self)
    }
    
}
