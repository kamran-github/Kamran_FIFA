//
//  MerchantProductsViewControler.swift
//  FootballFan
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class MerchantProductsViewControler: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var arrproducts: [AnyObject] = []
    lazy var lazyImage:LazyImage = LazyImage()
    var lastposition = 0
    @IBOutlet weak var Buttomloader: UIView?
     @IBOutlet weak var notelable: UILabel?
     @IBOutlet weak var produectcountlbl: UILabel?
    @IBOutlet weak var tableviewButtomConstraint: NSLayoutConstraint!
    var cid: Int64 = 0
     var refreshTable: UIRefreshControl!
     var isPageRefresh: Bool = false
    var maintitel: String = ""
     var returntofilter:Bool = false
     var strings:[String] = []
     var Apicalling:Bool = false
        var arrshort: [AnyObject] = []
    @IBOutlet weak var storySearchBar: UISearchBar?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.collectionView.dataSource  = self
        self.collectionView.delegate = self
        storySearchBar?.delegate = self
        setupCollectionView()
        registerNibs()
        self.navigationItem.title = maintitel//"Product"
      
        refreshTable = UIRefreshControl()
        refreshTable.attributedTitle = NSAttributedString(string: "")
        refreshTable.addTarget(self, action: #selector(refreshNews(_:)), for: UIControl.Event.valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshTable
        } else {
            collectionView.addSubview(refreshTable)
        }
        
        collectionView.alwaysBounceVertical = true;
        isPageRefresh = true
       // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
        getproduct(0)
        
        let button2 = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(MerchantProductsViewControler.FiltterShow(sender:)))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2
        
        let button3 = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(MerchantProductsViewControler.SortShow(sender:)))
        let rightSearchBarButtonItem:UIBarButtonItem = button3
        
       navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1, rightSearchBarButtonItem], animated: true)
    }
    
    @objc func refreshNews(_ sender:AnyObject)  {
        lastposition = 0
         getproduct(0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(returntofilter){
            returntofilter = false
        isPageRefresh = true
             self.arrproducts = []
            collectionView.reloadData()
            //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
       getproduct(0)
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
       // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
         getproduct(0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
        //print("regtykiu")
        let trimMessage: String = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //var name : String = "GALERIA DOMINIKAŃSKA"
         storySearchBar?.resignFirstResponder()
        //let encMessage: String = self.appDelegate().msgEncode(trimMessage)
        if(trimMessage.count>0){
           // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
        getproduct(0)
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // storySearchBar?.showsCancelButton = true
        //searchStarting = true
        //storyTableView?.reloadData()
        //searchActive = true
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimMessage: String = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(trimMessage.count == 0){
            //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            getproduct(0)
        }
    }
    @objc func FiltterShow(sender:UIButton)  {
        if(appDelegate().arrfilter.count>0){
           returntofilter = true
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let settingsController : MerchantFiltterViewController = storyBoard.instantiateViewController(withIdentifier: "MerchantFiltter") as! MerchantFiltterViewController
            
            show(settingsController, sender: self)
        }
        else{
            alertWithTitle1(title: nil, message: "No filters found for this category", ViewController: self)
            
        }
       
    }
    @objc func SortShow(sender:UIButton)  {
          if(arrshort.count>0){
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        for i in 0..<arrshort.count {
            
            let dic = arrshort[i] as! NSDictionary
            let checkdays = dic.value(forKey: "name") as! String
           let checked = dic.value(forKey: "checked") as! Bool
            // }
            let EveryoneAction = UIAlertAction(title: checkdays, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                //print(alert.title)
                //Code to show camera
                let namesel = alert.title as! String
                for i in 0..<self.arrshort.count {
                    
                    let dic = self.arrshort[i] as! NSDictionary
                    let checkdays = dic.value(forKey: "name") as! String
                    print(namesel)
                    if(checkdays == namesel){
                        var dict: [String : AnyObject] = self.arrshort[i] as! [String : AnyObject]
                        dict["checked"] = 1 as AnyObject
                        self.arrshort[i] = dict as AnyObject
                    }
                    else{
                        var dict: [String : AnyObject] = self.arrshort[i] as! [String : AnyObject]
                        dict["checked"] = 0 as AnyObject
                        self.arrshort[i] = dict as AnyObject
                    }
                }
                self.arrproducts = []
                //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                self.getproduct(0)
                
            })
            EveryoneAction.setValue(checked, forKey: "checked")
            optionMenu.addAction(EveryoneAction)
            
        }
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
            
        })
       
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        }
          else{
            alertWithTitle1(title: nil, message: "No products to sort", ViewController: self)
            
        }
    }
    func Nodatamsg()  {
        self.notelable?.isHidden = false
        
        self.collectionView?.isHidden = true
        self.produectcountlbl?.isHidden = true
        let bullet1 = "No product(s) found for your filter criteria"
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
        let viewNib = UINib(nibName: "MerchantProduct", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "MerchantProduct")
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MerchantProductsViewControler.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MerchantProductsViewControler.realDelegate!;
    }
    func getproduct(_ lastindex : Int)  {
        if ClassReachability.isConnectedToNetwork() {
            Apicalling = true
            if(lastindex == 0){
                isPageRefresh = true
                lastposition = 0
                 self.produectcountlbl?.text = ""
            //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading")
                // TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            }
            let trimMessage: String = (storySearchBar?.text!.trimmingCharacters(in: .whitespacesAndNewlines))!
            let boundary = appDelegate().generateBoundaryString()
            var request = URLRequest(url: URL(string: MediaAPI)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var reqParams = [String: AnyObject]()
            reqParams["cmd"] = "getproducts" as AnyObject
            reqParams["key"] = "kXfqS9wUug6gVKDB"  as AnyObject
             reqParams["search"] = trimMessage as AnyObject
            reqParams["cid"] =   cid as AnyObject//String(describing:  lastindex)
            reqParams["lastindex"] = lastindex as AnyObject
            if(appDelegate().arrtempfilter.count > 0){
                do {
                    
                        let dataArrAllChats = try JSONSerialization.data(withJSONObject:  appDelegate().arrtempfilter, options: .prettyPrinted)
                        let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                    reqParams["afilter"] = strArrAllChats as AnyObject
                } catch {
                    //print(error.localizedDescription)
                }
                // reqParams["afilter"] =   appDelegate().arrtempfilter as AnyObject
            }
            //reqParams["username"] = myjidtrim as AnyObject
            if(appDelegate().arrfilter.count > 0){
                do {
                    
                    let dataArrAllChats = try JSONSerialization.data(withJSONObject:  appDelegate().arrfilter, options: .prettyPrinted)
                    let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                    reqParams["filter"] = strArrAllChats as AnyObject
                } catch {
                    //print(error.localizedDescription)
                }
                //reqParams["filter"] =   appDelegate().arrfilter as AnyObject
            }
            if(arrshort.count > 0){
                do {
                    
                    let dataArrAllChats = try JSONSerialization.data(withJSONObject:  arrshort, options: .prettyPrinted)
                    let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                    reqParams["sort"] = strArrAllChats as AnyObject
                } catch {
                    //print(error.localizedDescription)
                }
                //reqParams["filter"] =   appDelegate().arrfilter as AnyObject
            }
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
                    self.Apicalling = false
                    if String(data: data, encoding: String.Encoding.utf8) != nil {
                        //print(stringData) //JSONSerialization
                        
                        
                        
                        //print(time)
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                            
                            let isSuccess: Bool = (jsonData?.value(forKey: "success") as? Bool)!
                             //print(jsonData)
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
                                    if(data.count == 1){
                                         self.produectcountlbl?.text = String( jsonData?.value(forKey: "productcount") as! Int) + " Product available  "
                                    }
                                    else{
                                         self.produectcountlbl?.text = String( jsonData?.value(forKey: "productcount") as! Int) + " Products available   "
                                    }
                                   
                                    if(self.isPageRefresh)
                                    {  self.isPageRefresh = false
                                        //arrFanUpdatesTeams
                                        self.refreshTable.endRefreshing()
                                        self.arrproducts = data  as [AnyObject]
                                    }
                                    else
                                    {
                                        self.arrproducts += data  as [AnyObject]
                                    }
                                    //  self.arrsubcategories = jsonData?.value(forKey: "data") as! NSArray
                                    self.collectionView.reloadData()
                                }
                                else{
                                    self.isPageRefresh = false
                                    self.tableviewButtomConstraint.constant = 10
                                    self.Buttomloader?.isHidden = true
                                    // self.collectionView.reloadData()
                                }
                                let filter = jsonData?.value(forKey: "filter") as! NSArray
                                if(filter.count > 0)
                                {
                                    self.appDelegate().arrfilter = filter as [AnyObject]
                                    self.appDelegate().merchantfilterupdate()
                                }
                                let sort = jsonData?.value(forKey: "sort") as! NSArray
                                if(sort.count > 0)
                                {
                                    self.arrshort = sort as [AnyObject]
                                    //self.appDelegate().merchantfilterupdate()
                                }
                                if(self.arrproducts.count == 0){
                                    self.notelable?.isHidden = false
                                    self.collectionView.isHidden = true
                                    self.produectcountlbl?.isHidden = true
                                    self.Nodatamsg()
                                }
                                else{
                                    self.notelable?.isHidden = true
                                    self.collectionView.isHidden = false
                                     self.produectcountlbl?.isHidden = false
                                }
                                }
                               
                            }
                            else
                            { DispatchQueue.main.async
                                {
                                    //TransperentLoadingIndicatorView.hide()
                                    self.tableviewButtomConstraint.constant = 10
                                    self.Buttomloader?.isHidden = true
                                    if(self.isPageRefresh)
                                    {  self.isPageRefresh = false
                                        //arrFanUpdatesTeams
                                        self.refreshTable.endRefreshing()
                                        self.arrproducts = []
                                         self.collectionView.reloadData()
                                    }
                                    if(self.arrproducts.count == 0){
                                        self.notelable?.isHidden = false
                                        self.collectionView.isHidden = true
                                         self.produectcountlbl?.isHidden = true
                                        self.Nodatamsg()
                                    }
                                    else{
                                        self.notelable?.isHidden = true
                                        self.collectionView.isHidden = false
                                         self.produectcountlbl?.isHidden = false
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
                            if(self.isPageRefresh)
                            {  self.isPageRefresh = false
                            }
                            self.tableviewButtomConstraint.constant = 10
                            self.Buttomloader?.isHidden = true
                            self.collectionView.reloadData()
                            if(self.arrproducts.count == 0){
                                self.notelable?.isHidden = false
                                self.collectionView.isHidden = true
                                 self.produectcountlbl?.isHidden = true
                                self.Nodatamsg()
                            }
                            else{
                                self.notelable?.isHidden = true
                                self.collectionView.isHidden = false
                                 self.produectcountlbl?.isHidden = false
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
        return arrproducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(arrproducts.count > 19)
        {
            
            let lastElement = arrproducts.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                if(!Apicalling){
                    Buttomloader?.isHidden = false
                    tableviewButtomConstraint.constant = 35
                    lastposition = lastposition + 1
                    print("jff\(lastposition)")
                    //TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                    getproduct(lastposition)
                }
               
                
            }
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantProduct", for: indexPath as IndexPath) as! MerchantProductCell
        
        
        // Add image to cell
        
        
        let dic = arrproducts[indexPath.row] as AnyObject
        cell.productTitle.text = dic.value(forKey: "productName") as? String
        cell.price.text = dic.value(forKey: "displayPrice") as? String
        if(dic.value(forKey: "productImageURL") != nil)
        {
            let avatar:String = (dic.value(forKey: "productImageURL") as? String)!
            if(!avatar.isEmpty)
            {
                //cell.imageView.imageURL = avatar
                self.lazyImage.show(imageView:cell.imageView!, url:avatar, defaultImage: "img_thumb")
                
            }
        }
        else{
            cell.imageView?.image = UIImage(named: "img_thumb")
        }
        /* if selectedCell.contains(indexPath) {
         cell.contentView.backgroundColor = .red
         }
         else {
         cell.contentView.backgroundColor = .white
         } */
        if(dic.value(forKey: "productMRP") != nil)
        {
            let avatar:String = (dic.value(forKey: "productMRP") as? String)!
            if(!avatar.isEmpty && avatar != "£0.00")
            {
                //self.lazyImage.show(imageView:imageView!, url:avatar, defaultImage: "img_thumb")
                cell.rrprice.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (dic.value(forKey: "productMRP") as? String)!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                cell.rrprice.attributedText = attributeString
                //merchatlogo.imageURL = dic.value(forKey: "MerchantImage") as! String
            }
            else{
                cell.rrprice.isHidden = true
            }
        }
        else{
            //merchatlogo?.image = UIImage(named: "img_thumb")
            cell.rrprice.isHidden = true
        }
        let label1 = UILabel(frame: CGRect(x: 20.0, y: 0, width:CGFloat.greatestFiniteMagnitude , height:21.0 ))
        label1.font = UIFont.systemFont(ofSize: 17.0)
        label1.text = dic.value(forKey: "displayPrice") as? String
        // label1.textAlignment = .left
        //label.textColor = self.strokeColor
        //label1.lineBreakMode = .byWordWrapping
        label1.numberOfLines = 1
        label1.sizeToFit()
        //print(label1.frame.width)
        if((label1.frame.width) > 53)
        {
            cell.priceWidth.constant = label1.frame.width + 15.0
        }
        else{
            cell.priceWidth.constant = label1.frame.width + 5.0
        }
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
        let dic = arrproducts[indexPath.row] as! NSDictionary
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : MerchantDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MerchantDetail") as! MerchantDetailViewController
        settingsController.dic = dic
        settingsController.maintitel = dic.value(forKey: "productName") as! String
        show(settingsController, sender: self)
        
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
        
        return CGSize(width: 250, height: 400)
    }
    
    
    
    
    
    
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in
            
        });
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion:nil)
    }
    

    
    
}
