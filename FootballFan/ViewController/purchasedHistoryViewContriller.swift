//
//  purchasedHistoryViewContriller.swift
//  FootballFan
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
class purchasedHistoryViewContriller: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "totalfccell"
    @IBOutlet weak var totalfc: UILabel?
    var returnToOtherView:Bool = false
    var lastposition = 0
    @IBOutlet weak var notelable: UILabel?
    var strings:[String] = []
    @IBOutlet weak var butcontacts: UIButton?
    var isPageRefresh: Bool = false
    var arrhistory: [AnyObject] = []
   
    @IBOutlet weak var totalrc: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        parent?.navigationItem.rightBarButtonItems = nil
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
       
        let notificationName = Notification.Name("_FetchedTotalFC")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedTotalFC), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("_FetchedTotalFCFail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedTotalFC), name: notificationName2, object: nil)
        
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
    
    @objc func fetchedTotalFC()
    {
       // TransperentLoadingIndicatorView.hide()
        closeRefresh()
        
       // let leaderdetail = appDelegate().arrTotalFC[0] as! NSDictionary
        //print(leaderdetail)
        
        //totalfc?.text = "\(self.appDelegate().formatNumber(leaderdetail.value(forKey: "todaycoins") as? Int ?? 0))"
        
        storyTableView?.reloadData()
        
        
        if(arrhistory.count <= 0)
        {
            
            notelable?.isHidden = false
            butcontacts?.isHidden = false
            storyTableView?.isHidden = true
            let bullet1 = "No purchase history available"
            //let bullet2 = "To learn more tap on “Learn About FanCoins Rewards?”."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1]
            // let boldText  = "Quick Information \n"
            let attributesDictionary = [kCTForegroundColorAttributeName : notelable?.font]
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
            
            
            notelable?.attributedText = fullAttributedString
        } else {
            notelable?.isHidden = true
            storyTableView?.isHidden = false
            butcontacts?.isHidden = true
        }
    }
    
    
    @IBAction  func HowEarn() {
        UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
        UserDefaults.standard.synchronize()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewcontroller = storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewcontroller
        show(myTeamsController, sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(returnToOtherView){
            getTotalFC(lastposition)
        } else {
            if(arrhistory.count == 0)
            {
                lastposition = 0
                self.getTotalFC(self.lastposition)
                /* if(appDelegate().isUserOnline)
                 {
                 getTotalFC(lastposition)
                 } else {
                 //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading.")
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                 // do stuff 3 seconds later
                 self.getTotalFC(self.lastposition)
                 }
                 }*/
            }
        }
        
    }
    
    
    
    func getTotalFC(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getpurchasehistory" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            if(lastindex == 0)
            {
                //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                isPageRefresh = true
            } else {
                isPageRefresh = false
            }
            do {
                //Creating Request Data
                var dictRequestData = [String: AnyObject]()
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                
                let myjidtrim: String? = userUserJid
                dictRequestData["lastindex"] = lastindex as AnyObject
                dictRequestData["username"] = myjidtrim as AnyObject
                dictRequestData["type"] = "today" as AnyObject
                dictRequest["requestData"] = dictRequestData as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
                
                // let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                //let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
               /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                //print(strFanUpdates)
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                
                let url = MediaAPIjava + "request=" + escapedString!*/
                //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
                AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                  headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                    // 2
                    .responseJSON { response in
                        
                        switch response.result {
                                   case .success(let value):
                                       if let json = value as? [String: Any] {
                                           // print(" JSON:", json)
                                           let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                           // self.finishSyncContacts()
                                           //print(" status:", status1)
                                           if(status1){
                                               DispatchQueue.main.async{
                                                   
                                                   let response: NSArray = json["responseData"] as! NSArray
                                                   
                                                  let myProfileDict: NSDictionary = response[0] as! NSDictionary
                                                   self.totalfc?.text = "£\(self.appDelegate().formatNumber(myProfileDict.value(forKey: "purchaseamount") as? Int ?? 0))"
                                                   self.totalrc?.text = "£\(self.appDelegate().formatNumber(myProfileDict.value(forKey: "returnamount") as? Int ?? 0))"
                                                   if(self.isPageRefresh)
                                                   {
                                                       self.arrhistory = myProfileDict.value(forKey: "purchase") as! [AnyObject]
                                                   } else  {
                                                       self.arrhistory += myProfileDict.value(forKey: "purchase") as! [AnyObject]
                                                   }
                                                   
                                                   let notificationName = Notification.Name("_FetchedTotalFC")
                                                   NotificationCenter.default.post(name: notificationName, object: nil)
                                                   
                                                   
                                                   
                                               }
                                               
                                           }
                                           else{
                                               DispatchQueue.main.async
                                                   {
                                                       //TransperentLoadingIndicatorView.hide()
                                                       self.closeRefresh()
                                               }
                                               //Show Error
                                           }
                                       }
                                   case .failure(let error):
                                    debugPrint(error as Any)
                                                               //TransperentLoadingIndicatorView.hide()
                                                               self.closeRefresh()
                            break
                                       // error handling
                        
                                   }
                       
                }
                
                //print(strFanUpdates)
                // self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            self.closeRefresh()
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    func closeRefresh()
    {
       // TransperentLoadingIndicatorView.hide()
    }
    
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            TodayFCViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return TodayFCViewController.realDelegate!;
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(arrhistory.count > 19)
        {
            
            let lastElement = arrhistory.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                lastposition = lastposition + 1
                getTotalFC(lastposition)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TotalFCCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TotalFCCell
        let dict: NSDictionary? = arrhistory[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            //cell.activity?.text = "\(dict?.value(forKey: "activity") as! String)"
            if((dict?.value(forKey: "transactiontype") as! String) == "earned")
            {
                cell.activity?.text = dict?.value(forKey: "transactionmsg") as! String
            } else if((dict?.value(forKey: "activity") as! String) == "redeemed")
            {
               cell.activity?.text = dict?.value(forKey: "transactionmsg") as! String
            }
            let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.activity?.frame.width)! , height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .left
            label.text = dict?.value(forKey: "transactionmsg") as! String
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            if((label.frame.height) > 17)
            {
                let height = (label.frame.height) + 31
                
                cell.messagesHightConstraint.constant = label.frame.height
                // cell.mainViewConstraint.constant = CGFloat(height)
                //print("Height \(height).")
                //storyTableView?.rowHeight = CGFloat(height)
                
            }
            else
            {
               
                cell.messagesHightConstraint.constant = 20
                // cell.mainViewConstraint.constant = CGFloat(height)
                //print("Height \(height).")
                // storyTableView?.rowHeight = CGFloat(height)
                
            }
            cell.fanCoins?.text = "£\(self.appDelegate().formatNumber(dict?.value(forKey: "baseamount") as? Int ?? 0))"
            if((dict?.value(forKey: "transactiontype") as! String) == "returned")
            {
                cell.fanCoins?.textColor = UIColor.red
            } else {
                cell.fanCoins?.textColor = UIColor.green
            }
            var msgtime = ""
            if let mili1 = dict?.value(forKey: "time")
            {
                
                let mili: Double = Double(mili1  as! String)!
                let myMilliseconds: UnixTime = UnixTime(mili/1000.0)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                //dateFormatter.dateStyle = .short
                
                let now = Date()
                let birthday: Date = myMilliseconds.dateFull as Date
                let calendar = Calendar.current
                
                let ageComponents = calendar.dateComponents([.hour], from: birthday, to: now)
                let timebefore = Int64(ageComponents.hour!)
                if(timebefore > 24){
                    msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                }
                else{
                    msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                    //dateFormatter.dateFormat = "HH:mm"
                    // msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                }
                cell.date?.text = "Date: \(msgtime)"
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(appDelegate().arrMyFanUpdatesTeams.count)
        return arrhistory.count
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell:TotalFCCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TotalFCCell
        
           let dict: NSDictionary? = arrhistory[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.activity?.frame.width)! , height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .left
            label.text = dict?.value(forKey: "transactionmsg") as! String
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            if((label.frame.height) > 17)
            {
                let height = (label.frame.height) + 35
                 return height
                
                // cell.mainViewConstraint.constant = CGFloat(height)
                //print("Height \(height).")
                //storyTableView?.rowHeight = CGFloat(height)
                
            }
            else
            {
                 return 40
              
                
            }
        }
        return 40
    }
    
}

