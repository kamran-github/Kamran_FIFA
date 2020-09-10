//
//  SimViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 27/06/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class SimViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(AppDelegate().hasCellularCoverage())!
        {
            // Override point for customization after application launch.
            let login: String? = UserDefaults.standard.string(forKey: "userJID")
            let isShowProfile: String? = UserDefaults.standard.string(forKey: "isShowProfile")
            let isLoggedin: String? = UserDefaults.standard.string(forKey: "isLoggedin")
            //Check if user is already logged in
            if isLoggedin == nil || isLoggedin == "NO"
            {
                if isShowProfile == nil {
                    if (login != nil) {
                        if AppDelegate().connect() {
                            //show buddy list
                        } else {
                            AppDelegate().showLogin()
                        }
                    }
                    else
                    {
                        AppDelegate().showLogin()
                    }
                }
                else
                {
                    //Authenticate and fetch profile data
                    if AppDelegate().connect() {
                        AppDelegate().showProfile()
                    }
                    
                }
            }
            
            AppDelegate().profileAvtarTemp = UIImage(named:"user")
        }

        
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
