//
//  SimChangedViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 26/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class SimChangedViewController: UIViewController {
    @IBOutlet weak var userIBAvtar: UIImageView?
    @IBOutlet weak var btnKeepNumber: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userJID: String? = UserDefaults.standard.string(forKey: "userJID")
        
        if(!(userJID?.isEmpty)!)
        {
            //btnKeepNumber?.setTitle("Keep " + (userJID)!, for: UIControlState.selected)
            btnKeepNumber?.setTitle("Keep", for: UIControl.State.selected)
        }
        
    }    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeNumber () {
        
        UserDefaults.standard.setValue(nil, forKey: "isShowProfile")
        UserDefaults.standard.setValue(nil, forKey: "isRegistering")
        UserDefaults.standard.setValue(nil, forKey: "isLoggedin")
        UserDefaults.standard.setValue(nil, forKey: "userJID")
        UserDefaults.standard.setValue(nil, forKey: "registerJID")
        UserDefaults.standard.synchronize()
        appDelegate().isAvtarChanged = false
        appDelegate().isvCardUpdated = false
        
        appDelegate().showLogin()
        
        appDelegate().profileAvtarTemp! = UIImage(named:"user")!
        
    }
    
    @IBAction func keepNumber () {
        appDelegate().showMainTab()
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
