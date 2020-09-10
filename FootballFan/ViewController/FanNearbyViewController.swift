import UIKit
import MapKit
import Alamofire

class FanNearbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    //@IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var storyTableView: UITableView?
    
    @IBOutlet weak var nearbyTeam: UILabel?
    //@IBOutlet weak var btnNearbyTeam: UIButton!
    
    @IBOutlet weak var fanName: UITextField?
    
    
    var isFromCurrentLocation: Bool = true
     var Selectedlocation: Bool = false
    var phoneFilteredContacts = NSMutableArray()
    let cellReuseIdentifier = "nearby"
    var searchActive: Bool = false
    var searchStarting: Bool = false
    var isLoadingFans: Bool = false
    //var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    //var resultView: UITextView?
    var activityIndicator: UIActivityIndicatorView?
    var strings:[String] = []
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var Childview: UIView?
    @IBOutlet weak var notelable: UILabel?
      @IBOutlet weak var ConectingHightConstraint: NSLayoutConstraint!
     @IBOutlet weak var Connectinglabel: UILabel?
    @IBOutlet weak var searchBtn: UIButton?
    @IBOutlet weak var resetBtn: UIButton?
    @IBAction func radiusButton(_ sender: UIButton) {
        //aTextField?.endEditing(true)
        let optionMenu = UIAlertController(title: nil, message: "Select an Option", preferredStyle: .actionSheet)
        let OneAction = UIAlertAction(title: "1 Mile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 1
            self.radius.text = "  1 Mile"
            
        })
        let TwoAction = UIAlertAction(title: "5 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 5
            self.radius.text = "  5 Miles"
            
        })
        let ThreeAction = UIAlertAction(title: "10 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 10
            self.radius.text = "  10 Miles"
            
        })
       /* let FourAction = UIAlertAction(title: "20 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 20
            self.radius.text = "  20 Miles"
            
        })
        let FiveAction = UIAlertAction(title: "30 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 30
            self.radius.text = "  30 Miles"
            
        })
        let SixAction = UIAlertAction(title: "40 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 40
            self.radius.text = "  40 Miles"
            
        })*/
        let SevenAction = UIAlertAction(title: "50 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 50
            self.radius.text = "  50 Miles"
            
        })
        
        let EightAction = UIAlertAction(title: "100 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 100
            self.radius.text = "  100 Miles"
            
        })
       /* let NineAction = UIAlertAction(title: "200 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 200
            self.radius.text = "  200 Miles"
            
        })
        let TenAction = UIAlertAction(title: "300 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 300
            self.radius.text = "  300 Miles"
            
        })*/
        let ElevenAction = UIAlertAction(title: "500 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 500
            self.radius.text = "  500 Miles"
            
        })
        let TwelveAction = UIAlertAction(title: "Anywhere", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 501
            self.radius.text = "  Anywhere"
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(OneAction)
        optionMenu.addAction(TwoAction)
        optionMenu.addAction(ThreeAction)
        //optionMenu.addAction(FourAction)
        //optionMenu.addAction(FiveAction)
        //optionMenu.addAction(SixAction)
        optionMenu.addAction(SevenAction)
        optionMenu.addAction(EightAction)
       // optionMenu.addAction(NineAction)
        //optionMenu.addAction(TenAction)
        optionMenu.addAction(ElevenAction)
        optionMenu.addAction(TwelveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func teamButton(_ sender: UIButton) {
        let popController: CategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category") as! CategoryViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        popController.isShowForBanterRoom = true
        popController.teamType = "nearby"
        // present the popover
        self.present(popController, animated: true, completion: nil)
      /*  let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        popController.isShowForBanterRoom = true
        popController.teamType = "nearby"
        // present the popover
        self.present(popController, animated: true, completion: nil)*/
    }
    
    @objc func isUserOnline()
    {
          DispatchQueue.main.async {
           if ClassReachability.isConnectedToNetwork() {
                
            if(self.appDelegate().isUserOnline)
                {
                    // LoadingIndicatorView.hide()
                   // self.parent?.title = "Fans Nearby"
                    self.ConectingHightConstraint.constant = CGFloat(0.0)
                }
                else
                {
                    self.Connectinglabel?.text = "Connecting..."
                    self.ConectingHightConstraint.constant = CGFloat(00.0)
                    //LoadingIndicatorView.hide()
                    // self.parent?.title = "Banter Rooms"
                    //LoadingIndicatorView.show(self.view, loadingText: "Please wait while loading banters.")
                    //self.parent?.title = "Connecting.."
                }
                
                
            } else {
              //  TransperentLoadingIndicatorView.hide()
               // self.parent?.title = "Waiting for network.."
            self.Connectinglabel?.text = "Waiting for network..."
            self.ConectingHightConstraint.constant = CGFloat(20.0)
            }
       // }
        }
    }
    
   // @IBOutlet var aTextField: AJAutocompletePlaceTextfield!
    
    var placeid : String? = nil
    var latitude : Double?  = 0
    var longitude : Double?  = 0
    var priority = 0
    @IBOutlet weak var radius: UILabel!
    var AllowWebserviceCall : Bool = false
    
    
    //@IBOutlet weak var select_miles: UIButton!
    @IBOutlet weak var cur_location: UIButton!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    @IBAction func locationtxtchange(){
            latitude = 0
            longitude = 0
    }
    @IBAction func current_location(_ sender: UIButton) {
        if ClassReachability.isConnectedToNetwork()
        {

        let notified: String? = UserDefaults.standard.string(forKey: "notifiedlocation")
       
        if notified == nil
        {
            //Show notify before get permissions
            let popController: VideoPermissionScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoPermissionScreen") as! VideoPermissionScreen
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.notifyType = "location"
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }
        else
        {
             // LoadingIndicatorView.show(self.view, loadingText: "Retrieving your current location")
            isFromCurrentLocation = false
            currentLocation = nil
            Selectedlocation = false
            locationManager = CLLocationManager()
            isAuthorizedtoGetUserLocation()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        }
        }
        else {
            self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
    }
    
    @IBAction func resetFan(){
        fanName!.text = "";
        nearbyTeam!.text = "  Select a Team"
        priority = 0
        self.radius.text = "  Select a Radius"
        self.appDelegate().nearbyTeamId = 0
         notelable?.isHidden = true
         storyTableView?.isHidden = true
        self.appDelegate().nearbyTeamName = ""
        self.appDelegate().fanNearByContacts = []
        storyTableView?.reloadData()
    }
    
    @IBAction func searchFanNear(){
        fanName?.endEditing(true)
        SearchFans()
            
       }
    
    @objc func SearchFans() {
       // aTextField?.endEditing(true)
        
        if ClassReachability.isConnectedToNetwork()
        {
        phoneFilteredContacts = NSMutableArray()
        //appDelegate().fanNearByContacts = NSMutableArray()
        let notified: String? = UserDefaults.standard.string(forKey: "notifiedlocation")
        if notified == nil
        {
            //Show notify before get permissions
            let popController: VideoPermissionScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoPermissionScreen") as! VideoPermissionScreen
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.notifyType = "location"
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }
        else
        {
            
            AllowWebserviceCall = true
           // if ClassReachability.isConnectedToNetwork()
           // {
                isFromCurrentLocation = true
                currentLocation = nil
                locationManager = CLLocationManager()
                isAuthorizedtoGetUserLocation()
                
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }

            else {
                   displayCantAddContactAlert()
                 }
           // }
           // else {
            //    self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                
            //}
        }
        }
        else {
            self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        
    }
    
    
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            fanName?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    
    @objc func selectNearbyTeam (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            //isShowForBanterRoom = true
            //teamType = "my"
            let popController: CategoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category") as! CategoryViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.isShowForBanterRoom = true
            popController.teamType = "nearby"
            // present the popover
            self.present(popController, animated: true, completion: nil)
          /*
            // get a reference to the view controller for the popover
            let popController: AddTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTeam") as! AddTeamViewController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.isShowForBanterRoom = true
            popController.teamType = "nearby"
            // present the popover
            self.present(popController, animated: true, completion: nil)*/
        }
        sender.cancelsTouchesInView = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        storyTableView?.delegate = self
        storyTableView?.dataSource = self
      //  aTextField?.delegate = self
        
        storyTableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FanNearbyViewController.minimiseKeyboard(_:))))
        storyTableView?.isUserInteractionEnabled = true
        
        
        nearbyTeam?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FanNearbyViewController.selectNearbyTeam(_:))))
        nearbyTeam?.isUserInteractionEnabled = true
        
        
        radius?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FanNearbyViewController.loadMiles(_:))))
        radius?.isUserInteractionEnabled = true
        
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FanNearbyViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        
        
        searchBtn?.layer.masksToBounds = true;
        searchBtn?.layer.cornerRadius = 5.0
        
        resetBtn?.layer.masksToBounds = true;
        resetBtn?.layer.cornerRadius = 5.0
        
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FanNearbyViewController.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
        
     /*   aTextField.selectedPlace = { place, pid, indexPath in
            //print("SELECTED PLACE : \(place)")
            // print("SELECTED PLACE ID : \(pid)")
            self.placeid = pid
            //print("INDEXPATH : \(indexPath)")
            
            //This will be go into the notify
            //GMSPlacesClient.provideAPIKey("AIzaSyBT7WyWAdjhUZCssmEIbHZC-xcjME0Zcv8")
            
            let placesClient = GMSPlacesClient()
            
            placesClient.lookUpPlaceID(self.placeid!, callback: { (placeresult, error) -> Void in
                if let error = error {
                    // print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = placeresult else {
                    // print("No place details for \(String(describing: self.placeid))")
                    return
                }
                self.Selectedlocation = true
                self.latitude = place.coordinate.latitude as AnyObject as? Double
                self.longitude = place.coordinate.longitude as AnyObject as? Double
                
            })
            
        }
        */
        
        
        
        /*btnNearbyTeam?.layer.masksToBounds = true;
         btnNearbyTeam?.layer.borderWidth = 1.0
         btnNearbyTeam?.layer.borderColor = UIColor.lightGray.cgColor
         btnNearbyTeam?.layer.cornerRadius = 5.0 */
        
      /*  aTextField?.layer.masksToBounds = true;
        aTextField?.layer.borderWidth = 1.0
        aTextField?.layer.borderColor = UIColor.lightGray.cgColor
        aTextField?.layer.cornerRadius = 5.0
        */
        /*  cur_location?.layer.masksToBounds = true;
         cur_location?.layer.borderWidth = 1.0
         cur_location?.layer.borderColor = UIColor.lightGray.cgColor
         cur_location?.layer.cornerRadius = 5.0 */
        
        /* select_miles?.layer.masksToBounds = true;
         select_miles?.layer.borderWidth = 1.0
         select_miles?.layer.borderColor = UIColor.lightGray.cgColor
         select_miles?.layer.cornerRadius = 5.0 */
        
        radius?.layer.masksToBounds = true;
        radius?.layer.borderWidth = 1.0
        radius?.layer.borderColor = UIColor.lightGray.cgColor
        radius?.layer.cornerRadius = 5.0
        
        nearbyTeam?.layer.masksToBounds = true;
        nearbyTeam?.layer.borderWidth = 1.0
        nearbyTeam?.layer.borderColor = UIColor.lightGray.cgColor
        nearbyTeam?.layer.cornerRadius = 5.0
        
        
        fanName?.layer.masksToBounds = true;
        fanName?.layer.borderWidth = 1.0
        fanName?.layer.borderColor = UIColor.lightGray.cgColor
        fanName?.layer.cornerRadius = 5.0
        
        
        
        
        //GMSPlacesClient.provideAPIKey("AIzaSyBT7WyWAdjhUZCssmEIbHZC-xcjME0Zcv8")
        
        //GMSServices.provideAPIKey("AIzaSyBT7WyWAdjhUZCssmEIbHZC-xcjME0Zcv8")
        
        /*resultsViewController = GMSAutocompleteResultsViewController()
         resultsViewController?.delegate = self as GMSAutocompleteResultsViewControllerDelegate
         
         searchController = UISearchController(searchResultsController: resultsViewController)
         searchController?.searchResultsUpdater = resultsViewController
         
         // Put the search bar in the navigation bar.
         searchController?.searchBar.sizeToFit()
         //navigationItem.titleView = searchController?.searchBar
         self.parent?.navigationItem.titleView = searchController?.searchBar
         
         //self.view.addSubview((searchController?.searchBar)!)
         
         // When UISearchController presents the results view, present it in
         // this view controller, not one further up the chain.
         definesPresentationContext = true
         
         // Prevent the navigation bar from being hidden when searching.
         searchController?.hidesNavigationBarDuringPresentation = false*/
        
        let notificationName = Notification.Name("_RefreshNearbyView")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(FanNearbyViewController.refreshNearbyView), name: notificationName, object: nil)
        
        let notificationName2 = Notification.Name("_GetPermissionsForLocation")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(FanNearbyViewController.GetPermissionsForLocation), name: notificationName2, object: nil)
        let notificationName3 = Notification.Name("_isUserOnlineNotifyNearby")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(FanNearbyViewController.isUserOnline), name: notificationName3, object: nil)
        
         storyTableView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.parent?.title = "Fans"
         //self.navigationItem.title = "Fans Nearby"
        parent?.navigationItem.rightBarButtonItems = nil
             self.appDelegate().isUpdatesLoaded = false
             
             /*let infoButton = UIButton(type: .custom)
              infoButton.setTitle("Search", for: .normal)
              //infoButton.frame = CGRect(x: 0, y: 0, width: 80, height: 22)
              infoButton.addTarget(self, action: #selector(fetchNearbyContacts), for: .touchUpInside)
              let barButton = UIBarButtonItem(customView: infoButton)
              self.parent?.navigationItem.rightBarButtonItem = barButton
              */
             self.parent?.navigationItem.leftBarButtonItem = nil
        self.parent?.navigationItem.rightBarButtonItem = nil
           //  self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(SearchFans))
             
        if ClassReachability.isConnectedToNetwork() {
            
            if(appDelegate().isUserOnline)
            {
                //self.parent?.title = "Fans Nearby"
                 ConectingHightConstraint.constant = CGFloat(0.0)
            }
            else
            {
                Connectinglabel?.text = "Connecting..."
                 ConectingHightConstraint.constant = CGFloat(0.0)
                //self.parent?.title = "Connecting.."
            }
            
        } else {
            //self.parent?.title = "Waiting for network.."
            Connectinglabel?.text = "Waiting for network..."
            ConectingHightConstraint.constant = CGFloat(20.0)
        }
      
       /* let settingsImage   = UIImage(named: "settings")!
        let settingsButton = UIBarButtonItem(image: settingsImage,  style: .plain, target: self, action: #selector(self.showSettings))
        self.parent?.navigationItem.leftBarButtonItem = settingsButton*/
        
        appDelegate().curRoomType = "chat"
        
        //Temp code
        //showChatWindow()
        //end
        /*let login: String? = UserDefaults.standard.string(forKey: "userJID")
         if(login != nil)
         {
         appDelegate().goOnline(xmppStream())
         }*/
        
        
        /*if(self.appDelegate().nearbyTeamId > 0)
         {
         nearbyTeam?.text = self.appDelegate().nearbyTeamName
         }*/
        
        if(self.appDelegate().nearbyTeamId > 0)
        {
            nearbyTeam?.text = "  " + self.appDelegate().nearbyTeamName
        }
        else
        {
            /*
            let primary = self.appDelegate().primaryTeamId
            if(primary != 0){
                self.appDelegate().nearbyTeamId = self.appDelegate().primaryTeamId
                self.appDelegate().nearbyTeamName = self.appDelegate().primaryTeamName
                nearbyTeam?.text = "  " + self.appDelegate().primaryTeamName
            }
            else{
                nearbyTeam?.text = "  Select a Team"
            }
            */
            nearbyTeam?.text = "  Select a Team"
            
        }
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
               if(login == nil){
        //nearbyTeam?.padding = UIEdgeInsetsMake(0, 10, 0, 0)
      appDelegate().pageafterlogin = "nearby"
                       appDelegate().idafterlogin = 0
        }
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
    /*@IBAction func autocompleteClicked(_ sender: UIButton) {
     let autocompleteController = GMSAutocompleteViewController()
     autocompleteController.delegate = self
     present(autocompleteController, animated: true, completion: nil)
     }*/
    
    @objc func showSettings() {
        //print("Show stettings")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController : SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        
        self.present(settingsController, animated: true, completion: nil)
    }
    
    @objc func refreshNearbyView()
    {
        currentLocation = nil
        self.storyTableView?.reloadData()
        
        if(self.appDelegate().fanNearByContacts.count < 1)
        {   notelable?.isHidden = false
            storyTableView?.isHidden = true
            //notelable?.text = "Sorry! No Fans found for your search criteria.\nPlease try different search criteria."
            let bullet1 = "Sorry! No Fans found for your search criteria."
            let bullet2 = "Please try different search criteria."
           // let bullet3 = ""
           // let bullet4 = ""
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
                let formattedString: String = "\(string)\n"
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
            //let message = "No Chats found."
            //alertWithTitle(title: "Error", message: message, ViewController: self)
            
        }
        else{
            notelable?.isHidden = true
            storyTableView?.isHidden = false
        }
        TransperentLoadingIndicatorView.hide()
        
        /*   if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         } */
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
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
   
   
    
    @objc func GetPermissionsForLocation(notification: NSNotification)
    {
        // LoadingIndicatorView.show(self.view, loadingText: "Retrieving your current location")
        isFromCurrentLocation = false
        locationManager = CLLocationManager()
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
             AllowWebserviceCall = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
        else if status == .authorizedAlways {
            //print("User allowed us to access location")
            //do whatever init activities here.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    
    @objc func loadMiles (_ sender: UITapGestureRecognizer) {
      //  aTextField?.endEditing(true)
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        let OneAction = UIAlertAction(title: "1 Mile", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 1
            self.radius.text = "  1 Mile"
            
        })
        let TwoAction = UIAlertAction(title: "5 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 5
            self.radius.text = "  5 Miles"
            
        })
        let ThreeAction = UIAlertAction(title: "10 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 10
            self.radius.text = "  10 Miles"
            
        })
       /* let FourAction = UIAlertAction(title: "20 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 20
            self.radius.text = "  20 Miles"
            
        })
        let FiveAction = UIAlertAction(title: "30 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 30
            self.radius.text = "  30 Miles"
            
        })
        let SixAction = UIAlertAction(title: "40 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 40
            self.radius.text = "  40 Miles"
            
        })*/
        let SevenAction = UIAlertAction(title: "50 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 50
            self.radius.text = "  50 Miles"
            
        })
        let EightAction = UIAlertAction(title: "100 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 100
            self.radius.text = "  100 Miles"
            
        })
       /* let NineAction = UIAlertAction(title: "200 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 200
            self.radius.text = "  200 Miles"
            
        })
        let TenAction = UIAlertAction(title: "300 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 300
            self.radius.text = "  300 Miles"
            
        })*/
        let ElevenAction = UIAlertAction(title: "500 Miles", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 500
            self.radius.text = "  500 Miles"
            
        })
        let TwelveAction = UIAlertAction(title: "Anywhere", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.priority = 501
            self.radius.text = "  Anywhere"
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(OneAction)
        optionMenu.addAction(TwoAction)
        optionMenu.addAction(ThreeAction)
       // optionMenu.addAction(FourAction)
        //optionMenu.addAction(FiveAction)
        //optionMenu.addAction(SixAction)
        optionMenu.addAction(SevenAction)
        optionMenu.addAction(EightAction)
        //optionMenu.addAction(NineAction)
        //optionMenu.addAction(TenAction)
        optionMenu.addAction(ElevenAction)
        optionMenu.addAction(TwelveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //currentLocation = locations.last
       // aTextField?.endEditing(true)
        if currentLocation == nil {
            currentLocation = locations.last
            manager.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            // print("locations = \(locationValue)")
            
            manager.stopUpdatingLocation()
            latitude = currentLocation.coordinate.latitude  
            longitude = currentLocation.coordinate.longitude as Double
            //Call API to save current location
            if (CLLocationCoordinate2DIsValid(locationValue)) {
                /*}
                 if(locationValue.latitude > 0 && locationValue.longitude > 0)
                 {*/
                
                //New code to call different APIS
                
               /* if(isFromCurrentLocation == false)
                {
                    if(Selectedlocation == false){
                        latitude = locationValue.latitude;
                        longitude = locationValue.longitude;
                        
                        let ceo: CLGeocoder = CLGeocoder()
                        
                        ceo.reverseGeocodeLocation(currentLocation, completionHandler:
                            {(placemarks, error) in
                                if (error != nil)
                                {
                                    // print("reverse geodcode fail: \(error!.localizedDescription)")
                                }
                                let pm = placemarks! as [CLPlacemark]
                                
                                if pm.count > 0 {
                                    let pm = placemarks![0]
                                    self.aTextField.text = pm.locality! + ", " + pm.administrativeArea! + ", " + pm.country!;
                                }
                                LoadingIndicatorView.hide()
                        })
                    }
                    else{
                         LoadingIndicatorView.hide()
                    }
                    
                    
                }
                else
                {*/
        if(AllowWebserviceCall){
            var trimMessage: String = fanName!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            trimMessage = trimMessage.condenseWhitespace()
                
                if(!(nearbyTeam?.text?.contains("  Select a Team"))! || !trimMessage.isEmpty)
                    {
                    if(latitude != 0 && longitude != 0 )
                    {
                        
                        if(priority > 0)
                        {
                            //appDelegate().fanNearByContacts = NSMutableArray()

                            //LoadingIndicatorView.show(self.view, loadingText: "Searching Fans for you")
                            //TransperentLoadingIndicatorView.show(view, loadingText: "")
                                       
                            var dictRequest = [String: AnyObject]()
                            dictRequest["cmd"] = "getnearbyusers" as AnyObject
                            dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                            dictRequest["device"] = "ios" as AnyObject
                            do {
                                
                                let login: String? = UserDefaults.standard.string(forKey: "userJID")
                                let arrReadUserJid = login?.components(separatedBy: "@")
                                let userReadUserJid = arrReadUserJid?[0]
                                
                                //Creating Request Data
                                var dictRequestData = [String: AnyObject]()
                                
                                var trimMessage: String = fanName!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                //print(trimMessage)
                                trimMessage = trimMessage.condenseWhitespace()
                                
                                
                                dictRequestData["searchby"] = "city" as AnyObject
                                dictRequestData["miles"] = priority as AnyObject
                                dictRequestData["username"] = userReadUserJid as AnyObject
                                dictRequestData["latitude"] = latitude as AnyObject
                                dictRequestData["longitude"] = longitude as AnyObject
                                dictRequestData["query"] = trimMessage as AnyObject
                                                              
                                if(currentLocation != nil)
                                {
                                    dictRequestData["clatitude"] = currentLocation.coordinate.latitude as AnyObject
                                    dictRequestData["clongitude"] = currentLocation.coordinate.longitude as AnyObject
                                }
                                
                                // dictRequestData["clatitude"] = 22.7152182 as AnyObject
                                //  dictRequestData["clongitude"] = 75.8714397 as AnyObject
                                
                                dictRequestData["teamid"] = self.appDelegate().nearbyTeamId as AnyObject
                                
                                dictRequest["requestData"] = dictRequestData as AnyObject
                                //dictRequest.setValue(dictMobiles, forKey: "requestData")
                                //print(dictRequest)
                                
                                /*let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
                                let strByPlace = NSString(data: dataByPlace, encoding: String.Encoding.utf8.rawValue)! as String
                                //print(strByPlace)
                                let escapedString = strByPlace.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                                
                                let url = MediaAPIjava + "request=" + escapedString!
                               */ //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
                                AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                                                  headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                                    // 2
                                    .responseJSON { response in
                                        //print(response.result.value)
                                        switch response.result {
                                                                                  case .success(let value):
                                                                                      if let json = value as? [String: Any] {
                                                                                          // print(" JSON:", json)
                                                                                          let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                                                                                          // self.finishSyncContacts()
                                                                                          //print(" status:", status1)
                                                                                          if(status1){DispatchQueue.main.async {
                                                                                              let response: NSArray = json["responseData"] as! NSArray
                                                                                              // print(response)
                                                                                              
                                                                                           //   self.appDelegate().fanNearByContacts = NSMutableArray()
                                                                                              
                                                                                              if(response.count > 0)
                                                                                              {
                                                                                                  self.appDelegate().fanNearByContacts = response as [AnyObject]
                                                                                                /*  let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
                                                                                                  if strAllContacts != nil
                                                                                                  {
                                                                                                      //Code to parse json data
                                                                                                      if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                                                                                          do {
                                                                                                              //appDelegate().allContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray as! NSMutableArray
                                                                                                              let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                                                                                                              
                                                                                                              self.appDelegate().allContacts = NSMutableArray()
                                                                                                              for record in tmpAllContacts {
                                                                                                                  self.appDelegate().allContacts[self.appDelegate().allContacts.count] = record
                                                                                                              }
                                                                                                              
                                                                                                              //appDelegate().allContacts = tmpAllAppContacts as! NSMutableArray
                                                                                                              //newChatAppContacts = appDelegate().allContacts[0] as! NSMutableArray
                                                                                                              
                                                                                                              let tmpAllAppContacts = self.appDelegate().allContacts[0] as! NSArray
                                                                                                              
                                                                                                              //newChatAppContacts = NSMutableArray()
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              for record in response {
                                                                                                                  
                                                                                                                  
                                                                                                                  let fansNearBy: NSDictionary = record as! NSDictionary
                                                                                                                  let fanNearbyJid = fansNearBy.value(forKey: "username") as! String
                                                                                                                  let fanNearbyDistance = fansNearBy.value(forKey: "distance") as! String
                                                                                                                  let fanNearbyNick = fansNearBy.value(forKey: "nickname") as! String
                                                                                                                  let avtarurl = fansNearBy.value(forKey: "avatar") as! String
                                                                                                                  var strName: String = ""
                                                                                                                  
                                                                                                        let followed = fansNearBy.value(forKey: "followed") as! Bool
                                                                                                                  //var strLogo: String = ""
                                                                                                                  var strStatus: String = ""
                                                                                                                  var strMobile: String = ""
                                                                                                                  _ = tmpAllAppContacts.filter({ (text) -> Bool in
                                                                                                                      let tmp: NSDictionary = text as! NSDictionary
                                                                                                                      let jid: String = tmp.value(forKey: "jid") as! String
                                                                                                                      if(jid == fanNearbyJid)
                                                                                                                      {                                                                                  strName = tmp.value(forKey: "name") as! String
                                                                                                                          
                                                                                                                          // strLogo = tmp.value(forKey: "avatar") as! String
                                                                                                                         // strStatus = tmp.value(forKey: "status") as! String
                                                                                                                         // strMobile = tmp.value(forKey: "mobile") as! String
                                                                                                                          //return true
                                                                                                                      }
                                                                                                                      
                                                                                                                      return false
                                                                                                                  })
                                                                                                                  
                                                                                                                  if(!strName.isEmpty)
                                                                                                                  {
                                                                                                      var tempDict = [String: AnyObject]()
                                                                                                                      
                                                                                                                      tempDict["jid"] = fanNearbyJid as AnyObject
                                                                                                                      tempDict["name"] = strName as AnyObject
                                                                                                                      tempDict["nickname"] = fanNearbyNick as AnyObject
                                                                                                                      tempDict["mobile"] = strMobile as AnyObject
                                                                                                                      tempDict["avatar"] = avtarurl as AnyObject//strLogo
                                                                                                                      let status: String? = strStatus
                                                                                                                      if status != nil
                                                                                                                      {
                                                                                                                          tempDict["status"] = "Hello! I am a Football Fan" as AnyObject
                                                                                                                      }
                                                                                                                      else
                                                                                                                      {
                                                                                                                          tempDict["status"] = "Hello! I am a Football Fan" as AnyObject
                                                                                                                      }
                                                                                                                      
                                                                                                                      tempDict["type"] = "nearby" as AnyObject
                                                                                                                      tempDict["distance"] = fanNearbyDistance as AnyObject
                                                                                                        
                                                                                                                      tempDict["followed"] = followed as AnyObject
                                                                                                                      
                                                                                                                      self.appDelegate().fanNearByContacts[self.appDelegate().fanNearByContacts.count] = tempDict
                                                                                                                  }
                                                                                                                  else
                                                                                                                  {
                                                                                                                      let varMobile = fanNearbyJid.split{$0 == "@"}.map(String.init)
                                                                                                                      
                                                                                                                      var tempDict = [String: AnyObject]()
                                                                                                                      
                                                                                                                      tempDict["jid"] = fanNearbyJid as AnyObject
                                                                                                                      tempDict["name"] = varMobile[0] as AnyObject
                                                                                                                      tempDict["nickname"] = fanNearbyNick as AnyObject
                                                                                                                      tempDict["mobile"] = "" as AnyObject
                                                                                                                      tempDict["avatar"] = avtarurl as AnyObject
                                                                                                                      tempDict["status"] = "Hello! I am a Football Fan" as AnyObject
                                                                                                                      
                                                                                                                      tempDict["type"] = "nearby" as AnyObject
                                                                                                                      tempDict["distance"] = fanNearbyDistance as AnyObject
                                                                                                          
                                                                                                                      tempDict["followed"] = followed as AnyObject
                                                                                                                      self.appDelegate().fanNearByContacts[self.appDelegate().fanNearByContacts.count] = tempDict
                                                                                                                  }
                                                                                                                  
                                                                                                              }
                                                                                                              //if(self.fanNearByContacts.count > 0)
                                                                                                              //{
                                                                                                              //Send notification to reload table
                                                                                                              
                                                                                                              let notificationName = Notification.Name("_RefreshNearbyView")
                                                                                                              NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                              //}
                                                                                                              //print(fanNearByContacts)
                                                                                                              
                                                                                                              /*var size = 0
                                                                                                               repeat {
                                                                                                               let colour = "clear"
                                                                                                               tmpSelected.add(colour)
                                                                                                               // Increment.
                                                                                                               size += 1
                                                                                                               
                                                                                                               } while size < newChatAppContacts.count*/
                                                                                                              
                                                                                                              
                                                                                                              //print(tmpSelected.count)
                                                                                                              //print(newChatAppContacts.count)
                                                                                                              
                                                                                                          } catch let error as NSError {
                                                                                                              print(error)
                                                                                                          }
                                                                                                      }
                                                                                                  }
                                                                                                  else
                                                                                                  {
                                                                                                      for record in response {
                                                                                                          
                                                                                                          
                                                                                                          let fansNearBy: NSDictionary = record as! NSDictionary
                                                                                                          let fanNearbyJid = fansNearBy.value(forKey: "username") as! String
                                                                                                          let fanNearbyDistance = fansNearBy.value(forKey: "distance") as! String
                                                                                                          let fanNearbyNick = fansNearBy.value(forKey: "nickname") as! String
                                                                                                          let avtarurl = fansNearBy.value(forKey: "avatar") as! String
                                                                                                          let varMobile = fanNearbyJid.split{$0 == "@"}.map(String.init)
                                                                                                          
                                                                                                          let followed = fansNearBy.value(forKey: "followed") as! Bool
                                                                                                                                        
                                                                                                          var tempDict = [String: AnyObject]()
                                                                                                          
                                                                                                          tempDict["jid"] = fanNearbyJid as AnyObject
                                                                                                          tempDict["name"] = varMobile[0] as AnyObject
                                                                                                          tempDict["nickname"] = fanNearbyNick as AnyObject
                                                                                                          tempDict["mobile"] = "" as AnyObject
                                                                                                          tempDict["avatar"] = avtarurl as AnyObject
                                                                                                          tempDict["status"] = "Hello! I am a Football Fan" as AnyObject
                                                                                                          
                                                                                                          tempDict["type"] = "nearby" as AnyObject
                                                                                                          tempDict["distance"] = fanNearbyDistance as AnyObject
                                                                                                          
                                                                                                        tempDict["followed"] = followed as AnyObject
                                                                                                        
                                                                                                          
                                                                                                          self.appDelegate().fanNearByContacts[self.appDelegate().fanNearByContacts.count] = tempDict
                                                                                                          
                                                                                                          
                                                                                                      }
                                                                                                      //if(self.fanNearByContacts.count > 0)
                                                                                                      //{
                                                                                                      //Send notification to reload table
                                                                                                      
                                                                                                      let notificationName = Notification.Name("_RefreshNearbyView")
                                                                                                      NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                                      //}
                                                                                                  }*/

                                                                                                  let notificationName = Notification.Name("_RefreshNearbyView")
                                                                                                  NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                              }
                                                                                              
                                                                                              }
                                                                                              
                                                                                          }
                                                                                          else{
                                                                                              DispatchQueue.main.async
                                                                                                  {
                                                                                                      self.appDelegate().fanNearByContacts = []
                                                                                                      let notificationName = Notification.Name("_RefreshNearbyView")
                                                                                                      NotificationCenter.default.post(name: notificationName, object: nil)
                                                                                              }
                                                                                              //Show Error
                                                                                          }
                                                                                      }
                                                                                  case .failure(let error):
                                                                                     debugPrint(error)
                                            break
                                                                                      // error handling
                                                                                  }
                                       
                                }
                                //self.appDelegate().sendRequestToAPI(strRequestDict: strByPlace)
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            
                        } else{
                             TransperentLoadingIndicatorView.hide()
                            //print("Select a radius")
                             storyTableView?.reloadData()
                            self.alertWithTitle(title: nil, message: "Please select a radius", ViewController: self)
                            
                        }
                    }
                    else
                    {
                        //print("Select a location")
                         TransperentLoadingIndicatorView.hide()
                        storyTableView?.reloadData()
                        self.alertWithTitle(title: nil, message: "Something went wrong.Please try again later", ViewController: self)
                    }
                    }
                    else
                    {
                        //print("Select a location")
                        TransperentLoadingIndicatorView.hide()
                        storyTableView?.reloadData()
                        self.alertWithTitle(title: nil, message: "Please enter fan name or select a team", ViewController: self)
                    }
                    
                    
                    
                    
                    
                }
                    
               // }
                
            }
            
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        displayCantAddContactAlert()
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot get location",
                                                    message: "You must give the app permission to get your current location.",
                                                    preferredStyle: .alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
                                                    style: .default,
                                                    handler: { action in
                                                        TransperentLoadingIndicatorView.hide()
                                                        self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            TransperentLoadingIndicatorView.hide()
            self.closeRefresh()
        }))
        present(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func closeRefresh()
    {
        /*if(refreshTable.isRefreshing)
         {
         refreshTable.endRefreshing()
         }
         else
         {
         if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }
         
         }
         isLoadingContacts = false
         storyTableView?.isScrollEnabled = true*/
    }
    
    func openSettings() {
        /*if(refreshTable.isRefreshing)
         {
         refreshTable.endRefreshing()
         }
         else
         {
         if(self.activityIndicator?.isAnimating)!
         {
         self.activityIndicator?.stopAnimating()
         }
         
         }
         isLoadingContacts = false
         storyTableView?.isScrollEnabled = true*/
        
        let url = NSURL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(url! as URL)
    }
    
    /*@IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
     if(sender.selectedSegmentIndex == 0)
     {
     print("By Current Location")
     }
     else if(sender.selectedSegmentIndex == 1)
     {
     let autocompleteController = GMSAutocompleteViewController()
     autocompleteController.delegate = self
     present(autocompleteController, animated: true, completion: nil)
     }
     
     }*/
    
    // MARK: - Table view data source
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     
     if(searchActive) {
     return "Search Results"
     }
     
     return "Football Fan Contacts"
     
     }*/
    
    
    @objc func FollowClick(_ longPressGestureRecognizer: UITapGestureRecognizer) {
         // print("Like Click")
          let touchPoint = longPressGestureRecognizer.location(in: storyTableView)
          if let indexPath = storyTableView?.indexPathForRow(at: touchPoint) {
              let login: String? = UserDefaults.standard.string(forKey: "userJID")
              if(login != nil){
                if ClassReachability.isConnectedToNetwork() {
                let dict: NSDictionary? = self.appDelegate().fanNearByContacts[indexPath.row] as? NSDictionary
              
                var dictRequest = [String: AnyObject]()
                dictRequest["cmd"] = "savefollowers" as AnyObject
                dictRequest["key"] = "kXfqS9wUug6gVKDB" as AnyObject
                dictRequest["device"] = "ios" as AnyObject
                     do {
                         
                         
                         //Creating Request Data
                         var dictRequestData = [String: AnyObject]()
                         let myjid: String? = UserDefaults.standard.string(forKey: "userJID")
                         let arrdUserJid = myjid?.components(separatedBy: "@")
                         let userUserJid = arrdUserJid?[0]
                         let time: Int64 = self.appDelegate().getUTCFormateDate()
                         
                         
                         let myjidtrim: String? = userUserJid
                        
                        let userjid: String? = dict?.value(forKey: "username") as? String
                        let arrUserJid = userjid?.components(separatedBy: "@")
                        let usernameJid = arrUserJid?[0]
                        let username: String? = usernameJid
                        
                         dictRequestData["followusername"] = username as AnyObject
                         dictRequestData["time"] = time as AnyObject
                         dictRequestData["username"] = myjidtrim as AnyObject
                         dictRequestData["type"] = "fan" as AnyObject
                         dictRequest["requestData"] = dictRequestData as AnyObject
                         
                        AF.request(MediaAPIjava, method:.post, parameters: ["request" : dictRequest], encoding: JSONEncoding.default,
                              headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                                            //print(response.result.value)
                                switch response.result {
                                                                         case .success(let value):
                                                                             if let json = value as? [String: Any] {
                                                                                    let status1: Bool = json["success"] as! Bool
                                                                                 
                                                                                    if(status1) {
                                                                                        let followed: Bool = dict?.value(forKey: "followed") as! Bool
                                                                                            
                                                                                        if let cell: NearbyCell = self.storyTableView!.cellForRow(at: indexPath as IndexPath) as? NearbyCell{
                                                                                                   
                                                                                            if(followed){
                                                                                                
                                                                                                var dict1: [String: AnyObject] = self.appDelegate().fanNearByContacts[indexPath.row] as! [String: AnyObject]
                                                                                                dict1["followed"] = 0 as AnyObject
                                                                                                self.appDelegate().fanNearByContacts[indexPath.row] = dict1 as AnyObject
                                                                                                cell.contactFollow?.setTitle("Follow", for: .normal)
                                                                                                cell.contactFollow.backgroundColor = UIColor.init(hex: "2185F7")
                                                                                            } else {
                                                                                                var dict1: [String: AnyObject] = self.appDelegate().fanNearByContacts[indexPath.row] as! [String: AnyObject]
                                                                                                dict1["followed"] = 1 as AnyObject
                                                                                                self.appDelegate().fanNearByContacts[indexPath.row] = dict1 as AnyObject
                                                                                                cell.contactFollow?.setTitle("Unfollow", for: .normal)
                                                                                                cell.contactFollow.backgroundColor = UIColor.init(hex: "AAAAAA")
                                                                                                
                                                                                            }
                                                                                                
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                             }
                                                                         case .failure(let error):
                                                                            debugPrint(error)
                                    break
                                                                             // error handling
                                                                         }
                               
                            }
                        
                     } catch {
                         print(error.localizedDescription)
                     }

                
                } else {
                    self.alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                            
                }
            } else {
                    appDelegate().LoginwithModelPopUp()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if(section == 0)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #FD7A5C
            // headerView.tintColor=UIColor(hex:"FFFFFF")
        }
        else if(section == 1)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
        }
        else if(section == 2)
        {
            headerView.backgroundColor = UIColor(hex: "9A9A9A")// #7FD9FB
        }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " Search Results"
        label.textColor=UIColor(hex: "FFFFFF")
        headerView.addSubview(label)
        if #available(iOS 9.0, *) {
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
        
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive){
            return phoneFilteredContacts.count
        }
        
        return self.appDelegate().fanNearByContacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NearbyCell = storyTableView!.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! NearbyCell
        
        let longPressGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FollowClick(_:)))
                     //longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        
        cell.contactFollow?.addGestureRecognizer(longPressGesture)
        cell.contactFollow?.isUserInteractionEnabled = true
        //print(phoneFilteredContacts)
        /* if(searchActive){
         //let arry: NSArray? = phoneFilteredContacts[indexPath.section] as? NSArray
         let dict: NSDictionary? = phoneFilteredContacts[indexPath.row] as? NSDictionary
         cell.contactName?.text = dict?.value(forKey: "name") as? String
         cell.contactDistance?.text = dict?.value(forKey: "distance") as? String
         cell.contactImage?.isHidden = true
         //cell.contactImage?.frame = CGRect(origin: .zero, size: .zero)
         cell.contactName?.frame.origin.x = 15.0
         cell.contactDistance?.frame.origin.x = 15.0
         //cell.pickContact?.addTarget(self, action: #selector(ForwardViewController.pickContact(_:)), for: UIControlEvents.touchUpInside)
         
         }
         else
         { */
        //let arry: NSArray? = self.appDelegate().fanNearByContacts[indexPath.row] as? NSArray
        let dict: NSDictionary? = self.appDelegate().fanNearByContacts[indexPath.row] as? NSDictionary
        
        let userjid: String? = dict?.value(forKey: "username") as! String
        let arrdUserJid = userjid?.components(separatedBy: "@")
               let userUserJid = arrdUserJid?[0]
        cell.contactName?.text = appDelegate().ExistingContact(username: userUserJid!)//dict?.value(forKey: "name") as? String
        
        let usersharedlocation: Bool = dict?.value(forKey: "usersharedlocation") as! Bool
               
        if(usersharedlocation){
              cell.contactDistance?.text = "Within " +  String(dict?.value(forKey: "distance") as! String)
        }
        else{
              cell.contactDistance?.text = "Location Unknown"
        }
      
        //print(dict?.value(forKey: "name") ?? "")
        //print(dict?.value(forKey: "avatar") ?? "")
        
        if(dict?.value(forKey: "avatar") != nil)
        {
            
            let avatar:String = (dict?.value(forKey: "avatar") as? String)!
            if(!avatar.isEmpty)
            {
                let url = URL(string:avatar)!
                                   cell.contactImage?.af_setImage(withURL: url)
                //cell.contactImage?.image = UIImage(data: Data.init(base64Encoded: avatar)!)
                //appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
               // cell.contactImage?.imageURL = avatar
                // appDelegate().loadImageFromUrl(url: avatar, view: cell.contactImage!)
            }
        }
        else
        {
            cell.contactImage?.image = UIImage(named: "user")
        }
        
        let followed: Bool = dict?.value(forKey: "followed") as! Bool
        
       
        if(followed){
                       cell.contactFollow?.setTitle("Unfollow" , for: UIControl.State.normal)
                       cell.contactFollow.backgroundColor = UIColor.init(hex: "AAAAAA")
                          }
                          else{
                              cell.contactFollow?.setTitle("Follow" , for: UIControl.State.normal)
                        cell.contactFollow.backgroundColor = UIColor.init(hex: "2185F7")
                          }
        // }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        
        let dict: NSDictionary = self.appDelegate().fanNearByContacts[indexPath.row] as! NSDictionary
        let userJid = (dict.value(forKey: "username") as? String)!
        /*appDelegate().toName = (dict.value(forKey: "name") as? String)!
        if let tmpAvatar = dict.value(forKey: "avatar")
        {
            appDelegate().toAvatarURL = tmpAvatar as! String//(dict?.value(forKey: "avatar") as? String)!
        }
        else
        {
            appDelegate().toAvatarURL = ""
        }
        
        /*let showType:[String: String] = ["type": "chat", "jid": userJid]
         let notificationName = Notification.Name("ShowGroupOrChatWindow")
         NotificationCenter.default.post(name: notificationName, object: nil, userInfo: showType)
         */
        
        appDelegate().toUserJID = userJid
        showChatWindow()*/
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let myTeamsController : ProfileDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetailsViewController
                            myTeamsController.RoomJid = userJid//dic?.value(forKey: "followusername") as! String + JIDPostfix
                            show(myTeamsController, sender: self)
                           
        }
        else{
            appDelegate().LoginwithModelPopUp()
        }
        
        
    }
    
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            FanNearbyViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return FanNearbyViewController.realDelegate!;
    }
    
   
    
}


/*extension FanNearbyViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print("Place name: \(place.name)")
        //print("Place address: \(place.formattedAddress)")
        //print("Place attributions: \(place.attributions)")
        
        //Call API
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "getnearbyusers" as AnyObject
        
        do {
            
            /*let dataInvited = try JSONSerialization.data(withJSONObject: strBanterJIDs, options: .prettyPrinted)
             let strInvited = NSString(data: dataInvited, encoding: String.Encoding.utf8.rawValue)! as String
             print(strInvited)*/
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let arrReadUserJid = login?.components(separatedBy: "@")
            let userReadUserJid = arrReadUserJid?[0]
            
            //Creating Request Data
            var dictRequestData = [String: AnyObject]()
            
            dictRequestData["searchby"] = "city" as AnyObject
            dictRequestData["miles"] = "1" as AnyObject
            dictRequestData["username"] = userReadUserJid as AnyObject
            dictRequestData["latitude"] = place.coordinate.latitude as AnyObject
            dictRequestData["longitude"] = place.coordinate.longitude as AnyObject
            
            if(currentLocation != nil)
            {
                dictRequestData["clatitude"] = currentLocation.coordinate.latitude as AnyObject
                dictRequestData["clongitude"] = currentLocation.coordinate.longitude as AnyObject
            }
            
            dictRequestData["teamid"] = self.appDelegate().nearbyTeamId as AnyObject
            
            dictRequest["requestData"] = dictRequestData as AnyObject
            //dictRequest.setValue(dictMobiles, forKey: "requestData")
            //print(dictRequest)
            
            let dataByPlace = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strByPlace = NSString(data: dataByPlace, encoding: String.Encoding.utf8.rawValue)! as String
            //print(strByPlace)
             let escapedString = strByPlace.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
           
            let url = MediaAPIjava + "request=" + escapedString!
            //"http://apitest.ifootballfan.com:8080/FFJavaAPI/API?request=%7B%22cmd%22%3A%22getfanupdates%22%2C%22requestData%22%3A%7B%22lastindex%22%3A0%2C%22teams%22%3A%22all%22%7D%7D"//MediaAPI + "request=" + strFanUpdates
            Alamofire.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default,
                              headers: ["Content-Type": "application/json","cache-control": "no-cache",])
                // 2
                .responseJSON { response in
                    //print(response.result.value)
                    if response.result.error == nil {
                        if let json = response.result.value as? Dictionary<String, Any>{
                            // print(" JSON:", json)
                            let status1: Bool = json["success"] as! Bool  //(json.index(forKey: "status") != nil) as Bool
                            // self.finishSyncContacts()
                            //print(" status:", status1)
                            if(status1){DispatchQueue.main.async {
                                let response: NSArray = json["responseData"] as! NSArray
                                // print(response)
                                
                                self.appDelegate().fanNearByContacts = NSMutableArray()
                                
                                if(response.count > 0)
                                {
                                    let strAllContacts: String? = UserDefaults.standard.string(forKey: "allContacts")
                                    if strAllContacts != nil
                                    {
                                        //Code to parse json data
                                        if let data = strAllContacts?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                            do {
                                                //appDelegate().allContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray as! NSMutableArray
                                                let tmpAllContacts = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                                                
                                                self.appDelegate().allContacts = NSMutableArray()
                                                for record in tmpAllContacts {
                                                    self.appDelegate().allContacts[self.appDelegate().allContacts.count] = record
                                                }
                                                
                                                //appDelegate().allContacts = tmpAllAppContacts as! NSMutableArray
                                                //newChatAppContacts = appDelegate().allContacts[0] as! NSMutableArray
                                                
                                                let tmpAllAppContacts = self.appDelegate().allContacts[0] as! NSArray
                                                
                                                //newChatAppContacts = NSMutableArray()
                                                
                                                
                                                
                                              
                                                
                                                for record in response {
                                                    
                                                   
                                                    let fansNearBy: NSDictionary = record as! NSDictionary
                                                    let fanNearbyJid = fansNearBy.value(forKey: "username") as! String
                                                    let fanNearbyDistance = fansNearBy.value(forKey: "distance") as! String
                                                    let fanNearbyNick = fansNearBy.value(forKey: "nickname") as! String
                                                    let avtarurl = fansNearBy.value(forKey: "avatar") as! String
                                                    var strName: String = ""
                                                    //var strLogo: String = ""
                                                    var strStatus: String = ""
                                                    var strMobile: String = ""
                                                    _ = tmpAllAppContacts.filter({ (text) -> Bool in
                                                        let tmp: NSDictionary = text as! NSDictionary
                                                        let jid: String = tmp.value(forKey: "jid") as! String
                                                        if(jid == fanNearbyJid)
                                                        {                                                                                  strName = tmp.value(forKey: "name") as! String
                                                            
                                                            // strLogo = tmp.value(forKey: "avatar") as! String
                                                            strStatus = tmp.value(forKey: "status") as! String
                                                            strMobile = tmp.value(forKey: "mobile") as! String
                                                            //return true
                                                        }
                                                        
                                                        return false
                                                    })
                                                    
                                                    if(!strName.isEmpty)
                                                    {
                                                        var tempDict = [String: String]()
                                                        
                                                        tempDict["jid"] = fanNearbyJid
                                                        tempDict["name"] = strName
                                                        tempDict["nickname"] = fanNearbyNick
                                                        tempDict["mobile"] = strMobile
                                                        tempDict["avatar"] = avtarurl//strLogo
                                                        let status: String? = strStatus
                                                        if status != nil
                                                        {
                                                            tempDict["status"] = status
                                                        }
                                                        else
                                                        {
                                                            tempDict["status"] = "Hello! I am a Football Fan"
                                                        }
                                                        
                                                        tempDict["type"] = "nearby"
                                                        tempDict["distance"] = fanNearbyDistance
                                                        
                                                        self.appDelegate().fanNearByContacts[self.appDelegate().fanNearByContacts.count] = tempDict
                                                    }
                                                    else
                                                    {
                                                        let varMobile = fanNearbyJid.characters.split{$0 == "@"}.map(String.init)
                                                        
                                                        var tempDict = [String: String]()
                                                        
                                                        tempDict["jid"] = fanNearbyJid
                                                        tempDict["name"] = varMobile[0]
                                                        tempDict["nickname"] = fanNearbyNick
                                                        tempDict["mobile"] = ""
                                                        tempDict["avatar"] = avtarurl
                                                        tempDict["status"] = "Hello! I am a Football Fan"
                                                        
                                                        tempDict["type"] = "nearby"
                                                        tempDict["distance"] = fanNearbyDistance
                                                        
                                                        self.appDelegate().fanNearByContacts[self.appDelegate().fanNearByContacts.count] = tempDict
                                                    }
                                                    
                                                }
                                                //if(self.fanNearByContacts.count > 0)
                                                //{
                                                //Send notification to reload table
                                                
                                                let notificationName = Notification.Name("_RefreshNearbyView")
                                                NotificationCenter.default.post(name: notificationName, object: nil)
                                                //}
                                                //print(fanNearByContacts)
                                                
                                                /*var size = 0
                                                 repeat {
                                                 let colour = "clear"
                                                 tmpSelected.add(colour)
                                                 // Increment.
                                                 size += 1
                                                 
                                                 } while size < newChatAppContacts.count*/
                                                
                                                
                                                //print(tmpSelected.count)
                                                //print(newChatAppContacts.count)
                                                
                                            } catch let error as NSError {
                                                //print(error)
                                            }
                                        }
                                    }
                                    else
                                    {
                                        for record in response {
                                            
                                            
                                            let fansNearBy: NSDictionary = record as! NSDictionary
                                            let fanNearbyJid = fansNearBy.value(forKey: "username") as! String
                                            let fanNearbyDistance = fansNearBy.value(forKey: "distance") as! String
                                            let fanNearbyNick = fansNearBy.value(forKey: "nickname") as! String
                                            let avtarurl = fansNearBy.value(forKey: "avatar") as! String
                                            let varMobile = fanNearbyJid.characters.split{$0 == "@"}.map(String.init)
                                            
                                            var tempDict = [String: String]()
                                            
                                            tempDict["jid"] = fanNearbyJid
                                            tempDict["name"] = varMobile[0]
                                            tempDict["nickname"] = fanNearbyNick
                                            tempDict["mobile"] = ""
                                            tempDict["avatar"] = avtarurl
                                            tempDict["status"] = "Hello! I am a Football Fan"
                                            
                                            tempDict["type"] = "nearby"
                                            tempDict["distance"] = fanNearbyDistance
                                            
                                            self.appDelegate().fanNearByContacts[self.appDelegate().fanNearByContacts.count] = tempDict
                                            
                                            
                                        }
                                        //if(self.fanNearByContacts.count > 0)
                                        //{
                                        //Send notification to reload table
                                        
                                        let notificationName = Notification.Name("_RefreshNearbyView")
                                        NotificationCenter.default.post(name: notificationName, object: nil)
                                        //}
                                    }
                                }
                                
                                }
                                
                            }
                            else{
                                DispatchQueue.main.async
                                    {
                                        let notificationName = Notification.Name("_RefreshNearbyView")
                                        NotificationCenter.default.post(name: notificationName, object: nil)
                                }
                                //Show Error
                            }
                        }
                    } else {
                        debugPrint(response.result.error as Any)
                    }
            }
            //self.appDelegate().sendRequestToAPI(strRequestDict: strByPlace)
        } catch {
            //print(error.localizedDescription)
        }
        
        //segmentedControl.selectedSegmentIndex = 0
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //segmentedControl.selectedSegmentIndex = 0
        // print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}*/
// Handle the user's selection.
/*extension FanNearbyViewController: GMSAutocompleteResultsViewControllerDelegate {
 func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
 didAutocompleteWith place: GMSPlace) {
 searchController?.isActive = false
 // Do something with the selected place.
 print("Place name: \(place.name)")
 print("Place address: \(place.formattedAddress)")
 print("Place latitude: \(place.coordinate.latitude)")
 print("Place longitude: \(place.coordinate.longitude)")
 self.dismiss(animated: true, completion: nil)
 }
 
 func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
 didFailAutocompleteWithError error: Error){
 // TODO: handle the error.
 print("Error: ", error.localizedDescription)
 }
 
 // Turn the network activity indicator on and off again.
 func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
 UIApplication.shared.isNetworkActivityIndicatorVisible = true
 }
 
 func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
 UIApplication.shared.isNetworkActivityIndicatorVisible = false
 }
 }*/
