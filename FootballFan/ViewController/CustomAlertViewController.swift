//
//  CustomAlertViewController.swift
//  EzPopup_Example
//
//  Created by Huy Nguyen on 6/4/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
     @IBOutlet weak var messageimg: UIImageView!
     @IBOutlet weak var actionBut: UIButton!
    var titleString: String?
    var messageString: String?
    var  mediatype: String?
    var mediaurl: String?
    var ActionTitle: String?
     var LinkTitle: String?
    var  actioncommand:String?
    var actionlink:String?
    static func instantiate() -> CustomAlertViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(CustomAlertViewController.self)") as? CustomAlertViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleString
        messageLabel.text = messageString
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        actionBut.setTitle(ActionTitle, for: .normal)
        }else{
             actionBut.setTitle("Sign In", for: .normal)
        }
        //let advTimeGif = UIImage.gifImageWithData(imageData!)!
        if(actioncommand!.isEmpty){
            actionBut.isHidden = true
        }
        if(mediatype == "gif"){
            // messageimg.imageURL = mediaurl
            let arrReadselVideoPath = mediaurl!.components(separatedBy: "/")
            let imageId = arrReadselVideoPath.last
            let arrReadimageId = imageId?.components(separatedBy: ".")
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent( arrReadimageId![0] + ".gif")
            //try fileManager.removeItem(atPath: imageId)
            // Check if file exists
            if fileManager.fileExists(atPath: paths) {
                //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "contacts", withExtension: "gif")!)
               // let advTimeGif = UIImage.gifImageWithName("contacts")
               // messageimg.image = advTimeGif
                let fileName = arrReadimageId![0] + ".gif"
                let fileURL = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent(fileName)
                if let imageData = NSData(contentsOf: fileURL!) {
                    _ = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
                    messageimg.image = UIImage.gifImageWithData(imageData as Data)
                }

               /* do {
                    if let imageData = NSData(contentsOfURL: paths) {
                        let image = UIImage(data: imageData) // Here you can attach image to UIImageView
                    }
                    let imageData = try Data(contentsOf: URL(string: paths)!)
                    messageimg.image = UIImage.gifImageWithData(imageData)
                } catch {
                    print("Not able to load image")
                }*/
                
            }
            else{
                messageimg.image = UIImage.gifImageWithURL(mediaurl!)
            }
            //
        }
        else{
            messageimg.imageURL = mediaurl
        }
      
    }

    // MARK: Actions
    
    @IBAction func ButtonTapped(_ sender: Any) {
        navigationController?.isNavigationBarHidden = false
        dismiss(animated: true, completion: nil)
        appDelegate().ismodalshow = false
        let login: String? = UserDefaults.standard.string(forKey: "userJID")
        if(login != nil){
        if(actioncommand == "contacts"){
            appDelegate().showcontactswindows()
        }
        else if(actioncommand == "share"){
            appDelegate().share()
        }
        else if(actioncommand == "banter"){
            appDelegate().HomeSetSlider = true
            appDelegate().showMainTab()
        }
        else if(actioncommand == "newstory"){
            appDelegate().showNewPostWindow()
        }
        else if(actioncommand == "browser"){
            appDelegate().showexternalbrowser(url: actionlink!)
        }
        else if(actioncommand == "inappbrowser"){
            appDelegate().inappwindows(url: actionlink!, titel: LinkTitle!)
        }
        else if(actioncommand == "login"){
            appDelegate().LoginwithModelPopUp()
        }
        }
        else{
            appDelegate().LoginwithModelPopUp()
        }
        
    }
    @IBAction func CloseTapped(_ sender: Any) {
       // navigationController?.isNavigationBarHidden = false
         appDelegate().ismodalshow = false
        dismiss(animated: true, completion: nil)
       
    }
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            CustomAlertViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return CustomAlertViewController.realDelegate!;
    }
   
}
