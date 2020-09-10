//
//  TDSquadViewController.swift
//  FootballFan
//
//  Created by Apple on 01/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class TDSquadViewController: UIViewController {
   var season_id: AnyObject = 0 as AnyObject
       
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
   // @IBOutlet weak var storytableview: UITableView?
    var arrstanding: [AnyObject] = []
    @IBOutlet weak var segments: UISegmentedControl?
    override func viewDidLoad() {
        super.viewDidLoad()
     // smatchdayapiCall()
        //storytableview?.delegate = self
        //storytableview?.dataSource = self
        self.segments?.layer.cornerRadius = 15.0
      // self.segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
      // self.segmentedControl.layer.borderWidth = 1.0f;
       self.segments?.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
       
      }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
         switch sender.selectedSegmentIndex {
         case 0:
             selectedsegmentindex = 0
             //storytableview?.reloadData()
         case 1:
             selectedsegmentindex = 1
            // storytableview?.reloadData()
         case 2:
             selectedsegmentindex = 2
            // storytableview?.reloadData()
         default:
             break;
         }
     }
}
