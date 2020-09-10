//
//  ChangepasswordViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 02/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import Foundation
import UIKit

class ChangepasswordViewController:UIViewController,UITextFieldDelegate,UIAlertViewDelegate{
     @IBOutlet weak var userpassword: UITextField?
    // var activityIndicator: UIActivityIndicatorView?
     @IBOutlet weak var btnShow: UIButton?
   let Password_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-@.!#$%^&*()+=<>?:;{}[]"
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var Childview: UIView?
     @IBOutlet weak var userPasswordcount: UILabel?
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBAction func next() {
    if ClassReachability.isConnectedToNetwork() {
        let thereWereErrors = checkForErrors()
        if !thereWereErrors
        {
            
            userpassword?.resignFirstResponder()
            // let navigateby: String? = UserDefaults.standard.string(forKey: "forgate")
            //activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
            //activityIndicator?.startAnimating()
            if(appDelegate().isUserOnline){
            LoadingIndicatorView.show(self.view, loadingText: "Changing your Football Fan password")
            
            
            UserDefaults.standard.setValue(userpassword?.text, forKey: "userpassword")
            UserDefaults.standard.synchronize()
            appDelegate().sendRequestToResetPassword()
                self.appDelegate().HomeSetSlider = true
            //self.activityIndicator?.startAnimating()
            }else{
                 alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self, toFocus:self.userpassword!)
            }
            
        }
    }
    else {
    alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self, toFocus:self.userpassword!)
    
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userpassword?.delegate=self
        
        
        
    }
    @IBAction func userpasswordtxtchange(){
        
        
        userPasswordcount?.text=String(describing: userpassword?.text?.count ?? 0)+"/"+String(describing: userpassword?.maxLength ?? 0)
        
    }
    @IBAction func showpassword () {
        // let passwordtag = ""
        let passwordtag = btnShow?.currentTitle
        if (passwordtag == "Show") {
            userpassword?.isSecureTextEntry = false
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
        var errors = false
        let title = "Error"
        var message = ""
        if (userpassword?.text?.isEmpty)! {
            errors = true
            message += "Password cannot be empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.userpassword!)
            
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
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChangepasswordViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChangepasswordViewController.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
        /*let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if(screenHeight <= 480)
        {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        }*/
    }
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            userpassword?.endEditing(true)
            //userJID?.delegate = self
            
            
        }
        sender.cancelsTouchesInView = false
    }
    func keyboardWillShow(notification:NSNotification){
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
    
    func keyboardWillHide(notification:NSNotification){
        /*let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         self.storyToolbar.contentInset = contentInset*/
        isKeyboardHiding = true
        //adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        
        
    }
    func UIKeyboardDidHide(notification:NSNotification){
        //self.storyTableView?.allowsSelection = true
    }
    
    
    
    func keyboardDidChangeFrame(notification:NSNotification){
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
        var userInfo = notification.userInfo!
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
    
}
