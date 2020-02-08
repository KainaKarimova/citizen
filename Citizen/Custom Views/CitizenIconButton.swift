//
//  CitizenIconButton.swift
//  Citizen
//
//  Created by Karina Karimova on 9/14/19.
//  Copyright © 2019 Karina Karimova. All rights reserved.
//

import UIKit

class CitizenIconButton: UIButton {
  
  // MARK:- Properties
  
  var iconImage: UIImage! {
    didSet {
      iconImageView.image = iconImage
    }
  }
  
  var iconWidth: CGFloat = 30 {
    didSet {
      iconWidthConstraint.constant = iconWidth
    }
  }
  var iconHeight: CGFloat = 30 {
    didSet {
      iconHeightConstraint.constant = iconHeight
    }
  }
  
  var mainColor = DesignUtil.citizenThemeGreen() {
    didSet {
      switch mainColor {
      case DesignUtil.citizenThemeGreen():
        separatorView.backgroundColor = .white
        title.textColor = .white
        backgroundColor = mainColor
      default:
        separatorView.backgroundColor = DesignUtil.citizenThemeGreen()
        title.textColor = DesignUtil.citizenThemeGreen()
        backgroundColor = mainColor
      }
    }
  }
  
  fileprivate var iconWidthConstraint: NSLayoutConstraint!
  fileprivate var iconHeightConstraint: NSLayoutConstraint!
  
  fileprivate lazy var iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = UIViewContentMode.scaleAspectFill
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  fileprivate lazy var separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var title: UILabel = {
    let label = UILabel()
    label.font = Fonts.playRegular?.withSize(18.0)
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK:- Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addShadow(cornerRadius: 10)
    backgroundColor = DesignUtil.citizenThemeGreen()
    configureViews()
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK:- Setup
  
  fileprivate func configureViews() {
    [iconImageView, separatorView, title].forEach {
      addSubview($0)
    }
  }
  
  fileprivate func configureConstraints() {
    
    iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: iconWidth)
    iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: iconHeight)
    
    [
      iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.0),
      iconWidthConstraint,
      iconHeightConstraint,
      
      separatorView.heightAnchor.constraint(equalToConstant: 28.0),
      separatorView.widthAnchor.constraint(equalToConstant: 1.0),
      separatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
      separatorView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 9.0),
      
      title.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 10.0),
      title.centerYAnchor.constraint(equalTo: centerYAnchor),
      title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
      title.heightAnchor.constraint(equalTo: heightAnchor)
      ].forEach { $0.isActive = true }
  }
  
  // MARK:- Actions
  
}
