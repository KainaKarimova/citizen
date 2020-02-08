//
//  MainMenuHeader.swift
//  Citizen
//
//  Created by Karina Karimova on 9/15/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

protocol CitizenHeaderDelegate: class {
  func didTapLeftButton()
}

class CitizenHeader: BaseView {

  // MARK:- Properties
  
  weak var delegate: CitizenHeaderDelegate?
  
  var title: String! {
    didSet {
      titleLabel.text = title
    }
  }
  
  var leftButtonImage: UIImage! {
    didSet {
      leftButton.setBackgroundImage(leftButtonImage, for: .normal)
    }
  }
  
  fileprivate lazy var leftButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  fileprivate lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.playBold?.withSize(28.0)
    label.numberOfLines = 1
    label.contentMode = .center
    label.textColor = DesignUtil.citizenThemeGreen()
    label.addShadow()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  fileprivate lazy var logoIcon: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "logo_mini")
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  // MARK:- Setup
  
  override func setupView() {
    super.setupView()
    backgroundColor = .white
    configureViews()
    configureConstraints()
  }
  
  fileprivate func configureViews() {
    [leftButton, titleLabel, logoIcon].forEach {
      addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    [
      leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
      leftButton.widthAnchor.constraint(equalToConstant: 34.0),
      leftButton.heightAnchor.constraint(equalToConstant: 34.0),
      
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      logoIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
      logoIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
      logoIcon.widthAnchor.constraint(equalToConstant: 53.0),
      logoIcon.heightAnchor.constraint(equalToConstant: 43.0)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
  @objc func didTapLeftButton() {
    delegate?.didTapLeftButton()
  }
  
}
