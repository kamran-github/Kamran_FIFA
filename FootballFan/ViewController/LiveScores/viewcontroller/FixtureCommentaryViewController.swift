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
    var homeId:Int = 0
    var visitorId:Int = 0
    var matchstatus:String = ""
    var arrcommentary: [AnyObject] = []
    var Fixture_id = 0
    var fixtureComentryData : Fixture?
    var season_id: AnyObject = 0 as AnyObject
    var dic: NSDictionary = NSDictionary()
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    
    @IBOutlet weak var storytableview: UITableView?
    @IBOutlet weak var hometeam: UILabel?
    @IBOutlet weak var visitteam: UILabel?
    @IBOutlet weak var imghometeam: UIImageView?
    @IBOutlet weak var imgvisitteam: UIImageView?
    @IBOutlet weak var lblstatus: UILabel?
    @IBOutlet weak var lbltime: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
        storytableview?.delegate = self
        storytableview?.dataSource = self
        storytableview?.estimatedRowHeight = 120
        storytableview?.rowHeight = UITableView.automaticDimension
        
        if let localTeam = fixtureComentryData?.localTeam {
        if let localTeamDetil = localTeam.data {
            if let name = localTeamDetil.name{
                let  homelogo = localTeamDetil.logo_path ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                hometeam?.text = name
                let url = URL(string:homelogo)!
                homeId = localTeamDetil.id ?? 0
                imghometeam?.af.setImage(withURL: url)
            }
        }}
        if let visitorTeam = fixtureComentryData?.visitorTeam {
            if let visitorTeamDetil = visitorTeam.data {
                if let name = visitorTeamDetil.name{
                    let visitorlogo = visitorTeamDetil.logo_path  ?? "https://img.favpng.com/11/10/15/logo-football-photography-png-favpng-PHcuh7RUxh66QMFf1CRjLjfv5.jpg"
                    visitteam?.text = name
                    let url1 = URL(string:visitorlogo)!
                    imgvisitteam?.af.setImage(withURL: url1 )
                    visitorId = visitorTeamDetil.id ?? 0
        }}}
      
        var homescore = 0
        var visitorscore = 0
        if let scoredic = fixtureComentryData?.scores {
            homescore = scoredic.localteam_score ?? 0
            visitorscore = scoredic.visitorteam_score ?? 0
            lbltime?.text = "\(homescore) : \(visitorscore)"
        }
        if let status = fixtureComentryData?.time {
            let status = status.status
            if(status == "FT"){
                lblstatus?.text = "Final Score"
                lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
                lbltime?.text = "\(homescore) : \(visitorscore)"
            }
            else if(status == "LIVE"){
                lblstatus?.text = "Live"
                lbltime?.text = "\(homescore) : \(visitorscore)"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
            }
            else if(status == "NS"){
                lblstatus?.text = "Time"
                lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                if let mili = fixtureComentryData?.fixtureTime
                {
                    let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                    let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
                    dateFormatter.dateStyle = .short
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
        let minutevalue = dic?.value(forKey: "minute") as? Int
        let extraMinute = dic?.value(forKey: "extraMinute") as? Int
        cell.vline1?.isHidden = false
        if(extraMinute == 0 && minutevalue != 0){
            cell.lblminuts?.text = "\(minutevalue ?? 0)'"
        }
        else if(indexPath.row == 0 && minutevalue == 0){
            cell.lblminuts?.text = "FT"
            cell.vline1?.isHidden = true
        }
        else if(extraMinute == 0 && minutevalue == 0){
            cell.lblminuts?.text = "\(minutevalue ?? 0)'"
        }
        else{
            cell.lblminuts?.text = "\(minutevalue ?? 0) + \(extraMinute ?? 0)'"
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
            //Changed Sept
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
