//
//  MerchantRangeFilterViewController.swift
//  FootballFan
//
//  Created by Apple on 15/06/19.
//  Copyright © 2019 Tridecimal. All rights reserved.
//

import Foundation
import UIKit
import RangeSeekSlider
class MerchantRangeFilterViewController: UIViewController {
     var filterType: String = "Sub Categories"
   @IBOutlet fileprivate weak var rangeSliderCurrency: RangeSeekSlider!
    var dic :NSDictionary = NSDictionary()
      var filterindex: Int = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.navigationItem.title = filterType
       //  rangeSliderCurrency.updateLayerFrames()
//rangeSliderCurrency?.mi = 0
        //rangeSliderCurrency?.upperValue = 100
        rangeSliderCurrency.delegate = self
        rangeSliderCurrency.minValue = dic.value(forKey: "MinRange") as! CGFloat//50.0
        rangeSliderCurrency.maxValue = dic.value(forKey: "MaxRange") as! CGFloat
        rangeSliderCurrency.selectedMinValue = dic.value(forKey: "MinRangeSel") as! CGFloat
        rangeSliderCurrency.selectedMaxValue = dic.value(forKey: "MaxRangeSel") as! CGFloat//140.0
        rangeSliderCurrency.minDistance = 0//dic.value(forKey: "MinRange") as! CGFloat
        rangeSliderCurrency.maxDistance = dic.value(forKey: "MaxRange") as! CGFloat
       // rangeSliderCurrency.handleColor = .black
        rangeSliderCurrency.handleDiameter = 30.0
        rangeSliderCurrency.selectedHandleDiameterMultiplier = 0
        rangeSliderCurrency.numberFormatter.numberStyle = .currency
        rangeSliderCurrency.numberFormatter.locale = Locale(identifier: "en_Uk")
        rangeSliderCurrency.numberFormatter.maximumFractionDigits = 0
        rangeSliderCurrency.minLabelFont = UIFont.systemFont(ofSize: 15.0, weight: .regular)//UIFont(name: UIFont.s, size: 15.0)!
        rangeSliderCurrency.maxLabelFont = UIFont.systemFont(ofSize: 15.0, weight: .regular)//UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
//rangeSliderCurrency.colorBetweenHandles = UIColor.init(hex: "9A9A9A")
    /*    let button1 = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(MerchantChangeFilterViewController.FiltterShow(sender:)))
        self.navigationItem.rightBarButtonItem = button1*/
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    @objc func FiltterShow(sender:UIButton)  {
        
       
        var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
        dict1["MinRangeSel"] = dic.value(forKey: "MinRange") as AnyObject
        dict1["MaxRangeSel"] = dic.value(forKey: "MaxRange") as AnyObject
        appDelegate().arrfilter[filterindex] = dict1 as AnyObject
        appDelegate().merchantfilterupdate()
        rangeSliderCurrency.delegate = self
        rangeSliderCurrency.minValue = dic.value(forKey: "MinRange") as! CGFloat//50.0
        rangeSliderCurrency.maxValue = dic.value(forKey: "MaxRange") as! CGFloat
        rangeSliderCurrency.selectedMinValue = dic.value(forKey: "MinRangeSel") as! CGFloat
        rangeSliderCurrency.selectedMaxValue = dic.value(forKey: "MaxRangeSel") as! CGFloat//140.0
        rangeSliderCurrency.minDistance = dic.value(forKey: "MinRange") as! CGFloat
        rangeSliderCurrency.maxDistance = dic.value(forKey: "MaxRange") as! CGFloat
        // rangeSliderCurrency.handleColor = .black
        rangeSliderCurrency.handleDiameter = 30.0
        rangeSliderCurrency.selectedHandleDiameterMultiplier = 0
        rangeSliderCurrency.numberFormatter.numberStyle = .currency
        rangeSliderCurrency.numberFormatter.locale = Locale(identifier: "en_Uk")
        rangeSliderCurrency.numberFormatter.maximumFractionDigits = 1
        rangeSliderCurrency.minLabelFont = UIFont(name: "System-Regular", size: 15.0)!
        rangeSliderCurrency.maxLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
    }

    static var realDelegate: AppDelegate?;
    
    func appDelegate() -> AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        let dg = DispatchGroup();
        dg.enter()
        DispatchQueue.main.async{
            MerchantRangeFilterViewController.realDelegate = UIApplication.shared.delegate as? AppDelegate;
            dg.leave();
        }
        dg.wait();
        return MerchantRangeFilterViewController.realDelegate!;
    }
}
// MARK: - RangeSeekSliderDelegate

extension MerchantRangeFilterViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
       /* if slider === rangeSlider {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        } else if slider === rangeSliderCurrency {
            print("Currency slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        } else if slider === rangeSliderCustom {
            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        }*/
         print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        var dict1: [String : AnyObject] = appDelegate().arrfilter[filterindex] as! [String : AnyObject]
        dict1["MinRangeSel"] = Int(round(minValue)) as AnyObject
         dict1["MaxRangeSel"] = Int(round(maxValue)) as AnyObject
        appDelegate().arrfilter[filterindex] = dict1 as AnyObject
        appDelegate().merchantfilterupdate()
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
