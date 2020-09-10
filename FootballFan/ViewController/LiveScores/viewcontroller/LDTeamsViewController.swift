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
   var season_id: AnyObject = 0 as AnyObject
       
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    @IBOutlet weak var storytableview: UITableView?
    var arrstanding: [AnyObject] = []
    @IBOutlet weak var segments: UISegmentedControl?
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
                let dic = arrstanding[indexPath.section]
                                  let result = dic.value(forKey: "result") as! String
                                   let arr = dic.value(forKey: result) as! NSArray
                let dict1 = arr[indexPath.row] as! NSDictionary
              
               if(selectedsegmentindex == 0){
                   //let localStandings = dic.value(forKey: "localStandings") as! NSDictionary
                   cell.teamName?.text = dict1.value(forKey: "team_name") as? String
                //Comment By Vipin
        
                   let  homelogo = dict1.value(forKey: "logo_path") as! String
                 let url = URL(string:homelogo)!
                                                                              
                                  cell.imgtagright?.af.setImage(withURL: url)
                   cell.Sno?.text = "\(dict1.value(forKey: "position") as! Int)"
                   let total = dict1.value(forKey: "total") as! NSDictionary
                   cell.GD?.text = "\(total.value(forKey: "goal_difference") as AnyObject)"
                   cell.Pts?.text = "\(total.value(forKey: "points") as! Int)"
                   let overall = dict1.value(forKey: "overall") as! NSDictionary
                   cell.D?.text = "\(overall.value(forKey: "draw") as! Int)"
                   cell.pl?.text = "\(overall.value(forKey: "games_played") as! Int)"
                   cell.L?.text = "\(overall.value(forKey: "lost") as! Int)"
                   cell.W?.text = "\(overall.value(forKey: "won") as! Int)"
                   
               }
                if(selectedsegmentindex == 1){
                    //let localStandings = dic.value(forKey: "localStandings") as! NSDictionary
                    cell.teamName?.text = dict1.value(forKey: "team_name") as? String
                    let  homelogo = dict1.value(forKey: "logo_path") as! String
                                         
                                      let url = URL(string:homelogo)!
                                                                               
                                   cell.imgtagright?.af.setImage(withURL: url)
                    cell.Sno?.text = "\(dict1.value(forKey: "position") as! Int)"
                    let total = dict1.value(forKey: "total") as! NSDictionary
                    cell.GD?.text = "\(total.value(forKey: "goal_difference") as AnyObject)"
                    cell.Pts?.text = "\(total.value(forKey: "points") as! Int)"
                    let overall = dict1.value(forKey: "home") as! NSDictionary
                    cell.D?.text = "\(overall.value(forKey: "draw") as! Int)"
                    cell.pl?.text = "\(overall.value(forKey: "games_played") as! Int)"
                    cell.L?.text = "\(overall.value(forKey: "lost") as! Int)"
                    cell.W?.text = "\(overall.value(forKey: "won") as! Int)"
                    let goals_scored = overall.value(forKey: "goals_scored") as! Int
                    let goals_against = overall.value(forKey: "goals_against") as! Int
                    let totalGD = goals_scored - goals_against
                    cell.GD?.text = "\(totalGD)"
                    
                }
               if(selectedsegmentindex == 2){
                               //let localStandings = dic.value(forKey: "localStandings") as! NSDictionary
                               cell.teamName?.text = dict1.value(forKey: "team_name") as? String
                               let  homelogo = dict1.value(forKey: "logo_path") as! String
                                                    
                                                 let url = URL(string:homelogo)!
                                                                                          
                                              cell.imgtagright?.af.setImage(withURL: url)
                               cell.Sno?.text = "\(dict1.value(forKey: "position") as! Int)"
                               let total = dict1.value(forKey: "total") as! NSDictionary
                               cell.GD?.text = "\(total.value(forKey: "goal_difference") as AnyObject)"
                               cell.Pts?.text = "\(total.value(forKey: "points") as! Int)"
                               let overall = dict1.value(forKey: "away") as! NSDictionary
                               cell.D?.text = "\(overall.value(forKey: "draw") as! Int)"
                               cell.pl?.text = "\(overall.value(forKey: "games_played") as! Int)"
                               cell.L?.text = "\(overall.value(forKey: "lost") as! Int)"
                               cell.W?.text = "\(overall.value(forKey: "won") as! Int)"
                               let goals_scored = overall.value(forKey: "goals_scored") as! Int
                               let goals_against = overall.value(forKey: "goals_against") as! Int
                               let totalGD = goals_scored - goals_against
                               cell.GD?.text = "\(totalGD)"
                               
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
          let url = "\(baseurl)/Standing/Season/\(season_id)"
                 AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                                           switch response.result {
                                                                                                   case .success(let value):
                                                                                                       if let json = value as? [String: Any] {
                                                                                                                                               let status1: Bool = json["success"] as! Bool
                                                                          if(status1){
                                                                            self.arrstanding = json["json"] as! [AnyObject]
                                                                            self.storytableview?.reloadData()
                                                                                                        }
                                                                                                        else{
                                                                                                             
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
