//
//  AppInfoViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 18/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class AppInfoViewController:UIViewController{
    @IBOutlet weak var Copyright: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "App Info"
       // Copyright.text = "© 2017 Football Fan. All rights reserved."
        
    }
    
    @IBAction func cancelview () {
        //UserStaus?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
      @IBAction func sendlog(){
         if ClassReachability.isConnectedToNetwork() {
        if(appDelegate().isOnloggin){
            
        appDelegate().uploadlogfile()
        }else{
            alertWithTitle1(title: nil, message: "Logging is inactive.", ViewController: self)
        }
            }else {
                       //TransperentLoadingIndicatorView.hide()
                       alertWithTitle1(title: nil, message: "Please check your Internet connection.", ViewController: self)
                       
                   }
    }
    func alertWithTitle1(title: String!, message: String, ViewController: UIViewController) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           let action1 = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: {_ in
               
           });
           
           alert.addAction(action1)
           self.present(alert, animated: true, completion:nil)
    }
    static var realDelegate: AppDelegate?;
       
       func appDelegate() -> AppDelegate {
           if Thread.isMainThread{
               return UIApplication.shared.delegate as! AppDelegate;
           }
           let dg = DispatchGroup();
           dg.enter()
           DispatchQueue.main.async{
               AppInfoViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
               dg.leave();
           }
           dg.wait();
           return AppInfoViewController.realDelegate!;
       }
}
