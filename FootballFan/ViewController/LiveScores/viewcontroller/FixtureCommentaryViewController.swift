//
//  FixtureCommentaryViewController.swift
//  FootballFan
//
//  Created by Apple on 01/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
class FixtureCommentaryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var fixtureComentryData : Fixture?
   var season_id: AnyObject = 0 as AnyObject
        var dic: NSDictionary = NSDictionary()
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    @IBOutlet weak var storytableview: UITableView?
    var arrcommentary: [AnyObject] = []
  var Fixture_id: AnyObject  = 0 as AnyObject
    @IBOutlet weak var hometeam: UILabel?
    @IBOutlet weak var visitteam: UILabel?
    @IBOutlet weak var imghometeam: UIImageView?
       @IBOutlet weak var imgvisitteam: UIImageView?
    @IBOutlet weak var lblstatus: UILabel?
     @IBOutlet weak var lbltime: UILabel?
    var homeId:Int = 0
       var visitorId:Int = 0
    var matchstatus:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     apiCall()
        storytableview?.delegate = self
        storytableview?.dataSource = self
       storytableview?.estimatedRowHeight = 120
                    storytableview?.rowHeight = UITableView.automaticDimension
        
        if let localTeam = dic.value(forKey: "localTeam") {
                         if let localTeamDetil = (localTeam as AnyObject).value(forKey: "data") {
                      
                             if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                              let  homename = name as! String
                               let  homelogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                   hometeam?.text = homename
                                    let url = URL(string:homelogo)!
                                   homeId = (localTeamDetil as AnyObject).value(forKey: "id") as! Int
                                    imghometeam?.af.setImage(withURL: url)
                          }
                      }}
                  if let visitorTeam = dic.value(forKey: "visitorTeam") {
                    if let localTeamDetil = (visitorTeam as AnyObject).value(forKey: "data") {
                  
                        if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                           let visitorname = name as! String
                                                          let visitorlogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                                             visitteam?.text = visitorname
                                                             let url1 = URL(string:visitorlogo)!
                                                                           imgvisitteam?.af.setImage(withURL: url1 )
                           visitorId = (localTeamDetil as AnyObject).value(forKey: "id") as! Int
                      }}}
                  /*  let  homelogo = dic.value(forKey: "hometeamlogo") as! String
                           hometeam?.text = dic.value(forKey: "hometeamname") as? String
                       let url = URL(string:homelogo)!
                                                                
                       imghometeam?.af.setImage(withURL: url)
                           let  visitorteamlogo = dic.value(forKey: "visitorteamlogo") as! String
                           visitteam?.text = dic.value(forKey: "visitorteamname") as? String
                              let url1 = URL(string:visitorteamlogo)!
                                                                       
                              imgvisitteam?.af.setImage(withURL: url1)
                           homeId = dic.value(forKey: "homeid") as! Int
                           visitorId = dic.value(forKey: "visitorid") as! Int*/
      /*  matchstatus = dic.value(forKey: "matchStatus") as? String ?? ""
        if(matchstatus == "FT"){
            lblstatus?.text = "Final Score"
            lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
            lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
        }
            else if(matchstatus == "LIVE"){
           lblstatus?.text = "Live"
                   lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
            lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
        }
        else if(matchstatus == "NS"){
             lblstatus?.text = "Time"
             lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
        if let mili = dic.value(forKey: "fixtureTime")
        {
            let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
            //dateFormatter.dateStyle = .short
           
                 dateFormatter.dateFormat = "HH:mm"
           lbltime?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
           
            
        }
        }*/
        var homescore = 0
                  var visitorscore = 0
                  if let scoredic = dic.value(forKey: "scores") {
                                  homescore = (scoredic as AnyObject).value(forKey: "localteam_score") as! Int
                                  visitorscore = (scoredic as AnyObject).value(forKey: "visitorteam_score") as! Int
                                 lbltime?.text = "\(homescore) : \(visitorscore)"
                             }
                  if let status = dic.value(forKey: "time") {
                      let status = (status as AnyObject).value(forKey: "status") as! String
                      if(status == "FT"){
                                    lblstatus?.text = "Final Score"
                                    lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
                       lbltime?.text = "\(homescore) : \(visitorscore)"
                                   // lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
                                }
                                    else if(status == "LIVE"){
                                   lblstatus?.text = "Live"
                       lbltime?.text = "\(homescore) : \(visitorscore)"
                                           //lbltime?.text = "\(dic.value(forKey: "homescore") as! Int) : \(dic.value(forKey: "visitorscore") as! Int)"
                                    lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                                }
                                else if(status == "NS"){
                                     lblstatus?.text = "Time"
                                     lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                                if let mili = dic.value(forKey: "fixtureTime")
                                {
                                    let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                                    let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                                    let dateFormatter = DateFormatter()
                                    //dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
                                    //dateFormatter.dateStyle = .short
                                   
                                         dateFormatter.dateFormat = "HH:mm"
                                   lbltime?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                                   
                                    
                                }
                                }
                  }
      
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
      
      }
    // MARK: - Table view data source
       
       func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // let arrrow = resultArry[section] as! NSArray
           //print(appDelegate().arrNewsLikes.count)
           return arrcommentary.count
           
       }
       /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
        }*/
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell:CommentaryCell = storytableview!.dequeueReusableCell(withIdentifier: "CommentaryCell") as! CommentaryCell
           let dic: NSDictionary? = arrcommentary[indexPath.row] as? NSDictionary
        let minutevalue = dic?.value(forKey: "minute") as! Int
        let extraMinute = dic?.value(forKey: "extraMinute") as! Int
        cell.vline1?.isHidden = false
        if(extraMinute == 0 && minutevalue != 0){
            cell.lblminuts?.text = "\(minutevalue)'"
        }
        else if(indexPath.row == 0 && minutevalue == 0){
            cell.lblminuts?.text = "FT"
            cell.vline1?.isHidden = true
        }
        else if(extraMinute == 0 && minutevalue == 0){
                cell.lblminuts?.text = "\(minutevalue)'"
            }
        else{
            cell.lblminuts?.text = "\(minutevalue) + \(extraMinute)'"
        }
        cell.lblheadline?.text = dic?.value(forKey: "comment") as? String
        
          
          if(matchstatus == "LIVE"){
            cell.vline1?.backgroundColor = UIColor.green
            cell.vline2?.backgroundColor = UIColor.green
        }
                      
           
        
           return cell
       }
       func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           
       }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          // let dic: NSDictionary? = apd.arrnotification[indexPath.row] as? NSDictionary
                // print(dic)
         //  showevent(dic: dic!)
                 //cell.contactName?.text = dic?.value(forKey: "username") as? String
               
          // var dict1: [String: AnyObject] = apd.arrnotification[indexPath.row] as! [String: AnyObject]
          //dict1["Is_read"] = 1 as AnyObject
        
           //apd.arrnotification[indexPath.row] = dict1 as AnyObject
                    
           
       }
     func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               
               let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
                   
               });
               
               alert.addAction(action1)
               self.present(alert, animated: true, completion:nil)
           }
    func apiCall(){
             if ClassReachability.isConnectedToNetwork() {
             let url = "\(baseurl)/Commentaries/Fixture/\(Fixture_id)"
                    AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                                              switch response.result {
                                                                                                      case .success(let value):
                                                                                                          if let json = value as? [String: Any] {
                                                                                                                                                  let status1: Bool = json["success"] as! Bool
                                                                             if(status1){
                                                                               self.arrcommentary = json["json"] as! [AnyObject]
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
