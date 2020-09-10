//
//  AHCategoryView.swift
//  AHCategoryVC
//
//  Created by Andy Tong on 5/29/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit

//********** For NavBar
public protocol AHCategoryNavBarDelegate: class {
    func categoryNavBar(_ navBar: AHCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int)
    func categoryNavBar(_ navBar: AHCategoryNavBar, didSwitchIndexTo toIndex: Int)
}

// Default implementation
extension AHCategoryNavBarDelegate{
    func categoryNavBar(_ navBar: AHCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {}
}


//********** For ContentView
public protocol AHCategoryContainerDelegate: class {
    func categoryContainer(_ container: UIView, didSwitchIndexTo toIndex: Int)
    
    func categoryContainer(_ container: UIView, transitioningFromIndex fromIndex:Int, toIndex:Int, progress: CGFloat)
    
}


open class AHCategoryView: UIView {
    public var interControllerSpacing: CGFloat = 0.0 {
        didSet {
            self.containerView.interControllerSpacing = self.interControllerSpacing
        }
    }
    public fileprivate(set) var navBar: AHCategoryNavBar!
    
    fileprivate var categories: [AHCategoryItem]
    fileprivate var childVCs: [UIViewController]
    fileprivate weak var parentVC: UIViewController!
    fileprivate var barStyle: AHCategoryNavBarStyle
    fileprivate var containerView: AHPageContainerView!

    
    
    public init(frame: CGRect, categories: [AHCategoryItem], childVCs: [UIViewController], parentVC: UIViewController, barStyle: AHCategoryNavBarStyle) {
        self.categories = categories
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.barStyle = barStyle
        
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(item: AHCategoryItem, at index: Int) {
        navBar.setItem(item: item, for: index)
    }
    
    public func select(at index:Int) {
        // select through NavBar only
        // to prevent infinite loops by delegate calls
        navBar.select(at: index)
    }
    
    public func setBadge(atIndex index: Int, badgeNumber num: Int) {
        guard index >= 0 && index <= categories.count else {
            return
        }
        navBar.setBadge(atIndex: index, numberOfBadge: num)
    }
    
    
    
}

//MARK:- For setups
private extension AHCategoryView {
    func setup() {
        setupNavBar()
        setupContainerVC()
        
        containerView.delegate = navBar
        navBar.delegate = containerView
    }
    
    func setupNavBar() {
        var barFrame: CGRect?
        if barStyle.isEmbeddedToView {
            barFrame = CGRect(x: 0, y: 0, width: bounds.width, height: barStyle.height)
        }else{
            barFrame = CGRect.zero
        }
        
        navBar = AHCategoryNavBar(frame: barFrame!, categories: categories, barStyle: barStyle)
        addSubview(navBar)
    }
    
    func setupContainerVC() {
        let containerY: CGFloat = barStyle.isEmbeddedToView ? barStyle.height : 0.0
        let containerHeight: CGFloat = barStyle.isEmbeddedToView ? bounds.height - barStyle.height : bounds.height
        let frame = CGRect(x: 0, y: containerY, width: bounds.width, height: containerHeight)
        
        containerView = AHPageContainerView(frame: frame, childVCs: childVCs, parentVC: parentVC)
        addSubview(containerView)
        
    }
}

internal extension UIColor {
    class func random() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// return RGB components in scale of 0~255.0
    func getRGBComponents() -> (CGFloat, CGFloat, CGFloat) {
        guard let components = self.cgColor.components, components.count == 4 else {
            fatalError("Please use RGB channels for colors")
        }
        
        return (components[0], components[1], components[2])
    }
    
    /// return RGB differences between two colors
    class func getRGBDelta(first: UIColor, second: UIColor) -> (CGFloat, CGFloat, CGFloat){
        let firstComponents = first.getRGBComponents()
        let secondComponents = second.getRGBComponents()
        
        let redDelta = firstComponents.0 - secondComponents.0
        let greenDelta = firstComponents.1 - secondComponents.1
        let blueDelta = firstComponents.2 - secondComponents.2
        
        return (redDelta, greenDelta, blueDelta)
    }
    
}
