//
//  AddTeamViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 28/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class AddTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var collectionViewTeams: UICollectionView?
    @IBOutlet weak var colSearchBar: UISearchBar?
    let reuseIdentifier = "collectioncell"
    //var dataTeams: NSArray?
    var dataFilteredTeams: NSArray?
    var arrDataTeamsAll = NSArray()
    var isShowForBanterRoom = false
    var teamType = ""
     var strings:[String] = []
     @IBOutlet weak var NoteamLabel: UILabel?
    var searchActive : Bool = false
    var searchStarting : Bool = false
     @IBOutlet weak var topConstraint: NSLayoutConstraint!
     @IBOutlet weak var parenttopConstraint: NSLayoutConstraint!
     @IBOutlet weak var copRightlbl: UILabel?
    var categoryname : String = "Select a Team"
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
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            let copyrightvalue: String = UserDefaults.standard.string(forKey: "teamcopyright")!
        if(copyrightvalue == ""){
            self.parenttopConstraint.constant = 10.0
            copRightlbl?.isHidden = true
        }
        else{
             self.parenttopConstraint.constant = 30.0
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
        }
        }
        else{
            self.parenttopConstraint.constant = 10.0
            copRightlbl?.isHidden = true
        }
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
        
        
        filterTeams()
        
        
    }
    
    func filterTeams()
    {
        if(teamType == "my")
        {
             self.topConstraint.constant = 10.0
            colSearchBar?.isHidden = true
            appDelegate().primaryTeamId = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
            appDelegate().optionalTeam1Id = Int64(UserDefaults.standard.integer(forKey: "optionalTeam1Id"))
            appDelegate().optionalTeam2Id = Int64(UserDefaults.standard.integer(forKey: "optionalTeam2Id"))
            appDelegate().optionalTeam3Id = Int64(UserDefaults.standard.integer(forKey: "optionalTeam3Id"))
            
            let predicateFormat = NSString(format: "team_Id == '%d' || team_Id == '%d' || team_Id == '%d' || team_Id == '%d'",
                                           appDelegate().primaryTeamId,
                                           appDelegate().optionalTeam1Id,
                                           appDelegate().optionalTeam2Id,
                                           appDelegate().optionalTeam3Id)
            let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
            
            let sectionArray = appDelegate().arrDataTeams.filtered(using: predicate)
            
            dataFilteredTeams = sectionArray as NSArray
            arrDataTeamsAll = sectionArray as NSArray
            
            //New code to filter my team and opponent team
            
            let predicateFormat2 = NSString(format: "team_Id != '%d'",
                                            appDelegate().myTeamId)
            let predicate2:NSPredicate = NSPredicate(format:predicateFormat2 as String)
            
            let sectionArray2: NSArray = (dataFilteredTeams!.filtered(using: predicate2) as NSArray?)!
            
            dataFilteredTeams = sectionArray2 as NSArray
            arrDataTeamsAll = sectionArray2 as NSArray
            
            let predicateFormat3 = NSString(format: "team_Id != '%d'",
                                            appDelegate().aponentTeamId)
            let predicate3:NSPredicate = NSPredicate(format:predicateFormat3 as String)
            
            let sectionArray3: NSArray = (dataFilteredTeams!.filtered(using: predicate3) as NSArray?)!
            
            dataFilteredTeams = sectionArray3 as NSArray
            arrDataTeamsAll = sectionArray3 as NSArray
            
            
        }
        else if(teamType == "aponent")
        {
            let predicateFormat = NSString(format: "team_Id != '%d'",
                                           appDelegate().myTeamId)
            let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
            
            let sectionArray = appDelegate().arrDataTeams.filtered(using: predicate)
            
            dataFilteredTeams = sectionArray as NSArray
            arrDataTeamsAll = sectionArray as NSArray
            
            //New code to filter my team and opponent team
            
            let predicateFormat2 = NSString(format: "team_Id != '%d'",
                                            appDelegate().aponentTeamId)
            let predicate2:NSPredicate = NSPredicate(format:predicateFormat2 as String)
            
            let sectionArray2: NSArray = (dataFilteredTeams!.filtered(using: predicate2) as NSArray?)!
            
            dataFilteredTeams = sectionArray2 as NSArray
            arrDataTeamsAll = sectionArray2 as NSArray
            
            
        }
        else if(teamType == "nearby")
        {
            let predicateFormat = NSString(format: "team_Id != '%d'",
                                           appDelegate().nearbyTeamId)
            let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
            
            let sectionArray = appDelegate().arrDataTeams.filtered(using: predicate)
            
            dataFilteredTeams = sectionArray as NSArray
            arrDataTeamsAll = sectionArray as NSArray
            
        }
        else if(teamType == "updates")
        {
            let predicateFormat = NSString(format: "team_Id != '%d'",
                                           appDelegate().fanUpdatesTeamId)
            let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
            
            let sectionArray = appDelegate().arrDataTeams.filtered(using: predicate)
            
            dataFilteredTeams = sectionArray as NSArray
            arrDataTeamsAll = sectionArray as NSArray
            
        }
        else
        {
            //if(isShowForBanterRoom)
            //{
            appDelegate().primaryTeamId = Int64(UserDefaults.standard.integer(forKey: "primaryTeamId"))
            appDelegate().optionalTeam1Id = Int64(UserDefaults.standard.integer(forKey: "optionalTeam1Id"))
            appDelegate().optionalTeam2Id = Int64(UserDefaults.standard.integer(forKey: "optionalTeam2Id"))
            appDelegate().optionalTeam3Id = Int64(UserDefaults.standard.integer(forKey: "optionalTeam3Id"))
            
            let predicateFormat = NSString(format: "team_Id != '%d'",
                                           appDelegate().primaryTeamId)
            let predicate:NSPredicate = NSPredicate(format:predicateFormat as String)
            
            let sectionArray = appDelegate().arrDataTeams.filtered(using: predicate)
            
            dataFilteredTeams = sectionArray as NSArray
            arrDataTeamsAll = sectionArray as NSArray
            
            let predicateFormat2 = NSString(format: "team_Id != '%d'",
                                            appDelegate().optionalTeam1Id)
            let predicate2:NSPredicate = NSPredicate(format:predicateFormat2 as String)
            
            let sectionArray2: NSArray = (dataFilteredTeams!.filtered(using: predicate2) as NSArray?)!
            
            dataFilteredTeams = sectionArray2 as NSArray
            arrDataTeamsAll = sectionArray2 as NSArray
            
            let predicateFormat3 = NSString(format: "team_Id != '%d'",
                                            appDelegate().optionalTeam2Id)
            let predicate3:NSPredicate = NSPredicate(format:predicateFormat3 as String)
            
            let sectionArray3: NSArray = (dataFilteredTeams!.filtered(using: predicate3) as NSArray?)!
            
            dataFilteredTeams = sectionArray3 as NSArray
            arrDataTeamsAll = sectionArray3 as NSArray
            
            let predicateFormat4 = NSString(format: "team_Id != '%d'",
                                            appDelegate().optionalTeam3Id)
            let predicate4:NSPredicate = NSPredicate(format:predicateFormat4 as String)
            
            let sectionArray4: NSArray = (dataFilteredTeams!.filtered(using: predicate4) as NSArray?)!
            
            dataFilteredTeams = sectionArray4 as NSArray
            arrDataTeamsAll = sectionArray4 as NSArray
            /*}
             else
             {
             dataFilteredTeams = appDelegate().arrDataTeams
             }*/
            
        }
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
        NoteamLabel?.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        colSearchBar?.resignFirstResponder()
        if let cancelButton = colSearchBar?.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        searchActive = true
        searchStarting = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count>0)
        {
            let result: NSArray = (self.arrDataTeamsAll.filter({ (text) -> Bool in
                let tmp: NSDictionary = text as! NSDictionary
                let val = tmp.value(forKey: "team_name")
                let range = (val as AnyObject).range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }) as NSArray?)!
            
            //if((result?.count) != nil)
            if(result.count > 0)
            {
                NoteamLabel?.isHidden = true
                dataFilteredTeams = result as NSArray//NSArray(array: result!)//result as! NSMutableArray
            }
            else
            {
                dataFilteredTeams = NSArray()
                //filterTeams()
                NoteamLabel?.isHidden = false
                showNoteamfound()
            }
        }
        else{
            NoteamLabel?.isHidden = true
            filterTeams()
        }
       
        
        //searchActive = true
        //storyTableView?.reloadData()
        collectionViewTeams?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataFilteredTeams!.count)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TeamCollectionViewCell
        
        /*let index = dataTeams?.allKeys.startIndex.advanced(by: indexPath.row)
         let key1 = dataTeams?.allKeys[index!]
         let dict2: NSDictionary? = dataTeams?.value(forKey: key1 as! String) as? NSDictionary
         cell.colName?.text = dict2?.value(forKey: "name") as? String*/
        
        let dict: NSDictionary? = dataFilteredTeams?[indexPath.row] as? NSDictionary
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
        
        if(isShowForBanterRoom)
        {
            if(teamType == "my")
            {
                if(appDelegate().myTeamId == teamId)
                {
                    cell.colTick?.image = UIImage(named:"green_tick")
                    cell.colImage?.alpha = 0.6
                }
            }
            else if(teamType == "aponent")
            {
                if(appDelegate().aponentTeamId == teamId)
                {
                    cell.colTick?.image = UIImage(named:"green_tick")
                    cell.colImage?.alpha = 0.6
                }
            }
            else if(teamType == "nearby")
            {
                if(appDelegate().nearbyTeamId == teamId)
                {
                    cell.colTick?.image = UIImage(named:"green_tick")
                    cell.colImage?.alpha = 0.6
                }
            }
            else if(teamType == "updates")
            {
                if(appDelegate().fanUpdatesTeamId == teamId)
                {
                    cell.colTick?.image = UIImage(named:"green_tick")
                    cell.colImage?.alpha = 0.6
                }
            }
            
        }
        else
        {
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
        
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        
        let dict: NSDictionary? = dataFilteredTeams?[indexPath.row] as? NSDictionary
        let teamId: Int64 = Int64(dict?.value(forKey: "team_Id") as! String)!
        let teamName = dict?.value(forKey: "team_name") as? NSString
        let teamLogo = dict?.value(forKey: "team_logo") as? NSString
        //print(appDelegate().teamToSet)
        
        if(isShowForBanterRoom)
        {
            if(teamType == "my")
            {
                appDelegate().myTeamId = teamId
                appDelegate().myTeamName = teamName! as String
            }
            else if(teamType == "aponent")
            {
                appDelegate().aponentTeamId = teamId
                appDelegate().aponentTeamName = teamName! as String
            }
            else if(teamType == "nearby")
            {
                appDelegate().nearbyTeamId = teamId
                appDelegate().nearbyTeamName = teamName! as String
            }
            else if(teamType == "updates")
            {
                appDelegate().fanUpdatesTeamId = teamId
                appDelegate().fanUpdatesTeamName = teamName! as String
                
                let notificationName = Notification.Name("_FetchFanUpdatesData")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
           
            //self.dismiss(animated: false, completion: nil)DissminNotify
            self.dismiss(animated: false, completion: nil)
            let notificationName = Notification.Name("DissminNotify")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        else
        {
            if(appDelegate().primaryTeamId != teamId && appDelegate().optionalTeam1Id != teamId && appDelegate().optionalTeam2Id != teamId && appDelegate().optionalTeam3Id != teamId)
            {
                if(appDelegate().teamToSet == 1)
                {
                    appDelegate().primaryTeamId = teamId
                    appDelegate().primaryTeamName = teamName! as String
                    
                    UserDefaults.standard.setValue(teamId, forKey: "primaryTeamId")
                    UserDefaults.standard.setValue(teamName! as String, forKey: "primaryTeamName")
                    UserDefaults.standard.setValue(teamLogo! as String, forKey: "primaryTeamLogo")
                    UserDefaults.standard.synchronize()
                    appDelegate().isTeamsUpdated = true
                }
                else if(appDelegate().teamToSet == 2)
                {
                    appDelegate().optionalTeam1Id = teamId
                    appDelegate().optionalTeam1Name = teamName! as String
                    UserDefaults.standard.setValue(teamId, forKey: "optionalTeam1Id")
                    UserDefaults.standard.setValue(teamName! as String, forKey: "optionalTeam1Name")
                    UserDefaults.standard.setValue(teamLogo! as String, forKey: "optionalTeam1Logo")
                    UserDefaults.standard.synchronize()
                     appDelegate().isTeamsUpdated = true
                }
                else if(appDelegate().teamToSet == 3)
                {
                    appDelegate().optionalTeam2Id = teamId
                    appDelegate().optionalTeam2Name = teamName! as String
                    UserDefaults.standard.setValue(teamId, forKey: "optionalTeam2Id")
                    UserDefaults.standard.setValue(teamName! as String, forKey: "optionalTeam2Name")
                    UserDefaults.standard.setValue(teamLogo! as String, forKey: "optionalTeam2Logo")
                    UserDefaults.standard.synchronize()
                     appDelegate().isTeamsUpdated = true
                }
                else if(appDelegate().teamToSet == 4)
                {
                    appDelegate().optionalTeam3Id = teamId
                    appDelegate().optionalTeam3Name = teamName! as String
                    UserDefaults.standard.setValue(teamId, forKey: "optionalTeam3Id")
                    UserDefaults.standard.setValue(teamName! as String, forKey: "optionalTeam3Name")
                    UserDefaults.standard.setValue(teamLogo! as String, forKey: "optionalTeam3Logo")
                    UserDefaults.standard.synchronize()
                     appDelegate().isTeamsUpdated = true
                }
                self.dismiss(animated: false, completion: nil)
                let notificationName = Notification.Name("DissminNotify")
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
        
    }
    
    @IBAction func cancelMe () {
       // appDelegate().teamToSet = 0
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            AddTeamViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return AddTeamViewController.realDelegate!;
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

