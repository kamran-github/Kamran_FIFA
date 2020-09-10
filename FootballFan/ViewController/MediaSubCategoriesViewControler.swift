//
//  MediaSubCategoriesViewControler.swift
//  FootballFan
//
//  Created by Apple on 25/02/2020.
//  Copyright © 2020 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MediaSubCategoriesViewControler: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    @IBOutlet weak var collectionView: UICollectionView!
     var arrsubcategories: [AnyObject] = []
      lazy var lazyImage:LazyImage = LazyImage()
      var lastposition = 0
      @IBOutlet weak var Buttomloader: UIView?
     @IBOutlet weak var tableviewButtomConstraint: NSLayoutConstraint!
     var cid: Int64 = 0
     var maintitel: String = "Sub Categories"
    @IBOutlet weak var notelable: UILabel?
    var isPageRefresh: Bool = false
    var returntofilter:Bool = false
    var strings:[String] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.collectionView.dataSource  = self
        self.collectionView.delegate = self
        setupCollectionView()
        registerNibs()
        self.navigationItem.title = maintitel//"Sub Categories"
        getsubcategories(0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate().arrfilter = []
         appDelegate().arrtempfilter = []
        
       // self.parent?.title = "News"
        self.navigationItem.title = maintitel//"Sub Categories"
        
    }
    
    //MARK: - CollectionView UI Setup
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        // Collection view attributes
        self.collectionView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView.collectionViewLayout = layout
    }
    //** Number of Cells in the CollectionView */
    func registerNibs(){
        
        // attach the UI nib file for the ImageUICollectionViewCell to the collectionview
        let viewNib = UINib(nibName: "MediaSubCategroies", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "mediasubcell")
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MediaSubCategoriesViewControler.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MediaSubCategoriesViewControler.realDelegate!;
    }
    func getsubcategories(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            
            var dictRequest = [String: AnyObject]()
              dictRequest["cmd"] = "getmediacategories" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                   
                  Clslogging.logdebug(State: "getMediaCategories start")
              
                  
                
                  var reqParams2 = [String: AnyObject]()
                  
                  reqParams2["cid"] = cid as AnyObject
                 
                  
                  
                  dictRequest["requestData"] = reqParams2 as AnyObject
                   
                  AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                    headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                      // 2
                      .responseJSON { response in
                        switch response.result {
                                                                case .success(let value):
                                                                    if let json = value as? [String: Any] {
                                                                                                          let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                        Clslogging.loginfo(State: "getMediaCategories for latest records", userinfo: json as [String : AnyObject])
                                                                        // self.finishSyncContacts()
                                                                        //print(" status:", status1)
                                                                        if(status1){DispatchQueue.main.async {
                                                                            let data: NSArray = json["responseData"]  as! NSArray
                                                                            
                                                                            
                                                                                                                                                                self.Buttomloader?.isHidden = true
                                                                                                                                                                  self.tableviewButtomConstraint.constant = 10
                                                                                                                                                                  
                                                                                                                                                                  if(data.count > 0)
                                                                                                                                                                  {
                                                                                                                                                                  if(self.isPageRefresh)
                                                                                                                                                                  {
                                                                                                                                                                  
                                                                                                                                                                      self.arrsubcategories = data  as [AnyObject]
                                                                                                                                                                  }
                                                                                                                                                                  else
                                                                                                                                                                  {
                                                                                                                                                                      self.arrsubcategories += data  as [AnyObject]
                                                                                                                                                                  }
                                                                                                                                                                //  self.arrsubcategories = jsonData?.value(forKey: "data") as! NSArray
                                                                                                                                                                  self.collectionView.reloadData()
                                                                                                                                                                  }
                                                                                                                                                                  else{
                                                                                                                                                                      self.tableviewButtomConstraint.constant = 10
                                                                                                                                                                      self.Buttomloader?.isHidden = true
                                                                                                                                                                     // self.collectionView.reloadData()
                                                                                                                                                                  }
                                                                                                                                                                  if(self.arrsubcategories.count == 0){
                                                                                                                                                                      self.notelable?.isHidden = false
                                                                                                                                                                      self.collectionView.isHidden = true
                                                                                                                                                                      self.Nodatamsg()
                                                                                                                                                                  }
                                                                                                                                                                  else{
                                                                                                                                                                      self.notelable?.isHidden = true
                                                                                                                                                                      self.collectionView.isHidden = false
                                                                                                                                                                  }
                                                                            }
                                                                            
                                                                        }
                                                                        else{
                                                                            DispatchQueue.main.async
                                                                                {
                                                                                  
                                                                                  //TransperentLoadingIndicatorView.hide()
                                                                                   self.tableviewButtomConstraint.constant = 10
                                                                                  self.Buttomloader?.isHidden = true
                                                                                  self.collectionView.reloadData()
                                                                                  if(self.arrsubcategories.count == 0){
                                                                                      self.notelable?.isHidden = false
                                                                                      self.collectionView.isHidden = true
                                                                                      self.Nodatamsg()
                                                                                  }
                                                                                  else{
                                                                                      self.notelable?.isHidden = true
                                                                                      self.collectionView.isHidden = false
                                                                                  }
                                                                                    
                                                                            }
                                                                            //Show Error
                                                                        }
                                                                    }
                                                                case .failure(let error):
                            debugPrint(error)
                            let errorinfo:[String: AnyObject] = ["error": error as AnyObject]
                            Clslogging.logerror(State: "getMediaCategories Error", userinfo: errorinfo)
                            break
                                                                    // error handling
                                                     
                                                                }
                          //print(response.result.value)
                        
                  }
                  
                  Clslogging.logdebug(State: "getMediaCategories End")
            
            
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrsubcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    
    
    //** Create a basic CollectionView Cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediasubcell", for: indexPath as IndexPath) as! MediaSubCategoriesCell
        
        let dic = arrsubcategories[indexPath.row] as AnyObject
        //cell.categoryTitle.text = dic.value(forKey: "CategoryName") as? String
        
        if(dic.value(forKey: "CategoryImage") != nil)
        {
            let avatar:String = (dic.value(forKey: "CategoryImage") as? String)!
            if(!avatar.isEmpty)
            {
                self.lazyImage.show(imageView:cell.imageView!, url:avatar, defaultImage: "img_thumb")
                
            }
        }
        else{
            cell.imageView?.image = UIImage(named: "img_thumb")
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        appDelegate().arrfilter = []
        appDelegate().arrtempfilter = []
        let dic = arrsubcategories[indexPath.row] as AnyObject
        let isend = dic.value(forKey: "IsEnd") as! Int64
        if(isend == 1){
            //Code by Ravi to remember and temp
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
             let mediaController : MediaListViewController = storyBoard.instantiateViewController(withIdentifier: "MediaList") as! MediaListViewController
            mediaController.cid = dic.value(forKey: "CategoryID") as! Int64
            mediaController.returnToOtherView = true
            mediaController.maintitle = dic.value(forKey: "CategoryName") as! String
             self.show(mediaController, sender: self)
            /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settingsController : MerchantProductsViewControler = storyBoard.instantiateViewController(withIdentifier: "MerchantProducts") as! MerchantProductsViewControler
            settingsController.cid = dic.value(forKey: "CategoryID") as! Int64
             settingsController.maintitel = dic.value(forKey: "CategoryName") as! String
            show(settingsController, sender: self)*/
            
            
        }
        else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settingsController : MediaSubCategoriesViewControler = storyBoard.instantiateViewController(withIdentifier: "MediaSubCategories") as! MediaSubCategoriesViewControler
            settingsController.cid = dic.value(forKey: "CategoryID") as! Int64
            settingsController.maintitel = (dic.value(forKey: "CategoryName") as? String)!
            show(settingsController, sender: self)
        }
        
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        
        return CGSize(width: 250, height: 300)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        let bounds: CGRect = UIScreen.main.bounds
        //var width:CGFloat = bounds.size.width
        let height:CGFloat = bounds.size.height
        print(height)
        if(height == 812){//xr
             return CGSize(width: 250, height: 300)//
        }
        else if(height == 667){
             return CGSize(width: 255, height: 306)//255x380
        }
        else if(height == 736){
            return CGSize(width: 257, height: 308) //257x385
        }
        return CGSize(width: 250, height: 300) //250x375
    }
    
    
    
    
    
    
    
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    func Nodatamsg()  {
        self.notelable?.isHidden = false
        
        self.collectionView?.isHidden = true
        let bullet1 = "No categories found"
        let bullet2 = ""
        //  let bullet5 = "Fans can share messages, pictures or videos with other like-minded fans in a Banter Room."
        // let bullet6 = "Most importantly, enjoy banters in a good sportsman spirit and keep your Banter Room funny."
        
        self.strings = [bullet1, bullet2]
        // let boldText  = "Quick Information \n"
        let attributesDictionary = [kCTForegroundColorAttributeName : self.notelable?.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as Any as? [NSAttributedString.Key : Any])
        //  let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        //let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
        //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: boldString)
        
        //fullAttributedString.append(boldString)
        for string: String in self.strings
        {
            //let _: String = ""
            let formattedString: String = "\(string)\n\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            
            let paragraphStyle = self.createParagraphAttribute()
            attributedString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            
            let range1 = (formattedString as NSString).range(of: "Invite")
            attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range1)
            
            let range2 = (formattedString as NSString).range(of: "Settings")
            attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: UIColor.init(hex: "197DF6"), range: range2)
            
            fullAttributedString.append(attributedString)
        }
        
        
        self.notelable?.attributedText = fullAttributedString
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
    
    
}
