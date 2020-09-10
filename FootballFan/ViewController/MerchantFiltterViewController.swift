//
//  MerchantFiltterViewController.swift
//  FootballFan
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class MerchantFiltterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var FilterTableview: UITableView!
    let cellReuseIdentifier = "settings"
    var refresh:Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.FilterTableview.dataSource  = self
        self.FilterTableview.delegate = self
       
        self.navigationItem.title = "Filters"
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let button1 = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(MerchantFiltterViewController.FiltterShow(sender:)))
        self.navigationItem.rightBarButtonItem = button1
        if(refresh){
            FilterTableview.reloadData()
        }
}
    @objc func FiltterShow(sender:UIButton)  {
        
        for i in 0..<appDelegate().arrfilter.count {
            
            let dic: NSDictionary = self.appDelegate().arrfilter[i] as! NSDictionary
            let FiltersType = dic.value(forKey: "FiltersType") as! String
            if (FiltersType == "range") {
                
                
                var dict1: [String : AnyObject] = appDelegate().arrfilter[i] as! [String : AnyObject]
                dict1["MinRangeSel"] = dic.value(forKey: "MinRange") as AnyObject
                dict1["MaxRangeSel"] = dic.value(forKey: "MaxRange") as AnyObject
                appDelegate().arrfilter[i] = dict1 as AnyObject            }
            else{
                var filter = dic.value(forKey: "data") as! [AnyObject]
                if(filter.count>0){
                    for j in 0..<filter.count {
                        
                        var dict: [String : AnyObject] = filter[j] as! [String : AnyObject]
                        dict["checked"] = 1 as AnyObject
                        filter[j] = dict as AnyObject
                    }
                    var dict: [String : AnyObject] = appDelegate().arrfilter[i] as! [String : AnyObject]
                    dict["data"] = filter as AnyObject
                    appDelegate().arrfilter[i] = dict as AnyObject
                }
            }
           
            
        }
        appDelegate().merchantfilterupdate()
        FilterTableview.reloadData()
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MerchantFiltterViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MerchantFiltterViewController.realDelegate!;
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return appDelegate().arrfilter.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingsCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SettingsCell
        //print(phoneFilteredContacts)
        
        //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
        let dic = appDelegate().arrfilter[indexPath.row] as! NSDictionary
        cell.optionName?.text = dic.value(forKey: "DisplayName") as? String
        let FiltersType = dic.value(forKey: "FiltersType") as! String
        if (FiltersType == "range") {
            
         
             cell.count?.text = "£\(dic.value(forKey: "MinRangeSel") as! Int) - £\( dic.value(forKey: "MaxRangeSel") as! Int)"
        }
        else{
           let arrsub = dic.value(forKey: "data") as! [AnyObject]
            var countchecked:Int = 0
            
            for i in 0..<arrsub.count {
                
                let dic = arrsub[i] as! NSDictionary
                 let checkdays = dic.value(forKey: "name") as! String
                if(checkdays == "All"){
                    let checked = dic.value(forKey: "checked") as! Bool
                    if(checked){
                        cell.count?.text = "All"
                          break
                    }
                  
                }
                else{
                         let checked = dic.value(forKey: "checked") as! Bool
                        if(checked){
                            countchecked = countchecked + 1
                        }
                    }
               // }
                
               
            }
            if(countchecked == 0){
                cell.count?.text = "All"
            }
            else{
                cell.count?.text = String(countchecked)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath) as! SettingsCell
       
        /*if(indexPath.row == 2) //My Teams
         {
         self.showRedeem()
         }*/
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
        refresh = true
        let dic = appDelegate().arrfilter[indexPath.row] as! NSDictionary
        let FiltersType = dic.value(forKey: "FiltersType") as! String
        if (FiltersType == "range") {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settingsController : MerchantRangeFilterViewController = storyBoard.instantiateViewController(withIdentifier: "MerchantRangeFilter") as! MerchantRangeFilterViewController
           settingsController.filterType = dic.value(forKey: "DisplayName") as! String
            settingsController.dic = dic//arrsubfilter = dic.value(forKey: "data") as! [AnyObject]
           settingsController.filterindex = indexPath.row
            show(settingsController, sender: self)
        }
        else{
            let data = dic.value(forKey: "data") as! [AnyObject]
            if(data.count>0){
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let settingsController : MerchantChangeFilterViewController = storyBoard.instantiateViewController(withIdentifier: "MerchantChangeFilter") as! MerchantChangeFilterViewController
                settingsController.filterType = dic.value(forKey: "DisplayName") as! String
                settingsController.arrsubfilter = dic.value(forKey: "data") as! [AnyObject]
                settingsController.filterindex = indexPath.row
                show(settingsController, sender: self)
            }
           
        }
       
    }
    @IBAction func done(){
        self.navigationController?.popViewController(animated: true)
    }
}
