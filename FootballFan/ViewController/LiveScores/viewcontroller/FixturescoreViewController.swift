//
//  FixturescoreViewController.swift
//  FootballFan
//
//  Created by Apple on 24/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class FixturescoreViewController: UIViewController {
    fileprivate weak var categoryView: AHCategoryView!
    var apd = UIApplication.shared.delegate as! AppDelegate
    var season_id = 0
    var fixtureData : Fixture?
    var legname:String = ""
    var dict: NSDictionary = NSDictionary()
    var tabatindex: Int = 0
    var childVCs = [UIViewController]()
    @IBOutlet weak var parentview: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //embeddedIntoTheNavigationBar()
        pinterest()
        let notificationName8 = Notification.Name("selecttab3")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.setindex), name: notificationName8, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        self.title = legname
        self.title = "Fixture"
        
        let button2 = UIBarButtonItem(image: UIImage(named: "shear_dark"), style: .plain, target: self, action: #selector(self.Showcalender(sender:)))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2
        
        /*  let rightSearchBarButtonItem2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.Getsliderdata))*/
        
        
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
        
    }
    @objc func Showcalender(sender:UIButton) {
        do {
            //let roomjid = appDelegate().toUserJID
            
            var dictRequest = [String: AnyObject]()
            dictRequest["id"] = season_id as AnyObject
            dictRequest["type"] = "roominvite" as AnyObject
            let dataInvite = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            //print(appDelegate().toName)
            //let title = appDelegate().toName
            
            let myBase64Data = dataInvite.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            
            let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
            
            let param = resultNSString as String?
            
            let inviteurl = InviteHost + "?q=" + param!
            var text = ""
            
            
            //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
            
            let objectsToShare = [text] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            //appDelegate().callingTinyURL(url: inviteurl, Titel: text)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    @objc func setindex(){
        categoryView.select(at: 3)
    }
}


//MARK:- Pinterest NavBar Style
extension FixturescoreViewController {
    func pinterest() {
        ///######## 1. Adding items
        /*var featureItem = AHCategoryItem()
         featureItem.title = "Feature"
         var chartItem = AHCategoryItem()
         chartItem.title = "Categories"
         var radioItem = AHCategoryItem()
         radioItem.title = "Radio"
         var liveItem = AHCategoryItem()
         liveItem.title = "Live"
         var searchItem = AHCategoryItem()
         searchItem.normalImage = UIImage(named: "search-magnifier")
         searchItem.selectedImage = UIImage(named: "search-magnifier")
         
         let items = [featureItem, chartItem, radioItem, liveItem, featureItem, chartItem, radioItem, liveItem, searchItem]*/
        var featureItem = AHCategoryItem()
        featureItem.title = "Overview"
        var chartItem = AHCategoryItem()
        chartItem.title = "Commentary"
        var transfersItem = AHCategoryItem()
        transfersItem.title = "Line-Up"
        var teamsItem = AHCategoryItem()
        teamsItem.title = "Statistics"
        
        let items = [featureItem, chartItem,transfersItem,teamsItem]
        ///######## 2. Adding VCs
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let mybanter : FixtureOverviewViewController = storyBoard.instantiateViewController(withIdentifier: "FixtureOverview") as! FixtureOverviewViewController
        mybanter.season_id = season_id
        mybanter.dic = dict
        mybanter.fixtureOverViewData = fixtureData
        childVCs.append(mybanter)
        let Commentary : FixtureCommentaryViewController = storyBoard.instantiateViewController(withIdentifier: "Commentary") as! FixtureCommentaryViewController
        if let fixtureid = fixtureData?.id! {
           Commentary.Fixture_id = fixtureid
        } else {
            Commentary.Fixture_id = 0
        }
        Commentary.dic = dict
        Commentary.fixtureComentryData = fixtureData
        childVCs.append(Commentary)
        let FixtureLineUp : FixtureLineUpViewController = storyBoard.instantiateViewController(withIdentifier: "FixtureLineUp") as! FixtureLineUpViewController
        if let fixtureid = fixtureData?.id! {
           FixtureLineUp.Fixture_id = fixtureid
        } else {
            FixtureLineUp.Fixture_id = 0
        }
        FixtureLineUp.dic = dict
        FixtureLineUp.fixtureLineupData = fixtureData
        childVCs.append(FixtureLineUp)
        let FixtureState : FixtureStateViewController = storyBoard.instantiateViewController(withIdentifier: "FixtureState") as! FixtureStateViewController
        // FixtureLineUp.Fixture_id = dic.value(forKey: "fixture_id") as AnyObject
        FixtureState.dic = dict
        FixtureState.fixtureStateData = fixtureData
        childVCs.append(FixtureState)
        ///######## 3. Configuring barStyle
        var style = AHCategoryNavBarStyle()
        //        style.contentInset.left = 100.0
        //        style.contentInset.right = 100.0
        style.height = 37.0
        style.fontSize = 18.0
        style.selectedFontSize = 20.0
        style.interItemSpace = 5.0
        style.itemPadding = 8.0
        style.isScrollable = true
        style.layoutAlignment = .left
        style.isEmbeddedToView = true
        style.showBottomSeparator = false
        style.showIndicator = true
        style.normalColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        style.selectedColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).withAlphaComponent(0.7)
        //style.showBgMaskView = true
        // style.bgMaskViewColor = UIColor.lightGray
        //(parentview?.frame.size.height)!
        let parentheight = view.frame.size.height
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        let atualheight = parentheight -  topBarHeight
        //######### 4. Attaching categoryView to view.addSubview
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: atualheight)
        let categoryView = AHCategoryView(frame: frame, categories: items, childVCs: childVCs, parentVC: self, barStyle: style)
        
        categoryView.interControllerSpacing = 0
        parentview?.addSubview(categoryView)
        self.categoryView = categoryView
        // parentview = categoryView
        //refreshBadgeCount()
        categoryView.select(at: 0)
    }
    
}

//MARK: - Embeded the navBar into a UINavigationBar
extension FixturescoreViewController {
    func embeddedIntoTheNavigationBar() {
        // adding a separate button to the right of the navBar, for fun.
        let searchBtn = UIButton(type: .custom)
        let searchImg = UIImage(named: "search-magnifier")
        searchBtn.setImage(searchImg, for: .normal)
        searchBtn.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        
        ///######## 1. Adding items
        var meItem = AHCategoryItem()
        meItem.normalImage = UIImage(named: "me-normal")
        meItem.selectedImage = UIImage(named: "me-selected")
        
        
        var featureItem = AHCategoryItem()
        featureItem.title = "Feature"
        var chartItem = AHCategoryItem()
        chartItem.title = "Charts"
        var categoryItem = AHCategoryItem()
        categoryItem.title = "Categories"
        var radioItem = AHCategoryItem()
        radioItem.title = "Radio"
        var liveItem = AHCategoryItem()
        liveItem.title = "Live"
        
        
        let items = [meItem, featureItem, chartItem, categoryItem, radioItem, liveItem]
        
        ///######## 2. Adding VCs
        for _ in 0..<5 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random()
            childVCs.append(vc)
        }
        
        
        ///######## 3. Configuring barStyle
        
        var style = AHCategoryNavBarStyle()
        //        style.contentInset = .zero
        style.interItemSpace = 8.0
        style.itemPadding = 8.0
        style.isScrollable = false
        style.layoutAlignment = .left
        ///NOTE: If you want to embed categoryView.navBar into a navigationItem.titleView or some other view, you have to set style.isEmbeddedToView = false.
        style.isEmbeddedToView = false
        style.showBottomSeparator = false
        style.indicatorColor = UIColor(red: 244.0/255.0, green: 173.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        style.normalColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        style.selectedColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        let parentheight = (parentview?.frame.size.height)!
        //######### 4. Attaching categoryView to navigationItem.titleView
        let frame = CGRect(x: 0, y: 64.0, width: (parentview?.frame.size.width)!, height: parentheight)
        let categoryView = AHCategoryView(frame: frame, categories: items, childVCs: childVCs, parentVC: self, barStyle: style)
        self.view.addSubview(categoryView)
        self.parentview = categoryView
        categoryView.navBar.frame = CGRect(x: 0, y: 0, width: 359.0, height: 44.0)
        categoryView.navBar.backgroundColor = UIColor.clear
        categoryView.select(at: 1)
        categoryView.setBadge(atIndex: 0, badgeNumber: 10)
        categoryView.setBadge(atIndex: 2, badgeNumber: 3)
        self.navigationItem.titleView = categoryView.navBar
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}
