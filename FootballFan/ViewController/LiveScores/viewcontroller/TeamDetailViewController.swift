//
//  TeamDetailViewController.swift
//  FootballFan
//
//  Created by Apple on 28/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class TeamDetailViewController: UIViewController {
    fileprivate weak var categoryView: AHCategoryView!
    var childVCs = [UIViewController]()
    @IBOutlet weak var parentview: UIView?
    var apd = UIApplication.shared.delegate as! AppDelegate
    var season_id = 0
    var team_id: AnyObject  = 0 as AnyObject
    var Teamname:String = ""
    // var dic: NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        embeddedIntoTheNavigationBar()
        pinterest()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        //self.title = legname
        self.title = Teamname
        let button2 = UIBarButtonItem(image: UIImage(named: "shear_dark"), style: .plain, target: self, action: #selector(self.Showcalender(sender:)))
        let rightSearchBarButtonItem1:UIBarButtonItem = button2
        
        /*  let rightSearchBarButtonItem2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.Getsliderdata))*/
        
        
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem1], animated: true)
        
    }
    
    @objc func Showcalender(sender:UIButton) {
    }
}


//MARK:- Pinterest NavBar Style
extension TeamDetailViewController {
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
        chartItem.title = "Stats"
        var transfersItem = AHCategoryItem()
        transfersItem.title = "Squad"
        var teamsItem = AHCategoryItem()
        teamsItem.title = "News"
        
        let items = [featureItem, chartItem,transfersItem]
        ///######## 2. Adding VCs
        let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
        let mybanter : TDOverviewViewController = storyBoard.instantiateViewController(withIdentifier: "teamoverview") as! TDOverviewViewController
        mybanter.season_id = season_id
        mybanter.team_id = team_id as! Int
        childVCs.append(mybanter)
        
        let TDstats : TDstatsViewController = storyBoard.instantiateViewController(withIdentifier: "TDstats") as! TDstatsViewController
        TDstats.season_id = season_id
        TDstats.team_id = team_id as! Int
        childVCs.append(TDstats)
        
        let TDsquad : TDSquadViewController = storyBoard.instantiateViewController(withIdentifier: "Squad") as! TDSquadViewController
        TDsquad.season_id = season_id
        TDsquad.teamId = team_id as! Int
        childVCs.append(TDsquad)
        
        
        ///######## 3. Configuring barStyle
        var style = AHCategoryNavBarStyle()
        //        style.contentInset.left = 100.0
        //        style.contentInset.right = 100.0
        style.height = 37.0
        style.fontSize = 18.0
        style.selectedFontSize = 20.0
        style.interItemSpace = 5.0
        style.itemPadding = 8.0
        style.isScrollable = false
        style.layoutAlignment = .center
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
    }
    
}
