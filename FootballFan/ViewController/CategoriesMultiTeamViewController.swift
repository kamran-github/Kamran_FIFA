//
//  CategoriesMultiTeamViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 31/05/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class CategoriesMultiTeamViewControlle:UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var storyTableView: UITableView?
    var data = [TeamCategories_detail]()
    var teamType = ""
     var variableString = ""
    var globel_catid :Int64 = 0
    var isShowForBanterRoom = false
    
    var dataFilteredTeams = NSMutableArray()
    var arrDataTeamsAll = NSMutableArray()
    @IBOutlet weak var ibBanterSound: UISwitch!
    
    
     @IBOutlet weak var TeamCount: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        let notificationName = Notification.Name("RefreshcatView")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CategoriesMultiTeamViewControlle.refreshNotification), name: notificationName, object: nil)
        
        //UserStaus?.text=UserDefaults.standard.string(forKey: "userStatus")
        let teamselected = appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
        
        for cat in teamselected
        {
            
            let team_Id =  (cat as! NSDictionary).value(forKey: "team_Id") as! String
            if( variableString == ""){
                variableString += "\(String(describing: team_Id))"
            }
            else{
                variableString += ",\(String(describing: team_Id))"
            }
        }
        
        
        
        //let result2 = appDelegate().db.execute(sql:"DELETE FROM teamcategories_detail")
        //if(result2 > 0){}
        data = TeamCategories_detail.rows(order:"c_Id ASC") as! [TeamCategories_detail]
        if(data.count != 0){
            storyTableView?.reloadData()
        }
        else{
           // TransperentLoadingIndicatorView.show(self.view, loadingText: "Please wait while loading Teams")
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: String]()
            reqParams["cmd"] = "teamsync"
            reqParams["key"] = "kXfqS9wUug6gVKDB"  
            request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data1, response, error) in
                if let redata = data1 {
                    if String(data: redata, encoding: String.Encoding.utf8) != nil {
                        //print(stringData) //JSONSerialization
                        
                        
                        
                        //print(time)
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with:redata , options: []) as? NSDictionary
                            
                            let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                            
                            if(isSuccess)
                            {
                                let response = jsonData?.value(forKey: "responseData") as! NSDictionary
                                
                                let catarr = response.value(forKey: "teamcategories") as! NSArray
                                for cat in catarr
                                {
                                    let c_id =  (cat as! NSDictionary).value(forKey: "id") as! Int64
                                    let iscat = TeamCategories_detail.rows(filter:"c_Id = \(c_id)") as! [TeamCategories_detail]
                                    if(iscat.count == 0){
                                        let teamCategories_detail = TeamCategories_detail()
                                        teamCategories_detail.c_Id = (cat as! NSDictionary).value(forKey: "id") as! Int64
                                        teamCategories_detail.c_name = (cat as! NSDictionary).value(forKey: "name") as! String
                                        teamCategories_detail.c_logo = (cat as! NSDictionary).value(forKey: "logo") as! String
                                        teamCategories_detail.save()
                                    }
                                    else{
                                        
                                    }
                                    let teamImageName = "caty" + c_id.description
                                    //print(teamImageName)
                                    self.appDelegate().loadImageFromUrl(url: ((cat as! NSDictionary).value(forKey: "logo") as! String), fileName: teamImageName as String)
                                }
                                
                                let teamarr = response.value(forKey: "teams") as! NSArray
                                for team in teamarr
                                {
                                    let t_id =  (team as! NSDictionary).value(forKey: "id") as! Int64
                                    let isteam = Teams_details.rows(filter:"team_Id = \(t_id)") as! [Teams_details]
                                    if(isteam.count == 0){
                                        let teams_details = Teams_details()
                                        teams_details.team_Id = (team as! NSDictionary).value(forKey: "id") as! Int64
                                        teams_details.team_name = (team as! NSDictionary).value(forKey: "name") as! String
                                        teams_details.team_logo = (team as! NSDictionary).value(forKey: "logo") as! String
                                        let c_id =  (team as! NSDictionary).value(forKey: "catid") as! Int64
                                        teams_details.team_categoriy = c_id
                                        teams_details.isselected = true
                                        teams_details.save()
                                    }
                                    else{
                                        
                                    }
                                    
                                    
                                    let teamImageName = "Team" + t_id.description
                                    //print(teamImageName)
                                    self.appDelegate().loadImageFromUrl(url: ((team as! NSDictionary).value(forKey: "logo") as! String), fileName: teamImageName as String)
                                    
                                }
                                self.data = [TeamCategories_detail]()
                                self.data = TeamCategories_detail.rows(order:"c_Id ASC") as! [TeamCategories_detail]
                                if(self.data.count != 0){
                                    //data = data1
                                    self.storyTableView?.reloadData()
                                    TransperentLoadingIndicatorView.hide()
                                    
                                    
                                }
                                let teamselected = self.appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
                                self.TeamCount?.text = "Selected Team(s): \(teamselected.count)"
                                for cat in self.appDelegate().arrDataTeams
                                {
                                    //let c_id =  (cat as! NSDictionary).value(forKey: "id") as! Int64
                                    self.arrDataTeamsAll.add(cat)
                                }
                                
                                let totalteams = self.appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
                                
                                if (teamselected.count == totalteams.count) {
                                    self.ibBanterSound.setOn(true, animated: false)
                                    
                                } else {
                                    self.ibBanterSound.setOn(false, animated: false)
                                }
                            }else
                            {
                                //Show Error
                            }
                        } catch let error as NSError {
                            print(error)
                            //Show Error
                        }
                        
                    }
                }
                else
                {
                    //Show Error
                }
            })
            task.resume()
        }
        let notificationName1 = Notification.Name("DissminNotify")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.DissminNotify), name: notificationName1, object: nil)
        
    }
    
    @IBAction func soundIsChanged(mySwitch: UISwitch) {
       
        var message = ""
        if(mySwitch.isOn)
        {
            message = "Are you sure you want to Select All teams?"
        } else
        {
            message = "Are you sure you want to Deselect All teams?"
        }
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {_ in
            
        if mySwitch.isOn {
            //self.isAllUnSelectedTeams = false
            let _ = self.appDelegate().db.query(sql:"UPDATE Teams_details SET isselected = 1")
            mySwitch.setOn(true, animated: false)
            for i in 0...self.arrDataTeamsAll.count-1 {
                //print(i)
                var dict: [String : AnyObject] = self.arrDataTeamsAll[i] as! [String : AnyObject]
                
                dict["isselected"] = true as AnyObject
                
                self.arrDataTeamsAll.replaceObject(at: i, with: dict)
            }
            /*for (Int i = 0; i <= <arrDataTeamsAll.count - 1; i++) {
             var dict: [String : AnyObject] = dataFilteredTeams[i] as! [String : AnyObject]
             
             dict["isselected"] = false as AnyObject
             
             dataFilteredTeams.replaceObject(at: indexPath.row, with: dict)
             }*/
            
            
        } else {
            let _ = self.appDelegate().db.query(sql:"UPDATE teams_details SET isselected = 0")
            mySwitch.setOn(false, animated: false)
            for i in 0...self.arrDataTeamsAll.count-1 {
                //print(i)
                var dict: [String : AnyObject] = self.arrDataTeamsAll[i] as! [String : AnyObject]
                
                dict["isselected"] = false as AnyObject
                
                self.arrDataTeamsAll.replaceObject(at: i, with: dict)
            }
            
        }
        let teamselected = self.appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
        self.TeamCount?.text = "Selected Team(s): \(teamselected.count)"
        self.storyTableView?.reloadData()
            
        });
        let action1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default,handler: {_ in
           if mySwitch.isOn {
            mySwitch.setOn(false, animated: false)
            } else
           {
            mySwitch.setOn(true, animated: false)
            }
            self.storyTableView?.reloadData()
            let teamselected = self.appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
            self.TeamCount?.text = "Selected Team(s): \(teamselected.count)"
        });
        alert.addAction(action)
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        appDelegate().isOnMultiCategoriesView = false
    }
    @objc func refreshNotification()
    {
        let teamselected = appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
        TeamCount?.text = "Selected Team(s): \(teamselected.count)"
        for cat in appDelegate().arrDataTeams
        {
            //let c_id =  (cat as! NSDictionary).value(forKey: "id") as! Int64
            arrDataTeamsAll.add(cat)
        }
        
        let totalteams = appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
        
        if (teamselected.count == totalteams.count) {
            ibBanterSound.setOn(true, animated: false)
            
        } else {
            ibBanterSound.setOn(false, animated: false)
        }
        
        storyTableView?.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate().isOnMultiCategoriesView = true
        let teamselected = appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1") as NSArray
        TeamCount?.text = "Selected Team(s): \(teamselected.count)"
        for cat in appDelegate().arrDataTeams
        {
            //let c_id =  (cat as! NSDictionary).value(forKey: "id") as! Int64
            arrDataTeamsAll.add(cat)
        }
        
        let totalteams = appDelegate().db.query(sql: "SELECT * FROM Teams_details") as NSArray
        
        if (teamselected.count == totalteams.count) {
            ibBanterSound.setOn(true, animated: false)
            
        } else {
            ibBanterSound.setOn(false, animated: false)
        }
        
        storyTableView?.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    @objc func DissminNotify()
    {
        self.dismiss(animated: false, completion: nil)
    }
    /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     if(section == 0)
     {
     headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
     // headerView.tintColor=UIColor(hex:"FFFFFF")
     }
     else if(section == 1)
     {
     headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
     }
     else if(section == 2)
     {
     headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
     }
     let label = UILabel()
     label.translatesAutoresizingMaskIntoConstraints = false
     let chatType = self.sectionNames[section] as! String
     if(chatType == "banter")
     {
     label.text = " Blocked Banter Room Fans"// #FD7A5C
     // headerView.tintColor=UIColor(hex:"FFFFFF")
     }
     else if(chatType == "chat")
     {
     label.text = " Blocked Fans"// #7FD9FB
     }
     
     label.textColor=UIColor(hex: "FFFFFF")
     headerView.addSubview(label)
     if #available(iOS 9.0, *) {
     label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
     label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
     label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
     label.heightAnchor.constraint(equalToConstant: 25).isActive = true
     
     } else {
     // Fallback on earlier versions
     }
     
     
     return headerView
     }*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // let arrrow = resultArry[section] as! NSArray
        
        return data.count
        
    }
    /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 30.0
     }*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryCell = storyTableView!.dequeueReusableCell(withIdentifier: "cat") as! CategoryCell
        let dic = data[indexPath.row]
        
        cell.contactName?.text = dic.c_name
        
        // cell.contactImage?.image = UIImage(named: "user")
        
        let teamId: Int64 = dic.c_Id
        let teamImageName = "caty" + (teamId.description)
        //print(teamImageName)
        
        let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
        if((teamImage) != nil)
        {
            cell.contactImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
            
            if(cell.contactImage?.image == nil)
            {
                appDelegate().loadImageFromUrl(url: dic.c_logo,view: (cell.contactImage)!, fileName: teamImageName as String)
            }
        }
        else
        {
            appDelegate().loadImageFromUrl(url: dic.c_logo,view: (cell.contactImage)!, fileName: teamImageName as String)
        }
        
        let teamselected = appDelegate().db.query(sql: "SELECT * FROM Teams_details where isselected = 1 AND team_categoriy = \(teamId)") as NSArray
        if(teamselected.count != 0)
        {
            cell.selectedTeamCount?.isHidden = false
                if(teamselected.count>99 && teamselected.count<999){
                    cell.selectedTeamCountConstraint.constant = CGFloat(50.0)
                }
                else if(teamselected.count>999){
                    cell.selectedTeamCountConstraint.constant = CGFloat(70.0)
                }
                else{
                    cell.selectedTeamCountConstraint.constant = CGFloat(30.0)
                }
                cell.selectedTeamCount?.isHidden = false
                cell.selectedTeamCount?.text = String(teamselected.count)
                //cell.badgeCount?.sizeToFit()
                //cell.badgeCount?.frame.size = CGSize(width: (cell.badgeCount?.intrinsicContentSize.width)!, height: (cell.badgeCount?.frame.height)!)
                cell.selectedTeamCount?.backgroundColor = UIColor.init(hex: "FFD401")//self.view.tintColor
                cell.selectedTeamCount?.layer.masksToBounds = true;
                cell.selectedTeamCount?.layer.borderWidth = 1.0
                cell.selectedTeamCount?.layer.borderColor = UIColor.init(hex: "FFD401").cgColor
                cell.selectedTeamCount?.layer.cornerRadius = 10.0
                
            
        //cell.selectedTeamCount?.text = "\(teamselected.count)"
        } else {
        cell.selectedTeamCount?.text = ""
            cell.selectedTeamCount?.isHidden = true
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = data[indexPath.row]
        
        
        let id = dic.c_Id as Int64
        globel_catid = id
        appDelegate().arrDataTeams =  appDelegate().db.query(sql: "SELECT * FROM Teams_details where team_categoriy = \(id)") as NSArray
        // let array =  Teams_details.rows(order:"team_categoriy ASC") as! [Teams_details]//Teams_details.rows(filter: "team_categoriy = \(id)")  as NSArray
        selectAponentTeam(name: dic.c_name)
        
    }
    func selectAponentTeam(name : String) {
        //isShowForBanterRoom = true
        //teamType = "aponent"
        // get a reference to the view controller for the popoverCategory
        if(isShowForBanterRoom){
            if(teamType == "multi"){
                let popController: AddMultipleTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeamM") as! AddMultipleTeamViewController
                
                // set the presentation style
                popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                //popController.modalPresentationStyle = .popover
                popController.modalTransitionStyle = .crossDissolve
                
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
                popController.popoverPresentationController?.sourceView = self.view // button
                //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
                popController.isShowForBanterRoom = true
                popController.teamType = globel_catid
                 popController.categoryname = name
                // present the popover
                self.present(popController, animated: true, completion: nil)
            }
            else{
                let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
                
                // set the presentation style
                popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                //popController.modalPresentationStyle = .popover
                popController.modalTransitionStyle = .crossDissolve
                
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
                popController.popoverPresentationController?.sourceView = self.view // button
                //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
                popController.isShowForBanterRoom = true
                popController.teamType = teamType
                
                // present the popover
                self.present(popController, animated: true, completion: nil)
            }
            
        }
        else{
            let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }
        
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            CategoriesMultiTeamViewControlle.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return CategoriesMultiTeamViewControlle.realDelegate!;
    }
    
    @IBAction func cancelTeam () {
        let _ = appDelegate().db.query(sql:"UPDATE Teams_details SET isselected = 1 WHERE team_Id IN (\(variableString))")
        
        let _ = appDelegate().db.query(sql:"UPDATE teams_details SET isselected = 0 WHERE team_Id NOT IN (\(variableString))")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func DoneTeam () {
        let notificationName = Notification.Name("_FechedFanUpdate")
        NotificationCenter.default.post(name: notificationName, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
