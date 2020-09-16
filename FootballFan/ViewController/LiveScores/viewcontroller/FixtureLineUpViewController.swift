//
//  FixtureLineUpViewController.swift
//  FootballFan
//
//  Created by Apple on 05/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
class FixtureLineUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   var season_id = 0  
    var fixtureLineupData : Fixture?
    var apd = UIApplication.shared.delegate as! AppDelegate
    var selectedsegmentindex:Int = 0
    
    @IBOutlet weak var storytableview: UITableView?
    @IBOutlet weak var goalfkeeper: UIView?
     @IBOutlet weak var backplayer1: UIView?
     @IBOutlet weak var backplayer2: UIView?
     @IBOutlet weak var backplayer3: UIView?
     @IBOutlet weak var backplayer4: UIView?
    @IBOutlet weak var backplayer5: UIView?
    @IBOutlet weak var Dmidfieldplayer1: UIView?
    @IBOutlet weak var Dmidfieldplayer2: UIView?
    @IBOutlet weak var Dmidfieldplayer3: UIView?
    @IBOutlet weak var Dmidfieldplayer4: UIView?
    @IBOutlet weak var Dmidfieldplayer5: UIView?
    @IBOutlet weak var midfieldplayer1: UIView?
    @IBOutlet weak var midfieldplayer2: UIView?
    @IBOutlet weak var midfieldplayer3: UIView?
    @IBOutlet weak var midfieldplayer4: UIView?
     @IBOutlet weak var midfieldplayer5: UIView?
    @IBOutlet weak var wingerplayer1: UIView?
    @IBOutlet weak var wingerplayer2: UIView?
    @IBOutlet weak var wingerplayer3: UIView?
    @IBOutlet weak var wingerplayer4: UIView?
    @IBOutlet weak var wingerplayer5: UIView?
    @IBOutlet weak var centerforwordplayer1: UIView?
    @IBOutlet weak var centerforwordplayer2: UIView?
    @IBOutlet weak var centerforwordplayer3: UIView?
    @IBOutlet weak var centerforwordplayer4: UIView?
    @IBOutlet weak var centerforwordplayer5: UIView?
    
    @IBOutlet weak var imggoalfkeeper: UIImageView?
     @IBOutlet weak var imgbackplayer1: UIImageView?
     @IBOutlet weak var imgbackplayer2: UIImageView?
     @IBOutlet weak var imgbackplayer3: UIImageView?
     @IBOutlet weak var imgbackplayer4: UIImageView?
    @IBOutlet weak var imgbackplayer5: UIImageView?
    @IBOutlet weak var imgDmidfieldplayer1: UIImageView?
    @IBOutlet weak var imgDmidfieldplayer2: UIImageView?
    @IBOutlet weak var imgDmidfieldplayer3: UIImageView?
    @IBOutlet weak var imgDmidfieldplayer4: UIImageView?
    @IBOutlet weak var imgDmidfieldplayer5: UIImageView?
    @IBOutlet weak var imgmidfieldplayer1: UIImageView?
    @IBOutlet weak var imgmidfieldplayer2: UIImageView?
    @IBOutlet weak var imgmidfieldplayer3: UIImageView?
    @IBOutlet weak var imgmidfieldplayer4: UIImageView?
    @IBOutlet weak var imgmidfieldplayer5: UIImageView?
    @IBOutlet weak var imgwingerplayer1: UIImageView?
    @IBOutlet weak var imgwingerplayer2: UIImageView?
    @IBOutlet weak var imgwingerplayer3: UIImageView?
    @IBOutlet weak var imgwingerplayer4: UIImageView?
    @IBOutlet weak var imgwingerplayer5: UIImageView?
    @IBOutlet weak var imgcenterforwordplayer1: UIImageView?
    @IBOutlet weak var imgcenterforwordplayer2: UIImageView?
    @IBOutlet weak var imgcenterforwordplayer3: UIImageView?
    @IBOutlet weak var imgcenterforwordplayer4: UIImageView?
    @IBOutlet weak var imgcenterforwordplayer5: UIImageView?
    
    @IBOutlet weak var namegoalfkeeper: UILabel?
     @IBOutlet weak var namebackplayer1: UILabel?
     @IBOutlet weak var namebackplayer2: UILabel?
     @IBOutlet weak var namebackplayer3: UILabel?
     @IBOutlet weak var namebackplayer4: UILabel?
    @IBOutlet weak var namebackplayer5: UILabel?
    @IBOutlet weak var nameDmidfieldplayer1: UILabel?
    @IBOutlet weak var nameDmidfieldplayer2: UILabel?
    @IBOutlet weak var nameDmidfieldplayer3: UILabel?
    @IBOutlet weak var nameDmidfieldplayer4: UILabel?
    @IBOutlet weak var nameDmidfieldplayer5: UILabel?
    @IBOutlet weak var namemidfieldplayer1: UILabel?
    @IBOutlet weak var namemidfieldplayer2: UILabel?
    @IBOutlet weak var namemidfieldplayer3: UILabel?
    @IBOutlet weak var namemidfieldplayer4: UILabel?
    @IBOutlet weak var namemidfieldplayer5: UILabel?
    @IBOutlet weak var namewingerplayer1: UILabel?
    @IBOutlet weak var namewingerplayer2: UILabel?
    @IBOutlet weak var namewingerplayer3: UILabel?
    @IBOutlet weak var namewingerplayer4: UILabel?
    @IBOutlet weak var namewingerplayer5: UILabel?
    @IBOutlet weak var namecenterforwordplayer1: UILabel?
    @IBOutlet weak var namecenterforwordplayer2: UILabel?
    @IBOutlet weak var namecenterforwordplayer3: UILabel?
    @IBOutlet weak var namecenterforwordplayer4: UILabel?
    @IBOutlet weak var namecenterforwordplayer5: UILabel?
    
    @IBOutlet weak var Bgoalfkeeper: UILabel?
     @IBOutlet weak var Bbackplayer1: UILabel?
     @IBOutlet weak var Bbackplayer2: UILabel?
     @IBOutlet weak var Bbackplayer3: UILabel?
     @IBOutlet weak var Bbackplayer4: UILabel?
    @IBOutlet weak var Bbackplayer5: UILabel?
    @IBOutlet weak var BDmidfieldplayer1: UILabel?
    @IBOutlet weak var BDmidfieldplayer2: UILabel?
    @IBOutlet weak var BDmidfieldplayer3: UILabel?
    @IBOutlet weak var BDmidfieldplayer4: UILabel?
    @IBOutlet weak var BDmidfieldplayer5: UILabel?
    @IBOutlet weak var Bmidfieldplayer1: UILabel?
    @IBOutlet weak var Bmidfieldplayer2: UILabel?
    @IBOutlet weak var Bmidfieldplayer3: UILabel?
    @IBOutlet weak var Bmidfieldplayer4: UILabel?
    @IBOutlet weak var Bmidfieldplayer5: UILabel?
    @IBOutlet weak var Bwingerplayer1: UILabel?
    @IBOutlet weak var Bwingerplayer2: UILabel?
    @IBOutlet weak var Bwingerplayer3: UILabel?
    @IBOutlet weak var Bwingerplayer4: UILabel?
     @IBOutlet weak var Bwingerplayer5: UILabel?
    @IBOutlet weak var Bcenterforwordplayer1: UILabel?
    @IBOutlet weak var Bcenterforwordplayer2: UILabel?
    @IBOutlet weak var Bcenterforwordplayer3: UILabel?
    @IBOutlet weak var Bcenterforwordplayer4: UILabel?
    @IBOutlet weak var Bcenterforwordplayer5: UILabel?
    
    @IBOutlet weak var goalfkeeperXConstraint: NSLayoutConstraint?
        @IBOutlet weak var backplayer1XConstraint: NSLayoutConstraint?
        @IBOutlet weak var backplayer2XConstraint: NSLayoutConstraint?
        @IBOutlet weak var backplayer3XConstraint: NSLayoutConstraint?
        @IBOutlet weak var backplayer4XConstraint: NSLayoutConstraint?
    @IBOutlet weak var backplayer5XConstraint: NSLayoutConstraint?
       @IBOutlet weak var Dmidfieldplayer1XConstraint: NSLayoutConstraint?
       @IBOutlet weak var Dmidfieldplayer2XConstraint: NSLayoutConstraint?
       @IBOutlet weak var Dmidfieldplayer3XConstraint: NSLayoutConstraint?
       @IBOutlet weak var Dmidfieldplayer4XConstraint: NSLayoutConstraint?
     @IBOutlet weak var Dmidfieldplayer5XConstraint: NSLayoutConstraint?
       @IBOutlet weak var midfieldplayer1XConstraint: NSLayoutConstraint?
       @IBOutlet weak var midfieldplayer2XConstraint: NSLayoutConstraint?
       @IBOutlet weak var midfieldplayer3XConstraint: NSLayoutConstraint?
       @IBOutlet weak var midfieldplayer4XConstraint: NSLayoutConstraint?
    @IBOutlet weak var midfieldplayer5XConstraint: NSLayoutConstraint?
       @IBOutlet weak var wingerplayer1XConstraint: NSLayoutConstraint?
       @IBOutlet weak var wingerplayer2XConstraint: NSLayoutConstraint?
       @IBOutlet weak var wingerplayer3XConstraint: NSLayoutConstraint?
       @IBOutlet weak var wingerplayer4XConstraint: NSLayoutConstraint?
    @IBOutlet weak var wingerplayer5XConstraint: NSLayoutConstraint?
       @IBOutlet weak var centerforwordplayer1XConstraint: NSLayoutConstraint?
       @IBOutlet weak var centerforwordplayer2XConstraint: NSLayoutConstraint?
       @IBOutlet weak var centerforwordplayer3XConstraint: NSLayoutConstraint?
       @IBOutlet weak var centerforwordplayer4XConstraint: NSLayoutConstraint?
    @IBOutlet weak var centerforwordplayer5XConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var childheightConstraint: NSLayoutConstraint?
    @IBOutlet weak var goalfkeeperYConstraint: NSLayoutConstraint?
    
     @IBOutlet weak var backplayer1YConstraint: NSLayoutConstraint?
     @IBOutlet weak var backplayer2YConstraint: NSLayoutConstraint?
     @IBOutlet weak var backplayer3YConstraint: NSLayoutConstraint?
     @IBOutlet weak var backplayer4YConstraint: NSLayoutConstraint?
    @IBOutlet weak var backplayer5YConstraint: NSLayoutConstraint?
    @IBOutlet weak var Dmidfieldplayer1YConstraint: NSLayoutConstraint?
    @IBOutlet weak var Dmidfieldplayer2YConstraint: NSLayoutConstraint?
    @IBOutlet weak var Dmidfieldplayer3YConstraint: NSLayoutConstraint?
    @IBOutlet weak var Dmidfieldplayer4YConstraint: NSLayoutConstraint?
     @IBOutlet weak var Dmidfieldplayer5YConstraint: NSLayoutConstraint?
    @IBOutlet weak var midfieldplayer1YConstraint: NSLayoutConstraint?
    @IBOutlet weak var midfieldplayer2YConstraint: NSLayoutConstraint?
    @IBOutlet weak var midfieldplayer3YConstraint: NSLayoutConstraint?
    @IBOutlet weak var midfieldplayer4YConstraint: NSLayoutConstraint?
    @IBOutlet weak var midfieldplayer5YConstraint: NSLayoutConstraint?
    @IBOutlet weak var wingerplayer1YConstraint: NSLayoutConstraint?
    @IBOutlet weak var wingerplayer2YConstraint: NSLayoutConstraint?
    @IBOutlet weak var wingerplayer3YConstraint: NSLayoutConstraint?
    @IBOutlet weak var wingerplayer4YConstraint: NSLayoutConstraint?
    @IBOutlet weak var wingerplayer5YConstraint: NSLayoutConstraint?
    @IBOutlet weak var centerforwordplayer1YConstraint: NSLayoutConstraint?
    @IBOutlet weak var centerforwordplayer2YConstraint: NSLayoutConstraint?
    @IBOutlet weak var centerforwordplayer3YConstraint: NSLayoutConstraint?
    @IBOutlet weak var centerforwordplayer4YConstraint: NSLayoutConstraint?
    @IBOutlet weak var centerforwordplayer5YConstraint: NSLayoutConstraint?
    var homeId:Int = 0
    var visitorId:Int = 0
    var homeLineup: [AnyObject] = []
    var visitorLineup: [AnyObject] = []
    var homeBench: [AnyObject] = []
    var visitorBench: [AnyObject] = []
    @IBOutlet weak var segments: UISegmentedControl?
    @IBOutlet weak var childView :UIView?
    var formation:String = ""
     var dic: NSDictionary = NSDictionary()
      var Fixture_id: AnyObject  = 0 as AnyObject
    override func viewDidLoad() {
        super.viewDidLoad()
     // smatchdayapiCall()
        print(dic)
       storytableview?.delegate = self
        storytableview?.dataSource = self
        storytableview?.isScrollEnabled = false
      // storytableview?.estimatedRowHeight = 120
                  //  storytableview?.rowHeight = UITableView.automaticDimension
        if let localTeam = dic.value(forKey: "localTeam") {
                               if let localTeamDetil = (localTeam as AnyObject).value(forKey: "data") {
                            
                                   if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                    let  homename = name as! String
                                     let  homelogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                        // hometeam?.text = homename
                                         
                                         homeId = (localTeamDetil as AnyObject).value(forKey: "id") as! Int
                                         // let homelogourl = URL(string: homelogo as! String )
                                              //  let data = try? Data(contentsOf: homelogourl!)
                                                // segments?.setImage(UIImage.textEmbeded(image:UIImage(data: data!)! , string: homename, isImageBeforeText: true), forSegmentAt: 0)
                                    segments?.setTitle(homename, forSegmentAt: 0)
                                }
                            }}
                        if let visitorTeam = dic.value(forKey: "visitorTeam") {
                          if let localTeamDetil = (visitorTeam as AnyObject).value(forKey: "data") {
                        
                              if let name = (localTeamDetil as AnyObject).value(forKey: "name"){
                                 let visitorname = name as! String
                               // let visitorlogo = (localTeamDetil as AnyObject).value(forKey: "logo_path") as! String
                                                                   
                                       segments?.setTitle(visitorname, forSegmentAt: 1)
                                 visitorId = (localTeamDetil as AnyObject).value(forKey: "id") as! Int
                                //let  visitorlogourl = URL(string: visitorlogo)
                                        //let data1 = try? Data(contentsOf: visitorlogourl!)
                                       //segments?.setImage(UIImage.textEmbeded(image:UIImage(data: data1!)! , string: visitorname, isImageBeforeText: true), forSegmentAt: 1)
                            }}}
        let objformation = dic.value(forKey: "formations") as! NSDictionary
       if apd.isNsnullOrNil(object: objformation.value(forKey: "localteam_formation") as AnyObject?)
                  {
                     childView?.isHidden = true
        }
       else{
          formation = objformation.value(forKey: "localteam_formation") as! String
          apilocalCall()
        }
        if apd.isNsnullOrNil(object: objformation.value(forKey: "visitorteam_formation") as AnyObject?)
                         {
                            childView?.isHidden = true
               }
              else{
            apivisitorCall()
              //visitorLineup = dic.value(forKey: "visitorLineup") as! [AnyObject]
               }
       
        
        
       
       // formation = objformation.value(forKey: "localteam_formation") as! String
       
        let eventheader = 40
        let totelheight = 620 + (homeBench.count * 50) + eventheader
        childheightConstraint?.constant = CGFloat(totelheight)
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
       
      }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
         switch sender.selectedSegmentIndex {
         case 0:
             selectedsegmentindex = 0
             let objformation = dic.value(forKey: "formations") as! NSDictionary
            if apd.isNsnullOrNil(object: objformation.value(forKey: "localteam_formation") as AnyObject?)
                             {
                                childView?.isHidden = true
                   }
                  else{
                      childView?.isHidden = false
                                 formation = objformation.value(forKey: "localteam_formation") as! String
                                 let objcolors = dic.value(forKey: "colors") as! NSDictionary
                                 let localteamcolor = objcolors.value(forKey: "localteam") as! NSDictionary
                                 FormationReset(color: localteamcolor.value(forKey: "color") as! String)
                                let eventheader = 40
                                       let totelheight = 620 + (homeBench.count * 50) + eventheader
                                 childheightConstraint?.constant = CGFloat(totelheight)
                                 storytableview?.reloadData()
                   }
            
         case 1:
             selectedsegmentindex = 1
             let objformation = dic.value(forKey: "formations") as! NSDictionary
             if apd.isNsnullOrNil(object: objformation.value(forKey: "visitorteam_formation") as AnyObject?)
                                     {
                                        childView?.isHidden = true
                           }
                          else{
                childView?.isHidden = false
                      formation = objformation.value(forKey: "visitorteam_formation") as! String
                         let objcolors = dic.value(forKey: "colors") as! NSDictionary
                         let localteamcolor = objcolors.value(forKey: "visitorteam") as! NSDictionary
                        
                         FormationReset(color: localteamcolor.value(forKey: "color") as! String)
                        let eventheader = 40
                               let totelheight = 620 + (visitorBench.count * 50) + eventheader
                         childheightConstraint?.constant = CGFloat(totelheight)
                        storytableview?.reloadData()
                          //visitorLineup = dic.value(forKey: "visitorLineup") as! [AnyObject]
                           }
             
         default:
             break;
         }
     }
    func FormationReset(color:String)  {
        let hashcolor = color.replace(target: "#", withString: "")
        centerforwordplayer1?.isHidden = true
                centerforwordplayer2?.isHidden = true
                centerforwordplayer3?.isHidden = true
                centerforwordplayer4?.isHidden = true
        centerforwordplayer5?.isHidden = true
         centerforwordplayer1XConstraint?.constant = 0
        centerforwordplayer1YConstraint?.constant = 0
        centerforwordplayer2XConstraint?.constant = 0
        centerforwordplayer2YConstraint?.constant = 0
        centerforwordplayer3XConstraint?.constant = 0
        centerforwordplayer3YConstraint?.constant = 0
        centerforwordplayer4XConstraint?.constant = 0
        centerforwordplayer4YConstraint?.constant = 0
        centerforwordplayer5XConstraint?.constant = 0
        centerforwordplayer5YConstraint?.constant = 0
        
        imgcenterforwordplayer1?.tintColor = UIColor.init(hex: hashcolor)
        imgcenterforwordplayer2?.tintColor = UIColor.init(hex: hashcolor)
       
        imgcenterforwordplayer3?.tintColor = UIColor.init(hex: hashcolor)
        imgcenterforwordplayer4?.tintColor = UIColor.init(hex: hashcolor)
        imgcenterforwordplayer5?.tintColor = UIColor.init(hex: hashcolor)
                wingerplayer1?.isHidden = true
                wingerplayer2?.isHidden = true
                wingerplayer3?.isHidden = true
                wingerplayer4?.isHidden = true
        wingerplayer5?.isHidden = true
        wingerplayer1XConstraint?.constant = 0
        wingerplayer1YConstraint?.constant = 0
        wingerplayer2XConstraint?.constant = 0
         wingerplayer2YConstraint?.constant = 0
         wingerplayer3XConstraint?.constant = 0
         wingerplayer3YConstraint?.constant = 0
         wingerplayer4XConstraint?.constant = 0
         wingerplayer4YConstraint?.constant = 0
        wingerplayer5XConstraint?.constant = 0
        wingerplayer5YConstraint?.constant = 0
        imgwingerplayer1?.tintColor = UIColor.init(hex: hashcolor)
        imgwingerplayer2?.tintColor = UIColor.init(hex: hashcolor)
        imgwingerplayer3?.tintColor = UIColor.init(hex: hashcolor)
        imgwingerplayer4?.tintColor = UIColor.init(hex: hashcolor)
        imgwingerplayer5?.tintColor = UIColor.init(hex: hashcolor)
                midfieldplayer1?.isHidden = true
                midfieldplayer2?.isHidden = true
                midfieldplayer3?.isHidden = true
                midfieldplayer4?.isHidden = true
        midfieldplayer5?.isHidden = true
        midfieldplayer1XConstraint?.constant = 0
        midfieldplayer1YConstraint?.constant = 0
        midfieldplayer2XConstraint?.constant = 0
               midfieldplayer2YConstraint?.constant = 0
        midfieldplayer3XConstraint?.constant = 0
        midfieldplayer3YConstraint?.constant = 0
        midfieldplayer4XConstraint?.constant = 0
        midfieldplayer4YConstraint?.constant = 0
        midfieldplayer5XConstraint?.constant = 0
        midfieldplayer5YConstraint?.constant = 0
        imgmidfieldplayer1?.tintColor = UIColor.init(hex: hashcolor)
        imgmidfieldplayer2?.tintColor = UIColor.init(hex: hashcolor)
        imgmidfieldplayer3?.tintColor = UIColor.init(hex: hashcolor)
        imgmidfieldplayer4?.tintColor = UIColor.init(hex: hashcolor)
        imgmidfieldplayer5?.tintColor = UIColor.init(hex: hashcolor)
                Dmidfieldplayer1?.isHidden = true
                 Dmidfieldplayer2?.isHidden = true
                 Dmidfieldplayer3?.isHidden = true
                 Dmidfieldplayer4?.isHidden = true
        Dmidfieldplayer5?.isHidden = true
                Dmidfieldplayer1XConstraint?.constant = 0
        Dmidfieldplayer1YConstraint?.constant = 0
        Dmidfieldplayer2XConstraint?.constant = 0
              Dmidfieldplayer2YConstraint?.constant = 0
        Dmidfieldplayer3XConstraint?.constant = 0
              Dmidfieldplayer3YConstraint?.constant = 0
        Dmidfieldplayer4XConstraint?.constant = 0
              Dmidfieldplayer4YConstraint?.constant = 0
        Dmidfieldplayer5XConstraint?.constant = 0
        Dmidfieldplayer5YConstraint?.constant = 0
        imgDmidfieldplayer1?.tintColor = UIColor.init(hex: hashcolor)
        imgDmidfieldplayer2?.tintColor = UIColor.init(hex: hashcolor)
         imgDmidfieldplayer3?.tintColor = UIColor.init(hex: hashcolor)
         imgDmidfieldplayer4?.tintColor = UIColor.init(hex: hashcolor)
         imgDmidfieldplayer5?.tintColor = UIColor.init(hex: hashcolor)
        
                
                
                backplayer1?.isHidden = true
                           backplayer2?.isHidden = true
                           backplayer3?.isHidden = true
                           backplayer4?.isHidden = true
        backplayer5?.isHidden = true
        backplayer1XConstraint?.constant = 0
         backplayer1YConstraint?.constant = 0
        backplayer2XConstraint?.constant = 0
        backplayer2YConstraint?.constant = 0
        backplayer3XConstraint?.constant = 0
        backplayer3YConstraint?.constant = 0
        backplayer4XConstraint?.constant = 0
        backplayer4YConstraint?.constant = 0
        backplayer5XConstraint?.constant = 0
        backplayer5YConstraint?.constant = 0
        imgbackplayer1?.tintColor = UIColor.init(hex: hashcolor)
        imgbackplayer2?.tintColor = UIColor.init(hex: hashcolor)
        imgbackplayer3?.tintColor = UIColor.init(hex: hashcolor)
        imgbackplayer4?.tintColor = UIColor.init(hex: hashcolor)
        imgbackplayer5?.tintColor = UIColor.init(hex: hashcolor)
        imggoalfkeeper?.tintColor = UIColor.init(hex: hashcolor)
        manageFormation()
    }
    func manageFormation()  {
        if(formation == "3-1-4-2"){
            
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            midfieldplayer1XConstraint?.constant = 30
            midfieldplayer2XConstraint?.constant = 30
            midfieldplayer4XConstraint?.constant = -30
            midfieldplayer5XConstraint?.constant = -30
            
            Bmidfieldplayer5?.text = getnumberplay(index: 5)
                       namemidfieldplayer5?.text = getplayername(index: 5)
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            Bmidfieldplayer2?.text = getnumberplay(index: 7)
            namemidfieldplayer2?.text = getplayername(index: 7)
            Bmidfieldplayer1?.text = getnumberplay(index: 8)
            namemidfieldplayer1?.text = getplayername(index: 8)
            
            Dmidfieldplayer3?.isHidden = false
            BDmidfieldplayer3?.text = getnumberplay(index: 4)
            nameDmidfieldplayer3?.text = getplayername(index: 4)
            
            
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            
            
            Bbackplayer4?.text = getnumberplay(index: 1)
            namebackplayer4?.text = getplayername(index: 1)
            
            
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
            
        }
        else  if(formation == "4-2-3-1"){
            
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            
            
            wingerplayer2?.isHidden = false
            wingerplayer3?.isHidden = false
            wingerplayer4?.isHidden = false
            wingerplayer2XConstraint?.constant = -39
            wingerplayer2YConstraint?.constant = 35
            
            wingerplayer3YConstraint?.constant = 35
            wingerplayer4XConstraint?.constant = 39
            wingerplayer4YConstraint?.constant = 35
            Bwingerplayer4?.text = getnumberplay(index: 9)
            namewingerplayer4?.text = getplayername(index: 9)
            Bwingerplayer3?.text = getnumberplay(index: 8)
            namewingerplayer3?.text = getplayername(index: 8)
            Bwingerplayer2?.text = getnumberplay(index: 7)
            namewingerplayer2?.text = getplayername(index: 7)
            
            
            
            
            
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            BDmidfieldplayer4?.text = getnumberplay(index: 6)
            nameDmidfieldplayer4?.text = getplayername(index: 6)
            BDmidfieldplayer2?.text = getnumberplay(index: 5)
                       nameDmidfieldplayer2?.text = getplayername(index: 5)
            
            
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bbackplayer5?.text = getnumberplay(index: 4)
                                  namebackplayer5?.text = getplayername(index: 4)
            Bbackplayer4?.text = getnumberplay(index: 3)
            namebackplayer4?.text = getplayername(index: 3)
            Bbackplayer2?.text = getnumberplay(index: 2)
            namebackplayer2?.text = getplayername(index: 2)
            Bbackplayer1?.text = getnumberplay(index: 1)
            namebackplayer1?.text = getplayername(index: 1)
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "3-5-2"){
            
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer3?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            Bmidfieldplayer5?.text = getnumberplay(index: 4)
            namemidfieldplayer5?.text = getplayername(index: 4)
            Bmidfieldplayer4?.text = getnumberplay(index: 5)
            namemidfieldplayer4?.text = getplayername(index: 5)
            Bmidfieldplayer3?.text = getnumberplay(index: 6)
            namemidfieldplayer3?.text = getplayername(index: 6)
            Bmidfieldplayer2?.text = getnumberplay(index: 7)
            namemidfieldplayer2?.text = getplayername(index: 7)
            Bmidfieldplayer1?.text = getnumberplay(index: 8)
            namemidfieldplayer1?.text = getplayername(index: 8)
            
            
            
            Dmidfieldplayer1?.isHidden = false
            Dmidfieldplayer3?.isHidden = false
            Dmidfieldplayer5?.isHidden = false
            BDmidfieldplayer5?.text = getnumberplay(index: 1)
            nameDmidfieldplayer5?.text = getplayername(index: 1)
            BDmidfieldplayer3?.text = getnumberplay(index: 2)
            nameDmidfieldplayer3?.text = getplayername(index: 2)
            BDmidfieldplayer1?.text = getnumberplay(index: 3)
            nameDmidfieldplayer1?.text = getplayername(index: 3)
            
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "3-2-4-1"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
                                             namecenterforwordplayer3?.text = getplayername(index: 10)
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            Bmidfieldplayer5?.text = getnumberplay(index: 6)
                                  namemidfieldplayer5?.text = getplayername(index: 6)
            Bmidfieldplayer4?.text = getnumberplay(index: 7)
                                    namemidfieldplayer4?.text = getplayername(index: 7)
            Bmidfieldplayer2?.text = getnumberplay(index: 8)
                                  namemidfieldplayer2?.text = getplayername(index: 8)
            Bmidfieldplayer1?.text = getnumberplay(index: 9)
                                    namemidfieldplayer1?.text = getplayername(index: 9)
            midfieldplayer1XConstraint?.constant = 30
            midfieldplayer2XConstraint?.constant = 30
            midfieldplayer4XConstraint?.constant = -30
            midfieldplayer5XConstraint?.constant = -30
            
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            BDmidfieldplayer4?.text = getnumberplay(index: 4)
                                  nameDmidfieldplayer4?.text = getplayername(index: 4)
            BDmidfieldplayer2?.text = getnumberplay(index: 5)
                                    nameDmidfieldplayer2?.text = getplayername(index: 5)
            
            
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            Bbackplayer4?.text = getnumberplay(index: 1)
            namebackplayer4?.text = getplayername(index: 1)
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "3-4-3"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 8)
            namewingerplayer5?.text = getplayername(index: 8)
            Bwingerplayer1?.text = getnumberplay(index: 9)
            namewingerplayer1?.text = getplayername(index: 9)
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            Bmidfieldplayer5?.text = getnumberplay(index: 4)
            namemidfieldplayer5?.text = getplayername(index: 4)
            Bmidfieldplayer4?.text = getnumberplay(index: 5)
            namemidfieldplayer4?.text = getplayername(index: 5)
            Bmidfieldplayer2?.text = getnumberplay(index: 6)
            namemidfieldplayer2?.text = getplayername(index: 6)
            Bmidfieldplayer1?.text = getnumberplay(index: 7)
            namemidfieldplayer1?.text = getplayername(index: 7)
            midfieldplayer1XConstraint?.constant = 30
            midfieldplayer2XConstraint?.constant = 30
            midfieldplayer4XConstraint?.constant = -30
            midfieldplayer5XConstraint?.constant = -30
            
            
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            Bbackplayer4?.text = getnumberplay(index: 1)
            namebackplayer4?.text = getplayername(index: 1)
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "4-1-4-1"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            Bmidfieldplayer5?.text = getnumberplay(index: 6)
            namemidfieldplayer5?.text = getplayername(index: 6)
            Bmidfieldplayer4?.text = getnumberplay(index: 7)
            namemidfieldplayer4?.text = getplayername(index: 7)
            Bmidfieldplayer2?.text = getnumberplay(index: 8)
            namemidfieldplayer2?.text = getplayername(index: 8)
            Bmidfieldplayer1?.text = getnumberplay(index: 9)
            namemidfieldplayer1?.text = getplayername(index: 9)
            midfieldplayer1XConstraint?.constant = 30
            midfieldplayer2XConstraint?.constant = 30
            midfieldplayer4XConstraint?.constant = -30
            midfieldplayer5XConstraint?.constant = -30
            
            Dmidfieldplayer3?.isHidden = false
            BDmidfieldplayer3?.text = getnumberplay(index: 5)
            nameDmidfieldplayer3?.text = getplayername(index: 5)
            
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "4-2-4"){
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 7)
            namewingerplayer5?.text = getplayername(index: 7)
            Bwingerplayer1?.text = getnumberplay(index: 8)
            namewingerplayer1?.text = getplayername(index: 8)
            
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 5)
            namemidfieldplayer4?.text = getplayername(index: 5)
            Bmidfieldplayer2?.text = getnumberplay(index: 6)
            namemidfieldplayer2?.text = getplayername(index: 6)
            
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "4-3-3"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 8)
            namewingerplayer5?.text = getplayername(index: 8)
            Bwingerplayer1?.text = getnumberplay(index: 9)
            namewingerplayer1?.text = getplayername(index: 9)
            
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            Bmidfieldplayer2?.text = getnumberplay(index: 7)
            namemidfieldplayer2?.text = getplayername(index: 7)
            
            Dmidfieldplayer3?.isHidden = false
            BDmidfieldplayer3?.text = getnumberplay(index: 5)
            nameDmidfieldplayer3?.text = getplayername(index: 5)
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "4-4-1-1"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            
            wingerplayer3?.isHidden = false
            Bwingerplayer3?.text = getnumberplay(index: 9)
            namewingerplayer3?.text = getplayername(index: 9)
            wingerplayer3YConstraint?.constant = 35
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            Bmidfieldplayer5?.text = getnumberplay(index: 5)
            namemidfieldplayer5?.text = getplayername(index: 5)
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            Bmidfieldplayer2?.text = getnumberplay(index: 7)
            namemidfieldplayer2?.text = getplayername(index: 7)
            Bmidfieldplayer1?.text = getnumberplay(index: 8)
            namemidfieldplayer1?.text = getplayername(index: 8)
            
            midfieldplayer1XConstraint?.constant = 30
            midfieldplayer2XConstraint?.constant = 30
            midfieldplayer4XConstraint?.constant = -30
            midfieldplayer5XConstraint?.constant = -30
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "4-4-2"){
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
                       namecenterforwordplayer4?.text = getplayername(index: 9)
                       
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
                       namecenterforwordplayer2?.text = getplayername(index: 10)
                       
            
            midfieldplayer1?.isHidden = false
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            midfieldplayer5?.isHidden = false
            Bmidfieldplayer5?.text = getnumberplay(index: 5)
                       namemidfieldplayer5?.text = getplayername(index: 5)
                       Bmidfieldplayer4?.text = getnumberplay(index: 6)
                       namemidfieldplayer4?.text = getplayername(index: 6)
                       Bmidfieldplayer2?.text = getnumberplay(index: 7)
                       namemidfieldplayer2?.text = getplayername(index: 7)
                       Bmidfieldplayer1?.text = getnumberplay(index: 8)
                       namemidfieldplayer1?.text = getplayername(index: 8)
            
            midfieldplayer1XConstraint?.constant = 30
            midfieldplayer2XConstraint?.constant = 30
            midfieldplayer4XConstraint?.constant = -30
            midfieldplayer5XConstraint?.constant = -30
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
                       namebackplayer5?.text = getplayername(index: 1)
                       Bbackplayer4?.text = getnumberplay(index: 2)
                       namebackplayer4?.text = getplayername(index: 2)
                       Bbackplayer2?.text = getnumberplay(index: 3)
                       namebackplayer2?.text = getplayername(index: 3)
                       Bbackplayer1?.text = getnumberplay(index: 4)
                       namebackplayer1?.text = getplayername(index: 4)
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "5-3-2"){
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            midfieldplayer2?.isHidden = false
            midfieldplayer3?.isHidden = false
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            Bmidfieldplayer3?.text = getnumberplay(index: 7)
            namemidfieldplayer3?.text = getplayername(index: 7)
            Bmidfieldplayer2?.text = getnumberplay(index: 8)
            namemidfieldplayer2?.text = getplayername(index: 8)
            
            
            midfieldplayer2XConstraint?.constant = -35
            midfieldplayer4XConstraint?.constant = 35
            
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer3?.text = getnumberplay(index: 3)
            namebackplayer3?.text = getplayername(index: 3)
            Bbackplayer2?.text = getnumberplay(index: 4)
            namebackplayer2?.text = getplayername(index: 4)
            Bbackplayer1?.text = getnumberplay(index: 5)
            namebackplayer1?.text = getplayername(index: 5)
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
            
        }
        else if(formation == "5-4-1"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 8)
            namewingerplayer5?.text = getplayername(index: 8)
            Bwingerplayer1?.text = getnumberplay(index: 9)
            namewingerplayer1?.text = getplayername(index: 9)
            
            midfieldplayer2?.isHidden = false
            
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            Bmidfieldplayer2?.text = getnumberplay(index: 7)
            namemidfieldplayer2?.text = getplayername(index: 7)
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer3?.text = getnumberplay(index: 3)
            namebackplayer3?.text = getplayername(index: 3)
            Bbackplayer2?.text = getnumberplay(index: 4)
            namebackplayer2?.text = getplayername(index: 4)
            Bbackplayer1?.text = getnumberplay(index: 5)
            namebackplayer1?.text = getplayername(index: 5)
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
            
        }
        else if(formation == "3-3-1-3"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 8)
            namewingerplayer5?.text = getplayername(index: 8)
            Bwingerplayer1?.text = getnumberplay(index: 9)
            namewingerplayer1?.text = getplayername(index: 9)
            
            
            midfieldplayer3?.isHidden = false
            Bmidfieldplayer3?.text = getnumberplay(index: 7)
            namemidfieldplayer3?.text = getplayername(index: 7)

            
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer3?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            BDmidfieldplayer4?.text = getnumberplay(index: 4)
            nameDmidfieldplayer4?.text = getplayername(index: 4)
            BDmidfieldplayer3?.text = getnumberplay(index: 5)
            nameDmidfieldplayer3?.text = getplayername(index: 5)
            BDmidfieldplayer2?.text = getnumberplay(index: 6)
            nameDmidfieldplayer2?.text = getplayername(index: 6)
            Dmidfieldplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            Dmidfieldplayer4XConstraint?.constant = 35
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            Bbackplayer4?.text = getnumberplay(index: 1)
                       namebackplayer4?.text = getplayername(index: 1)
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "3-3-3-1"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            // wingerplayer1?.isHidden = false
            // wingerplayer5?.isHidden = false
            wingerplayer2?.isHidden = false
            wingerplayer3?.isHidden = false
            wingerplayer4?.isHidden = false
            Bwingerplayer4?.text = getnumberplay(index: 7)
            namewingerplayer4?.text = getplayername(index: 7)
            Bwingerplayer3?.text = getnumberplay(index: 8)
            namewingerplayer3?.text = getplayername(index: 8)
            Bwingerplayer2?.text = getnumberplay(index: 9)
            namewingerplayer2?.text = getplayername(index: 9)
            wingerplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            wingerplayer4XConstraint?.constant = 35
            
            
            
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer3?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            BDmidfieldplayer4?.text = getnumberplay(index: 4)
            nameDmidfieldplayer4?.text = getplayername(index: 4)
            BDmidfieldplayer3?.text = getnumberplay(index: 5)
            nameDmidfieldplayer3?.text = getplayername(index: 5)
            BDmidfieldplayer2?.text = getnumberplay(index: 6)
            nameDmidfieldplayer2?.text = getplayername(index: 6)
            Dmidfieldplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            Dmidfieldplayer4XConstraint?.constant = 35
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            Bbackplayer4?.text = getnumberplay(index: 1)
            namebackplayer4?.text = getplayername(index: 1)
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "3-4-1-2"){
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            midfieldplayer3?.isHidden = false
            Bmidfieldplayer3?.text = getnumberplay(index: 8)
            namemidfieldplayer3?.text = getplayername(index: 8)
            
            Dmidfieldplayer1?.isHidden = false
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            Dmidfieldplayer5?.isHidden = false
            BDmidfieldplayer5?.text = getnumberplay(index: 4)
            nameDmidfieldplayer5?.text = getplayername(index: 4)
            BDmidfieldplayer4?.text = getnumberplay(index: 5)
            nameDmidfieldplayer4?.text = getplayername(index: 5)
            BDmidfieldplayer2?.text = getnumberplay(index: 6)
            nameDmidfieldplayer2?.text = getplayername(index: 6)
            BDmidfieldplayer1?.text = getnumberplay(index: 7)
                       nameDmidfieldplayer1?.text = getplayername(index: 7)
            
            Dmidfieldplayer1XConstraint?.constant = 30
            Dmidfieldplayer2XConstraint?.constant = 30
            Dmidfieldplayer4XConstraint?.constant = -30
            Dmidfieldplayer5XConstraint?.constant = -30
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            Bbackplayer4?.text = getnumberplay(index: 1)
            namebackplayer4?.text = getplayername(index: 1)
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
        }
        else if(formation == "3-4-2-1"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
            namecenterforwordplayer3?.text = getplayername(index: 10)
            
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 8)
            namewingerplayer5?.text = getplayername(index: 8)
            Bwingerplayer1?.text = getnumberplay(index: 9)
            namewingerplayer1?.text = getplayername(index: 9)
            
            Dmidfieldplayer1?.isHidden = false
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            Dmidfieldplayer5?.isHidden = false
            BDmidfieldplayer5?.text = getnumberplay(index: 4)
            nameDmidfieldplayer5?.text = getplayername(index: 4)
            BDmidfieldplayer4?.text = getnumberplay(index: 5)
            nameDmidfieldplayer4?.text = getplayername(index: 5)
            BDmidfieldplayer2?.text = getnumberplay(index: 6)
            nameDmidfieldplayer2?.text = getplayername(index: 6)
            BDmidfieldplayer1?.text = getnumberplay(index: 7)
            nameDmidfieldplayer1?.text = getplayername(index: 7)
            
            Dmidfieldplayer1XConstraint?.constant = 30
            Dmidfieldplayer2XConstraint?.constant = 30
            Dmidfieldplayer4XConstraint?.constant = -30
            Dmidfieldplayer5XConstraint?.constant = -30
            
            
            backplayer2?.isHidden = false
            backplayer3?.isHidden = false
            backplayer4?.isHidden = false
            Bbackplayer4?.text = getnumberplay(index: 1)
            namebackplayer4?.text = getplayername(index: 1)
            
            Bbackplayer3?.text = getnumberplay(index: 2)
            namebackplayer3?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            
            backplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            backplayer4XConstraint?.constant = 35
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
            
        }
        else if(formation == "4-1-2-3"){
            centerforwordplayer3?.isHidden = false
            Bcenterforwordplayer3?.text = getnumberplay(index: 10)
                       namecenterforwordplayer3?.text = getplayername(index: 10)
            
            wingerplayer1?.isHidden = false
            wingerplayer5?.isHidden = false
            Bwingerplayer5?.text = getnumberplay(index: 8)
                                  namewingerplayer5?.text = getplayername(index: 8)
            Bwingerplayer1?.text = getnumberplay(index: 9)
            namewingerplayer1?.text = getplayername(index: 9)
            
            midfieldplayer2?.isHidden = false
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            Bmidfieldplayer2?.text = getnumberplay(index: 7)
            namemidfieldplayer2?.text = getplayername(index: 7)
            
            Dmidfieldplayer3?.isHidden = false
            BDmidfieldplayer3?.text = getnumberplay(index: 5)
                                  nameDmidfieldplayer3?.text = getplayername(index: 5)
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
            
        }
        else if(formation == "4-1-3-2"){
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            
            midfieldplayer2?.isHidden = false
            midfieldplayer3?.isHidden = false
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 6)
            namemidfieldplayer4?.text = getplayername(index: 6)
            
            Bmidfieldplayer3?.text = getnumberplay(index: 7)
            namemidfieldplayer3?.text = getplayername(index: 7)
            
            Bmidfieldplayer2?.text = getnumberplay(index: 8)
            namemidfieldplayer2?.text = getplayername(index: 8)
            
            midfieldplayer2XConstraint?.constant = -39
            //backplayer3XConstraint?.constant = 35
            midfieldplayer4XConstraint?.constant = 35
            
            Dmidfieldplayer3?.isHidden = false
            BDmidfieldplayer3?.text = getnumberplay(index: 5)
            nameDmidfieldplayer3?.text = getplayername(index: 5)
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            
            
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
                       namegoalfkeeper?.text = getplayername(index: 0)
            
        }
        else if(formation == "4-2-2-2"){
            centerforwordplayer2?.isHidden = false
            centerforwordplayer4?.isHidden = false
            Bcenterforwordplayer4?.text = getnumberplay(index: 9)
            namecenterforwordplayer4?.text = getplayername(index: 9)
            Bcenterforwordplayer2?.text = getnumberplay(index: 10)
            namecenterforwordplayer2?.text = getplayername(index: 10)
            
            midfieldplayer2?.isHidden = false
            
            midfieldplayer4?.isHidden = false
            Bmidfieldplayer4?.text = getnumberplay(index: 7)
                       namemidfieldplayer4?.text = getplayername(index: 7)
                       Bmidfieldplayer2?.text = getnumberplay(index: 8)
                       namemidfieldplayer2?.text = getplayername(index: 8)
                       
            
            Dmidfieldplayer2?.isHidden = false
            Dmidfieldplayer4?.isHidden = false
            BDmidfieldplayer4?.text = getnumberplay(index: 5)
            nameDmidfieldplayer4?.text = getplayername(index: 5)
            BDmidfieldplayer2?.text = getnumberplay(index: 6)
            nameDmidfieldplayer2?.text = getplayername(index: 6)
            
            
            
            backplayer1?.isHidden = false
            backplayer2?.isHidden = false
            backplayer4?.isHidden = false
            backplayer5?.isHidden = false
            Bbackplayer5?.text = getnumberplay(index: 1)
            namebackplayer5?.text = getplayername(index: 1)
            Bbackplayer4?.text = getnumberplay(index: 2)
            namebackplayer4?.text = getplayername(index: 2)
            Bbackplayer2?.text = getnumberplay(index: 3)
            namebackplayer2?.text = getplayername(index: 3)
            Bbackplayer1?.text = getnumberplay(index: 4)
            namebackplayer1?.text = getplayername(index: 4)
            backplayer1XConstraint?.constant = 30
            backplayer2XConstraint?.constant = 30
            backplayer4XConstraint?.constant = -30
            backplayer5XConstraint?.constant = -30
            
            Bgoalfkeeper?.text = getnumberplay(index: 0)
            namegoalfkeeper?.text = getplayername(index: 0)
        }
    }
    func getnumberplay(index:Int)-> String{
        var number = ""
        if(selectedsegmentindex == 0){
           if(homeLineup.count>0){
            let dict1 = homeLineup[index] as! NSDictionary
                       
             number = String(dict1.value(forKey: "number") as! Int)
            }
            
        }
        else{
            if(visitorLineup.count>0){
            let dict1 = visitorLineup[index] as! NSDictionary
                           
            number = String(dict1.value(forKey: "number") as! Int)
            
            }
        }
        return number
    }
    func getplayername(index:Int)-> String{
        var playername = ""
        if(selectedsegmentindex == 0){
            if(homeLineup.count>0){
            let dict1 = homeLineup[index] as! NSDictionary
                       let detail = dict1.value(forKey: "detail") as! NSDictionary
            let firstname = detail.value(forKey: "firstname") as! String
            let iscaptain = dict1.value(forKey: "captain") as! Bool
            if(iscaptain){
                 playername = "\(firstname) (c)"
            }
            else{
                playername = firstname
            }
            }
        }
        else{
             if(visitorLineup.count>0){
            let dict1 = visitorLineup[index] as! NSDictionary
                           let detail = dict1.value(forKey: "detail") as! NSDictionary
            let firstname = detail.value(forKey: "firstname") as! String
                       let iscaptain = dict1.value(forKey: "captain") as! Bool
                       if(iscaptain){
                            playername = "\(firstname) (c)"
                       }
                       else{
                           playername = firstname
                       }
            }
        }
        return playername
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            //print(appDelegate().allContacts)
            //print(appDelegate().allContacts.count)
            
            
    return 1
                
          
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40.0
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            //let dic = appDelegate().arrStanding[section] as! NSDictionary
            //let date = dic.value(forKey: "date")
             
               return "Match Events"
           
        }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           
                let headerView:EventHeader = storytableview!.dequeueReusableCell(withIdentifier: "EventHeader") as! EventHeader
                               
            //let dic = arrstanding[section] as! NSDictionary
            headerView.headername?.text = "Banch"//dic.value(forKey: "result") as! String
                             // headerView.headerlabelHightConstraint2.constant = 0.0
                              
               return headerView
           
            
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              
            if(selectedsegmentindex == 0){
                return homeBench.count
            }
            else{
                return visitorBench.count
            }
              
              
           
           
            
        }
        /*  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 30.0
         }*/
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
            let cell:PlayerCell = storytableview!.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
            
            
           if(selectedsegmentindex == 0){
            let dict1 = homeBench[indexPath.row] as! NSDictionary
            let detail = dict1.value(forKey: "detail") as! NSDictionary
            cell.headername?.text = detail.value(forKey: "fullname") as? String
            cell.number?.text = "\(dict1.value(forKey: "number") as! Int)"
              let  homelogo = detail.value(forKey: "image_path") as! String
                 
              let url = URL(string:homelogo)!
                                                       
            cell.playerimg?.af.setImage(withURL: url)
            let position = dict1.value(forKey: "position") as! String
             if(position == "A"){
                                       cell.playstate?.text = "Attacker"
                                             }
                                             else if(position == "M"){
                                       cell.playstate?.text = ""
                                             }
                                             else if(position == "G"){
                                       cell.playstate?.text = "Goalkeeper "
                                             }
                                             else if(position == "D"){
                                       cell.playstate?.text = "Defender"
                                             }
                                             else if(position == "F"){
                                       cell.playstate?.text = "ForWard"
                                             }
                                             else{
                                       cell.playstate?.text = position
                                             }
               
           }
           else if(selectedsegmentindex == 1){
                let dict1 = visitorBench[indexPath.row] as! NSDictionary
                let detail = dict1.value(forKey: "detail") as! NSDictionary
                cell.headername?.text = detail.value(forKey: "fullname") as? String
                           cell.number?.text = "\(dict1.value(forKey: "number") as! Int)"
                             let  homelogo = detail.value(forKey: "image_path") as! String
                                
                             let url = URL(string:homelogo)!
                                                                      
                           cell.playerimg?.af.setImage(withURL: url)
                           let position = dict1.value(forKey: "position") as! String
                           if(position == "A"){
                            cell.playstate?.text = "Attacker"
                                  }
                                  else if(position == "M"){
                            cell.playstate?.text = ""
                                  }
                                  else if(position == "G"){
                            cell.playstate?.text = "Goalkeeper "
                                  }
                                  else if(position == "D"){
                            cell.playstate?.text = "Defender"
                                  }
                                  else if(position == "F"){
                            cell.playstate?.text = "ForWard"
                                  }
                                  else{
                            cell.playstate?.text = position
                                  }
               
                
            }
          
           
            return cell
          
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
                      
                       let storyBoard = UIStoryboard(name: "LiveScoreStoryboard", bundle: nil)
                             let myTeamsController : PlayerViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerD") as!
                       PlayerViewController
                       if(selectedsegmentindex == 0){
                       let dict1 = homeBench[indexPath.row] as! NSDictionary
                         myTeamsController.dic = dict1 as NSDictionary
                       }else if (selectedsegmentindex == 1){
                        let dict1 = visitorBench[indexPath.row] as! NSDictionary
                         myTeamsController.dic = dict1 as NSDictionary
            }
                       
                            
                              show(myTeamsController, sender: self)
            
           
            
        }
    func apilocalCall(){
                  if ClassReachability.isConnectedToNetwork() {
                let url = "\(baseurl)/Lineup/Fixture/\(Fixture_id)/\(homeId)"
                       AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                                                 switch response.result {
                                                                                                         case .success(let value):
                                                                                                             if let json = value as? [String: Any] {
                                                                                                                                                     let status1: Bool = json["success"] as! Bool
                                                                                if(status1){
                                                                                    let jsondic = json["json"] as! NSDictionary
                                                                                    self.homeLineup = jsondic.value(forKey: "lineup") as! [AnyObject]
                                                                                    self.homeBench = jsondic.value(forKey: "bench") as! [AnyObject]
                                                                                    if(self.selectedsegmentindex == 0){
                                                                                        let objformation = self.dic.value(forKey: "formations") as! NSDictionary
                                                                                        self.formation = objformation.value(forKey: "localteam_formation") as! String
                                                                                        let objcolors = self.dic.value(forKey: "colors") as! NSDictionary
                                                                                               let localteamcolor = objcolors.value(forKey: "localteam") as! NSDictionary
                                                                                        self.FormationReset( color: localteamcolor.value(forKey: "color") as! String)
                                                                                               
                                                                                               let eventheader = 40
                                                                                        let totelheight = 620 + (self.homeBench.count * 50) + eventheader
                                                                                        self.childheightConstraint?.constant = CGFloat(totelheight)
                                                                                        self.storytableview?.reloadData()
                                                                                    }
                                                                                                              }
                                                                                                              else{
                                                                                                                   
                                                                                                               }
                                                                   }
                                                                                                               case .failure(let error):
                                                                                                                   print(error)
                                                                                                               
                                                                   break
                                                                                                                                                                                                   // error handling
                                                                                                                                                                                    
                                                                                                                                                                                               }
                                                                                                                                   
                                                                                                                                      }
                    }
                           else {
                               alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
                               
                           }
                }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
              let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
              
              let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
                  
              });
              
              alert.addAction(action1)
              self.present(alert, animated: true, completion:nil)
          }
    func apivisitorCall(){
                    if ClassReachability.isConnectedToNetwork() {
                   let url = "\(baseurl)/Lineup/Fixture/\(Fixture_id)/\(visitorId)"
                          AF.request(url, method:.get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json","cache-control": "no-cache",]).responseJSON { response in
                                                                    switch response.result {
                                                                                                            case .success(let value):
                                                                                                                if let json = value as? [String: Any] {
                                                                                                                                                        let status1: Bool = json["success"] as! Bool
                                                                                   if(status1){
                                                                                     let jsondic = json["json"] as! NSDictionary
                                                                                       self.visitorLineup = jsondic.value(forKey: "lineup") as! [AnyObject]
                                                                                       self.visitorBench = jsondic.value(forKey: "bench") as! [AnyObject]
                                                                                       if(self.selectedsegmentindex == 1){
                                                                                        let objformation = self.dic.value(forKey: "formations") as! NSDictionary
                                                                                        self.formation = objformation.value(forKey: "visitorteam_formation") as! String
                                                                                        let objcolors = self.dic.value(forKey: "colors") as! NSDictionary
                                                                                                       let localteamcolor = objcolors.value(forKey: "visitorteam") as! NSDictionary
                                                                                                      
                                                                                        self.FormationReset(color: localteamcolor.value(forKey: "color") as! String)
                                                                                                  
                                                                                                  let eventheader = 40
                                                                                           let totelheight = 620 + (self.visitorBench.count * 50) + eventheader
                                                                                           self.childheightConstraint?.constant = CGFloat(totelheight)
                                                                                        self.storytableview?.reloadData()
                                                                                       }
                                                                                                                 }
                                                                                                                 else{
                                                                                                                      
                                                                                                                  }
                                                                      }
                                                                                                                  case .failure(let error):
                                                                                                                      print(error)
                                                                                                                  
                                                                      break
                                                                                                                                                                                                      // error handling
                                                                                                                                                                                       
                                                                                                                                                                                                  }
                                                                                                                                      
                                                                                                                                         }
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
                   }
}
extension UIImage {
    static func textEmbeded(image: UIImage,
                           string: String,
                isImageBeforeText: Bool,
                          segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont.systemFont(ofSize: 13)
        let expectedTextSize = (string as NSString).size(withAttributes: [.font: font])
        let width = expectedTextSize.width + 30 + 5
        let height = max(expectedTextSize.height, 35)
        let size = CGSize(width: width, height: height)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2
            let textOrigin: CGFloat = isImageBeforeText
                ? 30 + 5
                : 0
            let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
            string.draw(at: textPoint, withAttributes: [.font: font])
            let alignment: CGFloat = isImageBeforeText
                ? 0
                : expectedTextSize.width + 5
            let rect = CGRect(x: alignment,
                              y: (height - 25) / 2,
                          width: 25,
                         height: 25)
            image.draw(in: rect)
        }
    }

}
