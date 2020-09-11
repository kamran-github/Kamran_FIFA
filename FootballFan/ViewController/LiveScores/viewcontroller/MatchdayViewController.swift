//
//  MatchdayViewController.swift
//  FootballFan
//
//  Created by Apple on 23/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class MatchdayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   var season_id: AnyObject = 0 as AnyObject
       
    var apd = UIApplication.shared.delegate as! AppDelegate
        @IBOutlet weak var Dropdownlabel: UILabel?
        @IBOutlet weak var Dropdownbut: UIButton?
     @IBOutlet weak var popupView: UIView?
     @IBOutlet weak var poptable: UITableView?
    @IBOutlet weak var storytableview: UITableView?
     var Allarrfixture: [AnyObject] = []
     var arrfixture: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture_Showpopup:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Showpopup(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture_Showpopup.delegate = self as? UIGestureRecognizerDelegate
        
        Dropdownlabel?.addGestureRecognizer(longPressGesture_Showpopup)
        Dropdownlabel?.isUserInteractionEnabled = true
        smatchdayapiCall()
        poptable?.delegate = self
        poptable?.dataSource = self
        storytableview?.delegate = self
               storytableview?.dataSource = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
         let button2 = UIBarButtonItem(image: UIImage(named: "shear_dark"), style: .plain, target: self, action: #selector(self.Showcalender(sender:)))
                     let rightSearchBarButtonItem1:UIBarButtonItem = button2
         
                   /*  let rightSearchBarButtonItem2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.Getsliderdata))*/
                     
                     
                     parent?.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
       // storytableview?.estimatedRowHeight = 120shear_dark
       // storytableview?.rowHeight = UITableView.automaticDimension
      }
      @objc func Showpopup(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        popupView?.isHidden  = false
        poptable?.reloadData()
    }
     @objc func Showcalender(sender:UIButton) {
    }
 @IBAction func showpopup(){
      popupView?.isHidden  = false
    poptable?.reloadData()
    }
    func smatchdayapiCall(){
         if ClassReachability.isConnectedToNetwork() {
        let milisecond = apd.getUTCFormateDate()
            
       let url = "\(baseurl)/Rounds/Season/\(season_id)/\(milisecond)"
              AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                                        switch response.result {
                                                                                                case .success(let value):
                                                                                                    if let json = value as? [String: Any] {
                                                                                                                                            let status1: Bool = json["success"] as! Bool
                                                                                                      if(status1){
                                                                                                        
                                                                                                      self.Allarrfixture = json["json"] as! [AnyObject]
                                                                                                        if(self.Allarrfixture.count>0){
                                                                                                            for j in 0..<self.Allarrfixture.count{
                                                                                                                let dic = self.Allarrfixture[j] as! NSDictionary
                                                                                                                let current = dic.value(forKey: "current") as! Bool
                                                                                                                if(current){
                                                                                                                    self.Dropdownlabel?.text = "MatchDay \(dic.value(forKey: "name") as! Int)"
                                                                                                                    break
                                                                                                                }
                                                                                                                if(j == (self.Allarrfixture.count - 1)){
                                                                                                                    let dict = self.Allarrfixture[0] as! NSDictionary
                                                                                                                    
                                                                           self.Dropdownlabel?.text = "MatchDay \(dict.value(forKey: "name") as! Int)"                                     }
                                                                                                            }
                                                                                                        }
                                                                                                  //     self.createarraylist(timeint: currenttimestrmp)
                                                                                                      }else{
                                                                                                          
                                                                                                      }
                                                          }
                                                                                                      case .failure(let error):
                                                                                                      
                                                          break
                                                                                                                                                                                          // error handling
                                                                                                                                                                           
                                                                                                                                                                                      }
                                                                                                                          
                                                                                                                             }
            }
                                                else {
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         
         return "self.sections[section]"
         
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         // #warning Incomplete implementation, return the number of sections
        if(tableView == poptable){
              return 1
        }
        else{
            if arrfixture.count > 0 {
                storytableview?.backgroundView = nil
                     return arrfixture.count
                 } else {
                     let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
                     messageLabel.text = "Retrieving data.\nPlease wait."
                     messageLabel.numberOfLines = 0;
                     messageLabel.textAlignment = .center;
                     messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
                     messageLabel.sizeToFit()
                self.storytableview?.backgroundView = messageLabel;
                 }
            return 0
        }
         
     }
     
     // number of rows in table view
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if(tableView == storytableview){
             let dic = arrfixture[section]
            let mili = String(dic.value(forKey: "date") as! Int)
            let arr = dic.value(forKey: mili as! String ) as! NSArray
            return arr.count
         }
         else{
             return Allarrfixture.count
         }
         
     }
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if(tableView == storytableview){
         
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
        let dic = arrfixture[section]
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE"
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.dateFormat = "dd MMM"
        var starttime = ""
        if let mili = dic.value(forKey: "date")
        {
            let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
            
           
                starttime = "\(dateFormatter.string(from: myMilliseconds.dateFull as Date)),\(dateFormatter1.string(from: myMilliseconds.dateFull as Date))"
            
            
            
        }
         label.text = "  \(starttime)"//self.sections[section]
        
         
         headerView.addSubview(label)
         if #available(iOS 9.0, *) {
             label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
             label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
             label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            // label.heightAnchor.constraint(equalToConstant: 30).isActive = true
             
         } else {
             // Fallback on earlier versions
         }
         
         return headerView
        }else{
            return headerView
        }
     }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == storytableview){
               
         
             return 30.0
        }else{
            return 0
        }
        
     }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(tableView == storytableview){
                      
                
                    return 30.0
               }else{
                   return 0
               }
    }
      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
         if(tableView == storytableview){
         
         let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 5))
         separatorView.backgroundColor = UIColor.lightText
         footerView.addSubview(separatorView)
        }
         return footerView
     }
     /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 30.0
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80.0
      }*/
     
     // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == poptable){
         let cell:MatchdayDropdownCell = tableView.dequeueReusableCell(withIdentifier: "dropdown") as! MatchdayDropdownCell
         
        let dic = Allarrfixture[indexPath.row]
        cell.matchday?.text = "MatchDay \(dic.value(forKey: "name") as! Int)"
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE"
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.dateFormat = "dd MMM"
      var endtime = ""
             if let mili = dic.value(forKey: "end")
             {
                 let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                 let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                
                endtime = "\(dateFormatter.string(from: myMilliseconds.dateFull as Date)),\(dateFormatter1.string(from: myMilliseconds.dateFull as Date))"
                            
                 
                 
             }
        var starttime = ""
        if let mili = dic.value(forKey: "start")
        {
            let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
            let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
            
           
                starttime = "\(dateFormatter.string(from: myMilliseconds.dateFull as Date)),\(dateFormatter1.string(from: myMilliseconds.dateFull as Date))"
            
            
            
        }
       
        cell.lbltime?.text = "\(starttime) - \(endtime)"
         
         return cell
        }else{
            let cell:MatchdayscoreCell = tableView.dequeueReusableCell(withIdentifier: "MatchdayscoreCell") as! MatchdayscoreCell
            let dic = arrfixture[indexPath.section]
                               let mili = String(dic.value(forKey: "date") as! Int)
                               let arr = dic.value(forKey: mili as! String ) as! NSArray
            let dict1 = arr[indexPath.row] as! NSDictionary
            if let localTeam = dict1.value(forKey: "localTeam") {
                                 if let localTeamDetil = (localTeam as AnyObject).value(forKey: "data") {
                              
                                     if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                    let  homename = name as! String
                                    let  homelogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                        cell.hometeam?.text = homename
                                         let url = URL(string:homelogo)!
                                        
                                         cell.imghometeam?.af.setImage(withURL: url)
                                  }
                              }}
                          if let visitorTeam = dict1.value(forKey: "visitorTeam") {
                            if let localTeamDetil = (visitorTeam as AnyObject).value(forKey: "data") {
                          
                                if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                 let visitorname = name as! String
                                 let visitorlogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                    cell.visitteam?.text = visitorname
                                    let url1 = URL(string:visitorlogo)!
                                                      cell.imgvisitteam?.af.setImage(withURL: url1 )
                              }}}
            if let scoredic = dict1.value(forKey: "scores") {
                let homescore = (scoredic as AnyObject).value(forKey: "localteam_score") as! Int
                let visitorscore = (scoredic as AnyObject).value(forKey: "visitorteam_score") as! Int
                cell.lbltime?.text = "\(homescore) : \(visitorscore)"
            }
             
            return cell
        }
     }
     
     // method to run when table view cell is tapped
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("You tapped cell number \(indexPath.row).")
        if(tableView == poptable){
             let dic = Allarrfixture[indexPath.row]
            arrfixture = dic.value(forKey: "fixture") as! [AnyObject]
            storytableview?.reloadData()
            popupView?.isHidden = true
            Dropdownlabel?.text = "MatchDay \(dic.value(forKey: "name") as! Int)"
           
        }else{
            let dict1 = arrfixture[indexPath.row] as! NSDictionary
           
            let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
                  let myTeamsController : FixturescoreViewController = storyBoard.instantiateViewController(withIdentifier: "fixture") as!
            FixturescoreViewController
            
            
            myTeamsController.season_id = dict1.value(forKey: "season_id") as AnyObject as! Int
                   //myTeamsController.legname = dic.value(forKey: "legname") as! String
            myTeamsController.dict = dict1 as NSDictionary
                   show(myTeamsController, sender: self)
        }

     }
}
