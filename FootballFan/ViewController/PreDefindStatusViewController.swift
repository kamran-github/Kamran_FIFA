//
//  PreDefindStatusViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 15/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class PreDefindStatusViewController:UIViewController,UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource{
    let sections = [" Select Your New Status"]
    
     let items = ["Available", "Busy", "At School","At the movies","At work","Battery about to die","At the gym","Sleeping","Urgent call only"]
    @IBOutlet weak var UserStaus: UITextField?
     @IBOutlet weak var storyTableView: UITableView?
     @IBOutlet weak var statuscount: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
        let userStatus: String? = UserDefaults.standard.string(forKey: "userStatus")
        
        if((userStatus) != nil)
        {
            UserStaus?.text = userStatus
        }else{
            UserStaus?.text = "Hello! I am a Football Fan"
        }
        statuscount?.text=String(describing: UserStaus?.text?.count ?? 0)+"/"+String(describing: UserStaus?.maxLength ?? 0)
    }
    @IBAction func userstatustxtchange(){
        
        if UserStaus?.text != UserDefaults.standard.string(forKey: "userStatus")
        {
            // appDelegate().StatusTemp = (UserStaus?.text)!
            appDelegate().isvCardUpdated = true
             statuscount?.text=String(describing: UserStaus?.text?.count ?? 0)+"/"+String(describing: UserStaus?.maxLength ?? 0)
        }
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.sections.count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if(section == 0)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
           // headerView.tintColor=UIColor(hex:"FFFFFF")
        }
        else if(section == 1)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.sections[section]
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyTeamsCell = storyTableView!.dequeueReusableCell(withIdentifier: "cell") as! MyTeamsCell
        cell.teamName?.text = self.items[indexPath.row]
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //self.items[indexPath.section][indexPath.row
        UserStaus?.text=items[indexPath.row]
        /*if UserStaus?.text != UserDefaults.standard.string(forKey: "userStatus")
        {
            appDelegate().StatusTemp = (UserStaus?.text)!
            appDelegate().isvCardUpdated = true
            
        }*/
        
       // self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTeam () {
        UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func DoneStatus () {
        UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
        if UserStaus?.text != UserDefaults.standard.string(forKey: "userStatus")
        {
            if(UserStaus?.text?.condenseWhitespace().isEmpty)!
            {
                appDelegate().StatusTemp = "Hello! I am a Football Fan"
                appDelegate().isvCardUpdated = true
                let notificationName2 = Notification.Name("modifyStatus")
                               NotificationCenter.default.post(name: notificationName2, object: nil)
            } else
            {
                appDelegate().StatusTemp = (UserStaus?.text)!
                appDelegate().isvCardUpdated = true
                let notificationName2 = Notification.Name("modifyStatus")
                               NotificationCenter.default.post(name: notificationName2, object: nil)
            }
            
        }
       
        self.dismiss(animated: true, completion: nil)
        
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            PreDefindStatusViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return PreDefindStatusViewController.realDelegate!;
    }
    
}
