//
//  LeaderBoardViewController.swift
//  FootballFan
//
//  Created by Mayank Sharma on 14/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import UIKit

import Alamofire
class LeaderBoardViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var myLevel: UILabel?
    @IBOutlet weak var bronzeLevel: UILabel?
    @IBOutlet weak var silverLevel: UILabel?
    @IBOutlet weak var goldLevel: UILabel?
    @IBOutlet weak var platinumLevel: UILabel?
    @IBOutlet weak var diamondLevel: UILabel?
    @IBOutlet weak var currentRank: UILabel?
    @IBOutlet weak var todayCoins: UILabel?
    @IBOutlet weak var totalCoins: UILabel?
    @IBOutlet weak var cashEarned: UILabel?
    
    @IBOutlet weak var bronzeImage: UIImageView?
    @IBOutlet weak var silverImage: UIImageView?
    @IBOutlet weak var goldImage: UIImageView?
    @IBOutlet weak var platinumImage: UIImageView?
    @IBOutlet weak var diamondImage: UIImageView?
    
    @IBOutlet weak var earncoins: UIView?
    @IBOutlet weak var redeemcoins: UIView?
    @IBOutlet weak var todaysfancoins: UIView?
    @IBOutlet weak var totalfancoins: UIView?
    @IBOutlet weak var cashearn: UIView?
    @IBOutlet weak var rankClick: UIView?
     @IBOutlet weak var lavelview: UIView?
    @IBOutlet weak var BuyNow: UIButton?
     @IBOutlet weak var lavelhieghtConstraint: NSLayoutConstraint!
     @IBOutlet weak var RankhieghtConstraint: NSLayoutConstraint!
     @IBOutlet weak var FcHistoryhieghtConstraint: NSLayoutConstraint!
    var returnToOtherView:Bool = false
    var refreshTable: UIRefreshControl!
       @IBOutlet weak var scrollViewmain: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // parent?.navigationItem.rightBarButtonItems = nil
        
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
      //  let rightSearchBarButtonItem1:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(LeaderBoardViewController.refreshView))
        
        //let settingsImage   = UIImage(named: "refresh")!
       // let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.refreshView))
         //navigationItem.rightBarButtonItem = rightSearchBarButtonItem1
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        }
        appDelegate().arrLeaderBoard  = [AnyObject]()
        appDelegate().arrLeaderTopUsers  = [AnyObject]()
        
        let notificationName = Notification.Name("_FetchedLeaderBoard")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedLeaderBoard), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("_FetchedLeaderBoardFail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchedLeaderBoard), name: notificationName2, object: nil)
        
        let notificationNewlavel = Notification.Name("newlavel")
              // Register to receive notification
              NotificationCenter.default.addObserver(self, selector: #selector(self.lavelChange), name: notificationNewlavel, object: nil)
              
        
        let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EarnCoinsClick(_:)))
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        earncoins?.addGestureRecognizer(longPressGesture)
        earncoins?.isUserInteractionEnabled = true
        
        let longPressGesture1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RedeemCoinsClick(_:)))
        longPressGesture1.delegate = self as? UIGestureRecognizerDelegate
        redeemcoins?.addGestureRecognizer(longPressGesture1)
        redeemcoins?.isUserInteractionEnabled = true
        
        let longPressGesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TodaysCoinsClick(_:)))
        longPressGesture2.delegate = self as? UIGestureRecognizerDelegate
        todaysfancoins?.addGestureRecognizer(longPressGesture2)
        todaysfancoins?.isUserInteractionEnabled = true
        
        let longPressGesture3:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TotalCoinsClick(_:)))
        longPressGesture3.delegate = self as? UIGestureRecognizerDelegate
        totalfancoins?.addGestureRecognizer(longPressGesture3)
        totalfancoins?.isUserInteractionEnabled = true
        
        let longPressGesture4:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CashEarnClick(_:)))
        longPressGesture4.delegate = self as? UIGestureRecognizerDelegate
        cashearn?.addGestureRecognizer(longPressGesture4)
        cashearn?.isUserInteractionEnabled = true
        
        let longPressGesture5:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CurrentRankClick(_:)))
        longPressGesture5.delegate = self as? UIGestureRecognizerDelegate
        rankClick?.addGestureRecognizer(longPressGesture5)
        rankClick?.isUserInteractionEnabled = true
        refreshTable = UIRefreshControl()
                  refreshTable.attributedTitle = NSAttributedString(string: "")
           refreshTable.addTarget(self, action: #selector(self.refreshView), for: UIControl.Event.valueChanged)
                  
                  
                  scrollViewmain?.addSubview(refreshTable)
        
    }
    
    @objc func refreshView() {
        print("refreshView")
       getLeaderBoard(0)
      /*  if(appDelegate().isUserOnline)
        {
            getLeaderBoard(0)
        } else {
            //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // do stuff 3 seconds later
                self.getLeaderBoard(0)
            }
        }*/
    }
    
    
    @objc func EarnCoinsClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("EarnCoinsClick")
        UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
        UserDefaults.standard.synchronize()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewcontroller = storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewcontroller
        show(myTeamsController, sender: self)
    }
    
    @objc func CurrentRankClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("CurrentRankClick")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : TopFansViewController = storyBoard.instantiateViewController(withIdentifier: "topfans") as! TopFansViewController
        //appDelegate().isFromSettings = true
        show(myTeamsController, sender: self)
        //self.present(myTeamsController, animated: true, completion: nil)
        }
        else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    @objc func RedeemCoinsClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("RedeemCoinsClick")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let myTeamsController : RedeemViewController = storyBoard.instantiateViewController(withIdentifier: "redeem") as! RedeemViewController
            //appDelegate().isFromSettings = true
            show(myTeamsController, sender: self)
            //self.present(myTeamsController, animated: true, completion: nil)
        }
        else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    @objc func TodaysCoinsClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("TodaysCoinsClick")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : TodayFCViewController! = storyBoard.instantiateViewController(withIdentifier: "todayfc") as? TodayFCViewController
        appDelegate().isTotalFCRefresh = true
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    @objc func TotalCoinsClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("TotalCoinsClick")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : TotalFCViewController! = storyBoard.instantiateViewController(withIdentifier: "totalfc") as? TotalFCViewController
        appDelegate().isTotalFCRefresh = true
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    
    @objc func CashEarnClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("CashEarnClick")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : TotalCashEarnedViewController! = storyBoard.instantiateViewController(withIdentifier: "totalearn") as? TotalCashEarnedViewController
        appDelegate().isTotalEarnRefresh = true
        show(registerController, sender: self)
        }else{
            appDelegate().LoginwithModelPopUp()
        }
    }
    @objc func lavelChange()
      {
          DispatchQueue.main.async{
            let CurentLevel = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fccurrentlevel) as! String
            self.myLevel?.text = "My Level: \(CurentLevel as! String)"
        if(CurentLevel == "Bronze")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbronzeimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.bronzeImage?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.bronzeImage!)
                   }
               } else if(CurentLevel  == "Silver")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsilverimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.silverImage?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.silverImage!)
                   }
               } else if(CurentLevel == "Gold")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcgoldimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.goldImage?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.goldImage!)
                   }
               } else if(CurentLevel == "Platinum")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcplatinumimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.platinumImage?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.platinumImage!)
                   }
               } else if(CurentLevel == "Diamond")
               {
                let link = self.appDelegate().GetvalueFromInsentiveConfigTable(Key: fcdiamondimageh) as? String
                   
                   let fileManager = FileManager.default
                   
                if fileManager.fileExists(atPath: self.getFilePath(url: link!)) {
                       // print("file")
                    self.diamondImage?.image = UIImage(contentsOfFile: self.getFilePath(url: link!))
                   } else {
                    self.appDelegate().loadImageFromUrl(url: link!, view: self.diamondImage!)
                   }
               }
        }
    }
    @objc func fetchedLeaderBoard()
    {
        TransperentLoadingIndicatorView.hide()
        closeRefresh()
        
        let leaderdetail = appDelegate().arrLeaderBoard[0] as! NSDictionary
        //print(leaderdetail)
        
        myLevel?.text = "My Level: \(leaderdetail.value(forKey: "level") as! String)"
        currentRank?.text = "Current Rank: \(self.appDelegate().formatNumber(leaderdetail.value(forKey: "rank") as? Int ?? 0))"
        todayCoins?.text = "Today's FanCoins Rewards: \(self.appDelegate().formatNumber(leaderdetail.value(forKey: "todaycoins") as? Int ?? 0))"
        totalCoins?.text = "\(self.appDelegate().formatNumber(leaderdetail.value(forKey: "availablecoins") as? Int ?? 0))"
        cashEarned?.text = "Cash Earned: \(leaderdetail.value(forKey: "currency") as! String)\(leaderdetail.value(forKey: "totalearned") as! Double)"
        
        if((leaderdetail.value(forKey: "level") as! String) == "Bronze")
        {
            let link = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbronzeimageh) as? String
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: getFilePath(url: link!)) {
                // print("file")
                bronzeImage?.image = UIImage(contentsOfFile: getFilePath(url: link!))
            } else {
                appDelegate().loadImageFromUrl(url: link!, view: bronzeImage!)
            }
        } else if((leaderdetail.value(forKey: "level") as! String) == "Silver")
        {
            let link = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsilverimageh) as? String
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: getFilePath(url: link!)) {
                // print("file")
                silverImage?.image = UIImage(contentsOfFile: getFilePath(url: link!))
            } else {
                appDelegate().loadImageFromUrl(url: link!, view: silverImage!)
            }
        } else if((leaderdetail.value(forKey: "level") as! String) == "Gold")
        {
            let link = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcgoldimageh) as? String
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: getFilePath(url: link!)) {
                // print("file")
                goldImage?.image = UIImage(contentsOfFile: getFilePath(url: link!))
            } else {
                appDelegate().loadImageFromUrl(url: link!, view: goldImage!)
            }
        } else if((leaderdetail.value(forKey: "level") as! String) == "Platinum")
        {
            let link = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcplatinumimageh) as? String
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: getFilePath(url: link!)) {
                // print("file")
                platinumImage?.image = UIImage(contentsOfFile: getFilePath(url: link!))
            } else {
                appDelegate().loadImageFromUrl(url: link!, view: platinumImage!)
            }
        } else if((leaderdetail.value(forKey: "level") as! String) == "Diamond")
        {
            let link = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcdiamondimageh) as? String
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: getFilePath(url: link!)) {
                // print("file")
                diamondImage?.image = UIImage(contentsOfFile: getFilePath(url: link!))
            } else {
                appDelegate().loadImageFromUrl(url: link!, view: diamondImage!)
            }
        }
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         /* if(returnToOtherView){
            getLeaderBoard(lastposition)
        } else { */
           // if(appDelegate().arrLeaderBoard.count == 0)
           // {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            BuyNow?.setTitle("Buy FanCoins", for: .normal)
             BuyNow?.isHidden  = true
            getLeaderBoard(0)
              /* if(appDelegate().isUserOnline)
                {
                    getLeaderBoard(0)
                } else {
                   // LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        // do stuff 3 seconds later
                        self.getLeaderBoard(0)
                    }
                }*/
            scrollViewmain.isScrollEnabled = true
            scrollViewmain.alwaysBounceVertical = true
        }else{
             myLevel?.text = "My Level: No Level"
             currentRank?.text = "Current Rank: 0"
            BuyNow?.isHidden  = false
            BuyNow?.setTitle("Sign In", for: .normal)
            lavelhieghtConstraint.constant = 0
            RankhieghtConstraint.constant = 0
            FcHistoryhieghtConstraint.constant = 0
            totalfancoins?.isHidden = true
            rankClick?.isHidden = true
            lavelview?.isHidden = true
        }
            //}
        //}
        circleImages()
      setData()
        if(login == nil){
        appDelegate().pageafterlogin = "leader"
        }
    }
    
    func circleImages()
    {
        bronzeImage?.layer.masksToBounds = true;
        bronzeImage?.layer.borderWidth = 1.0
        bronzeImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        bronzeImage?.layer.cornerRadius = 20.0
        
        silverImage?.layer.masksToBounds = true;
        silverImage?.layer.borderWidth = 1.0
        silverImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        silverImage?.layer.cornerRadius = 20.0
        
        goldImage?.layer.masksToBounds = true;
        goldImage?.layer.borderWidth = 1.0
        goldImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        goldImage?.layer.cornerRadius = 20.0
        
        platinumImage?.layer.masksToBounds = true;
        platinumImage?.layer.borderWidth = 1.0
        platinumImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        platinumImage?.layer.cornerRadius = 20.0
        
        diamondImage?.layer.masksToBounds = true;
        diamondImage?.layer.borderWidth = 1.0
        diamondImage?.layer.borderColor = UIColor.init(hex: "9a9a9a").cgColor
        diamondImage?.layer.cornerRadius = 20.0
    }
    
    func setData()
    {
        bronzeLevel?.text = "\(self.appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbronzeth) as? Int ?? 0))"
        silverLevel?.text = "\(self.appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsilverth) as? Int ?? 0))"
        goldLevel?.text = "\(self.appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcgoldth) as? Int ?? 0))"
        platinumLevel?.text = "\(self.appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcplatinumth) as? Int ?? 0 ))"
        diamondLevel?.text = "\(self.appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcdiamondth) as? Int ?? 0))"
        
        let bronzeLink = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcbronzeimage) as? String
        let silverLink = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcsilverimage) as? String
        let goldLink = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcgoldimage) as? String
        let platinumLink = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcplatinumimage) as? String
        let diamondLink = appDelegate().GetvalueFromInsentiveConfigTable(Key: fcdiamondimage) as? String
        
        let fileManager = FileManager.default
        if(bronzeLink != nil){
            if fileManager.fileExists(atPath: getFilePath(url: bronzeLink!)) {
                // print("file")
                bronzeImage?.image = UIImage(contentsOfFile: getFilePath(url: bronzeLink!))
            } else {
                appDelegate().loadImageFromUrl(url: bronzeLink!, view: bronzeImage!)
            }
        }else{
            appDelegate().loadImageFromUrl(url: DbronzeLink, view: bronzeImage!)
        }
        if(silverLink != nil){
            if fileManager.fileExists(atPath: getFilePath(url: silverLink!)) {
                // print("file")
                silverImage?.image = UIImage(contentsOfFile: getFilePath(url: silverLink!))
            } else {
                appDelegate().loadImageFromUrl(url: silverLink!, view: silverImage!)
            }
        }else{
            appDelegate().loadImageFromUrl(url: DsilverLink, view: bronzeImage!)
        }
        if(goldLink != nil){
            if fileManager.fileExists(atPath: getFilePath(url: goldLink!)) {
                // print("file")
                goldImage?.image = UIImage(contentsOfFile: getFilePath(url: goldLink!))
            } else {
                appDelegate().loadImageFromUrl(url: goldLink!, view: goldImage!)
            }
        }else{
            appDelegate().loadImageFromUrl(url: DgoldLink, view: bronzeImage!)
        }
        if(platinumLink != nil){
            if fileManager.fileExists(atPath: getFilePath(url: platinumLink!)) {
                // print("file")
                platinumImage?.image = UIImage(contentsOfFile: getFilePath(url: platinumLink!))
            } else {
                appDelegate().loadImageFromUrl(url: platinumLink!, view: platinumImage!)
            }
        }else{
            appDelegate().loadImageFromUrl(url: DplatinumLink, view: bronzeImage!)
        }
        if(diamondLink != nil){
            if fileManager.fileExists(atPath: getFilePath(url: diamondLink!)) {
                // print("file")
                diamondImage?.image = UIImage(contentsOfFile: getFilePath(url: diamondLink!))
            } else {
                appDelegate().loadImageFromUrl(url: diamondLink!, view: diamondImage!)
            }
        }else{
            appDelegate().loadImageFromUrl(url: DdiamondLink, view: bronzeImage!)
        }
    }
    @IBAction func buyAction(){
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
               if(login != nil){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : PurchaseFanCoinViewController! = storyBoard.instantiateViewController(withIdentifier: "purchaseFC") as? PurchaseFanCoinViewController
        self.returnToOtherView = true
        self.show(registerController, sender: self)
        }else{
                  appDelegate().LoginwithModelPopUp()
              }
    }
    func getFilePath(url : String) -> String
    {
        let arrReadselVideoPath = url.components(separatedBy: "/")
        let imageId = arrReadselVideoPath.last
        let arrReadimageId = imageId?.components(separatedBy: ".")
        //let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".png")
        return paths
    }
    
    func getLeaderBoard(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getleaderboard" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            
               // LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading")
             //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
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
              /*
                let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
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
                                                                                self.appDelegate().arrLeaderBoard  = [AnyObject]()
                                                                                self.appDelegate().arrLeaderTopUsers  = [AnyObject]()
                                                                                //arrFanUpdatesTeams
                                                                                self.appDelegate().arrLeaderBoard = response  as [AnyObject]
                                                                                self.appDelegate().arrLeaderTopUsers = self.appDelegate().arrLeaderBoard[0].value(forKey: "topusers") as! [AnyObject]
                                                                                
                                                                                let notificationName = Notification.Name("_FetchedLeaderBoard")
                                                                                NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                if(self.refreshTable.isRefreshing)
                                                                                {
                                                                                 self.refreshTable.endRefreshing()
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                        else{
                                                                            DispatchQueue.main.async
                                                                                {
                                                                                   // TransperentLoadingIndicatorView.hide()
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
        if(self.refreshTable.isRefreshing)
                                               {
                                                self.refreshTable.endRefreshing()
                                               }
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
            LeaderBoardViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return LeaderBoardViewController.realDelegate!;
    }
    
    
   
}

