//
//  Firstviewcontroller.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 27/11/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//
import UIKit
class Firstviewcontroller:UIViewController,UITextFieldDelegate,UIAlertViewDelegate{
     @IBOutlet weak var userJID: UITextField?
     @IBOutlet weak var userpassword: UITextField?
   // var activityIndicator: LoadingIndicatorView?
     @IBOutlet weak var childiew: UIView?
     @IBOutlet weak var parentview: UIImageView?
     @IBOutlet weak var btnShow: UIButton?
    let UserNameACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"
   // let extraACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@. "
    //let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@."
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@.!#$%^&*()+=<>?:;{}[]"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Sign In"
        let notificationName4 = Notification.Name("Loginfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(Firstviewcontroller.loginFailed(notification:)), name: notificationName4, object: nil)
        UserDefaults.standard.setValue("My contacts", forKey: "Mobilesetting")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue("My contacts", forKey: "Emailsetting")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue("", forKey: "teamcopyright")
        UserDefaults.standard.setValue(nil, forKey: "defalteamSelection")
        UserDefaults.standard.setValue("", forKey: "broadcastallid")
         UserDefaults.standard.setValue("", forKey: "broadcastinactiveid")
        UserDefaults.standard.setValue(userAvtar, forKey: "userAvatarURL")
        UserDefaults.standard.setValue(true, forKey: "isvcardupdated")
                                  
        UserDefaults.standard.synchronize()
         appDelegate().profileAvtarTemp = UIImage(named:"avatar")
       // let notificationName2 = Notification.Name("_GetPermissionsForLocationOnRegister")
        // Register to receive notification
        //Temp Hide for 1st release
        //NotificationCenter.default.addObserver(self, selector: #selector(Firstviewcontroller.GetPermissionsForLocationOnRegister), name: notificationName2, object: nil)
        // Comment by Mayank 18 Jun 2018
        /*
        var dictRequest = [String: AnyObject]()
        dictRequest["cmd"] = "teamsync" as AnyObject
        var dictRequestData = [String: AnyObject]()
        
        dictRequestData["version"] = appDelegate().Realeseversion as AnyObject
        dictRequest["requestData"] = dictRequestData as AnyObject
        do {
            let dataTeams = try JSONSerialization.data(withJSONObject: dictRequest, options: .prettyPrinted)
            let strTeams = NSString(data: dataTeams, encoding: String.Encoding.utf8.rawValue)! as String
            // print(strTeams)
            appDelegate().sendRequestToAPI(strRequestDict: strTeams)
        } catch {
            print(error.localizedDescription)
        } */
        userJID?.delegate=self
        userpassword?.delegate=self
           childiew?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Firstviewcontroller.minimiseKeyboard(_:))))
            childiew?.isUserInteractionEnabled = true
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Firstviewcontroller.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
       // userJID?.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       UserDefaults.standard.setValue(nil, forKey: "forgate")
        UserDefaults.standard.synchronize()
        
    }
    @IBAction func login() {
        if ClassReachability.isConnectedToNetwork() {
             Clslogging.logdebug(State: "Login start")
            let thereWereErrors = checkForErrors()
            if !thereWereErrors
            {
                if let userid = userJID!.text?.lowercased() {
                    //if let countrycode = userpassword!.text {
                        
                    self.userpassword?.resignFirstResponder()
                        //Here we have to show loader and minimize keyboard
                        userJID?.resignFirstResponder()
                        
                       
                        //userJID?.isUserInteractionEnabled = false
                        //Code to show loader
                        
                       // LoadingIndicatorView.show(self.view, loadingText: "Validating your Football Fan sign in details")
                    TransperentLoadingIndicatorView.show(self.view,loadingText: "")
                        //New code for mobile lookup
                        //appDelegate().callPHPFFAPI("vmnlookup", mobile: Int64(mobileNumberTemp)!, countryCode: countryCodeTemp)
                        
                        
                        // This code will shift after mobile verification process
                        let Userjid =  userid + JIDPostfix
                        let userpassword = self.userpassword!.text
                        UserDefaults.standard.setValue(Userjid, forKey: "userJID")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.setValue(userid, forKey: "registerusername")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.setValue(userpassword, forKey: "userpassword")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.setValue("yes", forKey: "bylogin")
                        UserDefaults.standard.synchronize()
                        //Trying to connect user
                    UserDefaults.standard.setValue(false, forKey: "istriviauser")
                    UserDefaults.standard.synchronize()
                   // UserDefaults.standard.setValue(nil, forKey: "triviauser")
                    //UserDefaults.standard.synchronize()
                        appDelegate().profileAvtarTemp = UIImage(named:"avatar")
                        //print("Trying to connect user")
                    
                        if appDelegate().connect() {
                            //show buddy list
                            appDelegate().HomeSetSlider = true
                        } else {
                            //showLogin()
                            userJID?.isUserInteractionEnabled = true
                            TransperentLoadingIndicatorView.hide()
                            self.userJID?.becomeFirstResponder()
                             Clslogging.logdebug(State: "Login but not connect")
                            
                        }
                        
                        
                        
                    
                }
            }
        } else {
             alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self, toFocus:self.userJID!)
          
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
            Firstviewcontroller.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return Firstviewcontroller.realDelegate!;
    }
    func checkForErrors() -> Bool
    {
        var errors = false
        _ = "Error"
        var message = ""
        if (userJID?.text?.isEmpty)! {
            errors = true
            message += "Invalid username"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
            
        }
        else if (userpassword?.text?.isEmpty)! {
            errors = true
            message += "Invalid password"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userJID!)
            
        }
        
        
       
        return errors
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
   
    @IBAction func register() {
        //Temp Hide for 1st release
        /*let notified: String? = UserDefaults.standard.string(forKey: "notifiedlocation")
        if notified == nil
        {
            //Show notify before get permissions
            let popController: NotifyPermissionController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Notify") as! NotifyPermissionController
            
            // set the presentation style
            popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            
            // set up the popover presentation controller
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
            popController.popoverPresentationController?.sourceView = self.view // button
            //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
            popController.notifyType = "registerlocation"
            // present the popover
            self.present(popController, animated: true, completion: nil)
        }
        else
        {
            appDelegate().showregister()
        }*/
        if ClassReachability.isConnectedToNetwork() {
            UserDefaults.standard.setValue(nil, forKey: "registerusername")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(nil, forKey: "userpassword")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(nil, forKey: "allowregistration")
            UserDefaults.standard.synchronize()
            appDelegate().showregister()
        } else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self, toFocus:self.userJID!)
            
        }
    
        
    }
    
    func GetPermissionsForLocationOnRegister(notification: NSNotification)
    {
        
        appDelegate().showregister()
    }
    @IBAction func forgetpassword() {
        userJID?.endEditing(true)
        userpassword?.endEditing(true)
        UserDefaults.standard.setValue("password", forKey: "forgate")
        UserDefaults.standard.synchronize()
        appDelegate().showforget();
        
    }
    @IBAction func forgetusename() {
        userJID?.endEditing(true)
        userpassword?.endEditing(true)
        UserDefaults.standard.setValue("username", forKey: "forgate")
        UserDefaults.standard.synchronize()
        appDelegate().showforget();
        
    }
    @IBAction func showpassword () {
        // let passwordtag = ""
        let passwordtag = btnShow?.currentTitle
        if (passwordtag == "Show") {
            userpassword?.isSecureTextEntry = false
            //userpassword?.font = UIFont(name:sy, size: 18)
            btnShow?.setTitle("Hide", for: UIControl.State.normal)
        }
        else{
            userpassword?.isSecureTextEntry = true
            btnShow?.setTitle("Show", for: UIControl.State.normal)
        }
       /* if #available(iOS 9.0, *) {
            userpassword?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        } else {
            // Fallback on earlier versions
        }*/
    }
    @objc func loginFailed(notification: NSNotification)
    {
        TransperentLoadingIndicatorView.hide()
       // var message +="Invalid username and password."
         Clslogging.logdebug(State: "Login fail")
        alertWithTitle(title: nil, message: "Your username or password is incorrect.", ViewController: self, toFocus:self.userJID!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
     @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            userJID?.endEditing(true)
            userpassword?.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag==1){
            let cs = NSCharacterSet(charactersIn: UserNameACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            //usernamecount?.text =
            return (string == filtered)
        }
        else if(textField.tag == 2){
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
       
        return true;
    }
  
}
