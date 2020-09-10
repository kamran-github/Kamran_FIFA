//
//  AddMultipleTeamViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 24/05/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class AddMultipleTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var collectionViewTeams: UICollectionView?
    @IBOutlet weak var colSearchBar: UISearchBar?
    let reuseIdentifier = "collectioncell"
    //var dataTeams: NSArray?
    var dataFilteredTeams = NSMutableArray()
    var arrDataTeamsAll = NSMutableArray()
    var isShowForBanterRoom = false
     //var isAllTeams = true
    var teamType:Int64 = 0
     @IBOutlet weak var ibBanterSound: UISwitch!
    var searchActive : Bool = false
    var searchStarting : Bool = false
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var parenttopConstraint: NSLayoutConstraint!
    @IBOutlet weak var copRightlbl: UILabel?
    var strings:[String] = []
    @IBOutlet weak var NoteamLabel: UILabel?
    var categoryname : String = ""
     @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionViewTeams?.delegate = self
        collectionViewTeams?.dataSource = self
        colSearchBar?.delegate = self
        navItem.title = categoryname
        // colSearchBar?.layer.masksToBounds = true;
        //storySearchBar?.layer.borderWidth = 1.0
        //storySearchBar?.layer.borderColor = self.contentView.tintColor.cgColor
        //UIColor(red:5.0, green: 122.0, blue: 255.0, alpha: 1.0) as! CGColor
        //colSearchBar?.layer.cornerRadius = 10.0
        //collectionViewTeams?.allowsMultipleSelection = true
      /*  let copyrightvalue: String = UserDefaults.standard.string(forKey: "teamcopyright") as! String
        if(copyrightvalue == ""){
            self.parenttopConstraint.constant = 60.0
            copRightlbl?.isHidden = true
        }
        else{
            self.parenttopConstraint.constant = 80.0
            let  screenHeight = self.view.frame.height
            copRightlbl?.text = copyrightvalue
            if(screenHeight <= 568)
            {
                copRightlbl?.font = UIFont.systemFont(ofSize: 11)
            }
            else{
                copRightlbl?.font = UIFont.systemFont(ofSize: 13)
            }
            copRightlbl?.isHidden = false
        }*/
        /*let dict: NSString? = "{\"success\":true, \"data\":[{\"id\":1,\"name\": \"Arsenal\",\"logo\":\"https://cinefuntv.com/chap/image/Arsenal_FC.svg.png\"}, {\"id\":2,\"name\": \"Burnley\",\"logo\":\"https://cinefuntv.com/chap/image/Burnley_FC_badge.png\"}, {\"id\":3,\"name\": \"Chelsea\",\"logo\":\"https://cinefuntv.com/chap/image/chelsea.png\"}, {\"id\":4,\"name\": \"C Palace\",\"logo\":\"https://cinefuntv.com/chap/image/Crystal_Palace_Eagle_Crest_2.gif\"}, {\"id\":5,\"name\": \"Everton\",\"logo\":\"https://cinefuntv.com/chap/image/Crest.jpg\"}, {\"id\":6,\"name\": \"Hull City\",\"logo\":\"https://cinefuntv.com/chap/image/Hull_City_logo-vector.png\"}] }";
         
         
         
         if let data = dict?.data(using: String.Encoding.utf8.rawValue) {
         
         do {
         let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
         
         let isSuccess = json?.value(forKey: "success") as? Bool
         
         if(isSuccess)!
         {
         dataTeams = (json?.value(forKey: "data") as? NSArray)!
         print(dataTeams as Any)
         }
         
         
         } catch let error as NSError {
         print(error)
         }
         }*/
        
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //New code to reset new banter room page as it is
        /*let pTeamId: Int? = UserDefaults.standard.integer(forKey: "primaryTeamId")
         let pTeamName: String? = UserDefaults.standard.string(forKey: "primaryTeamName") ?? " "
         
         if((pTeamId) != 0)
         {
         appDelegate().myTeamId = pTeamId!
         appDelegate().myTeamName = pTeamName!
         }
         
         appDelegate().aponentTeamId = 0
         appDelegate().aponentTeamName = ""
         */
        //End
       
        for cat in appDelegate().arrDataTeams
        {
            //let c_id =  (cat as! NSDictionary).value(forKey: "id") as! Int64
            arrDataTeamsAll.add(cat)
        }
        
         let teamselected =  appDelegate().db.query(sql: "SELECT * FROM Teams_details where team_categoriy = \(teamType) AND isselected = 1") as NSArray
       
        if (teamselected.count == appDelegate().arrDataTeams.count) {
           // isAllTeams = true
            ibBanterSound.setOn(true, animated: false)
           
        } else {
            //isAllTeams = false
            ibBanterSound.setOn(false, animated: false)
        }
        filterTeams()
    }
    @IBAction func soundIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
             //isAllTeams = true
           
            for i in 0...arrDataTeamsAll.count-1 {
                //print(i)
                var dict: [String : AnyObject] = arrDataTeamsAll[i] as! [String : AnyObject]
                
                dict["isselected"] = true as AnyObject
                
                arrDataTeamsAll.replaceObject(at: i, with: dict)
            }
            /*for (Int i = 0; i <= <arrDataTeamsAll.count - 1; i++) {
                var dict: [String : AnyObject] = dataFilteredTeams[i] as! [String : AnyObject]
                
                dict["isselected"] = false as AnyObject
                
                dataFilteredTeams.replaceObject(at: indexPath.row, with: dict)
            }*/
           filterTeams()
            
            collectionViewTeams?.reloadData()
            
            
        } else {
          // isAllTeams = false
            for i in 0...arrDataTeamsAll.count-1 {
                //print(i)
                var dict: [String : AnyObject] = arrDataTeamsAll[i] as! [String : AnyObject]
                
                dict["isselected"] = false as AnyObject
                
                arrDataTeamsAll.replaceObject(at: i, with: dict)
            }
            filterTeams()
            collectionViewTeams?.reloadData()
        }
       
    }
    func filterTeams()
    {
       
        
          
       dataFilteredTeams = arrDataTeamsAll
      //  arrDataTeamsAll = sectionArray as! NSMutableArray
            
           
            /*}
             else
             {
             dataFilteredTeams = appDelegate().arrDataTeams
             }*/
            
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        colSearchBar?.showsCancelButton = true
        searchStarting = true
        //collectionViewTeams?.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        colSearchBar?.text = ""
        //dataFilteredTeams = appDelegate().allPhoneContacts.mutableCopy() as! NSMutableArray
       filterTeams()
        colSearchBar?.resignFirstResponder()
        colSearchBar?.showsCancelButton = false
        searchActive = false
        searchStarting = false
        collectionViewTeams?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        colSearchBar?.resignFirstResponder()
        if let cancelButton = colSearchBar?.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        searchActive = true
        searchStarting = true
         NoteamLabel?.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count>0)
        {
           /* let result: NSMutableArray = (self.arrDataTeamsAll.filter({ (text) -> Bool in
                let tmp: NSDictionary = text as! NSDictionary
                let val = tmp.value(forKey: "team_name")
                let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }) as NSArray?)! as! NSMutableArray
            
            //if((result?.count) != nil)
            if(result.count > 0)
            {
                dataFilteredTeams = result  //NSArray(array: result!)//result as! NSMutableArray
            }
            else
            {
                dataFilteredTeams = NSMutableArray()
                filterTeams()
                
            }*/
            let predicate = NSPredicate(format:"team_name CONTAINS[C] %@", searchText)
            let filteredArray = (arrDataTeamsAll as NSMutableArray).filtered(using: predicate)
           // print(filteredArray)
            if(filteredArray.count > 0){
                searchActive = false;
                
                dataFilteredTeams = NSMutableArray()
                for cat in filteredArray
                {
                    //let c_id =  (cat as! NSDictionary).value(forKey: "id") as! Int64
                    dataFilteredTeams.add(cat)
                }
                
                //dataFilteredTeams = filteredArray as! NSMutableArray
            } else {
                searchActive = true;
            }
           collectionViewTeams?.reloadData()
        }
        else{
            filterTeams()
            NoteamLabel?.isHidden = true
        }
        
        
        //searchActive = true
        //storyTableView?.reloadData()
        collectionViewTeams?.reloadData()
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            AddMultipleTeamViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return AddMultipleTeamViewController.realDelegate!;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataFilteredTeams.count)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TeamCollectionViewCell
        
        /*let index = dataTeams?.allKeys.startIndex.advanced(by: indexPath.row)
         let key1 = dataTeams?.allKeys[index!]
         let dict2: NSDictionary? = dataTeams?.value(forKey: key1 as! String) as? NSDictionary
         cell.colName?.text = dict2?.value(forKey: "name") as? String*/
        
        let dict: NSDictionary? = dataFilteredTeams[indexPath.row] as? NSDictionary
        cell.colName?.text = dict?.value(forKey: "team_name") as? String
        //cell.colImage?.image = appDelegate().loadImageFromUrl(dict?.value(forKey: "logo") as? String)
        //cell.colImage?.image = UIImage(named:(dict2?.value(forKey: "flag") as? String)!) //
        
        //Code to tick mark selected teams
        let teamId: Int64 = Int64(dict?.value(forKey: "team_Id") as! String)!
        let teamImageName = "Team" + (teamId.description)
        //print(teamImageName)
        
        let teamImage: String? = UserDefaults.standard.string(forKey: teamImageName)
        if((teamImage) != nil)
        {
            cell.colImage?.image = appDelegate().loadProfileImage(filePath: teamImage!)
            
            if(cell.colImage?.image == nil)
            {
                appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "team_logo") as? String)!,view: (cell.colImage)!, fileName: teamImageName as String)
            }
        }
        else
        {
            appDelegate().loadImageFromUrl(url: (dict?.value(forKey: "team_logo") as? String)!,view: (cell.colImage)!, fileName: teamImageName as String)
        }
      
       
            let isselected: Bool = (dict?.value(forKey: "isselected") as? Bool)!
            if(isselected){
               
               
                cell.colTick?.image = UIImage(named:"check")
              
                
            }
                
            else
            {
                 cell.colTick?.image = UIImage(named: "uncheck")
                /*if(isAllTeams){
                    var dict: [String : AnyObject] = dataFilteredTeams[indexPath.row] as! [String : AnyObject]
                    cell.colTick?.image = UIImage(named: "green_tick")
                    dict["isselected"] = true as AnyObject
                    
                    dataFilteredTeams.replaceObject(at: indexPath.row, with: dict)
                }*/
                /*if(appDelegate().primaryTeamId == teamId)
                 {
                 cell.colTick?.image = UIImage(named:"green_tick")
                 cell.colImage?.alpha = 0.6
                 }
                 else if(appDelegate().optionalTeam1Id == teamId)
                 {
                 cell.colTick?.image = UIImage(named:"green_tick")
                 cell.colImage?.alpha = 0.6
                 }
                 else if(appDelegate().optionalTeam2Id == teamId)
                 {
                 cell.colTick?.image = UIImage(named:"green_tick")
                 cell.colImage?.alpha = 0.6
                 }
                 else if(appDelegate().optionalTeam3Id == teamId)
                 {
                 cell.colTick?.image = UIImage(named:"green_tick")
                 cell.colImage?.alpha = 0.6
                 }*/
            }
       // }
        
        
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
   /* func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TeamCollectionViewCell //collectionView.cellForRow(at: indexPath) as! TeamCollectionViewCell
         var dict: [String : AnyObject] = dataFilteredTeams[indexPath.row] as! [String : AnyObject]
        cell.colTick?.image = UIImage(named: "green_tick")
        dict["isselected"] = true as AnyObject
        arrDataTeamsAll.replaceObject(at: indexPath.row, with: dict)
    }*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        
       
        //cell.pickContact?.backgroundColor = cell.contentView.tintColor
        //print(tmpSelected)
        //let colour = cell.contentView.tintColor
        let cell = collectionView.cellForItem(at: indexPath) as! TeamCollectionViewCell //collectionView.cellForRow(at: indexPath) as! TeamCollectionViewCell
        
       
       // let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
        //dict?.setValue("blue", forKey: "colour")
       
        var dict: [String : AnyObject] = dataFilteredTeams[indexPath.row] as! [String : AnyObject]
        let selteam: NSDictionary = dataFilteredTeams[indexPath.row] as! NSDictionary
         let id = selteam.value(forKey: "team_Id") as! String
        let isselected: Bool = selteam.value(forKey: "isselected") as! Bool
        if(isselected){
             cell.colTick?.image = UIImage(named: "uncheck")
            for i in 0...arrDataTeamsAll.count-1 {
                //print(i)
                let atual: NSDictionary = arrDataTeamsAll[i] as! NSDictionary
                let Aid = atual.value(forKey: "team_Id") as! String
                if(id == Aid){
               
                
                dict["isselected"] = false as AnyObject
                
                arrDataTeamsAll.replaceObject(at: i, with: dict)
                    break
                }
            }
            //dict["isselected"] = false as AnyObject
            
            //arrDataTeamsAll.replaceObject(at: indexPath.row, with: dict)
        }
        else{
            cell.colTick?.image = UIImage(named: "check")
            for i in 0...arrDataTeamsAll.count-1 {
                //print(i)
                let atual: NSDictionary = arrDataTeamsAll[i] as! NSDictionary
                 let Aid = atual.value(forKey: "team_Id") as! String
                if(id == Aid){
                    
                    
                    dict["isselected"] = true as AnyObject
                    
                    arrDataTeamsAll.replaceObject(at: i, with: dict)
                    break
                }
               
            }
            //dict["isselected"] = true as AnyObject
            //arrDataTeamsAll.replaceObject(at: indexPath.row, with: dict)
        }
        //print(teamImageName)
        
        
        
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
    }
    @IBAction func cancelTeam () {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done () {
      //  let predicateFormat2 = NSString(format: "isselected = 1")
        //let predicate2:NSPredicate = NSPredicate(format:predicateFormat2 as String)
        
        //let sectionArray2: NSArray = dataFilteredTeams.filtered(using: predicate2) as! NSMutableArray
        var variableString = ""
       
        for cat in arrDataTeamsAll
        {
            let isselected =  (cat as! NSDictionary).value(forKey: "isselected") as! Bool
            if(isselected){
                let team_Id =  (cat as! NSDictionary).value(forKey: "team_Id") as! String
                if( variableString == ""){
                    variableString += "\(String(describing: team_Id))"
                }
                else{
                    variableString += ",\(String(describing: team_Id))"
                }
               
            }
            
        }
        //print(variableString)
        let _ = appDelegate().db.query(sql:"UPDATE Teams_details SET isselected = 1 WHERE team_categoriy = \(teamType) AND team_Id IN (\(variableString))")
        
        let _ = appDelegate().db.query(sql:"UPDATE teams_details SET isselected = 0 WHERE team_categoriy = \(teamType) AND team_Id NOT IN (\(variableString))")
       // appDelegate().db.query(sql: "UPDATE Teams_details SET isselected = 1 WHERE team_categoriy = \(teamType) AND team_Id IN \(variableString)")
         // appDelegate().db.query(sql: "UPDATE Teams_details SET isselected = 0 WHERE team_categoriy = \(teamType) AND team_Id NOT IN \(variableString)")
        self.dismiss(animated: true, completion: nil)
    }
    func showNoteamfound(){
        let bullet1 = "Sorry! No teams found for your search criteria."
        let bullet2 = "Please try a different search criteria."
        //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
        // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
        
        strings = [bullet1, bullet2]
        // let boldText  = "Quick Information \n"
        let attributesDictionary = [kCTForegroundColorAttributeName : NoteamLabel?.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedString.Key : Any])
        //  let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        //let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
        //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: boldString)
        
        //fullAttributedString.append(boldString)
        for string: String in strings
        {
            //let _: String = ""
            let formattedString: String = "\(string)\n\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            let range1 = (formattedString as NSString).range(of: "Invite")
            attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
            
            let range2 = (formattedString as NSString).range(of: "Settings")
            attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
            
            fullAttributedString.append(attributedString)
        }
        
        
        NoteamLabel?.attributedText = fullAttributedString
    }
    func createParagraphAttribute() ->NSParagraphStyle
    {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        //paragraphStyle.tabStops = [NSTextTab (textAlignment: .justified, location: 0.0, options: [NSTextTab.OptionKey: an])] //[NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [String : AnyObject])]
        paragraphStyle.defaultTabInterval = 0
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 0
        
        return paragraphStyle
    }
   /* func collectionView(_ tableView: UICollectionView, didDeselectRowAt indexPath: IndexPath) {
        
        //cell.pickContact?.backgroundColor = UIColor.clear
        //let colour = cell.contentView.tintColor
        let cell = collectionView.cellForItem(at: indexPath) as! TeamCollectionViewCell //collectionView.cellForRow(at: indexPath) as! TeamCollectionViewCell
        

        // let dict: NSDictionary? = appDelegate().allAppContacts[indexPath.row] as? NSDictionary
        //dict?.setValue("blue", forKey: "colour")
        cell.colTick?.image = UIImage(named: "uncheck")
        
        //appDelegate().allAppContacts.replaceObject(at: indexPath.row, with: dict as Any)
        
    }*/
}
