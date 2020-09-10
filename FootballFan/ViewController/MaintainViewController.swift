//
//  MaintainViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 17/05/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import  UIKit
class MaintainViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var notifyHeading: UILabel!
    @IBOutlet weak var notifyText: UILabel?
    @IBOutlet weak var notifyImage: UIImageView?
    @IBOutlet weak var notifyAccept: UIButton?
    @IBOutlet weak var ParentView: UIView?
    var notifyType: String = ""
    @IBOutlet weak var notifyText1: UILabel?
    @IBOutlet weak var notifyTextView: UITextView!
    @IBOutlet weak var notifyText2: UILabel?
    @IBOutlet weak var infolabel: UILabel?
    var strings:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let maintancetype: String = UserDefaults.standard.string(forKey: "maintancetype")!
        if(maintancetype.contains("ismanupdate")){
            let Titel: String = UserDefaults.standard.string(forKey: "maintanceTitel")!
            let messg: String = UserDefaults.standard.string(forKey: "maintancemessage")!
            notifyHeading.text = Titel
            notifyTextView.text = messg
            notifyImage?.image = UIImage(named: "pre_update")
            notifyAccept?.isHidden = false
            //notifyTextView.text = "A new mandatory Football Fan app update is available for you to download.\nPlease tap on the button/link (whatever you add) to update your Football Fan app.\nWe appreciate your continued support. Thank you."

        }
        else{
             let Titel: String = UserDefaults.standard.string(forKey: "maintanceTitel")!
             let messg: String = UserDefaults.standard.string(forKey: "maintancemessage")!
            notifyHeading.text = Titel
            notifyTextView.text = messg
            notifyImage?.image = UIImage(named: "per_maintain")
            notifyAccept?.isHidden = true
            //notifyTextView.text = "A new mandatory Football Fan app update is available for you to download.\nPlease tap on the button/link (whatever you add) to update your Football Fan app.\nWe appreciate your continued support. Thank you."
        }
       
}
    @IBAction func updatenewVersion(){
        UIApplication.shared.openURL(NSURL(string : "https://itunes.apple.com/us/app/football-fan/id1335286217?ls=1&mt=8")! as URL)
    }
}
