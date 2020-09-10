//
//  TotalFCViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 17/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

import Alamofire
class TotalFCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var storyTableView: UITableView?
    let cellReuseIdentifier = "totalfccell"
    @IBOutlet weak var totalfc: UILabel?
    @IBOutlet weak var totalrc: UILabel?
    @IBOutlet weak var availablefc: UILabel?
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
        
        appDelegate().arrTotalFC  = [AnyObject]()
        appDelegate().arrTotalFCTrans  = [AnyObject]()
        appDelegate().isTotalFCRefresh = true
        
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
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        
        
        let leaderdetail = appDelegate().arrTotalFC[0] as! NSDictionary
        //print(leaderdetail)
        
        totalfc?.text = "\(self.appDelegate().formatNumber(leaderdetail.value(forKey: "totalcoins") as? Int ?? 0))"
        totalrc?.text = "\(self.appDelegate().formatNumber(leaderdetail.value(forKey: "redeemcoins") as? Int ?? 0))"
        availablefc?.text = "\(self.appDelegate().formatNumber(leaderdetail.value(forKey: "availablecoins") as? Int ?? 0))"
       
        storyTableView?.reloadData()
        
        
        if(appDelegate().arrTotalFCTrans.count <= 0)
        {
        
            notelable?.isHidden = false
            butcontacts?.isHidden = false
            storyTableView?.isHidden = true
            let bullet1 = "No FanCoins rewards collected so far."
            let bullet2 = "To learn more tap on “Learn About FanCoins Rewards?”."
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
         if(appDelegate().arrTotalFCTrans.count == 0)
         {
            lastposition = 0
            self.getTotalFC(self.lastposition)
         
        }
        }
        
    }
    
    
    
    func getTotalFC(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "gettransactionhistory" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            if(lastindex == 0)
            {
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                appDelegate().isTotalFCRefresh = true
            } else {
                appDelegate().isTotalFCRefresh = false
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
                dictRequestData["type"] = "total" as AnyObject
                dictRequest["requestData"] = dictRequestData as AnyObject
             
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
                                                                                  
                                                                                  self.appDelegate().arrTotalFC = response  as [AnyObject]
                                                                                  
                                                                                  if(self.appDelegate().isTotalFCRefresh)
                                                                                  {
                                                                                      self.appDelegate().arrTotalFCTrans = self.appDelegate().arrTotalFC[0].value(forKey: "fancoins") as! [AnyObject]
                                                                                  } else  {
                                                                                      self.appDelegate().arrTotalFCTrans += self.appDelegate().arrTotalFC[0].value(forKey: "fancoins") as! [AnyObject]
                                                                                  }
                                                                                  
                                                                                  let notificationName = Notification.Name("_FetchedTotalFC")
                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                  
                                                                                  
                                                                                  
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                      TransperentLoadingIndicatorView.hide()
                                                                                      self.closeRefresh()
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                                                                    TransperentLoadingIndicatorView.hide()
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
            TotalFCViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return TotalFCViewController.realDelegate!;
    }
    
    
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     if(appDelegate().arrTotalFCTrans.count > 19)
     {
     
     let lastElement = appDelegate().arrTotalFCTrans.count - 1
     if indexPath.row == lastElement {
     // handle your logic here to get more items, add it to dataSource and reload tableview
        lastposition = lastposition + 1
        getTotalFC(lastposition)
     }
     }
     }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TotalFCCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TotalFCCell
        let dict: NSDictionary? = appDelegate().arrTotalFCTrans[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            if((dict?.value(forKey: "activity") as! String) == "signup")
            {
                cell.activity?.text = "Sign Up"
            } else if((dict?.value(forKey: "activity") as! String) == "redeem")
            {
                cell.activity?.text = "Redeemed"
            } else if((dict?.value(forKey: "activity") as! String) == "activities")
            {
                cell.activity?.text = "\(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcactivityth) as! Int) App Activities"
                
            } else if((dict?.value(forKey: "activity") as! String) == "appopen")
            {
                cell.activity?.text = "Daily App Usage"
            } else if((dict?.value(forKey: "activity") as! String) == "banterjoin")
            {
                cell.activity?.text = "\(self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbanterth))  Fans in Banter Room"
            } else if((dict?.value(forKey: "activity") as! String) == "bonus")
            {
                cell.activity?.text = "Bonus"
            }
            else if((dict?.value(forKey: "activity") as! String) == "referral")
            {
                if((dict?.value(forKey: "isreferral") as! String) == "yes"){
                    cell.activity?.text = "Referral Bonus from \(String(describing: appDelegate().ExistingContact(username: dict?.value(forKey: "referraluser") as! String)!))"
                }
                else{
                    cell.activity?.text = "Referral Bonus"
                }
               // cell.activity?.text = "Referral"
            }
            else if((dict?.value(forKey: "activity") as! String) == "merchandise")
            {
                cell.activity?.text = "Shopping Bonus"
            }
            else if((dict?.value(forKey: "activity") as! String) == "inapppurchase")
            {
                cell.activity?.text = "FanCoins Purchased through In App Purchase"
            }
            else if((dict?.value(forKey: "activity") as! String) == "ticket")
            {
                cell.activity?.text = dict?.value(forKey: "message") as? String
            }
            else if((dict?.value(forKey: "activity") as! String) == "fanstory")
            {
                cell.activity?.text = "FanStory"//dict?.value(forKey: "message")as! String
            }
            let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.activity?.frame.width)! , height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .left
            label.text = cell.activity?.text //dict?.value(forKey: "transactionmsg") as! String
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            if((label.frame.height) > 17)
            {
               // let height = (label.frame.height) + 31
                
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
            cell.fanCoins?.text = "\(self.appDelegate().formatNumber(dict?.value(forKey: "fancoins") as? Int ?? 0))"
            
            if((dict?.value(forKey: "transactiontype") as! String) == "redeem")
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
                
               
                //let birthday: Date = myMilliseconds.dateFull as Date
                //let calendar = Calendar.current
                let timeNow = Date()
                let ourdate = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                let currentdate = dateFormatter.string(from: timeNow)
                if (ourdate == currentdate) {
                    cell.date?.text = "Date: Today"
                }
                else{
                   
                        msgtime = dateFormatter.string(from: myMilliseconds.dateFull as Date)
                    
                    cell.date?.text = "Date: \(msgtime)"
                }
               
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
        return appDelegate().arrTotalFCTrans.count
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell:TotalFCCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TotalFCCell
        
        let dict: NSDictionary? = appDelegate().arrTotalFCTrans[indexPath.row] as? NSDictionary
        if(dict != nil)
        {
            if((dict?.value(forKey: "activity") as! String) == "signup")
            {
                cell.activity?.text = "Sign Up"
            } else if((dict?.value(forKey: "activity") as! String) == "redeem")
            {
                cell.activity?.text = "Redeemed"
            } else if((dict?.value(forKey: "activity") as! String) == "activities")
            {
                cell.activity?.text = "\(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcactivityth) as! Int) App Activities"
                
            } else if((dict?.value(forKey: "activity") as! String) == "appopen")
            {
                cell.activity?.text = "Daily App Usage"
            } else if((dict?.value(forKey: "activity") as! String) == "banterjoin")
            {
                cell.activity?.text = "\(self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbanterth))  Fans in Banter Room"
            } else if((dict?.value(forKey: "activity") as! String) == "bonus")
            {
                cell.activity?.text = "Bonus"
            }
            else if((dict?.value(forKey: "activity") as! String) == "referral")
            {
                if((dict?.value(forKey: "isreferral") as! String) == "yes"){
                    cell.activity?.text = "Referral Bonus from \(String(describing: appDelegate().ExistingContact(username: dict?.value(forKey: "referraluser") as! String)!))"
                }
                else{
                    cell.activity?.text = "Referral Bonus"
                }
                // cell.activity?.text = "Referral"
            }
            else if((dict?.value(forKey: "activity") as! String) == "merchandise")
            {
                cell.activity?.text = "Shopping Bonus"
            }
            else if((dict?.value(forKey: "activity") as! String) == "inapppurchase")
            {
                cell.activity?.text = "FanCoins Purchased through In App Purchase"
            }
            else if((dict?.value(forKey: "activity") as! String) == "ticket")
            {
                cell.activity?.text = dict?.value(forKey: "message") as? String
            }
            let label = UILabel(frame: CGRect(x: 0.0, y: 0, width: (cell.activity?.frame.width)! , height: CGFloat.greatestFiniteMagnitude))
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .left
            label.text = cell.activity?.text//dict?.value(forKey: "transactionmsg") as! String
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
