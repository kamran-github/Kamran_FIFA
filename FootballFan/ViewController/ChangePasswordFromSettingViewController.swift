//
//  ChangePasswordFromSettingViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 22/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//


import Foundation
import UIKit

class ChangePasswordFromSettingViewController:UIViewController,UITextFieldDelegate,UIAlertViewDelegate{
    @IBOutlet weak var cuserpassword: UITextField?
    @IBOutlet weak var userpassword: UITextField?
    //var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var btnShow: UIButton?
    let Password_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@.!#$%^&*()+=<>?:;{}[]"
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var Childview: UIView?
    @IBOutlet weak var userPasswordcount: UILabel?
    @IBOutlet weak var cuserPasswordcount: UILabel?
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cbtnShow: UIButton?
    @IBAction func next() {
         if ClassReachability.isConnectedToNetwork() {
        let thereWereErrors = checkForErrors()
        if !thereWereErrors
        {
            
            userpassword?.resignFirstResponder()
            cuserpassword?.resignFirstResponder()
            userpassword?.endEditing(true)
            cuserpassword?.endEditing(true)
            // let navigateby: String? = UserDefaults.standard.string(forKey: "forgate")
           // activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
            //activityIndicator?.startAnimating()
            LoadingIndicatorView.show(self.view, loadingText: "Changing your Football Fan password")
            
            // let username: String? = UserDefaults.standard.string(forKey: "registerusername")
            //let registerid = username
           // UserDefaults.standard.setValue("password", forKey: "forgate")
             UserDefaults.standard.setValue("yes", forKey: "byChangePassword")
           UserDefaults.standard.setValue(userpassword?.text, forKey: "oldpassword")
            UserDefaults.standard.setValue(cuserpassword?.text, forKey: "newpassword")
            UserDefaults.standard.synchronize()
            //appDelegate().isFromSettings=true
              if appDelegate().connect() {
           // appDelegate().sendRequestToResetPassword()
            }
            //self.activityIndicator?.startAnimating()
            
        }
            }
                          else {
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userpassword?.delegate=self
        cuserpassword?.delegate=self
        
        
    }
    @IBAction func userpasswordtxtchange(){
        
        
        userPasswordcount?.text=String(describing: userpassword?.text?.count ?? 0)+"/"+String(describing: userpassword?.maxLength ?? 0)
        
    }
    @IBAction func Newuserpasswordtxtchange(){
        
        
        cuserPasswordcount?.text=String(describing: cuserpassword?.text?.count ?? 0)+"/"+String(describing: cuserpassword?.maxLength ?? 0)
        
    }
    @IBAction func showpassword () {
        // let passwordtag = ""
        userpassword?.endEditing(true)
        cuserpassword?.endEditing(true)
        let passwordtag = btnShow?.currentTitle
        if (passwordtag == "Show") {
            userpassword?.isSecureTextEntry = false
            btnShow?.setTitle("Hide", for: UIControl.State.normal)
        }
        else{
            userpassword?.isSecureTextEntry = true
            btnShow?.setTitle("Show", for: UIControl.State.normal)
        }
        /*if #available(iOS 9.0, *) {
            userpassword?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.available)
        } else {
            // Fallback on earlier versions
        }*/
    }
    @IBAction func showNewPassword () {
        // let passwordtag = ""
        userpassword?.endEditing(true)
        cuserpassword?.endEditing(true)
        let passwordtag = cbtnShow?.currentTitle
        if (passwordtag == "Show") {
            cuserpassword?.isSecureTextEntry = false
            cbtnShow?.setTitle("Hide", for: UIControl.State.normal)
        }
        else{
           cuserpassword?.isSecureTextEntry = true
            cbtnShow?.setTitle("Show", for: UIControl.State.normal)
        }
       /* if #available(iOS 9.0, *) {
            cuserpassword?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.normal)
        } else {
            // Fallback on earlier versions
        }*/
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: Password_ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
        
    }
    
    func checkForErrors() -> Bool
    { //let age_=calcAge(birthday: (userdob?.text)!)
        let AvilablePassword: String? = UserDefaults.standard.string(forKey: "userpassword")
        var errors = false
        //let title = "Error"
        var message = ""
        if (userpassword?.text?.isEmpty)! {
            errors = true
            message += "Current password cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.userpassword!)
            
        }
        else if (cuserpassword?.text?.isEmpty)! {
            errors = true
            message += "New password cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.cuserpassword!)
            
        }
        else if (userpassword?.text != AvilablePassword) {
            errors = true
            message += "Invalid current password"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.cuserpassword!)
            
        }else if (userpassword?.text == cuserpassword?.text) {
            errors = true
            message += "Current and new password cannot be same"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.cuserpassword!)
            
        }
        return errors
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // println("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userpassword?.delegate = self
        /*counterLabel?.layer.masksToBounds = true;
         counterLabel?.clipsToBounds=true;
         counterLabel?.layer.borderWidth = 1.0
         counterLabel?.layer.borderColor = UIColor.cyan.cgColor
         counterLabel?.contentMode =  UIViewContentMode.scaleAspectFit
         counterLabel?.layer.cornerRadius = 21.0*/
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChangePasswordFromSettingViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChangePasswordFromSettingViewController.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if(screenHeight <= 480)
        {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
        let notificationName = Notification.Name("resetPasswordFromSettingsSucssfull")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordFromSettingViewController.resetPasswordFromSettingsSucssfull(notification:)), name: notificationName, object: nil)
        
        let notificationName1 = Notification.Name("resetPasswordFromSettingsfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordFromSettingViewController.resetPasswordFromSettingsfail(notification:)), name: notificationName1, object: nil)
        
    }
    @IBAction func cancelTeam () {
        userpassword?.endEditing(true)
         cuserpassword?.endEditing(true)
        //appDelegate().showMainTab()
        self.dismiss(animated: true, completion: nil)
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            ChangePasswordFromSettingViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return ChangePasswordFromSettingViewController.realDelegate!;
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            userpassword?.endEditing(true)
            cuserpassword?.endEditing(true)
            
            
        }
        //sender.cancelsTouchesInView = false
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
        //adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        
        
    }
    @objc func UIKeyboardDidHide(notification:NSNotification){
        //self.storyTableView?.allowsSelection = true
    }
    
    
    
    @objc func keyboardDidChangeFrame(notification:NSNotification){
        //if(Tagtextfield > 3){
        /*if(isKeyboardHiding == false)
        {
            adjustingHeight(show: true, notification: notification)
        }*/
        
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
            let changeInHeight = 0.0
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = CGFloat(changeInHeight)
                
            })
        }
        else
        {
            //let changeInHeight = (maximumY - self.keyboardFrame.height) + 110 //* (show ? 1 : -1)
            let changeInHeight: CGFloat = 10.0
            
            //changeInHeight = (maximumY - self.keyboardFrame.height) + 110
            
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = -changeInHeight
                
            })
        }
        
        
        
    }
    @objc func resetPasswordFromSettingsSucssfull(notification: NSNotification) {
        
        /*if let recMobile = notification.userInfo?["recMobile"] as? String
         {
         
         }*/
        
        DispatchQueue.main.async {
           // self.activityIndicator?.stopAnimating()
            LoadingIndicatorView.hide()
           // self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @objc func resetPasswordFromSettingsfail(notification: NSNotification) {
        
        /*if let recMobile = notification.userInfo?["recMobile"] as? String
         {
         
         }*/
        
        DispatchQueue.main.async {
          //  self.activityIndicator?.stopAnimating()
            LoadingIndicatorView.hide()
            let title = "Error"
            var message = ""
            message += "Password reset code is incorrect."
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.userpassword!)
        }
        
    }
}

