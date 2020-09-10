//
//  PaypalwebViewController.swift
//  FootballFan
//
//  Created by Apple on 20/12/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class PaypalwebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewNavigation: UINavigationBar!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // webView.
        // webView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* let navigateby: String? = UserDefaults.standard.string(forKey: "terms")
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
            // navItem.ishi
            viewNavigation.isHidden = true
            self.navigationItem.title = navigateby
        }
        else{
            navItem.title = navigateby!
        }
        */
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        //var stringurl = "https://www.sandbox.paypal.com/signin/authorize?scope=email&redirect_uri=http://apidev.ifootballfan.com/ffapi/ffapi.php&response_type=code&client_id=AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&state=mks1645"
        if ClassReachability.isConnectedToNetwork() {
           
            webView.navigationDelegate = self
            if let url = URL(string: loadpaypalurl) {
                let request = URLRequest(url: url)
                webView.load(request)
                
            }
        } else {
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
            
        }
        
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
}
   
   /* func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let url = request.url?.absoluteString
        
        if ((url?.contains(MediaAPI))!) {
            if((url?.contains("code="))!){
                
                let messageContent = url!.replacingOccurrences(of:MediaAPI, with: "")
                let messageContent1 = messageContent.replacingOccurrences(of:"?", with: "")
                let arrdUserJid = messageContent1.components(separatedBy: "&")
                let code = arrdUserJid[0].replace(target: "code=", withString: "")
                if(code != nil){
                    webcallPaypalWithToken(code: code)
                }
                else{
                    self.dismiss(animated: true, completion: nil)
                    let tabIndex:[String: String] = ["msg": "PayPal email address verification failed.\nPlease check your email address and try again."]
                    let notificationName = Notification.Name("paypalverifiedfail")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo:tabIndex)
                    
                    

                }

            }
            else{
                            /*   */
                if ((url?.contains("error_uri"))!) {
                    self.dismiss(animated: false, completion: nil)

                    let tabIndex:[String: String] = ["msg": "PayPal email address verification failed.\nPlease check your email address and try again."]
                    let notificationName = Notification.Name("paypalverifiedfail")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo:tabIndex)
                }
                else{
                    return true

                }
            }
            return false
        }
        return true
    }*/
    func webcallPaypalWithToken(code: String)  {
        let boundary = appDelegate().generateBoundaryString()
        var request = URLRequest(url: URL(string: PaypalWithToken + code)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("en-US", forHTTPHeaderField: "Content-Language")
        let tMessage = Client_id + ":" + Secret_key
        //  print("Original: \(tMessage)")
        
        //1. Convert String to base64
        //Convert string to NSData
        let myNSData = tMessage.data(using: String.Encoding.utf8)! as NSData
        
        //Encode to base64
        let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        
        let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
        
        let cl = "Basic \(resultNSString)" as String
        
        request.setValue(cl, forHTTPHeaderField: "Authorization")
        let reqParams = [String: String]()
       /*
        reqParams["client_id"] = "AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&"
        reqParams["redirect_uri"] = "http://apidev.ifootballfan.com/ffapi/ffapi.php&"
        reqParams["client_secret"] = "EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-&"
        reqParams["code"] = code + "&"//"code"
        reqParams["grant_type"] = "authorization_code"
        */
        // request.httpBody = createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
        request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    print(stringData) //JSONSerialization
                    
                    
                    
                    //print(time)
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                       // let access_token: String = (jsonData?.value(forKey: "access_token") as? String)!
                        
                       
                        if (jsonData?.value(forKey: "access_token")) != nil {
                            let access_token: String = (jsonData?.value(forKey: "access_token") as? String)!
                            
                            self.webcallPaypalWithaccess_token(access_token: access_token)
                        }
                    
                        else
                        {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                            let tabIndex:[String: String] = ["msg": "PayPal email address verification failed.\nPlease check your email address and try again."]
                            let notificationName = Notification.Name("paypalverifiedfail")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo:tabIndex)
                            
                            //Show Error
                        }
                    } catch let error as NSError {
                        print(error)
                        //Show Error
                    }
                    
                }
            }
            else
            {
                //Show Error
            }
        })
        task.resume()
        
        
        
    }
    func webcallPaypalWithaccess_token(access_token: String)  {
        let boundary = appDelegate().generateBoundaryString()
        var request = URLRequest(url: URL(string: PaypalWithaccess_token )!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("en-US", forHTTPHeaderField: "Content-Language")
       /* let tMessage = "AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E" + ":" + "EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-"
        //  print("Original: \(tMessage)")
        
        //1. Convert String to base64
        //Convert string to NSData
        let myNSData = tMessage.data(using: String.Encoding.utf8)! as NSData
        
        //Encode to base64
        let myBase64Data = myNSData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        
        let resultNSString = NSString(data: myBase64Data as Data, encoding: String.Encoding.utf8.rawValue)!
        */
        let cl = "Bearer \(access_token)" as String
        
        request.setValue(cl, forHTTPHeaderField: "Authorization")
        let reqParams = [String: String]()
        /*
         reqParams["client_id"] = "AQNdPgkUXvVpykQjbsDvgahGWIX2S7hmGHz1GN9T69ZSejwAgpfEhOgzpxQ2P5dT0cL8V7P_3hBrIk_E&"
         reqParams["redirect_uri"] = "http://apidev.ifootballfan.com/ffapi/ffapi.php&"
         reqParams["client_secret"] = "EHkT97jYe2Zgmu_R7arQ2gBbZoyDsfeWylI-0zS_RX7fnBeJaMDgT7mwKpEg6hiumVPhISMZXWkuW2N-&"
         reqParams["code"] = code + "&"//"code"
         reqParams["grant_type"] = "authorization_code"
         */
        // request.httpBody = createRequestBodyWith(parameters:reqParams as [String : String], filePathKey:"uploaded", boundary:boundary, image: appDelegate().profileAvtarTemp!) as Data
        request.httpBody = appDelegate().createRequestBody(parameters: reqParams as [String : AnyObject], filePathKey: "", boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                    print(stringData) //JSONSerialization
                    
                    
                    
                    //print(time)
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with:data , options: []) as? NSDictionary
                        
                        let email: String = (jsonData?.value(forKey: "email") as? String)!
                         let verified: String = (jsonData?.value(forKey: "verified") as? String)!
                         let email_verified: String = (jsonData?.value(forKey: "email_verified") as? String)!
                        if(email != nil && email_verified == "true"){
                            self.appDelegate().TemppaypalEmail = email
                            
                            let tabIndex:[String: String] = ["verified": verified, "email_verified": email_verified]
                            //self.navigationController?.popViewController(animated: true)
                           DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            }
                            let notificationName = Notification.Name("callpaypalapi")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo:tabIndex)
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                            let tabIndex:[String: String] = ["msg": "PayPal email address verification failed.\nPlease check your email address and try again."]
                            let notificationName = Notification.Name("paypalverifiedfail")
                            NotificationCenter.default.post(name: notificationName, object: nil, userInfo:tabIndex)
                           
                        }
                    } catch let error as NSError {
                        print(error)
                        //Show Error
                    }
                    
                }
            }
            else
            {
                //Show Error
            }
        })
        task.resume()
        
        
        
    }
    @IBAction func backclick() {
        //appDelegate().showLogin()
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
            PaypalwebViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return PaypalwebViewController.realDelegate!;
    }

}
