//
//  InfoAlertViewController.swift
//  FootballFan
//
//  Created by Apple on 08/04/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import UIKit

class InfoAlertViewController: UIViewController {
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
    static func instantiate() -> InfoAlertViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoAlertViewController") as? InfoAlertViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString
        messageLabel.text = messageString
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
                    let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
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
      //  actionBut.setTitle(ActionTitle, for: .normal)
        //let advTimeGif = UIImage.gifImageWithData(imageData!)!
        if(actioncommand!.isEmpty){
           // actionBut.isHidden = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        appDelegate().ismodalshow = false
        dismiss(animated: true, completion: nil)
        
       /* if(actioncommand == "contacts"){
            appDelegate().showcontactswindows()
        }
        else if(actioncommand == "share"){
            appDelegate().share()
        }
        else if(actioncommand == "banter"){
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
        }*/
    }
    
    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            InfoAlertViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return InfoAlertViewController.realDelegate!;
    }
    
}
