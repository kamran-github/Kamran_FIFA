//
//  WebViewcontroller.swift
//  FFMediaPicker
//
//  Created by Nitesh Gupta on 06/12/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class WebViewcontroller: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewNavigation: UINavigationBar!
     var stringurl = ""
     var stringtitle = ""
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      // webView.
       // webView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
         TransperentLoadingIndicatorView.hide()
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            WebViewcontroller.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return WebViewcontroller.realDelegate!;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigateby: String? = UserDefaults.standard.string(forKey: "terms")
        TransperentLoadingIndicatorView.show(self.view, loadingText: "")
         let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
           // navItem.ishi
            viewNavigation.isHidden = true
            self.navigationItem.title = navigateby
        }
        else{
             navItem.title = navigateby!
            self.navigationItem.title = navigateby
        }
        
       
       
        if ClassReachability.isConnectedToNetwork() {
            if(navigateby=="Terms & Conditions"){
                stringurl = "http://ifootballfan.com/termscondition.html"
            }
            else if(navigateby == "FAQ")
            {
                stringurl = "http://ifootballfan.com/ffapi/faq.html"
            }
            else if(navigateby == "End User License ﻿﻿Agreement﻿﻿")
            {
                stringurl = "http://ifootballfan.com/eula.html"
            } else if(navigateby == "Learn About FanCoins Rewards?")
            {
                stringurl = RedeemURL
            }
            else if(navigateby == "InApp")
            {
                 self.navigationItem.title = stringtitle
            }
            else{
                stringurl = "http://ifootballfan.com/privacypolicy.html"
            }
            webView.navigationDelegate = self
            if let url = URL(string: stringurl) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else {
            webView.isHidden = true
            alertWithTitle(title: nil, message: "Please check your Internet connection.", ViewController: self)
             TransperentLoadingIndicatorView.hide()
        }
      
    }
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    @IBAction func backclick() {
        //appDelegate().showLogin()
        TransperentLoadingIndicatorView.hide()
        self.dismiss(animated: true, completion: nil)
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         TransperentLoadingIndicatorView.hide()
    }
    private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation, withError error: NSError) {
        TransperentLoadingIndicatorView.hide()
    }
   /* func webViewDidFinishLoad(_ webView: UIWebView) {
        // hide indicator
         TransperentLoadingIndicatorView.hide()
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        // hide indicator
          
    }*/
}

