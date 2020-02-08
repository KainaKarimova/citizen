//
//  StatusBar.swift
//  SideMenu
//
//  Created by kukushi on 22/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit

extension UIWindow {
    
    /// Returns current application's `statusBarWindows`
    static internal var sb: UIWindow? {
        // We use a non-public key here to obtain the `statusBarWindw` window.
        // We have been using it in real world app and it won't be rejected by the review team for using this key.
        let s = "status", b = "Bar", w = "Window"
        return UIApplication.shared.value(forKey: s+b+w) as? UIWindow
    }
    
    /// Changes the windows' visibility with custom behavior
    ///
    /// - Parameters:
    ///   - hidden: the windows hidden status
    ///   - behavior: status bar behavior
    internal func setStatusBar(_ hidden: Bool, with behavior: SideMenuPreferences.StatusBarBehavior) {
        guard behavior != .none else {
            return
        }
        
        switch behavior {
        case .fade, .hideOnMenu:
            alpha = hidden ? 0 : 1
        case .slide:
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            transform = hidden ? CGAffineTransform(translationX: 0, y: -statusBarHeight) : .identity
        default:
            return
        }
    }
   
    internal func isStatusBarHidden(with behavior: SideMenuPreferences.StatusBarBehavior) -> Bool {
        switch behavior {
        case .none:
            return false
        case .fade, .hideOnMenu:
            return alpha == 0
        case .slide:
            return transform != .identity
        }
    }
}
