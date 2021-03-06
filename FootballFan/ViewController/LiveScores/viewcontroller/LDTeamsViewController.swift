//
//  LDTeamsViewController.swift
//  FootballFan
//
//  Created by Apple on 31/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class LDTeamsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var season_id = 0
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    var arrstanding: [AnyObject] = []
    var serialArray = [[Int]]()
    
    @IBOutlet weak var storytableview: UITableView?
    @IBOutlet weak var segments: UISegmentedControl?
    @IBOutlet var topHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smatchdayapiCall()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(appDelegate().allContacts)
        //print(appDelegate().allContacts.count)
        
        
        return arrstanding.count
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //let dic = appDelegate().arrStanding[section] as! NSDictionary
        //let date = dic.value(forKey: "date")
        
        return "Match Events"
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView:EventHeader = storytableview!.dequeueReusableCell(withIdentifier: "EventHeader") as! EventHeader
        
        let dic = arrstanding[section] as! NSDictionary
        headerView.headername?.text = dic.value(forKey: "result") as! String
        // headerView.headerlabelHightConstraint2.constant = 0.0
        
        return headerView
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dic = arrstanding[section]
        let result = dic.value(forKey: "result") as! String
        let arr = dic.value(forKey: result  ) as! NSArray
        return arr.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:StandingCell = storytableview!.dequeueReusableCell(withIdentifier: "StandingCell") as! StandingCell
        let mainDic = arrstanding[indexPath.section]
        let result = mainDic.value(forKey: "result") as? String ?? ""
        if let arr = mainDic.value(forKey: result) as? NSArray {
            if let dict = arr[indexPath.row] as? NSDictionary {
                if(selectedsegmentindex == 0){
                    cell.teamName?.text = dict.value(forKey: "team_name") as? String ?? ConstantString.notAvailable
                    let  homelogo = dict.value(forKey: "logo_path") as? String ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                    if let url = URL(string:homelogo) {
                        cell.imgtagright?.af.setImage(withURL: url)
                    }
                    cell.Sno?.text = "\(serialArray[indexPath.section][indexPath.row])"
                    if let total = dict.value(forKey: "total") as? NSDictionary {
                        cell.GD?.text = "\(total.value(forKey: "goal_difference") as? String ?? "ConstantString.notAvailable")"
                        cell.Pts?.text = "\(total.value(forKey: "points") as? Int ?? 0)"
                    }
                    
                    if let overall = dict.value(forKey: "overall") as? NSDictionary {
                        cell.D?.text = "\(overall.value(forKey: "draw") as? Int ?? 0)"
                        cell.pl?.text = "\(overall.value(forKey: "games_played") as? Int ?? 0)"
                        cell.L?.text = "\(overall.value(forKey: "lost") as? Int ?? 0)"
                        cell.W?.text = "\(overall.value(forKey: "won") as? Int ?? 0)"
                    }
                    
                    
                }
                if(selectedsegmentindex == 1){
                    cell.teamName?.text = dict.value(forKey: "team_name") as? String ?? ConstantString.notAvailable
                    let  homelogo = dict.value(forKey: "logo_path") as? String ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                    if let url = URL(string:homelogo) {
                        cell.imgtagright?.af.setImage(withURL: url)
                    }
                    cell.Sno?.text = "\(serialArray[indexPath.section][indexPath.row])"
                    
                    if let total = dict.value(forKey: "total") as? NSDictionary {
                        cell.GD?.text = "\(total.value(forKey: "goal_difference") as? String ?? ConstantString.notAvailable)"
                        cell.Pts?.text = "\(total.value(forKey: "points") as? Int ?? 0)"
                    }
                    
                    if let overall = dict.value(forKey: "home") as? NSDictionary {
                        cell.D?.text = "\(overall.value(forKey: "draw") as? Int ?? 0)"
                        cell.pl?.text = "\(overall.value(forKey: "games_played") as? Int ?? 0)"
                        cell.L?.text = "\(overall.value(forKey: "lost") as? Int ?? 0)"
                        cell.W?.text = "\(overall.value(forKey: "won") as? Int ?? 0)"
                        let goals_scored = overall.value(forKey: "goals_scored") as? Int ?? 0
                        let goals_against = overall.value(forKey: "goals_against") as? Int ?? 0
                        let totalGD = goals_scored - goals_against
                        cell.GD?.text = "\(totalGD)"
                    }
                }
                if(selectedsegmentindex == 2){
                    cell.teamName?.text = dict.value(forKey: "team_name") as? String ?? ConstantString.notAvailable
                    let  homelogo = dict.value(forKey: "logo_path") as? String ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                    if let url = URL(string:homelogo) {
                        cell.imgtagright?.af.setImage(withURL: url)
                    }
                    cell.Sno?.text = "\(serialArray[indexPath.section][indexPath.row])"
                    
                    if let total = dict.value(forKey: "total") as? NSDictionary {
                        cell.GD?.text = "\(total.value(forKey: "goal_difference") as? String ?? ConstantString.notAvailable)"
                        cell.Pts?.text = "\(total.value(forKey: "points") as? Int ?? 0)"
                    }
                    
                    if let overall = dict.value(forKey: "away") as? NSDictionary {
                        cell.D?.text = "\(overall.value(forKey: "draw") as? Int ?? 0)"
                        cell.pl?.text = "\(overall.value(forKey: "games_played") as? Int ?? 0)"
                        cell.L?.text = "\(overall.value(forKey: "lost") as? Int ?? 0)"
                        cell.W?.text = "\(overall.value(forKey: "won") as? Int ?? 0)"
                        let goals_scored = overall.value(forKey: "goals_scored") as? Int ?? 0
                        let goals_against = overall.value(forKey: "goals_against") as? Int ?? 0
                        let totalGD = goals_scored - goals_against
                        cell.GD?.text = "\(totalGD)"
                    }
                }
            }
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let dic = data[indexPath.row]
        
        
        
        
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func smatchdayapiCall(){
        if ClassReachability.isConnectedToNetwork() {
            var serialNum = 1
            let url = "\(baseurl)/Standing/Season/\(season_id)"
            AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let status1: Bool = json["success"] as! Bool
                        if(status1){
                            self.arrstanding = json["json"] as! [AnyObject]
                            for index in 0..<self.arrstanding.count {
                                let dic = self.arrstanding[index]
                                let result = dic.value(forKey: "result") as! String
                                let arr = dic.value(forKey: result  ) as! NSArray
                                var tempSerialArray = [Int]()
                                for _ in 0..<arr.count {
                                    tempSerialArray.append(serialNum)
                                    serialNum = serialNum+1
                                }
                                self.serialArray.append(tempSerialArray)
                            }
                            self.storytableview?.reloadData()
                        }
                        else{
                            
                        }
                        if self.arrstanding.count > 0 {
                            self.topHeaderView.isHidden = false
                        } else {
                            self.topHeaderView.isHidden = true
                        }
                    }
                case .failure(let error):
                    print(error)  
                    break
                    // error handling
                    
                }
                
            }
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
}
