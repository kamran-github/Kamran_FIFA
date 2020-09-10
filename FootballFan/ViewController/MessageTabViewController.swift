//
//  MessageTabViewController.swift
//  FootballFan
//
//  Created by Apple on 02/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class MessageTabViewController: UIViewController {
    fileprivate weak var categoryView: AHCategoryView!
    var childVCs = [UIViewController]()
      @IBOutlet weak var parentview: UIView?
    var apd = UIApplication.shared.delegate as! AppDelegate
          
       
    override func viewDidLoad() {
        super.viewDidLoad()
//        embeddedIntoTheNavigationBar()
        pinterest()
        let notificationName8 = Notification.Name("RefreshSubTabBadgeCount")
           // Register to receive notification
           NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadgeCount), name: notificationName8, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.parent?.navigationItem.rightBarButtonItems = nil
           self.parent?.navigationItem.leftBarButtonItems = nil
           self.parent?.title = "Rooms"
        
      }
       @objc func refreshBadgeCount(){
               DispatchQueue.main.async {
                   
                  if(self.apd.badgeCount("banter") != 0)
                                    {
                                        self.categoryView.setBadge(atIndex: 0, badgeNumber: self.apd.badgeCount("banter"))
                                      
                                    } else {
                    self.categoryView.setBadge(atIndex: 0, badgeNumber: 0)
                                    }
                       // Now set the badge of the third tab
                    if(self.apd.badgeCount("chat") != 0)
                       {
                        self.categoryView.setBadge(atIndex: 1, badgeNumber: self.apd.badgeCount("chat"))
                       } else {
                        self.categoryView.setBadge(atIndex: 1, badgeNumber: 0)
                       }
                       
                    
                 
               
           }
    }

}


//MARK:- Pinterest NavBar Style
extension MessageTabViewController {
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
        featureItem.title = "Banter"
        var chartItem = AHCategoryItem()
        chartItem.title = "Chats"
        let items = [featureItem, chartItem]
        ///######## 2. Adding VCs
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mybanter : BantersViewController = storyBoard.instantiateViewController(withIdentifier: "Banters") as! BantersViewController
       // let navigationController2: UINavigationController = UINavigationController.init(rootViewController: storyBoard.instantiateViewController(withIdentifier: "Banters"))
        
        childVCs.append(mybanter)
        let myChats : ChatsViewController = storyBoard.instantiateViewController(withIdentifier: "Chats") as! ChatsViewController
        // let navigationController2: UINavigationController = UINavigationController.init(rootViewController: storyBoard.instantiateViewController(withIdentifier: "Banters"))
         childVCs.append(myChats)
        
      /* for _ in 0..<8 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random()
            childVCs.append(vc)
        }
        //let bantervc:BantersViewController = Bundle.main.loadNibNamed("Banters", owner: self, options: nil)?.first as! BantersViewController
        let bantervc = BantersViewController()
        childVCs.append(bantervc)
        //let chats = ChatsViewController()
        //childVCs.append(chats)
        let targetViewController = BantersViewController()
        //targetViewController.title = "Target"
        //targetViewController.view.backgroundColor = .white
        let targetNavigationController: UINavigationController = UINavigationController(rootViewController: targetViewController)
        childVCs.append(targetNavigationController)
        let umbrellaViewController = ChatsViewController()
        //umbrellaViewController.title = "Umbrella"
        //umbrellaViewController.view.backgroundColor = .white
        let umbrellaNavigationController: UINavigationController = UINavigationController(rootViewController: umbrellaViewController)
        childVCs.append(umbrellaNavigationController)*/
        
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
        
        let parentheight = view.frame.size.height
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let tabheight = (tabBarController?.tabBar.frame.size.height)!
        let atualheight = parentheight - (tabheight + topBarHeight)
        //######### 4. Attaching categoryView to view.addSubview
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: atualheight)
        let categoryView = AHCategoryView(frame: frame, categories: items, childVCs: childVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 10.0
        parentview?.addSubview(categoryView)
        self.categoryView = categoryView
       // parentview = categoryView
        refreshBadgeCount()
    }
 
}

//MARK: - Embeded the navBar into a UINavigationBar
extension MessageTabViewController {
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




