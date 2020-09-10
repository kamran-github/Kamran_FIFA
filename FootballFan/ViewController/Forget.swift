//
//  Forget.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 01/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//
import UIKit
import Foundation
class Forget: UIViewController, UIAlertViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate{
     @IBOutlet weak var useremailid: UITextField?
     //var activityIndicator: UIActivityIndicatorView?
  //  @IBOutlet weak var navigationItem: UINavigationItem?
    @IBOutlet weak var navItem: UINavigationItem!
    var flag=""
    var email="",otp=""
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var Childview: UIView?
     @IBOutlet weak var SuperviewHeadernote: UILabel?
    @IBOutlet weak var Headernote: UILabel?
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@."
    @IBAction func login() {
    if ClassReachability.isConnectedToNetwork() {
        let thereWereErrors = checkForErrors()
        if !thereWereErrors
        {
            
            useremailid?.resignFirstResponder()
            let navigateby: String? = UserDefaults.standard.string(forKey: "forgate")
            //activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
            //activityIndicator?.startAnimating()
            
            
            //self.activityIndicator?.startAnimating()
            if(navigateby=="password"){
                Clslogging.logdebug(State: "forgotpassword start")
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
            self.appDelegate().callPHPFFAPI("forgotpassword", useremail:(useremailid?.text?.lowercased())!)
            }
            else{
                TransperentLoadingIndicatorView.show(self.view, loadingText: "")
                Clslogging.logdebug(State: "forgotusername start")
                 self.appDelegate().callPHPFFAPI("forgotusername", useremail:(useremailid?.text?.lowercased())!)
            }
        }
    }
    else {
        alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self, toFocus:self.useremailid!)
        
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        useremailid?.delegate=self
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem?.title = "dd"
       //  self.parent?.title = "Banters"
        // Do any additional setup after loading the view.
        let navigateby: String? = UserDefaults.standard.string(forKey: "forgate")
        navItem.title = "Forgot " + navigateby!
        if(navigateby=="password"){
             navItem.title = "Forgot Password?"
             SuperviewHeadernote?.text="Need help with your \n Football Fan password?"
            Headernote?.text="Enter your Football Fan registered email address and we will email you a new password generation code."
        }
        else{
            Headernote?.text="Enter your Football Fan registered email address and we will email your username."
            SuperviewHeadernote?.text="Need help with your \n Football Fan username?"
             navItem.title = "Forgot Username?"
        }
        /*counterLabel?.layer.masksToBounds = true;
         counterLabel?.clipsToBounds=true;
         counterLabel?.layer.borderWidth = 1.0
         counterLabel?.layer.borderColor = UIColor.cyan.cgColor
         counterLabel?.contentMode =  UIViewContentMode.scaleAspectFit
         counterLabel?.layer.cornerRadius = 21.0*/
        // print("Screen width = \(screenWidth), screen height = \(screenHeight)")
        //if(screenHeight <= 568)
        //{
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if(screenHeight <= 480)
        {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
         }
       useremailid?.delegate=self
        let notificationName = Notification.Name("forgetrequstfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(Forget.forgetrequstfail(notification:)), name: notificationName, object: nil)
        let notificationName1 = Notification.Name("forgetrequstsucss")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(Forget.forgetrequstsucss(notification:)), name: notificationName1, object: nil)
        let notificationName2 = Notification.Name("forgetpasswordrequstsucss")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(Forget.forgetpasswordrequstsucss(notification:)), name: notificationName2, object: nil)
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Forget.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Forget.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
    }
    func showVerifyOTPScreen()
    {
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController : OTPViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyOTP") as! OTPViewController
       show(registerController, sender: self)
       /* let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyOTP")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self as UIPopoverPresentationControllerDelegate
        popController.popoverPresentationController?.sourceView = self.view // button
        //popController.popoverPresentationController?.sourceRect = (viewPopup?.bounds)!
        
        // present the popover
        self.present(popController, animated: true, completion: nil)*/
    }
    @IBAction func backclick() {
        appDelegate().showLogin()
    }
    func checkForErrors() -> Bool
    { //let age_=calcAge(birthday: (userdob?.text)!)
        var errors = false
       // let title = "Error"
        var message = ""
        if (useremailid?.text?.isEmpty)! {
            errors = true
            message += "Email address cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.useremailid!)
            
        }
        else if validateEmail(candidate: (useremailid?.text)!) {
            // Success
            // performSegueWithIdentifier("SEGUE-ID", sender: self)
        } else {
            // Failure - Alert
            errors = true
            message += "Invalid email address"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.useremailid!)
        }
        
        return errors
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            if(self.flag=="sucss"){
            let navigateby: String? = UserDefaults.standard.string(forKey: "forgate")
             if(navigateby=="password"){
                self.showVerifyOTPScreen();
                Clslogging.logdebug(State: "forgetpasswordrequstsucss showVerifyOTPScreen")
                }
             else{
                Clslogging.logdebug(State: "forgetuserrequstsucss LoginwithModelPopUp")
                self.appDelegate().LoginwithModelPopUp()
                }
            
        }
            else{
                toFocus.becomeFirstResponder()
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            Forget.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return Forget.realDelegate!;
    }
    
    
    @objc func forgetrequstfail(notification: NSNotification)
    {flag="fail"
        var message = ""
       
        DispatchQueue.main.async {
           /* if(self.activityIndicator?.isAnimating)!
            {
                self.activityIndicator?.stopAnimating()
            }*/
            TransperentLoadingIndicatorView.hide()
            message = (notification.userInfo?["OTPStatus"] as? String)!
            self.alertWithTitle(title: "Error", message: message, ViewController: self, toFocus:self.useremailid!)
        }
       
    }
    
    
    @objc func forgetrequstsucss(notification: NSNotification)
    {
        DispatchQueue.main.async {
            /*if(self.activityIndicator?.isAnimating)!
            {
                self.activityIndicator?.stopAnimating()
            }*/
            TransperentLoadingIndicatorView.hide()
            var message = ""
            self.flag="sucss"
                       message = (notification.userInfo?["OTPStatus"] as? String)!
            self.alertWithTitle(title: "", message: message, ViewController: self, toFocus:self.useremailid!)
        }
        
           
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
        
    }
    @objc func forgetpasswordrequstsucss(notification: NSNotification)
    {
        DispatchQueue.main.async {
           /* if(self.activityIndicator?.isAnimating)!
            {
                self.activityIndicator?.stopAnimating()
            }*/
            Clslogging.logdebug(State: "forgetpasswordrequstsucss alert")
            TransperentLoadingIndicatorView.hide()
            var message = ""
            self.flag="sucss"
            self.email = (notification.userInfo?["email"] as? String)!
            self.otp = (notification.userInfo?["otp"] as? String)!
            UserDefaults.standard.setValue(self.email, forKey: "tempemail")
                  UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(self.otp, forKey: "tempotp")
                  UserDefaults.standard.synchronize()
                  
                  message = (notification.userInfo?["OTPStatus"] as? String)!
            self.alertWithTitle(title: "", message: message, ViewController: self, toFocus:self.useremailid!)
        }
        
      
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            useremailid?.endEditing(true)
            //userJID?.delegate = self
            
            
        }
        sender.cancelsTouchesInView = false
    }
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        /*var userInfo = notification.userInfo!
         var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
         keyboardFrame = self.view.convert(keyboardFrame, from: nil)
         
         var contentInset:UIEdgeInsets = self.storyToolbar?. //.contentInset
         contentInset.bottom = keyboardFrame.size.height
         self.storyToolbar.contentInset = contentInset*/
        //adjustingHeight(show: true, notification: notification)
        //Working Very good
        //animateViewMoving(up: true, moveValue: 200)
        isKeyboardHiding = false
        //self.storyTableView?.allowsSelection = false
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        /*let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         self.storyToolbar.contentInset = contentInset*/
        isKeyboardHiding = true
        adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        
        
    }
    @objc func UIKeyboardDidHide(notification:NSNotification){
        //self.storyTableView?.allowsSelection = true
    }
    
    
    
    @objc func keyboardDidChangeFrame(notification:NSNotification){
        //if(Tagtextfield > 3){
            if(isKeyboardHiding == false)
            {
                adjustingHeight(show: true, notification: notification)
            }
            
       // }
        //else
        //{
           // self.bottomConstraint.constant = 0.0
       // }
        //isKeyboardHiding = false
        //self.scrollToBottom()
    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        let userInfo = notification.userInfo!
        //print(userInfo)
        self.keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        if(isKeyboardHiding == true)
        {
            Headernote?.isHidden = false
            let changeInHeight = 0.0
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = CGFloat(changeInHeight)
                
            })
        }
        else
        {
            let screenSize: CGRect = UIScreen.main.bounds
            
            //let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            if(screenHeight <= 480)
            {
                //let changeInHeight = (maximumY - self.keyboardFrame.height) + 110 //* (show ? 1 : -1)
                let changeInHeight: CGFloat = 105.0
                Headernote?.isHidden = true
                //changeInHeight = (maximumY - self.keyboardFrame.height) + 110
                
                UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                    //print(self.messageBox.keyboardType.rawValue)
                    self.bottomConstraint.constant = -changeInHeight
                    
                })
            }
            else
            {
                //let changeInHeight = (maximumY - self.keyboardFrame.height) + 110 //* (show ? 1 : -1)
                let changeInHeight: CGFloat = 40.0
                
                //changeInHeight = (maximumY - self.keyboardFrame.height) + 110
                
                UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                    //print(self.messageBox.keyboardType.rawValue)
                    self.bottomConstraint.constant = -changeInHeight
                    
                })
            }
            
        }
        
        
        
    }
    
    
}
