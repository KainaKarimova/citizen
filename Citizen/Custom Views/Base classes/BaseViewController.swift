//
//  BaseViewController.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {
  
  // MARK:- Properties
  
  
  var hasData: Bool = false
  var scrollEnabled = true {
    didSet {
      scrollView.isScrollEnabled = scrollEnabled
    }
  }
  
  lazy var noNetworkView: NoNetworkView = {
    let view = NoNetworkView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  var emptyView: EmptyView = {
    let view = EmptyView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var scrollView: UIScrollView = {
    let scView = UIScrollView()
    scView.backgroundColor = .clear
    scView.translatesAutoresizingMaskIntoConstraints = false
    return scView
  }()
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.mainBackgroundColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var statusBarView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20.0))
    view.backgroundColor = DesignUtil.citizenThemeGreen()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var header: CitizenHeader = {
    let view = CitizenHeader()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureScrollView()
    configureHeader()
    configureEmptyViews()
    registerForKeyboardNotifications()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }
  
  // MARK:- Setup
  
  func configureEmptyViews() {
    view.addSubview(noNetworkView)
    view.addSubview(emptyView)
    emptyView.isHidden = true
    noNetworkView.isHidden = true
    
    let constraints = [
      noNetworkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      noNetworkView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
      noNetworkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      noNetworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      emptyView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
      emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
    
    if !ReachabilityManager.shared.isReachable() {
      showNoNetworkView()
    }
  }
  
  func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    [
      scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
      ].forEach { $0.isActive = true }
  }
  
  
  func configureHeader() {
    view.addSubview(statusBarView)
    contentView.addSubview(header)
    [
      header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      header.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
      header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      header.heightAnchor.constraint(equalToConstant: 80.0),
      ].forEach { $0.isActive = true }
  }
  // MARK:- Actions
  
  func showNoNetworkView() {
    // don't show no network view if data has already been received
    if hasData == true {
      return
    }
    ReachabilityManager.shared.addListener(listener: self as? NetworkStatusListener)
    self.noNetworkView.isHidden = false
    self.noNetworkView.delegate = self as? NoNetworkViewDelegate
    
    view.bringSubview(toFront: self.noNetworkView)
  }
  
  func hideNoNetworkView() {
    hasData = true
    if self is NetworkStatusListener {
      ReachabilityManager.shared.removeListener(listener: self as! NetworkStatusListener)
    }
    self.noNetworkView.isHidden = true
  }
  
  func showEmptyView() {
    self.emptyView.isHidden = false
    view.bringSubview(toFront: self.emptyView)
  }
  
  func hideEmptyView() {
    self.emptyView.isHidden = true
  }
  
  func setEmptyViewMessage(_ message: String) {
    emptyView.emptyLabel.text = message
  }
  
  func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notif:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillBeShown(notif: Notification) {
    let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 265.0, 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    scrollView.isScrollEnabled = true
  }
  
  @objc func keyboardWillHide() {
    let zeroInsets = UIEdgeInsets.zero
    scrollView.contentInset = zeroInsets
    scrollView.scrollIndicatorInsets = zeroInsets
    scrollView.isScrollEnabled = scrollEnabled
  }
  
}

extension BaseViewController: NoNetworkViewDelegate {
  func didTapRefresh(noNetworkView: NoNetworkView) {
    if ReachabilityManager.shared.isReachable() {
      hideNoNetworkView()
    }
  }
}
