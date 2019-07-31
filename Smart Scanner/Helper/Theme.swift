//
//  Theme.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 29/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

struct Theme {
    
    enum Scheme {
        case Light, Dark
    }
    
    static var currentScheme: Scheme = .Light
    
    static var backgroundColor:UIColor?
    static var buttonTextColor:UIColor?
    static var buttonBackgroundColor:UIColor?
    static var labelTextColor: UIColor?
    
    static public func defaultTheme() {
        self.backgroundColor = UIColor.white
        self.buttonTextColor = UIColor.blue
        self.buttonBackgroundColor = UIColor.white
        self.labelTextColor = UIColor.black
        self.currentScheme = .Light
        updateDisplay()
    }
    
    static public func darkTheme() {
        self.backgroundColor = UIColor.black
        self.buttonTextColor = UIColor.orange
        self.buttonBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.labelTextColor = UIColor.white
        self.currentScheme = .Dark
        updateDisplay()
    }
    
    static public func toggleTheme() {
        if self.backgroundColor == .white {
            darkTheme()
        }
        else {
            defaultTheme()
        }
    }
    
    static public func updateDisplay() {
//        let proxyButton = UIButton.appearance()
//        proxyButton.setTitleColor(Theme.buttonTextColor, for: .normal)
//        proxyButton.backgroundColor = Theme.buttonBackgroundColor
////
//        let proxyView = UIView.appearance()
//        proxyView.backgroundColor = backgroundColor
//
//        let proxyNavBar = UINavigationBar.appearance()
//        proxyNavBar.barTintColor = Theme.backgroundColor
    }
}
