//
//  HelpViewController.swift
//  FootballFan
//
//  Created by Nitesh Gupta on 26/01/18.
//  Copyright © 2018 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
class HelpViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slider: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Take a Tour"
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
       // print(view.frame.width,view.frame.height)
       // print(scrollViewWidth,scrollViewHeight)
        //2
        // textView.textAlignment = .center
        //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
        //textView.textColor = UIColor.black
        //self.startButton.layer.cornerRadius = 10.0
        //3
        let imghome = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
               imghome.image = UIImage(named: "sliderhome")
               imghome.contentMode = .scaleAspectFill

        let imgOne = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "slide1")
        imgOne.contentMode = .scaleAspectFill

        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "slide2")
        imgTwo.contentMode = .scaleAspectFill

        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "slide3")
        imgThree.contentMode = .scaleAspectFill

       // let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
       // imgFour.image = UIImage(named: "slide4")
        /* let imgFive = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgFive.image = UIImage(named: "slide5")*/
        let imgSix = UIImageView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgSix.image = UIImage(named: "slide6")
        imgSix.contentMode = .scaleAspectFill
        let slidfandisplay = UIImageView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth, height:scrollViewHeight))
              slidfandisplay.image = UIImage(named: "slidfandisplay")
              slidfandisplay.contentMode = .scaleAspectFill

              let slidvideo = UIImageView(frame: CGRect(x:scrollViewWidth*6, y:0,width:scrollViewWidth, height:scrollViewHeight))
              slidvideo.image = UIImage(named: "slidvideo")
              slidvideo.contentMode = .scaleAspectFill

        let imgseven = UIImageView(frame: CGRect(x:scrollViewWidth*7, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgseven.image = UIImage(named: "slide10")
        imgseven.contentMode = .scaleAspectFill

        /* let imgEight = UIImageView(frame: CGRect(x:scrollViewWidth*7, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgEight.image = UIImage(named: "slide8")*/
        let imgNine = UIImageView(frame: CGRect(x:scrollViewWidth*8, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgNine.image = UIImage(named: "slide7")
        imgNine.contentMode = .scaleAspectFill

        let imgEnd = UIImageView(frame: CGRect(x:scrollViewWidth*9, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgEnd.image = UIImage(named: "slide9")
        imgEnd.contentMode = .scaleAspectFill

        /*  let imgEleven = UIImageView(frame: CGRect(x:scrollViewWidth*10, y:0,width:scrollViewWidth, height:scrollViewHeight))
         imgEleven.image = UIImage(named: "slide11")*/
        let imgTwelve = UIImageView(frame: CGRect(x:scrollViewWidth*10, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwelve.image = UIImage(named: "slide18")
        imgTwelve.contentMode = .scaleAspectFill

        let img13 = UIImageView(frame: CGRect(x:scrollViewWidth*11, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img13.image = UIImage(named: "slide13")
        img13.contentMode = .scaleAspectFill

        let imgEight = UIImageView(frame: CGRect(x:scrollViewWidth*12, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgEight.image = UIImage(named: "slide12")
        imgEight.contentMode = .scaleAspectFill

        let img16 = UIImageView(frame: CGRect(x:scrollViewWidth*13, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img16.image = UIImage(named: "slide16")
        img16.contentMode = .scaleAspectFill

        
        let img17 = UIImageView(frame: CGRect(x:scrollViewWidth*14, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img17.image = UIImage(named: "slide17")
        img17.contentMode = .scaleAspectFill

        let img14 = UIImageView(frame: CGRect(x:scrollViewWidth*15, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img14.image = UIImage(named: "slide14")
        img14.contentMode = .scaleAspectFill

        let img15 = UIImageView(frame: CGRect(x:scrollViewWidth*16, y:0,width:scrollViewWidth, height:scrollViewHeight))
        img15.image = UIImage(named: "slide15")
        img15.contentMode = .scaleAspectFill

        self.scrollView.addSubview(imghome)
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        //self.scrollView.addSubview(imgFour)
        //self.scrollView.addSubview(imgFive)
        self.scrollView.addSubview(imgSix)
         self.scrollView.addSubview(slidfandisplay)
         self.scrollView.addSubview(slidvideo)
        
        self.scrollView.addSubview(imgseven)
        //self.scrollView.addSubview(imgEight)
        self.scrollView.addSubview(imgNine)
        self.scrollView.addSubview(imgEnd)
        //self.scrollView.addSubview(imgEleven)
        self.scrollView.addSubview(imgTwelve)
        self.scrollView.addSubview(img13)
        self.scrollView.addSubview(imgEight)
        self.scrollView.addSubview(img16)
        self.scrollView.addSubview(img17)
        self.scrollView.addSubview(img14)
        self.scrollView.addSubview(img15)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 16, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        print(scrollView.contentSize)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    @IBAction func SkipHelp(_ sender: Any) {
        //SliderView.isHidden = true
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
            HelpViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return HelpViewController.realDelegate!;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        
    }
    
}
