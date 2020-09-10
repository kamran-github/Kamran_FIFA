//
//  MerchantSubCategoriesViewControler.swift
//  FootballFan
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class MerchantSubCategoriesViewControler: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
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
        let viewNib = UINib(nibName: "MerchantSubCategroies", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "merchantsubcell")
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MerchantSubCategoriesViewControler.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MerchantSubCategoriesViewControler.realDelegate!;
    }
    func getsubcategories(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading")
            // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getsubcategories" as AnyObject
            reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
            reqParams["cid"] =   cid as AnyObject//String(describing:  lastindex)
            isPageRefresh = true
            //reqParams["username"] = myjidtrim as AnyObject
            
            let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
            if(myjid != nil){
                let arrdUserJid = myjid?.components(separatedBy: "@")
                let userUserJid = arrdUserJid?[0]
                reqParams["username"] = userUserJid as AnyObject?
            }
            else{
                reqParams["username"] = "" as AnyObject
            }
            
            
            // request.httpBody = createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
            request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if String(data: data, encoding: String.Encoding.utf8) != nil {
                        //print(stringData) //JSONSerialization
                        
                        
                        
                        //print(time)
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                            
                            let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                            
                            if(isSuccess)
                            {DispatchQueue.main.async {
                                // let response: NSArray = jsonData?.value(forKey: "responseData") as! NSArray
                                //let dic: NSDictionary = response[0] as! NSDictionary
                                //print(response)
                                //TransperentLoadingIndicatorView.hide()
                                self.Buttomloader?.isHidden = true
                                self.tableviewButtomConstraint.constant = 10
                                let data = jsonData?.value(forKey: "data") as! NSArray
                                if(data.count > 0)
                                {
                                if(self.isPageRefresh)
                                {
                                    //arrFanUpdatesTeams
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
                            else
                            { DispatchQueue.main.async
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
                        } catch let error as NSError {
                            print(error)
                            //Show Error
                        }
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async
                                                   {
                    //TransperentLoadingIndicatorView.hide()
                    //Show Error
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
            })
            task.resume()
            
            
            /*var dictRequest = [String: AnyObject]()
             dictRequest["cmd"] = "getnews" as AnyObject
             
             if(lastindex == 0)
             {
             LoadingIndicatorView.show(self.view, loadingText: "Getting latest News for you")
             appDelegate().isNewsPageRefresh = true
             } else
             {
             appDelegate().isNewsPageRefresh = false
             }
             do {
             //Creating Request Data
             var dictRequestData = [String: AnyObject]()
             let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
             let arrdUserJid = myjid?.components(separatedBy: "@")
             let userUserJid = arrdUserJid?[0]
             
             let myjidtrim: String? = userUserJid
             dictRequestData["version"] = 1 as AnyObject
             dictRequestData["lastindex"] = lastindex as AnyObject
             dictRequestData["username"] = myjidtrim as AnyObject
             dictRequestData["catid"] = catid as AnyObject
             dictRequest["requestData"] = dictRequestData as AnyObject
             //dictRequest.setValue(dictMobiles, forKey: "requestData")
             //print(dictRequest)
             
             let dataFanUpdates = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
             let strFanUpdates = NSString(data: dataFanUpdates, encoding: String.Encoding.utf8.rawValue)! as String
             //print(strFanUpdates)
             self.appDelegate().sendRequestToAPI(strRequestDict: strFanUpdates)
             } catch {
             print(error.localizedDescription)
             }*/
        } else {
            alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrsubcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       /* if(arrsubcategories.count > 19)
        {
            
            let lastElement = arrsubcategories.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                Buttomloader?.isHidden = false
                tableviewButtomConstraint.constant = 35
                lastposition = lastposition + 1
                getsubcategories(lastposition)
                
            }
        }*/
    }
    
    
    //** Create a basic CollectionView Cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /*if(indexPath.row >= 4)
         {
         //Slider?.isHidden = true
         SliderTopConstraint.constant = CGFloat(-200.0)
         } else if(indexPath.row <= 3) {
         //Slider?.isHidden = false
         SliderTopConstraint.constant = CGFloat(0.0)
         }
         */
        // Create the cell and return the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchantsubcell", for: indexPath as IndexPath) as! MerchantSubCategoriesCell
        
        let dic = arrsubcategories[indexPath.row] as AnyObject
        cell.categoryTitle.text = dic.value(forKey: "CategoryName") as? String
        
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
        
        // Add image to cell
        
        
        
        /* if selectedCell.contains(indexPath) {
         cell.contentView.backgroundColor = .red
         }
         else {
         cell.contentView.backgroundColor = .white
         } */
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let url = model.images[indexPath.item]
        //print(indexPath.row)
        // let cell = collectionView.cellForItem(at: indexPath as IndexPath)
        /*  selectedCell.append(indexPath)
         
         if(collectionView == self.collectionViewTab)
         {
         selectedIndex = indexPath.row
         let dic = data[indexPath.row]
         catid = Int(dic.cid)
         //print(catid)
         lastposition = 0
         getNews(lastposition)
         self.collectionViewTab.reloadData()
         }*/
        //cell?.contentView.backgroundColor = .red
        appDelegate().arrfilter = []
        appDelegate().arrtempfilter = []
        let dic = arrsubcategories[indexPath.row] as AnyObject
        let isend = dic.value(forKey: "IsEnd") as! Int64
        if(isend == 1){
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settingsController : MerchantProductsViewControler = storyBoard.instantiateViewController(withIdentifier: "MerchantProducts") as! MerchantProductsViewControler
            settingsController.cid = dic.value(forKey: "CategoryID") as! Int64
             settingsController.maintitel = dic.value(forKey: "CategoryName") as! String
            show(settingsController, sender: self)
        }
        else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settingsController : MerchantSubCategoriesViewControler = storyBoard.instantiateViewController(withIdentifier: "MerchantSubCategories") as! MerchantSubCategoriesViewControler
            settingsController.cid = dic.value(forKey: "CategoryID") as! Int64
            settingsController.maintitel = (dic.value(forKey: "CategoryName") as? String)!
            show(settingsController, sender: self)
        }
        /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : MerchantSubCategoriesViewControler = storyBoard.instantiateViewController(withIdentifier: "MerchantSubCategories") as! MerchantSubCategoriesViewControler
        settingsController.cid = dic.value(forKey: "CategoryID") as! Int64
           settingsController.title = dic.value(forKey: "CategoryName") as! String
        show(settingsController, sender: self)*/
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)!
        /* if selectedCell.contains(indexPath) {
         selectedCell.remove(at: selectedCell.index(of: indexPath)!)
         cell.contentView.backgroundColor = .white
         } */
    }
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        
        return CGSize(width: 250, height: 300)
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
