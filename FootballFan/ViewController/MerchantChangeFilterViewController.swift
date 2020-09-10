//
//  MerchantChangeFilterViewController.swift
//  FootballFan
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class MerchantChangeFilterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var FilterTableview: UITableView!
    let cellReuseIdentifier = "NewGroupCell"
       var arrsubfilter: [AnyObject] = []
    var filterType: String = ""
      var filterindex: Int = 0
     var checkStatus: Bool = false
 //var maintitel: String = "Sub Categories"
     var selectedindex: Int = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.FilterTableview.dataSource  = self
        self.FilterTableview.delegate = self
        
        self.navigationItem.title = filterType//"Product"
        let dic = arrsubfilter[0] as! NSDictionary
       
        let checked = dic.value(forKey: "checked") as! Bool
        if(checked){
      AllChecked()
        }
        else{
            var countchecked:Int = 0
            
            for i in 0..<arrsubfilter.count {
                
                let dic = arrsubfilter[i] as! NSDictionary
                let checkdays = dic.value(forKey: "name") as! String
                if(checkdays == "All"){
                    let checked = dic.value(forKey: "checked") as! Bool
                    if(checked){
                        
                        break
                    }
                    
                }
                else{
                    let checked = dic.value(forKey: "checked") as! Bool
                    if(checked){
                        countchecked = countchecked + 1
                    }
                }
            }
            selectedindex = countchecked
            let button1 = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(MerchantChangeFilterViewController.FiltterShow(sender:)))
            self.navigationItem.rightBarButtonItem = button1
        }
        
    }
    @objc func FiltterShow(sender:UIButton)  {
        
        if (!checkStatus) {
            AllChecked()
        }
        else{
            AllUnChecked()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var countchecked:Int = 0
        
        for i in 0..<arrsubfilter.count {
            
            let dic = arrsubfilter[i] as! NSDictionary
            let checkdays = dic.value(forKey: "name") as! String
            if(checkdays == "All"){
                let checked = dic.value(forKey: "checked") as! Bool
                if(checked){
                    
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
            var dict: [String : AnyObject] = arrsubfilter[0] as! [String : AnyObject]
            dict["checked"] = 1 as AnyObject
            arrsubfilter[0] = dict as AnyObject
          
            var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
            dict1["data"] = arrsubfilter as AnyObject
            appDelegate().arrfilter[filterindex] = dict1 as AnyObject
            
        }
       appDelegate().merchantfilterupdate()
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MerchantChangeFilterViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MerchantChangeFilterViewController.realDelegate!;
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrsubfilter.count - 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewGroupCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! NewGroupCell
        //print(phoneFilteredContacts)
        
        //let arry: NSArray? = appDelegate().allAppContacts[indexPath.row] as? NSArray
        let dic = arrsubfilter[indexPath.row + 1] as! NSDictionary
        cell.contactName?.text = dic.value(forKey: "name") as? String
        let checked = dic.value(forKey: "checked") as! Bool
        if(checked){
             cell.pickContact?.image = UIImage(named: "check")
        }
        else{
             cell.pickContact?.image = UIImage(named: "uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewGroupCell
        
        //tmpSelected.add(indexPath)
        //cell.isForward = true
        //cell.pickContact?.backgroundColor = cell.contentView.tintColor
        //print(tmpSelected)
        //let colour = cell.contentView.tintColor
        
        //let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
        //dict?.setValue("blue", forKey: "colour")
       
       
        let dic = arrsubfilter[indexPath.row + 1] as! NSDictionary
        cell.contactName?.text = dic.value(forKey: "name") as? String
        let checked = dic.value(forKey: "checked") as! Bool
        if(checked){
            var dict: [String : AnyObject] = arrsubfilter[indexPath.row + 1] as! [String : AnyObject]
            dict["checked"] = 0 as AnyObject
            arrsubfilter[indexPath.row + 1] = dict as AnyObject
            cell.pickContact?.image = UIImage(named: "uncheck")
            var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
            dict1["data"] = arrsubfilter as AnyObject
            appDelegate().arrfilter[filterindex] = dict1 as AnyObject
            if(indexPath.row == -1){
                //AllUnChecked()
            }
            else{
                selectedindex = selectedindex - 1
                print(selectedindex)
                if(selectedindex != arrsubfilter.count-1){
                    var dict: [String : AnyObject] = arrsubfilter[0] as! [String : AnyObject]
                    dict["checked"] = 0 as AnyObject
                    arrsubfilter[0] = dict as AnyObject
                    cell.pickContact?.image = UIImage(named: "uncheck")
                    var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
                    dict1["data"] = arrsubfilter as AnyObject
                    appDelegate().arrfilter[filterindex] = dict1 as AnyObject
                    FilterTableview.reloadData()
                }
            }
        }
        else{
            var dict: [String : AnyObject] = arrsubfilter[indexPath.row + 1] as! [String : AnyObject]
            dict["checked"] = 1 as AnyObject
            arrsubfilter[indexPath.row + 1] = dict as AnyObject
            cell.pickContact?.image = UIImage(named: "check")
            var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
            dict1["data"] = arrsubfilter as AnyObject
            appDelegate().arrfilter[filterindex] = dict1 as AnyObject
            if(indexPath.row == -1){
                //AllChecked()
            }
            else{
                selectedindex = selectedindex + 1
               print(selectedindex)
                if(selectedindex == arrsubfilter.count-1){
                    var dict: [String : AnyObject] = arrsubfilter[0] as! [String : AnyObject]
                    dict["checked"] = 1 as AnyObject
                    arrsubfilter[0] = dict as AnyObject
                    cell.pickContact?.image = UIImage(named: "uncheck")
                    var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
                    dict1["data"] = arrsubfilter as AnyObject
                    appDelegate().arrfilter[filterindex] = dict1 as AnyObject
FilterTableview.reloadData()
                }
            }
        }
        appDelegate().merchantfilterupdate()
    }
    func AllChecked()  {
        for i in 0..<arrsubfilter.count {
            
            var dict: [String : AnyObject] = arrsubfilter[i] as! [String : AnyObject]
            dict["checked"] = 1 as AnyObject
            arrsubfilter[i] = dict as AnyObject
            
            
        }
        var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
        dict1["data"] = arrsubfilter as AnyObject
        appDelegate().arrfilter[filterindex] = dict1 as AnyObject
         checkStatus = true
        selectedindex = arrsubfilter.count-1
        self.navigationItem.rightBarButtonItem = nil
        let button1 = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(MerchantChangeFilterViewController.FiltterShow(sender:)))
        self.navigationItem.rightBarButtonItem = button1
         FilterTableview.reloadData()
    }
    func AllUnChecked()  {
        for i in 0..<arrsubfilter.count {
            
            var dict: [String : AnyObject] = arrsubfilter[i] as! [String : AnyObject]
            dict["checked"] = 0 as AnyObject
            arrsubfilter[i] = dict as AnyObject
            
            
        }
        selectedindex = 0
        checkStatus = false
        var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
        dict1["data"] = arrsubfilter as AnyObject
        appDelegate().arrfilter[filterindex] = dict1 as AnyObject
        self.navigationItem.rightBarButtonItem = nil
        let button1 = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(MerchantChangeFilterViewController.FiltterShow(sender:)))
        self.navigationItem.rightBarButtonItem = button1
        FilterTableview.reloadData()
    }
}
