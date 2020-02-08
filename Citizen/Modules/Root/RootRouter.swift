//
//  RootRouter.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import Foundation
import UIKit
import SideMenuSwift

class RootRouter: RootWireFrame {
  
  func presentMainTabScreen(in window: UIWindow) {  
    window.makeKeyAndVisible()
    
    let contentViewController = MainMenuRouter.setupModule()
    let menuViewController = SideMenuViewController()
    menuViewController.presenter = contentViewController.presenter
    menuViewController.navigationController?.isNavigationBarHidden = true
    let menuVC = SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
    let navVC = UINavigationController(rootViewController: menuVC)
    navVC.isNavigationBarHidden = true
    SideMenuController.preferences.basic.statusBarBehavior = .none
    SideMenuController.preferences.basic.position = .above
    SideMenuController.preferences.basic.menuWidth = 250.0
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      navVC.modalTransitionStyle = .flipHorizontal
      topController.present(navVC, animated: true)
    }
  }
  
  func presentLoginScreen(in window: UIWindow, isFirstLaunch: Bool) {
    window.makeKeyAndVisible()
    let vc = SignInRouter.setupModule()
    vc.isFirstLaunch = isFirstLaunch
    let navVC = UINavigationController(rootViewController: vc)
    navVC.isNavigationBarHidden = true
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      navVC.modalTransitionStyle = .flipHorizontal
      topController.present(navVC, animated: !isFirstLaunch)
    }
  }
  
  func presentRegistrationScreen(in window: UIWindow) {
    window.makeKeyAndVisible()
//    window.rootViewController = RegistrationRouter.setupModule()
  }
}
