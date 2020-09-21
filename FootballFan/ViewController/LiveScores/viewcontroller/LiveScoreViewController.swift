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
    var liveScoreArray = [LiveScoreModel]()
    var sortedliveScoreArray = [LiveScoreModel]()
    var refreshTable: UIRefreshControl!
    var apd = UIApplication.shared.delegate as! AppDelegate
    var calenderDateArray: [AnyObject] = []
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
        let calendar = Calendar(identifier: .gregorian)
        let startOfDate = calendar.startOfDay(for: Date())
        // setdate(midiledate: startOfDate)
        createDateArrayWithDay(midiledate: startOfDate)
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        self.collectionViewTab.dataSource  = self
        self.collectionViewTab.delegate = self
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        UserDefaults.standard.setValue(0, forKey: "notificationcount")
        UserDefaults.standard.synchronize()
        
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
        createDateArrayWithDay(midiledate: date)
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
    
    //Create and manage collection date day and time interval array
    func createDateArrayWithDay(midiledate : Date) {
        calenderDateArray = []
        self.liveScoreArray = []
        self.sortedliveScoreArray = []
        var calendar = Calendar(identifier: .gregorian)
        var centertimestrump = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM"
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: midiledate)!
        for index in 0...14 {
            let startDate = Calendar.current.date(byAdding: .day, value: index, to: startDate)!
            var tempTimeDic = [String : String]()
            tempTimeDic["day"] = dateFormatter.string(from: startDate)
            tempTimeDic["date"] = dateFormatter1.string(from: startDate)
            //Vipin
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            let utcDateNew = calendar.startOfDay(for: startDate)
            let timeinterval = utcDateNew.timeIntervalSince1970 * 1000
            tempTimeDic["timeInterval"] = String(Int64(timeinterval.rounded()))
            calenderDateArray.append(tempTimeDic as AnyObject)
        }
        selectedIndex = 7
        collectionViewTab.reloadData()
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.collectionViewTab.contentSize = CGSize(width: self.collectionViewTab.bounds.width * CGFloat(self.calenderDateArray.count), height: self.collectionViewTab.bounds.height)
            self.collectionViewTab.scrollToItem(at: IndexPath(row: 7, section: 0), at: .centeredHorizontally, animated: false)
        }
        if calenderDateArray.count>7 {
            centertimestrump = calenderDateArray[7]["timeInterval"] as! String
            let param = "Date/FixtureDate/\(centertimestrump)"
            scoreapiCall(param: param ,currenttimestrmp: centertimestrump)
        }
        
    }
    
    
    //MARK:- These are navigation gesture recogniser events
    @objc func ligaTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view
        let section = headerView!.tag
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = sortedliveScoreArray[selectedJsonIndex].valueObject[section].season_id ?? 0

        myTeamsController.legname = sortedliveScoreArray[selectedJsonIndex].valueObject[section].name ?? ConstantString.notAvailable
        myTeamsController.fixtureArray = sortedliveScoreArray[selectedJsonIndex].valueObject[section].fixture
        show(myTeamsController, sender: self)
    }
    
    @objc func standingTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view
        let section = headerView!.tag
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let myTeamsController : LegaDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "legdetail") as! LegaDetailsViewController
        myTeamsController.season_id = sortedliveScoreArray[selectedJsonIndex].valueObject[section].season_id ?? 0
        myTeamsController.legname = sortedliveScoreArray[selectedJsonIndex].valueObject[section].name ?? ConstantString.notAvailable
        myTeamsController.tabatindex = 2
        myTeamsController.fixtureArray = sortedliveScoreArray[selectedJsonIndex].valueObject[section].fixture
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
                                self.liveScoreArray.append(tempScoreObject!)
                            }
                            self.sortedliveScoreArray = self.liveScoreArray.sorted(by: { $0.keyObject < $1.keyObject})
                            self.createarraylist(timeint: currenttimestrmp)
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
    func createarraylist(timeint:String) {
        for index in 0..<sortedliveScoreArray.count{
            if sortedliveScoreArray[index].keyObject == Int(timeint) {
                selectedJsonIndex = index
                break
            }
        }
        tableView.reloadData()
    }
}

extension LiveScoreViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calenderDateArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celltab", for: indexPath as IndexPath) as! GameDateCell
        let dic = calenderDateArray[indexPath.row]
        if selectedIndex == indexPath.row {
            cell.dayTitle.backgroundColor = UIColor.init(hex: "ffd401")
            cell.dayTitle.font = UIFont.boldSystemFont(ofSize: 16)
            cell.weekTitle.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            cell.dayTitle.backgroundColor = UIColor.clear
            cell.dayTitle.font = UIFont.systemFont(ofSize:16)
            cell.weekTitle.font = UIFont.systemFont(ofSize:16)
        }
        cell.weekTitle.text = dic.value(forKey: "day") as? String
        cell.dayTitle.text = dic.value(forKey: "date") as? String
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if(indexPath.row>2 && indexPath.row<14){
            collectionViewTab.contentSize = CGSize(width: collectionViewTab.bounds.width * CGFloat(calenderDateArray.count), height: collectionViewTab.bounds.height)
            collectionViewTab.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        self.collectionViewTab.reloadData()
        
        let dic = calenderDateArray[indexPath.row] as! NSDictionary
        createarraylist(timeint: dic.value(forKey: "timeInterval") as! String)
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
                messageLabel.text = "No information found\non this date"
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = .center;
                messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
                messageLabel.sizeToFit()
                self.tableView.backgroundView = messageLabel;
            }
            return 0
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
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
//        header.textLabel?.frame.origin.x = 40
//        header.textLabel?.textColor = UIColor.black
//        header.textLabel?.text = sortedliveScoreArray[selectedJsonIndex].valueObject[section].name
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
        
        let imgligelogo = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30));
        let url = URL(string:sortedliveScoreArray[selectedJsonIndex].valueObject[section].logo_path ?? "")
        if let logourl = url {
            imgligelogo.af.setImage(withURL: logourl)
        }
        imgligelogo.tag = kHeaderSectionTag + section
        imgligelogo.isUserInteractionEnabled = true
        header.addSubview(imgligelogo)
        let messageLabel = UILabel(frame: CGRect(x: 50, y: 2, width: 230, height: 30))
        messageLabel.text = ""
        messageLabel.text = sortedliveScoreArray[selectedJsonIndex].valueObject[section].name
        messageLabel.backgroundColor = UIColor.init(hex: "EFEFEF")
        messageLabel.textColor = UIColor.black
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
                    cell.imgvisitteam?.af.setImage(withURL: url)
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
        myTeamsController.season_id = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].season_id ?? 0
        myTeamsController.fixtureData = sortedliveScoreArray[selectedJsonIndex].valueObject[indexPath.section].fixture?[indexPath.row]
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
        let sectionData = sortedliveScoreArray[selectedJsonIndex].valueObject[section].fixture! as NSArray
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0..<sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = sortedliveScoreArray[selectedJsonIndex].valueObject[section].fixture! as NSArray
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
