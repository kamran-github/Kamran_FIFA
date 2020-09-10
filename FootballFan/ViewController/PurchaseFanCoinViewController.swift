//
//  PurchaseFanCoinViewController.swift
//  FootballFan
//
//  Created by Apple on 09/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class PurchaseFanCoinViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout {
    @IBOutlet weak var collectionView: UICollectionView?
    let reuseIdentifier = "FFCoinCell"
    var arrFfcoinProduct: [AnyObject] = []
     var baseamount: Double = 0
    var basecurrency: String = ""
     var coins: Int64 = 0
     @IBOutlet weak var AvilableCoins: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource  = self
        self.collectionView?.delegate = self
        setupCollectionView()
        registerNibs()
        let notificationName3 = Notification.Name("_inappPurchaseSuccess")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.inappPurchaseSuccess(notification: )), name: notificationName3, object: nil)
        let notificationName4 = Notification.Name("_inappPurchasefail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.inappPurchasefail(notification:)), name: notificationName4, object: nil)
        AvilableCoins?.text = appDelegate().formatNumber(appDelegate().GetvalueFromInsentiveConfigTable(Key: fcavailablecoin) as! Int)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getproducts(0)
    }
    func getproducts(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "getpackages" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            
            TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            
            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
               reqParams["device"] = "ios" as AnyObject?
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                if(myjid != nil){
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    reqParams["username"] = userUserJid as AnyObject?
                }
                else{
                    reqParams["username"] = "" as AnyObject
                }
                
                dictRequest["requestData"] = reqParams as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
               /* let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                var reqParams1 = [String: AnyObject]()
                reqParams1["request"] = strFanUpdates as AnyObject
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
                                                                          if(status1){DispatchQueue.main.async {
                                                                              TransperentLoadingIndicatorView.hide()
                                                                              self.arrFfcoinProduct = json["responseData"] as! [AnyObject]
                                                                              self.collectionView?.reloadData()
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                      
                                                                                      TransperentLoadingIndicatorView.hide()
                                                                                      
                                                                                      
                                                                                      
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                                                                    TransperentLoadingIndicatorView.hide()
                                                                    debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                        
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return arrFfcoinProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FFCoinCell
          let dict: NSDictionary? = arrFfcoinProduct[indexPath.row] as? NSDictionary
        var thumbLink: String = ""
        if let thumb = dict?.value(forKey: "image")
        {
            thumbLink = thumb as! String
        }
        //let selVideoPath: String = (jsonDataMessage?.value(forKey: "value") as? String)!
        cell.imageView.imageURL = thumbLink
//        cell.productTitle.text = dict?.value(forKey: "name") as? String
        cell.coins.text = "\(String(describing: dict?.value(forKey: "fancoins") as! Int64))"
         cell.price.text = "£\(dict?.value(forKey: "price") as! Double)"
        let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(inappAction(_:)))
        //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        cell.viewprice?.addGestureRecognizer(longPressGesture)
        cell.viewprice?.isUserInteractionEnabled = true
        
        return cell
    }
    @objc func inappAction(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        // print("Like Click")
        let touchPoint = longPressGestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: touchPoint) {
            if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = arrFfcoinProduct[indexPath.row] as? NSDictionary
                let packageid = dict?.value(forKey: "packageid") as! String
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
               InAppPurchase.sharedInstance.unlockProduct(packageid)
                baseamount = dict?.value(forKey: "price") as! Double
                basecurrency = dict?.value(forKey: "currency") as! String
                coins = dict?.value(forKey: "fancoins") as! Int64
            }
            else{
                alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            }
        }}
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        // Collection view attributes
        self.collectionView?.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.collectionView?.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView?.collectionViewLayout = layout
    }
    //** Number of Cells in the CollectionView */
    func registerNibs(){
        
        // attach the UI nib file for the ImageUICollectionViewCell to the collectionview
        let viewNib = UINib(nibName: "FFCoinCell", bundle: nil)
        collectionView?.register(viewNib, forCellWithReuseIdentifier: "FFCoinCell")
    }
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        
        return CGSize(width: 250, height: 303)
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    @objc func inappPurchaseSuccess(notification: NSNotification)
    {
        let orderid = (notification.userInfo?["index"] )as AnyObject
        //onlineusercount?.text = count as? String
        savepurchase(orderid)
    }
    @objc func inappPurchasefail(notification: NSNotification)
    {
        //let count = (notification.userInfo?["index"] )as! AnyObject
       // onlineusercount?.text = count as? String
        DispatchQueue.main.async {
            TransperentLoadingIndicatorView.hide()
        }
    }
    func savepurchase(_ orderid : AnyObject)  {
        if ClassReachability.isConnectedToNetwork() {
            var dictRequest = [String: AnyObject]()
            dictRequest["cmd"] = "savepurchase" as AnyObject
            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
            dictRequest["device"] = "ios" as AnyObject
            

            do {
                
                /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
                 let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
                 print(strInvited)*/
                //let login: String? = UserDefaults.standard.string(forKey: "userJID")
                //let arrReadUserJid = login?.components(separatedBy: "@")
                //let userReadUserJid = arrReadUserJid?[0]
                
                
                var reqParams = [String: AnyObject]()
                //reqParams["cmd"] = "getfanupdates" as AnyObject
                reqParams["transactiontype"] = "earned" as AnyObject?
                reqParams["transactionmsg"] = "You have purchased \(coins) FanCoins from In App Purchase." as AnyObject?
                 reqParams["fancoins"] = coins as AnyObject?
                 reqParams["activity"] = "inapppurchase" as AnyObject?
                reqParams["baseamount"] = baseamount as AnyObject?
                reqParams["basecurrency"] = basecurrency as AnyObject?
                reqParams["orderid"] = orderid as AnyObject?
                let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                if(myjid != nil){
                    let arrdUserJid = myjid?.components(separatedBy: "@")
                    let userUserJid = arrdUserJid?[0]
                    reqParams["username"] = userUserJid as AnyObject?
                }
                else{
                    reqParams["username"] = "" as AnyObject
                }
                
                dictRequest["requestData"] = reqParams as AnyObject
                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                //print(dictRequest)
              /*  let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
                let escapedString = strFanUpdates.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                //  print(escapedString!)
                // print(strFanUpdates)
                var reqParams1 = [String: AnyObject]()
                reqParams1["request"] = strFanUpdates as AnyObject
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
                                                                              DispatchQueue.main.async {
                                                                              TransperentLoadingIndicatorView.hide()
                                                                              let response: NSArray = json["responseData"]  as! NSArray
                                                                              let myProfileDict: NSDictionary = response[0] as! NSDictionary
                                                                              let totalcoins = myProfileDict.value(forKey: "totalcoins") as! Int
                                                                              
                                                                              let availablecoins = myProfileDict.value(forKey: "availablecoins") as! Int
                                                                              //print(response)
                                                                              self.appDelegate().AddCoin(fctotalcoin: totalcoins, fcavailablecoin: availablecoins)
                                                                              self.navigationController?.popViewController(animated: true)
                                                                              
                                                                              }
                                                                              
                                                                          }
                                                                          else{
                                                                              DispatchQueue.main.async
                                                                                  {
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                              }
                                                                              //Show Error
                                                                          }
                                                                      }
                                                                  case .failure(let error):
                                                                    debugPrint(error as Any)
                            break
                                                                      // error handling
                                                       
                                                                  }
                       
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }else {
            TransperentLoadingIndicatorView.hide()
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
   @IBAction func EarnCoinsClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
        print("EarnCoinsClick")
        UserDefaults.standard.setValue("Learn About FanCoins Rewards?", forKey: "terms")
        UserDefaults.standard.synchronize()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let myTeamsController : WebViewcontroller = storyBoard.instantiateViewController(withIdentifier: "webview") as! WebViewcontroller
        show(myTeamsController, sender: self)
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            PurchaseFanCoinViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return PurchaseFanCoinViewController.realDelegate!;
    }

}
