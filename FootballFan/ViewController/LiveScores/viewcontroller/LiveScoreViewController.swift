//
//  LiveScoreViewController.swift
//  FootballFan
//
//  Created by Apple on 10/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FSCalendar
import ObjectMapper

class LiveScoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate{
    
    
    
    @IBOutlet weak var collectionViewTab: UICollectionView!
    @IBOutlet weak var viewcalender: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedJsonIndex = -1;
    var responseDataObject : ResponseDataModel?
    var sortedliveScoreArray = [LiveScoreModel]()
    var refreshTable: UIRefreshControl!
    var apd = UIApplication.shared.delegate as! AppDelegate
    var calenderdate: [AnyObject] = []
    var selectedIndex = Int ()
    var arrscore: [AnyObject] = []
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    let kHeaderSectionTag: Int = 6900;
    var scoredata = NSDictionary()
    var iscalendershow = false
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        self.collectionViewTab.dataSource  = self
        self.collectionViewTab.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        UserDefaults.standard.setValue(0, forKey: "notificationcount")
        UserDefaults.standard.synchronize()
        let calendar = Calendar(identifier: .gregorian)
        let startOfDate = Date()//calendar.startOfDay(for: Date()+1)
        setdate(midiledate: startOfDate)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.title = "Games"
        let button2 = UIBarButtonItem(image: UIImage(named: "calender"), style: .plain, target: self, action: #selector(self.Showcalender(sender:)))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2
        parent?.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    //MARK:- Calender button event and delegate
    @objc func Showcalender(sender:UIButton) {
        if(iscalendershow){
            calendar.isHidden = true
            iscalendershow = false
        }
        else{
            calendar.isHidden = false
            iscalendershow = true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        setdate(midiledate: date)
        calendar.isHidden = true
        iscalendershow = false
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    //MARK:- Date to call API
    func setdate(midiledate : Date)  {
        calenderdate = []
        let calendar = Calendar(identifier: .gregorian)
        let startOfDate = calendar.startOfDay(for: Date())
        let timeinterval1 = startOfDate.timeIntervalSince1970 * 1000
        let time = Int64(timeinterval1.rounded())
        var centertimestrump = ""
        var weekstring = ""
        var datestring = ""
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE"
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.dateFormat = "dd MMM"
        for i in (1...7 ).reversed(){
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -i, to: midiledate)!
            // previous7days.insert(calendar.component(.CalendarUnitDay, fromDate: prevDate!), atIndex: 0)
            // print(modifiedDate)
            
            weekstring = dateFormatter.string(from: modifiedDate)
            datestring = dateFormatter1.string(from: modifiedDate)
            let timeinterval = modifiedDate.timeIntervalSince1970 * 1000
            let finaltime = Int64(timeinterval.rounded())
            // print(finaltime)
            // print(datestring)
            var tempDict = [String: String]()
            
            tempDict["weekday"] = weekstring
            tempDict["daydate"] = datestring
            tempDict["milisecond"] = String(finaltime)
            calenderdate.append(tempDict as AnyObject)
        }
        for i in 0...8 {
            var calendar = Calendar(identifier: .gregorian)
            let modifiedDate = Calendar.current.date(byAdding: .day, value: i, to: midiledate)!
            weekstring = dateFormatter.string(from: modifiedDate)
            datestring = dateFormatter1.string(from: modifiedDate)
            //Vipin
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            let utcDateNew = calendar.startOfDay(for: modifiedDate)
            let timeinterval = utcDateNew.timeIntervalSince1970 * 1000
            let finaltime = Int64(timeinterval.rounded())
            
            if (i==0) {
                centertimestrump = String(finaltime)
            }
            if(time == finaltime){
                var tempDict = [String: String]()
                
                tempDict["weekday"] = "Today"
                tempDict["daydate"] = datestring
                tempDict["milisecond"] = String(finaltime)
                calenderdate.append(tempDict as AnyObject)
                
            } else{
                var tempDict = [String: String]()
                
                tempDict["weekday"] = weekstring
                tempDict["daydate"] = datestring
                tempDict["milisecond"] = String(finaltime)
                calenderdate.append(tempDict as AnyObject)
            }
            
        }
        selectedIndex = 7
        collectionViewTab.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.collectionViewTab.contentSize = CGSize(width: self.collectionViewTab.bounds.width * CGFloat(self.calenderdate.count), height: self.collectionViewTab.bounds.height)
            self.collectionViewTab.scrollToItem(at: IndexPath(row: 7, section: 0), at: .centeredHorizontally, animated: false)
        }
        let param = "Date/FixtureDate/\(centertimestrump)"
        scoreapiCall(param: param ,currenttimestrmp: centertimestrump)
    }
    
    
    //MARK:- These are navigation gesture recogniser events
    @objc func ligaTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view
        let section    = headerView!.tag
        let dic = arrscore[section] as! NSDictionary
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = dic.value(forKey: "season_id") as AnyObject
        myTeamsController.legname = dic.value(forKey: "legname") as! String
        //Comment By Vipin
        myTeamsController.dic = dic.value(forKey: "seasonStat") as! NSDictionary
        show(myTeamsController, sender: self)
    }
    
    @objc func standingTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view
        let section    = headerView!.tag
        let dic = arrscore[section] as! NSDictionary
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = dic.value(forKey: "season_id") as AnyObject
        myTeamsController.legname = dic.value(forKey: "legname") as! String
        //Comment By Vipin
        myTeamsController.dic = dic.value(forKey: "seasonStat") as! NSDictionary
        myTeamsController.tabatindex = 2
        show(myTeamsController, sender: self)
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
        });
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    //MARK:- Webservices call to get live score data
    func scoreapiCall(param: String,currenttimestrmp:String){
        if ClassReachability.isConnectedToNetwork() {
            var liveScoreArray = [LiveScoreModel]()
            let url = "\(baseurl)/\(param)"
            AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let status1: Bool = json["success"] as! Bool
                        if(status1){
                            self.scoredata = json["json"] as! NSDictionary
                            self.responseDataObject = Mapper<ResponseDataModel>().map(JSONObject: json)
                            for element in (self.responseDataObject?.json!)!{
                                var tempScoreObject = LiveScoreModel(JSON: ["keyObject" :Int(element.key) as Any, "valueObject" :[]])
                                tempScoreObject?.valueObject = element.value
                                liveScoreArray.append(tempScoreObject!)
                            }
                            
                            self.sortedliveScoreArray = liveScoreArray.sorted(by: { $0.keyObject < $1.keyObject})
                            self.createarraylist(timeint: currenttimestrmp, utcTime: Int(currenttimestrmp) ?? 0)
                        }else{
                            self.alertWithTitle(title: nil, message: ConstantString.apiFailMsg, ViewController: self)
                        }
                    }
                case .failure(let error):
                    self.alertWithTitle(title: nil, message: ConstantString.apiFailMsg, ViewController: self)
                    print(error)
                    break
                }
            }
        } else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func createarraylist(timeint:String, utcTime : Int) {
        for index in 0..<sortedliveScoreArray.count{
            print(index)
            print(sortedliveScoreArray[index].keyObject)
            if sortedliveScoreArray[index].keyObject == utcTime {
                selectedJsonIndex = index
                break
            }
        }
       // tableView.reloadData()
        arrscore = []
        if scoredata.value(forKey: timeint) != nil{
            let array = scoredata.value(forKey: timeint) as! NSArray
            for i in 0..<array.count{
                let dict: NSDictionary = array[i] as! NSDictionary
                var parentDict = [String: AnyObject]()
                parentDict["leglogo"] = dict.value(forKey: "logo_path") as AnyObject
                parentDict["legname"] = dict.value(forKey: "name") as AnyObject
                parentDict["season_id"] = dict.value(forKey: "season_id") as AnyObject?
                parentDict["seasonStat"] = dict.value(forKey: "seasonStat") as AnyObject?
                let fixture = dict.value(forKey: "fixture") as! NSArray
                var arrfixture: [AnyObject] = []
                for j in 0..<fixture.count{
                    let dict1: NSDictionary = fixture[j] as! NSDictionary
                    
                    var homename = ""
                    
                    var visitorname = ""
                    
                    if let localTeam = dict1.value(forKey: "localTeam") {
                        if let localTeamDetil = (localTeam as AnyObject).value(forKey: "data") {
                            
                            if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                homename = name as! String
                                
                            }
                        }}
                    
                    if let visitorTeam = dict1.value(forKey: "visitorTeam") {
                        if let localTeamDetil = (visitorTeam as AnyObject).value(forKey: "data") {
                            
                            if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                visitorname = name as! String
                                
                            }}}
                    
                    if(homename != "" && visitorname != ""){
                        
                        arrfixture.append(dict1 as AnyObject)
                    }
                    
                }
                parentDict["fixture"] = arrfixture as AnyObject
                arrscore.append( parentDict as AnyObject)
                
            }
            print(arrscore)
            tableView.reloadData()
            
        }
    }
}

extension LiveScoreViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calenderdate.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celltab", for: indexPath as IndexPath) as! GameDateCell
        let dic = calenderdate[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.dayTitle.backgroundColor = UIColor.init(hex: "ffd401")
            cell.dayTitle.font = UIFont.boldSystemFont(ofSize: 16)
            cell.weekTitle.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            cell.dayTitle.backgroundColor = UIColor.clear
            cell.dayTitle.font = UIFont.systemFont(ofSize:16)
            cell.weekTitle.font = UIFont.systemFont(ofSize:16)
        }
        cell.weekTitle.text = dic.value(forKey: "weekday") as? String
        cell.dayTitle.text = dic.value(forKey: "daydate") as? String
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if(indexPath.row>2 && indexPath.row<14){
            collectionViewTab.contentSize = CGSize(width: collectionViewTab.bounds.width * CGFloat(calenderdate.count), height: collectionViewTab.bounds.height)
            collectionViewTab.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        self.collectionViewTab.reloadData()
        let dic = calenderdate[indexPath.row] as! NSDictionary
        createarraylist(timeint: dic.value(forKey: "milisecond") as! String, utcTime: dic.value(forKey: "milisecond") as! Int)
    }
}


extension LiveScoreViewController {
    func numberOfSections(in tableView: UITableView) -> Int{
        if sortedliveScoreArray.count>0 {
            if sortedliveScoreArray[selectedJsonIndex].valueObject.count > 0 {
                tableView.backgroundView = nil
                return sortedliveScoreArray[selectedJsonIndex].valueObject.count
            } else {
                let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
                messageLabel.text = "Retrieving data.\nPlease wait."
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
                messageLabel.sizeToFit()
                self.tableView.backgroundView = messageLabel;
            }
            return 0
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            //            let dic = arrscore[section]
            //            let arrayOfItems = dic.value(forKey: "fixture") as! NSArray
            //            return arrayOfItems.count;
            return sortedliveScoreArray[selectedJsonIndex].valueObject[section].fixture?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.init(hex: "EFEFEF")//UIColor.colorWithHexString(hexStr: "#0075d4")
        //let dic = arrscore[section]
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.text = sortedliveScoreArray[selectedJsonIndex].valueObject[section].name
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let standinglogo = UIImageView(frame: CGRect(x: headerFrame.width - 85, y: 13, width: 20, height: 20));
        standinglogo.image = UIImage(named: "standing")
        standinglogo.tag =  section
        standinglogo.isUserInteractionEnabled = true
        header.addSubview(standinglogo)
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 35, y: 13, width: 20, height: 15));
        theImageView.image = UIImage(named: "dwonarrow")
        theImageView.tag = kHeaderSectionTag + section
        theImageView.isUserInteractionEnabled = true
        header.addSubview(theImageView)
        
        let imgligelogo = UIImageView(frame: CGRect(x: 10, y: 13, width: 20, height: 20));
        let url = URL(string:sortedliveScoreArray[selectedJsonIndex].valueObject[section].logo_path ?? "")
        if let logourl = url {
            imgligelogo.af.setImage(withURL: logourl)
        }
        imgligelogo.tag = kHeaderSectionTag + section
        imgligelogo.isUserInteractionEnabled = true
        header.addSubview(imgligelogo)
        let messageLabel = UILabel(frame: CGRect(x: 0, y: headerFrame.height - 2, width: headerFrame.width, height: 1))
        // messageLabel.text = self.sectionNames[section] as? String
        messageLabel.backgroundColor = UIColor.black
        header.addSubview(messageLabel)
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(sectionHeaderWasTouched(_:)))
        theImageView.addGestureRecognizer(headerTapGesture)
        let ligaTapGesture = UITapGestureRecognizer()
        ligaTapGesture.addTarget(self, action: #selector(ligaTouched(_:)))
        header.addGestureRecognizer(ligaTapGesture)
        let standingTapGesture = UITapGestureRecognizer()
        standingTapGesture.addTarget(self, action: #selector(standingTouched(_:)))
        standinglogo.addGestureRecognizer(standingTapGesture)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! LivescoreCell
       //Set Local Team Data
        if let localTeam = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].fixture?[indexPath.row].localTeam {
            if let localTeamData = localTeam.data {
                
                if let localTeamName = localTeamData.name{
                    cell.hometeam?.text = localTeamName
                } else {
                    cell.hometeam?.text = ConstantString.notAvailable
                }
                
                if let localTeamlogo = localTeamData.logo_path {
                    let url = URL(string:localTeamlogo)!
                    cell.imghometeam?.af.setImage(withURL: url)
                }
            }}
        
        //Set Visitor Team Data
        if let visitorTeam = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].fixture?[indexPath.row].visitorTeam  {
            if let visitorTeamData = visitorTeam.data {
                
                if let visitorTeamName = visitorTeamData.name {
                    cell.visitteam?.text = visitorTeamName
                } else {
                    cell.visitteam?.text = ConstantString.notAvailable
                }
                if let visitorTeamlogo = visitorTeamData.logo_path{
                    let url = URL(string:visitorTeamlogo)!
                    cell.imghometeam?.af.setImage(withURL: url)
                }
                
            }}
        //Live and visitor score varibale
        var localTeamScore = 0
        var visitorTeamScore = 0
        
        //Team scores
        if let scoreObject = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].fixture?[indexPath.row].scores {
            localTeamScore = scoreObject.localteam_score ?? 0
            visitorTeamScore = scoreObject.visitorteam_score ?? 0
            cell.lbltime?.text = "\(localTeamScore) : \(visitorTeamScore)"
        }
        
         //Time scores
        if let timeData = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].fixture?[indexPath.row].time {
            let status = timeData.status
            if(status == "FT"){
                cell.lblstatus?.text = "Final Score"
                cell.lblstatus?.font = UIFont.systemFont(ofSize: 13.0)
                cell.lbltime?.text = "\(localTeamScore) : \(visitorTeamScore)"
            }
            else if(status == "LIVE"){
                cell.lblstatus?.text = "Live"
                cell.lbltime?.text = "\(localTeamScore) : \(visitorTeamScore)"
                cell.lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
            }
            else if(status == "NS"){
                cell.lblstatus?.text = "Time"
                cell.lblstatus?.font = UIFont.systemFont(ofSize: 15.0)
                if let mili = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].fixture?[indexPath.row].fixtureTime
                {
                    let mili: Double = Double(truncating: (mili as AnyObject) as! NSNumber)
                    let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    cell.lbltime?.text = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : FixturescoreViewController = storyBoard.instantiateViewController(withIdentifier: "fixture") as!
        FixturescoreViewController
        let dic = arrscore[indexPath.section]
        let arrayOfItems = dic.value(forKey: "fixture") as! [AnyObject]
        let dic1 = arrayOfItems[indexPath.row] as! NSDictionary
        myTeamsController.season_id = dic.value(forKey: "season_id") as AnyObject
        myTeamsController.dict = dic1
        show(myTeamsController, sender: self)
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view?.superview
        let section    = headerView!.tag
        let eImageView = headerView!.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        // let sectionData = self.sectionItems[section] as! NSArray
        let dic = arrscore[section]
        let sectionData = dic.value(forKey: "fixture") as! NSArray
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        //let sectionData = self.sectionItems[section] as! NSArray
        let dic = arrscore[section]
        let sectionData = dic.value(forKey: "fixture") as! NSArray
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
}
