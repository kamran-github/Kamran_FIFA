//
//  CustomMediaPicker.swift
//  FootballFan
//
//  Created by Ravikant Nagar on 01/08/17.
//  Copyright © 2017 Tridecimal. All rights reserved.
//

import UIKit
//import FFMediaPicker
import Photos

struct Cell {
    let title: String
    let selector: Selector
}

class CustomMediaPicker: UITableViewController, NohanaImagePickerControllerDelegate {

    let cells = [
        Cell(title: "Default", selector: #selector(CustomMediaPicker.showDefaultPicker)),
        Cell(title: "Large thumbnail", selector: #selector(CustomMediaPicker.showLargeThumbnailPicker)),
        Cell(title: "No toolbar", selector: #selector(CustomMediaPicker.showNoToolbarPicker)),
        Cell(title: "Disable to pick assets", selector: #selector(CustomMediaPicker.showDisableToPickAssetsPicker)),
        Cell(title: "Custom UI", selector: #selector(CustomMediaPicker.showCustomUIPicker)),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let notificationName = Notification.Name("SendMessageToMain")
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendMessage(_:)), name: notificationName, object: nil)
        
    }
    
    @objc func sendMessage(_ notification: NSNotification) {
        
        DispatchQueue.main.async {
            if let pickedAllAssets = notification.userInfo?["assets"] as? NSMutableArray {
                //Save image/video to server and receive URL
                //print(pickedAllAssets)
                for asset in pickedAllAssets
                {
                    let dictAsset: [String : AnyObject] = asset as! [String : AnyObject]
                    let phAsset: PHAsset = dictAsset["asset"] as! PHAsset
                    
                    if(phAsset.mediaType.rawValue == 1) //Image
                    {
                        let tempImg: UIImage = self.getImageThumbnail(asset: phAsset)
                        
                        let _: NSData = UIImageJPEGRepresentation(tempImg, 0.5)! as NSData
                        //let base64String = imageData.base64EncodedString(options: [])
                        let registorusername: String? = UserDefaults.standard.string(forKey: "registerusername")
                        
                        var request = URLRequest(url: URL(string: MediaAPI)!)
                        request.httpMethod = "POST"
                        //let postString = "cmd=image&jid=919826615203&byte="+base64String
                        //request.httpBody = postString.data(using: .utf8)
                        
                        var reqParams = [String: String]()
                        reqParams["cmd"] = "image"
                        reqParams["jid"] = registorusername
                        
                        
                        request.httpBody = self.createRequestBodyWith(parameters:reqParams as [String : NSObject], filePathKey:"uploaded", boundary:self.generateBoundaryString(), image: tempImg) as Data
                        
                        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                            if let data = data {
                                if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                                  //  print(stringData) //JSONSerialization
                                }
                            }
                        })
                        task.resume()
                    }
                    else if(phAsset.mediaType.rawValue == 2) //Video
                    {
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    func getImageThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = cells[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkIfAuthorizedToAccessPhotos { isAuthorized in
            DispatchQueue.main.async(execute: {
                if isAuthorized {
                    self.perform(self.cells[indexPath.row].selector)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Denied access to images.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: - Photos
    
    func checkIfAuthorizedToAccessPhotos(_ handler: @escaping (_ isAuthorized: Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization{ status in
                switch status {
                case .authorized:
                    handler(true)
                default:
                    handler(false)
                }
            }
            
        case .restricted:
            handler(false)
        case .denied:
            handler(false)
        case .authorized:
            handler(true)
        }
    }
    
    func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String, image: UIImage) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "uploaded"
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // MARK: - Show NohanaImagePicker
    
    @objc
    func showDefaultPicker() {
        let picker = NohanaImagePickerController.init(assetCollectionSubtypes: [PHAssetCollectionSubtype.any], mediaType: MediaType.any, enableExpandingPhotoAnimation: true)
        picker.delegate = self
        picker.toolbarHidden = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc
    func showLargeThumbnailPicker() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        picker.numberOfColumnsInPortrait = 2
        picker.numberOfColumnsInLandscape = 3
        present(picker, animated: true, completion: nil)
    }
    
    @objc
    func showNoToolbarPicker() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        picker.toolbarHidden = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc
    func showDisableToPickAssetsPicker() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        picker.canPickAsset = { (asset:Asset) -> Bool in
            return asset.identifier % 2 == 0
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc
    func showCustomUIPicker() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        picker.config.color.background = UIColor(red: 0xcc/0xff, green: 0xff/0xff, blue: 0xff/0xff, alpha: 1)
        picker.config.color.separator = UIColor(red: 0x00/0xff, green: 0x66/0xff, blue: 0x66/0xff, alpha: 1)
        picker.config.strings.albumListTitle = "🏞"
        picker.config.image.droppedSmall = UIImage(named: "btn_select_m")
        picker.config.image.pickedSmall = UIImage(named: "btn_selected_m")
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - NohanaImagePickerControllerDelegate
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        //print("🐷Canceled🙅")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts :[PHAsset]) {
        //print("🐷Completed🙆\n\tpickedAssets = \(pickedAssts)")
        
        picker.dismiss(animated: true, completion: nil)        
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, willPickPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) -> Bool {
        //print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
        return true
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didPickPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) {
        //print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, willDropPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) -> Bool {
        print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
        return true
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didDropPhotoKitAsset asset: PHAsset, pickedAssetsCount: Int) {
        print("🐷\(#function)\n\tasset = \(asset)\n\tpickedAssetsCount = \(pickedAssetsCount)")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didSelectPhotoKitAsset asset: PHAsset) {
        print("🐷\(#function)\n\tasset = \(asset)\n\t")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didSelectPhotoKitAssetList assetList: PHAssetCollection) {
        print("🐷\(#function)\n\t\tassetList = \(assetList)\n\t")
    }
    
    func nohanaImagePickerDidSelectMoment(_ picker: NohanaImagePickerController) -> Void {
        print("🐷\(#function)")
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, assetListViewController: UICollectionViewController, cell: UICollectionViewCell, indexPath: IndexPath, photoKitAsset: PHAsset) -> UICollectionViewCell {
        print("🐷\(#function)\n\tindexPath = \(indexPath)\n\tphotoKitAsset = \(photoKitAsset)")
        return cell
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, assetDetailListViewController: UICollectionViewController, cell: UICollectionViewCell, indexPath: IndexPath, photoKitAsset: PHAsset) -> UICollectionViewCell {
        print("🐷\(#function)\n\tindexPath = \(indexPath)\n\tphotoKitAsset = \(photoKitAsset)")
        return cell
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, assetDetailListViewController: UICollectionViewController, didChangeAssetDetailPage indexPath: IndexPath, photoKitAsset: PHAsset) {
        print("🐷\(#function)\n\tindexPath = \(indexPath)")
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}
