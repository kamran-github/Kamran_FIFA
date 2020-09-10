//
//  TotalCashEarnedViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 17/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//


import UIKit

class TotalCashEarnedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "totalearncell"
    @IBOutlet weak var totalfc: UILabel?
    var returnToOtherView:Bool = false
    var lastposition = 0
    @IBOutlet weak var notelable: UILabel?
    var strings:[String] = []
    @IBOutlet weak var butcontacts: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parent?.navigationItem.rightBarButtonItems = nil
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
        
        appDelegate().arrTotalEarn  = [AnyObject]()
        appDelegate().arrTotalEarnTrans  = [AnyObject]()
        appDelegate().isTotalEarnRefresh = true
        
        let notificationName = Notification.Name("_FetchedTotalEarn")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedTotalFC), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("_FetchedTotalEarnFail")
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
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        
        let leaderdetail = appDelegate().arrTotalEarn[0] as! NSDictionary
        //print(leaderdetail)
        
        totalfc?.text = "\(leaderdetail.value(forKey: "currency") as! String)\(leaderdetail.value(forKey: "totalearned") as! Double)"
        
        storyTableView?.reloadData()
        
        if(appDelegate().arrTotalEarnTrans.count <= 0)
        {
            
            notelable?.isHidden = false
            butcontacts?.isHidden = false
            storyTableView?.isHidden = true
            let bullet1 = "No cash earned so far."
            let bullet2 = "You can earn cash by earning FanCoins. To learn more tap on “Earn more FanCoins?”."
            //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
            // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
            
            strings = [bullet1, bullet2]
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
        UserDefaults.standard.setValue("Earn more FanCoins?", forKey: "terms")
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
            if(appDelegate().arrTotalEarnTrans.count == 0)
            {
                lastposition = 0
                if(appDelegate().isUserOnline)
                {
                    getTotalFC(lastposition)
                } else {
                    //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        // do stuff 3 seconds later
                        self.getTotalFC(self.lastposition)
                    }
                }
            }
        }
        
    }
    
   
    
    
    func getTotalFC(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getredeemhistory" as AnyObject
            
            if(lastindex == 0)
            {
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                appDelegate().isTotalEarnRefresh = true
            } else {
                appDelegate().isTotalEarnRefresh = false
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
                dictRequest["requestData"] = dictRequestData as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
                
                let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                //print(strFanUpdates)
                self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
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
        TransperentLoadingIndicatorView.hide()
    }
    
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            TotalCashEarnedViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return TotalCashEarnedViewController.realDelegate!;
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(appDelegate().arrTotalEarnTrans.count > 19)
        {
            
            let lastElement = appDelegate().arrTotalEarnTrans.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                lastposition = lastposition + 1
                getTotalFC(lastposition)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TotalCashEarnedCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TotalCashEarnedCell
        let dict: NSDictionary? = appDelegate().arrTotalEarnTrans[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            cell.activity?.text = "You Earned"
            cell.status?.text = "Status: \((dict?.value(forKey: "status") as! String).capitalized)"
            cell.fanCash?.text = "\(dict?.value(forKey: "currency") as! String)\(dict?.value(forKey: "amount") as! Double)"
            cell.paypalEmail?.text = "PayPal Email: \(dict?.value(forKey: "paypalemail") as! String)"
            var msgtime = ""
            if((dict?.value(forKey: "status") as! String) == "pending" || (dict?.value(forKey: "status") as! String) == "failed")
            {
                if let mili1 = dict?.value(forKey: "requesttime")
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
                }
                cell.date?.text = "Date: \(msgtime)"
            } else {
            if let mili1 = dict?.value(forKey: "payouttime")
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
        return appDelegate().arrTotalEarnTrans.count
    }
    
    
    
}

