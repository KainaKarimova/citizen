//
//  NoNetworkView.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

protocol NoNetworkViewDelegate: class {
  func didTapRefresh(noNetworkView: NoNetworkView)
}

class NoNetworkView: UIView {
  
  // MARK:- Properties
  
  weak var delegate: NoNetworkViewDelegate?
  
  fileprivate lazy var backgroundImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.image = #imageLiteral(resourceName: "Philosoraptor")
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var leftView: UIView = {
    let view = UIView()
    let y = backgroundImageView.frame.maxY - 10
    view.backgroundColor = UIColor(red: 0.313725, green: 0.576471, blue: 0.364706, alpha: 1.0)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var rightView: UIView = {
    let view = UIView()
    let x = backgroundImageView.frame.maxX - 10
    let y:CGFloat = 10.0
    view.backgroundColor = UIColor(red: 0.478431, green: 0.588235, blue: 0.498039, alpha: 1.0)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  fileprivate lazy var noNetworkLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = Constants.Misc.networkError
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var refreshButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(Constants.Misc.refresh, for: .normal)
    button.addShadow()
    button.backgroundColor = DesignUtil.citizenThemeGreen()
    button.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK:- Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initViews()
  }
  
  // MARK:- Setup
  
  private func initViews() {
    self.backgroundColor = UIColor.white
    configureViews()
    configureConstraints()
  }
  
  fileprivate func configureViews() {
    
    [backgroundImageView, leftView, rightView].forEach {
      addSubview($0)
    }
    
    [noNetworkLabel, refreshButton].forEach {
      addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    let constraints = [
      
      backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
      
      leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
      leftView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
      leftView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -2.0),
      leftView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
      rightView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
      rightView.trailingAnchor.constraint(equalTo: trailingAnchor),
      rightView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      refreshButton.widthAnchor.constraint(equalToConstant: 250.0),
      refreshButton.heightAnchor.constraint(equalToConstant: 50.0),
      refreshButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      refreshButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 80.0),
      
      noNetworkLabel.centerXAnchor.constraint(lessThanOrEqualTo: centerXAnchor),
      noNetworkLabel.bottomAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -8.0),
      noNetworkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.0),
      noNetworkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  // MARK:- Actions
  
  @objc private func didTapRefresh() {
    delegate?.didTapRefresh(noNetworkView: self)
  }
  
}
