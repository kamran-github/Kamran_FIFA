//
//  OTPViewController.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 10/11/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var counterButton: UIButton!
    //@IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var txtOTP: UITextField!
    var count = 90
    var timer: Timer!
    var tempotp=""
    var tememail=""
    var keyboardFrame: CGRect! // = CGRect.init()
    var isKeyboardHiding = false
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
// var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var parentview: UIView?
    @IBOutlet weak var Childview: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*counterLabel?.layer.masksToBounds = true;
        counterLabel?.clipsToBounds=true;
        counterLabel?.layer.borderWidth = 1.0
        counterLabel?.layer.borderColor = UIColor.cyan.cgColor
        counterLabel?.contentMode =  UIViewContentMode.scaleAspectFit
        counterLabel?.layer.cornerRadius = 21.0*/
        self.txtOTP.becomeFirstResponder()
        tempotp = UserDefaults.standard.string(forKey: "tempotp")!
        tememail = UserDefaults.standard.string(forKey: "tempemail")!
        let notificationName = Notification.Name("verifyOTPStatus")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(OTPViewController.verifyOTPStatus(notification:)), name: notificationName, object: nil)
        parentview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OTPViewController.minimiseKeyboard(_:))))
        parentview?.isUserInteractionEnabled = true
        Childview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OTPViewController.minimiseKeyboard(_:))))
        Childview?.isUserInteractionEnabled = true
      /*  let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if(screenHeight <= 480)
        {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidHide), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name:NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        }*/
        let notificationName1 = Notification.Name("verifyOTPfail")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(OTPViewController.verifyOTPApifail(notification:)), name: notificationName1, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
           // self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(OTPViewController.update), userInfo: nil, repeats: true)
            
        //}
        
    }
    
    @objc func verifyOTPStatus(notification: NSNotification)
    {
        DispatchQueue.main.async {
           /* if(self.activityIndicator?.isAnimating)!
            {
                self.activityIndicator?.stopAnimating()
            }*/
            LoadingIndicatorView.hide()
            self.btnVerify.isEnabled = true
                  let message = "Password reset code is incorrect."
            self.alertWithTitle(title: "Error", message: message, ViewController: self, toFocus:self.txtOTP!)
        }
      
    }
    @objc func verifyOTPApifail(notification: NSNotification)
       {
           DispatchQueue.main.async {
              /* if(self.activityIndicator?.isAnimating)!
               {
                   self.activityIndicator?.stopAnimating()
               }*/
               LoadingIndicatorView.hide()
               self.btnVerify.isEnabled = true
            self.alertWithTitle(title: nil, message: "We apologise for a technical issue on our server. Please try again later.", ViewController: self, toFocus:self.txtOTP!)
                       
                 
           }
         
       }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
            // btnVerify.isEnabled = false
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   @objc func update() {
        if(count > 0) {
            count = count - 1
            //counterLabel.text = String(count)
            counterButton.setTitle(String(count), for: UIControl.State.normal)
        }
        else
        {
            timer.invalidate()
            btnVerify.isEnabled = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func backclick() {
        txtOTP.endEditing(true)
        appDelegate().showLogin()
    }
    @IBAction func verifyOTP(_ sender: Any) {
        if ClassReachability.isConnectedToNetwork() {
        let thereWereErrors = checkForErrors()
        if !thereWereErrors
        { btnVerify.isEnabled = false
       // let time: Int64 = self.appDelegate().getUTCFormateDate()
        txtOTP.resignFirstResponder()
            //activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
           // activityIndicator?.startAnimating()
            LoadingIndicatorView.show(self.view, loadingText: "Validating your code")
            
            //var newotp : String=(txtOTP?.text)!
        //var registerMobileTemp: String? = UserDefaults.standard.string(forKey: "registerMobileTemp")
        //registerMobileTemp = registerMobileTemp?.replace(target: "+", withString: "")
            self.appDelegate().callPHPFFAPI("verifyotp", useremail: tememail)}
        }
        else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self, toFocus:self.txtOTP!)
            
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
            OTPViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return OTPViewController.realDelegate!;
    }
    func checkForErrors() -> Bool
    { //let age_=calcAge(birthday: (userdob?.text)!)
        var errors = false
        _ = "Error"
        var message = ""
        if (txtOTP?.text?.isEmpty)! {
            errors = true
            message += "Password reset code cannot be empty"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.txtOTP!)
            
        }
        if (txtOTP?.text != tempotp) {
            errors = true
            message += "Password reset code is incorrect"
            alertWithTitle(title: nil, message: message, ViewController: self, toFocus:self.txtOTP!)
            
        }
         return errors
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func minimiseKeyboard (_ sender: UITapGestureRecognizer) {
        //messageBox?.becomeFirstResponder()
        if sender.state == .ended {
            txtOTP?.endEditing(true)
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
        adjustingHeight(show: false, notification: notification)
        
        //Working Very good
        //animateViewMoving(up: false, moveValue: 200)
        
        
    }
    func UIKeyboardDidHide(notification:NSNotification){
        //self.storyTableView?.allowsSelection = true
    }
    
    
    
    func keyboardDidChangeFrame(notification:NSNotification){
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
            let changeInHeight: CGFloat = 70.0
            
            //changeInHeight = (maximumY - self.keyboardFrame.height) + 110
            
            UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
                //print(self.messageBox.keyboardType.rawValue)
                self.bottomConstraint.constant = -changeInHeight
                
            })
        }
        
        
        
    }
    
}
