//
//  LoadingScreen.swift
//  Citizen
//
//  Created by Karina Karimova on 9/17/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class LoadingScreen: UIViewController {
  
  // MARK:- Properties
  
  fileprivate lazy var logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "Logo")
    iv.contentMode = UIViewContentMode.scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var loadingView: STBouncyPreloaderLoading = {
    let sz: CGFloat = 200.0
    let x: CGFloat = (UIScreen.main.bounds.width - sz)/2.0 + 15
    let y: CGFloat = 350.0
    let rect = CGRect(x: x, y: y, width: sz, height: sz)
    let view = STBouncyPreloaderLoading(frame: rect)
    view.startLoading()
    view.alpha = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.mainBackgroundColor
    configureViews()
    configureConstraints()
    
  }
 
  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 0.5) {
      self.loadingView.alpha = 1
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      UIView.animate(withDuration: 0.5, animations: {
        self.loadingView.alpha = 0
      }, completion: { (completed) in
        self.loadingView.stopLoading()
        
        UIApplication.shared.isStatusBarHidden = false
        
        if UserProfileManager.shared.isLoggedIn {
          UserProfileManager.shared.userLoggedIn()
          RootRouter().presentMainTabScreen(in: UIApplication.shared.keyWindow!)
        } else {
          RootRouter().presentLoginScreen(in: UIApplication.shared.keyWindow!, isFirstLaunch: true)
        }
      })
    }
  }
  
  // MARK:- Setup
  
  func configureViews() {
    [logoImageView, loadingView].forEach {
      view.addSubview($0)
    }
  }
  
  func configureConstraints() {
    [
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 157.0),
      logoImageView.widthAnchor.constraint(equalToConstant: 267.4),
      logoImageView.heightAnchor.constraint(equalToConstant: 229.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}
